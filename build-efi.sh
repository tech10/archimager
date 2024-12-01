#!/bin/sh
# This is designed to build an Arch Linux image
# from Arch Linux itself. It may not work on other distributions.
# Update all packages, then install the following to build an image:
# arch-install-scripts syslinux parted gptfdisk dosfstools
# These images are designed to boot on an EFI.
# They will work with the serial console by default, which is known to work with Linode, and possibly other VM hosts.
. ./common-functions.sh
. ./common-part-efi.sh
pkg_inst $pkgs_all $pkgs_efi $pkgs_kernel
. ./common-boot-efi.sh
. ./common-fstab-efi.sh
. ./common-tasks.sh
