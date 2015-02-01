scriptencoding utf-8

" --------------------------------------------------------------------------
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
" git clone git://github.com/Shougo/neobundle.vim bundle\neobundle.vim
"
" windows
"mklink "$VIM/.vimrc" ~/DropBox/dotfiles/.vimrc"
"mklink "$VIM/.gvimrc" ~/DropBox/dotfiles/.gvimrc"
"
" ubuntu/mac
" ln -s ~/DropBox/dotfiles/.vimrc ~/.vimrc
" ln -s ~/DropBox/dotfiles/.gvimrc ~/.gvimrc
" --------------------------------------------------------------------------

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
	NeoBundle 'vim-scripts/DoxygenToolkit.vim'
	NeoBundle 'tyru/open-browser.vim'
	NeoBundle 'cocopon/iceberg.vim'
	NeoBundle 'beyondmarc/hlsl.vim'
	NeoBundle 'vim-scripts/cg.vim'
	NeoBundle 'nagaohiroki/myplugin.vim'
	NeoBundle 'OmniSharp/omnisharp-vim'
	NeoBundle 'scrooloose/syntastic'
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
nnoremap ,b :Unite buffer<CR>
nnoremap ,m :Unite file_mru<CR>
nnoremap ,r :Unite register<CR>
" --------------------------------------------------------------------------
" neocomplete
" --------------------------------------------------------------------------
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_ignore_case=1
let g:neocomplete#enable_insert_char_pre=1


if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_input_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
"let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
"let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

" --------------------------------------------------------------------------
" OmniSharp
" --------------------------------------------------------------------------
autocmd MyAutoCmd FileType cs setlocal omnifunc=OmniSharp#Complete
let g:OmniSharp_sln_list_index = 1

" --------------------------------------------------------------------------
" DoxygenToolkit
" --------------------------------------------------------------------------
nnoremap ,d :Dox<CR>
let g:DoxygenToolkit_blockHeader='------------------------------------------------------------------------'
let g:DoxygenToolkit_blockFooter='------------------------------------------------------------------------'
let g:DoxygenToolkit_commentType='C++'
"let g:load_doxygen_syntax=1
" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
nm ,o <Plug>(openbrowser-smart-search)
nnoremap ,g :OpenBrowserSearch<Space>
nnoremap ,j :OpenBrowser http://translate.google.com/translate_t?hl=ja&langpair=ja%7Cen&text={}<Left>
nnoremap ,e :OpenBrowser http://translate.google.com/translate_t?hl=ja&langpair=en%7Cja&text={}<Left>
" ----------------------------------------------------------------------
" Astyle
" ---------------------------------------------------------------------
function! Astyle()
	let l:pos = getpos('.')
	%!AStyle -I -A1 -t -p -D -U -k3 -W3 -J -E -xp
	$delete
	call setpos('.',pos)
endfunction
command! Astyle :call Astyle()
" --------------------------------------------------------------------------
" Syntasitc
" --------------------------------------------------------------------------
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
let g:syntastic_flag = 0
function! SyntasitcToggle()
	if g:syntastic_flag == 0
		SyntasticCheck
		let g:syntastic_flag = 1
	else
		SyntasticReset
		let g:syntastic_flag = 0
	endif
endfunction
nnoremap ,s :call SyntasitcToggle()<CR>
" --------------------------------------------------------------------------
" Setting
" --------------------------------------------------------------------------
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
set nowrap
set noswapfile
set tabstop=4
set clipboard=unnamedplus
set clipboard+=unnamed
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
set notimeout
set backup
set backupdir=~/.cache
set undolevels=1000
set undofile
set undodir=~/.cache
set foldenable
set foldmethod=marker
set foldmarker=region,endregion
set foldnestmax=0
set foldcolumn=1
set statusline=%<%f\ %m%r%h%w(%n)
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
nnoremap <expr> <Space>w (&wrap) ? "\:set nowrap<CR>" : "\:set wrap<CR>"
nnoremap <Space>u :source $MYVIMRC<CR>
nnoremap <Space>v :tabe $MYVIMRC<CR>
nnoremap <Space>l :set columns+=50<CR>
nnoremap <Space>h :set columns-=50<CR>
nnoremap <Space>j :set lines+=20<CR>
nnoremap <Space>k :set lines-=20<CR>
nnoremap <Space>s :%s /\<<C-R><C-W>\>//g<Left><Left>
nnoremap <Space>g :vimgrep /<C-R><C-W>/**/*.*
nnoremap <S-Left> <Nop>
nnoremap <S-Right> <Nop>
nnoremap <S-Up> <Nop>
nnoremap <S-Down> <Nop>
" ----------------------------------------------------------------------
" AutoCommand
" ---------------------------------------------------------------------
autocmd MyAutoCmd BufNewFile,BufRead *.fcg,*.vcg,*.shader,*.cg set filetype=cg
autocmd MyAutoCmd BufNewFile,BufRead *.fx,*.fxc,*.fxh,*.hlsl,*.pssl set filetype=hlsl
autocmd MyAutoCmd BufNewFile,BufRead *.xml,*.dae nnoremap <Space>x :%s/></>\r</g<CR>:setf xml<CR>:normal gg=G<CR>
autocmd MyAutoCmd FocusGained,BufNewFile,BufRead,BufEnter * if expand('%:p:h') !~ '^/tmp' | silent! lcd %:p:h | endif
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
if has('kaoriya')
	autocmd MyAutoCmd BufNewFile,BufRead,FocusGained * set transparency=230
endif

