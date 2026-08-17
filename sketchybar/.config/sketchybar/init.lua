-- ~/.config/sketchybar/init.lua
-- Główny plik konfiguracyjny SketchyBar (SbarLua) w motywie Catppuccin Mocha

-- Ścieżka do skompilowanego modułu SbarLua
package.cpath = package.cpath .. ";" .. os.getenv("HOME") .. "/.local/share/sketchybar_lua/?.so"
-- Ścieżka do naszych własnych modułów (colors.lua, settings.lua, itd.)
package.path = package.path .. ";" .. os.getenv("CONFIG_DIR") .. "/?.lua"

local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

sbar.begin_config()

-- Wygląd samego paska
sbar.bar({
  height        = settings.bar_height,
  color         = colors.bar.bg,
  border_color  = colors.bar.border,
  border_width  = 2,
  position      = "top",
  padding_left  = 10,
  padding_right = 10,
  margin        = 6,
  corner_radius = 10,
  y_offset      = 5,
  blur_radius   = 30,
  sticky        = true,
  topmost       = "window",
})

-- Domyślny styl wszystkich itemów (dziedziczony, chyba że nadpisany)
sbar.default({
  updates = "on",
  icon = {
    font = { family = settings.font, style = "Bold", size = 14.0 },
    color = colors.text,
    padding_left = 8,
    padding_right = 4,
  },
  label = {
    font = { family = settings.font, style = "Semibold", size = 13.0 },
    color = colors.text,
    padding_left = 4,
    padding_right = 8,
  },
  background = {
    height = 26,
    corner_radius = 6,
    border_width = 1,
    border_color = colors.surface1,
    color = colors.transparent,
  },
  padding_left = 3,
  padding_right = 3,
})

-- Ładujemy poszczególne widgety (kolejność ma znaczenie dla lewej/prawej strony)
-- Dla position="right": pierwszy wczytany ląduje najdalej na prawo (przy krawędzi),
-- każdy kolejny ląduje bliżej środka. Więc "music" jest na końcu, żeby wylądować
-- tuż obok RAM, najbliżej środka paska.
require("items.spaces")    -- lewa strona: spaces + separator ">" + front_app (focus)
require("items.clock")     -- środek: data + godzina
require("items.weather")   -- prawa strona (najdalej od środka)
require("items.wifi")     -- zaraz za pogodą
require("items.volume")
require("items.battery")
require("items.ram")
require("items.privacy")
require("items.music")    -- najbliżej środka, tuż obok RAM

sbar.hotload(true)
sbar.end_config()

sbar.event_loop()
