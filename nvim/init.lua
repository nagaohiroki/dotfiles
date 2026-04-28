if require('singleton').setup() then return end
vim.g.mapleader = ' '
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.fixeol = false
vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.title = true
vim.opt.number = true
vim.opt.list = true
vim.opt.undofile = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.cmdheight = 2
vim.opt.mouse = 'a'
vim.opt.listchars = { eol = '<', tab = '> ', extends = '<' }
vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'
vim.opt.clipboard = { 'unnamed', 'unnamedplus' }
vim.opt.fileencodings = { 'ucs-bom', 'iso-2022-jp-3', 'euc-jisx0213', 'cp932', 'sjis', 'euc-jp', 'utf-8' }
vim.opt.statusline =
    '%<%f%m%r%h%w%y[%{&fenc}%{(&bomb?"_bom":"")}][%{&ff}]' ..
    '%=%c,%l/%L%{exists("*FugitiveStatusline")?FugitiveStatusline():""}'
vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_create_user_command('Errors', function() vim.diagnostic.setqflist() end, {})
vim.api.nvim_create_user_command('CodeAction', function() vim.lsp.buf.code_action() end, {})
vim.api.nvim_create_user_command('DocumentSymbol', function() vim.lsp.buf.document_symbol() end, {})
vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {})
vim.api.nvim_create_user_command('CdCurrent', function() vim.api.nvim_set_current_dir(vim.fn.expand('%:p:h')) end, {})
vim.api.nvim_create_user_command('CopyPath', function() vim.fn.setreg('*', vim.fn.expand('%:p')) end, {})
vim.api.nvim_create_user_command('CopyPathLine', function()
  vim.fn.setreg('*', vim.fn.expand('%:p') .. '#L' .. vim.fn.line('.'))
end, {})
vim.api.nvim_create_user_command('Wex', function()
  if vim.fn.has('mac') == 1 then
    vim.fn.system('open ' .. vim.fn.expand('%:h'))
  end
  if vim.fn.has('win32') == 1 then
    vim.fn.system('start explorer /select,' .. vim.api.nvim_buf_get_name(0))
  end
end, {})
local function OpenWez(pos, percent)
  vim.fn.system({ 'wezterm', 'cli', 'split-pane', pos, '--percent', percent, '--cwd', vim.fn.expand('%:p:h') })
end
vim.api.nvim_create_user_command('WezRight', function() OpenWez('--right', '20') end, {})
vim.api.nvim_create_user_command('WezLeft', function() OpenWez('--left', '20') end, {})
vim.api.nvim_create_user_command('WezTop', function() OpenWez('--top', '20') end, {})
vim.api.nvim_create_user_command('WezBottom', function() OpenWez('--bottom', '20') end, {})
vim.api.nvim_create_user_command('WezWin', function()
  vim.fn.system({ 'wezterm', 'cli', 'spawn', '--cwd', vim.fn.expand('%:p:h'), '--new-window' })
end, {})
vim.api.nvim_create_user_command('Rc', function()
  vim.cmd.drop(vim.fs.joinpath(vim.env.HOME, 'dotfiles', 'nvim', 'init.lua'))
end, {})
vim.api.nvim_create_user_command('RcPlug', function()
  vim.cmd.drop(vim.fs.joinpath(vim.env.HOME, 'dotfiles', 'nvim', 'lua', 'plugins.lua'))
end, {})
vim.api.nvim_create_user_command('Utf8bomLF', function()
  vim.opt.fileencoding = 'utf-8'
  vim.opt.bomb = true
  vim.opt.fileformat = 'unix'
end, {})
vim.api.nvim_create_augroup('loading', {})
vim.api.nvim_create_autocmd('QuickFixCmdPost',
  {
    group = 'loading',
    command = 'cwindow'
  })
vim.api.nvim_create_autocmd('FileType',
  {
    group = 'loading',
    pattern = { 'gitcommit' },
    command = 'set fenc=utf-8'
  })
vim.api.nvim_create_autocmd('FileType',
  {
    group = 'loading',
    pattern = { 'markdown' },
    callback = function()
      vim.opt.foldmethod = 'marker'
      vim.opt.foldmarker = { '<details>', '</details>' }
    end
  })
vim.api.nvim_create_autocmd('BufRead',
  {
    group = 'loading',
    callback = function()
      local line = vim.fn.line("'\"")
      if line > 0 and line <= vim.fn.line("$") then
        vim.fn.cursor(line, vim.fn.col("'\""))
      end
    end
  })
vim.api.nvim_create_autocmd('TermOpen',
  {
    group = 'loading',
    callback = function()
      vim.cmd('startinsert')
    end
  })
for _, ext in pairs({ 'usf', 'ush', 'cginc', 'shader', 'glslinc', 'fx', 'hlsl' }) do
  vim.filetype.add({ extension = { [ext] = 'hlsl' } })
end
vim.api.nvim_create_autocmd('BufWritePre',
  {
    group = 'loading',
    callback = function()
      local view = vim.fn.winsaveview()
      vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
      vim.fn.winrestview(view)
    end,
  })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set({ 'n', 'v' }, '<C-p>', '"0p')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
vim.keymap.set('n', '<leader>g', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>u', vim.lsp.buf.references)
vim.lsp.enable({ 'basedpyright', 'ruff' })
vim.lsp.config('clangd', { filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto', 'hlsl' }, })
vim.lsp.config('roslyn', { capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = false } } } })
vim.lsp.config('lua_ls', {
  on_init = function(client)
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = { 'lua/?.lua', 'lua/?/init.lua', },
      },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME }
      }
    })
  end,
  settings = { Lua = {} }
})
require('vim._core.ui2').enable({})
local lazypath = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy', 'lazy.nvim')
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins', { change_detection = { notify = false } })
