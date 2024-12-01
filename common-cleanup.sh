#!/bin/bash
check sync
check umount -Rv ${imgdir}
check rm -rv ${imgdir}
check losetup -vd ${loopdev}
