$vcenter = myvcenter

Connect-VIServer $vcenter

Get-VM | Where {$_.PowerState -eq "PoweredOn"} | Select Name, NumCpu, MemoryMB, `
@{N="CPU Usage (Maximum), %" ; E={[Math]::Round((($_ | Get-Stat -Stat cpu.usage.maximum -Start (Get-Date).AddDays(-30) | Measure-Object Value -Maximum).Maximum),2)}}, `
@{N="Memory Usage (Maximum), %" ; E={[Math]::Round((($_ | Get-Stat -Stat mem.usage.maximum -Start (Get-Date).AddDays(-30) | Measure-Object Value -Maximum).Maximum),2)}} |`

Export-Csv -Path C:\VMUsage.csv