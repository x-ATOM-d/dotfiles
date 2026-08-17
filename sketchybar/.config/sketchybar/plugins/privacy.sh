#!/bin/bash
set -u
# macOS nie ma publicznego API stanu mikrofonu; detekcja jest best-effort.
CAMERA=0; MIC=0
pgrep -x 'VDCAssistant|AppleCameraAssistant' >/dev/null 2>&1 && CAMERA=1
pgrep -f 'Zoom|Teams|FaceTime|Photo Booth|QuickTime Player|OBS' >/dev/null 2>&1 && MIC=1
if [ "$CAMERA" = 1 ] && [ "$MIC" = 1 ]; then
  sketchybar --set "$NAME" drawing=on icon='' label=' MIC'
elif [ "$CAMERA" = 1 ]; then
  sketchybar --set "$NAME" drawing=on icon='' label=''
elif [ "$MIC" = 1 ]; then
  sketchybar --set "$NAME" drawing=on icon='' label=''
else
  sketchybar --set "$NAME" drawing=off
fi
