#!/usr/bin/env bash

if [ "$1" = "enable" ]; then
    echo "Enabling dGPU..."

    echo 0 | sudo tee /sys/devices/platform/asus-nb-wmi/dgpu_disable
    echo 0 | sudo tee /sys/bus/pci/rescan

    sudo systemctl enable nvidia-suspend.service nvidia-resume.service nvidia-powerd.service nvidia-persistenced.service

    echo "Done!"

elif [ "$1" = "disable" ]; then
    echo "Disabling dGPU..."

    echo 1 | sudo tee /sys/devices/platform/asus-nb-wmi/dgpu_disable
    echo 1 | sudo tee /sys/bus/pci/rescan

    sudo systemctl disable nvidia-suspend.service nvidia-resume.service nvidia-powerd.service nvidia-persistenced.service

    echo "Done!"

else
    echo "Usage: $0 [enable|disable]"
fi
