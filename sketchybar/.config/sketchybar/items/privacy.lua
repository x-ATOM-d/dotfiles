local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local helpers = require("helpers")
local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

local privacy = sbar.add("item", "widgets.privacy", {
  position = "right", icon = { string = icons.mic, color = colors.red }, label = { string = "", max_chars = 8 }, drawing = false,
})
helpers.set_script(privacy.name, plugin_dir .. "/privacy.sh", 3)
sbar.exec("NAME=widgets.privacy " .. plugin_dir .. "/privacy.sh")
