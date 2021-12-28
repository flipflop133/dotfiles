#!/bin/sh

. "$HOME"/.config/scripts/bash/lightBemenu

logoff_cmd() { sway exit; }

# icons
icon_path="/usr/share/icons/Papirus/48x48/apps"
shutdown_icon="system-shutdown.svg"
reboot_icon="system-reboot.svg"
log_out_icon="system-log-out.svg"
suspend_icon="system-suspend.svg"
suspend_hibernate_icon="system-suspend-hibernate.svg"
screen_icon="cs-screen.svg"

# menu
menu() { 
	options="-i -l 10 --prompt="$1" "$font" "$colors""
	bemenu $options
}

options() {
	printf "Poweroff\nReboot\nLogout\nSuspend\nHibernate\nPower mode\nScreen timeout"
}

select=$(options | menu "Power menu")

# power menu
case $select in
"Poweroff")
	notify-send -i "$icon_path/$shutdown_icon" "Shutting down..." &
	sleep 1
	poweroff
	;;
"Reboot")
	notify-send -i "$icon_path/$reboot_icon" "Rebooting..." &
	sleep 1
	reboot
	;;
"Logout")
	notify-send -i "$icon_path/$log_out_icon" "Logging off..." &
	sleep 1
	logoff_cmd
	;;
"Suspend")
	notify-send -i "$icon_path/$suspend_icon" "Suspending..." &
	sleep 1
	systemctl suspend
	;;
"Hibernate")
	notify-send -i "$icon_path/$suspend_hibernate_icon" "Hibernating..." &
	sleep 1
	systemctl hibernate
	;;
"Power mode")
	$TERM sudo "$HOME"/.config/scripts/bash/Tools/powersave.sh
	;;
"Screen timeout")
	timeout=$(printf "Enable\nDisable" | menu "Screen timeout")
	;;
esac

# screen timeout
case $timeout in
"Enable")
	"$HOME"/.config/scripts/bash/Tools/idle.sh
	notify-send -i "$icon_path/$screen_icon" "Screen timeout enabled"
	;;
"Disable")
	if "$HOME"/.config/scripts/bash/Tools/idle.sh 0; then
		notify-send -i "$icon_path/$screen_icon" "Screen timeout disabled"
	fi
	;;
esac
