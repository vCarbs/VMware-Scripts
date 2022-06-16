$HcxServer = "hcx01" #Source HCX Server 
$HcxUser = "username"
$HcxPassword = 'password'
$HcxDestinationVC = "vcenter.vmwarevmc.com" #Destination vCenter Server where the VM will be migrated to
$vmName = "myvm"
$DestinationFolder = "folder"
$vmNetworkSource = "Alpha1"
$vmNetworkDestination = "L2E_Alpha1"


Connect-HCXServer -Server $HcxServer -User $HcxUser -Password $HcxPassword -Force

$HcxSrcSite = get-hcxsite -source -server $HcxServer

$HcxDstSite = get-hcxsite -destination -server $HcxServer -name $HcxDestinationVC

$HcxVM = Get-HCXVM -Name $vmName -server $HcxServer -site $HcxSrcSite

$DstFolder = Get-HCXContainer -Name $DestinationFolder -Site $HcxDstSite

$DstCompute = Get-HCXContainer -Name Compute-ResourcePool  -Site $HcxDstSite

$DstDatastore = Get-HCXDatastore -Name WorkloadDatastore -Site $HcxDstSite

$SrcNetwork = Get-HCXNetwork -Name $vmNetworkSource -type DistributedVirtualPortgroup -Site $HcxSrcSite

$DstNetwork = Get-HCXNetwork -Name $vmNetworkDestination -type NsxtSegment -Site $HcxDstSite

$NetworkMapping = New-HCXNetworkMapping -SourceNetwork $SrcNetwork -DestinationNetwork $DstNetwork


$NewMigration = New-HCXMigration -VM $HcxVM -MigrationType RAV -SourceSite $HcxSrcSite -DestinationSite $HcxDstSite -Folder $DstFolder `
-TargetComputeContainer $DstCompute -TargetDatastore $DstDatastore -NetworkMapping $NetworkMapping -DiskProvisionType Thin `
-RemoveSnapshots $True
Start-HCXMigration -Migration $NewMigration -Confirm:$false
