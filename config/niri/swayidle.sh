#!/usr/bin/env bash
swayidle -w \
    timeout 300 '~/.config/sway/lock.sh' \
    timeout 600 'niri msg action power-off-monitors' \
    before-sleep '~/.config/sway/lock.sh' 

