local M = {}
local function is_running()
  return vim.fn.exists('g:NVIM_SINGLETON') ~= 0
      and vim.fn.filereadable(vim.g.NVIM_SINGLETON) ~= 0
      and vim.g.NVIM_SINGLETON ~= vim.v.servername
end
local function restore()
  vim.cmd('wshada')
  vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false,
    { 'server: ' .. vim.g.NVIM_SINGLETON, 'please wait...' })
  vim.system({ vim.v.progpath, '--server', vim.g.NVIM_SINGLETON, '--remote-send', '<Esc>:rshada | normal! `0<CR>' },
    nil, function() vim.schedule(function() vim.cmd('qa!') end) end)
end
function M.setup()
  vim.cmd('rshada')
  if is_running() then
    vim.opt.swapfile = false
    vim.opt.writebackup = false
    vim.opt.loadplugins = false
    vim.opt.shadafile = ''
    vim.api.nvim_create_autocmd('VimEnter', { once = true, callback = restore })
    return true
  end
  vim.g.NVIM_SINGLETON = vim.v.servername
  vim.cmd('wshada')
  return false
end

return M
