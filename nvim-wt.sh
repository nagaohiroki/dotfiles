#!/bin/zsh
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
/Applications/WezTerm.app/Contents/MacOS/wezterm start -- nvim "$@"
