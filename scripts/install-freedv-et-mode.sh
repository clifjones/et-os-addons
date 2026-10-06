#!/usr/bin/env bash
#
# Author: David Ross
# Description:
#  Integrates FreeDV with ETC's et-mode (same behaviour as the ETC R7 + FreeDV build):
#   - installs the et-freedv launcher
#   - adds the "HF Digital Voice (FreeDV)" mode to et-mode
#   - makes et-kill-all stop FreeDV safely (PTT off, config saved, radio mode handed back)
#   - adds the FreeDV block (WIDTH 3000, notes) to the Yaesu FT-991A radio configuration
#
#  et-mode and et-kill-all are patched in place after ETC is installed. The patches
#  are applied with no fuzz, after a dry run. If ETC's files no longer match the
#  version the patches were made for, the install stops with an error instead of
#  guessing. Re-running this script is safe.
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

set -e

PATCH_DIR="${ET_OS_ADDONS_BASE}/patches/freedv"
BIN_DIR="${ET_HOME}/bin"
RADIO_CONF="${ET_HOME}/conf/radios.d/yaesu-ft991a.json"
FREEDV_RADIO_BLOCK="${PATCH_DIR}/yaesu-ft991a.freedv.json"

# Patch an installed ETC file. Args: target file, patch file, marker of an applied patch
function applyPatch() {
  local target="$1"
  local patch_file="$2"
  local marker="$3"

  if grep -qF -- "${marker}" "${target}"; then
    et-log "$(basename ${target}) already includes FreeDV support. Skipping."
    return 0
  fi

  if ! patch --dry-run --forward --fuzz=0 --reject-file=- "${target}" "${patch_file}" > /dev/null; then
    et-log "ERROR: ${target} does not match the ETC version $(basename ${patch_file}) was made for."
    et-log "ERROR: ETC may have been updated. ${target} was NOT modified. Update the FreeDV patch."
    exit 1
  fi

  patch --forward --fuzz=0 --reject-file=- --no-backup-if-mismatch "${target}" "${patch_file}"
  bash -n "${target}"
  et-log "Patched $(basename ${target}) for FreeDV"
}

et-log "Integrating FreeDV with et-mode..."

command -v patch > /dev/null || apt install patch -y

# 1. Launcher (identical to the ETC R7 + FreeDV build)
install -v -m 755 ${ET_OS_ADDONS_BASE}/overlay/opt/emcomm-tools/bin/et-freedv ${BIN_DIR}/et-freedv

# 2. et-mode and et-kill-all
applyPatch ${BIN_DIR}/et-mode     ${PATCH_DIR}/et-mode-freedv-r6.patch     'MODE_ID_FREEDV="freedv"'
applyPatch ${BIN_DIR}/et-kill-all ${PATCH_DIR}/et-kill-all-freedv-r6.patch '/opt/emcomm-tools/bin/et-freedv stop'

# 3. FT-991A: merge the "freedv" block into the radio configuration
if [[ "$(jq -r '.id' ${RADIO_CONF})" != "yaesu-ft991a" ]]; then
  et-log "ERROR: ${RADIO_CONF} is not the Yaesu FT-991A configuration."
  exit 1
fi
TMP_FILE=$(mktemp)
jq --argjson freedv "$(cat ${FREEDV_RADIO_BLOCK})" '. + {freedv: $freedv}' ${RADIO_CONF} > ${TMP_FILE}
jq -e '.freedv.dataPassband == 3000 and .rigctrl.id' ${TMP_FILE} > /dev/null
# Write in place to keep the file's owner, mode and the active-radio.json symlink
cat ${TMP_FILE} > ${RADIO_CONF}
rm -f ${TMP_FILE}
et-log "Added FreeDV settings to $(basename ${RADIO_CONF})"

# 4. Menu launcher starts FreeDV through et-freedv
cp -v ${ET_OS_ADDONS_BASE}/overlay/usr/share/applications/freedv.desktop /usr/share/applications/.

et-log "FreeDV et-mode integration complete"
