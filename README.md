# dotfiles

## Install

### Windows

```dos
git clone https://github.com/nagaohiroki/dotfiles.git
cd %USERPROFILE%\dotfiles\scripts
windows_vim_setup.bat
```

### Mac

```bash
git clone https://github.com/nagaohiroki/dotfiles.git
cd ~/dotfiles/scripts
chmod +x setup.sh
./setup.sh
```

### Docker install, build, run

https://github.com/docker/docker-install#usage

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

sudo docker build -t dev https://github.com/nagaohiroki/dotfiles.git
sudo docker run -it dev
```


## Use Plugins

nvim command

```
:PackerInit
:PackerUpdate
```