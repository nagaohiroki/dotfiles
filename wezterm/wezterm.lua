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
config.prefer_to_spawn_tabs = true
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.text_background_opacity = 0.5
config.window_background_opacity = 0.5
config.macos_window_background_blur = 20
config.win32_system_backdrop = 'Acrylic'
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
    key = 'r',
    mods = 'ALT',
    action = wezterm.action.ReloadConfiguration
  },
}
config.set_environment_variables =
{
  STARSHIP_CONFIG = wezterm.home_dir .. '/dotfiles/starship.toml',
}

local unclear_opacity = 0.5
config.background = { {
  source = { File = wezterm.home_dir .. '/my_images/image10.jpg' },
  hsb = { brightness = 0.1 },
  opacity = unclear_opacity,
  vertical_align = 'Middle',
  horizontal_align = 'Center',
} }
-- local function set_background_image_list(count)
--   local image_list = {}
--   for i = 0, count do
--     local image = {
--       source = { File = string.format('%s/my_images/image%d.jpg', wezterm.home_dir, i) },
--       hsb = { brightness = 0.1 },
--       opacity = 0.0,
--       vertical_align = 'Middle',
--       horizontal_align = 'Center',
--     }
--     table.insert(image_list, image)
--   end
--   return image_list
-- end
--
-- local function update_bg_opacity(in_overrides, index)
--   for i, images in ipairs(in_overrides.background) do
--     if i == index + 1 then
--       images.opacity = unclear_opacity
--     else
--       images.opacity = 0.0
--     end
--   end
-- end
-- local max = 12
-- local interval_time = 5
-- config.background = set_background_image_list(max)
-- local init_random = math.random(0, max)
-- update_bg_opacity(config, init_random)
-- local last_time = os.time()
-- wezterm.on('update-status', function(window, _)
--   local now = os.time()
--   local delta = now - last_time
--   if delta < interval_time then return end
--   last_time = now
--   local new_random = math.random(0, max)
--   local overrides = window:get_config_overrides() or {}
--   overrides.background = overrides.background or config.background
--   update_bg_opacity(overrides, new_random)
--   window:set_config_overrides(overrides)
-- end)
return config
