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
    config = function()
      vim.api.nvim_create_user_command('LspRestart', function() vim.cmd('Roslyn restart') end, {})
      require('roslyn').setup({ filewatching = 'roslyn', })
    end
  },
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
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
      mason_lspconfig.setup_handlers({ function(server_name) lspconfig[server_name].setup({}) end })
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
    'Exafunction/windsurf.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp'
    },
    config = function()
      require('codeium').setup(
        {
          enable_cmp_source = false,
          virtual_text =
          {
            enabled = true,
            key_bindings =
            {
              accept = '<C-q>',
              next = '<C-a>',
              prev = '<C-S-a>',
            }
          },
        })
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
      require('unity').setup()
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
      vim.api.nvim_create_user_command('DapUIFrame', widget.sidebar(widget.frames).open, {})
      vim.api.nvim_create_user_command('DapUIScope', widget.sidebar(widget.scopes).open, {})
      vim.keymap.set('n', '<C-F5>', dap.run_last)
      vim.keymap.set('n', '<F10>', dap.step_over)
      vim.keymap.set('n', '<F11>', dap.step_into)
      vim.keymap.set('n', '<S-F11>', dap.step_out)
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
      vim.keymap.set('n', '<C-F9>', function() dap.set_breakpoint(vim.fn.input(''), nil, nil) end)
      vim.keymap.set('n', '<S-C-F9>', dap.clear_breakpoints)
      vim.keymap.set('n', '<F12>', widget.hover)
      vim.keymap.set('n', '<F6>', dapui.toggle)
      vim.keymap.set('n', '<S-F5>', dap.disconnect)
      vim.keymap.set('n', '<F5>', dap.continue)
    end
  },
  {
    'David-Kunz/gen.nvim',
    config = function()
      local ollama = nil
      require('gen').setup({
        model = 'gemma3',
        init = function(_)
          ollama = vim.system({ 'ollama', 'serve' }, {text = true, stdin = true})
        end,
        prompts = require('prompts')
      })
      local function kill_ollama()
        if ollama == nil then
          return
        end
        vim.system({ 'taskkill', '/f', '/im', 'ollama.exe' }):wait()
      end
      vim.api.nvim_create_user_command('OllamaKill', kill_ollama, {})
      vim.api.nvim_create_autocmd({ 'VimLeavePre' },
        {
          group = 'loading',
          callback = kill_ollama
        })
    end
  }
}
