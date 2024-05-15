#!/usr/bin/env bash

function setup_bars() {
    PATH=$PATH:~/.npm-global/bin
    ags -q 2>/dev/null || true
    ags &
}

setup_bars

MONITORS=`niri msg outputs | grep Output | wc -l`

while true
do
    CURRENT=`niri msg outputs | grep Output | wc -l`
    if [[ $CURRENT -gt $MONITORS ]]; then
        echo "New monitor config!"
        setup_bars
    fi

    MONITORS=$CURRENT

    sleep 3
done
