#!/usr/bin/env bash

sudo zypper install -y \
    sway swayidle swaylock mako fuzzel kanshi foot waybar grim slurp brightnessctl \
    greetd wlgreet \
    pipewire wireplumber \
    zip unzip jq \
    hack-fonts fontawesome-fonts \
    zsh tmux wget curl pavucontrol

##############
# Hack Nerd Fonts
mkdir -p ~/.local/share/fonts
curl \
    -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip \
    -o ~/.local/share/fonts/hack.zip
unzip ~/.local/share/fonts/hack.zip -d ~/.local/share/fonts
rm ~/.local/share/fonts/hack.zip
