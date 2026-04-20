import-Module PSReadLine
Invoke-Expression (&'starship' init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (& { (atuin init powershell | Out-String) })
