#
# Clean of bullshit wins apps
#

#  remove all Modern apps from the system account

function restNotif ($msg) {
        $So =  $TSEnv:So
                $Rack = $TSEnv:Rack
                $Shelf = $TSEnv:Shelf
                $RackShelf = $Rack + "_" + $Shelf
                $PK = "[" + $So + "][" + $RackShelf + "]"
                $URL="http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/" + $PK
                $body = @{
                        notifid = $PK
                                status = $msg
                }
        invoke-RestMethod $URL -Method Put -ContentType "json" -Body (ConvertTo-Json $body) -UserAgent "perl"



}



Get-AppXProvisionedPackage -online | Remove-AppxProvisionedPackage -online | & {
    process {
        restNotif("Remove Windows Shit Apps: $_")
        Start-Sleep -Seconds 1
    }
}


#  remove all Modern apps from your all user account

Get-AppxPackage -AllUsers | Remove-AppxPackage | & {
    process {
        restNotif("Remove Windows Shit Apps: $_")
        Start-Sleep -Seconds 1
    }
}



exit 0
