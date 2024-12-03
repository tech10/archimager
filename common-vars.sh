#!/bin/bash
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
tz="America/Denver"
