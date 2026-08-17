#!/bin/bash
# WiFi widget: SSID + siła sygnału (RSSI w dBm).
# Bez sudo — korzysta z system_profiler i networksetup.
set -u

PROFILE="$(system_profiler SPAirPortDataType 2>/dev/null)"

# Czy w ogóle połączono?
CONNECTED="$(printf '%s\n' "$PROFILE" | grep -c 'Status: Connected')"

if [ "$CONNECTED" -eq 0 ]; then
  sketchybar --set "$NAME" label="Offline" icon.color=0xfff38ba8
  exit 0
fi

# Wyciągnij SSID (może być <redacted> — macOS ukrywa nazwę)
SSID="$(printf '%s\n' "$PROFILE" | awk '
  /Current Network Information:/ { capture=1; next }
  capture && /^ +[^ ]/ {
    gsub(/^ +|: *$/, "", $0)
    print $0
    exit
  }
')"

# Wyciągnij RSSI z linii "Signal / Noise: -54 dBm / -93 dBm"
RSSI_RAW="$(printf '%s\n' "$PROFILE" | awk '/Signal \/ Noise:/ { match($0, /-?[0-9]+/); print substr($0, RSTART, RLENGTH); exit }')"
RSSI_VAL="${RSSI_RAW:-}"

if [ -n "$RSSI_VAL" ]; then
  if   [ "$RSSI_VAL" -le -90 ]; then BARS=1
  elif [ "$RSSI_VAL" -le -80 ]; then BARS=2
  elif [ "$RSSI_VAL" -le -67 ]; then BARS=3
  else BARS=4
  fi
else
  BARS=0
fi

# Kolor wg jakości
if   [ "$BARS" -ge 4 ]; then COLOR=0xffa6e3a1   # green
elif [ "$BARS" -eq 3 ]; then COLOR=0xfff9e2af   # yellow
elif [ "$BARS" -eq 2 ]; then COLOR=0xfffab387   # peach
else COLOR=0xfff38ba8                            # red
fi

# Jeśli SSID ukryte, pokaż "WiFi ✓" zamiast nazwy
if [ -z "$SSID" ] || [ "$SSID" = "<redacted>" ]; then
  LABEL="WiFi ${BARS}/4"
else
  LABEL="${SSID} ${BARS}/4"
fi

sketchybar --set "$NAME" label="$LABEL" icon.color="$COLOR"
