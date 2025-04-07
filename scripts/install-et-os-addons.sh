#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Install the et-os-addons command and support files

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e 

et-log "Installing ET-OS-Addons command and support files..."

# Copy EmCommTools files
cp -v -r ${ET_OS_ADDONS_BASE}/overlay/opt/emcomm-tools/* ${ET_HOME}/.
chmod -v 664 ${ET_HOME}/conf/template.d/*.conf

# Copy misc Skel files
cp -v -r ${ET_OS_ADDONS_BASE}/overlay/etc/skel/* ${SKEL}/.

# This should be done by each script
#cp -v -r ${ET_OS_ADDONS_BASE}/overlay/usr/share/* /usr/share/.

et-log "ET-OS-Addons command and support files install complete"
