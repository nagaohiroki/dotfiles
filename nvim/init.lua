if require('singleton').singleton() then
	return
end

vim.g.mapleader = ' '
vim.o.writebackup = false
vim.o.fixeol = false
vim.o.wrap = false
vim.o.swapfile = false
vim.o.smartindent = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.title = true
vim.o.number = true
vim.o.list = true
vim.o.undofile = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.cmdheight = 2
vim.o.mouse = 'a'
vim.o.listchars = 'eol:<,tab:> ,extends:<'
vim.o.whichwrap = 'b,s,h,l,<,>,[,]'
vim.o.clipboard = 'unnamedplus,unnamed'
vim.o.fileencodings = 'ucs-bom,iso-2022-jp-3,euc-jisx0213,cp932,sjis,euc-jp,utf-8'
vim.o.statusline = '%<%f%m%r%h%w%y[%{&fenc}%{(&bomb?"_bom":"")}][%{&ff}]%=%c,%l/%L'
vim.api.nvim_create_user_command('Errors', function() vim.diagnostic.setqflist() end, {})
vim.api.nvim_create_user_command('Rc', function() vim.cmd('e ' .. vim.env.HOME .. [[/dotfiles/nvim/init.lua]]) end, {})
vim.api.nvim_create_user_command('Plug', function() vim.cmd('e ' .. vim.env.HOME .. [[/dotfiles/nvim/init.lua]]) end, {})
vim.api.nvim_create_user_command('CdCurrent', function() vim.api.nvim_set_current_dir(vim.fn.expand('%:p:h')) end, {})
vim.api.nvim_create_user_command('CopyPath', function() vim.fn.setreg('*', vim.fn.expand('%:p')) end, {})
vim.api.nvim_create_user_command('CopyPathLine',
	function() vim.fn.setreg('*', vim.fn.expand('%:p') .. '#L' .. vim.fn.line('.')) end, {})
vim.api.nvim_create_user_command('Wex',
	function()
		if vim.fn.has('mac') == 1 then
			vim.fn.system('open ' .. vim.fn.expand('%:h'))
		end
		if vim.fn.has('win32') == 1 then
			vim.fn.system('start explorer /select,' .. vim.api.nvim_buf_get_name(0))
		end
	end, {})

vim.api.nvim_create_user_command('Utf8bomLF',
	function()
		vim.o.fileencoding = 'utf-8'
		vim.o.bomb = true
		vim.o.fileformat = 'unix'
	end, {})

vim.api.nvim_create_augroup('loading', {})

function FontResize(inc)
	vim.g.fontSize = math.max(1, vim.g.fontSize + inc)
	if vim.g.GuiLoaded == 1 then
		vim.cmd('Guifont! ' .. vim.g.fontName .. ':h' .. vim.g.fontSize)
	end
	if vim.g.neovide then
		vim.o.guifont = vim.g.fontName .. ':h' .. vim.g.fontSize
	end
end

vim.api.nvim_create_autocmd('UIEnter', {
	group = 'loading',
	once = true,
	callback = function()
		local fontTable =
		{
			{ os = 'unix',  font = [[HackGen Console NFJ]], size = 14 },
			{ os = 'win32', font = [[HackGen Console NFJ]], size = 12 }
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
vim.api.nvim_create_autocmd({ 'FileType' },
	{
		group = 'loading',
		pattern = { 'gitcommit' },
		command = 'set fenc=utf-8'
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
vim.keymap.set({ 'n', 'v' }, '<C-p>', '"0p')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
vim.keymap.set('n', '+', function() FontResize(1) end)
vim.keymap.set('n', '-', function() FontResize(-1) end)
vim.keymap.set('n', '<leader>g', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>u', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>l', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<leader>e', vim.lsp.buf.declaration)
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
require('lazy').setup('plugins')
