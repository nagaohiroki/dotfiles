local M = {}
M.singleton = function()
  local my_server = vim.env.HOME .. [[/.local/state/nvim/nvim226]]
  if vim.fn.has('win32') == 1 then my_server = [[\\.\pipe\nvim-server]] end
  if my_server == vim.v.servername then return false end
  local result, _ = pcall(vim.fn.serverstart, my_server)
  if result then
    vim.fn.serverstop(vim.v.servername)
    return false
  end
  vim.opt.swapfile = false
  vim.opt.shada = ''
  vim.opt.loadplugins = false
  vim.api.nvim_create_autocmd('VimEnter',
    {
      once = true,
      callback = function()
        local cmd = string.format(
          '"%s" --server "%s" --remote-send "<Esc>:lua require(\'singleton\').edit_file([[%s]],%s,%s)<CR>"',
          vim.v.progpath, my_server, vim.api.nvim_buf_get_name(0), vim.fn.line('.'), vim.fn.col('.'))
        vim.cmd('enew')
        vim.fn.jobstart(cmd, { on_exit = function() vim.cmd('q') end })
      end
    })
  return true
end

M.edit_file = function(fname, line, col)
  if fname == '' then
    vim.cmd('enew')
  else
    vim.cmd('tab drop ' .. vim.fn.fnameescape(fname))
    vim.fn.cursor(line, col)
  end
end

return M
