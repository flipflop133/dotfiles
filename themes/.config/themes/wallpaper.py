import requests
from pathlib import Path
from subprocess import run, DEVNULL
from random import sample


class Wallpaper:
    home = str(Path.home())
    theme = "light"
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

    def updateWallpaper(self, theme):
        try:
            response = requests.get(self.urls[theme], stream=True)
            if response.ok:
                with open("{}/.config/themes/wallpaper_image.jpg".format(self.home),
                          'wb') as handle:
                    for block in response.iter_content(1024):
                        if not block:
                            break
                        handle.write(block)
                    run([
                        "swaymsg",
                        "output * bg {}/.config/themes/wallpaper_image.jpg fill".
                        format(self.home)
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
            "output * bg {}/.config/themes/wallpaper_image.* fill".
            format(self.home)
        ],
            check=True,
            stdout=DEVNULL)
Wallpaper().setWallpaper()