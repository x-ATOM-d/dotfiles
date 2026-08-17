#!/bin/bash
set -u
space="$1"
if [ "${MODIFIER:-}" = "cmd" ]; then
  yabai -m window --space "$space" >/dev/null 2>&1 && yabai -m space --focus "$space"
else
  yabai -m space --focus "$space"
fi
