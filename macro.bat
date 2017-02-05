@echo off
doskey ls=dir /w $*
doskey ll=dir /ad $*
doskey cp=copy $*
doskey pwd=echo %CD%
doskey mv=move $*
doskey tree=tree /f $b more
doskey cat=type $*
doskey h=doskey /history
doskey history=doskey /history
doskey ex=explorer %CD%
doskey pull=git pull
doskey push=git push
doskey st=git status
@echo on
