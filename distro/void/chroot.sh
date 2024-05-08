#!/usr/bin/env bash

hostname=void

while getopts u:a:f: flag
do
    case "${flag}" in
        h) hostname=${OPTARG};;
    esac
done

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
cmdline="GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash rd.lvm.vg=void rd.luks.uuid=$uuid rd.luks.allow-discards\""
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT.*/$cmdline/" /etc/default/grub
echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub
echo "GRUB_GFXMODE=1024x768x32" >> /etc/default/grub
echo "GRUB_GFXPAYLOAD=keep" >> /etc/default/grub
echo "GRUB_TERMINAL=gfxterm" >> /etc/default/grub

sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers
echo "Defaults pwfeedback" > /etc/sudoers.d/feedback

ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

grub-install /dev/nvme0n1
xbps-reconfigure -fa
