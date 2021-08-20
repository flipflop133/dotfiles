import os
from subprocess import run, PIPE
from time import sleep
import json
import sys
try:
    import dbus
except ModuleNotFoundError:
    if os.fork() == 0:
        run(["pip", "install", "dbus-python"])
        import dbus
    else:
        os.wait()


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

    def __init__(self):
        while True:
            # retrieve Spotify metadata
            Spotify.getSongData(self)
            # display Spotify metadata
            Spotify.output(self)
            # check and block ads
            Spotify.blockAds(self)
            sleep(3)

    def muteSpotify(self, mute):
        """ Mute Spotify sound
        """
        # retrieve sink inputs
        appList = run(["pacmd", "list-sink-inputs"], stdout=PIPE)

        # parse the output
        parsed = {}
        lines = appList.stdout.decode('utf-8').replace("\t", "").replace(
            " ", "").split("\n")
        current_index = 0
        cross_properties = False

        for line in lines:
            if not cross_properties:
                splited = line.split(":")
                cross_properties = splited[0] == "properties"

                if splited[0] == "index":
                    current_index = int(splited[1])

            else:
                splited = line.split("=")
                if splited[0] == "application.name":
                    parsed[splited[1]] = current_index
                    current_index = 0
                    cross_properties = False

        # mute Spotify
        index = parsed["\"Spotify\""]
        run(["pacmd", "set-sink-input-mute", str(index), mute])

    def blockAds(self):
        """Mute sound during ads
        """
        if 'Advertisement' in Spotify.song and Spotify.ad is False:
            Spotify.muteSpotify(self, "1")
            Spotify.ad = True
        if 'Advertisement' not in Spotify.song and Spotify.ad is True:
            Spotify.muteSpotify(self, "0")
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

    def output(self):
        """ Print song data in Json format.
        """
        output = ""
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
        sys.stdout.write(json.dumps(output) + '\n')
        sys.stdout.flush()

    def getPlayBackStatus(self):
        """Use Dbus to find the current playback status
        """
        return (dbus.Interface(
            dbus.SessionBus().get_object(Dbus.obj_player + "." + "spotify",
                                         Dbus.path_player),
            Dbus.intf_props)).Get(Dbus.intf_player, "PlaybackStatus")


Spotify()
