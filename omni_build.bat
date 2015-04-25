cd omnisharp-vim
git submodule foreach git clean
git submodule foreach git pull origin master
cd server
msbuild
cd ../../
copy "config.json" "omnisharp-vim/server/OmniSharp/bin/Debug"
pause
