#!/bin/bash
set -u
app="$(yabai -m query --windows --window 2>/dev/null | jq -r '.app // empty')"
sketchybar --set front_app label="${app:-}"
