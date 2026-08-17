-- Spaces zarządzane przez yabai. Stan jest odczytywany z yabai przy każdej
-- zmianie przestrzeni; SELECTED bywa nieaktualne dla komponentów space.
local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")
local helpers = require("helpers")
local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"
local space_items, space_names = {}, {}

sbar.exec("yabai -m query --spaces", function(spaces)
  if type(spaces) ~= "table" then return end
  for i, space in ipairs(spaces) do
    local index = space.index
    local item = sbar.add("space", "space." .. i, {
      position = "left", space = index,
      icon = { string = tostring(i), color = colors.crust, highlight_color = colors.crust, padding_left = 9, padding_right = 9 },
      label = { drawing = false },
      background = { color = space["has-focus"] and colors.mauve or colors.surface1, corner_radius = 6, height = 22, border_width = 0 },
      click_script = plugin_dir .. "/space_click.sh " .. index,
    })
    space_items[i], space_names[i] = item, "space." .. i
  end
  sbar.add("bracket", "spaces.bracket", space_names, { background = { color = colors.transparent, border_width = 0 } })
  sbar.add("item", "spaces.padding", { position = "left", width = settings.group_paddings, background = { drawing = false } })
  sbar.add("item", "spaces.separator", {
    position = "left",
    icon = { drawing = false },
    label = { string = ">", font = { family = settings.font, style = "Bold", size = 13.0 }, color = colors.subtext1 },
    background = { drawing = false },
    padding_left = 0,
    padding_right = 0,
  })
  local front_app = sbar.add("item", "front_app", { position = "left", icon = { drawing = false }, label = { font = { family = settings.font, style = "Bold", size = 13.0 }, color = colors.mauve }, background = { drawing = false } })
  -- Yabai/SketchyBar emitują zdarzenie zmiany aktywnej aplikacji; polling nie
  -- jest potrzebny i tylko odpytuje yabai w tle.
  helpers.set_script(front_app.name, plugin_dir .. "/front_app.sh", 0)
  sbar.exec("sketchybar --subscribe front_app front_app_switched space_change display_change system_woke")
  sbar.exec("NAME=front_app " .. plugin_dir .. "/front_app.sh")
  local updater = sbar.add("item", "spaces.refresh", { position = "left", drawing = false })
  helpers.set_script(updater.name, plugin_dir .. "/spaces.sh", 0)
  sbar.exec("sketchybar --subscribe spaces.refresh space_change display_change system_woke")
  sbar.exec("NAME=spaces.refresh " .. plugin_dir .. "/spaces.sh")
end)
