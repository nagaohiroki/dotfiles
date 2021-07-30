#!/bin/bash
cd "$1"
/Applications/MacVim.app/Contents/bin/mvim --remote-silent +"$3" "$2"
# $(ProjectPath) $(File) $(Line)
