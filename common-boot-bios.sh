#!/bin/bash
check mkdir -pv ${imgdir}/boot/syslinux/
check cp -v ${imgdir}/usr/lib/syslinux/bios/*.c32 ${imgdir}/boot/syslinux/
check syslinux-install_update -c ${imgdir} -i -a -m
check cp -v ./syslinux-bios.cfg ${imgdir}/boot/syslinux/syslinux.cfg
check chown root:root -v ${imgdir}/boot/syslinux/syslinux.cfg
