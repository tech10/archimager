#!/bin/bash
fstabinfo() {
echo "/dev/sda / ext4 defaults 0 1"
}
fstabinfo >>${imgdir}/etc/fstab
