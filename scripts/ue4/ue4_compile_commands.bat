call ue4_path.bat
call "%VS_COMMON_DIR%\Tools\VsDevCmd.bat"
cmake -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
