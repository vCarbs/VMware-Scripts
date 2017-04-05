$vscServer = ""
$vmToClone = ""
$netappParentSID = "xxx3412"
$netappDestinationSID = "xxx3412"
$svm = "NAS"
$destDatastoreName = "ds01"
$esxHost = ""
$vmdkFormat = "SAME"
$memoryMB = 2048
$vCPU = 1
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

New-VscClone -virtualMachineName $vmToClone -parentStorageSystemId $netappParentSID -destStorageSystemId $netappDestinationSID -svm $svm -datastoreName $destDatastoreName -destinationHostName $esxHost -diskFormat $vmdkFormat -memorySizeInMb $memoryMB -newCloneNamesArray $nameArray -virtualProcessors $vCPU
