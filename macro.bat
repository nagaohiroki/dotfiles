@echo off
doskey ls=dir /w /d /b $*
doskey cp=copy $*
doskey pwd=echo %CD%
doskey mv=move $*
doskey tree=tree /f $*
doskey cat=type $*
doskey cd=cd /d $*
doskey h=doskey /history $*
doskey history=doskey /history $*
doskey ex=explorer $*
doskey excd=explorer %CD%
doskey vi=gvim $*
doskey vim=gvim $*
doskey gvim=gvim $*
doskey ps=powershell $*
doskey dot=cd /d %USERPROFILE%\dotfiles
@echo on
