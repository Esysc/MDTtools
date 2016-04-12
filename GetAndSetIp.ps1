
#Get the actual ip
$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1} 
$myip = $ip.ipaddress[0]

#Set the ip and gw according to cs.ini
$IP = $TSEnv:OSDIPADDRESS
$MaskBits = $TSEnv:OSDNETMASK # This means subnet mask = 255.255.255.0
$Gateway = $TSEnv:OSDGATEWAY
$IPType = "IPv4"

# Retrieve the network adapter that you want to configure
$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}

# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}

If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}

 # Configure the IP address and default gateway
$adapter | New-NetIPAddress `
    -AddressFamily $IPType `
    -IPAddress $IP `
    -PrefixLength $MaskBits `
    -DefaultGateway $Gateway

    #Set the alias ip to the previous dhcp address. You'll need to manually remove later
     $adapter | New-NetIPAddress `
     -AddressFamily $IPType `
     -IPAddress $myip `
     -PrefixLength 24 `
	 -SkipAsSource True

#Wait some time.....


ping 9.1.1.1 -n 1 -w 10000 > nul
