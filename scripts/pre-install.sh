#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Initialize build directories, etc.
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

# Ensure dist dir exists
[ ! -e $ET_DIST_DIR ] && mkdir -v $ET_DIST_DIR

# ETC R6's install-js8call.sh downloads JS8Call from files.js8call.com, which no
# longer serves the package (new domain owners). Use the copy ETC itself switched
# to (emcomm-tools-os-community main, commit e52acc6). The ETC R6 build docs apply
# the same fix by replacing install-js8call.sh with the version from main.
JS8CALL_SCRIPT="${ET_SCRIPTS_DIR}/install-js8call.sh"
JS8CALL_URL="https://github.com/thetechprepper/emcomm-tools-os-community/releases/download/emcomm-tools-os-community-20260401-r6-final-6.0.0/js8call_2.2.0_20.04_amd64.deb"
if grep -q '^URL=.*files\.js8call\.com' "${JS8CALL_SCRIPT}"; then
  sed -i "s|^URL=.*|URL=\"${JS8CALL_URL}\"|" "${JS8CALL_SCRIPT}"
  echo "Patched ${JS8CALL_SCRIPT}: JS8Call download URL -> ETC R6 release"
fi
