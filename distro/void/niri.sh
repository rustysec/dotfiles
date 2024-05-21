#!/usr/bin/env bash

sudo xbps-install -Sy \
    pkg-config glib-devel eudev-libudev-devel libudev0-shim \
    gdk-pixbuf-devel cairo-devel libseat-devel pango-devel \
    pipewire-devel libinput-devel libgbm-devel libxkbcommon-devel \
    xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring \
    gobject-introspection gjs gjs-devel gtk+3-devel pulseaudio-devel pam-devel \
    upower

echo '#!/bin/sh
eval $(ssh-agent -s) 2>/dev/null >/dev/null
niri --session 2>/dev/null >/dev/null' | sudo tee /etc/greetd/niri.sh
sudo chmod +x /etc/greetd/niri.sh

echo "exec swaybg -m fill --image /etc/greetd/background.jpg
exec \"wlgreet --command /etc/greetd/niri.sh; swaymsg exit\"
bindsym Mod4+shift+e exec swaynag \
	-t warning \
	-m 'What do you want to do?' \
	-b 'Poweroff' 'loginctl poweroff' \
	-b 'Reboot' 'loginctl reboot'" | sudo tee /etc/greetd/niri-config

echo '[terminal]
vt = 7
[default_session]
command = "sway --config /etc/greetd/niri-config"
user = "_greeter"

[initial_session]
command = "/etc/greetd/niri.sh"
user = "russ"' | sudo tee /etc/greetd/config.toml
