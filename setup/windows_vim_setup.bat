cd /d "%HOMEPATH%"
git clone https://github.com/nagaohiroki/dotfiles
mklink ".vimrc"  "dotfiles/.vimrc"
mklink ".gvimrc" "dotfiles/.gvimrc"
pause
