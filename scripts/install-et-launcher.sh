#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Installs et-launcher app
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e

ET_LAUNCHER_APP_DL="https://github.com/clifjones/et-launcher/releases/download/app-v0.3.0-20-12b16ae/et-launcher_0.3.0_amd64.AppImage"
DEST_DIR="/opt/appimages"
DEST_FILE="${DEST_DIR}/et-launcher.appimage"

function checkInstall() {
  test -e ${DEST_FILE}
  return $?
}

et-log "Installing et-launcher..."

if [ ! -d ${DEST_DIR} ] ; then
  mkdir ${DEST_DIR}
fi

# Install required debs
apt-get install mlterm -y
[ $? -ne 0 ] && et-log "Error installing debs for et-launcher" && exit 3


# Uninstall any previous versions
if checkInstall; then
  et-log "Removing old et-launcher"
  rm -f ${DEST_FILE}
fi

# Download latest KIWIX Desktop appimage
if ! curl -L -o "${DEST_FILE}" --fail "${ET_LAUNCHER_APP_DL}"; then
  et-log "et-launcher download failed!"
  exit 1
fi

# Set execution bit
chmod ag+x ${DEST_FILE}

et-log "Creating icon to support PNP..."
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/applications/et-launcher.desktop /usr/share/applications/.
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/pixmaps/et-launcher.png /usr/share/pixmaps/.
et-log "Enabling autostart..."
mkdir -p ${SKEL}/.config/autostart
cp -v ${ET_OS_ADDONS_BASE}/overlay/etc/skel/.config/autostart/et-launcher.appimage.desktop ${SKEL}/.config/autostart/.

et-log "et-launcher install complete"


