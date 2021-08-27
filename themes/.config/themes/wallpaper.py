import requests
from pathlib import Path
from subprocess import run, DEVNULL
from random import sample


class Wallpaper:
    home = str(Path.home())
    theme = "light"
    categories = ["nature", "animal", "city", "technology", "travel"]
    urls = {
        "light":
        "https://source.unsplash.com/1920x1080/?{}".format(
            sample(categories, 1)),
        "dark":
        "https://source.unsplash.com/1920x1080/?night"
    }

    def updateWallpaper(self, theme):
        try:
            response = requests.get(self.urls[theme], stream=True)
            if response.ok:
                with open("{}/.config/themes/wallpaper.jpg".format(self.home),
                          'wb') as handle:
                    for block in response.iter_content(1024):
                        if not block:
                            break
                        handle.write(block)
                    run([
                        "swaymsg",
                        "output * bg {}/.config/themes/wallpaper.jpg fill".
                        format(self.home)
                    ],
                        check=True,
                        stdout=DEVNULL)
                    return True
        except:
            pass
        return False