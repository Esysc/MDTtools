@echo off
REM
REM This batch download and install all software defined in software.list
REM The format is npackg repo format
REM
REM here is the execution path
echo %~dp0
REM Set the vars value
set FILENAME=%~dp0software.list
set WINGET=npackdcl.exe
REM Install the cli
netsh winhttp set proxy proxy.hq.k.grp:80
msiexec.exe /qb- /i http://bit.ly/npackdcl-1_18_7 
REM add repository to look in
REM
cd "C:\Program Files\NpackdCL\"
%WINGET% add-repo --url https://windows-package-manager.googlecode.com/hg/repository/Rep.xml
%WINGET% add-repo --url https://windows-package-manager.googlecode.com/hg/repository/Rep64.xml
%WINGET% add-repo --url https://windows-package-manager.googlecode.com/hg/repository/Libs.xml
%WINGET% detect
REM This repo is not well formatted  --url https://windows-package-manager.googlecode.com/hg/RepUnstable.xml
REM Actually do the install/update
for /f "tokens=*" %%a in (%FILENAME%) do (a
REM unistall previous version first
call :INSTALLED %%a
		%WINGET% search -q %PACKAGE%
		IF  ERRORLEVEL 0 %WINGET% remove -p %PACKAGE%
		%WINGET% add -p %%a
		)

:INSTALLED
set PACKAGE=control-panel%~x1
