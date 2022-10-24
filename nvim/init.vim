let g:my_servername = $HOME . '/.local/state/nvim/nvim0'
if has('win32')
	let g:my_servername = '\\.\pipe\nvim-server'
endif
if g:my_servername != v:servername
	try
		call serverstart(g:my_servername)
		call serverstop(v:servername)
	catch
		set noswapfile
		let g:server_mode=1
		if expand('%:p') != ''
			function! LaunchSingleton()
				call system(printf('"%s" --server "%s" --remote-send ":e %s | call cursor(%d, %d)<CR>"', v:progpath, g:my_servername, expand('%:p'), line('.'), col('.')))
				if has('win32')
					call system($HOME . '/dotfiles/scripts/foreground_win32.exe')
				endif
				if has('mac')
					call system('open -a /opt/homebrew/bin/nvim-qt')
				endif
				if !exists('g:GuiLoaded')
					exit
				endif
			endfunction
			autocmd VimEnter * call LaunchSingleton()
		else
			if !exists('g:GuiLoaded')
				exit
			endif
		endif
		finish
	endtry
endif
set fileencodings=ucs-bom,iso-2022-jp-3,euc-jisx0213,cp932,sjis,euc-jp,utf-8
let mapleader="\<Space>"
function! InstallVimPlug(plug_dir)
	call mkdir(a:plug_dir, 'p')
	call system('git clone https://github.com/junegunn/vim-plug.git ' . a:plug_dir . '/autoload')
endfunction
command! InstallVimPlug call InstallVimPlug(expand('~/neovim-plug'))
if has('vim_starting')
	set runtimepath^=~/neovim-plug
endif
filetype plugin indent off
syntax off
call plug#begin('~/neovim-plug')
Plug 'https://github.com/junegunn/vim-plug', {'dir': '~/neovim-plug/autoload'}
Plug 'https://github.com/beyondmarc/hlsl.vim'
Plug 'https://github.com/cohama/agit.vim'
Plug 'https://github.com/kana/vim-altr'
Plug 'https://github.com/previm/previm'
Plug 'https://github.com/mhinz/vim-signify'
Plug 'https://github.com/nagaohiroki/myplugin.vim'
Plug 'https://github.com/nagaohiroki/vim-perforce'
Plug 'https://github.com/nagaohiroki/vim-ue4helper'
Plug 'https://github.com/nagaohiroki/vimDTETool'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/tyru/open-browser.vim'
Plug 'https://github.com/vim-jp/vimdoc-ja'
Plug 'https://github.com/vim-scripts/DoxygenToolkit.vim'
Plug 'https://github.com/tyru/open-browser-github.vim'
Plug 'https://github.com/voldikss/vim-translator'
Plug 'https://github.com/cocopon/iceberg.vim'
Plug 'https://github.com/nvim-treesitter/nvim-treesitter'
Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'https://github.com/williamboman/nvim-lsp-installer'
Plug 'https://github.com/hrsh7th/nvim-cmp'
Plug 'https://github.com/hrsh7th/cmp-nvim-lsp'
Plug 'https://github.com/hrsh7th/cmp-buffer'
Plug 'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'https://github.com/hrsh7th/cmp-vsnip'
Plug 'https://github.com/hrsh7th/vim-vsnip'
Plug 'https://github.com/nvim-lua/plenary.nvim'
Plug 'https://github.com/nvim-telescope/telescope.nvim'
Plug 'https://github.com/rafamadriz/friendly-snippets'
Plug 'https://github.com/mfussenegger/nvim-dap'
Plug 'https://github.com/rcarriga/nvim-dap-ui'
call plug#end()
filetype plugin indent on
syntax on
set background=dark
colorscheme iceberg
" translator
let g:translator_target_lang='ja'
let g:translator_source_lang='en'
nnoremap <silent> <Leader>j :TranslateW<CR>
vnoremap <silent> <Leader>j :TranslateW<CR>
nnoremap <silent> <Leader>e :TranslateW!<CR>
vnoremap <silent> <Leader>e :TranslateW!<CR>
" NERDTree
nnoremap <Leader>n :NERDTree<CR>
let g:NERDTreeShowHidden=1
" open-browser
nmap <Leader>o <Plug>(openbrowser-smart-search)
" artr for Unreal C++
nmap <Leader>a <Plug>(altr-forward)
call altr#define('Private/%.cpp', 'Private/*/%.cpp', 'Public/%.h', 'Public/*/%.h', 'Classes/%.h', 'Classes/*/%.h')
" Telescope
nnoremap <Leader>f :Telescope find_files<CR>
nnoremap <Leader>m :Telescope oldfiles<CR>
nnoremap <Leader>r :Telescope grep_string<CR>
nnoremap <Leader>i :Telescope live_grep<CR>
nnoremap <Leader>t :Telescope resume<CR>
" VS
nnoremap <Leader>b :VSBreakPoint<CR>
nnoremap <Leader>v :VSOpen<CR>
" SignifyDiff
nnoremap <Leader>d :SignifyDiff<CR>
" DoxygenToolkit
let g:DoxygenToolkit_blockHeader=repeat('-', 72)
let g:DoxygenToolkit_blockFooter=g:DoxygenToolkit_blockHeader
let g:DoxygenToolkit_commentType='C++'
" lsp
nnoremap <silent> <Leader>g <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <Leader>h <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <Leader>u <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <Leader>l <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <Leader>e <cmd>lua vim.lsp.buf.declaration()<CR>
imap <expr> <C-s>   vsnip#expandable()  ? '<Plug>(vsnip-expand)' : '<C-s>'
command! Format lua vim.lsp.buf.format{async=true}
command! Fmt lua vim.lsp.buf.formatting()
" dap
function! DepWin(isOpen)
	if a:isOpen == 0
		lua require'dapui'.close()
		lua require'dap'.repl.close()
		lua require'dap'.disconnect()
	else
		lua require'dap'.continue()
		lua require'dap'.repl.open()
		lua require'dapui'.open()
	endif
endfunction
nnoremap <silent> <F5>     :call DepWin(1)<CR>
nnoremap <silent> <S-F5>   :call DepWin(0)<CR>
nnoremap <silent> <S-C-F5> :lua require'dap'.run_last()<CR>
nnoremap <silent> <F10>    :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11>    :lua require'dap'.step_into()<CR>
nnoremap <silent> <S-F11>  :lua require'dap'.step_out()<CR>
nnoremap <silent> <F9>     :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <S-C-F9> :lua require'dap'.clear_breakpoints()<CR>
" Utility Setting(not plugins setting)
augroup vimrc_loading
	autocmd!
	autocmd QuickFixCmdPost *grep* cwindow
	autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
	autocmd BufRead,BufNewFile *.usf setfiletype hlsl
	autocmd BufRead,BufNewFile *.ush setfiletype hlsl
	autocmd BufRead,BufNewFile *.cginc setfiletype hlsl
	autocmd BufRead,BufNewFile *.shader setfiletype hlsl
	autocmd BufRead,BufNewFile *.glslinc setfiletype hlsl
augroup END
command! CopyPath call setreg('*', expand('%:p'))
command! CopyPathLine call setreg('*', expand('%:p') . '#L' . line('.'))
command! Rc e ~/dotfiles/nvim/init.vim
command! CdCurrent execute 'cd ' . fnameescape(expand('%:h'))
command! Date put=strftime('%F %T')
if has('win32')
	command! Wex silent !start explorer /select,"%:p"
endif
if has('mac')
	command! Wex silent !open "%:p:h"
endif
nnoremap <Leader>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <C-p> "0p
vnoremap <C-p> "0p
set noshowmatch
set noswapfile
set nowrap
set nobackup
set nowritebackup
set nofixeol
set noexpandtab
set autoindent
set autoread
set backspace=indent,eol,start
set clipboard=unnamedplus,unnamed
set helplang=ja
set hidden
set hlsearch
set incsearch
set laststatus=2
set list
set listchars=eol:<,tab:>\ ,extends:<
set number
set nrformats=hex
set shiftwidth=4
set showcmd
set smartindent
set smartcase
set ignorecase
set tabstop=4
set title
set undodir=$HOME/.cache_neovim
set undofile
set whichwrap=b,s,h,l,<,>,[,]
set mouse=a
set tags+=tags;
set statusline=%<%f%m%r%h%w
set statusline+=%y%{'['.&fenc.(&bomb?'_bom':'').']['.&ff.']'}
set statusline+=%=%c,%l/%L
set cmdheight=2
set completeopt=menu,menuone,noselect,noinsert
lua << EOF
  require('telescope').setup
  {
    defaults = {preview = false}
  }
  local lspinstaller = require("nvim-lsp-installer")
  lspinstaller.setup{}
  local lspconfig = require("lspconfig")
  lspconfig.omnisharp.setup{use_mono = true}
  lspconfig.pyright.setup{}
  lspconfig.clangd.setup{}
  local cmp = require'cmp'
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
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    ignore_install = {"phpdoc", "fortran", "haskell", "rnoweb"},
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
  dap.adapters.unity = {
    type = 'executable';
    command = vim.env.HOME .. '/.vscode/extensions/deitry.unity-debug-3.0.11/bin/UnityDebug.exe';
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
EOF
