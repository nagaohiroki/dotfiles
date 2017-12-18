set guioptions-=m
set guioptions-=T
set visualbell t_vb=
if has('vim_starting')
	set lines=65
	set columns=90
endif
if has('win32')
	set guifont=Migu_1M:h10
endif
if has('mac')
	set guifont=Osaka-Mono:h14
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
colorscheme iceberg
set background=dark
if has('multi_byte_ime') || has('xim')
	hi CursorIM guibg=Red guifg=NONE
endif
command! RcUpdate source ~/dotfiles/.vimrc | source ~/dotfiles/.gvimrc
