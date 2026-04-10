#!/usr/bin/env bash
if [ -e /dev/dri/card0 ]; then
    sleep 5
    rog-control-center >/dev/null 2>&1
fi
