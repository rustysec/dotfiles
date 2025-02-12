#!/usr/bin/env bash

##############
# UI Themes

curl \
    -L https://raw.githubusercontent.com/openSUSE/branding/ad4557bc2a9b5e1ed56556eac9685ee8a3211719/raw-theme-drop/desktop-1920x1080.svg \
    -o ~/.config/sway/lockscreen.svg
magick ~/.config/sway/lockscreen.svg ~/.config/sway/lockscreen.jpg

curl \
    -L https://raw.githubusercontent.com/openSUSE/branding/ad4557bc2a9b5e1ed56556eac9685ee8a3211719/raw-theme-drop/desktop-1920x1080.svg \
    -o ~/.config/sway/background.svg
magick ~/.config/sway/background.svg ~/.config/sway/background.jpg
