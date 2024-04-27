#!/usr/bin/env bash

sudo xbps-install -Sy \
    zsh \
    tmux \
    wget curl \
    dbus \
    polkit \
    pipewire wireplumber \
    elogind seatd \
    sway swaylock Waybar mako fuzzel kanshi foot \
    psutils psmisc \
    zip unzip \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    mate-polkit \
    font-hack-ttf nerd-fonts font-awesome6 \
    papirus-icon-theme \
    blueman libspa-bluetooth bluez \
    NetworkManager NetworkManager-openconnect nework-manager-applet \
    libvirt virt-manager podman \
    gcc cross-x86_64-w64-mingw32 cross-i686-w64-mingw32 \
    xwininfo \
    firefox

sudo usermod -a -G wheel video input bluetooth libvirt $(whoami)

SERVICES=(
    "dbus"
    "elogind"
    "polkitd"
    "NetworkManager"
    "libvirtd"
    "bluetoothd"
)

for service in ${SERVICES[@]};
do
    sudo ln -s /etc/sv/$service /var/service
done
