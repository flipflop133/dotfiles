# imports
import os


def getMem():
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

    gpu_mem_used = 100 - ((int(gpu_mem) / int(gpu_mem_tot)) * 100)
    print("%.0i%%" % gpu_mem_used)


getMem()
