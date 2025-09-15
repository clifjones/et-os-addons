#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description: Test et-launcher install

[ -e /opt/appimages/et-launcher.appimage ] && [ -e /usr/share/applications/et-launcher.desktop ] && [ -e /usr/share/pixmaps/et-launcher.png ]

exit $?
