rem C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat
rem ↑から開始する。バージョンに注意
cmake -G "NMake Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON  .
