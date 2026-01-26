#!/usr/bin/env bash

if [ "$1" = "up" ]; then
    if [ -e /sys/class/backlight/amdgpu_bl1 ]; then
        brightnessctl -d amdgpu_bl1 set "5%+"
    else
        brightnessctl set "5%+"
    fi

elif [ "$1" = "down" ]; then
    if [ -e /sys/class/backlight/amdgpu_bl1 ]; then
        brightnessctl -d amdgpu_bl1 set "5%-"
    else
        brightnessctl set "5%-"
    fi

else
    echo "Usage: $0 [up|down]"
fi
