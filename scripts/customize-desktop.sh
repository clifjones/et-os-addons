#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Make additional changes to the desktop, such as default X server and Gnome overrides
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

GDM3_CUSTOM_FILE="/etc/gdm3/custom.conf"

# Disabling Wayland will degrade Conky operation
function disableWayland() {
  et-log "Disable Wayland..."
  if grep "WaylandEnable" ${GDM3_CUSTOM_FILE} > /dev/null 2>&1 ; then
    sed -i "s/^.*WaylandEnable.*$/WaylandEnable=false/" ${GDM3_CUSTOM_FILE} 
  else
    et-log "Cannot find WaylandEnable line"
    exit 1
  fi
}

et-log "Customizing desktop..."

# Disabled since XOrg breaks Conky
#disableWayland

et-log "Desktop customization complete"


