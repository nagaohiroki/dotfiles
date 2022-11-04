-- telescope
require('telescope').setup { defaults = { preview = false } }
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>m', builtin.oldfiles)
vim.keymap.set('n', '<leader>r', builtin.grep_string)
vim.keymap.set('n', '<leader>i', builtin.live_grep)
vim.keymap.set('n', '<leader>t', builtin.resume)
-- lsp
function Vsnip()
	return [[<Plug>(vsnip-expand)]] or [[<C-s>]]
end

vim.keymap.set('n', '<leader>g', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>u', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>l', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<leader>e', vim.lsp.buf.declaration)
vim.keymap.set('i', '<C-s>', Vsnip, { expr = true })
vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format { async = true } end, {})
require("nvim-lsp-installer").setup {}
local lspconfig = require("lspconfig")
lspconfig.omnisharp.setup { use_mono = true }
lspconfig.pyright.setup {}
lspconfig.clangd.setup {}
lspconfig.sumneko_lua.setup { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
lspconfig.vimls.setup {}
lspconfig.jsonls.setup {}
local cmp = require 'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
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
	ensure_installed = "all",
	ignore_install = { "phpdoc", "fortran", "haskell", "rnoweb", "markdown" },
	highlight = { enable = true },
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
		name = "Launch file",
		program = "${file}",
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
		name = "Unity Editor",
		path = "Library/EditorInstance.json",
	},
}
require("dapui").setup()
