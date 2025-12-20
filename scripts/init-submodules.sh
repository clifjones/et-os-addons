#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Initialize git submodules
#

# Ensure git submodules are properly initialized and synced with remote origin
SCRIPT_DIR="$(dirname $(readlink -f $0))"
REPO_ROOT="$(readlink -f ${SCRIPT_DIR}/..)"

# Ensure git is installed
cp -v ${REPO_ROOT}/overlay/etc/apt/sources.list /etc/apt/
apt update
apt install git -y
[ $? -ne 0 ] && echo "Error installing git" && exit 1

# Sync submodule URLs with .gitmodules (in case URLs have changed)
echo "Syncing git submodule URLs..."
(cd "${REPO_ROOT}" && git submodule sync --recursive)

# Initialize and update submodules recursively
echo "Initializing and updating git submodules..."
(cd "${REPO_ROOT}" && git submodule update --init --recursive --remote)

