-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.automatically_reload_config = true
config.enable_tab_bar = false
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 18

config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.macos_window_background_blur = 10

config.default_cursor_style = "BlinkingBar"

config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 0,
}
config.color_scheme = "Nord (Gogh)"
config.background = {
	{
		source = {
			Color = "#000000",
		},
		width = "100%",
		height = "100%",
		opacity = 0.8,
	},
}

-- and finally, return the configuration to wezterm
return config
