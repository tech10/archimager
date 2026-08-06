#!/bin/bash
# Common boot tasks to execute.
# Created some time after automatic initrd fallback image generation was disabled.
echo Creating fallback initrd.
echo IMPORTANT!!!
echo This fallback image will not be recreated upon kernel upgrades.
check arch-chroot ${imgdir} /usr/bin/mkinitcpio -k /boot/${bootkernel} -g /boot/${bootinitrdfallback} -S autodetect
