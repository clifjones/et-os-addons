#!/bin/bash
#
# Author  : Clif Jones KD4CTJ
# Date    : 17 February 2025
# Updated : 17 February 2025
# Purpose : Install VARA Terminal
source ./common-checks.sh

VARA_HOME="$HOME/.wine32/drive_c/VARA Terminal"
VARA_PATTERN="VARA%20Terminal"

./vara-downloader.sh "${VARA_PATTERN}"
[[ $? -ne 0 ]] && et-log "Error downloading VARA Terminal" && exit 1

DOWNLOAD_FILE=$(ls *.zip | grep "${VARA_PATTERN}")
[[ ! -e "${DOWNLOAD_FILE}" ]] && et-log "VARA download file not found" && exit 1

unzip -o ${DOWNLOAD_FILE}

wine 'VARA Terminal setup (Run as Administrator).exe'

if [ ! -e "${VARA_HOME}/nt4pdhdll.exe" ]; then
  et-log "Install missing DLL..."

  CWD=$(pwd)

  cd "${VARA_HOME}"
  curl -s -f -L -O \
    http://download.microsoft.com/download/winntsrv40/update/5.0.2195.2668/nt4/en-us/nt4pdhdll.exe && unzip nt4pdhdll.exe
  cd ${CWD}
fi

echo -e "${YELLOW}Run ${WHITE}./03d-install-varac.sh${YELLOW} to install VarAC.${NC}"
