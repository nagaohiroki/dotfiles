cd omnisharp-vim
git submodule foreach git clean
git submodule foreach git pull origin master
cd server
git submodule foreach git clean
git submodule foreach git pull origin master
msbuild
cd ../../
copy "config.json" "omnisharp-vim/server/OmniSharp/bin/Debug"
pause
