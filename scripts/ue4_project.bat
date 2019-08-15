@echo off
set MY_UE4_ENGINE_DIR=D:\work\UE4\UE_4.22
set MY_UE4_PROJECT_DIR=D:\work\UE4\UE4MyGame\MyProject
set MY_UE4_PROJECT_NAME=MyProject
set GENERATE_CMD="%MY_UE4_ENGINE_DIR%\Engine\Build\BatchFiles\Build.bat" -projectfiles -project="%MY_UE4_PROJECT_DIR%\%MY_UE4_PROJECT_NAME%.uproject" -game -rocket
if exist %MY_UE4_ENGINE_DIR%\GenerateProjectFiles.bat (
	pushd %MY_UE4_ENGINE_DIR%
	call "GenerateProjectFiles.bat"
	call "GenerateProjectFiles.bat" -CMakefile
) else (
	pushd %MY_UE4_PROJECT_DIR%
	call %GENERATE_CMD%
	call %GENERATE_CMD% -CMakefile
)
call "%VS_COMMON_DIR%\Tools\VsDevCmd.bat"
start cmake -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
rem start ctags --languages=c++ --output-format=e-ctags -R "%MY_UE4_ENGINE_DIR%\Engine\Source" -R "%MY_UE4_PROJECT_DIR%\Source"
@echo on
