#!/usr/bin/env bash

current_dir=$(pwd)

sudo xbps-install -Sy \
    void-repo-multilib \
    zsh tmux wget curl \
    dbus tlp polkit ntpd-rs \
    swtpm pipewire wireplumber \
    elogind seatd greetd wlgreet plymouth ripgrep grim slurp \
    sway swaylock swayidle Waybar mako fuzzel kanshi foot light mesa-dri wl-clipboard \
    pavucontrol pamixer Thunar \
    psmisc powertop \
    zip unzip jq \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk mate-polkit \
    font-hack-ttf nerd-fonts font-awesome6 papirus-icon-theme \
    blueman libspa-bluetooth bluez \
    NetworkManager NetworkManager-openconnect network-manager-applet \
    libvirt virt-manager podman qemu \
    gcc cross-x86_64-w64-mingw32 cross-i686-w64-mingw32 \
    nodejs clang clang-analyzer clang-tools-extra \
    xwininfo openssl-devel \
    flatpak firefox samba gvfs gvfs-smb \
    cmake make faketime libcurl-devel

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

sudo usermod -a -G wheel,video,input,bluetooth,libvirt $(whoami)

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

##############
# greetd/wlgreet
echo '#!/bin/sh
eval $(ssh-agent -s)
dbus-run-session sway' | sudo tee /etc/greetd/sway.sh
sudo chmod +x /etc/greetd/sway.sh

echo "exec \"wlgreet --command /etc/greetd/sway.sh; swaymsg exit\"
bindsym Mod4+shift+e exec swaynag \
	-t warning \
	-m 'What do you want to do?' \
	-b 'Poweroff' 'systemctl poweroff' \
	-b 'Reboot' 'systemctl reboot'
include /etc/sway/config.d/*" | sudo tee /etc/greetd/sway-config

echo '[terminal]
vt = 7
[default_session]
command = "sway --config /etc/greetd/sway-config"
user = "_greeter"' | sudo tee /etc/greetd/config.toml

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
)

for service in ${SERVICES[@]};
do
    sudo ln -s /etc/sv/$service /var/service
done
