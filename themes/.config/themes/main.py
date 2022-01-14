"""Change system theme depending on current time.
Thanks to D-Feet utility for its convenience when dealing with dbus.
"""
import json
import multiprocessing
import os
from datetime import date, datetime, timedelta
from pathlib import Path
from sched import scheduler as sched_scheduler
from subprocess import run
from sys import exit
from time import mktime, time

import dbus
import pytz
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
from suntime import Sun
from tendo import singleton

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
    loop = None
    next_run_thread = None

    def __init__(self):
        """Initialize the theme script."""
        singleton.SingleInstance(
        )  # ensure that there is only one instance of the script
        self.update()
        self.setup_scheduler()

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
        scheduler.enterabs(next_run_date, 0, self.setup_new_update)
        # Run the scheduler on another thread so we can run the DBusGMainLoop on the main thread
        # to receive the suspend signal.
        self.next_run_thread = multiprocessing.Process(target=scheduler.run)
        self.next_run_thread.start()

    def setup_new_update(self):
        self.update()
        self.launch_scheduler()

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
        login1.connect_to_signal('SessionRemoved', self.session_signal_handler,
                                 None)

    def session_signal_handler(self):
        """Stop the whole script when user disconnect from the session."""
        self.next_run_thread.terminate()
        self.loop.quit()
        exit(0)

    def signal_handler(self, before):
        """Terminate the next run thread and schedule a new one to correct the time
        offset created during system suspend.
        """
        if before == 0:  # If before is 0, then the signal was sent after suspend.
            # Adjust the next run time that was paused during suspend.
            self.next_run_thread.terminate()
            self.update()
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
        if (((self.current_time < self.sunrise) or
             (self.current_time > self.sunset))
                and ("light" in self.current_theme)):
            # change theme
            self.theme_applications("dark")
            self.checked_theme = False
        elif (self.current_time > self.sunrise) and (
                self.current_time < self.sunset) and ("dark"
                                                      in self.current_theme):
            # change theme
            self.theme_applications("light")
            self.checked_theme = False
        self.checked_theme = False

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

    def theme_applications(self, new_theme):
        previous_theme = 'dark' if new_theme != 'dark' else 'light'
        file = open(
            f"{os.path.dirname(os.path.realpath(__file__))}/config.json", "r")
        data = json.loads(file.read())
        file.close()
        for application in data.keys():
            # Replace theme name in application config file
            for previous_value, new_value in zip(
                    data[application][previous_theme],
                    data[application][new_theme]):
                run([
                    "sed", "-i", f"s|{previous_value}|{new_value}|g",
                    f"{HOME}{data[application]['path']}"
                ])

            # Run optional commands
            if 'commands' in data[application]:
                for command in data[application]['commands']:
                    run(command.split())


Theme()
