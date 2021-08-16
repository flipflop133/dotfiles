#!/bin/bash

# install wmctrl. Its a prerequisite to make this script work.

# Launch it in your i3 config file
# exec --no-startup-id ~/.config/i3/startup_apps.sh

# Save default IFS value
DefaultIFS=$IFS

## WORKSPACE 2 UNIVERSITY ##
# Apps to start
apps=(	
 "thunderbird"
)

# Which workspace to assign your wanted App :
workspaces=(
"2:  "
)
# open the apps
for app in "${apps[@]}"
do
	# Set IFS to '' so spaces are not ignored
	IFS=''
    i3-msg workspace ${workspaces} # move in wanted workspace
    # Reset IFS to its default value for apps commands
    IFS=$DefaultIFS
    exec $app & # start the wanted app
    sleep 3s
done

# wait a moment
sleep 4s

## WORKSPACE 3 SOCIAL ##
# Apps to start
apps=(	
 "firefox https://www.messenger.com/"
 "firefox https://www.facebook.com/"
 "discord"
 "telegram-desktop"
)

# Which workspace to assign your wanted App :
workspaces=(
"3:  "
)
# open the apps
for app in "${apps[@]}"
do
	# Set IFS to '' so spaces are not ignored
	IFS=''
    i3-msg workspace ${workspaces} # move in wanted workspace
    # Reset IFS to its default value for apps commands
    IFS=$DefaultIFS
    exec $app & # start the wanted app
    sleep 3s
done

# wait a moment
sleep 4s

## WORKSPACE 4 MEDIA ##
# Apps to start
apps=(	
 "spotify"
)

# Which workspace to assign your wanted App :
workspaces=(
"4: ﱘ "
)
# open the apps
for app in "${apps[@]}"
do
	# Set IFS to '' so spaces are not ignored
	IFS=''
    i3-msg workspace ${workspaces} # move in wanted workspace
    # Reset IFS to its default value for apps commands
    IFS=$DefaultIFS
    exec $app & # start the wanted app
    sleep 3s
done


# wait a moment
sleep 4s
