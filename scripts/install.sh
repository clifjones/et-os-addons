#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Install emcomm-tools-os-community then installs additional tools
#

SCRIPT_PATH="$(readlink -f $0)"
SCRIPTS_DIR="$(dirname ${SCRIPT_PATH})"
export ET_OS_ADDONS_BASE="${SCRIPTS_DIR}/.."
ET_SCRIPTS_DIR="${ET_OS_ADDONS_BASE}/emcomm-tools-os-community/scripts"

. ${ET_SCRIPTS_DIR}/env.sh
. ${ET_SCRIPTS_DIR}/functions.sh

# Must run as user root
exitIfNotRoot

# First install emcomm-tools-os-community
cd ${ET_SCRIPTS_DIR} && ./install.sh

cd ${SCRIPTS_DIR}

# Install WSJT-X
${SCRIPTS_DIR}/install-wsjtx.sh

${SCRIPTS_DIR}/install-kiwix.sh

# Install ET OS Addons command and support files
${SCRIPTS_DIR}/install-et-os-addons.sh



