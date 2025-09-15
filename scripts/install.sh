#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Install emcomm-tools-os-community then installs additional tools
#

# Load env
. $(dirname $(readlink -f $0))/../scripts/env.sh

# Pre-install script
${SCRIPTS_DIR}/pre-install.sh

set -e

# First install emcomm-tools-os-community
cd ${ET_SCRIPTS_DIR} && ./install.sh

# Set the trap for ERR signal
trap 'handle_error $0 $LINENO "$BASH_COMMAND"' ERR

cd ${SCRIPTS_DIR}

# Install xygrib
${SCRIPTS_DIR}/install-xygrib.sh

# Install WSJT-X-Improved
${SCRIPTS_DIR}/install-wsjtx.sh

# Install Grid Tracker 2
${SCRIPTS_DIR}/install-gridtracker.sh

# Install working KIWIX app
${SCRIPTS_DIR}/install-kiwix.sh

# Customize Gnome Desktop
${SCRIPTS_DIR}/customize-desktop.sh

# Install JS8Spotter
${SCRIPTS_DIR}/install-js8spotter.sh

# Install et-launcher
${SCRIPTS_DIR}/install-et-launcher.sh

# Install ET OS Addons command and support files
${SCRIPTS_DIR}/install-et-os-addons.sh

# Run ETC tests - Check for errors manually
cd ${ET_TESTS_DIR} && ./run-test-suite.sh

# Run et-os-addons tests
cd ${ET_OS_ADDONS_BASE}/tests && ./run-all-tests.sh

echo "**** et-os-addons install completed normally ***"

