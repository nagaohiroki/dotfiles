#!/bin/bash
source /etc/zshrc
source /etc/zprofile
cd ~
mvim $*
# -g --remote-silent +$(Line) $(File)
