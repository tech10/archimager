#!/bin/bash
. ./common-vars.sh
# Common functions.
if [ $EUID -ne 0 ]; then
echo "This script requires root to build an image."
exit 10
fi
check() {
$@
if [ $? -ne 0 ]; then
echo $@
echo "Command failed to execute."
exit 10
fi
}
pkg_inst() {
check pacstrap -c ${imgdir} $@
}
