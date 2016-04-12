REM Delete obsolete lnk files from desktop
REM Added to try to clean old lnk that are not removed after reinstallation
REM You can keep updated this batch


del "%USERPROFILE%\Desktop\sqldeveloper.lnk"
del "%USERPROFILE%\Desktop\MobaXterm Personal Edition.lnk"
del "%USERPROFILE%\Desktop\Cygwin64 Terminal.lnk"
del "%USERPROFILE%\Desktop\SoapUI 5.0.0.lnk"

REM Repeat the actions for public user

del "%PUBLIC%\Desktop\sqldeveloper.lnk"
del "%PUBLIC%\Desktop\MobaXterm Personal Edition.lnk"
del "%PUBLIC%\Desktop\Cygwin64 Terminal.lnk"
del "%PUBLIC%\Desktop\SoapUI 5.0.0.lnk"

REM Here add a directory you want to remove

rmdir /S /Q "%PROGRAMFILES%\sqldeveloper"
