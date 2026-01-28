#!/usr/bin/env bash

BRIGHTNESS_FIFO="$XDG_RUNTIME_DIR/brightness.wob"
VOLUME_FIFO="$XDG_RUNTIME_DIR/volume.wob"

FIFOS=(
    $BRIGHTNESS_FIFO
    $VOLUME_FIFO
)

for fifo in "${FIFOS[@]}"; do
    if [ -e $fifo ]; then
        rm $fifo
    fi

    mkfifo $fifo

    tail -f $fifo | wob &
done
