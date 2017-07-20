scriptencoding utf-8
set encoding=utf8
set fileencodings=ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932,utf-8
" -------------------------------------------------------------------------
" AutoCommandGroup
" -------------------------------------------------------------------------
augroup MyAutoCmd
	autocmd!
augroup END
filetype off
let mapleader="\<Space>"
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
" -------------------------------------------------------------------------
" Plugins
" -------------------------------------------------------------------------
function! InstallVimPlug(plug_dir)
	if !isdirectory(a:plug_dir)
		call mkdir(a:plug_dir, 'p')
	endif
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
Plug 'Shougo/unite-outline'
Plug 'Shougo/neomru.vim'
Plug 'cocopon/iceberg.vim'
Plug 'tyru/open-browser.vim'
Plug 'scrooloose/syntastic'
Plug 'h1mesuke/vim-alignta'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'thinca/vim-fontzoom'
Plug 'beyondmarc/hlsl.vim'
Plug 'vim-scripts/cg.vim'
Plug 'vim-scripts/Tagbar'
Plug 'cohama/agit.vim'
Plug 'tpope/vim-fugitive'
Plug 'kana/vim-altr'
Plug 'Valloric/YouCompleteMe'
Plug 'nagaohiroki/myplugin.vim'
call plug#end()
filetype plugin indent on
syntax on
set background=dark
colorscheme iceberg
" --------------------------------------------------------------------------
" Tagbar
" --------------------------------------------------------------------------
nnoremap <F8> :TagbarToggle<CR>
let g:tagbar_sort=0
" --------------------------------------------------------------------------
" FontZoom
" --------------------------------------------------------------------------
nnoremap <F10> :Fontzoom +1<CR>
nnoremap <S-F10> :Fontzoom -1<CR>
nnoremap <C-S-F10> :Fontzoom!<CR>
" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
nmap <Leader>o <Plug>(openbrowser-smart-search)
" ----------------------------------------------------------------------
" artr
" ---------------------------------------------------------------------
nmap <Leader>h <Plug>(altr-forward)
" --------------------------------------------------------------------------
" syntastic
" --------------------------------------------------------------------------
let g:syntastic_cs_checkers=['syntax', 'semantic', 'issues']
let g:syntastic_python_checkers=['flake8']
let g:syntastic_go_checkers=['go', 'gofmt', 'golint', 'govet']
let g:syntastic_mode_map={'passive_filetypes': ['cpp']}
" --------------------------------------------------------------------------
" omnisharp
" --------------------------------------------------------------------------
function! CopyOmnisharpConfig()
	let dst=expand('~/dotfiles/setup/config.json')
	let src=expand('~/vim-plug/YouCompleteMe/third_party/ycmd/third_party/OmniSharpServer/OmniSharp/bin/Release/config.json')
	echo system(has('win32') ? 'copy' : 'cp' . ' "' . src . '" "' . dst . '"')
endfunction
command! CopyOmnisharpConfig call CopyOmnisharpConfig()
nnoremap <F12> :YcmCompleter GoToDefinition<CR>
" -------------------------------------------------------------------------
" unite
" -------------------------------------------------------------------------
call unite#custom#source('file_mru,file,file_rec', 'ignore_pattern', '\.meta$' )
nnoremap <Leader>f :Unite -start-insert file -path=<C-R>=fnameescape(expand('%:p:h'))<CR><CR>
nnoremap <Leader>m :Unite -start-insert file_mru<CR>
nnoremap <Leader>c :Unite -start-insert outline<CR>
" --------------------------------------------------------------------------
" DoxygenToolkit
" --------------------------------------------------------------------------
let g:DoxygenToolkit_blockHeader=repeat('-', 72)
let g:DoxygenToolkit_blockFooter=g:DoxygenToolkit_blockHeader
let g:DoxygenToolkit_commentType='C++'
" --------------------------------------------------------------------------
" altr for Unreal C++
" --------------------------------------------------------------------------
call altr#define('Private/%.cpp', 'Public/%.h')
" --------------------------------------------------------------------------
" shader syntax
" --------------------------------------------------------------------------
autocmd MyAutoCmd BufNewFile,BufRead *.shader,*.cg,*.compute,*.cginc set filetype=cg
autocmd MyAutoCmd BufNewFile,BufRead *.fx,*.hlsl set filetype=hlsl
" ----------------------------------------------------------------------
" Astyle
" ---------------------------------------------------------------------
function! Astyle()
	let l:pos = getpos('.')
	%!AStyle -I -n -A1 -t -p -D -U -j
	call setpos('.',pos)
endfunction
command! Astyle call Astyle()
" ----------------------------------------------------------------------
" change terminal cursol size
" ---------------------------------------------------------------------
if !has('win32')
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
	inoremap <Esc> <Esc>
endif
" ----------------------------------------------------------------------
" Utility Command
" ---------------------------------------------------------------------
command! CopyPath call setreg('*', expand('%:p'))
command! DateTime normal i<C-R>=strftime("%Y/%m/%d %H:%M:%S")<CR>
if has('win32')
	command! Term !start cmd /k cd /d "%:p:h"
	command! Wex !start explorer /select,"%:p"
	vnoremap <F3> y:!start "<C-R>0"<CR>
endif
if has('mac')
	command! Term !open -a iTerm "%:p:h"
	command! Wex !open "%:p:h"
	vnoremap <F3> y:!open "<C-R>0"<CR>
endif
" --------------------------------------------------------------------------
" Setting
" --------------------------------------------------------------------------
set autoindent
set autoread
set clipboard+=unnamedplus,unnamed
set completeopt=longest,menuone
set formatoptions=q
set helplang=ja
set hidden
set hlsearch
set incsearch
set laststatus=2
set list
set listchars=eol:<,tab:>\ ,extends:<
set matchpairs+=<:>
set matchtime=1
set number
set noshowmatch
set noswapfile
set notimeout
set nowrap
set nrformats=hex
set nobackup
set pumheight=10
set shiftwidth=4
set showcmd
set smartindent
set smartcase
set ignorecase
set statusline=%<%f%m%r%h%w
set statusline+=%y%{'['.(&fenc!=''?&fenc:'e:'.&enc).(&bomb?'_bom':'').']['.&ff.']'}
set statusline+=%=%c,%l/%L
set tabstop=4
set title
set undolevels=1000
set undodir=$HOME/.cache
set undofile
set whichwrap=b,s,h,l,<,>,[,]
set mouse=a
set visualbell t_vb=
set colorcolumn=80
set tags+=tags;
" ----------------------------------------------------------------------
" mapping
" ----------------------------------------------------------------------
nnoremap <S-Up>    :set lines-=10<CR>
nnoremap <S-Down>  :set lines+=10<CR>
nnoremap <S-Left>  :set columns-=100<CR>
nnoremap <S-Right> :set columns+=100<CR>
nnoremap <C-j> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <Leader>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <Leader>g :vim/<C-R><C-W>/%:h/**/*.*
nnoremap <Leader>v :tabe ~/dotfiles/.vimrc<CR>
nnoremap <Leader>u :source $MYVIMRC<CR>
