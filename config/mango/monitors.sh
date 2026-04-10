#!/usr/bin/env bash

CMD="enable_monitor"

if [[ $1 == "off" ]]; then
    CMD="disable_monitor"
fi

for monitor in `mmsg -O`; do
    mmsg -d $CMD,$monitor
done
