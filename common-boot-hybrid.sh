#!/bin/bash
# Hybred boot BIOS and EFI
. ./common-boot-efi.sh
check parted -s ${diskdev} set 1 boot on
check mkdir -pv ${imgdir}/boot/syslinux
check cp -av ${imgdir}/usr/lib/syslinux/bios/*.c32 ${imgdir}/boot/syslinux/
check syslinux-install_update -c ${imgdir} -i -a -m
syslinuxcfg / >${imgdir}/boot/syslinux/syslinux.cfg
