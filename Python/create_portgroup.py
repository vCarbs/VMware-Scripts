# Author: Nick Carbone
# Description: Create a Port Group on an ESXi host
# Usage: python3.5 create_portgroup.py

import ssl
import atexit
from pyVmomi import vim
from pyVim.connect import SmartConnect, Disconnect


#Configure SSL Properties
vccert = ssl.SSLContext(ssl.PROTOCOL_TLSv1)
vccert.verify_mode = ssl.CERT_NONE

#Configure vCenter Connection
vc = SmartConnect(host="10.0.0.0", user="administrator", pwd="password", sslContext=vccert)

#Create host object view
host = vc.content.searchIndex.FindByIp(None, "10.0.0.0", False)

#Create network security policy
policy=vim.host.NetworkPolicy()
policy.security=None
policy.nicTeaming=None
policy.offloadPolicy=None
policy.shapingPolicy=None


#Add datastore to host
pgspec=vim.host.PortGroup.Specification()
pgspec.name="VM_PortGroup"
pgspec.vlanId=0
pgspec.vswitchName="vSwitch0"
pgspec.policy=policy
host.configManager.networkSystem.AddPortGroup(pgspec)