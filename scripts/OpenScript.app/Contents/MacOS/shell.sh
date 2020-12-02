#!/bin/bash
source /etc/zshrc
source /etc/zprofile
cd ~
/Applications/MacVim.app/Contents/bin/mvim $*
# --remote-silent +$(Line) $(File)
