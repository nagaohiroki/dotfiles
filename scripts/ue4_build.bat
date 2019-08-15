@echo off
set MY_UE4_ENGINE_DIR=D:\work\UE4\UE_4.22
set MY_UE4_PROJECT_DIR=D:\work\UE4\UE4MyGame\MyProject
set MY_UE4_PROJECT_NAME=MyProject
%MY_UE4_ENGINE_DIR%\Engine\Build\BatchFiles\Build.bat %MY_UE4_PROJECT_NAME%Editor Win64 Development -Project="%MY_UE4_PROJECT_DIR%\%MY_UE4_PROJECT_NAME%.uproject" -WaitMutex -FromMsBuild
@echo on
