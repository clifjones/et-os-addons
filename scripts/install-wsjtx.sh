#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Installs WSJT-X https://wsjt.sourceforge.io/wsjtx.html
#

WSJTX_DEB_DL="https://sourceforge.net/projects/wsjt/files/wsjtx-2.6.1/wsjtx_2.6.1_amd64.deb"
TMP_FILE="/tmp/wsjtx-tmp.deb"

function cleanup() {
  unlink "${TMP_FILE}"
}

function checkInstall() {
  apt -q list wsjtx* | grep -i "installed"
  return $?
}

et-log "Installing WSJT-X..."

# Uninstall any previous versions
if checkInstall; then
  et-log "Removing old WSJT-X"
  apt purge -y wsjtx wsjtx-doc wsjtx-data
fi

# Download target version of WSJT-X and install
if ! curl -s -L -o "${TMP_FILE}" --fail "${WSJTX_DEB_DL}"; then
  et-log "WSJT-X download failed!"
  cleanup
  exit 1
fi

# Install DEB file. Then fix dependency errors
rm -rf "/usr/share/doc/wsjtx"
dpkg -i "${TMP_FILE}"
if ! apt install --fix-broken -y; then
  cleanup
  et-log "WSJTX-X update failed!"
  exit 3
fi

cleanup
et-log "WSJT-X install complete"


