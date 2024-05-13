#!/usr/bin/env bash
swayidle -w timeout 300 'swaylock' timeout 600 'niri msg action power-off-monitors' before-sleep 'swaylock' 

