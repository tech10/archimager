#!/bin/bash
check sync
check umount -Rv ${imgdir}
check rm -rv ${imgdir}
if [[ "$dev_type" == "loop" ]]; then
echo Detaching ${diskdev}
check sync
check losetup -d ${diskdev}
fi
