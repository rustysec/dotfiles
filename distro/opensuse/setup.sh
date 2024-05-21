#!/usr/bin/env bash

sudo zypper install -y \
    sway swayidle swaylock mako fuzzel kanshi foot waybar grim slurp brightnessctl \
    greetd wlgreet \
    pipewire wireplumber \
    zip unzip jq \
    hack-fonts fontawesome-fonts \
    zsh tmux wget curl pavucontrol \
    make cmake power-profiles-daemon powertop \
    NetworkManager-applet NetworkManager-applet-openconnect NetworkManager-openconnect \
    blueman papirus-icon-theme

##############
# Hack Nerd Fonts
mkdir -p ~/.local/share/fonts
curl \
    -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip \
    -o ~/.local/share/fonts/hack.zip
unzip ~/.local/share/fonts/hack.zip -d ~/.local/share/fonts
rm ~/.local/share/fonts/hack.zip

echo '[terminal]
vt = 1
[default_session]
command = "sway --config /etc/greetd/sway-config"
user = "greeter"
[initial_session]
command = "/etc/greetd/sway.sh"
user = "russ"' | sudo tee /etc/greetd/config.toml
