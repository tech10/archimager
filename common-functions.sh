#!/bin/bash
. ./common-vars.sh
# Stop immediately on undeclared variable or error.
set -euo pipefail
# Check for root execution.
if [ $EUID -ne 0 ]; then
echo "This script requires root to build an image."
exit 10
fi
# Common functions.
check() {
$@
local status=$?
if [[ $status -ne 0 ]]; then
echo "Error: Command '$@' failed with exit code $status" >&2
exit $status
fi
}
pkg_inst() {
check pacstrap -c -G -M ${imgdir} $@
}
execsh() {
check chroot ${imgdir} /usr/bin/bash -c "$(check cat $@)"
}
devset() {
local size=$1
local device=${2:-}
if [ -z "$device" ]; then
dev_type="loop"
check truncate -s ${size} ${archimg}
diskdev=$(check losetup -P -f --show ${archimg})
else
dev_type="custom"
diskdev="$device"
trap 'echo "Terminated."; exit 1' SIGINT
echo "WARNING!!!" >&2
echo "You are about to format ${diskdev}. Press enter to continue, or control+c to terminate." >&2
read
echo "Continuing." >&2
trap - SIGINT
fi
}
get_partition_path() {
local root_device="$1"
local partition_number="$2"
local partition_path=$(lsblk -lnpo NAME | grep -E "^${root_device}.*${partition_number}\$")
if [[ -z "$partition_path" ]]; then
echo "Partition not found for ${root_device}, partition number ${partition_number}" >&2
exit 1
fi
echo "$partition_path"
}
customsystemdsvc() {
cat <<'EOF'
[Unit]
Description=Custom Script Execution Service
After=network.target

[Service]
Type=oneshot
Environment=CUSTOM_SCRIPT=/root/custom.sh
ExecStart=/bin/bash $CUSTOM_SCRIPT
ExecStopPost=/bin/bash -c '\
systemctl disable %n; \
rm -fv /etc/systemd/system/%n; \
rm -fv $CUSTOM_SCRIPT; \
systemctl daemon-reload'
StandardOutput=tty
StandardError=tty
TTYPath=/dev/console

[Install]
WantedBy=multi-user.target
EOF
}
keymapwrite() {
local km="$1"
cat <<EOF
# Written by custom Arch Linux imaging scripts, read by systemd-localed
# and systemd-vconsole-setup(8). Use localectl(1) to update this file.
KEYMAP=$km
XKBLAYOUT=$km
XKBMODEL=pc105+inet
XKBOPTIONS=terminate:ctrl_alt_bksp
EOF
}
