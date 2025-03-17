#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description: Test JS8Spotter install

[ -e /etc/skel/apps/js8spotter/js8spotter.py ] && [ -e /usr/share/applications/js8spotter.desktop ] && [ -e /usr/share/pixmaps/js8spotter.ico ]

exit $?