" --------------------------------------------------------------------------
"
"  === Unity3D argment ===
"
" -p --remote-tab-silent +$(Line) $(File) 
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
" --------------------------------------------------------------------------
" --------------------------------------------------------------------------
" Initialize
" --------------------------------------------------------------------------
scriptencoding utf-8
let $LANG='ja'
if !exists('$PROJECT')
	let $PROJECT='D:\work\svn\unity_fps\trunk'
endif
" --------------------------------------------------------------------------
" https://github.com/Shougo/neobundle.vim
" --------------------------------------------------------------------------
if has('vim_starting')
	set runtimepath+=$VIM/bundle/neobundle.vim
endif
call neobundle#begin(expand($VIM . '/bundle'))
if neobundle#has_fresh_cache(expand($VIM . '/_vimrc'))
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
	NeoBundleSaveCache
endif
call neobundle#end()
filetype plugin indent on
NeoBundleCheck
syntax on
" -------------------------------------------------------------------------
" cscope ctags
" -------------------------------------------------------------------------
if has('cscope')
	set cscopequickfix=s-,c-,d-,i-,t-,e-
	cs add $PROJECT/cscope.out $PROJECT
endif
set tags+=$PROJECT/tags
" -------------------------------------------------------------------------
" AutoCommandGroup
" -------------------------------------------------------------------------
augroup MyAutoCmd
  autocmd!
augroup END
" -------------------------------------------------------------------------
" https://github.com/Shougo/unite.vim
" -------------------------------------------------------------------------
let g:unite_enable_ignore_case=1
let g:unite_enable_start_insert=1
nnoremap ,f :Unite file<CR>
nnoremap ,b :Unite buffer<CR>
nnoremap ,m :Unite file_mru<CR>
nnoremap ,r :Unite register<CR>
autocmd MyAutoCmd FileType unite nnoremap <buffer> <expr> <C-CR>   unite#do_action('split')
autocmd MyAutoCmd FileType unite inoremap <buffer> <expr> <C-CR>   unite#do_action('split')
autocmd MyAutoCmd FileType unite nnoremap <buffer> <expr> <C-S-CR> unite#do_action('vsplit')
autocmd MyAutoCmd FileType unite inoremap <buffer> <expr> <C-S-CR> unite#do_action('vsplit')
" --------------------------------------------------------------------------
" https://github.com/Shougo/neocomplete.vim
" --------------------------------------------------------------------------
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_ignore_case=1
let g:neocomplete#enable_insert_char_pre=1
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns={}
endif
let g:neocomplete#sources#omni#input_patterns.c='[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp='[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.cs='[^.[:digit:] *\t]\%(\.\|->\)'
" --------------------------------------------------------------------------
" https://github.com/vim-scripts/DoxygenToolkit.vim
" --------------------------------------------------------------------------
nnoremap ,d :Dox<CR>
let g:DoxygenToolkit_blockHeader='------------------------------------------------------------------------'
let g:DoxygenToolkit_blockFooter='------------------------------------------------------------------------'
let g:DoxygenToolkit_commentType='C++'
" --------------------------------------------------------------------------
" https://github.com/tyru/open-browser.vim
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
	call setpos(".",pos)
endfunction
command! Astyle :call Astyle()
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
set autoindent
set cindent
set smartindent
set nowrap
set noswapfile
set tabstop=4
set clipboard+=unnamed
set incsearch
set hlsearch
set hidden
set helplang=ja
set matchpairs+=<:>
set nrformats=hex
set autoread
set notimeout
set formatoptions=q
set completeopt=menuone
set lazyredraw
set ttyfast
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
inoremap <C-Q> <C-R>=strftime("%Y/%m/%d %H:%M")<CR>
nnoremap <C-P> "0p
vnoremap <C-P> "0p
nnoremap <C-J> :cn<CR>
nnoremap <C-k> :cp<CR>
inoremap <expr> <TAB>     pumvisible() ? "\<Down>"    : "\<Tab>"
inoremap <expr> <S-TAB>   pumvisible() ? "\<Up>"      : "\<S-Tab>"
inoremap <expr> <C-Space> pumvisible() ? "\<C-E>"     : "\<C-N><C-P>"
nnoremap <expr> <Space>w (&wrap) ? "\:set nowrap<CR>" : "\:set wrap<CR>"
nnoremap <Space>u :source $MYVIMRC<CR>:source $MYGVIMRC<CR>
nnoremap <Space>v :tabe $MYVIMRC<CR>
nnoremap <Space>l :set columns+=50<CR>
nnoremap <Space>h :set columns-=50<CR>
nnoremap <Space>j :set lines+=20<CR>
nnoremap <Space>k :set lines-=20<CR>
nnoremap <Space>ct :cd $PROJECT<CR>:!ctags -R<CR>
nnoremap <Space>cs :cd $PROJECT<CR>:!cscope -R -b<CR>
nnoremap <Space>s :%s /\<<C-R><C-W>\>//g<Left><Left>
nnoremap <Space>g :vim /<C-R><C-W>/**/*.*
nnoremap <Space>f :cs find d <C-R><C-W><CR>:cwin<CR>
" ----------------------------------------------------------------------
" AutoCommand
" ---------------------------------------------------------------------
autocmd MyAutoCmd BufNewFile,BufRead fcg,vcg,shader,cg      set filetype=cg
autocmd MyAutoCmd BufNewFile,BufRead *.fx,*.fxc,*.fxh,*.hlsl,*.pssl set filetype=hlsl
autocmd MyAutoCmd BufNewFile,BufRead *.xml,*.dae nnoremap <Space>x :%s/></>\r</g<CR>:setf xml<CR>:normal gg=G<CR>
autocmd MyAutoCmd FocusGained,BufNewFile,BufRead,BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
autocmd MyAutoCmd VimEnter * set lines=60 columns=80
