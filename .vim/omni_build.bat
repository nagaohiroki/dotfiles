cd /d "%VIM%/bundle/repos/github.com/OmniSharp/omnisharp-vim"
git submodule update --init --recursive
cd  server
msbuild
copy "%VIM%\.vim\config.json" "%VIM%\bundle\.dein\server\OmniSharp\bin\Debug\config.json"
