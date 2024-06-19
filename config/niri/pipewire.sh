#!/usr/bin/env bash

if command -v systemctl;
then
    # systemd should handle this
    echo "systemd, do your thing"
else
    ITEMS=("pipewire" "pipewire-pulse" "wireplumber")

    for item in ${ITEMS[@]}; do
        killall -9 $item 2>&1 >/dev/null
    done

    for item in ${ITEMS[@]}; do
        $item 2>&1 >/dev/null &
    done
fi
