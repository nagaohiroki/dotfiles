local function global_serverlist()
  if vim.fn.has('win32') == 1 then
    return vim.fn.glob([[\\.\pipe\nvim.*]], false, true)
  end
  return vim.fn.glob('/var/folders/*/*/*/nvim.*/*/nvim.*.0', false, true)
end
local function already_server()
  local servers = global_serverlist()
  if #servers == 0 then return nil end
  for _, server in ipairs(servers) do
    if server ~= vim.v.servername then
      return server
    end
  end
  return nil
end
local function open_other_server(server)
  vim.opt.swapfile = false
  vim.opt.shada = ''
  vim.opt.loadplugins = false
  vim.api.nvim_create_autocmd('VimEnter',
    {
      once = true,
      callback = function()
        local cmd = string.format(
          '"%s" --server "%s" --remote-send "<Esc>:lua require(\'singleton\').edit_file([[%s]],%s,%s)<CR>"',
          vim.v.progpath, server, vim.api.nvim_buf_get_name(0), vim.fn.line('.'), vim.fn.col('.'))
        vim.cmd('enew')
        vim.fn.jobstart(cmd, { on_exit = function() vim.cmd('q') end })
      end
    })
end
local M = {}
M.singleton = function()
  local my_server = already_server()
  if my_server == nil then
    return false
  end
  open_other_server(my_server)
  return true
end
M.edit_file = function(fname, line, col)
  if fname == '' then
    vim.cmd('enew')
  else
    vim.cmd('drop ' .. vim.fn.fnameescape(fname))
    vim.fn.cursor(line, col)
  end
end

return M
