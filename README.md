# EmComm Tools OS Community add-ons
These add-on extend [EmComm Tools OS Community](https://github.com/thetechprepper/emcomm-tools-os-community) to contain popular radio packet tools not in the original distribution. This can be useful if you want to practice using your offline emcomm appliance out in the field with more popular modes like FT8 during POTA/SOTA operations.

## Installation
Install [Cubic](https://github.com/PJ-Singh-001/Cubic) and start a new session using the Ubuntu 2.10 install image.

Download `et-os-addons` instead of `emcomm-tools-community` during ***Step 8*** of the [Creating EmComm Tools Community Image](https://community.emcommtools.com/getting-stated/create-etc-image.html) page. Replace the download URL in that section with:

`https://github.com/clifjones/et-os-addons/archive/refs/heads/main.tar.gz`

Note: `et-os-addons` contains a specific branch of [EmComm Tools Community](https://github.com/thetechprepper/emcomm-tools-os-community) as a Git submodule. The install script will check and attempt to properly sync this submodule repo during the build if you "clone" the repo. If you download the repo as a `zip` or `tar.gz` file, the submodule installer will attempt to download a tar file of `emcomm-tools-community` and expand it properly in the designated `et-os-addons` subdirectory.

### Summary of Build Steps
1. Start an Ubuntu 2.10 Cubic customization session
2. Download a zip or tar file of [this repo](https://github.com/clifjones/et-os-addons)
3. Copy the resulting repo archive into the Cubic session and return to the customization shell
4. Unzip or Untar the archive into the home directory
5. Change directory to the et-os-addons repo copy with command: `cd et-os-addons`
6. Execute the install script with command: `scripts/install.sh`
7. Ensure that the build completes without error and displays the final test status with all tests passing
8. Complete the customized Ubuntu installer process

### Important Build Notes
* `emcomm-tools-community` Git repo now contains symbolic file links, which is **NOT** compatible with the `zip` file format. TL;DR: Use `tar`. `et-os-addons` currently be downloaded as a `zip` or `tar.gz` file without issue as it will properly add in `emcomm-tools-community` as a `tar.gz` download.
* Some builds of `emcomm-tools-community` exit in error with `dpkg` unmet dependency problems (ex. SDR++ install test fails). Correct the build by running `apt install --fix-broken -y` and re-running the affected install script and re-verifying by re-running the test scripts.

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
- No longer require cloning of the repo to install. Install scripts will add in `emcomm-tools-community` using the `git` command or `wget` depending on the download method automatically.
