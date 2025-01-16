#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Install the et-os-addons command and support files

et-log "Installing ET-OS-Addons command and support files..."

cp -v -r ${ET_OS_ADDONS_BASE}/overlay/opt/emcomm-tools/* ${ET_HOME}/.

chmod -v 664 ${ET_HOME}/conf/template.d/*.conf

cp -v -r ${ET_OS_ADDONS_BASE}/overlay/usr/share/* /usr/share/.
