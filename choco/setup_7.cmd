@echo off
REM
REM This batch download and install all software defined in software.list
REM version 1.0 *A.Cristalli
REM here is the execution path
setlocal enableextensions enabledelayedexpansion
echo %~dp0
REM Set the vars value
set FILENAME=%~dp0software.list
set WINGET=choco install -y
set SCRIPTDIR=%~dp0..

certutil.exe -f -v -addstore root %~dp0firewall.cer

REM Then, install chocolatey 
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy bypass -Command "& '%~dp0ZTIChocolatey-Wrapper.ps1'" &&  SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM Actually do the install/update
for /f "eol=# tokens=*" %%a in (%FILENAME%) do (
			
		%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy bypass  -Command "&  %WINGET%  %%a -force" 
		)

