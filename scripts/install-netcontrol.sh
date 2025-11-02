#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Install BRARS NetControl support files
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e

et-log "Installing BRARS NetControl..."

et-log "Updating NetControl launcher icon to support PNP..."
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/applications/netcontrol.desktop /usr/share/applications/.
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/pixmaps/netcontrol.png /usr/share/pixmaps/.

et-log "NetControl install complete"
