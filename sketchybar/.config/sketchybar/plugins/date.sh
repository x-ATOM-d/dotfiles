#!/bin/bash
# Jeśli chcesz polskie skróty dni/miesięcy niezależnie od locale systemu, odkomentuj:
# export LC_TIME=pl_PL.UTF-8

sketchybar --set "$NAME" label="$(date '+%d %a')"
