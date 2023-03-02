#!/bin/sh
# This is designed to build an Arch Linux image
# from Arch Linux itself. It may not work on other distributions.
# Update all packages, then install the following to build an image:
# arch-install-scripts syslinux parted gptfdisk
# These images are designed to boot on an MBR and EFI.
# They will work with the serial console by default, which is known to work with Linode, and possibly other VM hosts.
if [ $EUID -ne 0 ]; then
echo "This script requires root to build an image."
exit 10
fi
check() {
eval $@
if [ $? -ne 0 ]; then
echo $@
echo "Command failed to execute."
exit 10
fi
}
archimg="./arch.img"
check truncate -s 1228M ${archimg}
loopdev=$(check losetup -P -f --show ${archimg})
check parted -s ${loopdev} mklabel gpt
check parted -s ${loopdev} mkpart EFI fat32 1MiB 201MiB
check parted -s ${loopdev} set 1 esp on
check parted -s ${loopdev} mkpart AROOT ext4 201MiB 100%
check parted -s ${loopdev} set 1 boot on
check mkfs.ext4 -m 0 -L AROOT ${loopdev}p2
check mkfs.vfat -F 32 -n ABOOT ${loopdev}p1
imgdir="./image"
check mkdir -p ${imgdir}
check mount -v -o noatime ${loopdev}p2 ${imgdir}
check mkdir -p ${imgdir}/boot
check mount -v -o noatime ${loopdev}p1 ${imgdir}/boot
check pacstrap -c ${imgdir} base linux syslinux efibootmgr dosfstools gptfdisk openssh nano ed wget rsync
check systemctl --root=${imgdir} enable sshd systemd-networkd systemd-resolved systemd-timesyncd
check syslinux-install_update -c ${imgdir} -i -a -m
check cp -v ./syslinux.cfg ${imgdir}/boot/syslinux/
check chown -v root:root ${imgdir}/boot/syslinux/syslinux.cfg
check mkdir -pv ${imgdir}/boot/EFI/BOOT
check cp -rv ${imgdir}/usr/lib/syslinux/efi64/* ${imgdir}/boot/EFI/BOOT/
check mv -v ${imgdir}/boot/EFI/BOOT/syslinux.efi ${imgdir}/boot/EFI/BOOT/bootx64.efi
check cp -v ./syslinux.cfg ${imgdir}/boot/EFI/BOOT/syslinux.cfg
check chown root:root -v ${imgdir}/boot/EFI/BOOT/syslinux.cfg
check cp -rv ./systemd/* ${imgdir}/etc/systemd/
check chown root:root -Rv ${imgdir}/etc/systemd/*
check ln -svf /run/systemd/resolve/stub-resolv.conf ${imgdir}/etc/resolv.conf
check chroot ${imgdir} /usr/bin/passwd -d root
fstabinfo() {
echo "LABEL=AROOT / ext4 rw,noatime 0 1"
echo "LABEL=ABOOT /boot vfat rw,noatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 2"
}
fstabinfo >>${imgdir}/etc/fstab
sshkeys="${HOME}/.ssh/authorized_keys"
sshdir="${imgdir}/root/.ssh"
if [ -f "${sshkeys}" ]; then
echo "Copying ${sshkeys} to ${sshdir}"
check mkdir -p ${sshdir}
check cp ${sshkeys} ${sshdir}
check chmod 700 -v ${sshdir}
check chmod 600 -v ${sshdir}/authorized_keys
check chown root:root -Rv ${sshdir}
fi
check sync
check umount -Rv ${imgdir}
check rm -rv ${imgdir}
check losetup -vd ${loopdev}
