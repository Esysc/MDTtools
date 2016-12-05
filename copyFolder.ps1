$TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment


function restNotif ($msg) {
	$So =  $TSEnv.value('So')
	$PerCent = $TSEnv:PercentComplete
		$Rack = $TSEnv.value('Rack')
		$Shelf = $TSEnv.value('Shelf')
		$RackShelf = $Rack + "_" + $Shelf
		$PK = "[$So][$RackShelf]"

		$URL="http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/$PK"
		$body = @{
			notifid = $PK
				status = $msg
				progress = $PerCent
		}
                       $body = $body | ConvertTo-Json
if (Get-Command  'Invoke-WebRequest' ) {
   Invoke-WebRequest  -Uri $URL -Method "Put"  -Body ($body) -UserAgent "perl" 
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


}
function Check-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}
function copyProgress ($sourcePath, $destinationPath) {
	$So =  $TSEnv.value('So')
		$Rack = $TSEnv.value('Rack')
		$Shelf = $TSEnv.value('Shelf')
		$RackShelf = $Rack + "_" + $Shelf
		$PK = "[$So][$RackShelf]"
		$URL="http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/$PK"
		$files = Get-ChildItem -Path $sourcePath -Recurse
		$filecount = $files.count
		$i=0
		Foreach ($file in $files) {
			$i++
			#	$msg = "Copying release $sourcePath ..... | $file ($i of $filecount) | Percent progress:  " +  (($i/$filecount)*100) + "%"
			$msg = "Copying release $sourcePath ..... | $file ($i of $filecount) <br/>
			<div class='bar' role='progressbar'   aria-valuenow='"+ (($i/$filecount)*100) + "' aria-valuemin='0' aria-valuemax='100' style='width:"+ (($i/$filecount)*100) + "% '>
        <span class='sr-only'  >"+ (($i/$filecount)*100) + "%</span>
        </div>"
				$body = @{
					notifid = $PK
						status = $msg
				}
				                       $body = $body | ConvertTo-Json
if (Get-Command  'Invoke-WebRequest' ) {
   Invoke-WebRequest  -Uri $URL -Method "Put"  -Body ($body) -UserAgent "perl" 
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
				Write-Progress -activity "Copying release..." -status "$file ($i of $filecount)" -percentcomplete (($i/$filecount)*100)

# Determine the absolute path of this object's parent container.  This is stored as a different attribute on file and folder objects so we use an if block to cater for both
				if ($file.psiscontainer) {
					$sourcefilecontainer = $file.parent

				} else {
					$sourcefilecontainer = $file.directory

				}

				$relativepath = $sourcefilecontainer.fullname.SubString($sourcepath.length)
# Copy the object to the appropriate folder within the destination folder
				Copy-Item $file.fullname ($destinationPath + $relativepath) -Verbose 
		}


}

#Setting 
$ScriptFile = $MyInvocation.MyCommand.Name 
$ScriptLocation  = Split-Path $MyInvocation.MyCommand.Path -Parent


#Setting Vars 

$username = $TSEnv.value('OSDUserPackager')
$password = $TSENV.value('OSDPasswordPackager')
$Releases = $TSEnv.value('OSDCustomerRelease')
$uncServer = $TSEnv.value('OSDPackagerRoot') 
$ScriptRoot = $TSEnv.value('DeployRoot')
$ScriptRoot = "$ScriptRoot\Scripts"
$TargetDir = "C:\Mycompany\delivery"
$ReleasesArr =  $Releases -split(',') | Where { $_ }
#Performing Action 
restNotif "Mount Network share $uncServer to copy release(s) $ReleasesArr"
Write-Progress -Activity "Copying Release" -Status "Mount Network share $uncServer" -PercentComplete 12 -Id 1 
net use $uncServer $password /USER:$username

#Loop on Releases

$ReleasesArr | foreach {
	$uncFullPath = "$uncServer\$_"
	$basenameObj = gi $uncFullPath | select basename
#	$b = $basenameObj[0]
#	$basename = $b.basename 
	$basename = $basenameObj.basename
	$ReleaseDir = "$TargetDir\$basename"
	restNotif  "Copying release $basename to $ReleaseDir ...."
		Write-Progress -Activity "Copying Release" -Status "Copying release $basename to $ReleaseDir ...." -PercentComplete 50 -Id 1
#copy the Release
#	$copy = Copy-Item $uncFullPath $TargetDir -recurse  -verbose -PassThru
		copyProgress $uncFullPath $ReleaseDir
#	restNotif "$copy"



}


Write-Progress -Activity "Copying Release" -Status "Copying release terminated, going to umount the Network share and quit." -PercentComplete 100 -Id 1
restNotif  "Copying release terminated, going to umount the Network share and quit."

net use $uncServer /delete
