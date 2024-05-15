#!/usr/bin/env bash
PATH=$PATH:~/.npm-global/bin
ags -q 2>/dev/null || true
killall -9 ags 2>/dev/null || true
ags -c ~/.config/ags/config.js &
