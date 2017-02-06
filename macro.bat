@echo off
doskey ls=dir /w $*
doskey ll=dir /ad $*
doskey cp=copy $*
doskey pwd=echo %CD%
doskey mv=move $*
doskey tree=tree /f $b more
doskey cat=type $*
doskey h=doskey /history $*
doskey history=doskey /history $*
doskey ex=explorer %CD%
doskey vi=gvim $*
doskey vim=gvim $*
doskey gvim=gvim $*
doskey ps=powershell $*
doskey dot=cd /d %USERPROFILE%\dotfiles
@echo on
