FROM ubuntu:latest
WORKDIR /root
RUN apt-get update 
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:neovim-ppa/stable
RUN apt-get install -y git
RUN apt-get install -y neovim
RUN apt-get install -y curl
RUN apt-get install -y npm
RUN apt-get install -y unzip
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN mkdir -p /root/.config
RUN python3 -m pip3 install --upgrade pip
RUN git clone https://github.com/nagaohiroki/dotfiles 
RUN python3 /root/dotfiles/setup.py
