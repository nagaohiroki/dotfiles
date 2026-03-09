local wezterm = require 'wezterm'
local function is_windows()
  return wezterm.target_triple == 'x86_64-pc-windows-msvc'
end
local function is_mac()
  return wezterm.target_triple == 'aarch64-apple-darwin'
end
local config = {}
config = wezterm.config_builder()
config.use_ime = true
config.enable_scroll_bar = true
config.font = wezterm.font_with_fallback({ [[HackGen Console NF]] })
if is_windows() then
  config.font_size = 12
end
if is_mac() then
  config.font_size = 14
end
config.hide_tab_bar_if_only_one_tab = true
config.text_background_opacity = 0.8
config.window_background_opacity = 0.8
config.window_frame =
{
  inactive_titlebar_bg = 'none',
  active_titlebar_bg = 'none',
}
config.window_padding =
{
  top = 0,
  right = 0,
  bottom = 0,
  left = 0
}
-- config.background =
-- {
-- 	{
-- 		source = { File = 'C:/work/images/image1.jpg' },
-- 		hsb = { brightness = 0.1 },
-- 		opacity = 0.8,
-- 	},
-- }
config.window_close_confirmation = 'NeverPrompt'
config.initial_cols = 90
config.initial_rows = 60
return config
