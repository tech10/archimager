#!/bin/bash
# Perform on all installs.
echo "Enabling systemd services."
check systemctl --root=${imgdir} enable sshd systemd-networkd systemd-resolved systemd-timesyncd
echo "Copying systemd files."
check cp -rv ./systemd/* ${imgdir}/etc/systemd/
echo "Setting resolv.conf"
check chroot ${imgdir} /usr/bin/ln -svf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
echo "Setting time zone: ${tz}"
check chroot ${imgdir} /usr/bin/ln -svf "/usr/share/zoneinfo/${tz}" /etc/localtime
echo "Setting up locale ${LOCALE} and keymap ${KEYMAP}"
# Enable the locale in /etc/locale.gen
if grep -q "^#${LOCALE}" ${imgdir}/etc/locale.gen; then
sed -i "s/^#${LOCALE}/${LOCALE}/" ${imgdir}/etc/locale.gen
echo "${LOCALE} enabled in /etc/locale.gen"
else
echo "${LOCALE} is already enabled in /etc/locale.gen or doesn't exist"
fi
chroot ${imgdir} /usr/bin/locale-gen
echo "Setting system locale."
echo "LANG=${LOCALE}" >${imgdir}/etc/locale.conf
echo "Setting keymap to ${KEYMAP}."
keymapwrite $KEYMAP >${imgdir}/etc/vconsole.conf
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
