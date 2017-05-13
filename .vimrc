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
" -------------------------------------------------------------------------
" Project
" -------------------------------------------------------------------------
function! InitProject(project_paths)
	for p in a:project_paths
		let l:proj=fnameescape(expand(p))
		execute 'set tags+=' . l:proj . '/tags'
		execute 'set path+=' . l:proj
	endfor
	let g:grep_root=fnameescape(expand(a:project_paths[0]))
endfunction
function! GenerateCtags(project_paths)
	for p in a:project_paths
		let l:proj=fnameescape(expand(p))
		if has('win32')
			execute '!start cd /d ' . l:proj . ' && ctags -R'
		else
			execute 'cd ' . l:proj . ' && ctags -R'
		endif
	endfor
endfunction
command! GenerateCtags call GenerateCtags(g:project_paths)

if exists('g:project_paths')
	call InitProject(g:project_paths)
endif
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
Plug 'Shougo/neocomplete.vim'
Plug 'cocopon/iceberg.vim'
Plug 'tyru/open-browser.vim'
Plug 'scrooloose/syntastic'
Plug 'aklt/plantuml-syntax'
Plug 'h1mesuke/vim-alignta'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'beyondmarc/hlsl.vim'
Plug 'PProvost/vim-ps1'
Plug 'timcharper/textile.vim'
Plug 'vim-scripts/cg.vim'
Plug 'vim-scripts/Tagbar'
Plug 'vim-scripts/gtags.vim'
Plug 'cohama/agit.vim'
Plug 'tpope/vim-fugitive'
Plug 'juneedahamed/svnj.vim'
Plug 'kannokanno/previm'
Plug 'kana/vim-altr'
Plug 'davidhalter/jedi-vim', {'for': ['python']}
Plug 'OmniSharp/omnisharp-vim', {'for': ['cs']}
Plug 'fatih/vim-go', {'for': ['go']}
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
" gtags
" --------------------------------------------------------------------------
nnoremap <F11> :CdCurrent<CR>:GtagsCursor<CR>
" --------------------------------------------------------------------------
" open-browser
" --------------------------------------------------------------------------
nmap <Space>o <Plug>(openbrowser-smart-search)
" ----------------------------------------------------------------------
" artr
" ---------------------------------------------------------------------
nmap <Space>h <Plug>(altr-forward)
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
function! SetupOmniSharp()
	let g:OmniSharp_sln_list_index=1
	let g:OmniSharp_timeout=30
	let g:OmniSharp_selector_ui='unite'
	let g:OmniSharp_server_type='v1'
	nnoremap <F12> :OmniSharpGotoDefinition<CR>
	nnoremap <S-F12> :OmniSharpFindUsages<CR>
	nnoremap <C-F12> :OmniSharpReloadSolution \| OmniSharpHighlightTypes<CR>
endfunction
autocmd MyAutoCmd Filetype cs call SetupOmniSharp()
let g:csharp_compiler=has('win32') ? 'C:/Windows/Microsoft.NET/Framework/v4.0.30319/msbuild' : 'xbuild'
command! OmniBuild execute '!' . g:csharp_compiler . ' ' . expand('~/vim-plug/omnisharp-vim/server/OmniSharp.sln')
" -------------------------------------------------------------------------
" unite
" -------------------------------------------------------------------------
call unite#custom#source('file_mru,file,file_rec', 'ignore_pattern', '\.meta$' )
nnoremap <Space>r :Unite -start-insert -path=<C-R>=g:grep_root<CR> file_rec<CR>
nnoremap <Space>f :Unite -start-insert file -path=<C-R>=fnameescape(expand('%:p:h'))<CR><CR>
nnoremap <Space>m :Unite -start-insert file_mru<CR>
nnoremap <Space>c :Unite -start-insert outline<CR>
" --------------------------------------------------------------------------
" neocomplete
" --------------------------------------------------------------------------
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_ignore_case=1
" --------------------------------------------------------------------------
" DoxygenToolkit
" --------------------------------------------------------------------------
let g:DoxygenToolkit_blockHeader='------------------------------------------------------------------------'
let g:DoxygenToolkit_blockFooter='------------------------------------------------------------------------'
let g:DoxygenToolkit_commentType='C++'
" --------------------------------------------------------------------------
" altr
" --------------------------------------------------------------------------
call altr#define('Private/%.cpp', 'Public/%.h')
" --------------------------------------------------------------------------
" shader syntax
" --------------------------------------------------------------------------
autocmd MyAutoCmd BufNewFile,BufRead *.fcg,*.vcg,*.shader,*.cg,*.compute,*.cginc set filetype=cg
autocmd MyAutoCmd BufNewFile,BufRead *.fx,*.fxc,*.fxh,*.hlsl,*.pssl set filetype=hlsl
" --------------------------------------------------------------------------
" Setting
" --------------------------------------------------------------------------
set autoindent
set autoread
set cindent
set clipboard+=unnamedplus,unnamed
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
set smartcase
set ignorecase
set statusline=%<%f\ %m%r%h%w
set statusline+=[%Y]%{'['.(&fenc!=''?&fenc:&enc).(&bomb?'_bom':'').']['.&fileformat.']'}
set statusline+=%=%l/%L,%c%V%8P
set tabstop=4
set title
set undolevels=1000
set undodir=$HOME/.cache
set undofile
set whichwrap=b,s,h,l,<,>,[,]
set mouse=a
set visualbell t_vb=
" ----------------------------------------------------------------------
" mapping
" ----------------------------------------------------------------------
nnoremap <S-Up>    :set lines-=10<CR>
nnoremap <S-Down>  :set lines+=10<CR>
nnoremap <S-Left>  :set columns-=100<CR>
nnoremap <S-Right> :set columns+=100<CR>
inoremap <C-c> <Esc>
nnoremap <C-j> :cn<CR>zz
nnoremap <C-k> :cp<CR>zz
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap <Space>s :%s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <Space>g :vim/<C-R><C-W>/<C-R>=g:grep_root<CR>/**/*.*
nnoremap <Space>v :tabe ~/dotfiles/.vimrc<CR>
nnoremap <Space>u :source $MYVIMRC<CR>
inoremap <expr> <C-Space> pumvisible() ? '<C-e>' : '<C-x><C-o><C-p>'
inoremap <expr> <TAB>     pumvisible() ? '<Down>': '<Tab>'
inoremap <expr> <S-TAB>   pumvisible() ? '<Up>'  : '<S-Tab>'
" ----------------------------------------------------------------------
" change terminal cursol size
" ---------------------------------------------------------------------
if !has('win32')
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
	inoremap <Esc> <Esc>
endif
" ----------------------------------------------------------------------
" AutoCommand
" ---------------------------------------------------------------------
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
" ----------------------------------------------------------------------
" Command
" ---------------------------------------------------------------------
command! CopyPath call setreg('*', expand('%:p') . ' ' . line('.'))
command! DateTime normal i<C-R>=strftime("%Y/%m/%d %H:%M:%S")<CR>
if has('win32')
	command! Term !start cmd /k cd /d "%:p:h"
	command! Wex echo system('explorer /select,"' . expand('%:p') . '"')
endif
if has('mac')
	command! Term !open -a iTerm %:p:h
	command! Wex execute '!open ' .  expand('%:p:h')
endif
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
" UE4
" ---------------------------------------------------------------------
function! UE4Build(build_bat)
	execute 'set makeprg=' . a:build_bat
	make
	let qflist = getqflist()
   for i in qflist
	  let i.text=iconv(i.text, "cp932", "utf-8")
   endfor
   call setqflist(qflist)
   cwindow
endfunction

command! UE4Build call UE4Build('~/ue4build.bat')
