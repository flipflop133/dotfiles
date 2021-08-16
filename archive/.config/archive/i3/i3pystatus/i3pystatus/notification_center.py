from i3pystatus import IntervalModule
import os


class notification_center(IntervalModule):

    on_leftclick = "change_notification_mode"
    color = "#ffffff"
    settings = ("format", ("interval", "update interval"), "color")
    interval = 3600
    dunst = 'on'
    icon = ''

    def change_notification_mode(self):
        # if dunst is on kill it on click
        if notification_center.dunst == 'on':
            os.popen("killall dunst")
            notification_center.dunst = 'off'
            notification_center.icon = ''
        # if dunst is off open it on click
        elif notification_center.dunst == 'off':
            os.popen("dunst")
            notification_center.dunst = 'on'
            notification_center.icon = ''

    def get_icon(self):
        icon = notification_center.icon
        cdict = {"icon": icon}
        return cdict

    def run(self):
        cdict = self.get_icon()
        self.data = cdict
        self.output = {
            "full_text": self.format.format(**cdict),
            "color": self.color
        }
