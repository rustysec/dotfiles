#!/usr/bin/env bash

sudo xbps-install -Sy \
    zsh \
    tmux \
    wget curl \
    dbus tlp \
    polkit ntpd-rs \
    pipewire wireplumber \
    elogind seatd greetd \
    sway swaylock swayidle Waybar mako fuzzel kanshi foot light mesa-dri wl-clipboard \
    pavucontrol pamixer \
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
    void-repo-nonfree intel-ucode \
    flatpak firefox

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.google.Chrome

sudo usermod -a -G wheel,video,input,bluetooth,libvirt $(whoami)

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
)

for service in ${SERVICES[@]};
do
    sudo ln -s /etc/sv/$service /var/service
done
