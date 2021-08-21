import requests
from pathlib import Path


class Wallpaper:
    home = str(Path.home())
    theme = "light"
    urls = {
        "light": "https://source.unsplash.com/1920x1080/?nature,animal",
        "dark": "https://source.unsplash.com/1920x1080/?night"
    }

    def updateWallpaper(self, theme):
        try:
            with open(
                    self.home + "/Images/wallpaper/" + theme +
                    "/wallpaper.jpg", 'wb') as handle:
                response = requests.get(self.urls[theme], stream=True)
                if not response.ok:
                    print(response)
                for block in response.iter_content(1024):
                    if not block:
                        break
                    handle.write(block)
        except:
            pass
