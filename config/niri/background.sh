#!/usr/bin/env bash
# swaybg -m fill -i ~/.config/sway/background.jpg
# swaybg -c 282a36
# swaybg -m fill -i /usr/share/wallpapers/Next/contents/images_dark/5120x2880.png
swww-daemon &
swww-daemon -n overview &
sleep 2
swww img  /usr/share/wallpapers/Next/contents/images_dark/5120x2880.png &
swww img -n overview /usr/share/wallpapers/Next/contents/images_dark/5120x2880.png &
