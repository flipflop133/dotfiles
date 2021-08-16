# imports
import os


def getFreq():
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
    freq = '{:.2f}'.format(round(freq / 1000, 2))
    return freq


print(getFreq(), "Ghz")
