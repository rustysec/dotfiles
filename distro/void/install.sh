#!/usr/bin/env bash

swap="8G"

while getopts u:a:f: flag
do
    case "${flag}" in
        s) swap=${OPTARG};;
    esac
done

sudo cryptsetup luksFormat --type luks1 /dev/nvme0n1p3
sudo cryptsetup luksOpen /dev/nvme0n1p3 void

sudo vgcreate voidvm /dev/mapper/void
sudo lvcreate --name swap -L $swap void
sudo lvcreate --name root -l 100%FREE void

sudo mkfs.ext4 -L root /dev/void/root
sudo mkfs.ext4 -L boot /dev/nvme0n1p2
sudo mkfs.vfat /dev/nvme0n1p1
sudo mkswap /dev/void/swap

sudo mount /dev/void/root /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p2 /mnt/boot
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/nvme0n1p1 /mnt/boot/efi

sudo mkdir -p /mnt/var/db/xbps/keys
sudo cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

sudo xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt \
    base-system cryptsetup grub-x86_64-efi lvm2 \
    neovim NetworkManager git
