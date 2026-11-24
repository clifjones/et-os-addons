#!/bin/bash
# Author   : EmComm Tools R7 + FreeDV custom build
# Date     : 5 October 2026
# Purpose  : Test FreeDV integration with et-mode/et-kill-all (no radio,
#            display or PipeWire required, so it also runs in the Cubic chroot)

ET_BIN=/opt/emcomm-tools/bin
ET_FREEDV=${ET_BIN}/et-freedv
RADIO_CONF=/opt/emcomm-tools/conf/radios.d/yaesu-ft991a.json
DESKTOP=/usr/share/applications/freedv.desktop

fail() { echo "test-et-freedv: $1" >&2; exit 1; }

# 1. Launcher present, valid and wired into ETC
[[ -x ${ET_FREEDV} ]]                                        || fail "et-freedv missing"
bash -n ${ET_FREEDV}                                         || fail "et-freedv syntax"
${ET_FREEDV} > /dev/null 2>&1 && fail "et-freedv without arguments must fail"
grep -q '^Exec=/opt/emcomm-tools/bin/et-freedv start' ${DESKTOP} || fail "freedv.desktop does not use et-freedv"
ICON=$(sed -n 's|^Icon=||p' ${DESKTOP})
[[ -n "${ICON}" && -e "${ICON}" ]]                          || fail "freedv.desktop icon missing: ${ICON}"

# 2. Runtime dependencies
for cmd in jq pw-dump rigctl python3 setsid notify-send awk pgrep timeout; do
  command -v ${cmd} > /dev/null                              || fail "missing dependency: ${cmd}"
done
python3 -c 'import ctypes.util, sys; sys.exit(0 if ctypes.util.find_library("X11") else 1)' \
                                                             || fail "libX11 not found (needed to close FreeDV safely)"

# 3. INI editing keeps unrelated settings (e.g. the headset) untouched
TMP=$(mktemp -d)
trap 'rm -rf ${TMP}' EXIT
cat > ${TMP}/freedv.conf <<'EOF'
FirstTimeUse=0
[Audio]
soundCard1InDeviceName=old-radio-in
soundCard2InDeviceName=my-headset-mic
soundCard2OutDeviceName=my-headset-out
[Hamlib]
RigNameStr=Yaesu FT-991
SerialPort=/dev/ttyUSB4
[Reporting/FreeDV]
Enable=0
EOF
(
  source <(sed -n '/^ini_set()/,/^}/p; /^ini_get()/,/^}/p; /^ini_default()/,/^}/p' ${ET_FREEDV})
  F=${TMP}/freedv.conf
  ini_set "$F" Hamlib RigNameStr "Hamlib NET rigctl"
  ini_set "$F" Hamlib SerialPort "localhost:4532"
  ini_set "$F" Audio soundCard1InDeviceName "new-radio-in"
  ini_set "$F" Reporting Callsign "N0TEST"
  ini_default "$F" Reporting/FreeDV Enable 1
  [[ "$(ini_get "$F" Hamlib RigNameStr)" == "Hamlib NET rigctl" ]]   || exit 1
  [[ "$(ini_get "$F" Hamlib SerialPort)" == "localhost:4532" ]]      || exit 1
  [[ "$(ini_get "$F" Audio soundCard1InDeviceName)" == "new-radio-in" ]] || exit 1
  [[ "$(ini_get "$F" Audio soundCard2InDeviceName)" == "my-headset-mic" ]] || exit 1
  [[ "$(ini_get "$F" Audio soundCard2OutDeviceName)" == "my-headset-out" ]] || exit 1
  [[ "$(ini_get "$F" Reporting Callsign)" == "N0TEST" ]]             || exit 1
  [[ "$(ini_get "$F" Reporting/FreeDV Enable)" == "0" ]]             || exit 1
  [[ "$(head -1 "$F")" == "FirstTimeUse=0" ]]                        || exit 1
) || fail "INI editing"

# 4. 'stop' is a safe no-op when FreeDV is not running (et-kill-all calls it)
HOME=${TMP} timeout 20 ${ET_FREEDV} stop > /dev/null 2>&1    || fail "et-freedv stop failed with FreeDV not running"

exit 0
