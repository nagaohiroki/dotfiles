scriptencoding utf-8
set encoding=utf8
set fileencodings=ucs-bom,iso-2022-jp-3,euc-jisx0213,cp932,sjis,euc-jp,utf-8
let mapleader="\<Space>"
" -------------------------------------------------------------------------
" vim-plug
" -------------------------------------------------------------------------
function! InstallVimPlug(plug_dir)
	call mkdir(a:plug_dir, 'p')
	call system('git clone https://github.com/junegunn/vim-plug.git ' . a:plug_dir . '/autoload')
endfunction
command! InstallVimPlug call InstallVimPlug(expand('~/vim-plug'))
if has('vim_starting')
	set runtimepath^=~/vim-plug
endif
filetype plugin indent off
syntax off
call plug#begin('~/vim-plug')
Plug 'https://github.com/junegunn/vim-plug', {'dir': '~/vim-plug/autoload'}
Plug 'https://github.com/junegunn/fzf'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/SirVer/ultisnips'
Plug 'https://github.com/beyondmarc/hlsl.vim'
Plug 'https://github.com/cohama/agit.vim'
Plug 'https://github.com/honza/vim-snippets'
Plug 'https://github.com/kana/vim-altr'
Plug 'https://github.com/previm/previm'
Plug 'https://github.com/majutsushi/tagbar'
Plug 'https://github.com/mhinz/vim-signify'
Plug 'https://github.com/nagaohiroki/myplugin.vim'
Plug 'https://github.com/nagaohiroki/vim-perforce'
Plug 'https://github.com/nagaohiroki/vim-ue4helper'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/sheerun/vim-polyglot'
Plug 'https://github.com/thinca/vim-fontzoom'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/tyru/open-browser.vim'
Plug 'https://github.com/vim-jp/vimdoc-ja'
Plug 'https://github.com/vim-scripts/DoxygenToolkit.vim'
Plug 'https://github.com/vim-scripts/ShaderHighLight'
Plug 'https://github.com/flazz/vim-colorschemes'
Plug 'https://github.com/tyru/open-browser-github.vim'
Plug 'https://github.com/haya14busa/vim-open-googletranslate'
Plug 'https://github.com/jremmen/vim-ripgrep'
Plug 'https://github.com/ycm-core/YouCompleteMe'
Plug 'https://github.com/vim-syntastic/syntastic'
call plug#end()
filetype plugin indent on
syntax on
set background=dark
colorscheme iceberg
" --------------------------------------------------------------------------
" tagbar
" --------------------------------------------------------------------------
let g:tagbar_sort=0
nnoremap <Leader>t :TagbarToggle<CR>
" --------------------------------------------------------------------------
" UtilSnips
" --------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger='<C-s>'
" --------------------------------------------------------------------------
" NERDTree
" --------------------------------------------------------------------------
nnoremap <Leader>n :NERDTree<CR>
let g:NERDTreeShowHidden=1
" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
nmap <Leader>o <Plug>(openbrowser-smart-search)
" ----------------------------------------------------------------------
" artr for Unreal C++
" ---------------------------------------------------------------------
nmap <Leader>a <Plug>(altr-forward)
call altr#define('Private/%.cpp', 'Private/*/%.cpp', 'Public/%.h', 'Public/*/%.h', 'Classes/%.h', 'Classes/*/%.h')
" --------------------------------------------------------------------------
" syntastic
" --------------------------------------------------------------------------
let g:syntastic_python_checkers=['flake8']
let g:syntastic_go_checkers=['go', 'gofmt', 'golint', 'govet']
command! CppCheck SyntasticCheck cppcheck | Errors
" -------------------------------------------------------------------------
" youcompleteme
" -------------------------------------------------------------------------
nnoremap <Leader>g :YcmCompleter GoToDefinition<CR>
let g:ycm_auto_hover=''
" -------------------------------------------------------------------------
" fzf
" -------------------------------------------------------------------------
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>c :execute 'Files ' . expand('%:p:h')<CR>
nnoremap <Leader>m :History<CR>
nnoremap <Leader>p :P4FZF<CR>
nnoremap <Leader>1 :UE4FZFProject<CR>
nnoremap <Leader>2 :UE4FZFEngine<CR>
nnoremap <Leader>v :UE4VSOpen<CR>
let g:fzf_preview_window=''
" -------------------------------------------------------------------------
" RipGrep
" -------------------------------------------------------------------------
nnoremap <Leader>r :Rg <C-R><C-W><CR>
nnoremap <Leader>d :SignifyDiff<CR>
" --------------------------------------------------------------------------
" DoxygenToolkit
" --------------------------------------------------------------------------
let g:DoxygenToolkit_blockHeader=repeat('-', 72)
let g:DoxygenToolkit_blockFooter=g:DoxygenToolkit_blockHeader
let g:DoxygenToolkit_commentType='C++'
" ----------------------------------------------------------------------
" Astyle
" ---------------------------------------------------------------------
function! Astyle()
	let l:pos = getpos('.')
	execute '%!AStyle --options=' . $HOME . '/dotfiles/scripts/astylerc'
	call setpos('.',pos)
endfunction
command! Astyle call Astyle()
" ----------------------------------------------------------------------
" Utility Setting(not plugins setting)
" ---------------------------------------------------------------------
augroup vimrc_loading
	autocmd!
	autocmd QuickFixCmdPost *grep* cwindow
	autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
	autocmd BufRead,BufNewFile *.usf setfiletype hlsl
	autocmd BufRead,BufNewFile *.ush setfiletype hlsl
augroup END
command! CopyPath call setreg('*', expand('%:p'))
command! CopyPathLine call setreg('*', expand('%:p') . '#L' . line('.'))
command! DateTime normal i<C-R>=strftime("%Y/%m/%d %H:%M:%S")<CR>
command! Rc e ~/dotfiles/.vimrc
command! RcUpdate source ~/dotfiles/.vimrc
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
set nofixeol 
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
set undodir=$HOME/.cache
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
set noimdisable
set completeopt=menu,menuone,noselect,noinsert
set viminfo='1000
nnoremap <Leader>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <C-j> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
nnoremap <C-p> "0p
vnoremap <C-p> "0p
