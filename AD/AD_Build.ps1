# Domain Controller Deployment Script
# Install Required Windows Features
Install-WindowsFeature AD-Domain-Services, DHCP, DNS -IncludeAllSubFeature -IncludeManagementTools

# AD DS Configuration

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainName "vcarbs.local" `
-DomainNetbiosName "VCARBS" `
-ForestMode "Win2012R2" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true