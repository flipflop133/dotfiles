#!/bin/bash
light(){
	# Change gtk-theme
	gsettings set org.gnome.desktop.interface gtk-theme vimix-light-laptop-doder
	# Change sway theme
	# Change waybar theme
}

dark(){
	echo "setting dark mode"
	# Change gtk-theme
	gsettings set org.gnome.desktop.interface gtk-theme vimix-dark-laptop-doder
	# Change sway theme
	# Change waybar theme
}

while getopts m:a:f: flag
do
    case "${flag}" in
	m) mode=${OPTARG};;
	a) age=${OPTARG};;
	f) fullname=${OPTARG};;
	*) echo "invalid flag"
    esac
done
echo "done"
echo ""$mode
$mode
