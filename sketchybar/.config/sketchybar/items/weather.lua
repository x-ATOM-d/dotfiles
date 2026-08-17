local sbar = require("sketchybar")
local colors = require("colors")
local helpers = require("helpers")

local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

local weather = sbar.add("item", "widgets.weather", {
  position = "right",
  click_script = plugin_dir .. "/open_weather.sh",
  icon = { drawing = false }, -- wttr.in zwraca gotowe emoji z pogodą
  label = { string = "..." , color = colors.sapphire },
})

helpers.set_script(weather.name, plugin_dir .. "/weather.sh", 900) -- co 15 minut, żeby nie spamować wttr.in


-- Wymuszamy pierwsze wykonanie od razu (inaczej trzeba by czekać 15 minut)
sbar.exec("NAME=widgets.weather " .. plugin_dir .. "/weather.sh")
