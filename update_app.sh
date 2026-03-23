#!/bin/zsh
brew update
brew upgrade
brew cleanup
uv tool upgrade --all
git pull
