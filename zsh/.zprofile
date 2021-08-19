# Default browser
export BROWSER="firefox"

# Default sudoeditor
export SUDO_EDITOR="nvim"

# Default editor
export EDITOR="nvim"

# start sway in tty1
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec env _JAVA_AWT_WM_NONREPARENTING=1 sway 1>/dev/null 2>/dev/null
fi
