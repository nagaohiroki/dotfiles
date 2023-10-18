function LaunchOnceProcess()
	local my_server = vim.fn.has('win32') == 1 and
		[[\\.\pipe\nvim-server]] or vim.env.HOME .. [[/.local/state/nvim/nvim226]]
	if my_server == vim.v.servername then
		return false
	end
	local result, _ = pcall(vim.fn.serverstart, my_server)
	if result then
		vim.fn.serverstop(vim.v.servername)
		return false
	end
	vim.o.swapfile = false
	vim.o.shada = ''
	vim.o.loadplugins = false
	vim.api.nvim_create_autocmd('VimEnter',
		{
			once = true,
			callback = function()
				local cmd = string.format('"%s" --server "%s" --remote-send "<Esc>:lua EditFile([[%s]],%s,%s)<CR>"',
					vim.v.progpath, my_server, vim.api.nvim_buf_get_name(0), vim.fn.line('.'), vim.fn.col('.'))
				vim.cmd('enew')
				vim.fn.jobstart(cmd, { on_exit = function() vim.cmd('q') end })
			end
		})
	return true
end

if LaunchOnceProcess() then
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

vim.api.nvim_create_user_command('Utf8bomLF',
	function()
		vim.o.fileencoding = 'utf-8'
		vim.o.bomb = true
		vim.o.fileformat = 'unix'
	end, {})

function FontSize(inc)
	vim.g.fontSize = math.max(1, vim.g.fontSize + inc)
	if vim.g.GuiLoaded == 1 then
		vim.cmd('Guifont! ' .. vim.g.fontName .. ':h' .. vim.g.fontSize)
	end
	if vim.g.neovide then
		vim.o.guifont = vim.g.fontName .. ':h' .. vim.g.fontSize
	end
end

function Foreground()
	if vim.g.GuiLoaded == 1 then
		vim.cmd('py3file ' .. vim.env.HOME .. '/dotfiles/scripts/foreground.py')
	end
end

function EditFile(fname, line, col)
	Foreground()
	if vim.fn.filereadable(fname) == 1 then
		vim.cmd('edit ' .. fname)
		vim.fn.cursor(line, col)
	else
		vim.cmd('enew')
	end
end

vim.keymap.set('n', '+', function() FontSize(1) end)
vim.keymap.set('n', '-', function() FontSize(-1) end)
vim.api.nvim_create_augroup('loading', {})
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
		FontSize(0)
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
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' },
	{
		group = 'loading',
		pattern = { '*.usf', '*.ush', '*.cginc', '*.shader', '*.glslinc' },
		command = 'setfiletype hlsl'
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
vim.api.nvim_create_user_command('InitPlugin', function()
	local pickerdir = string.format('"%s/site/pack/packer/start/packer.nvim"', vim.fn.stdpath('data'))
	vim.fn.system('git clone https://github.com/wbthomason/packer.nvim ' .. pickerdir)
	local pyexe = 'python'
	if vim.fn.has('mac') == 1 then
		pyexe = 'python3'
	end
	vim.fn.system(pyexe .. ' -m pip install -r ' .. vim.env.HOME .. '/dotfiles/scripts/requirements.txt')
end, {})
-- plugins
vim.cmd [[silent! packadd packer.nvim]]
local ok, packer = pcall(require, 'packer')
if not ok then
	print('cannot install plugins Please :InitPlugin')
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
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-tree/nvim-web-devicons'
	use 'rafamadriz/friendly-snippets'
	use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui'
	use 'voldikss/vim-translator'
	use 'lambdalisue/fern.vim'
	use 'lambdalisue/fern-git-status.vim'
	use 'lambdalisue/fern-renderer-nerdfont.vim'
	use 'lambdalisue/nerdfont.vim'
	use 'lambdalisue/glyph-palette.vim'
	use 'Exafunction/codeium.vim'
	use 'junegunn/vim-easy-align'
	use 'mhartington/formatter.nvim'
	use 'lewis6991/gitsigns.nvim'
end)
vim.cmd([[silent! colorscheme iceberg]])
-- gitsigns
require('gitsigns').setup()
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
vim.api.nvim_create_user_command('MasonMyInstall', function()
	vim.cmd("MasonInstall lua-language-server omnisharp-mono@v1.39.8 pyright black")
end, {})
require('mason').setup()
require('mason-lspconfig').setup()
local lspconfig = require('lspconfig')
lspconfig.omnisharp_mono.setup {}
lspconfig.pyright.setup {}
lspconfig.lua_ls.setup { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
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
-- dap
local dap = require('dap')
local dapui = require('dapui')
local dapwidget = require('dap.ui.widgets')

function FindPath(path, findPath)
	local newPath = vim.fn.fnamemodify(path, ':h')
	local editorInstance = vim.fn.glob(newPath .. findPath)
	if editorInstance ~= '' then
		return editorInstance
	end
	if path == newPath then
		return nil
	end
	return FindPath(newPath, findPath)
end

vim.keymap.set('n', '<F5>', function()
	dapui.open()
	dap.continue()
end)
vim.keymap.set('n', '<S-F5>', function()
	dapui.close()
	dap.disconnect()
end)
vim.keymap.set('n', '<C-F5>', dap.run_last)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<S-F11>', dap.step_out)
vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
vim.keymap.set('n', '<C-F9>', function() dap.set_breakpoint(vim.fn.input(''), nil, nil) end)
vim.keymap.set('n', '<S-C-F9>', dap.clear_breakpoints)
vim.keymap.set('n', '<F12>', dapwidget.hover)
dap.adapters.python = {
	type = 'executable',
	command = 'python',
	args = { '-m', 'debugpy.adapter' },
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
		path = function() return FindPath(vim.fn.expand('%:p'), '/Library/EditorInstance.json') end,
	},
}
dapui.setup({
	controls = {
		icons = {
			disconnect = "■",
			pause = "",
			play = ">",
			run_last = "↷",
			step_back = "",
			step_into = "→",
			step_out = "←",
			step_over = "↓",
			terminate = ""
		}
	},
})
-- formatter
require('formatter').setup({
	filetype = {
		python = {
			require('formatter.filetypes.python').black
		},
		['*'] = {
			function() vim.lsp.buf.format { async = true } end
		}
	}
})
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
-- Codeium
vim.keymap.set('i', '<C-q>', function() return vim.fn['codeium#Accept']() end, { expr = true })
vim.keymap.set('i', '<C-S-q>', function() return vim.fn['codeium#Clear']() end, { expr = true })
vim.keymap.set('i', '<C-a>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
vim.keymap.set('i', '<C-S-a>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
vim.g.codeium_filetypes = { markdown = false, text = false }
