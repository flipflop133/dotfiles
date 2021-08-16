import dbus
session_bus = dbus.SessionBus()
spotify_bus = session_bus.get_object('org.mpris.MediaPlayer2.spotify',
                                     '/org/mpris/MediaPlayer2')
spotify_properties = dbus.Interface(spotify_bus,
                                    'org.freedesktop.DBus.Properties')
metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
for key, value in metadata.items():
    print("key: " + str(key), "value: " + str(value))
artist = metadata['xesam:artist'][0] if metadata['xesam:artist'] else ''
song = metadata['xesam:title'] if metadata['xesam:title'] else ''
print(artist)
