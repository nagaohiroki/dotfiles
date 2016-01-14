set DOT_VIM=%VIM%\.vim

cd /d %VIM%/bundle/omnisharp-vim
git submodule foreach git pull origin master

cd /d server
git submodule foreach git pull origin master
msbuild
copy "%DOT_VIM%\config.json" "OmniSharp/bin/Debug"
