#!/bin/bash
# Partition for BIOS
devset ${ldevs_b} ${1:-}
check parted -s ${diskdev} mklabel msdos
check parted -s ${diskdev} mkpart primary ext4 1MiB 100%
check parted -s ${diskdev} set 1 boot on
rootdev=$(get_partition_path $diskdev 1)
check mkfs.ext4 -m 0 -L AROOT ${rootdev}
check mkdir -p ${imgdir}
check mount -v -o noatime ${rootdev} ${imgdir}
rootuuid=$(check lsblk -no UUID ${rootdev})
