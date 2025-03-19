return {
  { 'nagaohiroki/vim-perforce' },
  { 'nagaohiroki/vim-ue4helper' },
  { 'nagaohiroki/vimDTETool' },
  { 'equalsraf/neovim-gui-shim' },
  { 'mhinz/vim-signify' },
  { 'junegunn/vim-easy-align' },
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
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'echasnovski/mini.nvim' },
    opts = {},
    ft = { 'markdown' },
  },
  {
    'j-hui/fidget.nvim',
    opts = {}
  },
  {
    'uga-rosa/translate.nvim',
    opts = {}
  },
  {
    'nagaohiroki/unity.nvim',
    opts = {}
  },
  {
    'folke/tokyonight.nvim',
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
          if client.is_hacked then
            return
          end
          client.is_hacked = true
          client.server_capabilities = vim.tbl_deep_extend('force', client.server_capabilities, {
            semanticTokensProvider = {
              full = true,
            },
          })
          local request_inner = client.request
          client.request = function(method, params, handler, req_bufnr)
            if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
              return request_inner(method, params, handler)
            end
            local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
            local line_count = vim.api.nvim_buf_line_count(target_bufnr)
            local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]
            return request_inner('textDocument/semanticTokens/range', {
              textDocument = params.textDocument,
              range = {
                ['start'] = {
                  line = 0,
                  character = 0,
                },
                ['end'] = {
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
    },
    config = function()
      require('mason').setup({
        registries = {
          'github:mason-org/mason-registry',
          'github:Crashdummyy/mason-registry'
        }
      })
      local mason_lspconfig = require('mason-lspconfig')
      local lspconfig = require('lspconfig')
      mason_lspconfig.setup({ ensure_installed = { 'lua_ls', 'pyright', 'clangd', 'marksman', 'jsonls' } })
      mason_lspconfig.setup_handlers({
        function(server_name)
          local opts = {}
          if server_name == 'lua_ls' then
            opts = { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
          end
          lspconfig[server_name].setup(opts)
        end
      })
    end
  },
  {
    'nvimtools/none-ls.nvim',
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
        }
      })
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
      telescope.load_extension('live_grep_args')
      local builtin = require('telescope.builtin')
      local ext = telescope.extensions
      vim.keymap.set('n', '<leader>f', function() builtin.find_files({ hidden = true }) end)
      vim.keymap.set('n', '<leader>r', function() builtin.grep_string({ hidden = true }) end)
      vim.keymap.set('n', '<leader>t', function() builtin.resume({ hidden = true }) end)
      vim.keymap.set('n', '<leader>n', function() ext.file_browser.file_browser({ hidden = true }) end)
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
      vim.g.codeium_filetypes = { text = false, markdown = false }
    end
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'nagaohiroki/unity.nvim',
    },
    config = function()
      local dap = require('dap')
      local widget = require('dap.ui.widgets')
      local dapui = require('dapui')
      dapui.setup()
      require('unity').setup_vstuc()
      dap.adapters.python       = {
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
      vim.api.nvim_create_user_command('DapUIFrame', function() widget.sidebar(widget.frames).open() end, {})
      vim.api.nvim_create_user_command('DapUIScope', function() widget.sidebar(widget.scopes).open() end, {})
      vim.api.nvim_create_user_command('DapUIScope', function() widget.sidebar(widget.scopes).open() end, {})
      vim.keymap.set('n', '<C-F5>', dap.run_last)
      vim.keymap.set('n', '<F10>', dap.step_over)
      vim.keymap.set('n', '<F11>', dap.step_into)
      vim.keymap.set('n', '<S-F11>', dap.step_out)
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
      vim.keymap.set('n', '<C-F9>', function() dap.set_breakpoint(vim.fn.input(''), nil, nil) end)
      vim.keymap.set('n', '<S-C-F9>', dap.clear_breakpoints)
      vim.keymap.set('n', '<F12>', widget.hover)
      vim.keymap.set('n', '<F6>', dapui.toggle)
      vim.keymap.set('n', '<S-F5>', function()
        dap.disconnect()
        dapui.close()
      end)
      vim.keymap.set('n', '<F5>', function()
        if dap.session() == nil then dapui.open() end
        dap.continue()
      end)
    end
  },
}
