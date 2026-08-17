#!/usr/bin/env python3
"""Pętla marquee dla widgetu muzyki SketchyBar.

Args:
    sys.argv[1]: pelny tytul utworu (artist - title)
    sys.argv[2]: nazwa itemu SketchyBar (np. widgets.music)
    sys.argv[3]: szerokosc okienka w znakach (WINDOW)

Przesuwa tekst w lewo co 0.4s. Konczy się, gdy plik TRACKFILE przestanie
zawierac ten sam utwor (wtedy music.sh odpali nowy proces dla nowego utworu).
"""
import sys
import time
import subprocess

TRACK = sys.argv[1]
NAME = sys.argv[2]
WINDOW = int(sys.argv[3]) if len(sys.argv) > 3 else 22
TRACKFILE = "/tmp/sketchybar_music_track"
GAP = "    "  # 4 spacje miedzy powtorzeniami
STEP_SLEEP = 0.4  # sekundy na krok przewijania

buf = TRACK + GAP
n = len(buf)
pos = 0


def current_track() -> str:
    try:
        with open(TRACKFILE, "r", encoding="utf-8") as fh:
            return fh.read().strip()
    except OSError:
        return ""


while True:
    # Jesli utwor sie zmienil (lub plik zniknal) -> zakoncz (stary marquee ustepuje).
    if current_track() != TRACK:
        break

    vis = buf[pos:pos + WINDOW]
    if len(vis) < WINDOW:
        vis += buf[:WINDOW - len(vis)]

    try:
        subprocess.run(
            ["sketchybar", "--set", NAME, "label=" + vis, "label.align=left"],
            check=False,
        )
    except OSError:
        break

    pos = (pos + 1) % n
    time.sleep(STEP_SLEEP)
