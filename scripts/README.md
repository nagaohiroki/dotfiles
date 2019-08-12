* Unity
windows: -p --remote-tab-silent +$(Line) "$(File)"   
mac: +$(Line) "$(File)"  

* Windows regedit  
"gvim" -p --remote-tab-silent "%1"

* VisualStudio
"gvim" -p --remote-tab-silent +$(CurLine) $(ItemPath)
