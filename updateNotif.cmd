@echo off
REM
REM Send a message to the REST API
REM Created to increase the verbosity of MDT logging
REM Based on choco script setup.cmd
REM Changes: set PATH for dll to load using curl
REM Put the relative path instead of %SCRIPTROOT% that is not yet set
REM version 1.0 *A.Cristalli
REM here is the execution path
REM Set the vars value
set SCRIPTDIR=%~dp0 
set SCRIPTDIR=%SCRIPTDIR:~0,-1%
for /F "tokens=1,2* delims==" %%i in ('%SystemRoot%\System32\CScript.exe //nologo "%SCRIPTDIR%\EchoTSVariables.wsf"') do set %%i=%%j>nul
set PROGRESS=%PercentComplete%
set MSG=%Status%
REM Backslashes it's a problem
set MSG=%MSG:\=/%

set CURL=%SCRIPTDIR%\choco\curl.exe  --globoff -i -v -A "perl" -X PUT -H "Content-Type: application/json" -H "Accept: application/json"
set PK=[%So%][%Rack%_%Shelf%]
set URL=http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/%PK%
PATH "%PATH%;C:\Windows\System32\;C:\Windows\SysWOW64;C:\Windows\;"
REM send the message right now
%CURL% -d "{\"notifid\":\"%PK%\", \"status\":\"^<b^>%MSG%^</b^>\", \"progress\":\"%PROGRESS%\"}" %URL%  >> %SCRIPTDIR%\log.txt 

