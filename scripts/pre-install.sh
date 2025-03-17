#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description:
#   Make additional changes to the desktop, such as default X server and Gnome overrides
#

# Load env if this script executed individually
[ -z "$ET_ENV_LOADED" ] && . $(dirname $(readlink -f $0))/env.sh

# Ensure dist dir exists
[ ! -e $ET_DIST_DIR ] && mkdir -v $ET_DIST_DIR
