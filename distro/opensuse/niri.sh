#!/usr/bin/env bash
sudo zypper in -y glib2-devel libudev-devel pipewire-devel clang-devel cairo-devel \
	pango-devel seatd-devel libxkbcommon-devel libinput-devel libgbm-devel greetd wlgreet \
    gtk3-devel libudev-devel pipewire-devel clang seatd-devel libgbm-devel libinput-devel

echo '#!/bin/sh
eval $(ssh-agent -s) 2>/dev/null >/dev/null
niri --session 2>/dev/null >/dev/null' | sudo tee /etc/greetd/niri.sh
sudo chmod +x /etc/greetd/niri.sh

echo '[terminal]
vt = 1
[default_session]
command = "sway --config /etc/greetd/niri-config"
user = "greeter"
[initial_session]
command = "/etc/greetd/niri.sh"
user = "russ"' | sudo tee /etc/greetd/config.toml

~/.config/niri/config.sh
