# Run windows update offline
# You can update this local repo by running the dedicated script in sh directory
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

#Setting Vars 
$DoUpdate = "DoUpdate.cmd"
cd Z:\MDT\Scripts\wsusoffline\client\cmd
#Performing Action



#Performing Action 
restNotif "Windows Updates Wrapper:  Initializing Windows Updates......... Please be patience, it takes some time...."


#Start the updates

& .\$DoUpdate | & {
    process {
        restNotif "Windows Updates Wrapper: $_"
        Start-Sleep -Seconds 1
    }
}
 

restNotif  "Windows updates terminated"

exit 3010
