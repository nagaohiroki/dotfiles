#!/bin/zsh
brew update
brew upgrade
brew cleanup
uv self update
uv tool upgrade --all
git pull
