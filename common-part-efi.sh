#!/bin/bash
# Create disk image, format it for EFI, and mount it.
check truncate -s ${ldevs_e} ${archimg}
loopdev=$(check losetup -P -f --show ${archimg})
check parted -s ${loopdev} mklabel gpt
check parted -s ${loopdev} mkpart EFI fat32 1MiB 201MiB
check parted -s ${loopdev} set 1 esp on
check parted -s ${loopdev} mkpart ext4 201MiB 100%
bootdev="${loopdev}p1"
rootdev="${loopdev}p2"
check mkfs.ext4 -m 0 -L AROOT ${rootdev}
check mkfs.vfat -F 32 -L ABOOT ${bootdev}
check mkdir -p ${imgdir}
check mount -v -o noatime ${rootdev} ${imgdir}
check mkdir -p ${imgdir}/boot
check mount -v -o noatime ${bootdev} ${imgdir}/boot
bootuuid=$(check lsblk -no UUID ${bootdev})
rootuuid=$(check lsblk -no UUID ${rootdev})
