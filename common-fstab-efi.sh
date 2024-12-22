#!/bin/bash
fstabinfo() {
echo "UUID=${rootuuid} / ext4 defaults 0 1"
echo "UUID=${bootuuid} /boot vfat defaults 0 2"
}
fstabinfo >>${imgdir}/etc/fstab
