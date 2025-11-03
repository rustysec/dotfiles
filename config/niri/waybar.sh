#!/usr/bin/env bash

sleep 2
waybar -c ~/.config/waybar/config.niri > ~/waybar.log 2>&1 &
