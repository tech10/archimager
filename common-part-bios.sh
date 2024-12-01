#!/bin/bash
# Partition for BIOS
check truncate -s ${ldevs_b} ${archimg}
loopdev=$(check losetup -P -f --show ${archimg})
check parted -s ${loopdev} mklabel msdos
check parted -s ${loopdev} mkpart primary ext4 1MiB 100%
check parted -s ${loopdev} set 1 boot on
rootdev="${loopdev}p1"
check mkfs.ext4 -m 0 -L AROOT ${rootdev}
check mkdir -p ${imgdir}
check mount -v -o noatime ${rootdev} ${imgdir}
rootuuid=$(check lsblk -no UUID ${rootdev})
