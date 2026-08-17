local sbar = require("sketchybar")
local colors = require("colors")
local helpers = require("helpers")

local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

local volume = sbar.add("item", "widgets.volume", {
  position = "right",
  icon = { color = colors.sky },
  label = { string = "--%" },
})

helpers.set_script(volume.name, plugin_dir .. "/volume.sh", 10)
helpers.subscribe(volume.name, "volume_change")

-- Scrollowanie po ikonie zmienia głośność
volume:subscribe("mouse.scrolled", function(env)
  local delta = tonumber(env.SCROLL_DELTA) or 0
  sbar.exec("osascript -e \"set volume output volume (output volume of (get volume settings) + " .. (delta > 0 and 5 or -5) .. ")\"")
end)

-- Wymuszamy pierwsze wykonanie od razu
sbar.exec("NAME=widgets.volume " .. plugin_dir .. "/volume.sh")
