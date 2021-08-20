import os
from subprocess import run, PIPE
import time
import json
import sys
try:
    import dbus
except ModuleNotFoundError:
    n = os.fork()
    if n == 0:
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
    song = ""
    artist = ""
    album = ""
    ad = False

    def __init__(self):
        while True:
            # retrieve Spotify metadata
            Spotify.getSongData(self)
            # display Spotify metadata
            Spotify.output(self)
            # check and block ads
            Spotify.blockAds(self)
            time.sleep(3)

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
        session_bus = dbus.SessionBus()
        spotify_bus = session_bus.get_object('org.mpris.MediaPlayer2.spotify',
                                             '/org/mpris/MediaPlayer2')

        spotify_properties = dbus.Interface(spotify_bus,
                                            'org.freedesktop.DBus.Properties')
        metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player',
                                          'Metadata')
        artist = metadata['xesam:artist'][0] if metadata['xesam:artist'] else ''
        Spotify.artist = artist
        song = metadata['xesam:title'] if metadata['xesam:title'] else ''
        Spotify.song = song
        album = metadata['xesam:album'] if metadata['xesam:album'] else ''
        Spotify.album = album

    def output(self):
        """ Print song data in Json format.
        """
        output = ""
        # determine icon
        status = Spotify.getPlayBackStatus(self)
        if status == "Paused":
            icon = "Paused"
        else:
            icon = "Playing"

        # display song name
        if (Spotify.song != '' or Spotify.artist != '' or
                Spotify.album != '') and 'Advertisement' not in Spotify.song:
            if (Spotify.artist != '' and Spotify.song != ''):
                output = {
                    'text': Spotify.song[:20] + " - " + Spotify.artist[:20],
                    'alt': icon,
                    'tooltip': Spotify.album
                }
            elif (Spotify.artist != ''):
                output = {
                    'text': Spotify.artist[:40],
                    'alt': icon,
                    'tooltip': Spotify.album
                }
            elif (Spotify.song != ''):
                output = {
                    'text': Spotify.song[:40],
                    'alt': icon,
                    'tooltip': Spotify.album
                }
            else:
                output = {'text': Spotify.album[:40], 'alt': icon}
        sys.stdout.write(json.dumps(output) + '\n')
        sys.stdout.flush()

    def getPlayBackStatus(self):
        """Use Dbus to find the current playback status
        """
        player = Dbus.obj_player + "." + "spotify"
        player = dbus.SessionBus().get_object(player, Dbus.path_player)
        properties = dbus.Interface(player, Dbus.intf_props)
        return properties.Get(Dbus.intf_player, "PlaybackStatus")


Spotify()
