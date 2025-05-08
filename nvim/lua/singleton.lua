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
    if server ~= vim.v.servername then return server end
  end
  return nil
end
local function restore_session(server)
  local session = vim.fs.joinpath(vim.fn.stdpath('data'), 'singleton', vim.fn.getpid() .. '.vim')
  local session_dir = vim.fs.dirname(session)
  local files = vim.fn.glob(session_dir .. '/*.vim', false, true)
  if #files > 10 then
    for _, file in ipairs(files) do vim.fn.delete(file) end
  end
  vim.fn.mkdir(session_dir, 'p')
  vim.cmd('mksession! ' .. session .. ' | enew')
  vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false, { 'wait for open...' })
  vim.system({ vim.v.progpath, '--server', server, '--remote-send', ':source ' .. session .. '<CR>' }, nil,
    function() vim.schedule(function() vim.cmd('q!') end) end)
end
local function open_other_server(server)
  vim.opt.swapfile = false
  vim.opt.shada = ''
  vim.opt.loadplugins = false
  vim.api.nvim_create_autocmd('VimEnter',
    {
      once = true,
      callback = function() restore_session(server) end
    })
end
local M = {}
M.singleton = function()
  local my_server = already_server()
  if my_server == nil then return false end
  open_other_server(my_server)
  return true
end
return M
