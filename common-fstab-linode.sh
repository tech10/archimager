#!/bin/bash
fstabinfo() {
echo "/dev/sda / ext4 rw,noatime 0 1"
}
fstabinfo >>${imgdir}/etc/fstab
