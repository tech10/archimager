#!/bin/sh
# This is designed to build an Arch Linux image
# from Arch Linux itself. It may not work on other distributions.
# Update all packages, then install the following to build an image:
# arch-install-scripts syslinux parted
# These images are designed to boot on an MBR.
# They will work with the serial console by default, which is known to work with Linode, and possibly other VM hosts.
. ./common-functions.sh
. ./common-part-bios.sh
pkg_inst $pkgs_all $pkgs_kernel $pkgs_bootldr
. ./common-boot-bios.sh
. ./common-fstab-bios.sh
. ./common-tasks.sh
