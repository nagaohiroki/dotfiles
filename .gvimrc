﻿set visualbell t_vb=
set guioptions-=m
set guioptions-=T
set guioptions+=b
if has('vim_starting')
	set lines=60
	set columns=100
endif
if has('win32')
	set guifont=MS_Gothic:h9:cSHIFTJIS
	"set guifont=Ricty_Diminished:h10:cSHIFTJIS
	"set rop=type:directx
endif
if has('mac')
	set guifont=Osaka-Mono:h11
endif
if has('kaoriya')
	if has('win32')
		autocmd MyAutoCmd BufNewFile,BufRead,FocusGained * set transparency=220
	else
		autocmd MyAutoCmd GUIEnter * set transparency=10
	endif
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

