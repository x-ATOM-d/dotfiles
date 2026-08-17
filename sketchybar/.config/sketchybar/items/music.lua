local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local helpers = require("helpers")

local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

local music = sbar.add("item", "widgets.music", {
  position = "right",
  icon = {
    string = icons.music,
    color = colors.pink,
  },
  -- label.width=200 to stałe "okienko". Wyrównanie (center/left) i przewijanie
  -- (marquee) sa sterowane dynamicznie w plugins/music.sh:
  --   krotki tytul -> align=center (wycentrowany, statyczny)
  --   dlugi tytul  -> align=left + music_marquee.py (przewija w lewo, nie nachodzi na ikone)
  -- Natywne scroll_texts SketchyBar w tej wersji nie animuje tego widgetu (przetestowane),
  -- wiec uzywamy wlasnego marquee zamiast scroll_texts.
  label = {
    string = "",
    color = colors.text,
    width = 200,
    align = "center",
  },
  drawing = false,
})

helpers.set_script(music.name, plugin_dir .. "/music.sh", 5) -- awaryjny polling, oprócz media_change poniżej

-- Natychmiastowa reakcja na zmianę utworu/odtwarzacza (bez czekania na update_freq)
music:subscribe("media_change", function(env)
  sbar.exec("NAME=widgets.music " .. plugin_dir .. "/music.sh")
end)

-- Scroll = następny/poprzedni utwór.
-- UWAGA: media-control używa subkomend 'next-track' / 'previous-track' (ID 4/5),
-- a NIE 'next' / 'previous' (te zwracają "Unknown command" i spadają na fall-back
-- do AppleScript -> stąd bug, że odpalał się Spotify zamiast Evermusic).
-- media-control steruje KAŻDYM odtwarzaczem przez MediaRemote, więc nie potrzeba
-- fall-backu do AppleScript (pozostawiony tylko gdy media-control niezainstalowany).
music:subscribe("mouse.scrolled", function(env)
  -- media-control (akcja zapisu przez MediaRemote) wymaga GUI context / sesji,
  -- ktorego proces potomny sbar.exec NIE posiada -> bezposrednie "media-control next-track"
  -- w handlerze cicho nic nie robi (exit=0, ale utwor bez zmian). Opakowanie w osascript
  -- (do shell script) NADAJE ten kontekst, wiec sterowanie dziala z poziomu bara.
  -- (Przetestowane: z terminala media-control dziala; z bara tylko przez osascript.)
  local delta = tonumber(env.SCROLL_DELTA) or 1  -- nil => domyslnie "w gore" (nastepny)
  local action = delta > 0 and "next-track" or "previous-track"
  sbar.exec(string.format(
    "osascript -e 'do shell script \"/opt/homebrew/bin/media-control %s\"' >/dev/null 2>&1 &",
    action))
end)

-- Wymuszamy pierwsze wykonanie od razu
sbar.exec("NAME=widgets.music " .. plugin_dir .. "/music.sh")
