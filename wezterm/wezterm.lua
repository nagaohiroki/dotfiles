local wezterm = require 'wezterm'
local config = {}
config = wezterm.config_builder()
config.use_ime = true
config.enable_scroll_bar = true
config.font = wezterm.font_with_fallback({ [[HackGen Console NF]] })
config.font_size = 12
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
config.background =
{
	{
		source = { File = 'C:/work/images/image1.jpg' },
		hsb = { brightness = 0.1 },
		opacity = 0.8,
	},
}
config.window_close_confirmation = 'NeverPrompt'
config.initial_cols = 90
config.initial_rows = 60
return config
