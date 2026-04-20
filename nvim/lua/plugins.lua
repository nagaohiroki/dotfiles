return {
  { 'equalsraf/neovim-gui-shim' },
  {
    'mhinz/vim-signify',
    event = { 'BufReadPre', 'BufNewFile' },
    init = function() vim.g.signify_update_on_bufenter = 1 end,
  },
  {
    'kana/vim-altr',
    config = function()
      vim.fn['altr#define']('Private/%.cpp', 'Private/*/%.cpp', 'Public/%.h', 'Public/*/%.h', 'Classes/%.h',
        'Classes/*/%.h')
    end,
    keys = { { '<leader>a', '<Plug>(altr-forward)' } }
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Gread' },
    keys = { { '<leader>d', '<cmd>Gvdiffsplit<CR>' } }
  },
  {
    'tyru/open-browser-github.vim',
    cmd = { 'OpenGithubCommit', 'OpenGithubFile', 'OpenGithubProject', 'OpenGithubPullReq', 'OpenGithubPullIssue' }
  },
  {
    'tyru/open-browser.vim',
    keys = { { '<leader>b', '<Plug>(openbrowser-smart-search)' } }
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
  { 'j-hui/fidget.nvim',           opts = {},  event = 'LspAttach' },
  { 'uga-rosa/translate.nvim',     opts = {},  cmd = { 'Translate' } },
  { 'nvim-lua/plenary.nvim',       lazy = true },
  { 'nvim-tree/nvim-web-devicons', opts = {},  lazy = true },
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
  { 'seblyng/roslyn.nvim',  ft = { 'cs' } },
  { 'neovim/nvim-lspconfig' },
  {
    'mason-org/mason-lspconfig.nvim',
    event = 'VeryLazy',
    opts = { ensure_installed = { 'lua_ls', 'clangd', 'marksman', 'taplo' } }
  },
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog', 'MasonUpdate' },
    opts =
    {
      registries =
      {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry'
      }
    }
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
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
        mapping =
            cmp.mapping.preset.insert({
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm(),
              ['<Tab>'] = cmp.mapping.select_next_item(),
              ['<S-Tab>'] = cmp.mapping.select_prev_item(),
              ['<Down>'] = cmp.mapping.select_next_item(),
              ['<Up>'] = cmp.mapping.select_prev_item(),
            }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'buffer' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'render-markdown' },
        }
      })
    end,
    keys = { { '<C-s>', function() return '<Plug>(vsnip-expand)' end, mode = 'i', expr = true } }
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-frecency.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
      'jvgrootveld/telescope-zoxide'
    },
    opts = { defaults = { preview = false } },
    keys =
    {
      { '<leader>f', function() require('telescope.builtin').find_files({ hidden = true }) end },
      { '<leader>r', function() require('telescope.builtin').grep_string({ hidden = true }) end },
      { '<leader>t', function() require('telescope.builtin').resume({ hidden = true }) end },
      {
        '<leader>n',
        function()
          require('telescope').load_extension('file_browser')
          require('telescope').extensions.file_browser.file_browser({ hidden = true })
        end },
      {
        '<leader>i',
        function()
          require('telescope').load_extension('live_grep_args')
          require('telescope').extensions.live_grep_args.live_grep_args({ hidden = true })
        end
      },
      {
        '<leader>m',
        function()
          require('telescope').load_extension('frecency')
          require('telescope').extensions.frecency.frecency({ hidden = true })
        end
      },
      {
        '<leader>z',
        function()
          local telescope = require('telescope')
          telescope.load_extension('zoxide')
          telescope.extensions.zoxide.list()
        end
      }
    }
  },
  { 'nagaohiroki/unity.nvim', ft = { 'cs' }, opts = {} },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
    },
    config = function() require('dapui').setup() end,
    keys = {
      { '<F5>',     function() require('dap').continue() end },
      { '<C-F5>',   function() require('dap').run_last() end },
      { '<F10>',    function() require('dap').step_over() end },
      { '<F11>',    function() require('dap').step_into() end },
      { '<S-F11>',  function() require('dap').step_out() end },
      { '<F9>',     function() require('dap').toggle_breakpoint() end },
      { '<C-F9>',   function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end },
      { '<S-C-F9>', function() require('dap').clear_breakpoints() end },
      { '<S-F5>',   function() require('dap').disconnect() end },
      { '<F12>',    function() require('dap.ui.widgets').hover() end },
      { '<F6>',     function() require('dapui').toggle() end },
    },
  },
  {
    'stevearc/oil.nvim',
    opts = { view_options = { show_hidden = true } },
    cmd = { 'Oil' },
    keys = { { '<leader>o', '<cmd>Oil<CR>' } }
  },
  -- {
  --   'supermaven-inc/supermaven-nvim',
  --   opts = {
  --     ignore_filetypes = { 'markdown', 'text' },
  --     keymaps = { accept_suggestion = '<C-g>', }
  --   },
  -- },
}
