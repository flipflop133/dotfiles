import requests
from pathlib import Path
from subprocess import run, DEVNULL
from random import sample
from sys import argv

class Wallpaper:
    home = str(Path.home())
    categoriesLight = [
        "nature", "animal", "city", "technology", "travel", "wallpapers"
    ]
    categoriesDark = [
        "night", "black+background", "dark", "stars", "black", "neon",
        "darkness"
    ]
    urls = {
        "light":
        "https://source.unsplash.com/featured/1920x1080/?{}".format(
            sample(categoriesLight, 1)),
        "dark":
        "https://source.unsplash.com/featured/1920x1080/?{}".format(
            sample(categoriesDark, 1))
    }

    def __init__(self):
        if argv[1] == "auto":
            self.updateWallpaper()
        elif argv[1] == "manual":
            self.setWallpaper()

    def updateWallpaper(self):
        try:
            theme = str(
                run([
                    "/bin/gsettings", "get", "org.gnome.desktop.interface",
                    "gtk-theme"
                ],
                    capture_output=True,
                    encoding='utf-8').stdout)
            if "dark" in theme:
                theme = "dark"
            else:
                theme = "light"
            response = requests.get(self.urls[theme], stream=True)
            if response.ok:
                with open(
                        "{}/.config/themes/wallpaper_image.jpg".format(
                            self.home), 'wb') as handle:
                    for block in response.iter_content(1024):
                        if not block:
                            break
                        handle.write(block)
                    run([
                        "swaymsg",
                        "output * bg {}/.config/themes/wallpaper_image.jpg fill"
                        .format(self.home)
                    ],
                        check=True,
                        stdout=DEVNULL)
                    return True
        except:
            pass
        return False

    def setWallpaper(self):
        run([
            "swaymsg",
            "output * bg {}/.config/themes/wallpaper_image.* fill".format(
                self.home)
        ],
            check=True,
            stdout=DEVNULL)


Wallpaper()