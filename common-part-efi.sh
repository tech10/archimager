#!/bin/bash
# Create disk image, format it for EFI, and mount it.
devset ${ldevs_e} ${1:-}
check parted -s ${diskdev} mklabel gpt
check parted -s ${diskdev} mkpart EFI fat32 1MiB 201MiB
check parted -s ${diskdev} set 1 esp on
check parted -s ${diskdev} mkpart ext4 201MiB 100%
bootdev=$(get_partition_path $diskdev 1)
rootdev=$(get_partition_path $diskdev 2)
check mkfs.ext4 -m 0 -L AROOT ${rootdev}
check mkfs.vfat -F 32 -n ABOOT ${bootdev}
check mkdir -p ${imgdir}
check mount -v ${rootdev} ${imgdir}
check mkdir -p ${imgdir}/boot
check mount -v ${bootdev} ${imgdir}/boot
bootuuid=$(check lsblk -no UUID ${bootdev})
rootuuid=$(check lsblk -no UUID ${rootdev})
