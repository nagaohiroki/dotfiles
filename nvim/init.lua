if require('singleton').singleton() then
  return
end
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
vim.opt.laststatus = 2
vim.opt.mouse = 'a'
vim.opt.listchars = { eol = '<', tab = '> ', extends = '<' }
vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'
vim.opt.clipboard = { 'unnamed', 'unnamedplus' }
vim.opt.fileencodings = { 'ucs-bom', 'iso-2022-jp-3', 'euc-jisx0213', 'cp932', 'sjis', 'euc-jp', 'utf-8' }
vim.opt.statusline =
    '%<%f%m%r%h%w%y[%{&fenc}%{(&bomb?"_bom":"")}][%{&ff}]' ..
    '%=%c,%l/%L%{exists("*FugitiveStatusline")?FugitiveStatusline():""}'
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
vim.api.nvim_create_user_command('Rc', function()
  vim.cmd.drop(vim.env.HOME .. '/dotfiles/nvim/init.lua')
end, {})
vim.api.nvim_create_user_command('RcPlug', function()
  vim.cmd.drop(vim.env.HOME .. '/dotfiles/nvim/lua/plugins.lua')
end, {})
vim.api.nvim_create_user_command('Utf8bomLF', function()
  vim.opt.fileencoding = 'utf-8'
  vim.opt.bomb = true
  vim.opt.fileformat = 'unix'
end, {})
vim.api.nvim_create_augroup('loading', {})

local function FontResize(inc)
  vim.g.fontSize = math.max(1, vim.g.fontSize + inc)
  if vim.g.GuiLoaded == 1 then
    vim.cmd('Guifont! ' .. vim.g.fontName .. ':h' .. vim.g.fontSize)
  end
  if vim.g.neovide then
    vim.opt.guifont = vim.g.fontName .. ':h' .. vim.g.fontSize
  end
end

vim.api.nvim_create_autocmd('UIEnter', {
  group = 'loading',
  once = true,
  callback = function()
    local fontTable =
    {
      { os = 'unix',  font = [[HackGen Console NF]], size = 14 },
      { os = 'win32', font = [[HackGen Console NF]], size = 12 }
    }
    for _, f in pairs(fontTable) do
      if vim.fn.has(f.os) == 1 then
        vim.g.fontName = f.font
        vim.g.fontSize = f.size
      end
    end
    FontResize(0)
    if vim.g.GuiLoaded == 1 then
      vim.cmd('GuiWindowOpacity 0.95')
      vim.cmd('GuiScrollBar 1')
    end
    if vim.g.neovide then
      vim.g.neovide_transparency = 0.95
    end
  end
})
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
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set({ 'n', 'v' }, '<C-p>', '"0p')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
vim.keymap.set('n', '+', function() FontResize(1) end)
vim.keymap.set('n', '-', function() FontResize(-1) end)
vim.keymap.set('n', '<leader>g', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>u', vim.lsp.buf.references)
require('winctrl').setup()
require('unrealengine').setup()
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
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
