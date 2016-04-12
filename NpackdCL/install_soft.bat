@echo off
REM
REM This batch download and install all software defined in software.list
REM The format is npackg repo format
REM version 1.0 *A.Cristalli
REM here is the execution path
echo %~dp0
REM Set the vars value
set FILENAME=%~dp0software.list
set WINGET=%~dp0ncl.exe
set SCRIPTDIR=%~dp0..
for /F "tokens=1,2* delims==" %%i in ('cscript //nologo "%SCRIPTDIR%\EchoTSVariables.wsf"') do set %%i=%%j>nul

set CURL=%~dp0curl.exe  --globoff -i -v -A "perl" -X PUT -H "Content-Type: application/json" -H "Accept: application/json"
set PK=[%So%][%Rack%_%Shelf%]
set URL=http://x.x.x.204/SPOT/provisioning/api/provisioningnotifications/%PK%
set SCRIPTNAME="NpackdCL"
REM Set the proxy var (obsolete now)
REM netsh winhttp set proxy proxy.hq.k.grp:80
REM Clear the repos definition
%CURL% -d "{\"status\":\"^<b^>Reload software repository ^</b^>\"}" %URL%
FOR /F "skip=2" %%G IN ('%WINGET% list-repos') DO (
 %WINGET% remove-repo --url=%%G
 )
REM add repository to look in
REM

%WINGET% add-repo --url http://npackd.appspot.com/rep/xml?tag=stable
%WINGET% add-repo --url http://npackd.appspot.com/rep/xml?tag=stable64
%WINGET% add-repo --url http://npackd.appspot.com/rep/xml?tag=libs

%WINGET% detect

REM Actually do the install/update
for /f "eol=# tokens=*" %%a in (%FILENAME%) do (
REM unistall previous version first
call :INSTALLED %%a
		%WINGET% search -q %%a
		IF  ERRORLEVEL 0 (
		%WINGET% remove -p %%a
		%CURL%  -d "{\"status\":\"^<b^>%SCRIPTNAME% Removed old version of:^<br /^>  %%a ^</b^>\"}" %URL%
		REM Clean the trash
		rd /s /q %systemdrive%\$Recycle.bin
		)
		REM Updating the web provisioning dashboard
                set JSON={"notifid":"%PK%","status":"Installing new version of %%a"}a
		%CURL%  -d "{\"status\":\"^<b^>%SCRIPTNAME% installing  the following software:^<br /^>  %%a ^</b^>\"}" %URL%
		%WINGET% add -p %%a
		set JSON={"notifid":"%PK%","status":" %%a installed!"}	
		%CURL%  -d "{\"status\":\"^<b^>%SCRIPTNAME% the following software has been succesfully installed :^<br /^>  %%a ^</b^>\"}" %URL%	
		)

:INSTALLED
set PACKAGE=control-panel%~x1
