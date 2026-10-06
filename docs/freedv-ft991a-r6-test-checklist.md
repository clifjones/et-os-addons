# FreeDV on ETC R6 (et-os-addons): FT-991A test checklist

Run this on a machine installed from an et-os-addons `feature/freedv` build, with a Yaesu FT-991A
connected over USB. Each step lists what to look for. Note PASS/FAIL and anything unexpected.

Helpful while testing (read-only):

    tail -f ~/.local/share/emcomm-tools/freedv.log
    rigctl -m 2 f m t                    # frequency, mode, passband, PTT via rigctld
    cat ~/.config/emcomm-tools/et-mode   # last et-mode selection

## 0. Build and install
| # | Check | Expect | Result |
|---|---|---|---|
| 0.1 | Build log | `install-freedv.sh`: "FreeDV 2.4.0 install complete"; `install-freedv-et-mode.sh`: "Patched et-mode", "Patched et-kill-all", "Added FreeDV settings", no ERROR | |
| 0.2 | Test suites at the end of the build | `run-test-suite.sh` (ETC) and `tests/run-all-tests.sh` (et-os-addons) all PASSED, incl. `test-freedv.sh` and `test-et-freedv.sh` | |
| 0.3 | After install, first login | `et-user` done (callsign, grid), FT-991A selected with `et-radio` | |

## 1. et-mode → FreeDV
| # | Check | Expect | Result |
|---|---|---|---|
| 1.1 | `et-mode` menu (also from et-launcher) | "HF Digital Voice (FreeDV)" listed; select it | |
| 1.2 | FreeDV starts | Window opens; terminal/notification shows the FT-991A notes (WIDTH 3000, DT GAIN) | |
| 1.3 | First start only | FreeDV Easy Setup shows radio audio and CAT already filled in; pick the headset once | |
| 1.4 | CAT owner | `ls -l /proc/$(pgrep -f appdir/usr/bin/freedv)/fd \| grep -c tty` = 0; FreeDV log shows `Hamlib NET rigctl` via `localhost:4532` | |
| 1.5 | CAT frequency | Changing the band/frequency in FreeDV moves the radio | |
| 1.6 | Mode and WIDTH | Radio in DATA-LSB below 10 MHz (except 60 m), DATA-USB above; WIDTH 3000 on the radio's display; `rigctl -m 2 m` = `PKTLSB 3000` / `PKTUSB 3000` | |
| 1.7 | DT GAIN | Set DT GAIN for FreeDV on the radio (no CAT command; reminder only) | |
| 1.8 | RX | Decodes a FreeDV signal (RADE or 700D/E) on the air | |
| 1.9 | PTT / TX | PTT from FreeDV keys the radio; RF output on a wattmeter/dummy load; ALC reasonable; PTT released afterwards (`rigctl -m 2 t` = 0) | |
| 1.10 | Headset | Mic and playback through the headset; headset settings unchanged after restart | |
| 1.11 | Audio levels untouched | `amixer -c ET_AUDIO` before and during FreeDV identical | |
| 1.12 | et-mode state | `~/.config/emcomm-tools/et-mode` = `freedv` | |

## 2. et-mode → Winlink over HF (ARDOP), with FreeDV still running
This also covers the one path not tested end to end on R7: `et-kill-all` closing a *running* FreeDV.

| # | Check | Expect | Result |
|---|---|---|---|
| 2.1 | Select "Winlink over HF (ARDOP)" in `et-mode` while FreeDV is open | FreeDV window closes by itself within a few seconds (no "terminated" message in the ET log) | |
| 2.2 | PTT | Radio not transmitting; `rigctl -m 2 t` = 0 | |
| 2.3 | FreeDV settings saved | Reopen later: FreeDV kept its settings (headset, window) | |
| 2.4 | Radio hand-back | Radio back in the mode it had before FreeDV (normally DATA-USB), `rigctl -m 2 m` shows it; restore your ARDOP DT GAIN (reminder shown) | |
| 2.5 | ARDOP starts | No "device busy"; Pat opens; a Winlink connection over ARDOP succeeds | |
| 2.6 | et-mode state | `winlink-ardop` | |

## 3. Back to FreeDV, and closing from its window
| # | Check | Expect | Result |
|---|---|---|---|
| 3.1 | `et-mode` → FreeDV again | Starts normally; mode/WIDTH set again | |
| 3.2 | Close FreeDV from its window, then select any other et-mode | Radio mode handed back even though FreeDV was already closed | |
| 3.3 | Start WSJT-X (or JS8Call), then select FreeDV | FreeDV refuses to start and names the app holding the radio audio | |

## Report
Return the filled-in tables, the ETC/et-os-addons commits used (`git -C et-os-addons log -1`,
`git -C et-os-addons/emcomm-tools-os-community log -1`), and `~/.local/share/emcomm-tools/freedv.log`.
Don't include `~/.config/emcomm-tools/user.json` (Winlink password).
