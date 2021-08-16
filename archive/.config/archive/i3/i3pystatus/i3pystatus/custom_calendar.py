# imports
from i3pystatus import IntervalModule
import subprocess
import os
import time


class custom_calendar(IntervalModule):

    on_leftclick = "googleCalendar"
    color = '#ffffff'
    settings = ("format", "color")

    def getDate(self):
        dayName = subprocess.run(['date', '+%A'],
                                 check=True,
                                 stdout=subprocess.PIPE,
                                 universal_newlines=True)
        dayName = (dayName.stdout).strip()

        day = subprocess.run(['date', '+%e'],
                             check=True,
                             stdout=subprocess.PIPE,
                             universal_newlines=True)
        day = (day.stdout).strip()

        month = subprocess.run(['date', '+%B'],
                               check=True,
                               stdout=subprocess.PIPE,
                               universal_newlines=True)
        month = (month.stdout).strip()

        date = "{dayName}, {day} {month}.".format(dayName=dayName,
                                                  day=day,
                                                  month=month)
        cdict = {'date': date}
        return cdict

    def googleCalendar(self):
        # open a new chromium window and sleep 0.5s
        os.popen("firefox")
        time.sleep(0.5)
        # open the Google calendar link
        os.popen("firefox https://calendar.google.com/calendar/r?tab=rc")

    def run(self):
        cdict = self.getDate()
        self.data = cdict
        self.output = {
            "full_text": self.format.format(**cdict),
            "color": self.color
        }
