"""Script to display spotify in waybar.
Requirements:
 - dbus-python (module)
 - python-gobject (package)
"""
from json import dumps
from subprocess import PIPE, run
from sys import stdout
from time import sleep

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
import threading


class Dbus:
    obj_dbus = "org.freedesktop.DBus"
    path_dbus = "/org/freedesktop/DBus"
    obj_player = "org.mpris.MediaPlayer2"
    path_player = "/org/mpris/MediaPlayer2"
    intf_props = obj_dbus + ".Properties"
    intf_player = obj_player + ".Player"


class Spotify:
    song, artist, album = "", "", ""
    ad = False
    session_bus = 0
    spotify_proxy = 0
    loop = 0

    def __init__(self):
        self.thread = threading.Thread(target=self.wait)
        # initialize the signal handler
        DBusGMainLoop(set_as_default=True)
        self.session_bus = dbus.SessionBus()
        self.run_main_loop()

    def run_main_loop(self):
        try:
            self.spotify_proxy = self.session_bus.get_object(
                'org.mpris.MediaPlayer2.spotify', '/org/mpris/MediaPlayer2')
            self.spotify_proxy.connect_to_signal(
                "test_signal",
                self.test_signal_handler,
                dbus_interface='org.mpris.MediaPlayer2.spotify',
                arg0="test_signal")
        except dbus.exceptions.DBusException:
            thread = threading.Thread(target=self.wait)
            thread.start()
            thread.join()
            self.run_main_loop()
        self.session_bus.add_signal_receiver(
            handler_function=self.signal_handler,
            interface_keyword='org.mpris.MediaPlayer2.spotify',
        )
        self.loop = GLib.MainLoop()
        self.loop.run()
        self.clean()
        self.run_main_loop()

    def wait(self):
        sleep(3)

    def clean(self):
        # Clean output when Spotify is unavailable
        output = {'text': ''}
        self.output(output)

    def test_signal_handler(self, test_signal):
        print(
            "Received signal (by connecting using remote object) and it says: "
            + test_signal)

    def signal_handler(self, *args, **kwargs):
        try:
            self.spotify_proxy = self.session_bus.get_object(
                'org.mpris.MediaPlayer2.spotify', '/org/mpris/MediaPlayer2')
            # retrieve Spotify metadata
            self.get_song_data()
            # display Spotify metadata
            self.formatSongOutput()
            # check and block ads
            self.block_ads()
        except dbus.exceptions.DBusException:
            self.loop.quit()

    def output(self, output):
        stdout.write(dumps(output) + '\n')
        stdout.flush()

    def muteSpotify(self, mute):
        """ Mute Spotify sink input using pactl.
            Parameters
            ----------
            mute: str
                if true, mute spotify sink.
            """
        # Find Spotify sink id
        sink_inputs = run(["pactl", "list", "sink-inputs"], stdout=PIPE)
        sink_inputs = sink_inputs.stdout.decode('utf-8')
        sink_inputs = sink_inputs.split("Sink Input ")
        sink_inputs.pop(0)
        sink_to_mute = '-1'
        for sink in sink_inputs:
            if "media.name = \"Spotify\"" in sink:
                sink_to_mute = sink[1:3]
        # Mute spotify sink
        if sink_to_mute != -1:
            run(["pactl", "set-sink-input-mute", sink_to_mute, mute],
                stdout=PIPE)

    def block_ads(self):
        """Mute sound during ads
        """
        if 'Advertisement' in self.song and self.ad is False:
            self.muteSpotify("true")
            self.ad = True
            # Workaround: sleep for 3 seconds because Spotify seems
            # to mix the end of the ad with the start of the song.
            sleep(3)
        if 'Advertisement' not in self.song and self.ad is True:
            self.muteSpotify("false")
            self.ad = False

    def get_song_data(self):
        """Retrieve Spotify current playing song data using dbus
        """
        metadata = dbus.Interface(self.spotify_proxy,
                                  'org.freedesktop.DBus.Properties').Get(
                                      'org.mpris.MediaPlayer2.Player',
                                      'Metadata')

        self.artist = metadata['xesam:artist'][0] if metadata[
            'xesam:artist'] else ''
        self.song = metadata['xesam:title'] if metadata['xesam:title'] else ''
        self.album = metadata['xesam:album'] if metadata['xesam:album'] else ''

    def formatSongOutput(self):
        """ Print song data in Json format.
        """
        output = {'text': ''}
        status = self.getPlayBackStatus()  # status used to determine icon

        # display song name
        if (self.song != '' or self.artist != ''
                or self.album != '') and 'Advertisement' not in self.song:
            if (self.artist != '' and self.song != ''):
                output = {
                    'text': self.song[:20] + " - " + self.artist[:20],
                    'alt': status,
                    'tooltip': self.album
                }
            elif (self.artist != ''):
                output = {
                    'text': self.artist[:40],
                    'alt': status,
                    'tooltip': self.album
                }
            elif (self.song != ''):
                output = {
                    'text': self.song[:40],
                    'alt': status,
                    'tooltip': self.album
                }
            else:
                output = {'text': self.album[:40], 'alt': status}
        self.output(output)

    def getPlayBackStatus(self):
        """Use Dbus to find the current playback status
        """
        return (dbus.Interface(self.spotify_proxy,
                               Dbus.intf_props)).Get(Dbus.intf_player,
                                                     "PlaybackStatus")


Spotify()
