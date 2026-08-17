#!/bin/bash
set -u
ACTION="${1:-playpause}"
if command -v media-control >/dev/null 2>&1 && media-control "$ACTION" >/dev/null 2>&1; then exit 0; fi
case "$ACTION" in
  playpause) APPLE_ACTION="playpause" ;;
  previous) APPLE_ACTION="previous track" ;;
  next) APPLE_ACTION="next track" ;;
  *) exit 1 ;;
esac
osascript -e "tell application \"Spotify\" to $APPLE_ACTION" 2>/dev/null || osascript -e "tell application \"Music\" to $APPLE_ACTION" 2>/dev/null
