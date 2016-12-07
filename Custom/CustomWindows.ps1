<#

.SYNOPSIS
    This script reconfigures Windows 10.

.DESCRIPTION
    This script makes considerable changes to Windows 10.

    // *************
    // *  CAUTION  *
    // *************

    THIS SCRIPT MAKES CONSIDERABLE CHANGES TO THE DEFAULT CONFIGURATION OF WINDOWS 10.

    Please review this script THOROUGHLY before applying, and disable changes below as necessary to suit your current environment.

    This script is provided AS-IS - usage of this source assumes that you are at the very least familiar with PowerShell, and the
    tools used to create and debug this script.

    In other words, if you break it, you get to keep the pieces.



	Modify start menu for all user via GPO
	Unpin Edge from task bar

#>
function Pin-App ([string]$appname, [switch]$unpin, [switch]$start, [switch]$taskbar, [string]$path) {
    if ($unpin.IsPresent) {
        $action = "Unpin"
    } else {
        $action = "Pin"
    }
    
    if (-not $taskbar.IsPresent -and -not $start.IsPresent) {
        Write-Error "Specify -taskbar and/or -start!"
    }
    
    if ($taskbar.IsPresent) {
        try {
            $exec = $false
            if ($action -eq "Unpin") {
                ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}
                if ($exec) {
                    Write "App '$appname' unpinned from Taskbar"
                } else {
                    if (-not $path -eq "") {
                        Pin-App-by-Path $path -Action $action
                    } else {
                        Write "'$appname' not found or 'Unpin from taskbar' not found on item!"
                    }
                }
            } else {
                ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Pin to taskbar'} | %{$_.DoIt(); $exec = $true}
                
                if ($exec) {
                    Write "App '$appname' pinned to Taskbar"
                } else {
                    if (-not $path -eq "") {
                        Pin-App-by-Path $path -Action $action
                    } else {
                        Write "'$appname' not found or 'Pin to taskbar' not found on item!"
                    }
                }
            }
        } catch {
            Write-Error "Error Pinning/Unpinning $appname to/from taskbar!"
        }
    }
    
    if ($start.IsPresent) {
        try {
            $exec = $false
            if ($action -eq "Unpin") {
                ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from Start'} | %{$_.DoIt(); $exec = $true}
                
                if ($exec) {
                    Write "App '$appname' unpinned from Start"
                } else {
                    if (-not $path -eq "") {
                        Pin-App-by-Path $path -Action $action -start
                    } else {
                        Write "'$appname' not found or 'Unpin from Start' not found on item!"
                    }
                }
            } else {
                ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Pin to Start'} | %{$_.DoIt(); $exec = $true}
                
                if ($exec) {
                    Write "App '$appname' pinned to Start"
                } else {
                    if (-not $path -eq "") {
                        Pin-App-by-Path $path -Action $action -start
                    } else {
                        Write "'$appname' not found or 'Pin to Start' not found on item!"
                    }
                }
            }
        } catch {
            Write-Error "Error Pinning/Unpinning $appname to/from Start!"
        }
    }
}

function Pin-App-by-Path([string]$Path, [string]$Action, [switch]$start) {
    if ($Path -eq "") {
        Write-Error -Message "You need to specify a Path" -ErrorAction Stop
    }
    if ($Action -eq "") {
        Write-Error -Message "You need to specify an action: Pin or Unpin" -ErrorAction Stop
    }
    if ((Get-Item -Path $Path -ErrorAction SilentlyContinue) -eq $null){
        Write-Error -Message "$Path not found" -ErrorAction Stop
    }
    $Shell = New-Object -ComObject "Shell.Application"
    $ItemParent = Split-Path -Path $Path -Parent
    $ItemLeaf = Split-Path -Path $Path -Leaf
    $Folder = $Shell.NameSpace($ItemParent)
    $ItemObject = $Folder.ParseName($ItemLeaf)
    $Verbs = $ItemObject.Verbs()
    
    if ($start.IsPresent) {
        switch($Action){
            "Pin"   {$Verb = $Verbs | Where-Object -Property Name -EQ "&Pin to Start"}
            "Unpin" {$Verb = $Verbs | Where-Object -Property Name -EQ "Un&pin from Start"}
            default {Write-Error -Message "Invalid action, should be Pin or Unpin" -ErrorAction Stop}
        }
    } else {
        switch($Action){
            "Pin"   {$Verb = $Verbs | Where-Object -Property Name -EQ "Pin to Tas&kbar"}
            "Unpin" {$Verb = $Verbs | Where-Object -Property Name -EQ "Unpin from Tas&kbar"}
            default {Write-Error -Message "Invalid action, should be Pin or Unpin" -ErrorAction Stop}
        }
    }
    
    if($Verb -eq $null){
        Write-Error -Message "That action is not currently available on this Path" -ErrorAction Stop
    } else {
        $Result = $Verb.DoIt()
    }
}

#
# Clean of bullshit wins apps
#

#  remove all Modern apps from the system account

function restNotif ($msg) {
        $So =  $TSEnv:So
		$PerCent = $TSEnv:PercentComplete
                $Rack = $TSEnv:Rack
                $Shelf = $TSEnv:Shelf
                $RackShelf = $Rack + "_" + $Shelf
                $PK = "[" + $So + "][" + $RackShelf + "]"
                $URL="http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/" + $PK
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


# Remove OneDrive (not guaranteed to be permanent - see https://support.office.com/en-US/article/Turn-off-or-uninstall-OneDrive-f32a17ce-3336-40fe-9c38-6efb09f944b0)
# Note - best to run this after installing Office 2013/2016/365, as those may update or reinstall OneDrive:
Write-Host "Removing OneDrive..." -ForegroundColor Yellow
 restNotif("Removing OneDrive...")
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall
Start-Sleep -Seconds 30

# Set PeerCaching to Local Network PCs only (1):
Write-Host "Configuring PeerCaching..." -ForegroundColor Cyan
restNotif("Configuring PeerCaching...")
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' -Name 'DODownloadMode' -Value '1'


# Configure Services:
Write-Host "Configuring Network List Service to start Automatic..." -ForegroundColor Green
restNotif("Configuring Network List Service to start Automatic...")
Set-Service netprofm -StartupType Automatic


# Disable System Restore
Write-Host "Disabling System Restore..." -ForegroundColor Green
restNotif("Disabling System Restore...")
Disable-ComputerRestore -Drive "C:\"


# Remove Previous Versions:
Write-Host "Removing Previous Versions Capability..." -ForegroundColor Green
restNotif("Removing Previous Versions Capability...")
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'NoPreviousVersionsPage' -Value '1'




#Remove EDGE from the task bar
restNotif("Unpin Edge from task bar")
Pin-App "Microsoft Edge" -unpin -taskbar

# Add Internet explorer Tile and link
# Adjust ILO console wrong link
restNotif("Pinning IEXPLORER..... ")
Copy-Item -Path $PSScriptRoot'\Internet Explorer.lnk' -Destination 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories'
Copy-Item -Path $PSScriptRoot'\LayoutModification.xml' -Destination 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell'
Copy-Item -Path $PSScriptRoot'\iLO Integrated Remote Console.lnk' -Destination 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Hewlett-Packard'

#Call GPO to block start menu
restNotif("Applying GPO policy for start menu....")
Invoke-Command  -ScriptBlock {
		Write-Host "Applying GPO policy....." -ForegroundColor Green
        Start-Process -filepath "C:\windows\regedit.exe" -argumentlist "/s $PSScriptRoot\startmenu.reg"
       
    }
