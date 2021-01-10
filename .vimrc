scriptencoding utf-8
set encoding=utf8
set fileencodings=ucs-bom,iso-2022-jp-3,euc-jisx0213,cp932,sjis,euc-jp,utf-8
let mapleader="\<Space>"
function! InstallVimPlug(plug_dir)
	call mkdir(a:plug_dir, 'p')
	call system('git clone https://github.com/junegunn/vim-plug.git ' . a:plug_dir . '/autoload')
endfunction
command! InstallVimPlug call InstallVimPlug(expand('~/vim-plug'))
if has('vim_starting')
	set runtimepath^=~/vim-plug
endif
let s:use_coc=1
filetype plugin indent off
syntax off
call plug#begin('~/vim-plug')
Plug 'https://github.com/junegunn/vim-plug', {'dir': '~/vim-plug/autoload'}
Plug 'https://github.com/junegunn/fzf'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/pbogut/fzf-mru.vim'
Plug 'https://github.com/mattn/transparency-windows-vim'
Plug 'https://github.com/mattn/vimtweak'
Plug 'https://github.com/beyondmarc/hlsl.vim'
Plug 'https://github.com/cohama/agit.vim'
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
Plug 'https://github.com/OrangeT/vim-csharp'
Plug 'https://github.com/jremmen/vim-ripgrep'
Plug 'https://github.com/voldikss/vim-translator'
if s:use_coc==1
	Plug 'https://github.com/neoclide/coc.nvim'
else
	Plug 'https://github.com/honza/vim-snippets'
	Plug 'https://github.com/SirVer/ultisnips'
	Plug 'https://github.com/ycm-core/YouCompleteMe'
endif
call plug#end()
filetype plugin indent on
syntax on
set background=dark
colorscheme iceberg
nnoremap <Leader>t :TagbarToggle<CR>
if s:use_coc==1
	nnoremap <Leader>h :call CocActionAsync('doHover')<CR>
	inoremap <silent><expr><c-space> coc#refresh()
	inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	nmap <Leader>g <Plug>(coc-definition)
	nmap <Leader>u <Plug>(coc-references)
	imap <C-s> <Plug>(coc-snippets-expand)
	let g:coc_global_extensions=['coc-omnisharp', 'coc-clangd', 'coc-snippets', 'coc-pyright', 'coc-vimlsp', 'coc-json']
else
	" youcompleteme
	nnoremap <Leader>g :YcmCompleter GoToDefinition<CR>
	nnoremap <Leader>u :YcmCompleter GoToReferences<CR>
	let g:ycm_auto_hover=''
	" UtilSnips
	let g:UltiSnipsExpandTrigger='<C-s>'
endif
" tagbar
let g:tagbar_sort=0
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
nnoremap <Leader>c :execute 'FZF ' . expand('%:p:h')<CR>
nnoremap <Leader>m :FZFMru<CR>
" ue4helper
nnoremap <Leader>p :P4FZF<CR>
nnoremap <Leader>1 :UE4FZFProject<CR>
nnoremap <Leader>2 :UE4FZFEngine<CR>
nnoremap <Leader>v :UE4VSOpen<CR>
" nnoremap <Leader>e :UE4Dumps<CR>
" RipGrep
if executable('rg')
	nnoremap <Leader>r :Rg <C-R><C-W><CR>
else
	nnoremap <Leader>r :vim/<C-R><C-W>/**/*.*<CR>
endif
" Signfy
nnoremap <Leader>d :SignifyDiff<CR>
" DoxygenToolkit
let g:DoxygenToolkit_blockHeader=repeat('-', 72)
let g:DoxygenToolkit_blockFooter=g:DoxygenToolkit_blockHeader
let g:DoxygenToolkit_commentType='C++'
" Astyle
function! Astyle()
	let l:pos = getpos('.')
	execute '%!AStyle --options=' . $HOME . '/dotfiles/scripts/astylerc'
	call setpos('.',pos)
endfunction
command! Astyle call Astyle()
" Utility Setting(not plugins setting)
augroup vimrc_loading
	autocmd!
	autocmd QuickFixCmdPost *grep* cwindow
	autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
	autocmd BufRead,BufNewFile *.usf setfiletype hlsl
	autocmd BufRead,BufNewFile *.ush setfiletype hlsl
	autocmd InsertEnter,InsertLeave * set cursorline!
augroup END
command! CopyPath call setreg('*', expand('%:p'))
command! CopyPathLine call setreg('*', expand('%:p') . '#L' . line('.'))
command! Rc e ~/dotfiles/.vimrc
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
set completeopt=menu,menuone,noselect,noinsert
nnoremap <Leader>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <C-p> "0p
vnoremap <C-p> "0p
" mac omnisharp options
" ./configure --with-gacarchs=arm64 --enable-python3interp=dynamic --enable-luainterp=dynamic --with-lua-prefix=/opt/local 
" set pythonthreedll=/opt/local/Library/Frameworks/Python.framework/Versions/3.8/lib/libpython3.8.dylib
" set pythonthreehome=/opt/local/Library/Frameworks/Python.framework/Versions/3.8
" set luadll=/opt/local/lib/liblua.5.3.dylib
" ~/.config/coc/extensions/coc-omnisharp-data/server/run #L9
" mono_cmd=/Library/Frameworks/Mono.framework/Versions/Current/bin/mono
" ~/.config/coc/extensions/node_modules/coc-omnisharp/out/client/extension.js #L34
" "osx-x86": { platformPath: "omnisharp-osx.zip", execugable: "run" },
