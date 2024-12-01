#!/bin/bash
. ./common-boot-cfg.sh
# BIOS boot configuration
check mkdir -pv ${imgdir}/boot/syslinux/
check cp -av ${imgdir}/usr/lib/syslinux/bios/*.c32 ${imgdir}/boot/syslinux/
check syslinux-install_update -c ${imgdir} -i -a -m
syslinuxcfg /boot/ >${imgdir}/boot/syslinux/syslinux.cfg
