#!/usr/bin/env bash

BAT_PERC=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i 'percentage:' | awk '{print $2}'`
BAT_TIME=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i 'time to empty:' | cut -d: -f2 | sed -e 's/^\s*//'`
TIME=`date`
WIFI=`nmcli conn show | grep wifi | awk '{print $1}'`
BRIGHTNESS=`brightnessctl -P get`

echo "
Date:       $TIME
Battery:    $BAT_PERC ($BAT_TIME)
Wifi:       $WIFI
Brightness: $BRIGHTNESS%
" | fuzzel -p '' -d > /dev/null
