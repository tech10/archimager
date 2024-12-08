#!/bin/bash
check sync
check umount -Rv ${imgdir}
check rm -rv ${imgdir}
dev_type=$(lsblk -n -o TYPE "$diskdev" 2>/dev/null | head -n 1)
if [[ "$dev_type" == "loop" ]]; then
echo Detaching ${diskdev}
check sync
check losetup -d ${diskdev}
fi
