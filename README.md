# dotfiles

## setup 

### Windows

``` powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

scoop install git
git pull git@github.com:nagaohiroki/dotfiles.git
cd dotfiles
install_app.ps1
setup.bat

```

### macOS

``` sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git
git pull git@github.com:nagaohiroki/dotfiles.git
cd dotfiles
zsh install_app.sh
zsh setup.sh
```