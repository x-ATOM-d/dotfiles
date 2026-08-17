#!/bin/bash
# Pogoda z Open-Meteo (https://open-meteo.com) - bez klucza API, dokładniejsze
# dane niż wttr.in (który potrafi geolokalizować po IP/CDN i pokazywać
# pogodę zupełnie innego miasta). Współrzędne Rzeszowa wpisane na sztywno,
# żeby uniknąć niepotrzebnego geokodowania przy każdym odświeżeniu.
LAT="50.0412"
LON="21.9991"

RESPONSE="$(curl -s --max-time 5 "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,weather_code&timezone=auto")"

if [ -z "$RESPONSE" ]; then
  exit 0
fi

TEMP="$(echo "$RESPONSE" | jq -r '.current.temperature_2m // empty')"
CODE="$(echo "$RESPONSE" | jq -r '.current.weather_code // empty')"

if [ -z "$TEMP" ]; then
  exit 0
fi

# Mapowanie kodów pogodowych WMO (używanych przez Open-Meteo) na emoji
case "$CODE" in
  0) ICON="☀️" ;;
  1|2) ICON="🌤️" ;;
  3) ICON="☁️" ;;
  45|48) ICON="🌫️" ;;
  51|53|55|56|57) ICON="🌦️" ;;
  61|63|65|66|67) ICON="🌧️" ;;
  71|73|75|77) ICON="🌨️" ;;
  80|81|82) ICON="🌧️" ;;
  85|86) ICON="🌨️" ;;
  95|96|99) ICON="⛈️" ;;
  *) ICON="🌡️" ;;
esac

TEMP_ROUNDED="$(printf '%.0f' "$TEMP")"

sketchybar --set "$NAME" label="${ICON} ${TEMP_ROUNDED}°C"
