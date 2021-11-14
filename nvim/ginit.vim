if exists('g:GuiLoaded')
	GuiScrollBar 1
	GuiWindowOpacity 0.9
	if has('mac')
		Guifont! Monaco:h13
	endif
	if has('win32')
		Guifont! Migu\ 1M:h12
	endif
endif
