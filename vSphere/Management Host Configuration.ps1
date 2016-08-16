# Script Parameters
param(
    [string]$vmHost,
    [string]$username,
    [string]$password
)

# Global Variables
$mgmtPG = "Management"
$vdiPG = "VDI"
$serverPG = "Server"
$cloudPG = "Cloud"
$storagePG = "Storage"
$mgmtVLAN = "5"
$vdiVLAN = "8"
$serverVLAN = "10"
$cloudVLAN = "11"
$vMotionVLAN = "15"
$storageVLAN = "15"
$mgmtvmnic = "vmnic0", "vmnic1"
$storageIP = "10.0.0.0"
$storagenetmask = "255.255.255.0"
$iscsiTargets = "10.0.0.0", "10.0.0.0"
$nfsDS = "NFS01"
$nfsHost = "10.0.0.0"
$nfsPath = "/volume1/NFS-1"
$dns1 = "10.0.0.0"
$hostname = "esxi01"
$domain = "vcarbs.com"
$ntp1 = "pool.ntp.org"

# Loads PowerShell Modules
Add-PSSnapin VMware.VimAutomation.Core

# Connect to ESXi Host
Connect-VIServer -Server $vmHost -Username $username -Password $password


# Remove "VM Network" Port Group
$vmnetworkpg = Get-VirtualPortGroup -VirtualSwitch vSwitch0 -Name "VM Network"
Remove-VirtualPortGroup -VirtualPortGroup $vmnetworkpg -Confirm:$false


# Add vmnics to vSwitch0 | Set Port Count & MTU
Set-VirtualSwitch -VirtualSwitch vSwitch0 -NumPorts 128 -Nic $mgmtvmnic -mtu 1500 -Confirm:$false


# Prep New Port Groups
$managementpg = New-VirtualPortGroup -VirtualSwitch vSwitch0 -Name $mgmtPG -VLanId $mgmtVLAN
$serverpg = New-VirtualPortGroup -VirtualSwitch vSwitch0 -Name $serverPG -VLanId $serverVLAN
$cloudpg = New-VirtualPortGroup -VirtualSwitch vSwitch0 -Name $cloudPG -VLanId $cloudVLAN
$vdipg = New-VirtualPortGroup -VirtualSwitch vSwitch0 -Name $vdiPG -VLanId $vdiVLAN
$storagepg = New-VirtualPortGroup -VirtualSwitch vSwitch0 -Name $storagePG -VLanId $storageVLAN


# Create New Port Groups
$serverpg | Out-Null | Wait-Task
$cloudpg | Out-Null | Wait-Task
$vMotionpg | Out-Null | Wait-Task
$vdipg | Out-Null | Wait-Task


# Create VMkernel for iSCSI, vMotion & NFS
New-VMHostNetworkAdapter -VMHost $vmHost -PortGroup $storagePG -VirtualSwitch vSwitch0 -IP $storageIP -SubnetMask $storagenetmask


# Enable Software iSCSI
Get-VMHostStorage | Set-VMHostStorage -SoftwareIScsiEnabled $true


# Configure iSCSI Targets & Mount NFS
$hba = get-vmhosthba -Type iScsi
New-IScsiHbaTarget -IScsiHba $hba -Address $iscsiTargets
Get-VMHostStorage -RescanAllHba
New-Datastore -VMHost $vmHost -Nfs -Name $nfsDS -Path $nfsPath -NfsHost $nfsHost


# Allow Promiscuous for Nested Hosts
Get-SecurityPolicy -VirtualSwitch vSwitch0 | Set-SecurityPolicy -AllowPromiscuous $true


# Enable and Start SSH
Get-VMHostService -VMHost $vmHost | ?{$_.Label -eq "SSH"} | Set-VMHostService -Policy on
Get-VMHostService -VMHost $vmHost | ?{$_.Label -eq "SSH"} | Start-VMHostService -Confirm:$false

# Set DNS and NTP
Get-VMHostNetwork | Set-VMHostNetwork -HostName $hostname -DomainName $domain -DnsAddress $dns1
Add-VMHostNTPServer -NtpServer $ntp1
Get-VMHostService -VMHost $vmHost | where{$_.Key -eq "ntpd"} | Set-VMHostService -Policy on
Get-VMHostService -VMHost $vmHost | where{$_.Key -eq "ntpd"} | Restart-VMHostService -Confirm:$false