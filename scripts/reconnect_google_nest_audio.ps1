$dev  = Get-PnpDevice -FriendlyName "google nest audio Stereo"
Disable-PnpDevice -InstanceId $dev.instanceId -Confirm:$false
Start-Sleep -Seconds 10
Enable-PnpDevice -InstanceId $dev.instanceId -Confirm:$false
