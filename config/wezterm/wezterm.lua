-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Dracula (Official)'
config.font = wezterm.font('VictorMono Nerd Font')
config.font_size = 10.0
config.enable_tab_bar = false
config.show_tabs_in_tab_bar = false
config.enable_scroll_bar = false
config.enable_wayland = true
config.disable_default_mouse_bindings = true
config.swallow_mouse_click_on_window_focus = true
config.window_background_opacity = 1.0
-- config.window_decorations = "NONE"

config.window_padding = {
    --[[
    left = '1.0cell',
    right = '1.0cell',
    top = '0.5cell',
    bottom = '0.25cell',
    ]] --
    left = '12',
    right = '12',
    top = '12',
    bottom = '12',

}

-- and finally, return the configuration to wezterm
return config
