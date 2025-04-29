local M = {}
local function execute_win(tbl)
  if vim.fn.has('python3') == 0 then
    return
  end
  local json = vim.fn.json_encode(tbl)
  local winctrl_py = vim.fn.fnameescape(vim.fs.joinpath(vim.fn.stdpath('config'), 'python3', 'winctrl.py'))
  vim.cmd('py3 sys.argv = [\'' .. json .. '\']')
  vim.cmd('py3file ' .. winctrl_py)
end
local function key_resize(map, width, height)
  vim.keymap.set('n', map, function()
    execute_win({ pid = vim.uv.os_getppid(), method = 'resize', width = width, height = height })
  end)
end
local function key_move(map, width, height)
  vim.keymap.set('n', map, function()
    execute_win({ pid = vim.uv.os_getppid(), method = 'move', width = width, height = height })
  end)
end
function M.activate()
  execute_win({ pid = vim.uv.os_getppid(), method = 'activate', width = 0, height = 0 })
end

function M.setup()
  local size = 200
  key_resize('<M-UP>', 0, -size)
  key_resize('<M-Down>', 0, size)
  key_resize('<M-Left>', -size, 0)
  key_resize('<M-Right>', size, 0)
  key_move('<S-M-UP>', 0, -size)
  key_move('<S-M-Down>', 0, size)
  key_move('<S-M-Left>', -size, 0)
  key_move('<S-M-Right>', size, 0)
end

return M
