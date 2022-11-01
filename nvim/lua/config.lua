require('telescope').setup
{
	defaults = { preview = false }
}

require("nvim-lsp-installer").setup {}
local lspconfig = require("lspconfig")
lspconfig.omnisharp.setup { use_mono = true }
lspconfig.pyright.setup {}
lspconfig.clangd.setup {}
lspconfig.sumneko_lua.setup {}
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
require 'nvim-treesitter.configs'.setup {
	ensure_installed = "all",
	ignore_install = { "phpdoc", "fortran", "haskell", "rnoweb", "markdown" },
	highlight = {
		enable = true,
	},
}
local dap = require('dap')
dap.adapters.python = {
	type = 'executable';
	command = 'python';
	args = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
	{
		type = 'python';
		request = 'launch';
		name = "Launch file";
		program = "${file}";
		pythonPath = function()
			return 'python'
		end;
	},
}
local unityDebugCommand = vim.env.HOME .. '/.vscode/extensions/deitry.unity-debug-3.0.11/bin/UnityDebug.exe'
local unityDebugArgs = {}
if vim.fn.has('win32') == 0 then
	unityDebugArgs = { unityDebugCommand }
	unityDebugCommand = 'mono'
end
dap.adapters.unity = {
	type = 'executable';
	command = unityDebugCommand;
	args = unityDebugArgs;
	name = 'Unity Editor';
}
dap.configurations.cs = {
	{
		type = 'unity';
		request = 'launch';
		name = "Unity Editor";
		path = "Library/EditorInstance.json";
	},
}
require("dapui").setup()
