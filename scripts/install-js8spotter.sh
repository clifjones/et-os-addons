#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Install JS8Spotter
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e

VERSION="115"
ZIP_FILE="js8spotter-${VERSION}_src.zip"
INSTALL_DIR="${SKEL}/apps/js8spotter-${VERSION}_src"
LINK_PATH="${SKEL}/apps/js8spotter"

et-log "Installing JS8Spotter..."

APP_URL="https://kf7mix.com/files/js8spotter/${ZIP_FILE}"

# Download application zip file
if [ ! -e $ET_DIST_DIR/$ZIP_FILE ]; then
  et-log "Downloading JS8Spotter: $APP_URL"

  curl -s -L -O --fail $APP_URL
  [ $? -ne 0 ] && et-log "Error fetching JS8Spotter" && exit 1 

  [ ! -e $ET_DIST_DIR ] && mkdir -v $ET_DIST_DIR

  mv -v $ZIP_FILE $ET_DIST_DIR/$ZIP_FILE
else
  et-log "${ZIP_FILE} already downloaded. Skipping..."
fi

# Install application zip file
CWD_DIR=$(pwd)

if [ ! -e "${INSTALL_DIR}" ]; then
  mkdir -p ${SKEL}/apps
  cd ${SKEL}/apps
  unzip ${ET_DIST_DIR}/${ZIP_FILE}
  # Create a relative link so it relocates properly
  ln -sr ./js8spotter-${VERSION}_src ./js8spotter

  # Install documentation
  et-log "Installing JS8Spotter doc files..."
  mkdir -p ${SKEL}/Documents/JS8Spotter
  mv ${LINK_PATH}/*.pdf ${SKEL}/Documents/JS8Spotter/.
else
  et-log "${INSTALL_DIR} already exists."
fi

# Install required debs
apt-get install python3-tksnack python3-pip sqlite3 -y
[ $? -ne 0 ] && et-log "Error installing debs for JS8Spotter" && exit 3

# Install Python dependencies
pip3 install --user requests
[ $? -ne 0 ] && et-log "Error installing Python libs for JS8Spotter" && exit 4
# Move the local libs to skel
mkdir -p /etc/skel/.local/lib
rsync -a ${HOME}/.local/lib/python3.10 /etc/skel/.local/lib/.
# Pick up Python libs already installed globally
rsync -a /usr/lib/python3/dist-packages/urllib3* /etc/skel/.local/lib/python3.10/site-packages/.

cd ${CWD_DIR}

et-log "Updating JS8Spotter launcher icon to support PNP..."
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/applications/js8spotter.desktop /usr/share/applications/.
cp -v ${LINK_PATH}/js8spotter.ico /usr/share/pixmaps/.

et-log "JS8Spotter install complete"
