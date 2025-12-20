#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Initialize git submodules
#

# Exit on error
set -o errexit
set -o pipefail

# Ensure git submodules are properly initialized and synced with remote origin
SCRIPT_DIR="$(dirname $(readlink -f $0))"
REPO_ROOT="$(readlink -f ${SCRIPT_DIR}/..)"
TEMP_DIR=""

# Cleanup function
cleanup() {
  if [ -n "${TEMP_DIR}" ] && [ -d "${TEMP_DIR}" ]; then
    rm -rf "${TEMP_DIR}"
  fi
}

# Trap to handle errors and cleanup
trap 'cleanup; exit 1' ERR
trap 'cleanup' EXIT
# Ensure git and wget is installed
cp -v ${REPO_ROOT}/overlay/etc/apt/sources.list /etc/apt/
apt update
apt install git wget -y
[ $? -ne 0 ] && echo "Error installing git or wget" && exit 1

# Check repo install method and initialize submodules accordingly
if [ -e ${REPO_ROOT}/.git/config ]; then
  # Git repo
  echo -ne "\n\n"
  echo "*** Git repo detected. Syncing submodule URLs... ***"
  echo -ne "\n\n"
  sleep 2
  (cd "${REPO_ROOT}" && git submodule sync --recursive)
  echo "Initializing and updating git submodules..."
  (cd "${REPO_ROOT}" && git submodule update --init --recursive --remote)
else
  # Tarball repo
  TEMP_DIR="$(mktemp -d)"

  # Parse .gitmodules to get URL and branch, then create tarball URL
  ETC_REPO_URL="$(git config -f ${REPO_ROOT}/.gitmodules --get submodule.emcomm-tools-os-community.url)"
  ETC_REPO_BRANCH="$(git config -f ${REPO_ROOT}/.gitmodules --get submodule.emcomm-tools-os-community.branch)"
  ETC_REPO_TARBALL_URL="${ETC_REPO_URL}/archive/refs/heads/${ETC_REPO_BRANCH}.tar.gz"

  echo -ne "\n\n"
  echo "*** Tarball repo detected. Initializing submodules from ${ETC_REPO_TARBALL_URL} ***"
  echo -ne "\n\n"
  sleep 2
  wget -O ${TEMP_DIR}/emcomm-tools-os-community.tar.gz ${ETC_REPO_TARBALL_URL}
  tar -xzf ${TEMP_DIR}/emcomm-tools-os-community.tar.gz -C ${TEMP_DIR}
  cp -r ${TEMP_DIR}/emcomm-tools-os-community-*/* ${REPO_ROOT}/emcomm-tools-os-community/.
  cleanup && echo "Submodules initialized successfully"
fi
