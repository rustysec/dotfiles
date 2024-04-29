#!/usr/bin/env bash

hostname="void"
swap="8G"
stage="install"

while getopts u:a:f: flag
do
    case "${flag}" in
        h) hostname=${OPTARG};;
        w) swap=${OPTARG};;
        s) stage=${OPTARG};;
    esac
done

if [[ $stage == "install" ]];
then
    sudo cryptsetup luksFormat --type luks1 /dev/nvme0n1p3
    sudo cryptsetup luksOpen /dev/nvme0n1p3 void

    sudo vgcreate voidvm /dev/mapper/void
    sudo lvcreate --name swap -L $swap void
    sudo lvcreate --name root -l 100%FREE void

    sudo mkfs.ext4 -L root /dev/void/root
    sudo mkfs.ext4 -L boot /dev/nvme0n1p2
    sudo mkfs.vfat /dev/nvme0n1p1

    sudo mount /dev/void/root /mnt
    sudo mkdir -p /mnt/boot
    sudo mount /dev/nvme0n1p2 /mnt/boot
    sudo mkdir -p /mnt/boot/efi
    sudo mount /dev/nvme0n1p1 /mnt/boot/efi

    sudo mkdir -p /mnt/var/db/xbps/keys
    sudo cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

    sudo xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt \
        base-system cryptsetup grub-x86_64-efi lvm2 \
        neovim NetworkManager
else
    chown root:root /
    chmod 755 /
    passwd root
    echo $hostname > /etc/hostname

    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
    xbps-reconfigure -f glibc-locales

    echo "/dev/void/root    /           ext4    defaults              0       0" >> /etc/fstab
    echo "/dev/nvme0n1p2    /boot       ext4    defaults              0       0" >> /etc/fstab
    echo "/dev/nvme0n1p1    /boot/efi   vfat    defaults              0       0" >> /etc/fstab
    echo "/dev/void/swap    swap        swap    defaults              0       0" >> /etc/fstab

    uuid=`blkid -o value -s UUID /dev/nvme0n1p3`
    cmdline="GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=4 rd.lvm.vg=void rd.luks.uuid=$uuid rd.luks.options=discard\""
    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT.*/$cmdline/" /etc/default/grub
    echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub

    grub-install /dev/nvme0n1
    xbps-reconfigure -fa
fi
