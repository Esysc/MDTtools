@echo off
REM
REM This batch download and install all software defined in software.list
REM version 1.0 *A.Cristalli
REM here is the execution path
setlocal enableextensions enabledelayedexpansion
echo %~dp0
REM Set the vars value
set FILENAME=%~dp0software.list
set WINGET=choco update -y
set SCRIPTDIR=%~dp0..
for /F "tokens=1,2* delims==" %%i in ('cscript //nologo "%SCRIPTDIR%\EchoTSVariables.wsf"') do set %%i=%%j>nul

set CURL=%~dp0curl.exe  --globoff -i -v -A "perl" -X PUT -H "Content-Type: application/json" -H "Accept: application/json"
set PK=[%So%][%Rack%_%Shelf%]
set URL=http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/%PK%
REM set http_proxy=http://proxy.hq.k.grp:80
REM set https_proxy=http://proxy.hq.k.grp:80
REM Install the corporate certificate first
%CURL% -d "{\"status\":\"^<b^>CHOCO install script is installing the CA certificate  to be trusted..... ^</b^>\",\"progress\":\"85\"}" %URL%
certutil.exe -f -v -addstore root %~dp0firewall.cer

REM Then, install chocolatey 
%CURL% -d "{\"status\":\"^<b^>CHOCO install script is installing itself ..... ^</b^>\"}" %URL%
@powershell -NoProfile -ExecutionPolicy bypass -Command "& '%~dp0ZTIChocolatey-Wrapper.ps1'" &&  SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

SET /A COUNT=1
set "cmd=findstr /R /N "^^" %FILENAME% | find /C /V "#""
for /f  %%a in ('!cmd!') do set TOTAL=%%a
REM Actually do the install/update
for /f "eol=# tokens=*" %%a in (%FILENAME%) do (
			
		 %CURL% -d "{\"status\":\"^<b^>Installing !COUNT! of %TOTAL%:^<br /^>  %%a ^</b^>\",\"progress\":\"85\"}" %URL%
		powershell -NoProfile -ExecutionPolicy bypass  -Command "&  %WINGET%  %%a -force" && %CURL% -d "{\"status\":\"^<b^>CHOCO install script Successfully installed :^<br /^>  %%a ^</b^>\"}" %URL% || %CURL% -d "{\"status\":\"^<b^>CHOCO install script Error installing:^<br /^>  %%a . The software has not been installed.^</b^>\"}" %URL%
		SET /A COUNT+=1
		)
%CURL% -d "{\"status\":\"^<b^>CHOCO install script End. All software described in %FILENAME% installed .^</b^>\",\"progress\":\"90\"}" %URL%

