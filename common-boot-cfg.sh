#!/bin/bash
# Boot configuration functions and variables.
bootkernel="vmlinuz-linux"
bootinitrd="initramfs-linux.img"
bootinitrdfallback="initramfs-linux-fallback.img"
kernelcmdline() {
echo "root=UUID=${rootuuid} rw console=ttyS0,19200n8 audit=0"
}
syslinuxcfg() {
local bootpath=$1
cat <<EOF
SERIAL 0 19200

DEFAULT archfallback
PROMPT 0
TIMEOUT 50

LABEL arch
    LINUX ${bootpath}${bootkernel}
    APPEND $(kernelcmdline)
    INITRD ${bootpath}${bootinitrd}

LABEL archfallback
    LINUX ${bootpath}${bootkernel}
    APPEND $(kernelcmdline)
    INITRD ${bootpath}${bootinitrdfallback}
EOF
}
systemdbootcfgldr() {
cat <<EOF
timeout 0
default archfallback.conf
EOF
}
systemdbootcfgarch() {
local bootpath=$1
cat <<EOF
title Arch Linux
linux ${bootpath}${bootkernel}
initrd ${bootpath}${bootinitrd}
options $(kernelcmdline)
EOF
}
systemdbootcfgarchfallback() {
local bootpath=$1
cat <<EOF
title Arch Linux Fallback
linux ${bootpath}${bootkernel}
initrd ${bootpath}${bootinitrdfallback}
options $(kernelcmdline)
EOF
}
