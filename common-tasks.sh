#!/bin/bash
# Perform on all installs.
check systemctl --root=${imgdir} enable sshd systemd-networkd systemd-resolved systemd-timesyncd
check cp -rv ./systemd/* ${imgdir}/etc/systemd/
check ln -svf /run/systemd/resolve/stub-resolv.conf ${imgdir}/etc/resolv.conf
check chroot ${imgdir} /usr/bin/passwd -d root
sshkeys="${HOME}/.ssh/authorized_keys"
sshdir="${imgdir}/root/.ssh"
if [ -f "${sshkeys}" ]; then
echo "Copying ${sshkeys} to ${sshdir}"
check mkdir -p ${sshdir}
check cp ${sshkeys} ${sshdir}
check chmod 700 -v ${sshdir}
check chmod 600 -v ${sshdir}/authorized_keys
check chown root:root -Rv ${sshdir}
fi
customscript="custom.sh"
customscriptpath="${imgdir}/root/${customscript}"
customsvc="custom.service"
if [ -f "${customscript}" ]; then
echo "Custom script exists."
check cp -v "${customscript}" "${customscriptpath}"
check chmod -v +x "${customscriptpath}"
customsystemdsvc >${imgdir}/etc/systemd/system/${customsvc}
systemctl --root=${imgdir} enable "${customsvc}"
fi
check cp -av ./scripts ${imgdir}/root/
. ./common-cleanup.sh
