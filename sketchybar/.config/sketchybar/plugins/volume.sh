#!/bin/bash

# volume_change przekazuje w INFO sam procent, nie JSON. Dzięki temu reakcja na
# klawisze głośności nie czeka na kolejny update_freq.
if [ "${SENDER:-}" = "volume_change" ] && [ -n "${INFO:-}" ]; then
  VOLUME="$INFO"
  MUTED=$(osascript -e "output muted of (get volume settings)" 2>/dev/null || echo false)
else
  VOLUME=$(osascript -e "output volume of (get volume settings)" 2>/dev/null || echo 0)
  MUTED=$(osascript -e "output muted of (get volume settings)" 2>/dev/null || echo false)
fi

# Zachowaj bezpieczną wartość całkowitą również gdy przyszła z systemu jako
# liczba zmiennoprzecinkowa.
VOLUME="${VOLUME%%.*}"
case "$VOLUME" in
  ''|*[!0-9]*) VOLUME=0 ;;
esac

if [ "$MUTED" == "true" ]; then
  ICON=$'\xef\x9a\xa9' # f6a9
elif [ "$VOLUME" -ge 66 ]; then
  ICON=$'\xef\x80\xa8' # f028
elif [ "$VOLUME" -ge 33 ]; then
  ICON=$'\xef\x80\xa7' # f027
elif [ "$VOLUME" -gt 0 ]; then
  ICON=$'\xef\x80\xa6' # f026
else
  ICON=$'\xef\x80\xa6' # f026
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
