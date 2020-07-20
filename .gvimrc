set guioptions-=m
set guioptions-=T
set guioptions+=b
set visualbell t_vb=
if has('vim_starting')
	set lines=65
	set columns=90
endif
if has('win32')
	set guifont=Migu_1M:h11
endif
if has('mac')
	set guifont=Osaka-Mono:h14
endif
set background=dark
colorscheme iceberg
highlight CursorIM guifg=NONE guibg=Red
