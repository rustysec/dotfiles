#!/usr/bin/env bash

if [ "$1" = "enable" ]; then
    echo "Enabling WiFi..."

    modprobe mt7925e
    modprobe mt7925_common
    modprobe mt792x_lib

    echo "Enabling Bluetooth..."
    modprobe btmtk
    modprobe btusb

elif [ "$1" = "disable" ]; then
    echo "Disabling WiFi..."
    rmmod mt7925e
    rmmod mt7925_common
    rmmod mt792x_lib

    echo "Enabling Bluetooth..."
    rmmod btusb
    rmmod btmtk

else
    echo "Usage: $0 [enable|disable]"
fi
