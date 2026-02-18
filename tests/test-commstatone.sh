#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description: Test CommStatOne install

[ -e /etc/skel/apps/commstatone/commstat.py ] && [ -e /usr/share/applications/commstatone.desktop ] && ( [ -e /usr/share/pixmaps/commstatone.ico ] || [ -e /usr/share/pixmaps/commstatone.png ] )

exit $?
