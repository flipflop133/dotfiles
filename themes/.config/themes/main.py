"""Change system theme depending on current time."""
from datetime import date, datetime
from pathlib import Path
from sched import scheduler as sched_scheduler
from subprocess import run
from time import mktime, time

from pytz import UTC
from suntime import Sun

HOME = str(Path.home())


class Theme:
    """Theme class to manage the system theme."""

    last_checked = -1
    checked_theme = False
    sunrise = 600
    sunset = 1800
    current_theme = ''
    current_time = -1
    seconds_now = -1

    def __init__(self):
        """Initialize the theme script."""
        self.update()

    def retrieve_sunset_sunrise(self):
        """Retrieve the current sunrise and sunset times\
             for the current location."""
        latitude = 49
        longitude = 5
        sun = Sun(latitude, longitude)
        time_zone = datetime.now()
        self.sunrise = sun.get_local_sunrise_time(time_zone)
        self.sunset = sun.get_local_sunset_time(time_zone)

    def launch_scheduler(self):
        """Launch the scheduler for the next theme update."""
        scheduler = sched_scheduler(time)
        next_run_date = self.determine_next_time()
        next_run_date = mktime(next_run_date.timetuple())
        scheduler.enterabs(next_run_date, 0, self.update)
        scheduler.run()

    def update(self):
        """Update the system theme."""
        # check current theme
        if not self.checked_theme:
            self.current_theme = str(
                run([
                    "/bin/gsettings", "get", "org.gnome.desktop.interface",
                    "gtk-theme"
                ],
                    capture_output=True,
                    encoding='utf-8').stdout)
            self.checked_theme = True

        # check if sunrise and sunset are still valid
        if self.last_checked != date.today():
            self.retrieve_sunset_sunrise()
            self.last_checked = date.today()
        # retrieve current time
        utc = UTC
        self.current_time = utc.localize(dt=datetime.now())
        # check which theme to apply
        if (self.current_time < self.sunrise) or (self.current_time >
                                                  self.sunset):
            # change theme
            if "light" in self.current_theme:
                run([
                    HOME + "/.config/themes/themer.sh",
                    "light",
                    "dark",
                ])
                self.checked_theme = False
        elif (self.current_time > self.sunrise) and (self.current_time <
                                                     self.sunset):
            # change theme
            if "dark" in self.current_theme:
                run([HOME + "/.config/themes/themer.sh", "dark", "light"])
                self.checked_theme = False
        self.launch_scheduler()

    def determine_next_time(self):
        """Determine how much time the script should sleep\
             before changing theme again."""
        next_time = -1
        # night time
        if (self.current_time < self.sunrise) or (self.current_time >
                                                  self.sunset):
            if self.current_time > self.sunset:
                next_time = self.sunset
            elif self.current_time < self.sunrise:
                next_time = self.sunrise
        # day time
        elif self.sunset > self.current_time > self.sunrise:
            next_time = self.sunset
        return next_time


Theme()
