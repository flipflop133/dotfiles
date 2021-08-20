#!/bin/bash
battery(){
	level=$(cat /sys/class/power_supply/BAT0/capacity)
	if [ $level -lt 15 ]; then
		icon="\uf244"
	elif [ $level -lt 31 ]; then
		icon="\uf243"
	elif [ $level -lt 51 ]; then
		icon="\uf242"
	elif [ $level -lt 76 ]; then
		icon="\uf241"
	else
		icon="\uf240"
	fi
	echo $level"% "$icon"\uf22f"
}
brightness(){
	level=$(light)
	level=${level%.*}
	if [ $level -lt 5 ]; then
		icon="\uf5d9"
	elif [ $level -lt 10 ]; then
		icon="\uf5da"
	elif [ $level -lt 20 ]; then
		icon="\uf5db"
	elif [ $level -lt 40 ]; then
		icon="\uf5dc"
	elif [ $level -lt 60 ]; then
		icon="\uf5dd"
	elif [ $level -lt 80 ]; then
		icon="\uf5de"
	else
		icon="\uf5df"
	fi
	echo $level"% "$icon
}
output(){
	finalOutput=""
	padding="\u0020\u0020\u0020"
	# Volume
	finalOutput+=$padding
	volume=$(pamixer --get-volume)
	finalOutput=$finalOutput$volume"% \uf028"
	# Wifi
	# Backlight
	finalOutput+=$padding
	finalOutput=$finalOutput$(brightness) 
	# Battery
	finalOutput+=$padding
	finalOutput=$finalOutput$(battery)
	# Date and time
	finalOutput+=$padding
	finalOutput=$finalOutput$(date +'%a %d %l:%M %p')
	echo -e $finalOutput
}
while output;do sleep 1;done
