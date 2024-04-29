#!/usr/bin/env bash

sudo xbps-install -Sy \
    zsh \
    tmux \
    wget curl \
    dbus tlp \
    polkit ntpd-rs swtpm \
    pipewire wireplumber \
    elogind seatd greetd wlgreet plymouth ripgrep grim slurp \
    sway swaylock swayidle Waybar mako fuzzel kanshi foot light mesa-dri wl-clipboard \
    pavucontrol pamixer Thunar \
    psutils psmisc powertop \
    zip unzip \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    mate-polkit \
    font-hack-ttf nerd-fonts font-awesome6 \
    papirus-icon-theme \
    blueman libspa-bluetooth bluez \
    NetworkManager NetworkManager-openconnect network-manager-applet \
    libvirt virt-manager podman qemu \
    gcc cross-x86_64-w64-mingw32 cross-i686-w64-mingw32 \
    nodejs \
    xwininfo openssl-devel \
    flatpak firefox

if [[ $(grep Intel /proc/cpuinfo) == "" ]];
then
    sudo xbps-install -Sy \
        linux-firmware-amd \
        mesa-vdpau mesa-vaapi
else
    sudo xbps-install -Sy \
        void-repo-nonfree \
        intel-ucode \
        linux-firmware-intel \
        intel-video-accel
fi

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo usermod -a -G wheel,video,input,bluetooth,libvirt $(whoami)

sudo mkdir /etc/containers/registries.conf.d
echo 'unqualified-search-registries=["docker.io"]' | sudo tee /etc/containers/registries.conf.d/10-unqualified-search-registries.conf

sudo plymouth-set-default-theme -R bgrt

sudo mkdir -p /etc/sv/stop-plymouth/log
sudo ln -s /run/runit/supervise.stop-plymouth /etc/sv/stop-plymouth/supervise
echo '#!/bin/sh' | sudo tee -a /etc/sv/stop-plymouth/run
echo 'plymouth quit || exit 1' | sudo tee -a /etc/sv/stop-plymouth/run
sudo chmod +x /etc/sv/stop-plymouth/run

SERVICES=(
    "acpid"
    "dbus"
    "elogind"
    "polkitd"
    "NetworkManager"
    "libvirtd"
    "virtlogd"
    "bluetoothd"
    "tlp"
    "ntpd"
    "stop-plymouth"
)

for service in ${SERVICES[@]};
do
    sudo ln -s /etc/sv/$service /var/service
done
