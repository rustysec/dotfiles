#!/usr/bin/env bash

for file in `ls $HOME/.config/waybar/config.niri-*`; do
    waybar -c $file & 
done
