#!/usr/bin/env bash

for file in `ls ~/.config/waybar/config.niri-*`; do
    waybar -c $file & 
done
