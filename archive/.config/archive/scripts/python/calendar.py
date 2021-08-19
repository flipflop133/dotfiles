# imports
import subprocess
import time
import argparse

calendar = False
parser = argparse.ArgumentParser()
parser.add_argument('-c', '--calendar', type=bool, metavar='calendar')
args = parser.parse_args()

if args.calendar is not None:
    calendar = args.calendar


def getDate():
    print(time.strftime("%A, %d %B."))


def googleCalendar():
    # open a new browser firefox in workspace 1 and sleep 0.5s
    subprocess.run(["i3-msg", "workspace", "3"])
    subprocess.run(["firefox"])
    time.sleep(0.5)
    # open Google calendar
    subprocess.run(
        ["firefox", "https://calendar.google.com/calendar/r?tab=rc"])


if calendar:
    googleCalendar()
else:
    getDate()
