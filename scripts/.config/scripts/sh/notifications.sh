#!/bin/sh
# Dependencies: libnotify, light, Papirus icon pack, Pulseaudio-ctl

brightness() {
	icon_path="/usr/share/icons/Papirus/48x48/status/"
	brightness_low="notification-display-brightness-low.svg"
	brightness_medium="notification-display-brightness-medium.svg"
	brightness_high="notification-display-brightness-high.svg"
	brightness_full="notification-display-brightness-full.svg"

	brightness=$(light)
	brightness=${brightness%.*}

	# Set the icon depending on the brightness level
	if [ "$brightness" -lt 34 ]; then
		icon=$icon_path$brightness_low
	elif [ "$brightness" -lt 67 ]; then
		icon=$icon_path$brightness_medium
	elif [ "$brightness" -lt 100 ]; then
		icon=$icon_path$brightness_high
	else
		icon=$icon_path$brightness_full
	fi

	# Send the notification
	notify-send -c brightness "Brightness [$brightness] " -h int:value:"$brightness" --icon $icon
}

volume() {
	icon_path="/usr/share/icons/Papirus/48x48/status/"
	volume_muted="notification-audio-volume-muted.svg"
	volume_low="notification-audio-volume-low.svg"
	volume_medium="notification-audio-volume-medium.svg"
	volume_high="notification-audio-volume-high.svg"

	# Retrieve current volume level
	mute_status=$(pactl get-sink-mute 0 | awk '{print $2}')
	volume=$(pactl get-sink-volume 0 | awk '{print $5}')
	volume=$(echo "$volume" | sed 's/%//')

	# Set the icon depending on the volume level
	if [ "$mute_status" = "yes" ]; then
		icon=$icon_path$volume_muted
		# Send the notification
		notify-send -c audio "Volume" "Muted" --icon $icon
		exit
	elif [ "$volume" -lt 34 ]; then
		icon=$icon_path$volume_low
	elif [ "$volume" -lt 67 ]; then
		icon=$icon_path$volume_medium
	else
		icon=$icon_path$volume_high
	fi

	# Send the notification
	notify-send -c audio "Volume" "$volume%" -h int:value:"$volume" --icon $icon
}

microphone() {
	icon_path="/usr/share/icons/Papirus/48x48/status/"
	volume_low="notification-audio-volume-low.svg"
	volume_medium="notification-audio-volume-medium.svg"
	volume_high="notification-audio-volume-high.svg"
	mic_off="mic-off.svg"

	# Retrieve current volume level
	volume=$(pactl get-source-volume 0 | awk '{print $5}')
	volume=$(echo "$volume" | sed 's/%//')
	status=$(pactl get-source-mute 0 | awk '{print $2}')

	# Set the icon depending on the volume level
	if [ "$status" = "yes" ]; then
		icon=$icon_path$mic_off
		micro="muted"
		# Send the notification
		notify-send -c audio "Microphone status" "$micro" --icon $icon
		exit
	elif [ "$volume" -lt 34 ]; then
		icon=$icon_path$volume_low
	elif [ "$volume" -lt 67 ]; then
		icon=$icon_path$volume_medium
	else
		icon=$icon_path$volume_high
	fi

	# Send the notification
	notify-send -c audio "Microphone volume" "$volume%" -h int:value:"$volume" --icon $icon
}

case "$1" in
microphone)
	microphone
	;;
volume)
	volume
	;;
brightness)
	brightness
	;;
esac
