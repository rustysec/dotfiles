#!/usr/bin/env bash

niri msg action do-screen-transition -d 0 ; niri msg action $2
pkill -SIGRTMIN+$1 waybar
