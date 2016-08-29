cd /d "%HOMEPATH%"
set BUNDLE_DIR="bundle"
@if not exist %BUNDLE_DIR% (  
	mkdir %BUNDLE_DIR%
	cd %BUNDLE_DIR%
	git clone https://github.com/Shougo/neobundle.vim
)
mklink ".vimrc"  "%DOT_DIR%\.vimrc"
mklink ".gvimrc" "%DOT_DIR%\.gvimrc"
mklink /J ".vim" "%DOT_DIR%\.vim"
pause
