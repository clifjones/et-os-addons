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

# Copy and enable init.d scripts to fix et-predict-app
et-log "Installing init.d scripts..."
cp -v ${ET_OS_ADDONS_BASE}/overlay/etc/init.d/et-api /etc/init.d/.
cp -v ${ET_OS_ADDONS_BASE}/overlay/etc/init.d/et-mbtileserver /etc/init.d/.
chmod +x /etc/init.d/et-api /etc/init.d/et-mbtileserver
update-rc.d et-api defaults
update-rc.d et-mbtileserver defaults

# This should be done by each script
#cp -v -r ${ET_OS_ADDONS_BASE}/overlay/usr/share/* /usr/share/.

et-log "ET-OS-Addons command and support files install complete"
