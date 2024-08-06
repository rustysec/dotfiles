#!/usr/bin/env bash

dir=`dirname $0`
hostname=`hostname`
distro=`lsb_release -a | grep Description | awk '{print $2}' | tr A-Z a-z`
cursor_theme='breeze_cursors'

cat $dir/config.kdl.base > ~/.config/niri/config.kdl
cat $dir/config.kdl.$hostname >> ~/.config/niri/config.kdl 2>/dev/null


if [ "$distro" == "void" ]; then
    cursor_theme='Breeze_Obsidian'
fi

sed -i "s/__CURSOR_THEME__/$cursor_theme/g" ~/.config/niri/config.kdl
