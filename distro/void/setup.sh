#!/usr/bin/env bash

current_dir=$(pwd)

sudo xbps-install -Sy \
    void-repo-multilib \
    zsh tmux wget curl \
    dbus tlp polkit ntpd-rs socklog-void cronie \
    swtpm pipewire wireplumber vulkan-loader \
    elogind seatd greetd wlgreet plymouth ripgrep grim slurp \
    sway swaylock swayidle Waybar mako fuzzel kanshi foot brightnessctl mesa-dri wl-clipboard \
    pavucontrol pamixer Thunar libavcodec ffmpeg \
    psmisc powertop \
    zip unzip jq python3-i3ipc \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk mate-polkit \
    font-hack-ttf nerd-fonts font-awesome6 papirus-icon-theme gsfonts \
    blueman libspa-bluetooth bluez \
    NetworkManager NetworkManager-openconnect network-manager-applet \
    libvirt virt-manager podman qemu \
    gcc cross-x86_64-w64-mingw32 cross-i686-w64-mingw32 \
    nodejs clang clang-analyzer clang-tools-extra \
    xwininfo openssl-devel lua-language-server \
    flatpak firefox samba gvfs gvfs-smb \
    cmake make faketime libcurl-devel \
    cups avahi nss-mdns xmirror sof-firmware \
    meson gobject-introspection gjs gjs-devel gtk+3-devel \
    pam-devel pulseaudio-devel

sudo xbps-install -Sy \
    wine wine-32bit

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

sudo usermod -a -G wheel,video,input,bluetooth,libvirt,lpadmin $(whoami)

##############
# podman setup
sudo mkdir /etc/containers/registries.conf.d
echo 'unqualified-search-registries=["docker.io"]' | sudo tee /etc/containers/registries.conf.d/10-unqualified-search-registries.conf
sudo ln -s `which podman` /usr/sbin/docker

##############
# plymouth setup
sudo plymouth-set-default-theme -R bgrt

sudo mkdir -p /etc/sv/stop-plymouth/log
sudo ln -s /run/runit/supervise.stop-plymouth /etc/sv/stop-plymouth/supervise
echo '#!/bin/sh
plymouth quit || exit 1' | sudo tee /etc/sv/stop-plymouth/run
sudo chmod +x /etc/sv/stop-plymouth/run

echo '[terminal]
vt = 7
[default_session]
command = "sway --config /etc/greetd/sway-config"
user = "_greeter"

[initial_session]
command = "/etc/greetd/sway.sh"
user = "russ"' | sudo tee /etc/greetd/config.toml

echo '[border]
red = 0.45
green = 0.78
blue = 0.925
opacity = 1.0' | sudo tee /etc/greetd/wlgreet.toml

##############
# powertop setup
sudo mkdir -p /etc/sv/powertop/log
sudo ln -s /run/runit/supervise.powertop /etc/sv/powertop/supervise
echo '#!/bin/sh
powertop --auto-tune || exit 1' | sudo tee /etc/sv/powertop/run
sudo chmod +x /etc/sv/powertop/run

##############
# lock before sleep
echo '#!/usr/bin/env bash
pkill -USR1 swayidle' | sudo tee /etc/zzz.d/suspend/90-swayidle.sh
sudo chmod +x /etc/zzz.d/suspend/90-swayidle.sh

##############
# fstrim setup
echo '#!/bin/sh
fstrim /' | sudo tee /etc/cron.weekly/fstrim

##############
# markdown lsp
mkdir -p ~/.local/bin
curl \
    -L https://github.com/artempyanykh/marksman/releases/download/2023-12-09/marksman-linux-x64 \
    -o ~/.local/bin/marksman
chmod +x ~/.local/bin/marksman

##############
# osslsigncode
mkdir -p ~/pkgs
git clone https://github.com/mtrojnar/osslsigncode ~/pkgs/osslsigncode
mkdir -p ~/pkgs/osslsigncode/build
cd ~/pkgs/osslsigncode/build && cmake -S .. && cmake --build . && mv osslsigncode ~/.local/bin
cd $current_dir

##############
# shell aliases 
echo "alias xi='sudo xbps-install'" >> ~/.zshrc
echo "alias xr='sudo xbps-remove'" >> ~/.zshrc

##############
# finish up!
SERVICES=(
    "acpid"
    "dbus"
    "polkitd"
    "NetworkManager"
    "libvirtd"
    "virtlogd"
    "bluetoothd"
    "tlp"
    "ntpd"
    "stop-plymouth"
    "smbd"
    "nmbd"
    "socklog-unix"
    "nanoklogd"
    "cronie"
    "cupsd"
    "avahi-daemon"
)

for service in ${SERVICES[@]};
do
    if ! test -L /var/service/$service; then
        sudo ln -s /etc/sv/$service /var/service
    fi
done
