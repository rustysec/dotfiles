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
    zip \
    unzip \
    xdg-desktop-portal-wlr \
    xdg-desktop-portal-gtk \
    mate-polkit \
    font-hack-ttf \
    nerd-fonts \
    font-awesome6 \
    papirus-icon-theme

sudo usermod -a -G _seatd $(whoami)
sudo ln -s /etc/sv/dhcpd /var/service
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/elogind /var/service
sudo ln -s /etc/sv/polkitd /var/service
