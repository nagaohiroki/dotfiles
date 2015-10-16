set DOT_DIR=%DROPBOX%/dotfiles
mklink "%VIM%\.vimrc"  "%DOT_DIR%\.vimrc"
mklink "%VIM%\.gvimrc" "%DOT_DIR%\.gvimrc"
mklink /J "%VIM%\.vim" "%DOT_DIR%\.vim"
pause
