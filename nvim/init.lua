function LaunchOnceProcess()
	local my_server = vim.fn.has('win32') == 1 and
		[[\\.\pipe\nvim-server]] or vim.env.HOME .. [[/.local/state/nvim/nvim0]]
	if my_server == vim.v.servername then
		return
	end
	local result, _ = pcall(vim.fn.serverstart, my_server)
	if result then
		vim.fn.serverstop(vim.v.servername)
		return
	end
	vim.g.server_mode = 1
	vim.o.swapfile = false
	vim.o.loadplugins = false
	local ecmd = 'enew'
	local fname = vim.api.nvim_buf_get_name(0)
	if fname ~= '' then
		local cursorline = ''
		for _, a in pairs(vim.v.argv) do
			if string.match(a, '+%d+') == a then
				local line, _ = string.gsub(a, '+', '')
				cursorline = string.format('|call cursor(%s, 1)', line)
			end
		end
		ecmd = string.format('e %s%s', fname, cursorline)
	end
	vim.fn.system(string.format('"%s" --server "%s" --remote-send ":silent! %s%s<CR>"',
		vim.v.progpath, my_server, ecmd,
		[[|if exists('g:GuiLoaded')==1|suspend|call GuiForeground()|endif]]))
end

LaunchOnceProcess()
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
vim.keymap.set({ 'n', 'v' }, '<C-p>', '"0p')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
vim.api.nvim_create_user_command('Rc', function() vim.cmd([[e ]] .. vim.env.HOME .. [[/dotfiles/nvim/init.lua]]) end, {})
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

function FontSize(inc)
	if vim.g.GuiLoaded ~= 1 then
		return
	end
	vim.g.fontSize = math.max(1, vim.g.fontSize + inc)
	vim.api.nvim_command('Guifont! ' .. vim.g.fontName .. ':h' .. vim.g.fontSize)
end

vim.keymap.set('n', '+', function() FontSize(1) end)
vim.keymap.set('n', '-', function() FontSize(-1) end)
vim.api.nvim_create_augroup('loading', {})
vim.api.nvim_create_autocmd("UIEnter", {
	group = 'loading',
	once = true,
	callback = function()
		if vim.g.server_mode == 1 then
			vim.cmd.exit()
			return
		end
		if vim.g.GuiLoaded ~= 1 then
			return
		end
		vim.api.nvim_command('GuiWindowOpacity 0.95')
		vim.api.nvim_command('GuiScrollBar 1')
		local fontTable =
		{
			{ os = 'mac', font = [[HackGen Console NFJ]], size = 14 },
			{ os = 'win32', font = [[HackGen Console NFJ]], size = 12 }
		}
		for _, f in pairs(fontTable) do
			if vim.fn.has(f.os) == 1 then
				vim.g.fontName = f.font
				vim.g.fontSize = f.size
			end
		end
		FontSize(0)
	end
})
vim.api.nvim_create_autocmd('QuickFixCmdPost',
	{
		group = 'loading',
		command = 'cwindow'
	})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' },
	{
		group = 'loading',
		pattern = { '*.usf', '*.ush', '*.cginc', '*.shader', '*.glslinc' },
		command = 'setfiletype hlsl'
	})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' },
	{
		group = 'loading',
		pattern = { 'COMMIT_EDITMSG' },
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
vim.api.nvim_create_user_command('PackerInit', function()
	local pickerdir = string.format('"%s/site/pack/packer/start/packer.nvim"', vim.fn.stdpath('data'))
	vim.fn.system('git clone https://github.com/wbthomason/packer.nvim ' .. pickerdir)
end, {})
-- plugins
vim.cmd [[silent! packadd packer.nvim]]
local ok, packer = pcall(require, 'packer')
if not ok then
	print('cannot install plugins Please :PackerInit')
	return
end
packer.startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'beyondmarc/hlsl.vim'
	use 'cohama/agit.vim'
	use 'kana/vim-altr'
	use 'previm/previm'
	use 'mhinz/vim-signify'
	use 'nagaohiroki/myplugin.vim'
	use 'nagaohiroki/vim-perforce'
	use 'nagaohiroki/vim-ue4helper'
	use 'nagaohiroki/vimDTETool'
	use 'tpope/vim-fugitive'
	use 'tyru/open-browser.vim'
	use 'vim-scripts/DoxygenToolkit.vim'
	use 'vim-jp/vimdoc-ja'
	use 'tyru/open-browser-github.vim'
	use 'cocopon/iceberg.vim'
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-tree/nvim-web-devicons'
	use 'rafamadriz/friendly-snippets'
	use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui'
	use 'voldikss/vim-translator'
	use 'j-hui/fidget.nvim'
	use 'lambdalisue/fern.vim'
	use 'lambdalisue/fern-git-status.vim'
	use 'lambdalisue/fern-renderer-nerdfont.vim'
	use 'lambdalisue/nerdfont.vim'
	use 'lambdalisue/glyph-palette.vim'
end)
vim.api.nvim_command [[silent! colorscheme iceberg]]
-- telescope
require('telescope').setup { defaults = { preview = false } }
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>m', builtin.oldfiles)
vim.keymap.set('n', '<leader>r', builtin.grep_string)
vim.keymap.set('n', '<leader>i', builtin.live_grep)
vim.keymap.set('n', '<leader>t', builtin.resume)
-- lsp
vim.keymap.set('n', '<leader>g', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>u', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>l', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<leader>e', vim.lsp.buf.declaration)
vim.keymap.set('i', '<C-s>', function() return [[<Plug>(vsnip-expand)]] or [[<C-s>]] end, { expr = true })
vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format { async = true } end, {})
require('fidget').setup()
require('nvim-lsp-installer').setup {}
local lspconfig = require('lspconfig')
lspconfig.omnisharp.setup { use_mono = true }
lspconfig.pyright.setup {}
lspconfig.clangd.setup {}
lspconfig.powershell_es.setup {}
lspconfig.sumneko_lua.setup { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
local cmp = require 'cmp'
cmp.setup({
	snippet = {
		expand = function(args) vim.fn['vsnip#anonymous'](args.body) end,
	},
	mapping = {
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm(),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<Down>'] = cmp.mapping.select_next_item(),
		['<Up>'] = cmp.mapping.select_prev_item(),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
		{ name = 'buffer' },
		{ name = 'nvim_lsp_signature_help' },
	}
})
-- treesitter
require 'nvim-treesitter.configs'.setup {
	ensure_installed = 'all',
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = { enable = true },
}
-- dap
local dap = require('dap')
local dapui = require('dapui')
function DapClose()
	dapui.close()
	dap.repl.close()
	dap.disconnect()
end

function DapOpen()
	dapui.open()
	dap.repl.open()
	dap.continue()
end

vim.keymap.set('n', '<F5>', DapOpen)
vim.keymap.set('n', '<S-F5>', DapClose)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<S-F11>', dap.step_out)
vim.keymap.set('n', '<S-F9>', dap.toggle_breakpoint)
vim.keymap.set('n', '<S-C-F9>', dap.clear_breakpoints)
dap.adapters.python = {
	type = 'executable';
	command = 'python';
	args = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
	{
		type = 'python',
		request = 'launch',
		name = 'Launch file',
		program = '${file}',
		pythonPath = function() return 'python' end,
	},
}
local unityDebugCommand = vim.env.HOME .. '/.vscode/extensions/deitry.unity-debug-3.0.11/bin/UnityDebug.exe'
local unityDebugArgs = {}
if vim.fn.has('win32') == 0 then
	unityDebugArgs = { unityDebugCommand }
	unityDebugCommand = 'mono'
end
dap.adapters.unity = {
	type = 'executable',
	command = unityDebugCommand,
	args = unityDebugArgs,
	name = 'Unity Editor',
}
dap.configurations.cs = {
	{
		type = 'unity',
		request = 'launch',
		name = 'Unity Editor',
		path = 'Library/EditorInstance.json',
	},
}
require('dapui').setup()
-- Fern
vim.g['fern#default_hidden'] = 1
vim.g['fern#renderer'] = 'nerdfont'
vim.keymap.set('n', '<leader>n', ':Fern %:h -toggle -drawer<CR>')
-- open-browser
vim.keymap.set('n', '<leader>o', '<Plug>(openbrowser-smart-search)')
-- translator
vim.g.translator_target_lang = 'ja'
vim.g.translator_source_lang = 'en'
vim.keymap.set({ 'n', 'v' }, '<leader>j', ':TranslateW<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>e', ':TranslateW!<CR>')
-- artr for Unreal C++
vim.keymap.set('n', '<leader>a', '<Plug>(altr-forward)')
vim.fn['altr#define']('Private/%.cpp', 'Private/*/%.cpp', 'Public/%.h', 'Public/*/%.h', 'Classes/%.h', 'Classes/*/%.h')
-- DoxygenToolkit
vim.g.DoxygenToolkit_blockHeader = '------------------------------------------------------------------------'
vim.g.DoxygenToolkit_blockFooter = vim.g.DoxygenToolkit_blockHeader
vim.g.DoxygenToolkit_commentType = 'C++'
-- SignifyDiff
vim.keymap.set('n', '<leader>d', ':Gvdiffsplit<CR>')
-- VS
vim.keymap.set('n', '<leader>b', ':VSBreakPoint<CR>')
vim.keymap.set('n', '<leader>v', ':VSOpen<CR>')
