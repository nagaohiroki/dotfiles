cd /d "%VIM%\bundle\omnisharp-vim\server"
git checkout master
git pull
cd /d "cecil"
git checkout master
git pull
cd ../
cd /d "NRefactory"
git checkout master
git pull
cd ../
msbuild
copy "%VIM%\.vim\config.json" "OmniSharp\bin\Debug\config.json"
