#!/usr/bin/env bash

DEVICE=""
FIFO="$XDG_RUNTIME_DIR/brightness.wob"

if [ -e /sys/class/backlight/amdgpu_bl1 ]; then
    DEVICE="-d amdgpu_bl1"
fi

if [ "$1" = "up" ]; then
    brightnessctl $DEVICE set "5%+"

elif [ "$1" = "down" ]; then
    brightnessctl $DEVICE set "5%-"

else
    echo "Usage: $0 [up|down]"
fi

if [ -e "$FIFO" ]; then
    echo "scale=2; $(brightnessctl $DEVICE g) / $(brightnessctl $DEVICE m) * 100" | bc | cut -d'.' -f1 > $FIFO
fi
