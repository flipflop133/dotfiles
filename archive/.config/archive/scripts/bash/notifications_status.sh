#!/bin/sh
# Script to display and control notifications in status bar
# Dependencies: mako, nerd fonts

# Define icons
iconActive=""
iconInactive=""

# Display notifications status
if [ "$1" = "--status" ];then
	if [ "$(pidof mako)" ];then
		icon=$iconActive
	else
		icon=$iconInactive
	fi
	echo "$icon"
# Toggle notifications status
elif [ "$1" = "--toggle" ];then
	if [ "$(pidof mako)" ];then
		killall mako
	else
		mako
	fi
fi
