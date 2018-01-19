scriptencoding utf-8
set encoding=utf8
set fileencodings=ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932,utf-8
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
let g:plug_url_format='https://github.com/%s.git'
filetype plugin indent off
syntax off
call plug#begin('~/vim-plug')
Plug 'junegunn/vim-plug', {'dir': '~/vim-plug/autoload'}
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'tsukkee/unite-tag'
Plug 'tyru/open-browser.vim'
Plug 'vim-syntastic/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'thinca/vim-fontzoom'
Plug 'tpope/vim-fugitive'
Plug 'cohama/agit.vim'
Plug 'airblade/vim-gitgutter'
Plug 'kana/vim-altr'
Plug 'cocopon/iceberg.vim'
Plug 'nagaohiroki/myplugin.vim'
Plug 'nagaohiroki/vim-perforce'
Plug 'godlygeek/tabular'
Plug 'beyondmarc/hlsl.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'sheerun/vim-polyglot'
Plug 'vim-jp/vimdoc-ja'
call plug#end()
filetype plugin indent on
syntax on
set background=dark
colorscheme iceberg
" --------------------------------------------------------------------------
" UtilSnips
" --------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger='<C-s>'
" --------------------------------------------------------------------------
" NERDTree
" --------------------------------------------------------------------------
nnoremap <Leader>n :NERDTreeFind<CR>
let g:NERDTreeShowBookmarks=1
let g:NERDTreeQuitOnOpen=1
" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
nmap <Leader>o <Plug>(openbrowser-smart-search)
" ----------------------------------------------------------------------
" artr for Unreal C++
" ---------------------------------------------------------------------
nmap <Leader>a <Plug>(altr-forward)
call altr#define('Private/%.cpp', 'Public/%.h', 'Classes/%.h')
" --------------------------------------------------------------------------
" syntastic
" --------------------------------------------------------------------------
let g:syntastic_cs_checkers=['syntax', 'semantic', 'issues']
let g:syntastic_python_checkers=['flake8']
let g:syntastic_go_checkers=['go', 'gofmt', 'golint', 'govet']
" -------------------------------------------------------------------------
" youcompleteme
" -------------------------------------------------------------------------
let g:ycm_global_ycm_extra_conf='~/dotfiles/.ycm_extra_conf.py'
nnoremap <Leader>g :YcmCompleter GoToDefinition<CR>
" -------------------------------------------------------------------------
" unite(neomru and unite-tag)
" -------------------------------------------------------------------------
call unite#custom#source('file_mru,file,file_rec', 'ignore_pattern', '\.meta$' )
nnoremap <Leader>f :Unite -start-insert file -path=<C-R>=fnameescape(expand('%:p:h'))<CR><CR>
nnoremap <Leader>m :Unite -start-insert file_mru<CR>
nnoremap <C-]> :execute 'cd ' . expand('%:h') \| UniteWithCursorWord tag<CR>
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
	execute '%!AStyle --options=' . $HOME . '/dotfiles/astylerc'
	call setpos('.',pos)
endfunction
command! Astyle call Astyle()
" ----------------------------------------------------------------------
" Utility Setting(not plugins setting)
" ---------------------------------------------------------------------
autocmd QuickFixCmdPost *grep* cwindow
command! CopyPath call setreg('*', expand('%:p'))
command! DateTime normal i<C-R>=strftime("%Y/%m/%d %H:%M:%S")<CR>
command! Rc tabe ~/dotfiles/.vimrc
command! RcUpdate source ~/dotfiles/.vimrc
command! CdCurrent execute 'cd ' . fnameescape(expand('%:h'))
if has('win32')
	command! Term silent !start cmd /k cd /d "%:p:h"
	command! Wex silent !start explorer /select,"%:p"
	vnoremap <Leader>x y:silent !start "<C-R>0"<CR>
	command! VSOpen execute '!start ' . $HOME . '/dotfiles/vsopen.bat ' . fnameescape(expand('%:p'))
endif
if has('mac')
	command! Term silent !open -a iTerm "%:p:h"
	command! Wex silent !open "%:p:h"
	vnoremap <Leader>x y:silent !open "<C-R>0"<CR>
endif
set noshowmatch
set noswapfile
set nowrap
set nobackup
set autoindent
set autoread
set clipboard=unnamedplus,unnamed
set completeopt=menuone
set pumheight=15
set helplang=ja
set hidden
set hlsearch
set incsearch
set laststatus=2
set list
set listchars=eol:<,tab:>\ ,extends:<
set number
set ttimeout
set ttimeoutlen=100
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
set colorcolumn=80
set tags+=tags;
set statusline=%<%f%m%r%h%w
set statusline+=%y%{'['.&fenc.(&bomb?'_bom':'').']['.&ff.']'}
set statusline+=%=%c,%l/%L
set cmdheight=2
set grepprg=jvgrep
nnoremap <S-Left>  :set columns-=100<CR>
nnoremap <S-Right> :set columns+=100<CR>
nnoremap <S-Up>    :set lines-=10<CR>
nnoremap <S-Down>  :set lines+=10<CR>
nnoremap <C-j> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <Leader>s :%s/\<<C-R><C-W>\>//g<Left><Left>
