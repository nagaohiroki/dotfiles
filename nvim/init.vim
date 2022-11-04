let g:my_servername = has('win32') ? '\\.\pipe\nvim-server' : $HOME . '/.local/state/nvim/nvim0'
if g:my_servername != v:servername
	try
		call serverstart(g:my_servername)
		call serverstop(v:servername)
	catch
		stop
		set noswapfile
		set noloadplugins
		let g:server_mode=1
		if expand('%:p') != ''
			let cmdl = ''
			for i in v:argv
				if matchstr(i, '+\d\+', 0) == i
					let cmdl = printf(' | call cursor(%s, 1)', substitute(i, '+', '', 'g'))
				endif
			endfor
			call system(printf('"%s" --server "%s" --remote-send ":e %s%s<CR>"', v:progpath, g:my_servername, expand('%:p'), cmdl))
			if exists('g:GuiLoaded')
				if has('win32')
					call system($HOME . '/dotfiles/scripts/foreground_win32.exe')
				endif
				if has('mac')
					call system('open -a /opt/homebrew/bin/nvim-qt')
				endif
			endif
		endif
		exit
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
" VS
nnoremap <Leader>b :VSBreakPoint<CR>
nnoremap <Leader>v :VSOpen<CR>
" SignifyDiff
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
lua require('config')
