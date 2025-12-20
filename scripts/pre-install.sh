#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Make additional changes to the desktop, such as default X server and Gnome overrides
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

# Ensure git submodules are properly initialized and synced with remote origin
SCRIPT_DIR="$(dirname $(readlink -f $0))"
REPO_ROOT="$(readlink -f ${SCRIPT_DIR}/..)"

# Change to repo root to run git commands
cd "${REPO_ROOT}" || exit 1

# Sync submodule URLs with .gitmodules (in case URLs have changed)
echo "Syncing git submodule URLs..."
git submodule sync --recursive

# Initialize and update submodules recursively
echo "Initializing and updating git submodules..."
git submodule update --init --recursive --remote

# Ensure dist dir exists
[ ! -e $ET_DIST_DIR ] && mkdir -v $ET_DIST_DIR
