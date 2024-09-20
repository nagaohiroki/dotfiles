﻿return {
	{ 'nagaohiroki/vim-perforce' },
	{ 'nagaohiroki/vim-ue4helper' },
	{ 'equalsraf/neovim-gui-shim' },
	{ 'mhinz/vim-signify' },
	{ 'nagaohiroki/vimDTETool' },
	{ 'junegunn/vim-easy-align' },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	{
		'beyondmarc/hlsl.vim',
		config = function()
			vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' },
				{
					group = 'loading',
					pattern = { '*.usf', '*.ush', '*.cginc', '*.shader', '*.glslinc' },
					command = 'setfiletype hlsl'
				})
		end
	},
	{
		'kana/vim-altr',
		config = function()
			vim.keymap.set('n', '<leader>a', '<Plug>(altr-forward)')
			vim.fn['altr#define']('Private/%.cpp', 'Private/*/%.cpp', 'Public/%.h', 'Public/*/%.h', 'Classes/%.h',
				'Classes/*/%.h')
		end
	},
	{
		'tpope/vim-fugitive',
		dependencies = {
			'tpope/vim-rhubarb',
			'junegunn/gv.vim'
		},
		config = function()
			vim.keymap.set('n', '<leader>d', ':Gvdiffsplit<CR>')
		end
	},
	{
		'tyru/open-browser.vim',
		dependencies = {
			'tyru/open-browser-github.vim'
		},
		config = function()
			vim.keymap.set('n', '<leader>o', '<Plug>(openbrowser-smart-search)')
		end
	},
	{
		'voldikss/vim-translator',
		config = function()
			vim.g.translator_target_lang = 'ja'
			vim.g.translator_source_lang = 'en'
			vim.keymap.set({ 'n', 'v' }, '<leader>j', ':TranslateW<CR>')
			vim.keymap.set({ 'n', 'v' }, '<leader>e', ':TranslateW!<CR>')
		end
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require('tokyonight').setup({
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
					functions = { italic = false },
					variables = { italic = false },
				},
			})
			vim.cmd('colorscheme tokyonight-night')
		end
	},
	{
		'seblj/roslyn.nvim',
		ft = 'cs',
		opts = {
			config = {
				on_attach = function(client)
					-- NOTE: Super hacky... Don't know if I like that we set a random variable on the client
					-- Seems to work though
					if client.is_hacked then
						return
					end
					client.is_hacked = true

					-- let the runtime know the server can do semanticTokens/full now
					client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
						semanticTokensProvider = {
							full = true,
						},
					})

					-- monkey patch the request proxy
					local request_inner = client.request
					client.request = function(method, params, handler, req_bufnr)
						if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
							return request_inner(method, params, handler)
						end

						local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
						local line_count = vim.api.nvim_buf_line_count(target_bufnr)
						local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]
						return request_inner("textDocument/semanticTokens/range", {
							textDocument = params.textDocument,
							range = {
								["start"] = {
									line = 0,
									character = 0,
								},
								["end"] = {
									line = line_count - 1,
									character = string.len(last_line) - 1,
								},
							},
						}, handler, req_bufnr)
					end
				end
			}
		},
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'Hoffs/omnisharp-extended-lsp.nvim',
			'Decodetalkers/csharpls-extended-lsp.nvim',
		},
		config = function()
			require('mason').setup(
				{
					registries = {
						"file:" .. vim.env.HOME .. [[/dotfiles/scripts/mason-registry]],
						"github:mason-org/mason-registry",
					}
				})
			require('mason-lspconfig').setup()
			vim.api.nvim_create_user_command('MasonMyInstall', function()
				vim.cmd(
					"MasonInstall lua-language-server omnisharp-mono@v1.39.8 pyright black json-lsp clangd csharp-language-server")
			end, {})
			local lspconfig = require('lspconfig')
			-- lspconfig.csharp_ls.setup({
			-- 	handlers = {
			-- 		['textDocument/definition'] = require('csharpls_extended').handler,
			-- 		['textDocument/typeDefinition'] = require('csharpls_extended').handler,
			-- 	}
			-- })
			-- lspconfig.omnisharp_mono.setup({
			-- 	handlers = { ['textDocument/definition'] = require('omnisharp_extended').handler }
			-- })
			lspconfig.pyright.setup {}
			lspconfig.jsonls.setup {}
			lspconfig.clangd.setup {}
			lspconfig.lua_ls.setup { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
		end
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-vsnip',
			'hrsh7th/vim-vsnip',
			'rafamadriz/friendly-snippets',
		},
		config = function()
			local cmp = require('cmp')
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
			vim.keymap.set('i', '<C-s>', function() return [[<Plug>(vsnip-expand)]] or [[<C-s>]] end, { expr = true })
		end
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'nvim-telescope/telescope-file-browser.nvim',
			'nvim-telescope/telescope-project.nvim',
			'nvim-telescope/telescope-frecency.nvim',
			'nvim-telescope/telescope-live-grep-args.nvim',
		},
		config = function()
			require('nvim-web-devicons').setup()
			local telescope = require('telescope')
			telescope.setup {
				defaults = { preview = false },
			}
			telescope.load_extension('frecency')
			telescope.load_extension('file_browser')
			telescope.load_extension('project')
			telescope.load_extension('live_grep_args')
			local builtin = require('telescope.builtin')
			local ext = telescope.extensions
			vim.keymap.set('n', '<leader>f', function() builtin.find_files({ hidden = true }) end)
			vim.keymap.set('n', '<leader>m', function() builtin.oldfiles({ hidden = true }) end)
			vim.keymap.set('n', '<leader>r', function() builtin.grep_string({ hidden = true }) end)
			vim.keymap.set('n', '<leader>t', function() builtin.resume({ hidden = true }) end)
			vim.keymap.set('n', '<leader>n', function() ext.file_browser.file_browser({ hidden = true }) end)
			vim.keymap.set('n', '<leader>p', function() ext.project.project({ hidden = true }) end)
			vim.keymap.set('n', '<leader>i', function() ext.live_grep_args.live_grep_args({ hidden = true }) end)
			vim.keymap.set('n', '<leader>m', function() ext.frecency.frecency({ hidden = true }) end)
		end
	},
	{
		'Exafunction/codeium.vim',
		config = function()
			vim.keymap.set('i', '<C-q>', function() return vim.fn['codeium#Accept']() end, { expr = true })
			vim.keymap.set('i', '<C-S-q>', function() return vim.fn['codeium#Clear']() end, { expr = true })
			vim.keymap.set('i', '<C-a>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
			vim.keymap.set('i', '<C-S-a>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
			vim.g.codeium_filetypes = { text = false }
		end
	},
	{
		'mhartington/formatter.nvim',
		config = function()
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
		end
	},
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			'rcarriga/nvim-dap-ui',
			'nvim-neotest/nvim-nio',
		},
		config = function()
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
		end
	},
}
