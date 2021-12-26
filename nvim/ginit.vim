if exists('g:GuiLoaded')
	GuiScrollBar 1
	GuiWindowOpacity 0.95
	if has('mac')
		let g:fontName='Guifont! Monaco:h'
		let g:fontSize=13
	endif
	if has('win32')
		let g:fontName='Guifont! Migu\ 1M:h'
		let g:fontSize=12
	endif
	function! FontSize(inc)
		let g:fontSize+=a:inc
		if(g:fontSize < 1)
			let g:fontSize=1
		endif
		execute g:fontName . g:fontSize
	endfunction
	call FontSize(0)
	nnoremap + :call FontSize(1)<CR>
	nnoremap - :call FontSize(-1)<CR>
endif
