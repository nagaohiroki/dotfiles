mkdir "%USERPROFILE%\.config"
mklink /j "%USERPROFILE%\.config\wezterm" "%USERPROFILE%\dotfiles\wezterm"
call scoop bucket add extras
call scoop install neovim
call scoop install starship
call scoop install wezterm
call scoop install git
call scoop install ripgrep
call scoop install uv
call scoop install blender
call scoop install krita
call scoop install fzf
call scoop install zoxide
call scoop install nu
call scoop install rustup
call scoop install tree-sitter
call uv tool install basedpyright
call uv tool install ruff
