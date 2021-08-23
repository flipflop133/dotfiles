import requests
from pathlib import Path
from subprocess import run, DEVNULL


class Wallpaper:
    home = str(Path.home())
    theme = "light"
    urls = {
        "light": "https://source.unsplash.com/1920x1080/?nature",
        "dark": "https://source.unsplash.com/1920x1080/?night"
    }

    def updateWallpaper(self, theme):
        try:
            response = requests.get(self.urls[theme], stream=True)
            if response.ok:
                with open("wallpaper.jpg", 'wb') as handle:
                    for block in response.iter_content(1024):
                        if not block:
                            break
                        handle.write(block)
                    run([
                        "swaymsg",
                        "output * bg wallpaper.jpg fill".format(theme)
                    ],
                        stdout=DEVNULL)
                    return True
        except:
            pass
        return False
