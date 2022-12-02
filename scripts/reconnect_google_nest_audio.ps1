$id = 'BTHENUM\{0000110E-0000-1000-8000-00805F9B34FB}_VID&0001000F_PID&1200\7&2CDD7520&0&14C14EC70853_C00000000'
Disable-PnpDevice -InstanceId $id -Confirm:$false
Start-Sleep -Seconds 10
Enable-PnpDevice -InstanceId $id -Confirm:$false
