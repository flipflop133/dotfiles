# Default browser
export BROWSER="firefox"

# Chrome
export CHROME_EXECUTABLE="chromium"

# Flutter
export PATH="$PATH:/home/francois/flutter/bin"

# Dart
export PATH="$PATH:/usr/lib/dart/bin"

# Default sudoeditor
export SUDO_EDITOR="nvim"

# Default editor
export EDITOR="nvim"

# Default terminal
export TERM="foot"

# Fix for java applications
export _JAVA_AWT_WM_NONREPARENTING=1

# Flutter
export FLUTTER="/flutter/bin"

# start sway in tty1
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec sway 1>/dev/null 2>/dev/null
fi
