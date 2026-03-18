import-Module PSReadLine
Invoke-Expression (&'starship' init powershell)
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
