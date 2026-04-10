#!/usr/bin/env bash

DEVICE=$(ls /sys/class/backlight | head -n1)
MAX=$(brightnessctl -d $DEVICE max)

brightness=$(echo "scale=2; $(brightnessctl -d $DEVICE g) / $(brightnessctl -d $DEVICE m) * 100" | bc | cut -d'.' -f1)
echo "$brightness% 󰃞"

while true; do
    inotifywait -e modify /sys/class/backlight/$DEVICE/actual_brightness >/dev/null 2>&1 3>&1
    brightness=$(echo "scale=2; $(brightnessctl -d $DEVICE g) / $(brightnessctl -d $DEVICE m) * 100" | bc | cut -d'.' -f1)
    echo "$brightness% 󰃞"
done
