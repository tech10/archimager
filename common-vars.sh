#!/bin/bash
# Arch image and mount directory
archimg="./arch.img"
imgdir="./image"
# BIOS image size
ldevs_b="1024M"
# EFI image size
ldevs_e="1228M"
# Linode image size
ldevs_l="700M"
# Packages
pkgs_all="base openssh nano ed wget rsync"
pkgs_efi="efibootmgr dosfstools gptfdisk"
pkgs_kernel="linux zram-generator"
pkgs_bootldr="syslinux"
# Systemd services
svcs="sshd systemd-networkd systemd-resolved systemd-timesyncd"
# Root file system directory
rootfs="./rootfs"
# Time zone
tz="America/Denver"
# Locale and keymap
LOCALE="en_US.UTF-8"
KEYMAP="us"
# SSH key file and directory
sshkeys="${HOME}/.ssh/authorized_keys"
sshdir="${imgdir}/root/.ssh"
# Custom script, directory, and systemd service
customscript="custom.sh"
customscriptpath="${imgdir}/root/${customscript}"
customsvc="custom.service"
# Custom file system directory
customfs="./customfs"
