#!/usr/bin/env bash

OUTPUTS=$(niri msg -j outputs | jq 'keys[]' | sed 's/"//g')

for output in "${OUTPUTS[@]}";
do
    input="$PWD/config.niri.template"
    file="$HOME/.config/waybar/config.niri-$output"
    echo "copying $input to $file"
    cp $input $file
    sed -i "s/__OUTPUT__/$output/g" $file
done
