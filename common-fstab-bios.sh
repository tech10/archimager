#!/bin/bash
fstabinfo() {
echo "UUID=${rootuuid} / ext4 defaults 0 1"
}
fstabinfo >>${imgdir}/etc/fstab
