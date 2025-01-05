#!/usr/bin/env bash

if [ ! -z "$(sway --version 2>/dev/null | grep fx)" ]; then
    echo "Applying SwayFX configs"
    swaymsg corner_radius 8
    swaymsg blur enable
    swaymsg blur_passes 5
    # swaymsg blur_noise 0.5
    # swaymsg blur_brightness 1
    # swaymsg blur_contrast 1
    # swaymsg blur_saturation 1

    # swaymsg layer_effects 'launcher' 'blur enable ; blur_passes 5'
    # swaymsg layer_effects 'gtk-layer-shell' 'blur enable ; blur_passes 5'
else
    echo "SwayFX not detected"
fi
