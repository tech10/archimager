#!/bin/bash
# Create disk image, format it for EFI, and mount it.
check truncate -s ${ldevs_e} ${archimg}
loopdev=$(check losetup -P -f --show ${archimg})
check parted -s ${loopdev} mklabel gpt
check parted -s ${loopdev} mkpart EFI fat32 1MiB 201MiB
check parted -s ${loopdev} set 1 esp on
check parted -s ${loopdev} mkpart AROOT ext4 201MiB 100%
check mkfs.ext4 -m 0 -L AROOT ${loopdev}p2
check mkfs.vfat -F 32 -n ABOOT ${loopdev}p1
check mkdir -p ${imgdir}
check mount -v -o noatime ${loopdev}p2 ${imgdir}
check mkdir -p ${imgdir}/boot
check mount -v -o noatime ${loopdev}p1 ${imgdir}/boot
