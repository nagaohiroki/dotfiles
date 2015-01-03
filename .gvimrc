set visualbell t_vb=
set guioptions-=m
set guioptions-=T
set guioptions+=b
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

if has('kaoriya')
	autocmd MyAutoCmd FocusGained * set transparency=230
endif
