#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Installs WSJT-X-Improved https://wsjt-x-improved.sourceforge.io
#

WSJTX_DEB_DL="https://downloads.sourceforge.net/project/wsjt-x-improved/WSJT-X_v2.7.1/Linux/wsjtx_2.7.1-devel_improved_AL_PLUS_250106-RC8_amd64.deb"
TMP_FILE="/tmp/wsjtx-tmp.deb"
WSJTX_DESKTOP_FILE="/usr/share/applications/wsjtx.desktop"

function cleanup() {
  unlink "${TMP_FILE}"
  return $?
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
  return $?
fi

# Download target version of WSJT-X-Improved and install
if ! curl -L -o "${TMP_FILE}" --fail "${WSJTX_DEB_DL}"; then
  et-log "WSJT-X-Improved download failed!"
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

# Customize desktop file
if ! grep -q "Exec=et-wsjtx" ${WSJTX_DESKTOP_FILE}; then
  sed -i "s/^Exec=.*$/Exec=et-wsjtx start/" ${WSJTX_DESKTOP_FILE}
fi

cleanup
et-log "WSJT-X install complete"


