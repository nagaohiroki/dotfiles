return {
  'equalsraf/neovim-gui-shim',
  'mhinz/vim-signify',
  'junegunn/vim-easy-align',
  {
    'beyondmarc/hlsl.vim',
    config = function()
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' },
        {
          group = 'loading',
          pattern = { '*.usf', '*.ush', '*.cginc', '*.shader', '*.glslinc' },
          callback = function() vim.bo.filetype = 'hlsl' end,
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
  'tpope/vim-rhubarb',
  'junegunn/gv.vim',
  {
    'tpope/vim-fugitive',
    config = function() vim.keymap.set('n', '<leader>d', ':Gvdiffsplit<CR>') end
  },
  { 'tyru/open-browser-github.vim', lazy = true },
  {
    'tyru/open-browser.vim',
    config = function() vim.keymap.set('n', '<leader>o', '<Plug>(openbrowser-smart-search)') end
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    opts = { completions = { lsp = { enabled = true } } }
  },
  { 'j-hui/fidget.nvim',            opts = {} },
  { 'uga-rosa/translate.nvim',      opts = {} },
  { 'nvim-lua/plenary.nvim',        lazy = true },
  { 'echasnovski/mini.nvim',        lazy = true },
  { 'nvim-tree/nvim-web-devicons',  opts = {},  lazy = true },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup(
        {
          styles =
          {
            comments = { italic = false },
            keywords = { italic = false },
            functions = { italic = false },
            variables = { italic = false },
          },
        }
      )
      vim.cmd.colorscheme('tokyonight-night')
    end
  },
  {
    'seblj/roslyn.nvim',
    ft = 'cs',
    config = function()
      local tbl = { 'Start', 'Restart', 'Stop' }
      for _, v in pairs(tbl) do
        vim.api.nvim_create_user_command('Lsp' .. v, function() vim.cmd('Roslyn ' .. string.lower(v)) end, {})
      end
      require('roslyn').setup({ filewatching = 'roslyn', })
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
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
    end
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = { ensure_installed = { 'lua_ls', 'clangd', 'marksman', 'jsonls', 'basedpyright', 'ruff' } }
  },
  {
    'mason-org/mason.nvim',
    opts =
    {
      registries =
      {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry'
      }
    }
  },
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  'rafamadriz/friendly-snippets',
  {
    'hrsh7th/nvim-cmp',
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
          { name = 'render-markdown' },
        }
      })
      vim.keymap.set('i', '<C-s>', function() return [[<Plug>(vsnip-expand)]] or [[<C-s>]] end, { expr = true })
    end
  },
  { 'nvim-telescope/telescope-file-browser.nvim',   lazy = true },
  { 'nvim-telescope/telescope-frecency.nvim',       lazy = true },
  { 'nvim-telescope/telescope-live-grep-args.nvim', lazy = true },
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      local telescope = require('telescope')
      telescope.setup { defaults = { preview = false }, }
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
  { 'nagaohiroki/unity.nvim', opts = {} },
  {
    'mfussenegger/nvim-dap-python',
    config = function()
      local dir = 'bin'
      if vim.fn.has('win32') == 1 then
        dir = 'Scripts'
      end
      require('dap-python').setup(vim.fs.joinpath('.venv', dir, 'python'))
    end
  },
  { 'nvim-neotest/nvim-nio',  lazy = true },
  {
    'rcarriga/nvim-dap-ui',
    config = function()
      local dapui = require('dapui')
      dapui.setup()
      vim.keymap.set('n', '<F6>', dapui.toggle)
    end
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap    = require('dap')
      local widget = require('dap.ui.widgets')
      vim.keymap.set('n', '<F5>', dap.continue)
      vim.keymap.set('n', '<C-F5>', dap.run_last)
      vim.keymap.set('n', '<F10>', dap.step_over)
      vim.keymap.set('n', '<F11>', dap.step_into)
      vim.keymap.set('n', '<S-F11>', dap.step_out)
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
      vim.keymap.set('n', '<C-F9>', function() dap.set_breakpoint(vim.fn.input(''), nil, nil) end)
      vim.keymap.set('n', '<S-C-F9>', dap.clear_breakpoints)
      vim.keymap.set('n', '<F12>', widget.hover)
      vim.keymap.set('n', '<S-F5>', dap.disconnect)
    end
  },
  { 'stevearc/oil.nvim', opts = {}, lazy = false },
  {
    'Exafunction/windsurf.nvim',
    config = function()
      require('codeium').setup({
        enable_cmp_source = false,
        virtual_text =
        {
          enabled = true,
          key_bindings =
          {
            accept = '<C-g>',
            next = '<C-a>',
            prev = '<C-S-a>',
          }
        }
      })
    end
  },
  {
    'ravitemer/mcphub.nvim',
    build = 'npm install -g mcp-hub@latest',
    --  opts = {}
  },
  {
    'olimorris/codecompanion.nvim',
    opts =
    {
      extensions =
      {
        mcphub =
        {
          callback = 'mcphub.extensions.codecompanion',
          opts =
          {
            show_result_in_chat = true,
            make_vars = true,
            make_slash_commands = true,
          }
        }
      }
    }
  },
}
