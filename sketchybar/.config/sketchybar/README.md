# SketchyBar + Catppuccin Mocha (Lua)

Gotowy build SketchyBar napisany w Lua (przez [SbarLua](https://github.com/FelixKratz/SbarLua)),
w motywie **Catppuccin Mocha**.

**Układ:**
- lewa strona: spaces (yabai) + aktywna aplikacja
- środek: data i godzina (jak w GNOME/KDE)
- prawa strona: pogoda, głośność, bateria, RAM, CPU, muzyka oraz wskaźnik prywatności

## Obsługa

- Klik pogody otwiera wttr.in dla Rzeszowa w przeglądarce.
- Klik głośności wycisza/odwycisza (brak popupu — usunięty celowo).
- Klik przestrzeni przełącza ją. **Cmd-klik** przenosi aktywne okno do tej
  przestrzeni i na nią przechodzi. SketchyBar nie przekazuje zdarzeń
  mouse-down/mouse-up, więc nie da się odróżnić prawdziwego long-press od kliknięcia.
- Scroll nad głośnością zmienia jej poziom.
- Scroll nad muzyką = następny (w górę) / poprzedni (w dół) utwór. Klik = play/pause.
  Przy zainstalowanym `media-control` scroll i klik działają z każdym odtwarzaczem
  (Spotify, Apple Music, przeglądarka/YouTube itd.); bez niego scroll działa tylko
  ze Spotify/Apple Music przez AppleScript.

RAM jest liczony bezpośrednio z metryk systemowych macOS (`vm_stat`) i korzysta z
tej samej definicji „Memory Used” co Activity Monitor / Stats:
`(active + inactive + speculative + wired + compressed − purgeable − external) * pagesize`.
Dzięki temu wartość zgadza się z tym, co pokazuje aplikacja Stats.

Wskaźnik mikrofonu/kamery jest best-effort: macOS nie publikuje publicznego API
globalnego użycia mikrofonu. Systemowy pomarańczowy/zielony wskaźnik macOS pozostaje
jedynym wiarygodnym źródłem dla wszystkich aplikacji.

## 1. Instalacja zależności

```bash
brew install sketchybar lua yabai jq
brew install --cask font-jetbrains-mono-nerd-font

# opcjonalnie, ale zalecane: uniwersalny "now playing" (Spotify, Apple Music,
# przeglądarka/YouTube itd.) zamiast tylko AppleScript dla dwóch appek
brew tap ungive/media-control
brew install media-control
```

## 2. Instalacja SbarLua (most Lua <-> SketchyBar)

```bash
git clone --depth 1 https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua && make install
rm -rf /tmp/SbarLua
```

## 3. Skopiowanie configu

Rozpakuj tę paczkę do `~/.config/sketchybar/` (nadpisując domyślny config jeśli już istnieje):

```bash
mkdir -p ~/.config/sketchybar
cp -R ./sketchybar/* ~/.config/sketchybar/
chmod +x ~/.config/sketchybar/sketchybarrc
chmod +x ~/.config/sketchybar/plugins/*.sh
```

## 4. yabai (spaces po lewej stronie)

Jeśli nie masz jeszcze yabai skonfigurowanego:

```bash
brew install koekeishiya/formulae/yabai
yabai --start-service
```

Jeśli używasz innego window managera (np. AeroSpace), podmień w
`items/spaces.lua` zapytanie `yabai -m query --spaces` oraz `click_script`
na odpowiednik dla Twojego WM.

## 5. Uruchomienie

```bash
brew services restart sketchybar
```

albo, żeby zobaczyć logi na żywo podczas debugowania:

```bash
sketchybar --reload
```

## Uwagi

- **Pogoda** korzysta z darmowego `wttr.in` (bez klucza API) i odświeża się co 15 minut,
  żeby nie zostać zbanowanym za spam requestów. Jeśli chcesz inne miasto na sztywno,
  zmień URL w `plugins/weather.sh` na np. `https://wttr.in/Gdansk?format=%c+%t`.
- **Muzyka** domyślnie korzysta z `media-control` (jeśli zainstalowany) — działa z dowolnym
  odtwarzaczem (Spotify, Apple Music, przeglądarka). Bez niego automatycznie przechodzi na
  AppleScript, który obsługuje tylko Spotify i Apple Music. Scroll nad widgetem = następny/
  poprzedni utwór, klik = play/pause.
- **Ważne:** wszystkie widgety mają `updates = "on"` w `init.lua`. Jeśli kiedyś zmienisz to
  na `"when_shown"` (domyślne w wielu przykładach SketchyBar), `update_freq` przestanie
  cyklicznie odświeżać itemy — będą aktualizować się tylko przy `--reload`.
- **Data** domyślnie używa locale systemu. Jeśli chcesz polskie nazwy dni/miesięcy na sztywno,
  odkomentuj linię `export LC_TIME=pl_PL.UTF-8` w `plugins/date.sh`.
- Kolory Catppuccin są w jednym miejscu — `colors.lua` — więc łatwo je podmienić na inny
  flavor (Latte / Frappé / Macchiato) albo zupełnie inny motyw.
- Wszystkie ikony to Nerd Font (Font Awesome), zdefiniowane w `icons.lua`.
