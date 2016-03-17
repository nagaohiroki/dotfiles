scriptencoding utf-8
" --------------------------------------------------------------------------
" Unity
" -p --remote-tab-silent +$(Line) "$(File)"
"
" Windows regedit
" "gvim" -p --remote-tab-silent "%1"
"
" Visual Studio
" "gvim" -p --remote-tab-silent $(ItemPath)
" --------------------------------------------------------------------------
" -------------------------------------------------------------------------
" AutoCommandGroup
" -------------------------------------------------------------------------
augroup MyAutoCmd
	autocmd!
augroup END

" -------------------------------------------------------------------------
" Startup
" -------------------------------------------------------------------------
if has('vim_starting')
	let $VIM_CURRENT=has('win32') ? $VIM : $HOME
	let $VIM_CACHE_DIR=$HOME . '/.cache'
	let $MY_PLUGIN_PATH=$VIM_CURRENT . '/bundle'
	let g:dein#install_process_timeout=3000
	set runtimepath+=$MY_PLUGIN_PATH/dein.vim
endif
" --------------------------------------------------------------------------
" Plugin 
" --------------------------------------------------------------------------
call dein#begin(expand($MY_PLUGIN_PATH))
if dein#load_cache()
	call dein#add('Shougo/dein.vim')
	call dein#add('Shougo/unite.vim')
	call dein#add('Shougo/neomru.vim')
	call dein#add('Shougo/vimfiler.vim')
	call dein#add('Shougo/neocomplete.vim')
	call dein#add('Align')
	call dein#add('vim-scripts/DoxygenToolkit.vim')
	call dein#add('tyru/open-browser.vim')
	call dein#add('scrooloose/syntastic')
	call dein#add('kannokanno/previm')
	call dein#add('davidhalter/jedi-vim')
	call dein#add('nagaohiroki/myplugin.vim')
	call dein#add('thinca/vim-fontzoom')
	call dein#add('cocopon/iceberg.vim')
	call dein#add('cg.vim')
	call dein#add('beyondmarc/hlsl.vim')
	call dein#add('PProvost/vim-ps1')
	call dein#add('timcharper/textile.vim')
	call dein#add('aklt/plantuml-syntax')
	call dein#add('OmniSharp/omnisharp-vim')
	call dein#save_cache()
endif
call dein#end()
filetype plugin indent on
syntax on
" --------------------------------------------------------------------------
" Fontzoom
" --------------------------------------------------------------------------
nnoremap + :Fontzoom +1<CR>
nnoremap - :Fontzoom -1<CR>
" --------------------------------------------------------------------------
" syntastic
" --------------------------------------------------------------------------
let g:syntastic_cs_checkers=['syntax', 'semantic', 'issues']

" --------------------------------------------------------------------------
" omnisharp
" --------------------------------------------------------------------------
let g:OmniSharp_sln_list_index=1
let g:OmniSharp_timeout=30
let g:OmniSharp_selector_ui='unite'
let g:Omnisharp_server_config_name=$VIM . ".vim/config.json"
let g:OmniSharp_server_type='v1'
function! OmniSharpSetting()
	nnoremap <F12> :OmniSharpGotoDefinition<CR>
	nnoremap <S-F12> :OmniSharpFindUsages<CR>
	nnoremap <C-F12> :OmniSharpReloadSolution \| OmniSharpHighlightTypes<CR>
endfunction
autocmd MyAutoCmd Filetype cs call OmniSharpSetting()
command! MyOmniBuild execute '!start ' . $VIM . '/.vim/omni_build.bat'

" -------------------------------------------------------------------------
" unite
" -------------------------------------------------------------------------
let s:unite_ignore_patterns=['\.jpg','\.jpeg','\.png','\.tga','\.psd','\.tif','\.gif','\.bmp','\.dds']
let s:unite_ignore_patterns+=['\.dae','\.fbx','\.blender','\.ma','\.mb','\.mel','\.3ds','\.max']
let s:unite_ignore_patterns+=['\.meta','\.mat','\.unity','\.prefab','\.asset','\.flare','\.anim','\.exr', '\.physicsMaterial2D', '\.controller']
call unite#custom#source('file_mru,file,file_rec', 'ignore_pattern', join( s:unite_ignore_patterns, '\|' ) )

nnoremap <Space>r :Unite -start-insert -path=<C-R>=g:grep_root<CR> file_rec<CR>
nnoremap <Space>f :Unite -start-insert file<CR>
nnoremap <Space>m :Unite -start-insert file_mru<CR>
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
if executable('jvgrep')
    let g:unite_source_grep_command = 'jvgrep'
    let g:unite_source_grep_default_opts = '-r'
    let g:unite_source_grep_recursive_opt = '-R'
endif
" --------------------------------------------------------------------------
" vimfiler
" --------------------------------------------------------------------------
nnoremap <C-F> :VimFilerExplorer<CR>
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

" ----------------------------------------------------------------------
" function
" ---------------------------------------------------------------------
function! Enc()
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=ucs-boms,iso-2022-jp,euc-jp,cp932,sjis,utf-16le,utf-8
	set fileformat=unix
	set fileformats=unix,dos,mac
endfunction

function! XmlFmt()
	%s/></>\r</g
	normal gg=G
endfunction
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

" --------------------------------------------------------------------------
" Setting
" --------------------------------------------------------------------------
set autoindent
set autoread
set cindent
set clipboard+=unnamedplus,unnamed
set cmdheight=2
set completeopt=longest,menuone
set foldcolumn=1
set foldenable
set foldmarker=region,endregion
set foldmethod=marker
set foldnestmax=0
set formatoptions=q
set helplang=ja
set hidden
set hlsearch
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=eol:<,tab:>\ ,extends:<
set matchpairs+=<:>
set matchtime=1
set nobackup
set noshowmatch
set noswapfile
set notimeout
set nowrap
set nrformats=hex
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
set ttyfast
set undodir=$VIM_CACHE_DIR
set undofile
set undolevels=1000
set whichwrap=b,s,h,l,<,>,[,]
" ----------------------------------------------------------------------
" mapping
" ----------------------------------------------------------------------
vnoremap <S-Up>    <Nop>
vnoremap <S-Down>  <Nop>
vnoremap <S-Left>  <Nop>
vnoremap <S-Right> <Nop>
vnoremap <C-Up>    <Nop>
vnoremap <C-Down>  <Nop>
vnoremap <C-Left>  <Nop>
vnoremap <C-Right> <Nop>
nnoremap <S-Up>    :set lines-=10<CR>
nnoremap <S-Down>  :set lines+=10<CR>
nnoremap <S-Left>  :set columns-=10<CR>
nnoremap <S-Right> :set columns+=10<CR>
inoremap <C-c> <Esc>
inoremap <C-q> <C-R>=strftime('%Y/%m/%d %H:%M')<CR>
inoremap <C-d> <Del>
nnoremap <C-j> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <Space>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <Space>n :%s/\<<C-R><C-W>\>//ng<CR>
nnoremap <Space>g :vim/<C-R><C-W>/<C-R>=g:grep_root<CR>/**/*.cs<C-B><Right><Right><Right><Right>
nnoremap <Space>v :tabe $MYVIMRC<CR>
nnoremap <Space>l :tabe $VIM/vimrc_local.vim<CR>
nnoremap <Space>u :source $MYVIMRC<CR>
inoremap <expr> <C-Space> pumvisible() ? '<C-e>' : '<C-x><C-o><C-p>'
inoremap <expr> <TAB>     pumvisible() ? '<Down>': '<Tab>'
inoremap <expr> <S-TAB>   pumvisible() ? '<Up>'  : '<S-Tab>'

" ----------------------------------------------------------------------
" AutoCommand
" ---------------------------------------------------------------------
autocmd MyAutoCmd FocusGained,BufNewFile,BufRead,BufEnter * silent! lcd %:p:h
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
autocmd MyAutoCmd Filetype * setlocal formatoptions-=ro
" ----------------------------------------------------------------------
" Command
" ---------------------------------------------------------------------
command! Enc call Enc() | e!
command! PathCopy call setreg('*', expand('%:p'))
command! PathCopyLine call setreg('*', expand('%:p') . ' ' . line('.'))
command! XmlFmt call XmlFmt()
