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

menu() { bemenu --fn "$font"\
	-i\
	-l 10\
	--prompt="PowerMenu"\
	$colors; }


options() {
	printf "\uf011Poweroff\n\uf952Reboot\n\uf842Logout\n\uf9b1Suspend\n\uf2dcHibernate\n\uf58ePowerMode\n\ufa1aScreen timeout"
}

select=$(options | menu)

# power menu
case $select in
	"\uf011Poweroff")
		notify-send -i "$icon_path/$shutdown_icon" "Shutting down..." &
		sleep 1
		poweroff
		;;
	"\uf952Reboot")
		notify-send -i "$icon_path/$reboot_icon" "Rebooting..." &
		sleep 1
		reboot
		;;
	"\uf842Logout")
		notify-send -i "$icon_path/$log_out_icon" "Logging off..." &
		echo "not waiting"
		sleep 1
		logoff_cmd
		;;
	"\uf9b1Suspend")
		notify-send -i "$icon_path/$suspend_icon" "Suspending..." &
		sleep 1
		systemctl suspend
		;;
	"\uf2dcHibernate")
		notify-send -i "$icon_path/$suspend_hibernate_icon" "Hibernating..." &
		sleep 1
		systemctl hibernate
		;;
	"\uf58ePowerMode")
		foot sudo "$HOME"/.config/scripts/bash/Tools/powersave.sh
		;;
	"\ufa1aScreen timeout")
		timeout=$(printf "\uf9b1Enable screen timeout\n\uf9b2Disable screen timeout" | menu)
		;;
esac

# screen timeout
case $timeout in
	"\uf9b1Enable screen timeout")
		"$HOME"/.config/scripts/bash/Tools/idle.sh
		notify-send -i "$icon_path/$screen_icon" "Screen timeout enabled"
		;;
	"\uf9b2Disable screen timeout")
		if "$HOME"/.config/scripts/bash/Tools/idle.sh 0;then
			notify-send -i "$icon_path/$screen_icon" "Screen timeout disabled"
		fi
		;;
esac
