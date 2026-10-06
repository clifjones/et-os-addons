#!/usr/bin/env bash
#
# Author: David Ross
# Description:
#  Installs FreeDV 2.4.0 (HF digital voice) from the official AppImage.
#  The AppImage is SHA256-verified and extracted, so FreeDV runs without FUSE
#  and without network access. FreeDV bundles its own Hamlib and RADE libraries.
#  Same layout as the ETC R7 + FreeDV build (/opt/freedv -> /opt/freedv-2.4.0).
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e

APP=freedv
VERSION=2.4.0
DOWNLOAD_FILE="FreeDV-${VERSION}-x86_64.AppImage"
FREEDV_DL="https://github.com/drowe67/freedv-gui/releases/download/v${VERSION}/${DOWNLOAD_FILE}"
FREEDV_SHA256="0c9efef78fc06c762b30e3629192975cce4fd1998ab25ba26276503be1e5ca97"
INSTALL_DIR="/opt/${APP}-${VERSION}"
INSTALL_BIN_DIR="${INSTALL_DIR}/bin"
APP_DIR="${INSTALL_DIR}/appdir"
LINK_PATH="/opt/${APP}"

function checkDownload() {
  [ -e "${ET_DIST_DIR}/${DOWNLOAD_FILE}" ] && \
    echo "${FREEDV_SHA256}  ${ET_DIST_DIR}/${DOWNLOAD_FILE}" | sha256sum -c --status -
  return $?
}

et-log "Installing FreeDV ${VERSION}..."

[ ! -d ${ET_DIST_DIR} ] && mkdir -v -p ${ET_DIST_DIR}

# Download the pinned release unless a verified copy is already present
if ! checkDownload; then
  rm -f "${ET_DIST_DIR}/${DOWNLOAD_FILE}"
  if ! curl -L -o "${ET_DIST_DIR}/${DOWNLOAD_FILE}" --fail "${FREEDV_DL}"; then
    et-log "FreeDV download failed!"
    exit 1
  fi
fi

et-log "Verifying ${DOWNLOAD_FILE} SHA256..."
if ! checkDownload; then
  et-log "FreeDV SHA256 mismatch! Expected ${FREEDV_SHA256}."
  rm -f "${ET_DIST_DIR}/${DOWNLOAD_FILE}"
  exit 1
fi

WORK_DIR=$(mktemp -d)
cp "${ET_DIST_DIR}/${DOWNLOAD_FILE}" ${WORK_DIR}/
chmod 755 ${WORK_DIR}/${DOWNLOAD_FILE}
et-log "Extracting AppImage (no FUSE needed at run time)..."
(cd ${WORK_DIR} && ./${DOWNLOAD_FILE} --appimage-extract > /dev/null)

# Uninstall any previous copy of this version
[ -e ${INSTALL_DIR} ] && rm -rf ${INSTALL_DIR}
mkdir -v -p ${INSTALL_BIN_DIR} ${INSTALL_DIR}/share
mv ${WORK_DIR}/squashfs-root ${APP_DIR}
cp -v ${APP_DIR}/freedv256x256.png ${INSTALL_DIR}/share/freedv.png
echo "${VERSION} ${FREEDV_SHA256} ${DOWNLOAD_FILE}" > ${INSTALL_DIR}/VERSION
rm -rf ${WORK_DIR}

et-log "Creating launcher: ${INSTALL_BIN_DIR}/${APP}"
cat <<EOF > ${INSTALL_BIN_DIR}/${APP}
#!/bin/bash
# FreeDV ${VERSION} (extracted AppImage). Arguments are passed to FreeDV.
exec ${LINK_PATH}/appdir/AppRun "\$@"
EOF
chmod -v 755 ${INSTALL_BIN_DIR}/${APP}

[ -e ${LINK_PATH} ] && rm ${LINK_PATH}
ln -v -s ${INSTALL_DIR} ${LINK_PATH}
ln -v -s -f ${LINK_PATH}/bin/${APP} /usr/local/bin/${APP}

et-log "Creating icon..."
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/applications/freedv.desktop /usr/share/applications/.

et-log "FreeDV ${VERSION} install complete"
