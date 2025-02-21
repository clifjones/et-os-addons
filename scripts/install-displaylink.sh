#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Installs Synaptics DisplayLink drivers
#

function checkInstall() {
  apt -q list displaylink-driver | grep -i "installed"
  return $?
}

et-log "Installing Synaptics DisplayLink..."

# Uninstall any previous versions
if checkInstall; then
  et-log "Synaptics DisplayLink already installed"
  exit 0
fi

# Install DisplayLink
if ! apt install -y displaylink-driver; then
  cleanup
  et-log "WSJTX-X update failed!"
  exit 1
fi

et-log "Synaptics DisplayLink install complete"


