#!/usr/bin/env bash

swap="8G"

while getopts u:a:f: flag
do
    case "${flag}" in
        s) swap=${OPTARG};;
    esac
done

cryptsetup luksFormat --type luks1 /dev/nvme0n1p3
cryptsetup luksOpen /dev/nvme0n1p3 void

vgcreate void /dev/mapper/void
lvcreate --name swap -L $swap void
lvcreate --name root -l 100%FREE void

mkfs.ext4 -L root /dev/void/root
mkfs.ext4 -L boot /dev/nvme0n1p2
mkfs.vfat /dev/nvme0n1p1
mkswap /dev/void/swap

mount /dev/void/root /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt \
    base-system cryptsetup grub-x86_64-efi lvm2 \
    neovim NetworkManager git

cp $(pwd)/distro/void/chroot.sh /mnt
chmod +x /mnt/chroot.sh
xchroot /mnt
