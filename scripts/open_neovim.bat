python "%~dp0\open_neovim.py" %*
rem for /f %%a in (%USERPROFILE%\nvim_env.txt) do (nvim-qt -- --server "%%a" --remote-tab-silent %*)
