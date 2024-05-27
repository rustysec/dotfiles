#!/usr/bin/env bash

niri msg action $2
pkill -SIGRTMIN+$1 waybar
