#!/usr/bin/python3
"""Prompt for Fedora system updates, then apply them.

The script stays in this repository. ``install`` adds a per-user timer and an
unlock watcher. ``uninstall`` removes those units and restores the GNOME
Software settings that ``install`` changed.

    /usr/bin/python3 update.py install
    /usr/bin/python3 update.py run
    /usr/bin/python3 update.py uninstall
"""

from __future__ import annotations

import argparse
import fcntl
import json
import os
import pwd
import signal
import subprocess
import sys
import threading
import time
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from pathlib import Path

PYTHON = "/usr/bin/python3"
SCRIPT_PATH = Path(__file__).resolve()
STATE_DIR = Path.home() / ".local/state/labandlearn-system-update"
STATE_PATH = STATE_DIR / "state.json"
SPAWN_LOCK_PATH = STATE_DIR / "spawn.lock"
RUN_LOCK_PATH = STATE_DIR / "run.lock"
PROBE_CACHE_PATH = STATE_DIR / "probe.json"
PROBE_CACHE_MAX_AGE = 180
UNIT_DIR = Path.home() / ".config/systemd/user"
SERVICE_NAME = "labandlearn-system-update.service"
TIMER_NAME = "labandlearn-system-update.timer"
WATCH_NAME = "labandlearn-system-update-watch.service"
GSETTINGS_SCHEMA = "org.gnome.software"
GSETTINGS_KEYS = ("download-updates", "download-updates-notify")
# Monday, Wednesday, Friday.
DUE_WEEKDAYS = {0, 2, 4}
CODE_PREFIX = "/usr/share/code/"


@dataclass
class RunFlags:
    scheduled: bool = False
    privileged: bool = False
    # Armed once the user can see a choice: quit Code, or skip before the password.
    # A failed check stays unarmed so closing that window does not consume the cycle.
    can_dismiss: bool = False


RUN = RunFlags()


@dataclass(frozen=True)
class UpdateItem:
    source: str
    name: str
    detail: str

    @property
    def is_vscode(self) -> bool:
        return self.source == "rpm" and self.name == "code"


@dataclass
class Probe:
    items: list[UpdateItem] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.errors

    @property
    def empty(self) -> bool:
        return self.ok and not self.items


class FileLock:
    """Exclusive lock held for the lifetime of the context."""

    def __init__(self, path: Path, blocking: bool) -> None:
        self.path = path
        self.blocking = blocking
        self._handle = None

    def __enter__(self) -> FileLock | None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        handle = open(self.path, "a+")
        flags = fcntl.LOCK_EX
        if not self.blocking:
            flags |= fcntl.LOCK_NB
        try:
            fcntl.flock(handle, flags)
        except BlockingIOError:
            handle.close()
            return None
        self._handle = handle
        return self

    def __exit__(self, exc_type, exc, tb) -> None:
        if self._handle is not None:
            fcntl.flock(self._handle, fcntl.LOCK_UN)
            self._handle.close()
            self._handle = None


def cycle_id(now: datetime) -> str:
    """Latest Monday/Wednesday/Friday 10:00 local time that is not in the future."""
    if now.tzinfo is None:
        now = now.replace(tzinfo=datetime.now().astimezone().tzinfo)
    stamp = now.replace(hour=10, minute=0, second=0, microsecond=0)
    if now < stamp:
        stamp -= timedelta(days=1)
    while stamp.weekday() not in DUE_WEEKDAYS:
        stamp -= timedelta(days=1)
    return stamp.strftime("%Y-%m-%dT%H:%M")


def next_mark(now: datetime) -> datetime:
    """The due mark strictly after ``now``."""
    if now.tzinfo is None:
        now = now.replace(tzinfo=datetime.now().astimezone().tzinfo)
    current = datetime.strptime(cycle_id(now), "%Y-%m-%dT%H:%M").replace(tzinfo=now.tzinfo)
    stamp = current + timedelta(days=1)
    stamp = stamp.replace(hour=10, minute=0, second=0, microsecond=0)
    while stamp.weekday() not in DUE_WEEKDAYS:
        stamp += timedelta(days=1)
    return stamp


def should_mark_cycle_handled(
    *,
    empty: bool,
    all_succeeded: bool,
    dismissed_before_password: bool,
    scheduled: bool,
) -> bool:
    if empty or all_succeeded:
        return True
    if dismissed_before_password:
        return scheduled
    return False


def load_state() -> dict:
    try:
        return json.loads(STATE_PATH.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}


def save_state(state: dict) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    temporary = STATE_PATH.with_suffix(".json.tmp")
    temporary.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
    temporary.replace(STATE_PATH)


def mark_cycle_handled(now: datetime | None = None) -> None:
    state = load_state()
    state["handled_cycle_id"] = cycle_id(now or datetime.now().astimezone())
    save_state(state)


def cycle_is_due(now: datetime | None = None) -> bool:
    now = now or datetime.now().astimezone()
    return load_state().get("handled_cycle_id") != cycle_id(now)


def _run(args: list[str], timeout: int | None = None) -> subprocess.CompletedProcess[str]:
    try:
        return subprocess.run(
            args,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired:
        return subprocess.CompletedProcess(args, 124, stdout="", stderr="timed out")
    except OSError as exc:
        return subprocess.CompletedProcess(args, 127, stdout="", stderr=str(exc))


def parse_dnf_packages(payload: object) -> list[UpdateItem]:
    if not isinstance(payload, dict):
        raise ValueError("dnf JSON was not an object")
    items: list[UpdateItem] = []
    for values in payload.values():
        if not isinstance(values, list):
            continue
        for entry in values:
            if not isinstance(entry, dict) or "name" not in entry:
                continue
            name = str(entry["name"])
            arch = str(entry.get("arch") or "")
            evr = str(entry.get("evr") or "")
            repo = str(entry.get("repository") or "")
            label = name if not arch else f"{name}.{arch}"
            detail = " ".join(part for part in (label, evr, f"({repo})" if repo else "") if part)
            items.append(UpdateItem("rpm", name, detail))
    items.sort(key=lambda item: item.detail)
    return items


def parse_flatpak_refs(text: str, source: str) -> list[UpdateItem]:
    items: list[UpdateItem] = []
    for line in text.splitlines():
        ref = line.strip()
        if not ref or ref.startswith("Looking ") or ref.startswith("Notice:"):
            continue
        name = ref.split("/")[1] if ref.startswith(("app/", "runtime/")) and "/" in ref else ref
        items.append(UpdateItem(source, name, ref))
    return items


def parse_firmware_devices(payload: object) -> list[UpdateItem]:
    if not isinstance(payload, dict):
        raise ValueError("fwupd JSON was not an object")
    devices = payload.get("Devices") or []
    if not isinstance(devices, list):
        raise ValueError("fwupd JSON has no device list")
    items: list[UpdateItem] = []
    for device in devices:
        if not isinstance(device, dict):
            continue
        name = str(device.get("Name") or device.get("DeviceId") or "firmware device")
        releases = device.get("Releases") or []
        version = ""
        if isinstance(releases, list) and releases and isinstance(releases[0], dict):
            version = str(releases[0].get("Version") or "")
        detail = f"{name} {version}".strip()
        items.append(UpdateItem("firmware", name, detail))
    return items


def _json_stdout(result: subprocess.CompletedProcess[str]) -> object:
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        detail = (result.stderr or result.stdout or str(exc)).strip()
        raise ValueError(detail) from exc


def collect_updates() -> Probe:
    probe = Probe()
    dnf = _run(["dnf", "check-update", "--refresh", "--json"], timeout=300)
    if dnf.returncode != 0:
        detail = (dnf.stderr or dnf.stdout or f"dnf exited {dnf.returncode}").strip()
        probe.errors.append(f"Could not check RPM updates: {detail}")
    else:
        try:
            probe.items.extend(parse_dnf_packages(_json_stdout(dnf)))
        except ValueError as exc:
            probe.errors.append(f"Could not read the RPM update list: {exc}")

    for source, args in (
        ("flatpak-system", ["flatpak", "update", "--appstream", "--noninteractive", "--system"]),
        ("flatpak-user", ["flatpak", "update", "--appstream", "--noninteractive", "--user"]),
    ):
        refresh = _run(args, timeout=180)
        if refresh.returncode != 0:
            detail = (refresh.stderr or refresh.stdout or f"exited {refresh.returncode}").strip()
            probe.errors.append(f"Could not refresh {source} metadata: {detail}")
            continue
        listed = _run(
            ["flatpak", "remote-ls", "--updates", "--columns=ref", "--system" if source.endswith("system") else "--user"],
            timeout=180,
        )
        if listed.returncode != 0:
            detail = (listed.stderr or listed.stdout or f"exited {listed.returncode}").strip()
            probe.errors.append(f"Could not list {source} updates: {detail}")
            continue
        probe.items.extend(parse_flatpak_refs(listed.stdout, source))

    firmware = _run(["fwupdmgr", "get-updates", "--json"], timeout=180)
    if firmware.returncode != 0:
        detail = (firmware.stderr or firmware.stdout or f"fwupdmgr exited {firmware.returncode}").strip()
        probe.errors.append(f"Could not check firmware updates: {detail}")
    else:
        try:
            probe.items.extend(parse_firmware_devices(_json_stdout(firmware)))
        except ValueError as exc:
            probe.errors.append(f"Could not read the firmware update list: {exc}")
    return probe


def _session_props(session_id: str) -> dict[str, str]:
    result = _run(
        [
            "loginctl",
            "show-session",
            session_id,
            "-p",
            "Name",
            "-p",
            "Type",
            "-p",
            "Class",
            "-p",
            "Active",
            "-p",
            "LockedHint",
            "-p",
            "State",
        ]
    )
    props: dict[str, str] = {}
    for line in result.stdout.splitlines():
        if "=" in line:
            key, value = line.split("=", 1)
            props[key] = value
    return props


def session_is_unlocked() -> bool:
    listed = _run(["loginctl", "list-sessions", "--no-legend"])
    user = pwd.getpwuid(os.getuid()).pw_name
    for line in listed.stdout.splitlines():
        parts = line.split()
        if not parts:
            continue
        props = _session_props(parts[0])
        if props.get("Name") != user or props.get("Class") != "user":
            continue
        if props.get("Type") not in {"wayland", "x11"} or props.get("Active") != "yes":
            continue
        return props.get("LockedHint") == "no" and props.get("State") in {"active", "online"}
    return False


def code_is_running() -> bool:
    proc = Path("/proc")
    for entry in proc.iterdir():
        if not entry.name.isdigit():
            continue
        try:
            target = os.readlink(entry / "exe")
        except OSError:
            continue
        if target.startswith(CODE_PREFIX):
            return True
    return False


def wait_until_code_quits() -> None:
    RUN.can_dismiss = True
    print(
        "Visual Studio Code is running, and the code package is in this update.\n"
        "Quit Code so its save dialog can run. This window continues when Code has exited.\n"
        "Close this window before the password to skip.",
        flush=True,
    )
    while code_is_running():
        time.sleep(1)
    print("Code has exited.\n", flush=True)


def print_update_list(probe: Probe) -> None:
    groups = (
        ("rpm", "RPM"),
        ("flatpak-system", "Flatpak (system)"),
        ("flatpak-user", "Flatpak (user)"),
        ("firmware", "Firmware"),
    )
    print(f"{len(probe.items)} update(s) pending:\n", flush=True)
    for source, title in groups:
        rows = [item.detail for item in probe.items if item.source == source]
        if not rows:
            continue
        print(f"{title}:", flush=True)
        for row in rows:
            print(f"  {row}", flush=True)
        print(flush=True)


def print_password_notice(scheduled: bool) -> None:
    RUN.can_dismiss = True
    print(
        "Leave this window open after you enter your password.\n"
        "The upgrade, any VS Code reminder, and the reboot question happen here.\n"
        "Closing the window after the password stops the upgrade.",
        flush=True,
    )
    if scheduled:
        print(
            "Close this window now, or press Ctrl+C, to skip this cycle.\n"
            "The next prompt waits until the next Monday, Wednesday, or Friday at 10:00.",
            flush=True,
        )
    else:
        print(
            "Close this window now, or press Ctrl+C, to leave without updating.\n"
            "A scheduled prompt can still appear on a later unlock.",
            flush=True,
        )
    print(flush=True)


def _handle_stop(signum: int, _frame) -> None:
    if RUN.privileged:
        print("\nThe upgrade was interrupted. This cycle stays due.", flush=True)
    elif should_mark_cycle_handled(
        empty=False,
        all_succeeded=False,
        dismissed_before_password=RUN.can_dismiss,
        scheduled=RUN.scheduled,
    ):
        mark_cycle_handled()
        print("\nSkipped this cycle.", flush=True)
    elif RUN.can_dismiss:
        print("\nLeft without updating. A scheduled prompt can still appear later.", flush=True)
    else:
        print("\nStopped before the update list was ready. This cycle stays due.", flush=True)
    raise SystemExit(128 + signum)


def install_signal_handlers() -> None:
    signal.signal(signal.SIGHUP, _handle_stop)
    signal.signal(signal.SIGINT, _handle_stop)
    signal.signal(signal.SIGTERM, _handle_stop)


def sudo_authenticate() -> bool:
    print("Enter your sudo password to apply the updates above.", flush=True)
    result = subprocess.run(["sudo", "-v"])
    if result.returncode != 0:
        print("The password was not accepted. Nothing was changed. This cycle stays due.", flush=True)
        return False
    RUN.privileged = True

    def refresh(stop: threading.Event) -> None:
        while not stop.wait(60):
            subprocess.run(["sudo", "-n", "-v"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    threading.Thread(target=refresh, args=(threading.Event(),), daemon=True).start()
    return True


def _visible(args: list[str]) -> int:
    return subprocess.run(args).returncode


def apply_code_ritual() -> list[str]:
    user = pwd.getpwuid(os.getuid())
    failures: list[str] = []
    chown = _visible(["sudo", "chown", "-R", f"{user.pw_name}:{user.pw_name}", "/usr/share/code"])
    if chown != 0:
        failures.append("chown of /usr/share/code failed")
    launched = subprocess.Popen(
        ["/usr/bin/code"],
        start_new_session=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    print(
        "\nVS Code updated. Complete the custom CSS and JS loop.\n"
        "\n"
        "  1. In the Code window that just opened: Ctrl+Shift+P → Reload Custom CSS and JS\n"
        "  2. File → Exit (all windows)\n"
        "  3. Open Code again\n"
        "  4. Dismiss the installation-appears-to-be-corrupt warning\n"
        "\n"
        "The window buttons and the hidden app icon come back after that.",
        flush=True,
    )
    if launched.poll() not in (None, 0):
        failures.append("Code did not stay open after launch")
    return failures


def reboot_required_by_dnf() -> bool | None:
    print("Checking whether a reboot is required…", flush=True)
    result = _run(["dnf", "needs-restarting", "--json"], timeout=300)
    if result.returncode not in (0, 1):
        return None
    try:
        payload = _json_stdout(result)
    except ValueError:
        return None
    entries = payload if isinstance(payload, list) else [payload]
    for entry in entries:
        if isinstance(entry, dict) and entry.get("type") == "reboot":
            return bool(entry.get("reboot_required"))
    return None


def reboot_required_by_firmware() -> bool | None:
    result = _run(["fwupdmgr", "check-reboot-needed", "--json"], timeout=60)
    text = f"{result.stdout}\n{result.stderr}"
    if "No reboot is necessary" in text:
        return False
    if result.returncode == 0:
        return True
    return None


def ask_reboot(code_updated: bool) -> None:
    print(flush=True)
    if code_updated:
        print(
            "A reboot is required.\n"
            "Yes reboots immediately, and you finish the CSS loop after you log back in.\n"
            "No leaves the machine up so you can finish the loop first.",
            flush=True,
        )
    else:
        print("A reboot is required to finish applying updates.", flush=True)
    try:
        answer = input("Reboot now? [y/N] ").strip().lower()
    except EOFError:
        answer = ""
    if answer in {"y", "yes"}:
        print("Rebooting.", flush=True)
        subprocess.run(["sudo", "systemctl", "reboot"])
    else:
        print("Leaving the machine up. Reboot from the session menu when you are ready.", flush=True)


def apply_updates(probe: Probe) -> tuple[list[str], bool]:
    failures: list[str] = []
    code_updated = False
    rpm_items = [item for item in probe.items if item.source == "rpm"]
    if rpm_items:
        if _visible(["sudo", "dnf", "upgrade", "-y", "--refresh"]) != 0:
            failures.append("dnf upgrade failed")
        elif any(item.is_vscode for item in rpm_items):
            code_updated = True
            failures.extend(apply_code_ritual())

    for source, args in (
        ("flatpak-system", ["sudo", "flatpak", "update", "--noninteractive", "--assumeyes", "--system"]),
        ("flatpak-user", ["flatpak", "update", "--noninteractive", "--assumeyes", "--user"]),
    ):
        if any(item.source == source for item in probe.items):
            if _visible(args) != 0:
                failures.append(f"{source} update failed")

    if any(item.source == "firmware" for item in probe.items):
        if _visible(["sudo", "fwupdmgr", "update", "--assume-yes", "--no-reboot-check"]) != 0:
            failures.append("firmware update failed")
    return failures, code_updated


def finish_reboot_question(failures: list[str], code_updated: bool, attempted: bool) -> None:
    if not attempted:
        return
    dnf_reboot = reboot_required_by_dnf()
    firmware_reboot = reboot_required_by_firmware()
    if dnf_reboot is None and firmware_reboot is None:
        print("Could not tell whether a reboot is required.", flush=True)
        return
    if dnf_reboot or firmware_reboot:
        ask_reboot(code_updated)


def save_probe(probe: Probe) -> None:
    PROBE_CACHE_PATH.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "saved_at": time.time(),
        "errors": probe.errors,
        "items": [{"source": item.source, "name": item.name, "detail": item.detail} for item in probe.items],
    }
    PROBE_CACHE_PATH.write_text(json.dumps(payload) + "\n", encoding="utf-8")


def load_recent_probe() -> Probe | None:
    try:
        payload = json.loads(PROBE_CACHE_PATH.read_text(encoding="utf-8"))
        saved_at = float(payload["saved_at"])
    except (OSError, json.JSONDecodeError, KeyError, TypeError, ValueError):
        return None
    if time.time() - saved_at > PROBE_CACHE_MAX_AGE:
        return None
    items = []
    for entry in payload.get("items") or []:
        if not isinstance(entry, dict):
            return None
        try:
            items.append(UpdateItem(str(entry["source"]), str(entry["name"]), str(entry["detail"])))
        except KeyError:
            return None
    probe = Probe(items=items, errors=list(payload.get("errors") or []))
    return probe


def take_recent_probe() -> Probe | None:
    probe = load_recent_probe()
    PROBE_CACHE_PATH.unlink(missing_ok=True)
    return probe


def interactive(scheduled: bool) -> int:
    RUN.scheduled = scheduled
    RUN.privileged = False
    RUN.can_dismiss = False
    install_signal_handlers()
    if not sys.stdin.isatty():
        print("Run this in a terminal so you can type your sudo password.", file=sys.stderr)
        return 1

    probe = take_recent_probe()
    if probe is None:
        print("Checking for updates…", flush=True)
        probe = collect_updates()
    if not probe.ok:
        print("The update check did not finish. This cycle stays due.\n", flush=True)
        for error in probe.errors:
            print(error, flush=True)
        return 1
    if probe.empty:
        print("Nothing to update.", flush=True)
        if should_mark_cycle_handled(
            empty=True,
            all_succeeded=False,
            dismissed_before_password=False,
            scheduled=scheduled,
        ):
            mark_cycle_handled()
        return 0

    while any(item.is_vscode for item in probe.items) and code_is_running():
        wait_until_code_quits()

    print_update_list(probe)
    print_password_notice(scheduled)
    while any(item.is_vscode for item in probe.items) and code_is_running():
        wait_until_code_quits()
    if not sudo_authenticate():
        return 1

    failures, code_updated = apply_updates(probe)
    if failures:
        print("\nFinished with problems. This cycle stays due:", flush=True)
        for failure in failures:
            print(f"  - {failure}", flush=True)
    finish_reboot_question(failures, code_updated, attempted=True)
    if failures:
        return 1
    if should_mark_cycle_handled(
        empty=False,
        all_succeeded=True,
        dismissed_before_password=False,
        scheduled=scheduled,
    ):
        mark_cycle_handled()
    print("\nUpdates finished.", flush=True)
    return 0


def command_run(scheduled: bool) -> int:
    with FileLock(RUN_LOCK_PATH, blocking=False) as lock:
        if lock is None:
            print("An update window is already open.", flush=True)
            return 1
        return interactive(scheduled)


def command_prompt() -> int:
    with FileLock(SPAWN_LOCK_PATH, blocking=False) as lock:
        if lock is None or not cycle_is_due() or not session_is_unlocked():
            return 0
        with FileLock(RUN_LOCK_PATH, blocking=False) as run_lock:
            if run_lock is None:
                return 0
        print("Checking whether a system update prompt is due…", flush=True)
        probe = collect_updates()
        if probe.ok and probe.empty:
            mark_cycle_handled()
            return 0
        if probe.ok:
            save_probe(probe)
        window = subprocess.run(
            [
                "/usr/bin/ptyxis",
                "--standalone",
                "-T",
                "System updates",
                "--",
                PYTHON,
                str(SCRIPT_PATH),
                "run",
                "--scheduled",
            ]
        )
        return window.returncode


def command_watch() -> int:
    was_unlocked = False
    first = True
    while True:
        try:
            unlocked = session_is_unlocked()
            if unlocked and (first or not was_unlocked):
                command_prompt()
            was_unlocked = unlocked
            first = False
        except Exception as exc:
            print(f"Unlock watcher error: {exc}", file=sys.stderr, flush=True)
        time.sleep(5)


def _gsettings_get(key: str) -> bool | None:
    result = _run(["gsettings", "get", GSETTINGS_SCHEMA, key])
    value = result.stdout.strip()
    if result.returncode != 0 or value not in {"true", "false"}:
        return None
    return value == "true"


def _gsettings_set(key: str, enabled: bool) -> None:
    subprocess.run(
        ["gsettings", "set", GSETTINGS_SCHEMA, key, "true" if enabled else "false"],
        check=True,
    )


def _write_units() -> None:
    UNIT_DIR.mkdir(parents=True, exist_ok=True)
    script = str(SCRIPT_PATH)
    (UNIT_DIR / SERVICE_NAME).write_text(
        "\n".join(
            [
                "[Unit]",
                "Description=Open the system update prompt when a Monday, Wednesday, or Friday check is due",
                "After=graphical-session.target",
                "PartOf=graphical-session.target",
                "",
                "[Service]",
                "Type=oneshot",
                "TimeoutStartSec=infinity",
                f"ExecStart={PYTHON} {script} prompt",
                "",
            ]
        ),
        encoding="utf-8",
    )
    (UNIT_DIR / TIMER_NAME).write_text(
        "\n".join(
            [
                "[Unit]",
                "Description=Mark system update checks on Monday, Wednesday, and Friday at 10:00",
                "",
                "[Timer]",
                "OnCalendar=Mon,Wed,Fri *-*-* 10:00:00",
                "Persistent=true",
                f"Unit={SERVICE_NAME}",
                "",
                "[Install]",
                "WantedBy=timers.target",
                "",
            ]
        ),
        encoding="utf-8",
    )
    (UNIT_DIR / WATCH_NAME).write_text(
        "\n".join(
            [
                "[Unit]",
                "Description=Open the system update prompt when the graphical session unlocks",
                "After=graphical-session.target",
                "PartOf=graphical-session.target",
                "",
                "[Service]",
                "Type=simple",
                f"ExecStart={PYTHON} {script} watch",
                "Restart=on-failure",
                "RestartSec=5",
                "",
                "[Install]",
                "WantedBy=graphical-session.target",
                "",
            ]
        ),
        encoding="utf-8",
    )


def _systemctl(*args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(["systemctl", "--user", *args], text=True, check=False)


def command_install() -> int:
    state = load_state()
    saved = state.get("saved_gsettings")
    if not isinstance(saved, dict):
        saved = {}
        for key in GSETTINGS_KEYS:
            current = _gsettings_get(key)
            if current is None:
                print(f"Could not read the Software setting {key}.", file=sys.stderr)
                return 1
            saved[key] = current
        state["saved_gsettings"] = saved
    now = datetime.now().astimezone()
    state["handled_cycle_id"] = cycle_id(now)
    save_state(state)
    for key in GSETTINGS_KEYS:
        _gsettings_set(key, False)
    _write_units()
    reload_result = _systemctl("daemon-reload")
    if reload_result.returncode != 0:
        print("systemctl --user daemon-reload failed.", file=sys.stderr)
        return reload_result.returncode
    enable = _systemctl("enable", "--now", TIMER_NAME, WATCH_NAME)
    if enable.returncode != 0:
        print(enable.stderr or "Could not enable the user timer.", file=sys.stderr)
        return enable.returncode
    upcoming = next_mark(now)
    print(
        "Installed.\n"
        f"Script: {SCRIPT_PATH}\n"
        f"Units: {UNIT_DIR / TIMER_NAME}\n"
        f"       {UNIT_DIR / WATCH_NAME}\n"
        f"State: {STATE_PATH}\n"
        "\n"
        "Software will no longer download updates in the background or notify you.\n"
        "The Updates page still works if you open Software yourself.\n"
        "\n"
        f"Next prompt: after {upcoming.strftime('%A %-d %B %Y at %H:%M')}, "
        "when this session is next unlocked.\n"
        "\n"
        "Update now:\n"
        f"  {PYTHON} {SCRIPT_PATH} run\n"
        "\n"
        "Stop the popups and leave Software in manual-update mode:\n"
        f"  systemctl --user disable --now {TIMER_NAME} {WATCH_NAME}\n"
        "\n"
        "Remove the schedule and restore Software's previous automatic settings:\n"
        f"  {PYTHON} {SCRIPT_PATH} uninstall",
        flush=True,
    )
    return 0


def command_uninstall() -> int:
    _systemctl("disable", "--now", TIMER_NAME, WATCH_NAME, SERVICE_NAME)
    for name in (TIMER_NAME, WATCH_NAME, SERVICE_NAME):
        try:
            (UNIT_DIR / name).unlink()
        except FileNotFoundError:
            pass
    _systemctl("daemon-reload")
    _systemctl("reset-failed", TIMER_NAME, WATCH_NAME, SERVICE_NAME)
    state = load_state()
    saved = state.get("saved_gsettings")
    if isinstance(saved, dict):
        for key in GSETTINGS_KEYS:
            if isinstance(saved.get(key), bool):
                _gsettings_set(key, saved[key])
    if STATE_DIR.exists():
        for child in STATE_DIR.iterdir():
            child.unlink(missing_ok=True)
        STATE_DIR.rmdir()
    print(
        "Uninstalled the timer and unlock watcher.\n"
        "Restored Software's automatic download and notification settings from install time.\n"
        f"The script is still at {SCRIPT_PATH}.",
        flush=True,
    )
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Prompt for Fedora updates and apply them after your sudo password.")
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("install", help="Install the user timer and turn off Software's automatic updates")
    sub.add_parser("uninstall", help="Remove the timer and restore Software's automatic settings")
    run = sub.add_parser("run", help="Check and apply updates in this terminal")
    run.add_argument("--scheduled", action="store_true", help=argparse.SUPPRESS)
    sub.add_parser("prompt", help=argparse.SUPPRESS)
    sub.add_parser("watch", help=argparse.SUPPRESS)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    if args.command == "install":
        return command_install()
    if args.command == "uninstall":
        return command_uninstall()
    if args.command == "run":
        return command_run(scheduled=args.scheduled)
    if args.command == "prompt":
        return command_prompt()
    if args.command == "watch":
        return command_watch()
    return 2


if __name__ == "__main__":
    sys.exit(main())
