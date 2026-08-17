#!/bin/bash
set -u
yabai -m query --spaces 2>/dev/null | jq -r 'to_entries[] | "\(.key + 1) \(.value["has-focus"])"' | while read -r number focused; do
  color=0xff45475a
  [ "$focused" = "true" ] && color=0xffcba6f7
  sketchybar --set "space.$number" background.color="$color"
done
