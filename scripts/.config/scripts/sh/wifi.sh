#!/bin/sh
# Description: manage network with iwctl
# Dependencies: dmenu, iwd
# Shell: POSIX compliant
# Author: @mortezadadgar

INTERFACE="wlan0"

. "$HOME"/.config/scripts/sh/bemenu_theme

# menu
menu() {
    bemenu -i -l 10 --prompt="Wifi menu" --fn "$font" $theme
}

SELECT=$(printf "Connect to a network\nDisconnect current network\nForget a network" | menu)

case $SELECT in
"Connect to a network")
    notify-send "IWCTL" "searching for networks" -i wifi-radar
    iwctl station "$INTERFACE" scan

    # Give enough time to iwctl to find networks
    sleep 3

    networks=$(
        iwctl station "$INTERFACE" get-networks |
            sed 's/>//g' |
            sed 's/\x1b\[[0-9;]*m//g' |
            tail -n +5 | head -n -1 |
            awk '{print $1}' |
            sort
    )

    [ -z "$networks" ] && notify-send "IWCTL" "No access point found!" -i \
        notification-network-wireless-disconnected && exit 1

    network=$(echo "$networks" | dmenu -l 6)

    [ -z "$network" ] && exit 1

    password=$(printf 'No\nYes' | dmenu -p "Password required?")

    [ -z "$password" ] && exit 1

    if [ "$password" = "No" ]; then
        iwctl station "$INTERFACE" connect "$network" &&
            notify-send "IWCTL" "Connected to $network" -i wifi-radar && exit 0

        # failure
        notify-send "IWCTL" "Failed connecting to $network" \
            -i notification-network-wireless-disconnected
    elif [ "$password" = "Yes" ]; then
        dmenu -p "enter password" -P <&- |
            xargs -r -I{} iwctl station -P {} "$INTERFACE" connect "$network" &&
            notify-send "IWCTL" "Connected to $network" -i wifi-radar && exit 0

        # failure
        notify-send "IWCTL" "Failed connecting to $network" \
            -i notification-network-wireless-disconnected
    else
        notify-send "IWCTL" "Please select between two options" \
            -i system-error
    fi

    ;;
"Disconnect current network")
    iwctl station "$INTERFACE" disconnect
    ;;
"Forget a network")
    networks=$(
        iwctl known-networks list |
            iwctl station "$INTERFACE" get-networks |
            sed 's/>//g' |
            sed 's/\x1b\[[0-9;]*m//g' |
            tail -n +5 | head -n -1 |
            awk '{print $1}' |
            sort
    )

    [ -z "$networks" ] && notify-send "IWCTL" "No access point found!" \
        -i notification-network-wireless-disconnected && exit 1

    network=$(echo "$networks" | dmenu -l 6)

    [ -z "$network" ] && exit 1

    iwctl known-networks "$network" forget
    ;;
esac
