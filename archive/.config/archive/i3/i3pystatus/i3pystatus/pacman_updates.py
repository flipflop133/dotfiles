from i3pystatus import IntervalModule
import os


class pacman_updates(IntervalModule):

    color = "#000000"
    on_leftclick = "run"
    settings = (("format", "Format string used for output."),
                ("color", "Standard color"), ("interval", "Update interval."))
    format = "{icon}{temp}"
    interval = 900  # refresh every 15 minutes

    def get_updates(self):
        pacman = os.popen("pacman -Qu | wc -l")
        updates = pacman.read().strip()
        cdict = {"updates": updates}
        return cdict

    def run(self):
        cdict = self.get_updates()
        self.data = cdict
        self.output = {
            "full_text": self.format.format(**cdict),
            "color": self.color
        }
