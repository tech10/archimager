#!/bin/sh
# This is designed to build an Arch Linux image
# from Arch Linux itself. It may not work on other distributions.
# Update all packages, then install the following to build an image:
# arch-install-scripts
# These images are designed to boot on a Linode and do not include their own kernel.
. ./common-functions.sh
check truncate -s 700M ${archimg}
loopdev=$(check losetup -P -f --show ${archimg})
check mkfs.ext4 -m 0 ${loopdev}
check mkdir -p ${imgdir}
check mount -v -o noatime ${loopdev} ${imgdir}
pkg_inst $pkgs_all
fstabinfo() {
echo "/dev/sda / ext4 rw,noatime 0 1"
}
fstabinfo >>${imgdir}/etc/fstab
. ./common-tasks.sh
