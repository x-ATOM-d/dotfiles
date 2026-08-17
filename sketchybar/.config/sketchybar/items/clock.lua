-- Środek paska: zegar (lewa strona grupy) + data (prawa strona grupy)

local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

-- UWAGA: script/update_freq ustawiane bezpośrednio przy tworzeniu itemu
-- (a nie post-factum przez osobne wywołanie sketchybar --set) - to właśnie
-- brak tego był przyczyną "zamrożonej" daty: dotychczasowy workaround
-- (oddzielny sbar.exec z "--set ... script=... update_freq=...") potrafił
-- nie zadziałać, więc widget nigdy nie dostawał aktywnego update_freq i po
-- prostu nie odświeżał się automatycznie po pierwszym uruchomieniu.

local clock = sbar.add("item", "widgets.clock", {
  position = "center",
  script = plugin_dir .. "/clock.sh",
  update_freq = 1,
  icon = {
    string = icons.clock,
    color = colors.mauve,
  },
  label = {
    string = "--:--:--",
    font = { family = settings.font, style = "Bold", size = 13.0 },
    color = colors.text,
  },
  background = { drawing = false },
})

local date = sbar.add("item", "widgets.date", {
  position = "center",
  script = plugin_dir .. "/date.sh",
  update_freq = 1,
  icon = {
    string = icons.calendar,
    color = colors.rosewater,
  },
  label = {
    string = "ładowanie...",
    color = colors.subtext1,
  },
  background = { drawing = false },
})

sbar.add("item", "widgets.clock.padding", {
  position = "center",
  width = settings.group_paddings,
  background = { drawing = false },
})

-- Wymuszamy pierwsze wykonanie od razu, żeby nie czekać na pierwszy tick update_freq
sbar.exec("NAME=widgets.clock " .. plugin_dir .. "/clock.sh")
sbar.exec("NAME=widgets.date " .. plugin_dir .. "/date.sh")
