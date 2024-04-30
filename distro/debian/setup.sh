#!/usr/bin/env bash

current_dir=$(pwd)

sudo apt install -y \
    zsh tmux wget curl \
    dbus tlp \
    polkitd swtpm \
    pipewire wireplumber \
    elogind seatd greetd plymouth ripgrep grim slurp \
    sway swaylock swayidle waybar mako fuzzel kanshi foot light wl-clipboard libgl1-mesa-dri \
    mesa-va-drivers mesa-vdpau-drivers mesa-vulkan-drivers \
    pavucontrol pamixer thunar \
    psmisc powertop \
    zip unzip \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    mate-polkit \
    font-hack nerd-fonts \
    papirus-icon-theme \
    blueman libspa-bluetooth bluez \
    network-manager network-manager-openconnect network-manager-openconnect-gnome network-manager-applet \
    libvirt virt-manager podman qemu \
    gcc mingw-w64 \
    nodejs clang clang-tools \
    xwininfo libssl-dev \
    flatpak firefox \
    cmake make faketime

##############
# nerd fonts
mkdir -p ~/.local/share/fonts
curl \
    -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip \
    -o ~/.local/share/fonts/hack.zip
unzip -o ~/.local/share/fonts/hack.zip -d ~/.local/share/fonts
rm -f ~/.local/share/hack.zip

curl \
    -L https://use.fontawesome.com/releases/v6.5.2/fontawesome-free-6.5.2-desktop.zip \
    -o ~/.local/share/fonts/fontawesome6.zip
unzip -o ~/.local/share/fonts/fontawesome6.zip -d ~/.local/share/fonts
rm -f ~/.local/share/fontawesome6.zip

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
