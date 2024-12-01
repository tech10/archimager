#!/bin/bash
# Hybred boot BIOS and EFI
. ./common-boot-efi.sh
check parted -s ${loopdev} set 1 boot on
check mkdir -pv ${imgdir}/boot/syslinux
check cp -v ${imgdir}/usr/lib/syslinux/bios/*.c32 ${imgdir}/boot/syslinux/
check syslinux-install_update -c ${imgdir} -i -a -m
check cp -v ./syslinux-efi.cfg ${imgdir}/boot/syslinux/syslinux.cfg
