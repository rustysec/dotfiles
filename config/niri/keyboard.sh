#!/usr/bin/env bash
LINES=$(niri msg keyboard-layouts | wc -l)
OPT=$(niri msg keyboard-layouts | tail -n +2 | sed 's/\*//' | sed 's/^[[:space:]]*//' | fuzzel -d -l $LINES | xargs)

if [[ -n "$OPT" ]]; then
    niri msg action switch-layout $(echo $OPT | awk '{print $1}')
fi
