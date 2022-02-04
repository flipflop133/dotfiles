#!/bin/sh
time=30
if [ "$1" ]; then
  time=$1
fi
while [ "$time" -gt 0 ]; do
  notify-send "羽" "Pomodoro: $time minute(s) left" -t 60000 -c font-icon
  systemd-inhibit sleep 1m
  time=$((time - 1))
done
notify-send "" "Well done! It's time for a 5 minutes break!" -t 60000 -c font-icon
