# FreeDV integration with et-mode (et-os-addons, ETC R6)

FreeDV 2.4.0 becomes a selectable ETC mode ("HF Digital Voice (FreeDV)") with a PnP launcher,
`et-freedv`, that follows the ETC launcher conventions (`et-wsjtx`, `et-fldigi`).

This is the same integration as in the ETC R7 + FreeDV build, which was developed and verified
2026-10-05 on a Panasonic Toughbook with a Yaesu FT-991A over USB (CP2105 CAT `if00`, Burr-Brown
USB Audio CODEC) and a Logitech H570e headset. `et-freedv` is byte-identical in both builds.
The R6 build must still be tested on an FT-991A: see `docs/freedv-ft991a-r6-test-checklist.md`.

## Design

| Concern | How it works |
|---|---|
| CAT/PTT | FreeDV uses Hamlib **NET rigctl** at `localhost:4532`, same as Pat/ARDOP and fldigi. The system `rigctld` stays the only owner of `/dev/et-cat`. Previously FreeDV opened the CAT serial port itself, alongside `rigctld`. |
| Radio audio | `soundCard1In/OutDeviceName` are set to the PipeWire nodes of the udev-tagged `ET_AUDIO` card (looked up via `pw-dump`, `alsa.card` = card behind `/proc/asound/ET_AUDIO`). Works for any ETC radio. |
| Headset | FreeDV "sound card 2" is **never** changed. If none is set, the user is told to pick one. |
| Callsign/grid | `user.json` callsign and `et-system-info grid` → `[Reporting] Callsign/GridSquare` on every start. |
| FreeDV Reporter | `[Reporting] Enable` and `[Reporting/FreeDV] Enable` default to 1 **only if not already set**, so a user's opt-out wins. |
| Config editing | Small awk INI setter. Only the keys above are written. Refuses to edit while FreeDV runs (FreeDV rewrites its config on exit). |
| Conflicts | `start` runs `et-kill-all` (ETC modes), then refuses to start if a non-PipeWire process (e.g. WSJT-X, JS8Call, fldigi) holds the `ET_AUDIO` PCM, naming that process. Those apps are not killed, matching upstream (et-kill-all never kills them). |
| Radio mode/width | Only for radios whose JSON defines `freedv.dataPassband`. Mode follows FreeDV's own rule (`GetModeForFrequency`): PKTLSB below 10 MHz except 60 m, otherwise PKTUSB. Passband is set via `rigctl M <mode> <passband>` and read back. If it can't be set or confirmed, the user gets a persistent "<model> FreeDV: Set WIDTH to <n> Hz" notification. Skipped (warning only) when FreeDV is set to use USB/LSB, or when the operator manages modes (`EnableFreqModeChanges=0`) and the radio isn't in a data mode. |
| Hand-back | The mode/passband found before FreeDV is saved to `~/.local/share/emcomm-tools/freedv-radio-mode.state` and restored by `et-freedv stop` (from `et-kill-all`, i.e. every mode switch), even if FreeDV was already closed from its window. It is restored only if the radio is still in PKTUSB/PKTLSB (the operator hasn't changed it). Frequency is never touched. |
| Shutdown | FreeDV has no SIGTERM handler, so killing it doesn't unkey PTT or save its config. `stop` sends EWMH `_NET_CLOSE_WINDOW` to FreeDV's main window (python3 + ctypes/libX11; FreeDV runs under XWayland via the AppImage's `GDK_BACKEND=x11`). FreeDV's own close handler then unkeys PTT, stops the modem and saves the config. TERM, then KILL, are a last resort after 20 s. After that it always sends `rigctl T 0`, waits for PipeWire to release `ET_AUDIO` (so ARDOP/Mercury can open `plughw` directly), then restores the radio mode. |
| Launch | `setsid -f`, so FreeDV survives the `et-mode` terminal closing. Output goes to `~/.local/share/emcomm-tools/freedv.log`. Writes `freedv` to the et-mode state file (also when started from the menu). |
| Operator notes | Radio JSON `freedv.notes` (generic) plus the optional per-user `~/.config/emcomm-tools/freedv.json` `radios.<id>.start/stop` reminders are shown on start/stop (terminal, ET log, persistent notification). |

## FT-991A findings

* **WIDTH**: FreeDV RADEV1 is 1.5 kHz wide. A DATA filter of about 500 Hz (measured from the radio's
  RX audio: -6 dB passband 1251–1734 Hz) made FreeDV decode only fragments. WIDTH 3000 fixed it.
  DATA-USB and DATA-LSB **share one width** (verified). Hamlib 4.5 `M PKTUSB|PKTLSB 3000` → SH index
  17. It reads back as 3000 and matches the front-panel 3000 setting. The measured RX passband
  changes accordingly (2400 vs 3000 verified). The Hamlib FT-991 PKT width table uses Yaesu's
  RTTY/PSK column, so only the PKT modes are automated.
* **DT GAIN**: no CAT command exists (Yaesu FT-991A CAT Operation Reference Manual: no DT GAIN, and no
  EX menu for DATA input gain; `MG` is MIC GAIN only). Not automated. Reminders only.
* **Sideband**: FreeDV uses LSB below 10 MHz. Winlink/ARDOP use USB on all bands. The hand-back
  restores DATA-USB for Winlink.
* PipeWire sets the CODEC's hardware `PCM Playback Volume` (53/76, -23 dB) when the device appears.
  ARDOP uses the same control. `et-freedv` never changes any PipeWire/ALSA volume.

## Files

| File | Change |
|---|---|
| `scripts/install-freedv.sh` | downloads the FreeDV 2.4.0 AppImage from the drowe67/freedv-gui v2.4.0 release, verifies SHA256 `0c9efef7…e5ca97`, extracts it to `/opt/freedv-2.4.0` (`/opt/freedv`, `/usr/local/bin/freedv`) |
| `scripts/install-freedv-et-mode.sh` | installs `et-freedv`; patches ETC's installed `et-mode` and `et-kill-all`; merges the FT-991A `freedv` block; installs the menu launcher |
| `patches/freedv/et-mode-freedv-r6.patch` | new mode `freedv` → `et-freedv start` (after "Winlink over HF (VARA HF)" in the menu) |
| `patches/freedv/et-kill-all-freedv-r6.patch` | calls `et-freedv stop` before `stop_pat` |
| `patches/freedv/yaesu-ft991a.freedv.json` | `freedv.dataPassband` = 3000 and generic notes, merged into `radios.d/yaesu-ft991a.json` with jq |
| `overlay/opt/emcomm-tools/bin/et-freedv` | new (identical to R7) |
| `overlay/usr/share/applications/freedv.desktop` | `Exec=/opt/emcomm-tools/bin/et-freedv start` |
| `overlay/etc/skel/BACKUP_ITEMS.lst` | adds `.config/freedv` (FreeDV's own settings) to `et-user-backup` |
| `tests/test-freedv.sh`, `tests/test-et-freedv.sh` | new (identical to R7); run by `tests/run-all-tests.sh` |

No new packages: jq, pipewire-bin, python3, libx11-6, util-linux, libnotify-bin, procps, patch and
ETC's Hamlib are already installed by ETC.

### How the R6 files are changed
ETC's `et-mode` and `et-kill-all` are patched **after** ETC's own `install.sh` has installed them
(et-os-addons' overlay doesn't ship these files). Each patch is first applied as a dry run with no fuzz.
If ETC's file doesn't match the version the patch was made for, the build stops with an error and the
file is left unchanged. Because each patch also touches the file's header comment, any upstream edit to
`et-mode` or `et-kill-all` stops the build for a review, even if the FreeDV lines would still fit.
Re-running the script is safe: already-patched files are detected and skipped.

The patches were made against ETC `release/r6` (submodule commit `fadb2cd`, same tree as the
`release/r6` tip `4b5e272`). Note that `scripts/init-submodules.sh` uses `git submodule update --remote`,
so a build uses the current `release/r6` tip, not the pinned commit.

To update the patches for a newer ETC: apply the FreeDV hunks by hand to the new `et-mode`/`et-kill-all`
(keep the same lines), then `diff -u --label a/et-mode --label b/et-mode <old> <new> > patches/freedv/et-mode-freedv-r6.patch`.

## Not part of the ISO (user/station specific)

* `~/.config/freedv/freedv.conf`: headset devices, TX attenuation, mic level, window layout, status text.
* `~/.config/emcomm-tools/freedv.json`: per-user reminders. Example with the DT GAIN values used on the
  reference FT-991A (ETC's default CODEC level; good starting values, adjust for your ALC):

  ```json
  { "radios": { "yaesu-ft991a": {
      "start": ["Your FreeDV DT GAIN: about 48 (set on the radio)"],
      "stop":  ["Restore DT GAIN for ARDOP/Winlink: about 6"] } } }
  ```
* Callsign/grid (`et-user`), antenna/tuner settings. DT GAIN itself is set on the radio (no CAT command).

On a fresh user, FreeDV's first start shows its Easy Setup with the radio and CAT already filled in.
The user picks the headset once.

## Adding FreeDV support for another radio

Optional. Add to its `radios.d/<radio>.json`, only after verifying the Hamlib PKT width mapping on
that radio:

```json
"freedv": { "dataPassband": 3000, "notes": ["..."] }
```

Without it, `et-freedv` still configures CAT, audio, callsign and Reporter, and leaves the radio mode alone.

## Reference hardware test results (ETC R7 build, 2026-10-05, FT-991A)

| # | Criterion | Result |
|---|---|---|
| 1 | Only rigctld owns `/dev/et-cat` | PASS: FreeDV has 0 serial fds |
| 2 | FreeDV via `localhost:4532` | PASS: FreeDV log `rigName -Hamlib NET rigctl- via port -localhost:4532-`, 1 TCP session |
| 3 | CAT frequency control | PASS: FreeDV moved the radio across 3.795/7.185/7.192/7.167 MHz |
| 4 | PTT | PASS: TX cycles logged, PTT released |
| 5 | RF transmit | PASS: wattmeter, and a long FreeDV QSO at about 500 mi |
| 6 | RX decode via Burr-Brown | PASS: same QSO; PipeWire links verified |
| 7 | Headset mic/playback | PASS: links to the Logitech H570e unchanged |
| 8 | WIDTH 3000 | PASS: automatic, read back |
| 9 | Switch to ARDOP/Winlink | PASS: Winlink connected after hand-back to DATA-USB |
| 10 | Switch back to FreeDV | PASS |
| 11 | No PipeWire/ALSA volume changes | PASS: before/after snapshot identical |
| 12 | et-mode state | PASS: `freedv` / `winlink-ardop` |

Not tested end to end, by decision: `et-kill-all` closing a *running* FreeDV via the installed path.
The window-close mechanism itself was tested on its own: clean exit in 3 s, config saved, PTT 0.
It is part of the R6 checklist.

## Differences from the ETC R7 + FreeDV build

| Item | R7 build | et-os-addons (R6) |
|---|---|---|
| `et-freedv` | — | **identical** (SHA256 `63ec262d5823ccfd1ce6f4a3be478502c9f6b0631c6cd9161ae63b773b2e54ec`) |
| `test-freedv.sh`, `test-et-freedv.sh`, `freedv.desktop`, FT-991A `freedv` block | — | identical |
| FreeDV download | pinned local artifact cache | downloaded from GitHub at build time, SHA256-verified |
| `et-mode`, `et-kill-all` | edited in the overlay | patched at build time (R6 has no telnet/WWV modes, so the anchors differ) |
| FreeDV menu position | after "Winlink over telnet" | after "Winlink over HF (VARA HF)" |
| FT-991A JSON | edited in the overlay | jq merge at build time |
| `et-user-backup` | upstream (no list file) | `BACKUP_ITEMS.lst` includes `.config/freedv` |
