#!/usr/bin/env bash

for file in `ls $HOME/.config/waybar/config.niri-*`; do
    # waybar -c $file 2>&1 >/dev/null & 
    waybar -c $file  & 
done
