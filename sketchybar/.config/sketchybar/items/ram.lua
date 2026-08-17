local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local helpers = require("helpers")

local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

local ram = sbar.add("item", "widgets.ram", {
  position = "right",
  icon = {
    string = icons.ram,
    color = colors.green,
  },
  label = { string = "--%" },
})

helpers.set_script(ram.name, plugin_dir .. "/ram.sh", 5)

-- Wymuszamy pierwsze wykonanie od razu
sbar.exec("NAME=widgets.ram " .. plugin_dir .. "/ram.sh")
