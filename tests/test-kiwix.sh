#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description: Test Kiwix install

[ -e /opt/appimages/kiwix-desktop_x86_64.appimage ] && [ -e /usr/share/applications/kiwix.desktop ] && [ -e /usr/share/pixmaps/kiwix-desktop.svg ]

exit $?
