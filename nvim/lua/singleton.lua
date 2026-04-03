local M = {}
function M.setup()
  vim.cmd('rshada')
  if vim.fn.filereadable(vim.g.NVIM_SINGLETON) == 0 or vim.g.NVIM_SINGLETON == vim.v.servername then
    vim.g.NVIM_SINGLETON = vim.v.servername
    vim.cmd('wshada')
    return false
  end
  vim.opt.swapfile = false
  vim.opt.writebackup = false
  vim.opt.loadplugins = false
  vim.opt.shadafile = ''
  vim.api.nvim_create_autocmd('VimEnter',
    {
      once = true,
      callback = function()
        vim.cmd('wshada')
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'server: ' .. vim.g.NVIM_SINGLETON, 'please wait...' })
        vim.system(
          { vim.v.progpath, '--server', vim.g.NVIM_SINGLETON, '--remote-send', '<Esc>:rshada | normal! `0<CR>' },
          nil, function() vim.schedule(function() vim.cmd('qa!') end) end)
      end
    })
  return true
end

return M
