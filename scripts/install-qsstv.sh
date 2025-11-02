#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Install QSSTV
#

set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh

VERSION=main
TARBALL=qsstv-$VERSION.tar.gz
INSTALL_DIR=/opt/qsstv-$VERSION
LINK_PATH=/opt/qsstv

et-log "Installing QSSTV build dependencies..."
apt install \
  pkg-config g++ libfftw3-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
  libqt5svg5-dev libhamlib++-dev libasound2-dev libpulse-dev libopenjp2-7 \
  libopenjp2-7-dev libv4l-dev build-essential \
  cheese \
  -y

if [ ! -e $ET_DIST_DIR/$TARBALL ]; then

  URL=https://github.com/ON4QZ/QSSTV/archive/refs/heads/${VERSION}.tar.gz

  et-log "Downloading QSSTV version: $URL"
  curl -s -L -o $TARBALL --fail $URL

  [ ! -e $ET_DIST_DIR ] && mkdir $ET_DIST_DIR
  [ ! -e $ET_SRC_DIR ] && mkdir $ET_SRC_DIR
  
  mv -v $TARBALL $ET_DIST_DIR
fi

CWD_DIR=`pwd`

cd $ET_SRC_DIR
tar -xzf $ET_DIST_DIR/$TARBALL && cd QSSTV-$VERSION

[ ! -e $INSTALL_DIR ] && mkdir -v $INSTALL_DIR

[ -e src/build ] && rm -rf src/build
mkdir src/build && cd src/build
qmake ..
make -j2
make install

cp -v ../../qsstv.desktop /usr/share/applications/qsstv.desktop
sed -i "s/^Exec=.*$/Exec=et-qsstv start/" /usr/share/applications/qsstv.desktop
cp -v ../icons/qsstv.png /usr/share/pixmaps/.

[ -e $LINK_PATH ] && rm $LINK_PATH
ln -s $INSTALL_DIR $LINK_PATH

stow -v -d /opt qsstv -t /usr/local

cd $CWD_DIR

et-log "QSSTV install complete"

