#!/bin/bash
fstabinfo() {
echo "UUID=${rootuuid} / ext4 rw,noatime 0 1"
}
fstabinfo >>${imgdir}/etc/fstab
