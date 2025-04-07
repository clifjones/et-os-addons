#
# Author: Clifton Jones (KD4CTJ)
# Description: Load environment and functions
#

echo "Loading env..."

SCRIPT_PATH="$(readlink -f $0)"
SCRIPTS_DIR="$(dirname ${SCRIPT_PATH})"
export ET_OS_ADDONS_BASE="${SCRIPTS_DIR}/.."
export ET_SCRIPTS_DIR="${ET_OS_ADDONS_BASE}/emcomm-tools-os-community/scripts"
export ET_TESTS_DIR="${ET_OS_ADDONS_BASE}/emcomm-tools-os-community/tests"
export SKEL="/etc/skel"

export ET_ENV_LOADED=1
export ET_EXPERT=1

. ${ET_SCRIPTS_DIR}/env.sh
. ${ET_SCRIPTS_DIR}/functions.sh

# Must run as user root
exitIfNotRoot

# Function to handle errors
handle_error() {
  local filename="$1"
  local lineno="$2"
  local command="$3"
  echo "Error in file: ${filename} on line ${lineno}: ${command}" >&2
  echo "*** etc-os-addons install FAILED! ***"
  exit 1
}

