@echo off
REM
REM This batch download and install all software defined in software.list
REM version 1.0 *A.Cristalli
REM here is the execution path
echo %~dp0
REM Set the vars value
set FILENAME=%~dp0software.list
set WINGET=choco install
REM Install chocolatey first
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin


REM Actually do the install/update
for /f "eol=# tokens=*" %%a in (%FILENAME%) do (
                %WINGET%   %%a
                )

