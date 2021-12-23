"""Change system theme depending on current time.
Thanks to D-Feet utility for its convenience when dealing with dbus.
"""
from datetime import date, datetime, timedelta
from pathlib import Path
from sched import scheduler as sched_scheduler
from subprocess import run
from time import mktime, process_time, sleep, thread_time, time

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
import pytz
from suntime import Sun
import multiprocessing

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
    loop = 0
    next_run_thread = 0

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

    def setup_scheduler(self):
        """Setup the theme scheduler."""
        self.handle_system_suspension()
        self.launch_scheduler()
        self.loop.run()

    def launch_scheduler(self):
        """Launch the scheduler for the next theme update."""
        scheduler = sched_scheduler(time)
        next_run_date = self.determine_next_time()
        next_run_date = mktime(next_run_date.timetuple())
        scheduler.enterabs(next_run_date, 0, self.update)
        # Run the scheduler on another thread so we can run the DBusGMainLoop on the main thread
        # to receive the suspend signal.
        self.next_run_thread = multiprocessing.Process(target=scheduler.run)
        self.next_run_thread.start()

    def handle_system_suspension(self):
        """Handle system suspension.
        Setup a signal handler that will gets triggered when system resume
        after suspend.
        """
        DBusGMainLoop(set_as_default=True)
        self.loop = GLib.MainLoop()
        bus = dbus.SystemBus()
        proxy = bus.get_object('org.freedesktop.login1',
                               '/org/freedesktop/login1')
        login1 = dbus.Interface(proxy, 'org.freedesktop.login1.Manager')
        for signal in ['PrepareForSleep', 'PrepareForShutdown']:
            login1.connect_to_signal(signal, self.signal_handler, None)
        login1.connect_to_signal('SessionRemoved', self.session_signal_handler, None)

    def session_signal_handler(self):
        """Stop the whole script when user disconnect from the session."""
        self.next_run_thread.terminate()
        self.loop.quit()
        sys.exit(0)

    def signal_handler(self, before):
        """Terminate the next run thread and schedule a new one to correct the time
        offset created during system suspend.
        """
        if before == 0:  # If before is 0, then the signal was sent after suspend.
            # Adjust the next run time that was paused during suspend.
            self.next_run_thread.terminate()
            self.launch_scheduler()

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
        self.current_time = datetime.now(pytz.utc)
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
        self.setup_scheduler()

    def determine_next_time(self):
        """Determine how much time the script should sleep\
             before changing theme again."""
        next_time = -1
        # night time
        if (self.current_time < self.sunrise) or (self.current_time >
                                                  self.sunset):
            if self.current_time > self.sunset:
                # Next run is planned to next day so we add one day
                next_time = self.sunrise + timedelta(days=1)
            elif self.current_time < self.sunrise:
                next_time = self.sunrise
        # day time
        elif self.sunset > self.current_time > self.sunrise:
            next_time = self.sunset
        return next_time


Theme()
