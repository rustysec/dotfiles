#!/usr/bin/env bash

sudo xbps-install -Sy \
    zsh \
    tmux \
    wget \
    curl \
    dbus \
    polkit \
    pipewire \
    wireplumber \
    elogind
    seatd \
    sway \
    swaylock \
    Waybar \
    mako \
    fuzzel \
    kanshi \
    foot \
    psutils \
    psmisc \
    xdg-desktop-portal-wlr \
    xdg-desktop-portal-gtk \
    mate-polkit \
    font-hack-ttf \
    nerd-fonts

sudo usermod -a -G _seatd $(whoami)
