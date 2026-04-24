local M = {}
local function open_buffer()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'server: ' .. vim.g.NVIM_SINGLETON, 'please wait...' })
  vim.cmd('wshada')
  local open = '<Esc>:rshada | normal! `0<CR>'
  if vim.api.nvim_buf_get_name(0) == '' then open = '<Esc>:enew<CR>' end
  local cmd = { vim.v.progpath, '--server', vim.g.NVIM_SINGLETON, '--remote-send', open }
  vim.system(cmd, nil, function() vim.schedule(function() vim.cmd('qa!') end) end)
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
