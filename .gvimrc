set guioptions-=m
set guioptions-=T
set visualbell t_vb=
if has('vim_starting')
	set lines=65
	set columns=90
endif
if has('win32')
	" set guifont=MS_Gothic:h10:cSHIFTJIS
	" git clone https://github.com/edihbrandon/RictyDiminished
	set guifont=Ricty_Diminished:h11:cSHIFTJIS
	" set rop=type:directx
endif
if has('mac')
	set guifont=Osaka-Mono:h11
endif
if has('kaoriya')
	if has('win32')
		autocmd BufNewFile,BufRead,FocusGained * set transparency=220
	endif
	if has('mac')
		autocmd GUIEnter * set transparency=10
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
command! RcUpdate source ~/dotfiles/.vimrc | source ~/dotfiles/.gvimrc
