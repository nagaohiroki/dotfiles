cd /d "%VIM%\bundle\omnisharp-vim\server"
msbuild
copy "%VIM%\.vim\config.json" "OmniSharp\bin\Debug\config.json"
