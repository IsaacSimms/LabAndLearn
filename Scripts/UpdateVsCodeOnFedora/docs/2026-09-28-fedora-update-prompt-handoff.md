# [MODE A] — Thread Handoff Document

> **Handoff Mode: Implementation**
> **Receiving agent job: Resume and continue**

### Original Design

The thread started as a grill of a VS Code-only post-update ritual and settled on a prompted full-system updater. Behavior below is implemented in `update.py`. Do not re-open those choices unless the user overrides them.

## 1. Thread Purpose

Build a stdlib Python tool that prompts on this Fedora GNOME machine for pending RPM, Flatpak, and firmware updates, applies them after a sudo password in Ptyxis, and performs the VS Code custom-CSS follow-up when the `code` package was upgraded. The script is written and unit-tested. It has not been installed and has not applied a real upgrade.

## 2. Stack & Environment

- Fedora 44, GNOME on Wayland, Ptyxis (`/usr/bin/ptyxis`). No other terminal.
- dnf 5.4.x (`dnf check-update --json` exits 0 even when upgrades exist; parse the JSON). `dnf needs-restarting --json` returns `[{"type":"reboot","reboot_required":bool,...}]` and can take about 90 seconds. Exit 1 means reboot recommended; trust the JSON field.
- Flatpak 1.18.2. fwupd present. `fwupdmgr check-reboot-needed` exits 2 with message `No reboot is necessary` when no reboot is needed; exit 0 means a reboot is needed.
- GNOME Software 50.4. Relevant keys: `org.gnome.software download-updates`, `download-updates-notify`. `allow-updates` hides the Updates panel if false. Leave it true.
- Microsoft VS Code RPM repo already configured. At design time `code` was `1.139.0` with `1.139.1` pending, plus a pending `cursor` RPM. A full `dnf upgrade` includes Cursor. There is no Cursor ritual.
- Custom CSS extension: `~/.vscode/extensions/be5invis.vscode-custom-css-7.5.1`. Command id `extension.updateCustomCSS` (“Reload Custom CSS and JS”). User settings already contain `window.titleBarStyle`, `window.controlsStyle`, and `vscode_custom_css.imports`.
- Shell `python3` is Miniconda. System interpreter is `/usr/bin/python3` (3.14). User linger is off. Graphical session is found with `loginctl` (agent shells often have no `XDG_SESSION_ID`).
- Repo path: `/home/isaacsimms/Desktop/MiscRepos/LabAndLearn`. Script stays in-tree. Moving the repo requires `install` again so unit `ExecStart` paths update.

## 3A. What Was Accomplished

- Wrote `Scripts/UpdateVsCodeOnFedora/update.py` with `install`, `uninstall`, `run`, and hidden `prompt` / `watch`.
- Wrote `Scripts/UpdateVsCodeOnFedora/test_update.py`. `/usr/bin/python3 -m unittest test_update.py` from that directory: 17 tests, OK.
- Confirmed `ptyxis --standalone -- <cmd>` blocks until the command exits (about 2 seconds of startup plus the command).
- Did not run `install`, `uninstall`, `prompt`, or `run`. Did not change gsettings. Did not apply packages.

## 4A. Current State

`update.py` is the whole program. No venv. Units and state are created only by `install`.

`install` saves the current boolean values of `download-updates` and `download-updates-notify` into `~/.local/state/labandlearn-system-update/state.json` (first install only), sets both false, marks `handled_cycle_id` to the current cycle so it does not open a window immediately, writes units under `~/.config/systemd/user/`, and `systemctl --user enable --now` the timer and watch service.

Units:

- `labandlearn-system-update.timer` — `OnCalendar=Mon,Wed,Fri *-*-* 10:00:00`, `Persistent=true`, starts the oneshot.
- `labandlearn-system-update.service` — `Type=oneshot`, `TimeoutStartSec=infinity`, `ExecStart=/usr/bin/python3 <script> prompt`.
- `labandlearn-system-update-watch.service` — long-running `watch`, `Restart=on-failure`, `WantedBy=graphical-session.target`.

`prompt` holds `spawn.lock`, returns immediately if the cycle is not due, the Wayland/X11 session is missing or locked (`LockedHint` not `no`), or `run.lock` is held. Empty successful probe marks the cycle handled and does not open a window. A non-empty successful probe is cached in `probe.json` for 180 seconds. Errors still open Ptyxis so the message is visible. Ptyxis runs `update.py run --scheduled`.

`run` holds `run.lock`. Requires a TTY. Reuses a fresh probe cache, else collects again. Probe failure does not mark the cycle. Empty queue marks it. If an RPM named `code` is pending and a process exe starts with `/usr/share/code/`, it waits until that process exits before the password. `sudo -v` sets the privileged flag; a daemon thread runs `sudo -n -v` every 60 seconds. Then `sudo dnf upgrade -y --refresh`, Flatpak system (sudo) and user, then `sudo fwupdmgr update --assume-yes --no-reboot-check` for sources that had items. Code ritual only if dnf exited 0 and `code` was in the RPM list: `chown -R "$USER" /usr/share/code`, detached `/usr/bin/code`, printed CSS steps. Failures print before the reboot question. Reboot is asked only when dnf or firmware says so. `y` / `yes` runs `sudo systemctl reboot`.

Dismiss flag `can_dismiss` arms when the Code wait or the password notice is shown. SIGHUP, SIGINT, and SIGTERM before that do not mark the cycle. After it is armed, a scheduled run marks the cycle; a hand run does not. After `sudo -v` succeeds, those signals do not mark the cycle.

`uninstall` disables and deletes the three units, restores the saved gsettings booleans, deletes the state directory, and leaves `update.py` in place.

## 5. Key Decisions & Rationale

| Decision | Rationale |
|----------|-----------|
| Live `dnf upgrade` plus Flatpak and fwupd, not GNOME Software offline updates | User wants the Updates page contents without opening Software. VS Code chown/launch can happen in the same sitting. Reboot only when required. |
| Password in Ptyxis is the sign-off. Close before the password skips. | User must see the list and can back out. |
| Scheduled close-before-password marks the cycle handled. Hand-run close does not. Preflight failure never marks it. | “Not this time” lasts until the next Mon/Wed/Fri 10:00. A look via `run` must not silence the schedule. A lock or metadata failure retries on the next unlock. |
| Empty probe marks the cycle and stays quiet | Avoid a window, and avoid rechecking on every later unlock that week. |
| Partial apply still does the Code ritual and reboot question for what succeeded, and leaves the cycle due | Next unlock should show what is still pending. |
| Quit-Code wait is before the password, and only by the user | Code’s save dialog. Closing during that wait dismisses a scheduled cycle. No polite SIGTERM. |
| Script does not run `extension.updateCustomCSS` or click the corrupt-install dialog | `code` has no stable CLI for that command. Wayland UI automation was rejected. |
| Reboot question after the CSS reminder | Yes reboots now and the CSS loop happens after login. No leaves the machine up. |
| `install` turns off only `download-updates` and `download-updates-notify` | One automatic updater. Updates page stays available. |
| Per-user timer plus unlock watcher, linger left off | Prompt must open on the graphical session. User is at work at 10:00. Locked or logged-out waits for unlock/login. |
| Script stays in the git repo; `/usr/bin/python3`; no venv | User services do not see the Miniconda PATH setup. |
| `install` marks the current cycle handled | Enabling the watcher must not pop a window in the install session. |

## 6. Blockers & Open Questions

- `install` has never been run. Units, gsettings writes, and the unlock watcher are untested on this machine.
- No live upgrade has been run (`dnf`, Flatpak, fwupd, chown, Code launch, reboot prompt).
- Screen lock → `LockedHint=yes` was not checked by locking the session *(inferred from logind; GNOME normally sets it)*. If lock does not set `LockedHint`, a 10:00 run will open Ptyxis on a locked-looking desktop.
- `dnf needs-restarting` is slow (~97s when sampled). The script prints “Checking whether a reboot is required…” first.
- Interrupting `dnf` after the password (16A) can leave an rpm transaction. The script does not repair that.

## 7. Next Steps

1. Read this file and `update.py` before editing. Do not re-decide the table in §5.
2. Do not run `install`, `uninstall`, `prompt`, or `run` unless the user asks. `install` changes Software settings and enables units. `prompt` / `run` can open Ptyxis and, after the password, upgrade the system.
3. If they want it enabled, run `install` as the user (not root) and confirm the two gsettings are false, `allow-updates` is still true, and `systemctl --user status labandlearn-system-update.timer labandlearn-system-update-watch.service` is healthy. The command prints the next prompt time.
4. If they report a real run, reproduce with `update.py run` and fix the failure without widening past §5. Re-run `/usr/bin/python3 -m unittest test_update.py` from `Scripts/UpdateVsCodeOnFedora`.

## 8. Must-Knows for the New Thread

- User is not at this machine at 10:00 on workdays. Catch-up is the normal path. Lock the screen when leaving; 13A opens immediately if the session is already unlocked.
- Do not automate Ctrl+Shift+P, do not dismiss the corrupt-install dialog, do not set `allow-updates` false, do not enable linger, do not copy the script out of the repo.
- Probe commands are unprivileged. Privilege starts at `sudo -v`.
- `can_dismiss` is the difference between “closed an error” (cycle stays due) and “closed the list” (scheduled cycle is handled).
- Tests must not call `prompt`, `run`, or `install`. Importing `update.py` is safe. `save_probe` writes `PROBE_CACHE_PATH`; tests that call it must point that path at a temp file.
- `.vscode/settings.json` lists this folder as a Python project. Runtime does not use that venv.
- No `CONTEXT.md` / `AGENTS.md` in the repo.

## 9. Relevant Artifacts

- `Scripts/UpdateVsCodeOnFedora/update.py` — implementation. Not installed.
- `Scripts/UpdateVsCodeOnFedora/test_update.py` — 17 passing unit tests.
- `Scripts/UpdateVsCodeOnFedora/docs/2026-09-28-fedora-update-prompt-recap.md` — backward-looking recap.
- Future, only after `install`: `~/.config/systemd/user/labandlearn-system-update.service`, `.timer`, `labandlearn-system-update-watch.service`, `~/.local/state/labandlearn-system-update/state.json`.
