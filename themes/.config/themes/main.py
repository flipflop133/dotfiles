# Automatically change the system theme in function of the sunrise and sunset.
from subprocess import run
from pathlib import Path
home = str(Path.home())
from sunsetSunrise import get_sunset_sunrise
import datetime
from time import sleep
from wallpaper import Wallpaper


def determineSleepTime(currentTime, secondsNow, sunrise, sunset):
    '''Determine how much time the script should sleep before changing theme again.
    '''
    sleepTime = 5
    # night time
    if (currentTime < sunrise) or (currentTime > sunset):
        tmp = (int((str(sunrise)[-2:])) * 60) + (int(
            (str(sunrise)[:-2])) * 3600)
        if (currentTime > sunset):
            sleepTime = tmp + ((24 * 3600) - secondsNow)
        elif (currentTime < sunrise):
            # if current time is less than sunrise, the script must sleep until sunrise.
            sleepTime = tmp - secondsNow
    # day time
    elif (currentTime > sunrise) and (currentTime < sunset):
        # the script must sleep till sunset
        tmp = (int((str(sunset)[-2:])) * 60) + (int((str(sunset)[:2])) * 3600)
        sleepTime = tmp - secondsNow
    return sleepTime


def main():
    lastChecked = -1
    checkedTheme = False
    sunrise = 600
    sunset = 1800
    theme = ''
    wallpaper = Wallpaper()
    wallpaperChanged = False
    while True:
        try:
            # check current theme
            if not checkedTheme:
                theme = str(
                    run([
                        "gsettings", "get", "org.gnome.desktop.interface",
                        "gtk-theme"
                    ],
                        capture_output=True,
                        encoding='utf-8').stdout)
                checkedTheme = True

            # check if sunrise and sunset are still valid
            if lastChecked != datetime.date.today():
                data = get_sunset_sunrise()
                sunrise = int(data[0])
                sunset = int(data[1])
                lastChecked = datetime.date.today()
            # retrieve current time
            currentTime = int(
                datetime.datetime.now().strftime("%H:%M").replace(':', ''))
            secondsNow = (int((str(currentTime)[-2:])) * 60) + (int(
                (str(currentTime)[:-2])) * 3600)
            # check which theme to apply
            if (currentTime < sunrise) or (currentTime > sunset):
                # change theme
                if ("light" in theme):
                    run([
                        home + "/.config/themes/themer.sh",
                        "light",
                        "dark",
                    ])
                    checkedTheme = False
                    wallpaperChanged = wallpaper.updateWallpaper("dark")
                # change wallpaper
                if (not wallpaperChanged):
                    wallpaperChanged = wallpaper.updateWallpaper("dark")
            elif (currentTime > sunrise) and (currentTime < sunset):
                # change theme
                if ("dark" in theme):
                    run([home + "/.config/themes/themer.sh", "dark", "light"])
                    checkedTheme = False
                    wallpaperChanged = wallpaper.updateWallpaper("light")
                # change wallpaper
                if (not wallpaperChanged):
                    wallpaperChanged = wallpaper.updateWallpaper("light")
            sleep(5 if not wallpaperChanged else determineSleepTime(
                currentTime, secondsNow, sunrise, sunset))
        except:
            sleep(5)


main()
