@echo off
REM Windows Update setup
REM version 1.0 *A.Cristalli
REM here is the execution path
REM Set the vars value
set SCRIPTDIR=%~dp0
for /F "tokens=1,2* delims==" %%i in ('%SystemRoot%\System32\CScript.exe //nologo "%SCRIPTDIR%EchoTSVariables.wsf"') do set %%i=%%j>nul
set CURL=%SCRIPTDIR%choco\curl.exe  --globoff -i -v -A "perl" -X PUT -H "Content-Type: application/json" -H "Accept: application/json"
set PK=[%So%][%Rack%_%Shelf%]
set URL=http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/%PK%
PATH "%PATH%;C:\Windows\System32\;C:\Windows\SysWOW64;C:\Windows\;"
echo "The directory is %SCRIPTDIR%"
echo "%SCRIPTROOT%\wsusoffline\client\cmd\"
cd  "%SCRIPTROOT%\wsusoffline\client\cmd\"
set WSUS="DoUpdate.cmd"
set MSG="About to run the command %WSUS% /instielatest /updatecpp /updatetsc /instwmf /autoreboot"
SET RETURN=Label1
goto REST
:Label1
%WSUS% /instielatest /updatecpp /updatetsc /instwmf /autoreboot
set MSG="Windows Update terminate"
SET RETURN=End
goto REST

:REST
set MSG=%MSG:"=%
set MSG=%MSG:\=/%

%CURL% -d "{\"notifid\":\"%PK%\", \"status\":\"^<b^>%MSG%^</b^>\"}" %URL%
goto %RETURN% 

:End

