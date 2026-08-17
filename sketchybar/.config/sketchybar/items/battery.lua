local sbar = require("sketchybar")
local colors = require("colors")
local helpers = require("helpers")

local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  icon = { color = colors.yellow },
  label = { string = "--%" },
})

helpers.set_script(battery.name, plugin_dir .. "/battery.sh", 60)

battery:subscribe({ "power_source_change", "system_woke" }, function(env)
  sbar.exec("NAME=widgets.battery " .. plugin_dir .. "/battery.sh")
end)

-- Wymuszamy pierwsze wykonanie od razu
sbar.exec("NAME=widgets.battery " .. plugin_dir .. "/battery.sh")
