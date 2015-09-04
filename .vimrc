scriptencoding utf-8
" --------------------------------------------------------------------------
" Unity3D 3
" UnityExternalScriptEditorHelper.exe
"
" Unity3D 4~5
" -p --remote-tab-silent +$(Line) "$(File)"
"
" Windows regedit
" $VIM\gvim.exe" -p --remote-tab-silent "%1"
"
" Visual Studio
" $VIM\gvim.exe
" -p --remote-tab-silent $(ItemPath)
" $(ItemDir)
"
" === NeoBundle Setting ===
" mkdir bundle
" git clone git://github.com/Shougo/neobundle.vim bundle/neobundle.vim
"
" windows
"mklink "$VIM/.vimrc" "dotfiles/.vimrc"
"
" linux/mac
" ln -s dotfiles/.vimrc ~/.vimrc
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
	" Local Option
	if getftype( $VIM_CURRENT . '/local.vim' ) != ""
		source $VIM_CURRENT/local.vim
	endif

	" cache
	let $VIM_CACHE_DIR=$HOME . '/.cache'
	silent! call mkdir( $VIM_CACHE_DIR )

	" bundle
	let $MY_NEOBUNDLE_PATH=$VIM_CURRENT . '/bundle'

	set runtimepath+=$MY_NEOBUNDLE_PATH/neobundle.vim
endif
" --------------------------------------------------------------------------
" Plugin
" --------------------------------------------------------------------------
call neobundle#begin(expand($MY_NEOBUNDLE_PATH))
if neobundle#load_cache(expand($MY_NEOBUNDLE_PATH))
	NeoBundleFetch 'Shougo/neobundle.vim'
	NeoBundle 'Shougo/unite.vim'
	NeoBundle 'Shougo/neomru.vim'
	NeoBundle 'Shougo/neocomplete.vim'
	NeoBundle 'Align'
	NeoBundle 'vim-scripts/DoxygenToolkit.vim'
	NeoBundle 'tyru/open-browser.vim'
	NeoBundle 'scrooloose/syntastic'
	NeoBundle 'kannokanno/previm'
	NeoBundle 'cocopon/iceberg.vim'
	NeoBundle 'cg.vim'
	NeoBundle 'beyondmarc/hlsl.vim'
	NeoBundle 'PProvost/vim-ps1'
	NeoBundle 'timcharper/textile.vim'
	NeoBundle 'OmniSharp/omnisharp-vim'
	NeoBundle 'davidhalter/jedi-vim'
	NeoBundle 'nagaohiroki/myplugin.vim'
	NeoBundleSaveCache
endif
NeoBundleCheck
call neobundle#end()
filetype plugin indent on
syntax on
" --------------------------------------------------------------------------
" syntastic
" --------------------------------------------------------------------------
let g:syntastic_cs_checkers=['syntax', 'semantic', 'issues']

" --------------------------------------------------------------------------
" omnisharp
" --------------------------------------------------------------------------
let g:OmniSharp_sln_list_index=1
let g:OmniSharp_timeout=10
let g:OmniSharp_selector_ui='unite'
autocmd MyAutoCmd Filetype cs nnoremap <F12> :OmniSharpGotoDefinition<CR>
autocmd MyAutoCmd Filetype cs nnoremap <S-F12> :OmniSharpFindUsages<CR>
" -------------------------------------------------------------------------
" unite
" -------------------------------------------------------------------------
let s:unite_ignore_patterns=['\.jpg','\.jpeg','\.png','\.tga','\.psd','\.tif','\.gif','\.bmp','\.dds']
let s:unite_ignore_patterns+=['\.dae','\.fbx','\.blender','\.ma','\.mb','\.mel','\.3ds','\.max']
let s:unite_ignore_patterns+=['\.meta','\.mat','\.unity','\.prefab','\.asset','\.flare','\.anim','\.exr', '\.physicsMaterial2D', '\.controller']
call unite#custom#source('file_mru,file,file_rec', 'ignore_pattern', join( s:unite_ignore_patterns, '\|' ) )

nnoremap <Space>r :Unite -start-insert -path=<C-R>=g:local_working_path<CR> file_rec<CR>
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
autocmd MyAutoCmd BufNewFile,BufRead *.fcg,*.vcg,*.shader,*.cg,*.compute set filetype=cg
autocmd MyAutoCmd BufNewFile,BufRead *.fx,*.fxc,*.fxh,*.hlsl,*.pssl set filetype=hlsl

" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
command! OB call openbrowser#_keymapping_smart_search('n')

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
nnoremap <S-Left>  <Nop>
nnoremap <S-Right> <Nop>
nnoremap <S-Up>    <Nop>
nnoremap <S-Down>  <Nop>
vnoremap <S-Left>  <Nop>
vnoremap <S-Right> <Nop>
vnoremap <S-Up>    <Nop>
vnoremap <S-Down>  <Nop>
inoremap <C-c> <Esc>
inoremap <C-q> <C-R>=strftime('%Y/%m/%d %H:%M')<CR>
inoremap <C-l> <Del>
nnoremap <C-j> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <Space>l :set columns+=50<CR>
nnoremap <Space>h :set columns-=50<CR>
nnoremap <Space>j :set lines+=20<CR>
nnoremap <Space>k :set lines-=20<CR>
nnoremap <Space>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <Space>g :vim/<C-R><C-W>/<C-R>=g:local_working_path<CR>/**/*.cs<C-B><Right><Right><Right><Right>
nnoremap <Space>v :tabe $MYVIMRC<CR>
nnoremap <Space>u :source $MYVIMRC<CR>
inoremap <expr> <C-Space> pumvisible() ? '<C-e>' : '<C-x><C-o><C-p>'
inoremap <expr> <TAB>     pumvisible() ? '<Down>': '<Tab>'
inoremap <expr> <S-TAB>   pumvisible() ? '<Up>'  : '<S-Tab>'
vnoremap <MiddleMouse> <Esc><LeftMouse>:<C-U>q<CR>
nnoremap <MiddleMouse> <LeftMouse>:q<CR>
inoremap <MiddleMouse> <Esc><LeftMouse>:q<CR>

" ----------------------------------------------------------------------
" AutoCommand
" ---------------------------------------------------------------------
autocmd MyAutoCmd BufNewFile,BufRead *.xml,*.dae nnoremap <Space>x :%s/></>\r</g<CR>:setf xml<CR>:normal gg=G<CR>
autocmd MyAutoCmd FocusGained,BufNewFile,BufRead,BufEnter * if expand('%:p:h') !~ '^/tmp' | silent! lcd %:p:h | endif
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
autocmd MyAutoCmd Filetype * set formatoptions-=ro

" ----------------------------------------------------------------------
" Command
" ---------------------------------------------------------------------
command! PathCopy call setreg('*', expand('%:p'))
command! PathCopyLine call setreg('*', expand('%:p') . ' ' . line('.'))

