set visualbell t_vb=
set guioptions-=m
set guioptions-=T
set guioptions+=b
set lines=60
set columns=80
if has('win32')
	set guifont=MS_Gothic:h9:cSHIFTJIS
	set linespace=1
endif
"--------------------------------------------------------------------------
"colorscheme
"--------------------------------------------------------------------------
colorscheme darkblue
colorscheme iceberg
set background=dark
if has('multi_byte_ime') || has('xim')
	hi CursorIM guibg=Red guifg=NONE
endif

nnoremap <Space>u :source $MYVIMRC<CR>:source $MYGVIMRC<CR>
if has('kaoriya')
	autocmd MyAutoCmd FocusGained * set transparency=230
endif
