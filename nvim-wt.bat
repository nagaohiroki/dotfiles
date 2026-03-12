set NVIM_PATH=%USERPROFILE%\scoop\shims\nvim.exe
start "" wezterm-gui start --cwd . -- %NVIM_PATH% %*
