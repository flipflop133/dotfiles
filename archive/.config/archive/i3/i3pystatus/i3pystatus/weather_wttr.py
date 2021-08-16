from i3pystatus import IntervalModule
import subprocess
import os


class custom_weather(IntervalModule):

    color = "#ffffff"
    on_leftclick = "irm"
    settings = ("format", ("interval", "update interval"), "color")
    interval = 700

    def getWeather(self):
        process = subprocess.run(
            ['curl', 'wttr.in/Saint-Léger,Belgium?format=1'],
            stdout=subprocess.PIPE,
            universal_newlines=True)
        output_list = (process.stdout).splitlines()
        if output_list == []:  # displays no internet and refresh every second
            cdict = {
                'weather': "no internet connexion",
            }
            return cdict
        else:
            cdict = {
                'weather': output_list[0],
            }
            return cdict

    def irm(self):
        os.popen("chromium https://www.meteo.be/fr/belgique")

    def run(self):
        cdict = self.getWeather()
        self.data = cdict
        self.output = {
            "full_text": self.format.format(**cdict),
            "color": self.color
        }
