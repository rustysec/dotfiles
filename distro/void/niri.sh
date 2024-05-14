#!/usr/bin/env bash
#
echo '#!/bin/sh
eval $(ssh-agent -s) 2>/dev/null >/dev/null
niri- --session 2>/dev/null >/dev/null' | sudo tee /etc/greetd/niri.sh
sudo chmod +x /etc/greetd/niri.sh

echo "exec swaybg -m fill --image /etc/greetd/background.jpg
exec \"wlgreet --command /etc/greetd/niri.sh; swaymsg exit\"
bindsym Mod4+shift+e exec swaynag \
	-t warning \
	-m 'What do you want to do?' \
	-b 'Poweroff' 'loginctl poweroff' \
	-b 'Reboot' 'loginctl reboot'
include /etc/sway/config.d/*" | sudo tee /etc/greetd/niri-config

echo '[terminal]
vt = 7
[default_session]
command = "sway --config /etc/greetd/niri-config"
user = "_greeter"

[initial_session]
command = "/etc/greetd/niri.sh"
user = "russ"' | sudo tee /etc/greetd/config.toml

echo '[border]
red = 0.45
green = 0.78
blue = 0.925
opacity = 1.0' | sudo tee /etc/greetd/wlgreet.toml
