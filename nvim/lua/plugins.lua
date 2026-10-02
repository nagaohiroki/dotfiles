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
  { 'DingDean/wgsl.vim',           ft = { 'wgsl' } },
  {
    'tyru/open-browser.vim',
    cmd = { 'OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch' },
    keys = { { '<leader>b', '<Plug>(openbrowser-smart-search)' } }
  },
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
    'stevearc/oil.nvim',
    opts = { view_options = { show_hidden = true } },
    cmd = { 'Oil' },
    keys = { { '<leader>o', '<cmd>Oil<CR>' } }
  },
  { 'j-hui/fidget.nvim',           opts = {},      event = 'LspAttach' },
  { 'uga-rosa/translate.nvim',     opts = {},      cmd = { 'Translate' } },
  { 'nvim-tree/nvim-web-devicons', opts = {},      lazy = true },
  { 'seblyng/roslyn.nvim',         ft = { 'cs' } },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    event = 'UIEnter',
    config = function()
      require('tokyonight').setup({ styles = { comments = { italic = false }, keywords = { italic = false } } })
      vim.cmd.colorscheme('tokyonight-night')
    end
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig' },
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
      { '<leader>m', function() Snacks.picker.recent({ hidden = true }) end, },
      { '<leader>n', function() Snacks.picker.explorer({ hidden = true }) end, },
      { '<leader>z', function() Snacks.picker.zoxide() end, },
    },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'rcarriga/nvim-dap-ui', opts = {} },
      'nvim-neotest/nvim-nio'
    },
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
  { 'nagaohiroki/unity.nvim', ft = { 'cs' }, opts = {} },
  {
    'JaneySprings/DotRush',
    ft = { 'cs' },
    dependencies = { 'mfussenegger/nvim-dap' },
    build = 'dotnet publish src/DotRush.Debugging.Mono -c Release',
    config = function(plugin)
      local dap = require('dap')
      dap.adapters.monodbg = {
        type = 'executable',
        command = 'dotnet',
        args = { vim.fs.joinpath(plugin.dir, 'extension', 'bin', 'DebuggerMono', 'monodbg.dll') },
        name = 'Unity Debugger',
      }
      local function dap_config_editor()
        local editor_instance_path = vim.fs.joinpath('Library', 'EditorInstance.json')
        local editor_instance = vim.fn.findfile(editor_instance_path, '.;')
        if type(editor_instance) ~= 'string' or editor_instance == '' then return {} end
        local file = io.open(editor_instance, 'r')
        if file == nil then
          vim.print('cannot open ' .. editor_instance)
          return {}
        end
        local json = file:read('a')
        local obj = vim.json.decode(json)
        file:close()
        local project_path = vim.fs.dirname(vim.fs.dirname(editor_instance))
        return {
          type = 'monodbg',
          request = 'attach',
          name = vim.fs.basename(project_path) .. ' pid:' .. obj.process_id,
          debugPort = 56000 + (obj.process_id % 1000),
          cwd = project_path
        }
      end
      dap.providers.configs.cs = function(bufnr)
        if vim.bo[bufnr].filetype ~= 'cs' then return {} end
        return { dap_config_editor() }
      end
    end
  }
}
