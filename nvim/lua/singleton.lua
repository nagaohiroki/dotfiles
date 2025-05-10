local M = {}
M._config = {
  session = {
    dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'singleton'),
    save_limit = 10,
    sessionoptions = 'buffers,tabpages'
  }
}
local function is_running()
  vim.cmd('rshada')
  if vim.fn.exists('g:NVIM_SINGLETON') == 0 then
    return false
  end
  if vim.fn.filereadable(vim.g.NVIM_SINGLETON) == 0 then
    return false
  end
  if vim.g.NVIM_SINGLETON == vim.v.servername then
    return false
  end
  return true
end
local function restore_session()
  local session_dir = M._config.session.dir
  local session = vim.fs.joinpath(session_dir, vim.fn.getpid() .. '.vim')
  local files = vim.fn.glob(session_dir .. '/*.vim', false, true)
  if #files > M._config.session.save_limit then
    for _, file in ipairs(files) do vim.fn.delete(file) end
  end
  vim.fn.mkdir(session_dir, 'p')
  vim.cmd('mksession! ' .. session .. ' | enew')
  vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false, {
    'target server: ' .. vim.g.NVIM_SINGLETON,
    'mksession: ' .. session,
    'please wait...'
  })
  vim.system({ vim.v.progpath, '--server', vim.g.NVIM_SINGLETON, '--remote-send', '<Esc>:source ' .. session .. '<CR>' },
    nil, function() vim.schedule(function() vim.cmd('qa!') end) end)
end
local function open_other_server()
  vim.opt.swapfile = false
  vim.opt.writebackup = false
  vim.opt.loadplugins = false
  vim.opt.shada = ''
  vim.opt.sessionoptions = M._config.session.sessionoptions
  vim.api.nvim_create_autocmd('VimEnter', { once = true, callback = function() restore_session() end })
end
function M.setup(config)
  M._config = vim.tbl_deep_extend('force', M._config, config or {})
  if is_running() then
    open_other_server()
    return true
  end
  vim.g.NVIM_SINGLETON = vim.v.servername
  vim.cmd('wshada')
  return false
end
return M
