local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local helpers = require("helpers")

local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

local wifi = sbar.add("item", "widgets.wifi", {
  position = "right",
  icon = {
    string = icons.wifi,
    color = colors.sky,
  },
  label = { string = "--" },
  click_script = "open x-apple.systempreferences:com.apple.wifi",
})

helpers.set_script(wifi.name, plugin_dir .. "/wifi.sh", 30)

-- Odśwież po wybudzeniu systemu (sieć może się zmienić)
wifi:subscribe("system_woke", function(env)
  sbar.exec("NAME=widgets.wifi " .. plugin_dir .. "/wifi.sh")
end)

-- Wymuszamy pierwsze wykonanie od razu
sbar.exec("NAME=widgets.wifi " .. plugin_dir .. "/wifi.sh")
