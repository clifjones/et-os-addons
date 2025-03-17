#!/usr/bin/env bash
#
# Author: Clifton Jones (KD4CTJ)
# Description: Test WSJT-X Improved install

dpkg -s wsjtx > /dev/null 2>&1

exit $?