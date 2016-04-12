<#
.SYNOPSIS
Chocolatey Wrapper

.DESCRIPTION
Wrapper arround the Chocolatey (Chocolatey.org) package wrapper system.

.NOTES

This script will read in a list of chocolatey packages from the MDT Chocolatey variable 
and install each package locally.

The Chocolatey scripts are kept in the c:\minint folder so they are not added to any images.
Because of this, be aware of any "Portable" applications that are installed under c:\minint.

.EXAMPLE

CustomSettings.ini example:

[Settings]
Priority=Default
Properties=Chocolatey(*)

[Default]
...
Chocolatey001=WindowsADK
Chocolatey002=AdobeReader
Chocolatey003=vcredist2010

.EXAMPLE

.\ZTIChocolatey-Wrapper.ps1 -Verbose -Packages "WindowsADK","AdobeReader","vcredist20101"

Install three packages  initiated from the command line.

.LINK
http://keithga.wordpress.com/2014/11/25/new-tool-chocolatey-wrapper-for-mdt
http://Chocolatey.org

#>

[CmdletBinding()]
param(
    [parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Packages = $TSEnvList:Chocolatey
)

write-verbose "Construct a local path for Chocolatey"
if ($env:ChocolateyInstall -eq $Null)
{
    $env:ChocolateyInstall = [Environment]::GetEnvironmentVariable( "ChocolateyInstall" , [System.EnvironmentVariableTarget]::User)
    if ($env:ChocolateyInstall -eq $Null)
    {
        $env:ChocolateyInstall = join-path ([System.Environment]::GetFolderPath("CommonApplicationData")) "Chocolatey"
        if ($tsenv:LogPath -ne $null)
        {
            $env:ChocolateyInstall = join-path $tsenv:LogPath "Chocolatey"
        }
    }
}

$ChocoExe = join-path $env:ChocolateyInstall "bin\choco.exe"
$netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])


if($netAssembly)
{
    $bindingFlags = [Reflection.BindingFlags] "Static,GetProperty,NonPublic"
    $settingsType = $netAssembly.GetType("System.Net.Configuration.SettingsSectionInternal")

    $instance = $settingsType.InvokeMember("Section", $bindingFlags, $null, $null, @())

    if($instance)
    {
        $bindingFlags = "NonPublic","Instance"
        $useUnsafeHeaderParsingField = $settingsType.GetField("useUnsafeHeaderParsing", $bindingFlags)

        if($useUnsafeHeaderParsingField)
        {
          $useUnsafeHeaderParsingField.SetValue($instance, $true)
        }
    }
}
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

write-verbose "Chocolatey Program: $ChocoExe"
if ( ! (test-path $ChocoExe ) )
{
    write-verbose "Install Chocolatey..."
	
    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
    if (!(test-path $ChocoExe))
    {
        throw "Chocolatey Install not found!"
    }
}

write-verbose "Install Chocolatey packages from within MDT"
foreach ( $Package in $Packages ) 
{
    write-verbose "Install Chocolatey Package: $ChocoExe $Package"
    & $ChocoExe install $Package 2>&1 | out-string
}

write-verbose "Chocolatey install done"