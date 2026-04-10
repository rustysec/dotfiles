#!/usr/bin/env bash

DEVICE=""
FIFO="$XDG_RUNTIME_DIR/volume.wob"

if [ "$1" = "up" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "0.02+" -l 1.0

elif [ "$1" = "down" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "0.02-" -l 1.0

elif [ "$1" = "mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ "toggle"

elif [[ "$1" == "mic-mute" || "$1" = "mute-mic" ]]; then
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ "toggle"

else
    echo "Usage: $0 [up|down|mute|mic-mute]"
fi

if [ -e "$FIFO" ]; then
    pamixer --get-volume > $FIFO
fi
