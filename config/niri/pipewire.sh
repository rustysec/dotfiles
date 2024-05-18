#!/usr/bin/env bash

ITEMS=("pipewire" "pipewire-pulse" "wireplumber")

for item in ${ITEMS[@]}; do
    killall -9 $item
done

for item in ${ITEMS[@]}; do
    $item &
done
