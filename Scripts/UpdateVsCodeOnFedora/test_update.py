#!/usr/bin/python3
"""Schedule and list-parsing tests for the Fedora update prompt."""

import tempfile
import unittest
from datetime import datetime, timedelta, timezone
from pathlib import Path

import update


CENTRAL = timezone(timedelta(hours=-5))


def at(year, month, day, hour, minute=0):
    return datetime(year, month, day, hour, minute, tzinfo=CENTRAL)


class CycleTests(unittest.TestCase):
    def test_monday_before_ten_uses_previous_friday(self):
        self.assertEqual(update.cycle_id(at(2026, 9, 28, 6, 22)), "2026-09-25T10:00")

    def test_monday_at_ten_is_that_morning(self):
        self.assertEqual(update.cycle_id(at(2026, 9, 28, 10)), "2026-09-28T10:00")

    def test_monday_after_ten_stays_that_morning(self):
        self.assertEqual(update.cycle_id(at(2026, 9, 28, 18)), "2026-09-28T10:00")

    def test_saturday_morning_uses_friday(self):
        self.assertEqual(update.cycle_id(at(2026, 9, 26, 9)), "2026-09-25T10:00")

    def test_saturday_evening_uses_friday(self):
        self.assertEqual(update.cycle_id(at(2026, 9, 26, 19)), "2026-09-25T10:00")

    def test_next_mark_before_monday_ten_is_monday(self):
        self.assertEqual(update.next_mark(at(2026, 9, 28, 6, 22)), at(2026, 9, 28, 10))

    def test_next_mark_after_monday_ten_is_wednesday(self):
        self.assertEqual(update.next_mark(at(2026, 9, 28, 11)), at(2026, 9, 30, 10))


class PolicyTests(unittest.TestCase):
    def test_empty_check_marks_the_cycle(self):
        self.assertTrue(
            update.should_mark_cycle_handled(
                empty=True,
                all_succeeded=False,
                dismissed_before_password=False,
                scheduled=True,
            )
        )

    def test_scheduled_dismiss_marks_the_cycle(self):
        self.assertTrue(
            update.should_mark_cycle_handled(
                empty=False,
                all_succeeded=False,
                dismissed_before_password=True,
                scheduled=True,
            )
        )

    def test_manual_dismiss_leaves_the_cycle_due(self):
        self.assertFalse(
            update.should_mark_cycle_handled(
                empty=False,
                all_succeeded=False,
                dismissed_before_password=True,
                scheduled=False,
            )
        )

    def test_failure_leaves_the_cycle_due(self):
        self.assertFalse(
            update.should_mark_cycle_handled(
                empty=False,
                all_succeeded=False,
                dismissed_before_password=False,
                scheduled=True,
            )
        )

    def test_success_marks_the_cycle(self):
        self.assertTrue(
            update.should_mark_cycle_handled(
                empty=False,
                all_succeeded=True,
                dismissed_before_password=False,
                scheduled=False,
            )
        )


class ParseTests(unittest.TestCase):
    def test_dnf_packages_include_code(self):
        payload = {
            "upgrades": [
                {
                    "name": "code",
                    "arch": "x86_64",
                    "evr": "1.139.1-1790309585.el8",
                    "repository": "code",
                }
            ]
        }
        items = update.parse_dnf_packages(payload)
        self.assertEqual(len(items), 1)
        self.assertTrue(items[0].is_vscode)
        self.assertIn("1.139.1-1790309585.el8", items[0].detail)

    def test_flatpak_refs_skip_blank_lines(self):
        text = "\napp/org.mozilla.firefox/x86_64/stable\n"
        items = update.parse_flatpak_refs(text, "flatpak-user")
        self.assertEqual(items[0].name, "org.mozilla.firefox")
        self.assertEqual(items[0].source, "flatpak-user")

    def test_firmware_devices_use_the_newest_release_version(self):
        payload = {"Devices": [{"Name": "System Firmware", "Releases": [{"Version": "1.2.3"}]}]}
        items = update.parse_firmware_devices(payload)
        self.assertEqual(items[0].detail, "System Firmware 1.2.3")

    def test_firmware_without_devices_is_empty(self):
        self.assertEqual(update.parse_firmware_devices({"Devices": []}), [])

    def test_recent_probe_round_trip(self):
        with tempfile.TemporaryDirectory() as directory:
            cache = Path(directory) / "probe.json"
            original = update.PROBE_CACHE_PATH
            update.PROBE_CACHE_PATH = cache
            try:
                update.save_probe(
                    update.Probe(items=[update.UpdateItem("rpm", "code", "code.x86_64 1 (code)")])
                )
                loaded = update.load_recent_probe()
            finally:
                update.PROBE_CACHE_PATH = original
        self.assertIsNotNone(loaded)
        self.assertTrue(loaded.items[0].is_vscode)


if __name__ == "__main__":
    unittest.main()
