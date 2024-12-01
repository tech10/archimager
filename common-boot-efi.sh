#!/bin/bash
# Boot loader install for EFI system only.
check bootctl --root=${imgdir} --no-variables install
check cp -rv ./systemd-boot/loader ${imgdir}/boot/
check chown root:root -Rv ${imgdir}/boot/loader
check systemctl --root=${imgdir} enable systemd-boot-update
