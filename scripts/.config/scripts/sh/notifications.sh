#!/bin/sh
# Dependencies: libnotify, light, Pulseaudio-ctl

brightness() {
	brightness=$(light)
	brightness=${brightness%.*}

	# Set the icon depending on the brightness level
	if [ "$brightness" -lt 16 ]; then
		icon=""
	elif [ "$brightness" -lt 32 ]; then
		icon=""
	elif [ "$brightness" -lt 48 ]; then
		icon=""
	elif [ "$brightness" -lt 64 ]; then
		icon=""
	elif [ "$brightness" -lt 80 ]; then
		icon=""
	else
		icon=""
	fi

	# Send the notification
	notify-send -c "font-icon" $icon "Brightness [$brightness%] " # $icon #-h int:value:"$brightness" 
}

volume() {
	# Retrieve current volume level
	mute_status=$(pactl get-sink-mute 0 | awk '{print $2}')
	volume=$(pactl get-sink-volume 0 | awk '{print $5}' | sed 's/%//')

	# Set the icon depending on the volume level
	if [ "$mute_status" = "yes" ]; then
		# Send the notification
		notify-send -c "font-icon" "ﱝ" "Volume Muted"
		exit
	elif [ "$volume" -lt 34 ]; then
		icon="奄"
	elif [ "$volume" -lt 66 ]; then
		icon="奔"
	else
		icon="墳"
	fi

	# Send the notification
	notify-send -c "font-icon" $icon "Volume [$volume%]" #-h int:value:"$volume" 
}

microphone() {
	# Retrieve current volume level
	status=$(pactl get-source-mute 0 | awk '{print $2}')
	volume=$(pactl get-source-volume 0 | awk '{print $5}' | sed 's/%//')

	# Set the icon depending on the volume level
	if [ "$status" = "yes" ]; then
		# Send the notification
		notify-send -c "font-icon" "" "Mic muted"
		exit
	elif [ "$volume" -lt 34 ]; then
		icon="奄"
	elif [ "$volume" -lt 66 ]; then
		icon="奔"
	else
		icon="墳"
	fi

	# Send the notification
	notify-send -c "font-icon" $icon "Mic [$volume%]" #-h int:value:"$volume" 
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
