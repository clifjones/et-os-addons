# EmComm Tools OS Community add-ons
These add-on extend [EmComm Tools OS Community](https://github.com/thetechprepper/emcomm-tools-os-community) to contain popular radio packet tools not in the original distribution. This can be useful if you want to practice using your offline emcomm appliance out in the field with more popular modes like FT8 during POTA/SOTA operations.

## Installation
There are two ways to install `et-os-addons` depending on your workflow. You can either update your existing installation, or you can do it as part of building an image for use on an offline appliance. Either way will work but the process is different for each.

### 1) Existing EmComm Tools Installation

1. Follow the instructions in the [EmComm Tools OS Community](https://community.emcommtools.com/getting-stated/) wiki to build a bootable image. When you're done either install that image on your machine or just boot from it, either way is fine.
1. While booted from that image first create a working folder from which to build `et-os-addons`. It's fine to just make a `temp` folder in your `~/home` directory for this.
1. `cd` into the directory then clone `et-os-addons` with the following command:
    - `git clone --recurse-submodules https://github.com/clifjones/et-os-addons.git`
    - NOTE: DO NOT just use `git clone` or you won't have the necessary `emcomm-tools-community` submodules that are required to update your installation.

***Note:*** *To run a future update from this directory use `git submodule update --init --recursive` from the root `et-os-addons` repo.*

### 2) While Building New Image
To add `et-os-addons` while building an image of EmComm Tools for a new installation you'll need to use the download for `et-os-addons` instead of `emcomm-tools` during ***Step 8*** of the [Creating EmComm Tools Community Image](https://community.emcommtools.com/getting-stated/create-etc-image.html) page. Replace the download URL in that section with:

`https://github.com/clifjones/et-os-addons/archive/refs/heads/main.zip`

You will need to use `unzip` command instead of `tar` for this step. The rest of the process is the same.

---

### Bootable Image Install Notes
Installing the bootable image follows Ubuntu 22.10 install flow. The following notes cover some areas that can cause trouble if one is not familiar with single/mult-boot installs of Ubuntu.

* Upgrading et-os-addons - Before upgrading et-os-addons, run et-user-backup from the command line to create a user data backup. Copy this .tgz file to a USB driver for later.
* Single boot - This is the easiest install method because you simply overwrite the entire disk.

---

## EmComm Tools Community Documentation
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
