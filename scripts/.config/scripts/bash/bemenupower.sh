#!/bin/bash
source $HOME/.config/scripts/bash/lightBemenu

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
font="RobotoMono 16"

menu() { bemenu --fn "$font"\
	-i\
	-l 10\
	--prompt="PowerMenu"\
	$colors; }


options() {
	printf " Poweroff\n勒 Reboot\n﫼 Logout\n鈴 Suspend\n Hibernate\n PowerMode\n祥 Screen timeout"
}

select=$(options | menu)

# power menu
case $select in
	" Poweroff")
		notify-send -i "$icon_path/$shutdown_icon" "Shutting down..." &
		sleep 1
		poweroff
		;;
	"勒 Reboot")
		notify-send -i "$icon_path/$reboot_icon" "Rebooting..." &
		sleep 1
		reboot
		;;
	"﫼 Logout")
		notify-send -i "$icon_path/$log_out_icon" "Logging off..." &
		echo "not waiting"
		sleep 1
		logoff_cmd
		;;
	"鈴 Suspend")
		notify-send -i "$icon_path/$suspend_icon" "Suspending..." &
		sleep 1
		systemctl suspend
		;;
	" Hibernate")
		notify-send -i "$icon_path/$suspend_hibernate_icon" "Hibernating..." &
		sleep 1
		systemctl hibernate
		;;
	" PowerMode")
		foot sudo "$HOME"/.config/scripts/bash/Tools/powersave.sh
		;;
	"祥 Screen timeout")
		timeout=$(printf "鈴 Enable screen timeout\n零 Disable screen timeout" | menu)
		;;
esac

# screen timeout
case $timeout in
	"鈴 Enable screen timeout")
		"$HOME"/.config/scripts/bash/Tools/idle.sh
		notify-send -i "$icon_path/$screen_icon" "Screen timeout enabled"
		;;
	"零 Disable screen timeout")
		if "$HOME"/.config/scripts/bash/Tools/idle.sh 0;then
			notify-send -i "$icon_path/$screen_icon" "Screen timeout disabled"
		fi
		;;
esac
