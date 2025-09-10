#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Install xygrib weather map display app

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e 

et-log "Installing xygrib..."

apt install xygrib -y

# Copy misc Skel files
cp -v -r ${ET_OS_ADDONS_BASE}/overlay/etc/skel/* ${SKEL}/.

et-log "xygrib install complete"
