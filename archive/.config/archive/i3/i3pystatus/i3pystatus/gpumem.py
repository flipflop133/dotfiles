# imports
from i3pystatus import IntervalModule
import os


class gpumem(IntervalModule):

    color = "#000000"
    settings = ("format", "color")

    def getMem(self):
        # extract GPU available mem
        f = os.popen("glxinfo | grep 'Currently available'")
        gpu_mem = f.read()
        gpu_mem = gpu_mem.split()
        gpu_mem = gpu_mem[5]

        # extract GPU total mem
        f = os.popen("glxinfo | grep 'Total available'")
        gpu_mem_tot = f.read()
        gpu_mem_tot = gpu_mem_tot.split()
        gpu_mem_tot = gpu_mem_tot[3]

        gpu_mem_used = int(gpu_mem_tot) - int(gpu_mem)
        cdict = {'gpu_mem': gpu_mem_used}
        return cdict

    def run(self):
        cdict = self.getMem()
        self.data = cdict
        self.output = {
            "full_text": self.format.format(**cdict),
            "color": self.color,  # "color": cdict['color']
        }
