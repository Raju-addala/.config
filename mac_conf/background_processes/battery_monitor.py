#!/usr/bin/env python3
"""
battery_monitor.py

Monitors macOS battery percentage and power source and uses the `say` command to announce conditions.

Behavior (defaults):
 - If battery < 20% and NOT plugged in -> speak "low battery" every 5 minutes.
 - If battery > 80% and plugged in -> speak "battery overload" every 5 minutes.
 - The "every 5 minutes" intervals are configurable via constants or CLI args.

Usage:
  python3 battery_monitor.py [--once] [--low-threshold N] [--high-threshold N] [--check-interval SEC] [--speak-interval SEC]

--once will run a single check and exit (useful for testing).

This script is intended to be run as a user LaunchAgent (plist included) or manually.
"""

from __future__ import annotations
import argparse
import re
import subprocess
import time
from datetime import datetime
from pathlib import Path

# Defaults
LOW_THRESHOLD = 20
HIGH_THRESHOLD = 80
CHECK_INTERVAL = 60  # seconds between polls
SPEAK_INTERVAL = 300  # 5 minutes between repeated announcements for a condition

LOG_PATH = Path(__file__).parent / 'battery_monitor.log'


def log(msg: str) -> None:
    ts = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    line = f"{ts} - {msg}\n"
    try:
        LOG_PATH.write_text((LOG_PATH.read_text() + line) if LOG_PATH.exists() else line)
    except Exception:
        # best-effort logging; avoid crashing for I/O errors
        pass


def get_battery_info() -> tuple[int, bool]:
    """Return (percentage, plugged).

    Uses `pmset -g batt` output. On failure raises RuntimeError.
    """
    try:
        out = subprocess.check_output(['pmset', '-g', 'batt'], stderr=subprocess.STDOUT)
        s = out.decode('utf-8')
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"pmset failed: {e}") from e

    # Example output lines (macOS):
    # Now drawing from 'AC Power'
    #  -InternalBattery-0 (id=1234567)    95%; charging; 0:45 remaining
    # Or: "Now drawing from 'Battery Power'"

    plugged = 'AC Power' in s
    m = re.search(r"(\d+)%", s)
    if not m:
        raise RuntimeError(f"Couldn't parse battery percentage from: {s!r}")
    percent = int(m.group(1))
    return percent, plugged


def say(text: str) -> None:
    """Use macOS `say` to speak the given text. Non-blocking-ish via subprocess.run.

    Keep calls simple; `say` will use the default voice.
    """
    try:
        subprocess.run(['say', text])
    except Exception as e:
        log(f"Failed to invoke say: {e}")


def main_loop(low_threshold: int, high_threshold: int, check_interval: int, speak_interval: int, run_once: bool) -> None:
    last_spoken_low = 0.0
    last_spoken_over = 0.0

    if run_once:
        try:
            pct, plugged = get_battery_info()
            msg = None
            if pct < low_threshold and not plugged:
                msg = 'low battery'
            elif pct > high_threshold and plugged:
                msg = 'battery overload'

            if msg:
                log(f"ONCE: {msg} (pct={pct}, plugged={plugged})")
                say(msg)
            else:
                log(f"ONCE: no announcement (pct={pct}, plugged={plugged})")
        except Exception as e:
            log(f"ONCE: error reading battery info: {e}")
        return

    log("Battery monitor started")
    while True:
        try:
            pct, plugged = get_battery_info()
        except Exception as e:
            log(f"Error reading battery info: {e}")
            time.sleep(check_interval)
            continue

        now = time.time()
        # Low battery: pct < low_threshold and NOT plugged -> speak every speak_interval
        if pct < low_threshold and not plugged:
            if now - last_spoken_low >= speak_interval:
                last_spoken_low = now
                log(f"Announcing low battery: {pct}% (not plugged)")
                say('low battery')
            else:
                log(f"Low battery condition; next speak in {int(speak_interval - (now - last_spoken_low))}s")

        # Battery overload: pct > high_threshold and plugged -> speak every speak_interval
        if pct > high_threshold and plugged:
            if now - last_spoken_over >= speak_interval:
                last_spoken_over = now
                log(f"Announcing battery overload: {pct}% (plugged)")
                say('battery overload')
            else:
                log(f"Battery overload condition; next speak in {int(speak_interval - (now - last_spoken_over))}s")

        time.sleep(check_interval)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Battery monitor that speaks on thresholds.')
    parser.add_argument('--once', action='store_true', help='Run one check then exit')
    parser.add_argument('--low-threshold', type=int, default=LOW_THRESHOLD, help='Percent under which battery is considered low')
    parser.add_argument('--high-threshold', type=int, default=HIGH_THRESHOLD, help='Percent above which battery is considered overloaded')
    parser.add_argument('--check-interval', type=int, default=CHECK_INTERVAL, help='Seconds between battery polls')
    parser.add_argument('--speak-interval', type=int, default=SPEAK_INTERVAL, help='Seconds between repeated announcements for the same condition')

    args = parser.parse_args()

    main_loop(
        low_threshold=args.low_threshold,
        high_threshold=args.high_threshold,
        check_interval=args.check_interval,
        speak_interval=args.speak_interval,
        run_once=args.once,
    )
