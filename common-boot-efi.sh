#!/bin/bash
. ./common-boot-cfg.sh
# Boot loader install for EFI system only.
check bootctl --root=${imgdir} --random-seed=no --no-variables install
systemdbootcfgldr >${imgdir}/boot/loader/loader.conf
systemdbootcfgarch / >${imgdir}/boot/loader/entries/arch.conf
systemdbootcfgarchfallback / >${imgdir}/boot/loader/entries/archfallback.conf
check systemctl --root=${imgdir} enable systemd-boot-update
