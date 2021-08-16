# Default browser
export BROWSER=firefox

# theme manager
exec python -OO $HOME/.config/themes/main.py &

# start sway in tty1
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec env _JAVA_AWT_WM_NONREPARENTING=1 sway 1>/dev/null 2>/dev/null
fi
