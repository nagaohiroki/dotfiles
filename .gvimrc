set visualbell t_vb=
set guioptions-=m
set guioptions-=T
set guioptions+=b
if has('vim_starting')
	set lines=60
	set columns=100
endif
if has('win32')
	" set guifont=MS_Gothic:h9:cSHIFTJIS
	set guifont=Ricty_Diminished:h11:cSHIFTJIS
	set linespace=1
endif
if has('kaoriya')
	autocmd MyAutoCmd BufNewFile,BufRead,FocusGained * set transparency=220
endif
"--------------------------------------------------------------------------
"colorscheme
"--------------------------------------------------------------------------
" colorscheme desert
colorscheme iceberg
set background=dark
if has('multi_byte_ime') || has('xim')
	hi CursorIM guibg=Red guifg=NONE
endif

nnoremap <Space>u :source $MYVIMRC<CR>:source $MYGVIMRC<CR>

