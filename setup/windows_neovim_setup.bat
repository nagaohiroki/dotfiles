mkdir "%USERPROFILE%\AppData\Local\nvim"
mklink "%USERPROFILE%\AppData\Local\nvim\init.vim"  "%USERPROFILE%\dotfiles\.vimrc"
mklink "%USERPROFILE%\AppData\Local\nvim\ginit.vim"  "%USERPROFILE%\dotfiles\.gvimrc"
pause
