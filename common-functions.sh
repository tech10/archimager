#!/bin/bash
. ./common-vars.sh
# Common functions.
if [ $EUID -ne 0 ]; then
echo "This script requires root to build an image."
exit 10
fi
check() {
"$@"
local status=$?
if [[ $status -ne 0 ]]; then
echo "Error: Command '$@' failed with exit code $status" >&2
exit $status
fi
}
pkg_inst() {
check pacstrap -c ${imgdir} "$@"
}
execsh() {
chroot ${imgdir} /usr/bin/bash -c "$(cat $@)"
}
