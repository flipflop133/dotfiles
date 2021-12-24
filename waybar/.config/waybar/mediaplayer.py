#!/usr/bin/env python3
import argparse
import json
import logging
import signal
import subprocess
import sys
import time

import gi

gi.require_version('Playerctl', '2.0')
from gi.repository import GLib, Playerctl

logger = logging.getLogger(__name__)


class MediaPlayer():
    muted = False

    def __init__(self):
        self.main()

    def write_output(self, text, player):
        logger.info('Writing output')

        output = {
            'text': text,
            'class': 'custom-' + player.props.player_name,
            'alt': player.props.status,
            'tooltip': player.get_album()
        }

        sys.stdout.write(json.dumps(output) + '\n')
        sys.stdout.flush()

    def on_play(self,player, status, manager):
        logger.info('Received new playback status')
        self.on_metadata(player, player.props.metadata, manager)

    def on_metadata(self, player, metadata, manager):
        logger.info('Received new metadata')
        track_info = ''
        if player.props.player_name == 'spotify' and \
                'mpris:trackid' in metadata.keys() and \
                ':ad:' in player.props.metadata['mpris:trackid']:
            track_info = 'AD PLAYING'
            self.mute_spotify('true')
        elif player.get_artist() != '' and player.get_title() != '':
            track_info = f'{player.get_artist()[:40]} - {player.get_title()[:40]}'
            if player.props.player_name == 'spotify' and self.muted:
                time.sleep(
                    2)  # Spotify mix end of ad with beginning of next song.
                self.mute_spotify('false')
        else:
            track_info = player.get_title()

        self.write_output(track_info, player)

    def on_player_appeared(self, manager, player, selected_player=None):
        if player is not None and (selected_player is None or
                                        player.name == selected_player):
            self.init_player(manager, player)
        else:
            logger.debug(
                "New player appeared, but it's not the selected player, skipping"
            )

    @staticmethod
    def on_player_vanished(manager, player):
        logger.info('Player has vanished')
        sys.stdout.write('\n')
        sys.stdout.flush()

    def init_player(self, manager, name):
        logger.debug('Initialize player: %s', name.name)
        player = Playerctl.Player.new_from_name(name)
        player.connect('playback-status', self.on_play, manager)
        player.connect('metadata', self.on_metadata, manager)
        manager.manage_player(player)
        self.on_metadata(player, player.props.metadata, manager)

    @staticmethod
    def signal_handler(sig, frame):
        logger.debug('Received signal to stop, exiting')
        sys.stdout.write('\n')
        sys.stdout.flush()
        sys.exit(0)

    @staticmethod
    def parse_arguments():
        parser = argparse.ArgumentParser()

        # Increase verbosity with every occurrence of -v
        parser.add_argument('-v', '--verbose', action='count', default=0)

        # Define for which player we're listening
        parser.add_argument('--player')

        return parser.parse_args()

    def mute_spotify(self, mute):
        """ Mute Spotify sink input using pactl.
            Parameters
            ----------
            mute: str
                if true, mute spotify sink.
        """
        # Find Spotify sink id
        sink_inputs = subprocess.run(["pactl", "list", "sink-inputs"],
                                     stdout=subprocess.PIPE)
        sink_inputs = sink_inputs.stdout.decode('utf-8')
        sink_inputs = sink_inputs.split("Sink Input ")
        sink_inputs.pop(0)
        sink_to_mute = '-1'
        for sink in sink_inputs:
            if "media.name = \"Spotify\"" in sink:
                sink_to_mute = sink[1:3]
        # Mute spotify sink
        if sink_to_mute != -1:
            subprocess.run(
                ["pactl", "set-sink-input-mute", sink_to_mute, mute],
                stdout=subprocess.PIPE)
        if mute == 'true':
            self.muted = True
        else:
            self.muted = False

    def main(self):
        arguments = self.parse_arguments()

        # Initialize logging
        logging.basicConfig(stream=sys.stderr,
                            level=logging.DEBUG,
                            format='%(name)s %(levelname)s %(message)s')

        # Logging is set by default to WARN and higher.
        # With every occurrence of -v it's lowered by one
        logger.setLevel(max((3 - arguments.verbose) * 10, 0))

        # Log the sent command line arguments
        logger.debug('Arguments received %s', str(vars(arguments)))

        manager = Playerctl.PlayerManager()
        loop = GLib.MainLoop()

        manager.connect(
            'name-appeared',
            lambda *args: self.on_player_appeared(*args, arguments.player))
        manager.connect('player-vanished', self.on_player_vanished)

        signal.signal(signal.SIGINT, self.signal_handler)
        signal.signal(signal.SIGTERM, self.signal_handler)
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

        for player in manager.props.player_names:
            if arguments.player is not None and arguments.player != player.name:
                logger.debug(
                    '%s is not the filtered player, skipping it',player.name)
                continue

            self.init_player(manager, player)

        loop.run()


if __name__ == '__main__':
    MediaPlayer()
