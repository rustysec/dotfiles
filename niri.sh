#!/usr/bin/env bash

DISTRO=`lsb_release -a | grep Description | awk '{print $2}' | tr A-Z a-z`

current_dir=`pwd`

if [ -e ./distro/$DISTRO/niri.sh ];
then
    echo "- Running $DISTRO niri setup"
    ./distro/$DISTRO/niri.sh
else
    echo "- Generic niri $DISTRO"
fi

mkdir -p ~/pkgs
git clone https://github.com/yalter/niri ~/pkgs/niri
cd ~/pkgs/niri

if command -v systemctl;
then
    cargo build --release
    sudo cp resources/niri.service /usr/lib/systemd/user/
    sudo cp resources/niri-shutdown.target /usr/lib/systemd/user/
else
    cargo build --no-default-features --features=dbus,xdp-gnome-screencast --release
fi

sudo cp target/release/niri /usr/bin/
sudo cp resources/niri-session /usr/bin/
sudo cp resources/niri.desktop /usr/share/wayland-sessions/
sudo cp resources/niri-portals.conf /usr/share/xdg-desktop-portal/
