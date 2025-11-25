#!/usr/bin/env bash

dir=`dirname $0`
hostname=`hostname`
distro=`lsb_release -a 2>/dev/null | grep Description | awk '{print $2}' | tr A-Z a-z || "Unknown"`
cursor_theme='breeze_cursors'
# cursor_theme='Adwaita'

cat $dir/config.kdl.base > ~/.config/niri/config.kdl
cat $dir/config.kdl.$hostname >> ~/.config/niri/config.kdl 2>/dev/null

if [ "$distro" == "void" ]; then
    # cursor_theme='Breeze_Obsidian'
    cursor_theme='breeze_cursors'
fi

sed -i "s/__CURSOR_THEME__/$cursor_theme/g" ~/.config/niri/config.kdl
