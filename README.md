# dotfiles

## install

### Windows

``` powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git
git pull git@github.com:nagaohiroki/dotfiles.git
dotfiles/install.bat

```

### macOS

``` sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git
git pull git@github.com:nagaohiroki/dotfiles.git
zsh dotfiles/install.sh
```