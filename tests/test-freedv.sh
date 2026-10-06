#!/bin/bash
# Author   : Local build (custom/r7-freedv) - not part of upstream ETC
# Date     : 4 October 2026
# Purpose  : Test FreeDV installation

APP_BIN=/opt/freedv/appdir/usr/bin/freedv

OUT=$(which freedv) || exit 1
[[ -x ${APP_BIN} ]] || exit 1
[[ -e /usr/share/applications/freedv.desktop ]] || exit 1
[[ -e /opt/freedv/share/freedv.png ]] || exit 1

# Every shared library must resolve from the bundle or the system
ldd ${APP_BIN} | grep -q 'not found' && exit 1

# The GUI needs a display; only run it when one is available
if [[ -n "${DISPLAY}" ]]; then
  OUT=$(timeout 20 freedv --help 2>&1 | grep -q 'Usage: freedv') || exit 1
fi

exit 0
