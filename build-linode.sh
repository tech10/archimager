#!/bin/sh
# This is designed to build an Arch Linux image
# from Arch Linux itself. It may not work on other distributions.
# Update all packages, then install the following to build an image:
# arch-install-scripts
# These images are designed to boot on a Linode and do not include their own kernel.
. ./common-functions.sh
. ./common-part-linode.sh
pkg_inst $pkgs_all
. ./common-fstab-linode.sh
. ./common-tasks.sh
