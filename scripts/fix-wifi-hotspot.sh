#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#  Fix WiFi Hotspot but in Ubuntu 22.10

et-log "Configuring WiFi Hotpspot..."

nmcli c modify Hotspot 802-11-wireless-security.pmf 1

