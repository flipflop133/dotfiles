# Automatically change the system theme in function of the sunrise and sunset.
from wallpaper import Wallpaper
from threading import Timer
from time import sleep
import datetime
from sunsetSunrise import get_sunset_sunrise
from subprocess import run
from pathlib import Path
home = str(Path.home())

autoWallpaper = False


class Theme:
    last_checked = -1
    checked_theme = False
    sunrise = 600
    sunset = 1800
    current_theme = ''
    wallpaper = Wallpaper()
    wallpaper_changed = False
    current_time = -1
    seconds_now = -1

    def __init__(self):
        self.update()

    def launch_timer(self):
        Timer(self.determine_sleep_time(self.current_time, self.seconds_now),
              self.update).start()

    def update(self):
        try:
            # set wallpaper
            if not autoWallpaper:
                self.wallpaper.setWallpaper()

            # check current theme
            if not self.checked_theme:
                self.current_theme = str(
                    run([
                        "gsettings", "get", "org.gnome.desktop.interface",
                        "gtk-theme"
                    ],
                        capture_output=True,
                        encoding='utf-8').stdout)
                self.checked_theme = True

            # check if sunrise and sunset are still valid
            if self.last_checked != datetime.date.today():
                data = get_sunset_sunrise()
                self.sunrise = int(data[0])
                self.sunset = int(data[1])
                self.last_checked = datetime.date.today()
            # retrieve current time
            self.current_time = int(
                datetime.datetime.now().strftime("%H:%M").replace(':', ''))
            self.seconds_now = (int((str(self.current_time)[-2:])) * 60) + (int(
                (str(self.current_time)[:-2])) * 3600)
            # check which theme to apply
            if (self.current_time < self.sunrise) or (self.current_time
                                                      > self.sunset):
                # change theme
                if ("light" in self.current_theme):
                    run([
                        home + "/.config/themes/themer.sh",
                        "light",
                        "dark",
                    ])
                    self.checked_theme = False
                    if autoWallpaper:
                        self.wallpaper_changed = self.wallpaper.updateWallpaper(
                            "dark")
                # change wallpaper
                if (autoWallpaper and not self.wallpaper_changed):
                    self.wallpaper_changed = self.wallpaper.updateWallpaper(
                        "dark")
            elif (self.current_time > self.sunrise) and (self.current_time
                                                         < self.sunset):
                # change theme
                if ("dark" in self.current_theme):
                    run([home + "/.config/themes/themer.sh", "dark", "light"])
                    self.checked_theme = False
                    if autoWallpaper:
                        self.wallpaper_changed = self.wallpaper.updateWallpaper(
                            "light")
                # change wallpaper
                if (autoWallpaper and not self.wallpaper_changed):
                    self.wallpaper_changed = self.wallpaper.updateWallpaper(
                        "light")
            self.launch_timer()
        except:
            sleep(5)
            self.update()

    def determine_sleep_time(self, current_time, seconds_now):
        '''Determine how much time the script should sleep before changing
           theme again.
        '''
        sleep_time = 5
        # night time
        if (current_time < self.sunrise) or (current_time > self.sunset):
            tmp = (int((str(self.sunrise)[-2:])) * 60) + (int(
                (str(self.sunrise)[:-2])) * 3600)
            if (current_time > self.sunset):
                sleep_time = tmp + ((24 * 3600) - seconds_now)
            elif (current_time < self.sunrise):
                # if current time is less than sunrise, the script must sleep
                # until sunrise.
                sleep_time = tmp - seconds_now
        # day time
        elif (current_time > self.sunrise) and (current_time < self.sunset):
            # the script must sleep till sunset
            tmp = (int((str(self.sunset)[-2:])) * 60) + (int(
                (str(self.sunset)[:2])) * 3600)
            sleep_time = tmp - seconds_now
        print(sleep_time)
        return sleep_time


Theme()
