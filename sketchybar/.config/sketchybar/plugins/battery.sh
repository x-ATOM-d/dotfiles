#!/bin/bash
BATT_INFO="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT_INFO" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

# "AC Power" oznacza podłączone zasilanie. Dopiero gdy napis zawiera
# "charging" (a nie tylko "AC Power" przy 100% "charged"), bateria faktycznie
# się ładuje — wtedy pokazujemy ikonę błyskawicy.
CHARGING="$(echo "$BATT_INFO" | grep 'charging')"

# Ikony Nerd Font (Font Awesome battery states) - zapisane jako bajty UTF-8,
# bo macOS ma domyślnie bash 3.2, który nie wspiera $'\uXXXX'
if [ -n "$CHARGING" ]; then
  ICON=$'\xef\x83\xa7' # błyskawica (ładowanie) - f0e7
elif [ "$PERCENTAGE" -ge 90 ]; then
  ICON=$'\xef\x89\x80' # f240
elif [ "$PERCENTAGE" -ge 65 ]; then
  ICON=$'\xef\x89\x81' # f241
elif [ "$PERCENTAGE" -ge 35 ]; then
  ICON=$'\xef\x89\x82' # f242
elif [ "$PERCENTAGE" -ge 10 ]; then
  ICON=$'\xef\x89\x83' # f243
else
  ICON=$'\xef\x89\x84' # f244
fi

COLOR=0xffa6e3a1 # green
if [ "$PERCENTAGE" -le 20 ] && [ -z "$CHARGING" ]; then
  COLOR=0xfff38ba8 # red, ostrzeżenie o niskim poziomie baterii
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
