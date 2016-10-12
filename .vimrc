scriptencoding utf-8
set encoding=utf8
set fileencodings=euc-jp,cp932,sjis,iso-2022-jp,ucs-bom,utf-8
" --------------------------------------------------------------------------
" Unity
" -p --remote-tab-silent +$(Line) "$(File)"
" Windows regedit
" "gvim" -p --remote-tab-silent "%1"
" Visual Studio
" "gvim" -p --remote-tab-silent +$(CurLine) $(ItemPath)
" --------------------------------------------------------------------------
" -------------------------------------------------------------------------
" AutoCommandGroup
" -------------------------------------------------------------------------
augroup MyAutoCmd
	autocmd!
augroup END
filetype off
" -------------------------------------------------------------------------
" Startup
" -------------------------------------------------------------------------
if has('vim_starting')
	let $MY_PLUGIN_PATH=$HOME . '/bundle'
	set runtimepath^=$MY_PLUGIN_PATH/neobundle.vim/
	let g:neobundle#install_process_timeout=3000
endif

" -------------------------------------------------------------------------
" Project
" -------------------------------------------------------------------------
function! InitProject(project_paths)
	for p in a:project_paths
		execute 'set tags+=' . p . '/tags'
		execute 'set path+=' . p
	endfor
	let g:grep_root=a:project_paths[0]
endfunction

if exists('g:project_paths')
	call InitProject(g:project_paths)
endif
" --------------------------------------------------------------------------
" Plugin 
" --------------------------------------------------------------------------
call neobundle#begin(expand($MY_PLUGIN_PATH))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'nagaohiroki/myplugin.vim'
NeoBundle 'cocopon/iceberg.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'beyondmarc/hlsl.vim'
NeoBundle 'PProvost/vim-ps1'
NeoBundle 'aklt/plantuml-syntax'
NeoBundle 'DoxygenToolkit.vim'
NeoBundle 'cg.vim'
NeoBundle 'Tagbar'
NeoBundle 'Align'
NeoBundle 'gtags.vim'
NeoBundle 'davidhalter/jedi-vim', { 'autoload': { 'filetypes': ['python'] } }
if has('python')
NeoBundle 'OmniSharp/omnisharp-vim', { 'autoload': { 'filetypes': ['cs'] }}
endif
call neobundle#end()
filetype plugin indent on
syntax on
colorscheme iceberg
set background=dark
" --------------------------------------------------------------------------
" Tagbar
" --------------------------------------------------------------------------
nnoremap <F8> :TagbarToggle<CR>
" --------------------------------------------------------------------------
" VimFiler
" --------------------------------------------------------------------------
nnoremap <F7> :VimFiler -simple -split -toggle -winwidth=30 -no-quit<CR>

" --------------------------------------------------------------------------
" gtags
" --------------------------------------------------------------------------
nnoremap <F11> :GtagsCursor<CR>

" --------------------------------------------------------------------------
" syntastic
" --------------------------------------------------------------------------
let g:syntastic_cs_checkers=['syntax', 'semantic', 'issues']
let g:syntastic_python_checkers = ['flake8']
" --------------------------------------------------------------------------
" omnisharp
" --------------------------------------------------------------------------
function! SetupOmniSharp()
	let g:OmniSharp_sln_list_index=1
	let g:OmniSharp_timeout=30
	let g:OmniSharp_selector_ui='unite'
	let g:OmniSharp_server_config_name='config.json'
	let g:OmniSharp_server_type='v1'
	nnoremap <F12> :OmniSharpGotoDefinition<CR>
	nnoremap <S-F12> :OmniSharpFindUsages<CR>
	nnoremap <C-F12> :OmniSharpReloadSolution \| OmniSharpHighlightTypes<CR>
endfunction
if has('python')
	autocmd MyAutoCmd Filetype cs call SetupOmniSharp()
endif
let g:csharp_compiler=has('win32') ? 'msbuild' : 'xbuild'
command! OmniBuild execute '!' . g:csharp_compiler . ' ' . $MY_PLUGIN_PATH . '/omnisharp-vim/server/OmniSharp.sln'
" -------------------------------------------------------------------------
" unite
" -------------------------------------------------------------------------
let s:unite_ignore_patterns=['meta']
call unite#custom#source('file_mru,file,file_rec', 'ignore_pattern', join( s:unite_ignore_patterns, '\|' ) )
nnoremap <Space>r :Unite -start-insert -path=<C-R>=g:grep_root<CR> file_rec<CR>
nnoremap <Space>f :Unite -start-insert file<CR>
nnoremap <Space>m :Unite -start-insert file_mru<CR>
" --------------------------------------------------------------------------
" neocomplete
" --------------------------------------------------------------------------
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_ignore_case=1
let g:neocomplete#enable_insert_char_pre=1

" --------------------------------------------------------------------------
" DoxygenToolkit
" --------------------------------------------------------------------------
let g:DoxygenToolkit_blockHeader='------------------------------------------------------------------------'
let g:DoxygenToolkit_blockFooter='------------------------------------------------------------------------'
let g:DoxygenToolkit_commentType='C++'
" --------------------------------------------------------------------------
" shader syntax
" --------------------------------------------------------------------------
autocmd MyAutoCmd BufNewFile,BufRead *.fcg,*.vcg,*.shader,*.cg,*.compute,*.cginc set filetype=cg
autocmd MyAutoCmd BufNewFile,BufRead *.fx,*.fxc,*.fxh,*.hlsl,*.pssl set filetype=hlsl
" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
nmap <Space>o <Plug>(openbrowser-smart-search)
" ----------------------------------------------------------------------
" Align
" ---------------------------------------------------------------------
let g:Align_xstrlen=3
" --------------------------------------------------------------------------
" Setting
" --------------------------------------------------------------------------
set autoindent
set autoread
set cindent
set clipboard+=unnamedplus,unnamed
set cmdheight=2
set completeopt=longest,menuone
set nofoldenable
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
set noshowmatch
set noswapfile
set notimeout
set nowrap
set nrformats=hex
set nobackup
set number
set pumheight=10
set shiftwidth=4
set showcmd
set showtabline=2
set smartindent
set statusline=%<%f\ %m%r%h%w
set statusline+=[%Y]%{'['.(&fenc!=''?&fenc:&enc).(&bomb?'_bom':'').']['.&fileformat.']'}
set statusline+=%=%l/%L,%c%V%8P
set tabstop=4
set title
set undolevels=1000
set undodir=$HOME/.cache
set undofile
set whichwrap=b,s,h,l,<,>,[,]
set grepprg=jvgrep\ -i\ -I
set lazyredraw
set ttyfast
set diffopt=filler,context:1000000 
" ----------------------------------------------------------------------
" mapping
" ----------------------------------------------------------------------
nnoremap <C-Up>    [c
nnoremap <C-Down>  ]c
nnoremap <S-Up>    :set lines-=10<CR>
nnoremap <S-Down>  :set lines+=10<CR>
nnoremap <S-Left>  :set columns-=100<CR>
nnoremap <S-Right> :set columns+=100<CR>
inoremap <C-c> <Esc>
inoremap <C-q> <C-R>=strftime('%Y/%m/%d %H:%M')<CR>
inoremap <C-d> <Del>
nnoremap <C-j> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <Space>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <Space>g :vim/<C-R><C-W>/<C-R>=g:grep_root<CR>/**/*.*
nnoremap <Space>v :tabe $MYVIMRC<CR>
nnoremap <Space>u :source $MYVIMRC<CR>
inoremap <expr> <C-Space> pumvisible() ? '<C-e>' : '<C-x><C-o><C-p>'
inoremap <expr> <TAB>     pumvisible() ? '<Down>': '<Tab>'
inoremap <expr> <S-TAB>   pumvisible() ? '<Up>'  : '<S-Tab>'
" ----------------------------------------------------------------------
" AutoCommand
" ---------------------------------------------------------------------
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
autocmd MyAutoCmd Filetype * setlocal formatoptions-=ro
autocmd MyAutoCmd BufEnter * execute ":cd " . substitute(expand("%:p:h")," ","\\\\ ","g")

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
" xml
" ---------------------------------------------------------------------
function! XmlFmt()
	%s/></>\r</g
	normal gg=G
endfunction
command! XmlFmt call XmlFmt()

" ----------------------------------------------------------------------
" cpp
" ---------------------------------------------------------------------
function! SwitchSourceHeader()
  "update!
  if (expand ("%:e") == "cpp")
    find %:t:r.h
  else
    find %:t:r.cpp
  endif
endfunction

function! CppSetting()
	nnoremap <Space>h :call SwitchSourceHeader()<CR>
endfunction
autocmd MyAutoCmd FileType cpp call CppSetting()
" ----------------------------------------------------------------------
" go
" ---------------------------------------------------------------------
function! GoSetting()
	command! Run !go run %
	command! Build !start go build
	exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
	exe "set rtp+=".globpath($GOPATH, "src/github.com/golang/lint/misc/vim")
endfunction
autocmd MyAutoCmd FileType go call GoSetting()

" ----------------------------------------------------------------------
" python
" ---------------------------------------------------------------------
 function! PythonSetting()
	command! Fmt silent %!autopep8 -
endfunction
autocmd MyAutoCmd FileType python call PythonSetting()

" ----------------------------------------------------------------------
" Command
" ---------------------------------------------------------------------
command! CopyPath call setreg('*', expand('%:p') . ' ' . line('.'))

if has('win32')
	command! Term !start cmd
endif
if has('mac')
	command! Term !open -a Terminal
	command! Finder !open .
endif

" ----------------------------------------------------------------------
" Command
" ---------------------------------------------------------------------
function! OldRev()
	if(&diff == 1)
		diffoff!
		return
	endif
	pyfile $HOME/dotfiles/.vim/old_rev.py
endfunction
nnoremap<F6> :call OldRev()<CR>
