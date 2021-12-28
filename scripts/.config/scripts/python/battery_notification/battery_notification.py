#!/usr/bin/env python3
"""Battery monitor that send notifications on battery low."""
import subprocess

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

ALERT_PERCENTAGES = [5, 10, 15]


class BatteryMonitor:
    loop = None
    bus = None
    notifications_sent = {}
    reset = False

    def __init__(self):
        self.battery = '/org/freedesktop/UPower/devices/battery_BAT0'
        self.upower_name = "org.freedesktop.UPower"
        self.upower_path = "/org/freedesktop/UPower"

        self.dbus_properties = "org.freedesktop.DBus.Properties"
        self.set_notifications_sent()
        self.on_property_change()
        self.loop.run()

    def set_notifications_sent(self):
        for level in ALERT_PERCENTAGES:
            self.notifications_sent[level] = False

    def on_property_change(self):
        DBusGMainLoop(set_as_default=True)
        self.loop = GLib.MainLoop()
        self.bus = dbus.SystemBus()
        battery_proxy = self.bus.get_object(self.upower_name, self.battery)
        battery_proxy_interface = dbus.Interface(battery_proxy,
                                                 self.dbus_properties)
        battery_proxy_interface.connect_to_signal('PropertiesChanged',
                                                  self.session_signal_handler,
                                                  None)

    def session_signal_handler(self, *args, **kwargs):
        if self.get_state() != "Discharging":
            if not self.reset:
                self.set_notifications_sent()
                self.reset = True
            return
        self.reset = False
        percentage = self.get_device_percentage()
        if (percentage in ALERT_PERCENTAGES
                and not self.notifications_sent[percentage]):
            self.send_notification(percentage)
            self.notifications_sent[percentage] = True

    def get_device_percentage(self):
        battery_proxy = self.bus.get_object(self.upower_name, self.battery)
        battery_proxy_interface = dbus.Interface(battery_proxy,
                                                 self.dbus_properties)

        return battery_proxy_interface.Get(self.upower_name + ".Device",
                                           "Percentage")

    @staticmethod
    def send_notification(percentage):
        icons_path = '/usr/share/icons/Papirus/48x48/status/'
        battery_low_icon = f'{icons_path}battery-caution.svg'
        battery_very_low_icon = f'{icons_path}battery-empty.svg'
        subprocess.run([
            "notify-send", "Battery warning",
            f"Your battery is running low({percentage}%)", "--icon",
            battery_very_low_icon if (percentage <= 5) else battery_low_icon
        ])

    def get_state(self):
        battery_proxy = self.bus.get_object(self.upower_name, self.battery)
        battery_proxy_interface = dbus.Interface(battery_proxy, self.dbus_properties)
        state = int(battery_proxy_interface.Get(self.upower_name + ".Device", "State"))
        if (state == 0):
            return "Unknown"
        elif (state == 1):
            return "Loading"
        elif (state == 2):
            return "Discharging"
        elif (state == 3):
            return "Empty"
        elif (state == 4):
            return "Fully charged"
        elif (state == 5):
            return "Pending charge"
        elif (state == 6):
            return "Pending discharge"


if __name__ == '__main__':
    BatteryMonitor()
