# imports
from i3pystatus import IntervalModule
from i3pystatus.core.color import ColorRangeModule
import subprocess
import os


class cputemp(IntervalModule, ColorRangeModule):

    color = "#ffffff"
    settings = ("format", "color")
    alert_temp = 90

    def getTemp(self):
        """ execute a command and extract temperature
        return
        ------
        sum: the temperature average of all cores (float)
        Version
        −−−−−−−
        specification: François Bechet (v.1 06/04/20)
        implementation: François Bechet (v.1 06/04/20)
        """
        nCores = subprocess.run("nproc", stdout=subprocess.PIPE)
        nCores = nCores.stdout
        nCores = int(nCores) // 2
        listTemps = []
        for core in range(0, nCores):
            command = "sensors coretemp-isa-0000 | awk '/Core %i/{print $3}'" % (
                core)
            C_core = os.popen(command)
            C_core = C_core.read()
            CoreTemp = ""
            for i in range(len(C_core)):
                if C_core[i] == "+":
                    for j in range(1, 5):
                        CoreTemp += (C_core[i + j])
            listTemps.append(CoreTemp)

        sum = 0
        for i in listTemps:
            sum += float(i)
        temp = (sum // nCores)
        cdict = {'temp': temp}
        return cdict

    def init(self):
        self.colors = self.get_hex_color_range(self.start_color,
                                               self.end_color, 100)

    def run(self):
        cdict = self.getTemp()
        self.data = cdict
        perc = int(self.percentage(int(cdict['temp']), self.alert_temp))
        self.output = {
            "full_text": self.format.format(**cdict),
            "color": self.color,  # "color": self.get_colour(perc)
        }

    def get_colour(self, percentage):
        index = -1 if int(percentage) > len(self.colors) - 1 else int(
            percentage)
        return self.colors[index]
