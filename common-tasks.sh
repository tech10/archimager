#!/bin/bash
# Perform on all installs.
echo "Enabling systemd services."
check systemctl --root=${imgdir} enable sshd systemd-networkd systemd-resolved systemd-timesyncd
echo "Copying systemd files."
check cp -rv ./systemd/* ${imgdir}/etc/systemd/
echo "Setting resolve.conf"
check ln -svf /run/systemd/resolve/stub-resolv.conf ${imgdir}/etc/resolv.conf
echo "Setting time zone: ${tz}"
check chroot ${imgdir} /usr/bin/ln -svf "/usr/share/zoneinfo/${tz}" /etc/localtime
echo "Clearing root password."
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
echo "Custom script exists. Copying."
check cp -v "${customscript}" "${customscriptpath}"
check chmod -v +x "${customscriptpath}"
customsystemdsvc >${imgdir}/etc/systemd/system/${customsvc}
systemctl --root=${imgdir} enable "${customsvc}"
fi
check cp -av ./scripts ${imgdir}/root/
. ./common-cleanup.sh
