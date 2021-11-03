if exists('g:GuiLoaded')
	GuiScrollBar 1
	if has('mac')
		Guifont! Monaco:h13
		GuiWindowOpacity 0.9
	endif
	if has('win32')
		Guifont! Migu\ 1M:h12
	endif
endif
