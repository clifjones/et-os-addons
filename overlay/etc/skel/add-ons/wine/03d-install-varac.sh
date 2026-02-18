#!/bin/bash
#
# Author  : Clif Jones KD4CTJ
# Date    : 17 February 2025
# Updated : 17 February 2025
# Purpose : Install VarAC
source ./common-checks.sh

# Prerequisite: VarAC requires .NET 4.8 and GDI+
et-log "Installing VarAC prerequisites..."
winetricks --unattended --force dotnet48 gdiplus
[[ $? -ne 0 ]] && et-log "Failed to install winetricks prerequisites." && exit 1

# Check for VarAC installer in Downloads
shopt -s nullglob
INSTALLERS=("$HOME/Downloads"/VarAC_Installer*.exe)
shopt -u nullglob

if (( ${#INSTALLERS[@]} == 0 )); then
  et-log "VarAC installer not found in $HOME/Downloads"
  echo -e "${YELLOW}Download the VarAC installer from ${WHITE}https://www.varac-hamradio.com/${YELLOW}"
  echo -e "to your ${WHITE}Downloads${YELLOW} directory, then re-run this script.${NC}"
  exit 1
fi

wine "${INSTALLERS[0]}"

echo -e "${YELLOW}Run ${WHITE}./04-run-regedit.sh${YELLOW} to run registry editor.${NC}"
