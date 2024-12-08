#!/bin/bash
set -euo pipefail
# Build all images.
. ./common-vars.sh
img_l="./arch-linode.img.gz"
img_b="./arch-bios.img.gz"
img_e="./arch-efi.img.gz"
img_h="./arch-hybrid.img.gz"
img_comp="${archimg}.gz"
logd="./log"
mkdir -p $logd
builder() {
local script=$1
local imggz=$2
local logf="${logd}/$(basename ${script}.log)"
echo "Running $script and writing all output to $logf"
$script >$logf 2>&1
echo Compressing.
./compress.sh
echo Moving.
mv -v ${img_comp} ${imggz}
echo Removing built image.
rm -v ${archimg}
echo Success.
}
builder ./build-linode.sh $img_l
builder ./build-bios.sh $img_b
builder ./build-efi.sh $img_e
builder ./build-hybrid.sh $img_h
