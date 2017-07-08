<<<<<<< HEAD
$vscServer = "" #NetApp Virtual Storage Console IP or Hostname
$vmToClone = "" #vSphere VM to clone
$netappParentSID = "xxx3412" #NetApp Array Parent SID
$netappDestinationSID = "xxx3412" #NetApp Array Destination SID
$svm = "NAS" #SVM that hosts the vSphere datastore
$destDatastoreName = "ds01" #vSphere datastore name
$esxHost = "" #ESXi host for VM provisioning
$vmdkFormat = "SAME" #VMDK format
$memoryMB = 2048 #VM memory size in MB
$vCPU = 1 #VM vCPU
=======
$vscServer = "vsc01"
$vmToClone = "myVM"
$netappParentSID = "xxx3412"
$netappDestinationSID = "xxx3412"
$svm = "NAS"
$destDatastoreName = "ds01"
$esxHost = "esx01"
$vmdkFormat = "SAME"
$memoryMB = 2048
$vCPU = 1
>>>>>>> origin/master
#cloneName = [Edit this in the array workflow.]
#numberOfVMs [Edit this in the array workflow. 1-100]


workflow array {
	foreach -parallel ($_ in 1..5) {
		$workflow:i++
		$a = "SERVERNAME"
		"$a$i"
	}
}

$nameArray = array

Connect-VscServer -Server $vscServer

New-VscClone -virtualMachineName $vmToClone `
    -parentStorageSystemId $netappParentSID `
    -destStorageSystemId $netappDestinationSID `
    -svm $svm `
    -datastoreName $destDatastoreName `
    -destinationHostName $esxHost `
    -diskFormat $vmdkFormat `
    -memorySizeInMb $memoryMB `
    -newCloneNamesArray $nameArray `
    -virtualProcessors $vCPU
