local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28

config.font_size = 21

-- See https://wezterm.org/colorschemes/t/index.html#tokyo-night-moon for more examples
config.color_scheme = "Tokyo Night Moon"
-- config.color_scheme = "Catppuccin Mocha"

-- config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.enable_csi_u_key_encoding = true

config.window_background_opacity = 0.9
config.text_background_opacity = 0.9
config.enable_scroll_bar = false
config.adjust_window_size_when_changing_font_size = false

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.cursor_blink_rate = 0
config.text_blink_rate_rapid = 0

if wezterm.target_triple:find("apple%-darwin") ~= nil then
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  config.font = wezterm.font_with_fallback({
    { family = "Hack Nerd Font", weight = "Regular", stretch = "Normal", style = "Normal" },
    "PingFang SC",
  })
elseif wezterm.target_triple:find("linux%-gnu") ~= nil then
  -- NOTE: not tested
  config.window_decorations = "RESIZE"
end

config.keys = {
  { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n") },
}

wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
