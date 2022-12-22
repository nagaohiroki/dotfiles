# sudo docker build -t dev .
# sudo docker run -it dev
FROM ubuntu:latest
WORKDIR /root
RUN apt-get update 
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:neovim-ppa/stable
RUN apt-get install -y git
RUN apt-get install -y neovim
RUN apt-get install -y curl
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade neovim
RUN git clone https://github.com/nagaohiroki/dotfiles 
RUN git clone https://github.com/wbthomason/packer.nvim /root/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN mkdir -p /root/.config
RUN ln -s /root/dotfiles/nvim /root/.config/nvim
