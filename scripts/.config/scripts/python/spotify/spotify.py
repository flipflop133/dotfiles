"""Script to display spotify in waybar.
Requirements:
 - dbus-python (module)
 - python-gobject (package)
"""
from json import dumps
from os import fork, wait
from subprocess import PIPE, run
from sys import stdout
from time import sleep

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib


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
    clean = 0

    def __init__(self):
        # initialize the signal handler
        DBusGMainLoop(set_as_default=True)
        loop = GLib.MainLoop()
        dbus.SessionBus().add_signal_receiver(
            handler_function=self.signal_handler,
            interface_keyword='org.mpris.MediaPlayer2.spotify')
        loop.run()

    def signal_handler(self, *args, **kwargs):
        # retrieve Spotify metadata
        Spotify.getSongData(self)
        # display Spotify metadata
        Spotify.formatSongOutput(self)
        # check and block ads
        Spotify.blockAds(self)

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
        for sink in sink_inputs:
            if "media.name = \"Spotify\"" in sink:
                sink_to_mute = sink[1:3]
        # Mute spotify sink
        run(["pactl", "set-sink-input-mute", sink_to_mute, mute], stdout=PIPE)

    def blockAds(self):
        """Mute sound during ads
        """
        if 'Advertisement' in Spotify.song and Spotify.ad is False:
            Spotify.muteSpotify(self, "true")
            Spotify.ad = True
            # Workaround: sleep for 3 seconds because Spotify seems
            # to mix the end of the ad with the start of the song.
            sleep(3)
        if 'Advertisement' not in Spotify.song and Spotify.ad is True:
            Spotify.muteSpotify(self, "false")
            Spotify.ad = False

    def getSongData(self):
        """Retrieve Spotify current playing song data using dbus
        """
        metadata = dbus.Interface(
            dbus.SessionBus().get_object('org.mpris.MediaPlayer2.spotify',
                                         '/org/mpris/MediaPlayer2'),
            'org.freedesktop.DBus.Properties').Get(
                'org.mpris.MediaPlayer2.Player', 'Metadata')

        Spotify.artist = metadata['xesam:artist'][0] if metadata[
            'xesam:artist'] else ''
        Spotify.song = metadata['xesam:title'] if metadata[
            'xesam:title'] else ''
        Spotify.album = metadata['xesam:album'] if metadata[
            'xesam:album'] else ''

    def formatSongOutput(self):
        """ Print song data in Json format.
        """
        output = {'text': ''}
        status = Spotify.getPlayBackStatus(
            self)  # status used to determine icon

        # display song name
        if (Spotify.song != '' or Spotify.artist != '' or
                Spotify.album != '') and 'Advertisement' not in Spotify.song:
            if (Spotify.artist != '' and Spotify.song != ''):
                output = {
                    'text': Spotify.song[:20] + " - " + Spotify.artist[:20],
                    'alt': status,
                    'tooltip': Spotify.album
                }
            elif (Spotify.artist != ''):
                output = {
                    'text': Spotify.artist[:40],
                    'alt': status,
                    'tooltip': Spotify.album
                }
            elif (Spotify.song != ''):
                output = {
                    'text': Spotify.song[:40],
                    'alt': status,
                    'tooltip': Spotify.album
                }
            else:
                output = {'text': Spotify.album[:40], 'alt': status}
        Spotify.output(self, output)

    def getPlayBackStatus(self):
        """Use Dbus to find the current playback status
        """
        return (dbus.Interface(
            dbus.SessionBus().get_object(Dbus.obj_player + "." + "spotify",
                                         Dbus.path_player),
            Dbus.intf_props)).Get(Dbus.intf_player, "PlaybackStatus")


Spotify()
