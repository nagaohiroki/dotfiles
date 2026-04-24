local M = {}
local function progress_screen()
  local frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  local i = 1
  local timer = vim.uv.new_timer()
  if timer == nil then return end
  timer:start(0, 100, vim.schedule_wrap(function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      'server: ' .. vim.g.NVIM_SINGLETON,
      'please wait... ' .. frames[i] })
    i = i % #frames + 1
  end))
  return timer
end
local function open_buffer()
  local timer = progress_screen()
  if timer == nil then return end
  local function on_exit()
    vim.schedule(function()
      timer:stop()
      timer:close()
      vim.cmd('qa!')
    end)
  end
  vim.cmd('wshada')
  local open = '<Esc>:rshada | normal! `0<CR>'
  if vim.api.nvim_buf_get_name(0) == '' then open = '<Esc>:enew<CR>' end
  local cmd = { vim.v.progpath, '--server', vim.g.NVIM_SINGLETON, '--remote-send', open }
  vim.system(cmd, nil, on_exit)
end

function M.setup()
  vim.cmd('silent! rshada')
  if vim.fn.filereadable(vim.g.NVIM_SINGLETON) == 0 or vim.g.NVIM_SINGLETON == vim.v.servername then
    vim.g.NVIM_SINGLETON = vim.v.servername
    vim.cmd('wshada')
    return false
  end
  vim.opt.swapfile = false
  vim.opt.writebackup = false
  vim.opt.shadafile = ''
  vim.api.nvim_create_autocmd('VimEnter', { callback = open_buffer })
  return true
end

return M
