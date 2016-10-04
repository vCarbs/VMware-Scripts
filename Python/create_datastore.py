# Author: Nick Carbone
# Description: Create a NFS datastore on an ESXi host
# Usage: python3.5 create_datastore.py

import ssl
import atexit
from pyVmomi import vim
from pyVim.connect import SmartConnect, Disconnect


#Configure SSL Properties
s = ssl.SSLContext(ssl.PROTOCOL_TLSv1)
s.verify_mode = ssl.CERT_NONE

#Configure vCenter Connection
vc = SmartConnect(host="10.0.0.0", user="administrator", pwd="password", sslContext=s)

#Create host object view
host = vc.content.searchIndex.FindByIp(None, "10.0.0.0", False)

#Add datastore to host
spec=vim.host.NasVolume.Specification()
spec.remoteHost="10.0.0.0"
spec.remotePath="/vmware"
spec.localPath="NetApp"
spec.accessMode="readWrite"

host.configManager.datastoreSystem.CreateNasDatastore(spec)