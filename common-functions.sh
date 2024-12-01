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
check chroot ${imgdir} /usr/bin/bash -c "$(check cat $@)"
}
