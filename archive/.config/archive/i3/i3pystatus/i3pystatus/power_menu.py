# imports
from i3pystatus import IntervalModule
import subprocess
import os
import time


class power_menu(IntervalModule):
    on_leftclick = "powerMenu"

    color = '#ffffff'
    settings = ("format", "color")

    def powerMenu(self):
        os.popen("~/.config/rofi/power_menu/menu_powermenu.sh")

    def run(self):
        self.output = {"full_text": '', "color": self.color}
