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
  config.default_prog = { 'pwsh', '-NoLogo' }
end
if is_mac() then
  config.font_size = 14
end
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.text_background_opacity = 0.5
config.window_background_opacity = 0.5
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'
config.macos_window_background_blur = 20
config.win32_system_backdrop = 'Acrylic'
config.color_scheme = 'Tokyo Night'
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
config.window_close_confirmation = 'NeverPrompt'
config.initial_cols = 90
config.initial_rows = 60
local function window_resize(width, height)
  return wezterm.action_callback(function(window, _)
    local dims = window:get_dimensions()
    window:set_inner_size(dims.pixel_width + width, dims.pixel_height + height)
  end)
end
local add_size = 50
config.keys =
{
  { key = 'LeftArrow',  mods = 'ALT', action = window_resize(-add_size, 0) },
  { key = 'RightArrow', mods = 'ALT', action = window_resize(add_size, 0) },
  { key = 'UpArrow',    mods = 'ALT', action = window_resize(0, -add_size) },
  { key = 'DownArrow',  mods = 'ALT', action = window_resize(0, add_size) },
  {
    key = ' ',
    mods = 'CTRL',
    action = wezterm.action.SendKey({ key = ' ', mods = 'CTRL' })
  },
}
config.set_environment_variables =
{
  STARSHIP_CONFIG = wezterm.home_dir .. '/dotfiles/starship.toml',
}

local unclear_opacity = 0.5
config.background = { {
  source = { File = wezterm.home_dir .. '/my_images/image.jpg' },
  hsb = { brightness = 0.1 },
  opacity = unclear_opacity,
  vertical_align = 'Middle',
  horizontal_align = 'Center',
} }
-- require('random_background').setup(wezterm, config, 5, 5)
return config
