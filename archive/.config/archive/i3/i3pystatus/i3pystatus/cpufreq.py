# imports
from i3pystatus import IntervalModule
import subprocess
import os


class cpufreq(IntervalModule):

    color = "#ffffff"
    settings = ("format", "color")

    def getFreq(self):
        # extract CPU freq
        f = os.popen("cat /proc/cpuinfo | grep 'cpu MHz'")
        now = f.read()
        listfreq = []
        cpu = 0
        for i in range(len(now)):
            if now[i] == ":":
                tempstring = ""
                for j in range(1, 6):
                    tempstring += now[i + j]
                listfreq.append(tempstring)
                cpu += 1

        sum = 0
        for i in listfreq:
            sum += float(i)
        freq = int(sum / cpu)
        # determine the color in function of the temperature
        if freq > 3500:
            color = '#ff0000'
        elif freq > 3000:
            color = '#fb8c00'
        elif freq > 2500:
            color = '#ffff00'
        else:
            color = '#ffffff'

        freq = round(freq / 1000, 2)
        cdict = {'freq': freq, 'color': color}
        return cdict

    def run(self):
        cdict = self.getFreq()
        self.data = cdict
        self.output = {
            "full_text": self.format.format(**cdict),
            "color": self.color,  # "color": cdict['color']
        }
