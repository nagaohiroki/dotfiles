call ue4_path.bat
cd /d "%MY_UE4_PROJECT_DIR%"
ctags --languages=c++ -R "%MY_UE4_ENGINE_DIR%\Engine\Source"
ctags --languages=c++ -a -R Source
