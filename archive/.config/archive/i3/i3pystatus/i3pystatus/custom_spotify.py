# imports
import os
import subprocess
import time

import dbus
from i3pystatus import IntervalModule


class Dbus:
    obj_dbus = "org.freedesktop.DBus"
    path_dbus = "/org/freedesktop/DBus"
    obj_player = "org.mpris.MediaPlayer2"
    path_player = "/org/mpris/MediaPlayer2"
    intf_props = obj_dbus + ".Properties"
    intf_player = obj_player + ".Player"


class custom_spotify(IntervalModule):

    on_leftclick = "set_pause"
    on_rightclick = "play_next"
    color = '#ffffff'
    settings = ("format", "color")
    format = "{icon}{song}{artist}"

    # store if the previous song was an ad
    ad = False
    isSong = False

    def blockAds(self, song):
        """Mute sound during ads
        """
        # get mute status
        f = os.popen("pacmd list-sinks | awk '/muted/ { print $2 }'")
        mute = f.read()
        # mute sound if spotify is playing and AD
        if 'Advertisement' in song and 'yes' not in mute:
            subprocess.call(['pactl', 'set-sink-mute', '0', "toggle"])
            self.ad = True
            time.sleep(5)
        if 'Advertisement' not in song and 'yes' in mute and self.ad:
            subprocess.call(['pactl', 'set-sink-mute', '0', "toggle"])
        if 'Advertisement' not in song:
            self.ad = False

    def getSong(self):
        # song name
        f = os.popen(
            "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '\"' -f 2"
        )
        song = (f.read()).split()
        finalSong = ''
        for i in song:
            finalSong += i + ' '
        # check for ads
        self.blockAds(finalSong)
        # artist
        f = os.popen(
            "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata"
        )
        artist = (f.read()).split()
        artistName = ''
        for i in range(len(artist)):
            if artist[i] == "\"xesam:artist\"":
                artistName = artist[i + 5] + ' ' + artist[i + 6]
                # filter weird characters
                artistName = artistName.strip(']')
                artistName = artistName.replace('"', '')
                artistName = 'by ' + artistName

        # determine icon
        status = self.get_playBackStatus()
        if status == "Paused":
            icon = ''
        else:
            icon = ''
        # display song name
        if finalSong != '' and 'Advertisement' not in finalSong and artistName != '' and custom_spotify.isSong is False:
            custom_spotify.isSong = True
            cdict = {'icon': icon, 'song': finalSong, 'artist': ''}

        # display artist name
        elif finalSong != '' and 'Advertisement' not in finalSong and artistName != '' and custom_spotify.isSong is True:
            custom_spotify.isSong = False
            cdict = {'icon': icon, 'song': '', 'artist': artistName}

        return cdict

    def get_playBackStatus(self):
        """Use Dbus to find the current playback status
        """
        player = Dbus.obj_player + "." + "spotify"
        player = dbus.SessionBus().get_object(player, Dbus.path_player)
        properties = dbus.Interface(player, Dbus.intf_props)
        return properties.Get(Dbus.intf_player, "PlaybackStatus")

    def set_pause(self):
        """Toggle play/pause using dbus
        """
        os.popen(
            "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
        )
        self.icon = "play"

    def play_next(self):
        """Play the next song using dbus
        """
        os.popen(
            "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
        )

    def run(self):
        try:
            cdict = self.getSong()
            self.data = cdict
            self.output = {
                "full_text": self.format.format(**cdict),
                "color": self.color,
            }
        except:
            self.output = {
                "full_text": '',
            }
