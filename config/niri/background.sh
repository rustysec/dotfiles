#!/usr/bin/env bash
# swaybg -m fill -i ~/.config/sway/background.jpg
# swaybg -c 282a36
swww-daemon -n overview &
swww img -n overview /usr/share/wallpapers/Next/contents/images_dark/5120x2880.png &
swaybg -m fill -i /usr/share/wallpapers/Next/contents/images_dark/5120x2880.png
