#!/usr/bin/env bash
OPT=$(grep profile ~/.config/kanshi/config | awk '{print $2}' | fuzzel -d -l 6)

kanshictl switch $OPT
