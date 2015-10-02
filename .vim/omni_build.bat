set DOT_VIM=%VIM%/.vim

cd %VIM%/bundle/omnisharp-vim
git submodule foreach git clean
git submodule foreach git pull origin master
patch -f -p0 < "%DOT_VIM%/0001-Corresponding-to-Japanese.patch"

cd server
git submodule foreach git clean
git submodule foreach git pull origin master
msbuild
copy "%DOT_VIM%\config.json" "OmniSharp/bin/Debug"
