# Fedora update prompt

**Date:** 2026-09-28
**Type:** implementation
**Environment / Systems:** Fedora 44, GNOME on Wayland, Ptyxis, dnf5, Flatpak, fwupd, GNOME Software 50.4

## TL;DR

A Python updater at `Scripts/UpdateVsCodeOnFedora/update.py` replaces the GNOME Software Updates ritual: a Ptyxis window lists pending RPMs, Flatpaks, and firmware, the sudo password applies them, and a VS Code custom-CSS reminder runs when `code` was upgraded. It is not installed yet.

## Context & Goal

Updating VS Code on this Fedora desktop breaks a custom title-bar / hidden-app-icon setup (`be5invis.vscode-custom-css`). The Microsoft repo and the CSS settings were already in place. The goal grew from a one-shot Code update into a prompted replacement for the Software Updates page, including normal Fedora updates, on a machine the user is not sitting at during the workday.

## Key Points Explored

- GNOME Software’s Updates page is the offline “Requires Restart” path. The script applies updates live in the terminal instead. A reboot is a separate yes/no only when `dnf needs-restarting` or firmware asks.
- `code` has no Software row of its own (the AppStream id `com.visualstudio.code` is the Flatpak). The RPM update is inside the system set. After it upgrades, the script chowns `/usr/share/code`, launches Code, and prints the Reload Custom CSS steps. It does not drive the command palette. Session is Wayland.
- Schedule is Monday, Wednesday, and Friday at 10:00. The user is at work then. The window opens on the next unlock of the graphical session, including unlock of a session left locked. One catch-up covers every missed 10:00.
- Software’s `download-updates` and `download-updates-notify` are turned off by `install`. `allow-updates` stays on, so the Updates page still works for a manual visit.
- `python3` on the shell PATH is Miniconda. User services do not load the shell profile, so units call `/usr/bin/python3`.

## Decisions & Outcomes

Shipped `update.py` (stdlib only) and `test_update.py` (17 tests, all passing). `install` / `uninstall` / `run` are the user-facing commands. `prompt` and `watch` are for systemd.

Not run: `install`, `uninstall`, and a real upgrade. Ptyxis was checked only far enough to see that `ptyxis --standalone -- <cmd>` waits until the command exits.

## Open Questions / Next Steps

- Run `install` when the schedule should go live. The command prints the next prompt time and does not open a window immediately.
- Lock the screen when leaving. An unlocked session gets the window at 10:00.
- The live `dnf` / Flatpak / fwupd / reboot path has not been executed.

## Artifacts

- `Scripts/UpdateVsCodeOnFedora/update.py` — updater, not installed.
- `Scripts/UpdateVsCodeOnFedora/test_update.py` — cycle and parse tests.
- `Scripts/UpdateVsCodeOnFedora/docs/2026-09-28-fedora-update-prompt-handoff.md` — resume notes for a later session.
- User state the script will create on install: `~/.config/systemd/user/labandlearn-system-update.{service,timer}` and `labandlearn-system-update-watch.service`, plus `~/.local/state/labandlearn-system-update/state.json`.
