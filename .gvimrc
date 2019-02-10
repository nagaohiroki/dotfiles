set guioptions-=m
set guioptions-=T
set guioptions+=b
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
augroup gvimrc_loading
	autocmd!
	if has('mac')
		autocmd GUIEnter * set transparency=10
	endif
augroup END
command! RcUpdate source ~/dotfiles/.vimrc | source ~/dotfiles/.gvimrc
set background=dark
colorscheme iceberg
nnoremap <S-Left>  :set columns-=100<CR>
nnoremap <S-Right> :set columns+=100<CR>
nnoremap <S-Up>  :set lines-=10<CR>
nnoremap <S-Down> :set lines+=10<CR>
inoremap <ESC> <ESC>:set iminsert=0<CR>
nnoremap <ESC> <ESC>:set iminsert=0<CR>
highlight CursorIM guifg=NONE guibg=Red
