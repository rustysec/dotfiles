#!/usr/bin/env bash

##############
# greetd/wlgreet
sudo curl \
    -L https://w.wallhaven.cc/full/5w/wallhaven-5wwqg3.jpg \
    -o /etc/greetd/background.jpg

echo '#!/bin/sh
eval $(ssh-agent -s) 2>/dev/null >/dev/null
dbus-run-session sway 2>/dev/null >/dev/null' | sudo tee /etc/greetd/sway.sh
sudo chmod +x /etc/greetd/sway.sh

echo "exec swaybg -m fill --image /etc/greetd/background.jpg
exec \"wlgreet --command /etc/greetd/sway.sh; swaymsg exit\"
bindsym Mod4+shift+e exec swaynag \
	-t warning \
	-m 'What do you want to do?' \
	-b 'Poweroff' 'loginctl poweroff' \
	-b 'Reboot' 'loginctl reboot'" | sudo tee /etc/greetd/sway-config

echo '[border]
red = 0.45
green = 0.78
blue = 0.925
opacity = 1.0' | sudo tee /etc/greetd/wlgreet.toml
