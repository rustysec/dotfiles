#!/usr/bin/env bash
dms ipc call lock lock || gtklock -d 2>/dev/null || swaylock
