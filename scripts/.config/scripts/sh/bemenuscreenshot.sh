#!/bin/sh
. "$HOME"/.config/scripts/sh/bemenu_theme

# menu
menu() { 
	bemenu -i -l 10 --prompt="Screenshot menu" --fn "$font" $theme;
}

options() {
	printf " save\n copy"
}

subOptions(){
	printf " active\n screen\n output\n麗 area\n window\n"
}

select=$(options | menu)
choice=""

case $select in
	" save")
		choice="save"
		echo "save selected"
		subSelect=$(subOptions | menu)
		;;
	" copy")
		choice="copy"
		echo "copy selected"
		subSelect=$(subOptions | menu)
		;;
	*)
		exit 1
esac


secondChoice=""

case $subSelect in
	" active")
		secondChoice="active"
		;;
	" screen")
		secondChoice="screen"
		;;
	" output")
		secondChoice="output"
		;;
	"麗 area")
		secondChoice="area"
		;;
	" window")
		secondChoice="window"
		;;
	*)
		exit 1
esac

"$HOME"/.config/scripts/bash/grimshot.sh --notify $choice $secondChoice