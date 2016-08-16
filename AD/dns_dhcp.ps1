# Configure DNS & DHCP
# Prep Reverse Lookup Zones
$lookups = @("10.1.1.0/24", "10.1.1.0/24", "10.1.1.0/24")

# Configure DNS
Add-DnsServerPrimaryZone -Name "vcarbs.com" -ReplicationScope "Forest" -PassThru
foreach ($lookup in $lookups) {
    Add-DnsServerPrimaryZone -NetworkID $lookup -ReplicationScope "Forest" 
}

# Configure DHCP - For loop needs to be added
Add-DhcpServerv4Scope -Name "VDI - 10.1.1.0" -StartRange 10.1.1.50 -EndRange 10.1.1.150 -SubnetMask 255.255.255.0
Set-DhcpServerv4DnsSetting -DynamicUpdates Always -DeleteDnsRRonLeaseExpiry $True
Set-DhcpServerv4OptionValue -ScopeId 10.1.1.0 -DnsServer 10.1.1.2 -DnsDomain vcarbs.com -Router 10.1.1.1

Add-DhcpServerv4Scope -Name "Server - 10.1.1.0" -StartRange 10.1.1.50 -EndRange 10.1.1.150 -SubnetMask 255.255.255.0
Set-DhcpServerv4DnsSetting -DynamicUpdates Always -DeleteDnsRRonLeaseExpiry $True
Set-DhcpServerv4OptionValue -ScopeId 10.1.1.0 -DnsServer 10.1.1.2 -DnsDomain vcarbs.com -Router 10.1.1.1

Add-DhcpServerv4Scope -Name "Cloud - 10.1.1.0" -StartRange 10.1.1.50 -EndRange 10.1.1.150 -SubnetMask 255.255.255.0
Set-DhcpServerv4DnsSetting -DynamicUpdates Always -DeleteDnsRRonLeaseExpiry $True
Set-DhcpServerv4OptionValue -ScopeId 10.1.1.0 -DnsServer 10.1.1.2 -DnsDomain vcarbs.com -Router 10.1.1.1