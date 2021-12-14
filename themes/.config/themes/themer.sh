#!/bin/bash
theme() {
  theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
  newTheme=${theme/$1/$2}
  # theme tutanota (tutanota needs to be closed for this to work)
  sed -i "s|\"selectedTheme\": \"${1}\"|\"selectedTheme\": \"${2}\"|g" "$HOME"/.config/tutanota-desktop/conf.json
  # theme bpytop
  bpytop "$1"
  # theme foot
  sed -i "s|${1}Theme|${2}Theme|g" "$HOME"/.config/foot/foot.ini
  # theme kitty
  sed -i "s|${1}Theme|${2}Theme|g" "$HOME"/.config/kitty/kitty.conf
  killall -SIGUSR1 kitty
  # Atom
  sed -i "s|${1}|${2}|g" "$HOME"/.atom/config.cson
  # theme swayidle & swaylock
  sed -i "s|${1}|${2}|g" "$HOME"/.config/sway/swayidle
  sed -i "s|${1}|${2}|g" "$HOME"/.config/sway/swaylock
  # theme sway
  sed -i "s|${1}Theme|${2}Theme|g" "$HOME"/.config/sway/config
  capitalizedCurr1="$(tr '[:lower:]' '[:upper:]' <<<${1:0:1})${1:1}"
  capitalizedCurr2="$(tr '[:lower:]' '[:upper:]' <<<${2:0:1})${2:1}"
  sed -i "s|Papirus-$capitalizedCurr1|Papirus-$capitalizedCurr2|g" "$HOME"/.config/sway/config
  sed -i "s|${1}Fuzzel|${2}Fuzzel|g" "$HOME"/.config/sway/config
  sed -i "s|wallpaper/${1}|wallpaper/${2}|g" "$HOME"/.config/sway/config
  sed -i "s|$theme|$newTheme|g" "$HOME"/.config/sway/config
  sway reload 1>/dev/null
  python "$HOME"/.config/themes/themeSway.py "${1}"
  sway reload 1>/dev/null
  # theme bemenu
  sed -i "s|${1}Bemenu|${2}Bemenu|g" "$HOME"/.config/scripts/bash/bemenupower.sh
  sed -i "s|${1}Bemenu|${2}Bemenu|g" "$HOME"/.config/scripts/bash/bemenuscreenrecord.sh
  sed -i "s|${1}Bemenu|${2}Bemenu|g" "$HOME"/.config/scripts/bash/bemenuscreenshot.sh
  # theme ncmcpp
  ncmcpp "$1"
  # theme mako
  mako "$1"
  # theme zathura
  sed -i "s|${1}Theme|${2}Theme|g" "$HOME"/.config/zathura/zathurarc
  # theme nvim
  sed -i "s/\"${1}\"/\"${2}\"/g" "$HOME"/.config/nvim/lua/pluginList.lua
  nvim +PackerCompile +qall!
}

ncmcpp() {
  if [[ $1 = "light" ]]; then
    sed -i 's/black/white/g' "$HOME"/.config/ncmpcpp/config
  else
    sed -i 's/white/black/g' "$HOME"/.config/ncmpcpp/config
  fi
}

bpytop() {
  if [[ $1 = "light" ]]; then
    sed -i 's/flat-remix-light/default/g' "$HOME"/.config/bpytop/bpytop.conf
  else
    sed -i 's/default/flat-remix-light/g' "$HOME"/.config/bpytop/bpytop.conf
  fi
}

mako() {
  if [[ $1 = "light" ]]; then
    sed -i 's/background-color=#f5f5f5/background-color=#333333/g' "$HOME"/.config/mako/config
    sed -i 's/text-color=#242424/text-color=#dedede/g' "$HOME"/.config/mako/config
    sed -i 's/border-color=#242424/border-color=#dedede/g' "$HOME"/.config/mako/config
    sed -i 's/progress-color=#5895f9/progress-color=#0860f2/g' "$HOME"/.config/mako/config
  else
    sed -i 's/background-color=#333333/background-color=#f5f5f5/g' "$HOME"/.config/mako/config
    sed -i 's/text-color=#dedede/text-color=#242424/g' "$HOME"/.config/mako/config
    sed -i 's/border-color=#dedede/border-color=#242424/g' "$HOME"/.config/mako/config
    sed -i 's/progress-color=#0860f2/progress-color=#5895f9/g' "$HOME"/.config/mako/config
  fi
  makoctl reload
}
theme "$1" "$2"
