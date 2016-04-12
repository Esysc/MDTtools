On Error Resume Next
Dim strComputer
Dim objWMIService
Dim objNetAdapter
Dim colNetAdapters
dim errEnable, errDNS, errDDNS

strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colNetAdapters = objWMIService.ExecQuery _
    ("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE")
For Each objNetAdapter In colNetAdapters
    'this line to enable DHCP
    errEnable = objNetAdapter.EnableDHCP()
    'this line to clear the DNS entry's
    errDNS = objNetAdapter.SetDNSServerSearchOrder()
    'this line to enable the automatic DNS settings by DHCP
    errDDNs = objNetAdapter.SetDynamicDNSRegistration
Next
