# et-os-addons - EmComm Tools OS Community add-ons
et-os-addons extends [EmComm Tools OS Community](https://github.com/thetechprepper/emcomm-tools-os-community) contain popular radio packet tools not contained in the original distribution.

## Installation
Please follow the instructions in the [EmComm Tools OS Community](https://community.emcommtools.com/getting-stated/) wiki to build a bootable image.

### Bootable Image Install Notes
Installing the bootable image follows Ubuntu 22.10 install flow. The following notes cover some areas that can cause trouble if one is not familiar with single/mult-boot installs of Ubuntu.

* Upgrading et-os-addons - Before upgrading et-os-addons, run et-user-backup from the command line to create a user data backup. Copy this .tgz file to a USB driver for later.
* Single boot - This is the easiest install method because you simply overwrite the entire disk.

## Documentation
The main documentation site is provided by the [EmComm Tools OS Community](https://community.emcommtools.com/getting-stated/) wiki.
You must build your own distribution due to the base OS licensing terms. [Please do not distribute pre-built images](https://ubuntu.com/legal/intellectual-property-policy#1-summary).

## Change Log 
et-os-addons adds the following enhancements to [EmComm Tools OS Community](https://github.com/thetechprepper/emcomm-tools-os-community):
- Added [WSJT-X Improved](https://wsjt-x-improved.sourceforge.io/)
- Added [Gridtracker 2](https://gridtracker.org/)
- Added [JS8Spotter](https://kf7mix.com/js8spotter.html)
- Replaced original Kiwix with a version that has a working HTTP server mode.
- Added command line et-hotspot for straightforward WiFi hotspot control.
- Added installer for DisplayLink drivers.
- Enhanced et-user-backup command to allow for user-specified backup directories and files.
- Added VGC VR-N76 radio support (Absorbed into EmComm Tools OS Community)
- Added et-launcher to reduce reliance on Linux command line actions
- Added xygrib for viewing weather maps
- Added prototype Saildocs weather map retrieval scripts
- Added QSSTV and Cheese for webcam and SSTV support
- Added support for the [Blue Ridge Amateur Radio Society NetControl app](https://brars.cc/). (Requires Wine and application install)