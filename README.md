# dotfiles

## Install

### Windows

```dos
git clone https://github.com/nagaohiroki/dotfiles.git
python dotfiles\setup.py
```

### Mac

```bash
git clone https://github.com/nagaohiroki/dotfiles.git
python3 dotfiles/setup.py
```

### Docker install, build, run

https://github.com/docker/docker-install#usage

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

sudo docker build -t dev https://github.com/nagaohiroki/dotfiles.git
sudo docker run -it dev
```