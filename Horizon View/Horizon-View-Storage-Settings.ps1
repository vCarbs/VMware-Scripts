$datastoreSettings = '[Aggressive,OS,data]/Path/to/Datastore'
$pools = get-pool
foreach ($pool in $pools) {
	Update-AutomaticLinkedClonePool -Pool_id $pool.pool_id -DatastoreSpecs $datastoreSettings
}