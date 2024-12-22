#!/bin/bash
devset ${ldevs_l} ${1:-}
check mkfs.ext4 -m 0 ${diskdev}
check mkdir -p ${imgdir}
check mount -v ${diskdev} ${imgdir}
rootuuid=$(check lsblk -no UUID ${diskdev})
