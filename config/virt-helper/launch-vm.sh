#!/usr/bin/env bash
VM=$(virsh --connect qemu:///system list --all --name | fuzzel --dmenu)

if [[ $VM == "" ]];
then
    echo "No VM selected..."
    exit 1
fi

virsh --connect qemu:///system start "$VM"

virt-manager --connect qemu:///system --show-domain-console "$VM"
