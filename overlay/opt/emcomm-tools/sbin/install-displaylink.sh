#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Installs Synaptics DisplayLink drivers
#
DISPLAYLINK_KEYRING_URL="https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb"
KEYRING_DEB="/tmp/synaptics-keyring.deb"

function checkInstall() {
  apt -q list displaylink-driver | grep -i "installed"
  return $?
}

function cleanup() {
  rm -f ${KEYRING_DEB}
}

function exitIfNotRoot() {
  if [ $EUID -ne 0 ]; then
    echo "Exiting. You must be root."
    echo "Try running: sudo ./$(basename $0)"
    exit -1
  fi
}

et-log "Installing Synaptics DisplayLink..."

# Must be root
exitIfNotRoot

# Check for existing install
if checkInstall; then
  et-log "Synaptics DisplayLink already installed"
  exit 0
fi

# Point to correct Ubuntu repos
et-log "Updating apt to use the old repository..."
cp -v /opt/emcomm-tools/conf/template.d/sources.list /etc/apt/
apt update

# Download keyring
if ! curl -L -o "${KEYRING_DEB}" --fail "${DISPLAYLINK_KEYRING_URL}"; then
  cleanup
  et-log "Synaptics DisplayLink keyring download failed!"
  exit 1
fi

# Add DisplayLink repo
if ! dpkg -i ${KEYRING_DEB}; then
  cleanup
  et-log "Synaptics DisplayLink keyring install failed!"
  exit 2
fi

# Update repos
apt update

# Install DisplayLink
if ! apt install -y displaylink-driver; then
  cleanup
  et-log "Synaptics DisplayLink install failed!"
  exit 3
fi

et-log "Synaptics DisplayLink install complete"


