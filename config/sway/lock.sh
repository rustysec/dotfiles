#!/usr/bin/env bash
dms ipc call lock lock || swaylock || gtklock -d 2>/dev/null
