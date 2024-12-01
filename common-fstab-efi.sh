#!/bin/bash
fstabinfo() {
echo "UUID=${rootuuid} / ext4 rw,noatime 0 1"
echo "UUID=${bootuuid} /boot vfat rw,noatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 2"
}
fstabinfo >>${imgdir}/etc/fstab
