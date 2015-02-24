set visualbell t_vb=
set guioptions-=m
set guioptions-=T
set guioptions+=b
if has('vim_starting')
	set lines=80
	set columns=100
endif
if has('win32')
	set guifont=MS_Gothic:h9:cSHIFTJIS
	set linespace=1
	set renderoptions=type:directx
endif
"--------------------------------------------------------------------------
"colorscheme
"--------------------------------------------------------------------------
colorscheme desert
colorscheme iceberg
set background=dark
if has('multi_byte_ime') || has('xim')
	hi CursorIM guibg=Red guifg=NONE
endif

nnoremap <Space>u :source $MYVIMRC<CR>:source $MYGVIMRC<CR>

