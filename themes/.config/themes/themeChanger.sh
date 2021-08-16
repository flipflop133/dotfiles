#!/bin/bash
dark_mode(){
	# Retrieve current theme
	theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
	newTheme=${theme/light/dark}
	# theme foot
	sed -i 's/lightTheme/darkTheme/g' "$HOME"/.config/foot/foot.ini
	# theme sway
	sed -i 's/lightTheme/darkTheme/g' "$HOME"/.config/sway/config
	sed -i 's/lightFuzzel/darkFuzzel/g' "$HOME"/.config/sway/config
	sed -i 's/wallpaper\/light/wallpaper\/dark/g' "$HOME"/.config/sway/config
	sed -i "s|$theme|$newTheme|g" "$HOME"/.config/sway/config
	sway reload 1> /dev/null
	python $HOME/.config/themes/themeSway.py dark
	sway reload 1> /dev/null
	# theme bemenu
	sed -i 's/lightBemenu/darkBemenu/g' "$HOME"/.config/scripts/bash/bemenupower.sh
	sed -i 's/lightBemenu/darkBemenu/g' "$HOME"/.config/scripts/bash/bemenuscreenrecord.sh
	sed -i 's/lightBemenu/darkBemenu/g' "$HOME"/.config/scripts/bash/bemenuscreenshot.sh
	# theme ncmcpp	
	ncmcpp_dark
	# theme mako
	mako_dark
	# theme nvim
	sed -i 's/themeStyle = "light"/themeStyle = "dark"/g' "$HOME"/.config/nvim/lua/plugins.lua
	nvim +PackerCompile +qall!
}

light_mode(){
	# Retrieve current theme
	theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
	newTheme=${theme/dark/light}
	# theme foot
	sed -i 's/darkTheme/lightTheme/g' "$HOME"/.config/foot/foot.ini
	# theme sway
	sed -i 's/darkTheme/lightTheme/g' "$HOME"/.config/sway/config
	sed -i 's/darkFuzzel/lightFuzzel/g' "$HOME"/.config/sway/config
	sed -i 's/wallpaper\/dark/wallpaper\/light/g' "$HOME"/.config/sway/config
	sed -i "s|$theme|$newTheme|g" "$HOME"/.config/sway/config
	sway reload 1> /dev/null
	python $HOME/.config/themes/themeSway.py light
	sway reload 1> /dev/null
	# theme bemenu
	sed -i 's/darkBemenu/lightBemenu/g' "$HOME"/.config/scripts/bash/bemenupower.sh
	sed -i 's/darkBemenu/lightBemenu/g' "$HOME"/.config/scripts/bash/bemenuscreenrecord.sh
	sed -i 's/darkBemenu/lightBemenu/g' "$HOME"/.config/scripts/bash/bemenuscreenshot.sh
	# theme ncmcpp
	ncmcpp_light
	# theme mako
	mako_light
	# theme nvim
	sed -i 's/themeStyle = "dark"/themeStyle = "light"/g' "$HOME"/.config/nvim/lua/plugins.lua
	nvim +PackerCompile +qall!
}

ncmcpp_light(){
	sed -i 's/white/black/g' "$HOME"/.config/ncmpcpp/config
}

ncmcpp_dark(){
	sed -i 's/black/white/g' "$HOME"/.config/ncmpcpp/config
}

mako_light(){
	makoPID=$(pidof mako)
	if [ -n "$makoPID" ];then
		pkill mako
		sed -i 's/background-color=#1f2428/background-color=#ffffff/g' "$HOME"/.config/mako/config
		sed -i 's/text-color=#ffffff/text-color=#000000/g' "$HOME"/.config/mako/config
		sed -i 's/border-color=#ffffff/border-color=#000000/g' "$HOME"/.config/mako/config
		setsid mako &
	fi
}

mako_dark(){
	makoPID=$(pidof mako)
	if [ -n "$makoPID" ];then
		pkill mako
		sed -i 's/background-color=#ffffff/background-color=#1f2428/g' "$HOME"/.config/mako/config
		sed -i 's/text-color=#000000/text-color=#ffffff/g' "$HOME"/.config/mako/config
		sed -i 's/border-color=#000000/text-color=#ffffff/g' "$HOME"/.config/mako/config
		setsid mako &
	fi
}

lastChecked=-1
sunrise=0
sunset=0
main(){
	currentTheme=$(gsettings get org.gnome.desktop.interface gtk-theme)
	if [[ $lastChecked -ne $(date +%j) ]];then
		data=$(python $HOME/.config/themes/sunset_sunrise.py)
		sunrise=${data:2:4}
		sunset=${data:10:4}
		lastChecked=$(date +%j)
	fi

	if [[ $(("10#"$(date +%H%M))) -lt $(("10#"$sunrise)) || $(("10#"$(date +%H%M))) -gt $(("10#"$sunset)) ]];then
		if [[ $currentTheme == *"light"* ]];then
			dark_mode
		fi
	else
		if [[ $currentTheme == *"dark"* ]];then
			light_mode
		fi
	fi
	sleep 5m
	main
}
main
