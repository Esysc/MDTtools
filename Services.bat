REM Set the services that we need to activate
REM Remove the services that we don't need

set SCRIPTDIR=%~dp0
set CURL=%~dp0\choco\curl.exe  --globoff -i -v -A "perl" -X PUT -H "Content-Type: application/json" -H "Accept: application/json"
for /F "tokens=1,2* delims==" %%i in ('cscript //nologo "%SCRIPTDIR%\EchoTSVariables.wsf"') do set %%i=%%j>nul

set PK=[%So%][%Rack%_%Shelf%]
set URL=http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/%PK%

REM The following would disable the security center
%CURL% -d "{\"status\":\"^<b^>disabling  Windows Defender and Security center.... ^</b^>\",\"progress\":\"91\"}" %URL%
sc config wscsvc start= disabled

REM this would disable Windows Defender
sc config WinDefend= disabled


sc config lmhosts start= auto
sc start lmhosts





REM Customisation goes here
%CURL% -d "{\"status\":\"^<b^>Turning off the firewall ^</b^>\",\"progress\":\"92\"}" %URL%
netsh advfirewall set allprofiles state off 

NetSh Advfirewall set allprofiles state off
NetSh winhttp reset proxy
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v HideSCAHealth /t REG_DWORD /d 0x1 /f



net user administrator Superuser
net user operator Customer


echo Installation number: %So%  performed on %DATE%_%TIME% > C:\Windows\syp_log


if exist C:\Mycompany\delivery (
cd C:\Mycompany\delivery
for  /D  %%d IN (C:\Mycompany\delivery\*) DO (
                                if exist %%d (
								
                echo "Creating %%d.GUI **********************"

                mkdir %%d.GUI

                                cd %%d
                                FOR  /R  %%e IN (*.exe) DO (
								%CURL% -d "{\"status\":\"^<b^>Moving %%e in %%d.GUI ********************** ^</b^>\",\"progress\":\"93\"}" %URL%
                                echo "Moving %%e in %%d.GUI **********************"
                                move /Y %%e %%d.GUI
                                )
                                                                )

                )

)



if exist %OSDPK% (
%CURL% -d "{\"status\":\"^<b^>Activating Windows.......... ^</b^>\",\"progress\":\"94\"}" %URL%
echo "Activating Windows.........."
net time \\mdt01 /SET /YES
cscript /b %windir%\system32\slmgr.vbs -upk
ping 9.1.1.1 -n 1 -w 10000 > nul
cscript /b %windir%\system32\slmgr.vbs -ipk %OSDPK%
ping 9.1.1.1 -n 1 -w 10000 > nul
cscript /b %windir%\system32\slmgr.vbs -ato
ping 9.1.1.1 -n 1 -w 60000 > nul


)


%CURL% -d "{\"status\":\"^<b^>Adjusting the TZ to %OSDTZ% ^</b^>\",\"progress\":\"95\"}" %URL%
tzutil /s "%OSDTZ%"






