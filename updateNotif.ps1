$Msg = $TSEnv:Status
$PerCent = $TSEnv:PercentComplete
$So =  $TSEnv:So
$Rack = $TSEnv:Rack
$Shelf = $TSEnv:Shelf
$RackShelf = $Rack + "_" + $Shelf
$PK = "[" + $So + "][" + $RackShelf + "]"
$URL="http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/" + $PK
$body = @{
notifid = $PK
status = $Msg
progress = $PerCent
}
if (Get-Command  'Invoke-RestMethod' ) {
   invoke-RestMethod $URL -Method Put -ContentType "json" -Body (ConvertTo-Json $body) -UserAgent "perl" 
}
Else {
$bytes = [System.Text.Encoding]::ASCII.GetBytes($body)
$web = [System.Net.WebRequest]::Create("$URL")
$web.Method = "PUT"
$web.ContentType = "application/json"
$web.ContentLength = $bytes.Length
$web.UserAgent = "perl"
$stream = $web.GetRequestStream()
$stream.Write($bytes,0,$bytes.Length)
$stream.close()
}



