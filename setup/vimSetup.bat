set DOT_DIR=%DROPBOX%/dotfiles
mklink "%HOMEPATH%\.vimrc"  "%DOT_DIR%\.vimrc"
mklink "%HOMEPATH%\.gvimrc" "%DOT_DIR%\.gvimrc"
mklink /J "%HOMEPATH%\.vim" "%DOT_DIR%\.vim"
pause
