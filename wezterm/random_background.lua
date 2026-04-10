local M = {}

local function update_bg_opacity(in_overrides, index)
  local unclear_opacity = 0.5
  for i, images in ipairs(in_overrides.background) do
    if i == index + 1 then
      images.opacity = unclear_opacity
    else
      images.opacity = 0.0
    end
  end
end

local function set_background_image_list(count, wezterm)
  local image_list = {}
  for i = 0, count do
    local image = {
      source = { File = string.format('%s/my_images/image%d.jpg', wezterm.home_dir, i) },
      hsb = { brightness = 0.1 },
      opacity = 0.0,
      vertical_align = 'Middle',
      horizontal_align = 'Center',
    }
    table.insert(image_list, image)
  end
  return image_list
end

function M.setup(wezterm, config, max, interval_time)
  local last_time = os.time()
  config.background = set_background_image_list(max, wezterm)
  wezterm.on('update-status', function(window, _)
    local now = os.time()
    local delta = now - last_time
    if delta < interval_time then return end
    last_time = now
    local new_random = math.random(0, max)
    local overrides = window:get_config_overrides() or {}
    overrides.background = overrides.background or config.background
    update_bg_opacity(overrides, new_random)
    window:set_config_overrides(overrides)
  end)
end

return M
