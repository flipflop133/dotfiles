# Automatically change the system theme in function of the sunrise and sunset.
from subprocess import run
from pathlib import Path
home = str(Path.home())
from sunset_sunrise import get_sunset_sunrise
import datetime
from time import sleep


def main():
    lastChecked = -1
    checkedTheme = False
    sunrise = 600
    sunset = 1800
    theme = ''
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

            # check which theme to apply
            if ((currentTime < sunrise) or
                (currentTime > sunset)) and ("light" in theme):
                run([
                    home + "/.config/themes/themer.sh",
                    "light",
                    "dark",
                ])
                checkedTheme = False
            elif ((currentTime > sunrise) and
                  (currentTime < sunset)) and ("dark" in theme):
                run([home + "/.config/themes/themer.sh", "dark", "light"])
                checkedTheme = False
            sleep(5)
        except:
            pass


main()
