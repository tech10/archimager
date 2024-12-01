#!/bin/bash
# Partition for BIOS
check truncate -s 1024M ${archimg}
loopdev=$(check losetup -P -f --show ${archimg})
check parted -s ${loopdev} mklabel msdos
check parted -s ${loopdev} mkpart primary ext4 1MiB 100%
check parted -s ${loopdev} set 1 boot on
check mkfs.ext4 -m 0 -L AROOT ${loopdev}p1
check mkdir -p ${imgdir}
check mount -v -o noatime ${loopdev}p1 ${imgdir}
