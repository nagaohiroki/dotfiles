scriptencoding utf-8

" --------------------------------------------------------------------------
" memo
"
"  === Unity3D argment ===
"
" -p --remote-tab-silent +$(Line) "$(File)"
"
"  === Windows regedit setting ===
"
" $VIM\gvim.exe" -p --remote-tab-silent "%1"
"
"  === Visual Studio setting ===
"
" $VIM\gvim.exe
" -p --remote-tab-silent $(ItemPath)
" $(ItemDir)
"
" === NeoBundle Setting ===
"
" mkdir bundle
" git clone git://github.com/Shougo/neobundle.vim bundle/neobundle.vim
"
" windows
"mklink "$VIM/.vimrc" ~/DropBox/dotfiles/.vimrc"
"mklink "$VIM/.gvimrc" ~/DropBox/dotfiles/.gvimrc"
"
" ubuntu/mac
" ln -s ~/DropBox/dotfiles/.vimrc ~/.vimrc
" ln -s ~/DropBox/dotfiles/.gvimrc ~/.gvimrc
" --------------------------------------------------------------------------

" --------------------------------------------------------------------------
" LocalOption
" --------------------------------------------------------------------------
if getftype( $VIM . '/local.vim' ) != ""
	source $VIM/local.vim
endif

" -------------------------------------------------------------------------
" AutoCommandGroup
" -------------------------------------------------------------------------
augroup MyAutoCmd
	autocmd!
augroup END

" --------------------------------------------------------------------------
" NeoBundle
" --------------------------------------------------------------------------
if has('vim_starting')
	silent! call mkdir( $HOME . '/.cache' )
	if !exists('$MY_NEOBUNDLE_PATH')
		if has('win32')
			let $MY_NEOBUNDLE_PATH=$VIM . '/bundle'
		else
			let $MY_NEOBUNDLE_PATH=$HOME . '/bundle'
		endif
	endif
	set runtimepath+=$MY_NEOBUNDLE_PATH/neobundle.vim
endif
call neobundle#begin(expand($MY_NEOBUNDLE_PATH))
if neobundle#has_fresh_cache(expand($MYVIMRC))
	NeoBundleLoadCache
else
	NeoBundleFetch 'Shougo/neobundle.vim'
	NeoBundle 'Shougo/unite.vim'
	NeoBundle 'Shougo/neomru.vim'
	NeoBundle 'Shougo/neocomplete.vim'
	NeoBundle 'Align'
	NeoBundle 'cg.vim'
	NeoBundle 'beyondmarc/hlsl.vim'
	NeoBundle 'vim-scripts/DoxygenToolkit.vim'
	NeoBundle 'tyru/open-browser.vim'
	NeoBundle 'cocopon/iceberg.vim'
	NeoBundle 'nagaohiroki/myplugin.vim'
	NeoBundle 'OmniSharp/omnisharp-vim'
	NeoBundle 'mattn/webapi-vim'
	NeoBundle 'mattn/excitetranslate-vim'
	" NeoBundle 'scrooloose/syntastic'
	NeoBundleSaveCache
endif
NeoBundleCheck
call neobundle#end()
filetype plugin indent on
syntax on
" -------------------------------------------------------------------------
" unite
" -------------------------------------------------------------------------
let g:unite_enable_ignore_case=1
let g:unite_enable_start_insert=1
nnoremap ,f :Unite file<CR>
nnoremap ,m :Unite file_mru<CR>
nnoremap ,b :Unite buffer<CR>

" --------------------------------------------------------------------------
" syntastic
" --------------------------------------------------------------------------
" let g:syntastic_mode_map={ 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
" let g:syntastic_always_populate_loc_list=1
" let g:syntastic_auto_loc_list=1
" let g:syntastic_check_on_open=1
" let g:syntastic_check_on_wq=0
" let g:syntastic_cs_checkers=['syntax', 'semantic', 'issues']
" --------------------------------------------------------------------------
" neocomplete
" --------------------------------------------------------------------------
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_ignore_case=1
let g:neocomplete#enable_insert_char_pre=1

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns={}
endif
let g:neocomplete#sources#omni#input_patterns.cpp='[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.ruby='[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.cs='.*[^=\);]'
let g:neocomplete#sources#omni#input_patterns.python='.*[^=\);]'

" --------------------------------------------------------------------------
" OmniSharp
" --------------------------------------------------------------------------
if !exists('g:config_is_omnisharp') ||  g:config_is_omnisharp == 0
 	let g:OmniSharp_loaded=1
	let g:Omnisharp_start_server = 0
else
	autocmd MyAutoCmd FileType cs setlocal omnifunc=OmniSharp#Complete
	let g:OmniSharp_sln_list_index=1
endif

" --------------------------------------------------------------------------
" DoxygenToolkit
" --------------------------------------------------------------------------
let g:DoxygenToolkit_blockHeader='------------------------------------------------------------------------'
let g:DoxygenToolkit_blockFooter='------------------------------------------------------------------------'
let g:DoxygenToolkit_commentType='C++'
nnoremap ,d :Dox<CR>

" --------------------------------------------------------------------------
" cscomment
" --------------------------------------------------------------------------
nnoremap ,c :Cscomment<CR>

" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
nmap ,o <Plug>(openbrowser-smart-search)
nnoremap ,g :OpenBrowserSearch<Space>

" ----------------------------------------------------------------------
" Align
" ---------------------------------------------------------------------
let g:Align_xstrlen=3

" --------------------------------------------------------------------------
" Setting
" --------------------------------------------------------------------------
set noshowmatch
set nowrap
set noswapfile
set notimeout
set nobackup
set matchtime=1
set showtabline=2
set laststatus=2
set cmdheight=2
set whichwrap=b,s,h,l,<,>,[,]
set showcmd
set number
set title
set list
set listchars=eol:<,tab:>-,extends:<
set shiftwidth=4
set pumheight=10
set autoindent
set cindent
set smartindent
set tabstop=4
set clipboard+=unnamedplus,unnamed
set incsearch
set hlsearch
set hidden
set helplang=ja
set matchpairs+=<:>
set nrformats=hex
set autoread
set formatoptions=q
set completeopt=longest,menuone
set lazyredraw
set ttyfast
set undolevels=1000
set undofile
set undodir=$HOME/.cache
set foldenable
set foldmethod=marker
set foldmarker=region,endregion
set foldnestmax=0
set foldcolumn=1
set statusline=%<%f\ %m%r%h%w
set statusline+=[%Y]%{'['.(&fenc!=''?&fenc:&enc).(&bomb?'_bom':'').']['.&fileformat.']'}
set statusline+=%{(&wrap?'[wrap]':'')}
set statusline+=%=%l/%L,%c%V%8P

" ----------------------------------------------------------------------
" mapping
" ----------------------------------------------------------------------
nnoremap <MiddleMouse> <LeftMouse>:q<CR>
vnoremap <MiddleMouse> <Esc><LeftMouse>:q<CR>
inoremap <MiddleMouse> <Esc><LeftMouse>:q<CR>
inoremap <C-C> <Esc>
inoremap <C-Q> <C-R>=strftime('%Y/%m/%d %H:%M')<CR>
nnoremap <C-P> "0p
vnoremap <C-P> "0p
inoremap <C-L> <Del>
nnoremap <C-J> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
inoremap <expr> <C-Space> pumvisible() ? "\<C-E>"     : "\<C-N><C-P>"
inoremap <expr> <TAB>     pumvisible() ? "\<Down>"    : "\<Tab>"
inoremap <expr> <S-TAB>   pumvisible() ? "\<Up>"      : "\<S-Tab>"
nnoremap <Space>w :set wrap!<CR>
nnoremap <Space>u :source $MYVIMRC<CR>
nnoremap <Space>v :tabe $MYVIMRC<CR>
nnoremap <Space>l :set columns+=50<CR>
nnoremap <Space>h :set columns-=50<CR>
nnoremap <Space>j :set lines+=20<CR>
nnoremap <Space>k :set lines-=20<CR>
nnoremap <Space>s :%s /\<<C-R><C-W>\>//g<Left><Left>
nnoremap <Space>g :vimgrep /<C-R><C-W>/**/*.*
nnoremap <S-Left>  <Nop>
nnoremap <S-Right> <Nop>
nnoremap <S-Up>    <Nop>
nnoremap <S-Down>  <Nop>

" ----------------------------------------------------------------------
" AutoCommand
" ---------------------------------------------------------------------
autocmd MyAutoCmd BufNewFile,BufRead *.fcg,*.vcg,*.shader,*.cg set filetype=cg
autocmd MyAutoCmd BufNewFile,BufRead *.fx,*.fxc,*.fxh,*.hlsl,*.pssl set filetype=hlsl
autocmd MyAutoCmd BufNewFile,BufRead *.xml,*.dae nnoremap <Space>x :%s/></>\r</g<CR>:setf xml<CR>:normal gg=G<CR>
autocmd MyAutoCmd FocusGained,BufNewFile,BufRead,BufEnter * if expand('%:p:h') !~ '^/tmp' | silent! lcd %:p:h | endif
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
autocmd MyAutoCmd Filetype * set formatoptions-=ro


