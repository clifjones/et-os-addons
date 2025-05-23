#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Installs https://kiwix.org/en/applications/
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e

KIWIX_APP_DL="https://download.kiwix.org/release/kiwix-desktop/kiwix-desktop_x86_64.appimage"
DEST_DIR="/opt/appimages"
DEST_FILE="${DEST_DIR}/$(basename ${KIWIX_APP_DL})"

function checkInstall() {
  test -e ${DEST_FILE}
  return $?
}

function removeKiwixPkg() {
  if dpkg-query -W kiwix > /dev/null 2>&1 ; then
    et-log "Removing broken KIWIX first"
    apt purge -y kiwix
  fi
  return $?
 }

et-log "Installing KIWIX Desktop..."

if [ ! -d ${DEST_DIR} ] ; then
  mkdir ${DEST_DIR}
fi

# Insure that we don't have the broken KIWIX installed
# Broken: Webserver, which prevents the hotspot feature
removeKiwixPkg

# Uninstall any previous versions
if checkInstall; then
  et-log "Removing old KIWIX Desktop"
  rm -f ${DEST_FILE}
fi

# Download latest KIWIX Desktop appimage
if ! curl -L -o "${DEST_FILE}" --fail "${KIWIX_APP_DL}"; then
  et-log "KIWIX Desktop download failed!"
  exit 1
fi

# Set execution bit
chmod ag+x ${DEST_FILE}

et-log "Updating Kiwix launcher icon to support PNP..."
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/applications/kiwix.desktop /usr/share/applications/.
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/pixmaps/kiwix-desktop.svg /usr/share/pixmaps/.

et-log "KIWIX Desktop install complete"


