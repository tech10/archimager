#!/bin/bash
check sync
check umount -Rv ${imgdir}
check rm -rv ${imgdir}
dev_type=$(lsblk -n -o TYPE "$diskdev" 2>/dev/null)
if [[ "$dev_type" == "loop" ]]; then
check losetup -vd ${diskdev}
fi
