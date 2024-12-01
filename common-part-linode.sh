#!/bin/bash
check truncate -s ${ldevs_l} ${archimg}
loopdev=$(check losetup -P -f --show ${archimg})
check mkfs.ext4 -m 0 ${loopdev}
check mkdir -p ${imgdir}
check mount -v -o noatime ${loopdev} ${imgdir}
rootuuid=$(check lsblk -no UUID ${loopdev})
