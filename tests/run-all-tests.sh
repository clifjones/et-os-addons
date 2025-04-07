#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description: Run all et-os-addons tests

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/../scripts/env.sh

PATH=.:$PATH
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"
RC=0

echo -e "${YELLOW}---------------------------------------"
echo "et-os-addons post-validation test suite"
echo -e "---------------------------------------${NC}"

for test_case in "${ET_OS_ADDONS_BASE}/tests/test-"*.sh; do
  eval ${test_case}
  if [[ $? -eq 0 ]]; then
    printf "%20s ${GREEN}%s${NC}\n" "$(basename ${test_case})" "[PASSED]"
  else
    printf "%20s ${RED}%s${NC}\n" "$(basename ${test_case})" "[FAILED]"
    RC=1
  fi
done

if [[ 1 -eq ${RC} ]]; then
  printf "\n${RED}One or more tests FAILED!${NC}\n"
fi

exit ${RC}
