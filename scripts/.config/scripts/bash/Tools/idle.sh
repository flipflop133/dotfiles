#!/bin/sh
# power management
killall swayidle
if [ "$1" -eq 1 ];then
	swayidle -w timeout 330 'swaylock -f --no-unlock-indicator --image $HOME/Images/wallpaper/*'\
		timeout 300 'swaymsg "output * dpms off"'\
		resume 'swaymsg "output * dpms on"'\
		before-sleep 'swaylock -f --no-unlock-indicator --image $HOME/Images/wallpaper/*'
fi
