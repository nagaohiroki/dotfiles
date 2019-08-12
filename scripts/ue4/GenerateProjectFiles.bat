call ue4_path
call "%MY_UE4_ENGINE_DIR%\Engine\Build\BatchFiles\Build.bat" -projectfiles -project="%MY_UE4_PROJECT%" -game -rocket %*
