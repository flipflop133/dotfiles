#!/bin/bash
source $HOME/.config/scripts/bash/lightBemenu

menu() { bemenu --fn "$font"\
	-i\
	-l 10\
	--prompt="ScreenshotMenu"\
	$colors;
}

options() {
	printf "\uf0c7save\n\uf68ecopy"
}

subOptions(){
	printf "\uf245active\n\uf792screen\n\ufafboutput\n\uf988area\n\uf2d0window\n"
}

select=$(options | menu)
choice=""

case $select in
	"\uf0c7save")
		choice="save"
		echo "save selected"
		subSelect=$(subOptions | menu)
		;;
	"\uf68copy")
		choice="copy"
		echo "copy selected"
		subSelect=$(subOptions | menu)
		;;
	*)
		exit 1
esac


secondChoice=""

case $subSelect in
	"\uf245active")
		secondChoice="active"
		;;
	"\uf792screen")
		secondChoice="screen"
		;;
	"\ufafboutput")
		secondChoice="output"
		;;
	"\uf988area")
		secondChoice="area"
		;;
	"\uf2d0window")
		secondChoice="window"
		;;
	*)
		exit 1
esac

$HOME/.config/scripts/bash/grimshot.sh --notify $choice $secondChoice
