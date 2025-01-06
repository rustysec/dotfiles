#!/usr/bin/env bash
terminal=""
extra=""
cmd="-e toolbox run tmux new"

for t in wezterm alacritty konsole
do
    if command -v $t >/dev/null; then
        terminal=$t
        break
    fi
done

if ! command -v toolbox >/dev/null; then
   cmd="-e tmux new"
fi

if [ "$1" = "--light" ]; then
    if [ "$terminal" = "wezterm" ]; then
        extra="--config color_scheme='dayfox'"
    elif [ "$terminal" = "konsole" ]; then
        extra="--profile Russ-Light"
    else
        extra="--config-file $HOME/.config/alacritty/light.toml"
    fi
elif [ "$1" = "--vanilla" ]; then
    cmd=""
fi

$terminal $extra $cmd
