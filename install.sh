#!/bin/zsh
mkdir -p ~/.config
ln -sf ~/dotfiles/wezterm ~/.config/wezterm
ln -sf ~/dotfiles/.zshenv ~/.zshenv
brew install neovim
brew install uv
brew install starship
brew install git
brew install ripgrep
brew install zoxide
brew install fzf
brew install nushell
brew install rustup
brew install tree-sitter-cli
brew install --cask wezterm
brew install --cask blender
brew install --cask krita
uv tool install basedpyright
uv tool install ruff
