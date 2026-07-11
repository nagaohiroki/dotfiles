return {
  {
    'mhinz/vim-signify',
    event = { 'BufReadPre', 'BufNewFile' },
    init = function() vim.g.signify_update_on_bufenter = 1 end,
  },
  {
    'kana/vim-altr',
    ft = { 'c', 'cpp' },
    config = function()
      vim.fn['altr#define'](
        'Private/%.cpp', 'Private/*/%.cpp', 'Public/%.h', 'Public/*/%.h', 'Classes/%.h', 'Classes/*/%.h'
      )
    end,
    keys = { { '<leader>a', '<Plug>(altr-forward)' } }
  },
  { 'DingDean/wgsl.vim',     ft = { 'wgsl' } },
  { 'tyru/open-browser.vim', keys = { { '<leader>b', '<Plug>(openbrowser-smart-search)' } } },
  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Gread' },
    keys = { { '<leader>d', '<cmd>Gvdiffsplit<CR>' } }
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
  { 'j-hui/fidget.nvim',           opts = {}, event = 'LspAttach' },
  { 'uga-rosa/translate.nvim',     opts = {}, cmd = { 'Translate' } },
  { 'nvim-tree/nvim-web-devicons', opts = {}, lazy = true },
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
    opts = { ensure_installed = { 'lua_ls', 'clangd', 'marksman', 'taplo', 'rust_analyzer', 'wgsl_analyzer' } },
  },
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog', 'MasonUpdate' },
    opts = { registries = { 'github:mason-org/mason-registry', 'github:Crashdummyy/mason-registry' } }
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      keymap = {
        preset        = 'none',
        ['<C-Space>'] = { 'show', 'fallback' },
        ['<CR>']      = { 'accept', 'fallback' },
        ['<Tab>']     = { 'select_next', 'fallback' },
        ['<S-Tab>']   = { 'select_prev', 'fallback' },
        ['<Down>']    = { 'select_next', 'fallback' },
        ['<Up>']      = { 'select_prev', 'fallback' },
        ['<C-s>']     = { 'show_signature', 'fallback' },
      },
      sources = { default = { 'lsp', 'snippets', 'buffer' }, },
      signature = { enabled = true },
      fuzzy = { implementation = 'lua' },
      completion = {
        documentation = { auto_show = true },
        ghost_text = { enabled = true },
      },
    },
  },
  {
    'folke/snacks.nvim',
    opts = { picker = { layout = { preview = false } } },
    keys = {
      { '<leader>f', function() Snacks.picker.files({ hidden = true }) end, },
      { '<leader>r', function() Snacks.picker.grep_word({ hidden = true }) end, },
      { '<leader>i', function() Snacks.picker.grep({ hidden = true }) end, },
      { '<leader>t', function() Snacks.picker.resume() end, },
      { '<leader>n', function() Snacks.explorer() end, },
      { '<leader>m', function() Snacks.picker.recent({ hidden = true }) end, },
      { '<leader>z', function() Snacks.picker.zoxide() end, },
    },
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
}
