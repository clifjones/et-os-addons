#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Install CommStatOne - Python add-on for JS8Call groups
#   https://github.com/W5DMH/commstatone
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e

ZIP_FILE="commstatone-main.zip"
APP_URL="https://github.com/W5DMH/commstatone/archive/refs/heads/main.zip"
INSTALL_DIR="${SKEL}/apps/commstatone-main"
LINK_PATH="${SKEL}/apps/commstatone"

et-log "Installing CommStatOne..."

# Download application zip file
[ ! -e $ET_DIST_DIR ] && mkdir -v $ET_DIST_DIR

if [ ! -e $ET_DIST_DIR/$ZIP_FILE ]; then
  et-log "Downloading CommStatOne: $APP_URL"

  cd $ET_DIST_DIR
  curl -s -L -o $ZIP_FILE --fail $APP_URL
  [ $? -ne 0 ] && et-log "Error fetching CommStatOne" && exit 1
  cd - > /dev/null
else
  et-log "${ZIP_FILE} already downloaded. Skipping..."
fi

# Install application zip file
CWD_DIR=$(pwd)

if [ ! -e "${INSTALL_DIR}" ]; then
  mkdir -p ${SKEL}/apps
  cd ${SKEL}/apps
  unzip -o ${ET_DIST_DIR}/${ZIP_FILE}
  # Create a relative symlink so it relocates properly for new users
  rm -f ./commstatone
  ln -s ./commstatone-main ./commstatone

  cd ${CWD_DIR}
else
  et-log "${INSTALL_DIR} already exists."
fi

# Install required debs per linuxinstall.sh
et-log "Installing CommStatOne dependencies..."
DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pyqt5.qtwebengine
[ $? -ne 0 ] && et-log "Error installing debs for CommStatOne" && exit 3

# Install Python dependencies per install.py lininstall()
et-log "Installing CommStatOne Python packages..."
pip3 install feedparser file-read-backwards folium pandas maidenhead
[ $? -ne 0 ] && et-log "Error installing Python libs for CommStatOne" && exit 4

cd ${CWD_DIR}

et-log "Updating CommStatOne launcher icon to support PNP..."
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/applications/commstatone.desktop /usr/share/applications/.
# Use USA.ico or USA-32.png from the app as icon (per repo)
if [ -e ${LINK_PATH}/USA.ico ]; then
  cp -v ${LINK_PATH}/USA.ico /usr/share/pixmaps/commstatone.ico
elif [ -e ${LINK_PATH}/USA-32.png ]; then
  cp -v ${LINK_PATH}/USA-32.png /usr/share/pixmaps/commstatone.png
else
  et-log "Warning: No CommStatOne icon found in app directory"
fi

et-log "CommStatOne install complete"
