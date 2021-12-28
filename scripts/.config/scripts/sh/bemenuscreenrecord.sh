#!/bin/sh

. "$HOME"/.config/scripts/sh/lightBemenu

# menu
menu() { 
	bemenu -i -l 10 --prompt="Screen recorder" --fn "$font" $colors;
}

options() {
	printf "yes\nno"
}

subOptions(){
	printf "麗 area\n screen"
}

select=$(options | menu "Audio?")
choice=""
choiceName=""

case $select in
	"yes")
		choice="-a"
		choiceName="with audio"
		secondSelect=$(subOptions | menu "Geometry?")
		;;
	"no")
		choice=""
		secondSelect=$(subOptions | menu "Geometry?")
		;;
	*)
		exit 1
esac


secondChoice=""

case $secondSelect in
	"麗 area")
		secondChoice="slurp"
		thirdSelect=$(options | menu "Camera?")
		;;
	" screen")
		secondChoice=""
		thirdSelect=$(options | menu "Camera?")
		;;
	*)
		exit 1
esac

thirdChoice=""

case $thirdSelect in
	"yes")
		thirdChoice="yes"
		;;
	"no")
		thirdChoice="no"
		;;
	*)
		exit 1
esac


if [ "$secondChoice" = "slurp" ];then
	exec wf-recorder "$choice" -g "$(slurp)" -f ~/Videos/recording_"$(date +"%Y-%m-%d_%H:%M:%S.mp4")" & notify-send "Recording $choiceName"
else
	exec wf-recorder "$choice" -f ~/Videos/recording_"$(date +"%Y-%m-%d_%H:%M:%S.mp4")" & notify-send "Recording $choiceName"
fi

if [ $thirdChoice = "yes" ];then
	ffmpeg -f v4l2 -video_size 640x480 -i /dev/video0 -c:v libx264 -preset ultrafast ~/Videos/camera_"$(date +"%Y-%m-%d_%H:%M:%S.mp4")"
fi
