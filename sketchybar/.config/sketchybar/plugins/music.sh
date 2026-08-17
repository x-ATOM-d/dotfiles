#!/bin/bash
# Widget "now playing" dla SketchyBar.
# Preferowane: media-control (brew tap ungive/media-control) — uniwersalne "now playing"
# przez MediaRemote (dziala z Spotify, Apple Music, Evermusic, przegladarkami/YouTube itd.).
# Bez niego: fallback do AppleScript (tylko Spotify/Music — Evermusic nie ma slownika AppleScript).
#
# Przewijanie dlugich tytulow:
# Natywne scroll_texts SketchyBar w tej wersji nie animuje dla tego widgetu (przetestowane:
# nawet czysty item z scroll_texts=on + align=left + width=200 + b.dlugi tekst stoi w miejscu).
# Zamiast tego uzywamy wlasnego marquee (music_marquee.py): dla krotkiego tytulu wyswietlamy
# go wycentrowanego (statycznie), dla dlugiego odpalamy proces w tle, ktory co 0.4s przesuwa
# tekst w lewo (align=left + stala label.width=200 => nie nachodzi na ikone muzyki).

set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
NAME="${NAME:-widgets.music}"
TRACKFILE="/tmp/sketchybar_music_track"
MARQUEE_SCRIPT="$DIR/music_marquee.py"

# Stala okienka (liczba widocznych znakow) — musi pasowac do label.width=200
# w items/music.lua (JetBrainsMono 13pt ~7.8pt/znak => ~24 znaki; 22 dla marginesu).
WINDOW=22

# Zabij ewentualny dzialajacy proces marquee (stary/osierocony).
kill_marquee() {
  ps -eo pid,command | grep -E "Python.*marquee" | grep -v grep | awk '{print $1}' | while read p; do kill "$p" 2>/dev/null; done
  rm -f /tmp/sketchybar_music_marquee.pid
}

# --- Wykrywanie zrodla odtwarzania (ikona + kolor) -----------------------
# Zwraca dwa wiersze: ICON (gotowy glif Unicode) i COLOR (0xAARRGGBB).
# Logika:
#   - media-control daje bundleIdentifier (np. com.brave.Browser).
#   - Dla przegladarek sprawdzamy URL aktywnej karty. Jesli to YouTube
#     (w tym music.youtube.com) -> ikona KAMERY WIDEO (czerwona). Inna
#     strona -> ikona nutki (pink). Dotyczy Brave, Zen, Chrome, Safari, Edge.
#   - Dla aplikacji muzycznych dedykowana ikona; domyslnie ikona nutki.
# Uwaga: macOS /bin/bash to wersja 3.2.2 -> BRAK asocjacyjnych tablic
# (declare -A) i BRAK $'\uXXXX'. Dlatego mapy robimy przez case, a glify
# generuje python3 (poprawnie koduje \uXXXX do UTF-8 dla SketchyBar).
# Format koloru: 0xAARRGGBB (liczba) — SketchyBar CLI przyjmuje TYLKO ten
# format (#aarrggbb zeruje ikone -> przetestowane).
GLYPH_MUSIC=$(python3 -c "import sys; sys.stdout.write('\uf001')")     # nutka
GLYPH_VIDEOCAM=$(python3 -c "import sys; sys.stdout.write('\uf03d')") # kamera wideo
COLOR_PINK="0xfff5c2e7"   # Catppuccin pink (nutka / muzyka)
COLOR_RED="0xfff38ba8"    # Catppuccin red (YouTube)

detect_source() {
  local BID="$1"
  local icon="$GLYPH_MUSIC"
  local color="$COLOR_PINK"
  case "$BID" in
    com.apple.Music|com.spotify.client|com.leshko.cloudplayer.mac)
      icon="$GLYPH_MUSIC"; color="$COLOR_PINK" ;;
    com.brave.Browser|app.zen-browser.zen|com.google.Chrome|com.apple.Safari|com.microsoft.edgemac)
      # Przegladarki: YouTube (w tym music.youtube.com) -> kamera wideo (czerwona).
      # Inna strona -> nutka (domyslnie pink).
      local appname=""
      case "$BID" in
        com.brave.Browser) appname="Brave Browser" ;;
        app.zen-browser.zen) appname="Zen" ;;
        com.google.Chrome) appname="Google Chrome" ;;
        com.apple.Safari) appname="Safari" ;;
        com.microsoft.edgemac) appname="Microsoft Edge" ;;
      esac
      local url=""
      url=$(osascript -e "tell application \"$appname\" to get URL of active tab of front window" 2>/dev/null)
      if printf '%s' "$url" | grep -qiE 'https?://([^/]*\.)?(music\.)?youtube\.com'; then
        icon="$GLYPH_VIDEOCAM"; color="$COLOR_RED"
      else
        icon="$GLYPH_MUSIC"; color="$COLOR_PINK"
      fi ;;
    *) icon="$GLYPH_MUSIC"; color="$COLOR_PINK" ;;
  esac
  printf '%s\n%s\n' "$icon" "$color"
}

# Ustawia ikone + kolor + label widgetu (jedno wywolanie sketchybar).
set_widget() {
  local icon="$1" color="$2" label="$3" align="$4"
  sketchybar --set "$NAME" drawing=on \
    icon="$icon" icon.color="$color" \
    label="$label" label.align="$align"
}

get_track() {
  if command -v media-control >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    local INFO PLAYING TITLE ARTIST BID
    INFO=$(media-control get 2>/dev/null)
    PLAYING=$(echo "$INFO" | jq -r '.playing // false' 2>/dev/null)
    if [ "$PLAYING" == "true" ]; then
      TITLE=$(echo "$INFO" | jq -r '.title // empty' 2>/dev/null)
      ARTIST=$(echo "$INFO" | jq -r '.artist // empty' 2>/dev/null)
      BID=$(echo "$INFO" | jq -r '.bundleIdentifier // empty' 2>/dev/null)
      if [ -n "$TITLE" ]; then
        local track
        if [ -n "$ARTIST" ]; then
          track="${ARTIST} – ${TITLE}"
        else
          track="${TITLE}"
        fi
        # Wykryj zrodlo (ikona + kolor) i wypisz: ICON|COLOR|TRACK
        local si sc
        si=$(detect_source "$BID" | sed -n '1p')
        sc=$(detect_source "$BID" | sed -n '2p')
        echo "${si}|${sc}|${track}"
      fi
    fi
  else
    # Fallback AppleScript (tylko Spotify/Music — Evermusic nie ma slownika).
    local app state artist title
    for app in Spotify Music; do
      state=$(osascript -e "tell application \"$app\" to player state as string" 2>/dev/null)
      if [ "$state" == "playing" ]; then
        artist=$(osascript -e "tell application \"$app\" to artist of current track as string" 2>/dev/null)
        title=$(osascript -e "tell application \"$app\" to name of current track as string" 2>/dev/null)
        if [ -n "$title" ]; then
          local track
          if [ -n "$artist" ]; then track="${artist} – ${title}"; else track="${title}"; fi
          # Apple Music / Spotify -> nutka, pink
          echo "music|0xfff5c2e7|${track}"
        fi
        return 0
      fi
    done
  fi
}

RAW=$(get_track)
# Rozbij na ICON|COLOR|TRACK (domyslnie nutka, jesli puste)
SRC_ICON="${RAW%%|*}"
REST="${RAW#*|}"
SRC_COLOR="${REST%%|*}"
TRACK="${REST#*|}"

if [ -z "$SRC_ICON" ]; then SRC_ICON="$GLYPH_MUSIC"; fi
if [ -z "$SRC_COLOR" ]; then SRC_COLOR="$COLOR_PINK"; fi

if [ -z "$TRACK" ]; then
  kill_marquee
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Zapisz biezacy utwor (marquee sam sie zakonczy, gdy sie zmieni).
echo "$TRACK" > "$TRACKFILE"

if [ ${#TRACK} -le $WINDOW ]; then
  # Krotki: statycznie wycentrowany, bez marquee.
  kill_marquee
  set_widget "$SRC_ICON" "$SRC_COLOR" "$TRACK" center
else
  # Dlugi: marquee w tle (przewija w lewo, align=left => nie nachodzi na ikone).
  # Nie restartuj marquee, jesli juz kreci TEN SAM utwor (update_freq=5 wywoluje
  # ten skrypt co 5s -> bez tego checku tekst resetowalby sie do poczatku co 5s).
  SHOULD_START=1
  if [ -f /tmp/sketchybar_music_marquee.pid ]; then
    OLD=$(cat /tmp/sketchybar_music_marquee.pid 2>/dev/null)
    if kill -0 "$OLD" 2>/dev/null; then
      OLDCMD=$(ps -p "$OLD" -o command= 2>/dev/null)
      case "$OLDCMD" in
        *"$TRACK"*) SHOULD_START=0 ;;
      esac
    fi
  fi
  if [ "$SHOULD_START" = 1 ]; then
    kill_marquee
    # (python3 ... &) w subshellu + disown odczepia proces od sesji SketchyBar,
    # zeby sbar.exec nie zabil go po zakonczeniu tego skryptu (wtedy marquee
    # umieralby po ulamku sekundy i tekst stalby w miejscu).
    (python3 "$MARQUEE_SCRIPT" "$TRACK" "$NAME" "$WINDOW" >/dev/null 2>&1 & echo $! > /tmp/sketchybar_music_marquee.pid)
    disown 2>/dev/null || true
    # Chwila, by marquee zdolal sie odczepic i wystartowac petle.
    sleep 0.3
    # Pierwszy kadr od razu (align=left), zeby nie blyskalo wycentrowanym.
    # USTAWIAMY label TYLKO gdy odpalamy NOWY marquee -- w przeciwnym razie
    # update_freq=5 (ponizszy polling) resetowalby pozycje przewijania do
    # poczatku co 5 sekund (widoczny "skok tekstu do startu").
    set_widget "$SRC_ICON" "$SRC_COLOR" "$TRACK" left
  else
    # Marquee juz kreci ten sam utwor: nie ruszaj label (zeby nie zresetowac
    # przewijania), ale zapewnij poprawna ikone + kolor zrodla.
    sketchybar --set "$NAME" drawing=on icon="$SRC_ICON" icon.color="$SRC_COLOR"
  fi
fi
