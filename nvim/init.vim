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
Plug 'https://github.com/junegunn/fzf'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/pbogut/fzf-mru.vim'
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
Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'https://github.com/nvim-treesitter/nvim-treesitter'
Plug 'https://github.com/williamboman/nvim-lsp-installer'
Plug 'https://github.com/hrsh7th/nvim-cmp'
Plug 'https://github.com/hrsh7th/cmp-nvim-lsp'
Plug 'https://github.com/hrsh7th/cmp-buffer'
Plug 'https://github.com/hrsh7th/cmp-vsnip'
Plug 'https://github.com/hrsh7th/vim-vsnip'
Plug 'https://github.com/rafamadriz/friendly-snippets'
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
" fzf
let g:fzf_layout={'down': '40%'}
let g:fzf_preview_window=''
nnoremap <Leader>f :FZF<CR>
nnoremap <Leader>m :History<CR>
" ue4helper
nnoremap <Leader>p :P4FZF<CR>
nnoremap <Leader>1 :UE4FZFProject<CR>
nnoremap <Leader>2 :UE4FZFEngine<CR>
nnoremap <Leader>l :UE4Dumps<CR>
nnoremap <F9> :VSBreakPoint<CR>
nnoremap <F8> :VSOpen<CR>
" RipGrep
if executable('rg')
	nnoremap <Leader>r :Rg <C-R><C-W><CR>
else
	nnoremap <Leader>r :vim/<C-R><C-W>/**/*.*<CR>
endif
nnoremap <Leader>d :SignifyDiff<CR>
" DoxygenToolkit
let g:DoxygenToolkit_blockHeader=repeat('-', 72)
let g:DoxygenToolkit_blockFooter=g:DoxygenToolkit_blockHeader
let g:DoxygenToolkit_commentType='C++'
" Utility Setting(not plugins setting)
augroup vimrc_loading
	autocmd!
	autocmd QuickFixCmdPost *grep* cwindow
	autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
	autocmd BufRead,BufNewFile *.usf setfiletype hlsl
	autocmd BufRead,BufNewFile *.ush setfiletype hlsl
	autocmd BufRead,BufNewFile *.cginc setfiletype glsl
	autocmd BufRead,BufNewFile *.glslinc setfiletype glsl
augroup END
command! CopyPath call setreg('*', expand('%:p'))
command! CopyPathLine call setreg('*', expand('%:p') . '#L' . line('.'))
command! Rc e ~/dotfiles/nvim/init.vim
command! CdCurrent execute 'cd ' . fnameescape(expand('%:h'))
if has('win32')
	command! Wex silent !start explorer /select,"%:p"
endif
if has('mac')
	command! Wex silent !open "%:p:h"
endif
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
set visualbell t_vb=
set tags+=tags;
set statusline=%<%f%m%r%h%w
set statusline+=%y%{'['.&fenc.(&bomb?'_bom':'').']['.&ff.']'}
set statusline+=%=%c,%l/%L
set cmdheight=2
set ambiwidth=double
set completeopt=menu,menuone,noselect,noinsert
nnoremap <Leader>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <C-p> "0p
vnoremap <C-p> "0p
inoremap <F3> <C-R>=strftime("%F %T")<CR>
lua << EOF
  require("nvim-lsp-installer").on_server_ready(function(server) server:setup({}) end)
  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer' },
    }
  })
  require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
}
EOF
nnoremap <silent> <Leader>g <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <Leader>h <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <Leader>u <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <Leader>d <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <Leader>e <cmd>lua vim.lsp.buf.declaration()<CR>
redir! > $HOME/.cache_neovim/env.txt | echon $NVIM_LISTEN_ADDRESS | redir END
