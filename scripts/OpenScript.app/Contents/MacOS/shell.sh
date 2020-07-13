#!/bin/bash
source /etc/zshrc
source /etc/zprofile
cd ~
vim -g --remote-silent $*
