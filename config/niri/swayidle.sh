#!/usr/bin/env bash
swayidle -w \
    timeout 300 'niri msg action do-screen-transition ; ~/.config/sway/lock.sh' \
    timeout 600 'niri msg action power-off-monitors' \
    before-sleep 'niri msg action do-screen-transition ; ~/.config/sway/lock.sh' 

