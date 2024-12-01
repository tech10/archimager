#!/bin/bash
fstabinfo() {
echo "LABEL=AROOT / ext4 rw,noatime 0 1"
}
fstabinfo >>${imgdir}/etc/fstab
