#!/usr/bin/env bash

DISTRO=`lsb_release -a | grep Description | awk '{print $2}' | tr A-Z a-z`

if [ -e ./distro/$DISTRO/setup.sh ];
then
    echo "- Running $DISTRO setup"
    ./distro/$DISTRO/setup.sh
else
    echo "! Unknown setup distro $DISTRO"
fi

./setup/configs.sh
./setup/flatpak.sh
./setup/git.sh
./setup/greetd.sh
./setup/npm.sh
./setup/rust.sh
./setup/sway.sh
./setup/tmux.sh
# ./setup/ui.sh
./setup/zsh.sh
