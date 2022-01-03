# Browser
export BROWSER="firefox-beta"

# Editor
export SUDO_EDITOR="nvim"
export EDITOR="nvim"
export VISUAL="nvim"

# Terminal
export TERM="kitty"

# Font
export FONT="Open Sans"

# Fix for java applications
export _JAVA_AWT_WM_NONREPARENTING=1

# Flutter stuff
export FLUTTER="/flutter/bin"
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:/usr/lib/dart/bin"
export CHROME_EXECUTABLE="chromium"

# Start sway in tty1
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec sway 1>/dev/null 2>/dev/null
fi