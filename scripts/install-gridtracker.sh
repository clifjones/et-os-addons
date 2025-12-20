#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Installs Grid Tracker 2
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e 

GRIDTRACKER2_DEB_DL="https://download2.gridtracker.org/GridTracker2-2.250914.1-amd64.deb"
TMP_FILE="/tmp/gridtracker2-tmp.deb"

function cleanup() {
  [ -e "{TMP_FILE}" ] && unlink "${TMP_FILE}"
  return 0
}

function checkInstall() {
  apt -q list gridtracker* | grep -i "installed"
  return $?
}

et-log "Installing Grid Tracker 2..."

# Uninstall any previous versions
if checkInstall; then
  et-log "Removing old Grid Tracker 2"
  apt purge -y gridtracker2
fi

# Download target version of Grid Tracker 2 and install
if ! curl -s -L -o "${TMP_FILE}" --fail "${GRIDTRACKER2_DEB_DL}"; then
  et-log "Grid Tracker 2 download failed!"
  cleanup
  exit 1
fi

# Install DEB file. Then fix dependency errors
if ! dpkg -i "${TMP_FILE}" ; then
  cleanup
  et-log "Grid Tracker 2 update failed!"
  exit 3
fi

cleanup
et-log "Grid Tracker 2 install complete"


