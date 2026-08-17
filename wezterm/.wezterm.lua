-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()
local act = wezterm.action

-- Font
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19

-- Window
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.window_padding = { left = 12, right = 12, top = 8, bottom = 0 }
config.adjust_window_size_when_changing_font_size = false

-- Colors
config.color_scheme = "Catppuccin Mocha"

-- Keys
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Scrollback
config.scrollback_lines = 10000

-- Skok do okien tmux: Cmd+1..9 -> okna 1..9, Cmd+0 -> okno 10
-- (prefix Ctrl-a ustawiony w ~/.config/tmux/tmux.conf; base-index 1)
local tmux_window_keys = {}
for i = 1, 9 do
  table.insert(tmux_window_keys, {
    key = tostring(i),
    mods = "CMD",
    action = act.Multiple {
      act.SendKey { key = "a", mods = "CTRL" },
      act.SendKey { key = tostring(i) },
    },
  })
end
table.insert(tmux_window_keys, {
  key = "0",
  mods = "CMD",
  action = act.Multiple {
    act.SendKey { key = "a", mods = "CTRL" },
    act.SendKey { key = "1" },
    act.SendKey { key = "0" },
  },
})
config.keys = tmux_window_keys

return config
