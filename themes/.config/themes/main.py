# Automatically change the system theme in function of the sunrise and sunset.
from subprocess import run
from pathlib import Path
home = str(Path.home())
from sunsetSunrise import get_sunset_sunrise
import datetime
from time import sleep
from threading import Timer
from wallpaper import Wallpaper

autoWallpaper = False

class Theme:
    lastChecked = -1
    checkedTheme = False
    sunrise = 600
    sunset = 1800
    theme = ''
    wallpaper = Wallpaper()
    wallpaperChanged = False
    currentTime = -1
    secondsNow = -1

    def __init__(self):
        self.update()

    def launchTimer(self):
        Timer(self.determineSleepTime(self.currentTime, self.secondsNow),
              self.update).start()

    def update(self):
        try:
            # set wallpaper
            if not autoWallpaper:
                self.wallpaper.setWallpaper()

            # check current theme
            if not self.checkedTheme:
                self.theme = str(
                    run([
                        "gsettings", "get", "org.gnome.desktop.interface",
                        "gtk-theme"
                    ],
                        capture_output=True,
                        encoding='utf-8').stdout)
                self.checkedTheme = True

            # check if sunrise and sunset are still valid
            if self.lastChecked != datetime.date.today():
                data = get_sunset_sunrise()
                self.sunrise = int(data[0])
                self.sunset = int(data[1])
                self.lastChecked = datetime.date.today()
            # retrieve current time
            self.currentTime = int(
                datetime.datetime.now().strftime("%H:%M").replace(':', ''))
            self.secondsNow = (int((str(self.currentTime)[-2:])) * 60) + (int(
                (str(self.currentTime)[:-2])) * 3600)
            # check which theme to apply
            if (self.currentTime < self.sunrise) or (self.currentTime >
                                                     self.sunset):
                # change theme
                if ("light" in self.theme):
                    run([
                        home + "/.config/themes/themer.sh",
                        "light",
                        "dark",
                    ])
                    self.checkedTheme = False
                    if autoWallpaper:
                        self.wallpaperChanged = self.wallpaper.updateWallpaper(
                        "dark")
                # change wallpaper
                if (autoWallpaper and not self.wallpaperChanged):
                    self.wallpaperChanged = self.wallpaper.updateWallpaper(
                        "dark")
            elif (self.currentTime > self.sunrise) and (self.currentTime <
                                                        self.sunset):
                # change theme
                if ("dark" in self.theme):
                    run([home + "/.config/themes/themer.sh", "dark", "light"])
                    self.checkedTheme = False
                    if autoWallpaper:
                        self.wallpaperChanged = self.wallpaper.updateWallpaper(
                        "light")
                # change wallpaper
                if (autoWallpaper and not self.wallpaperChanged):
                    self.wallpaperChanged = self.wallpaper.updateWallpaper(
                        "light")
            self.launchTimer()
        except:
            sleep(5)
            self.update()

    def determineSleepTime(self, currentTime, secondsNow):
        '''Determine how much time the script should sleep before changing theme again.
        '''
        sleepTime = 5
        # night time
        if (currentTime < self.sunrise) or (currentTime > self.sunset):
            tmp = (int((str(self.sunrise)[-2:])) * 60) + (int(
                (str(self.sunrise)[:-2])) * 3600)
            if (currentTime > self.sunset):
                sleepTime = tmp + ((24 * 3600) - secondsNow)
            elif (currentTime < self.sunrise):
                # if current time is less than sunrise, the script must sleep until sunrise.
                sleepTime = tmp - secondsNow
        # day time
        elif (currentTime > self.sunrise) and (currentTime < self.sunset):
            # the script must sleep till sunset
            tmp = (int((str(self.sunset)[-2:])) * 60) + (int(
                (str(self.sunset)[:2])) * 3600)
            sleepTime = tmp - secondsNow
        return sleepTime


Theme()
