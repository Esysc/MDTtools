REM mount the default NT user .dat file for the purpose of adding HKCU registry changes
REG LOAD "HKU\CUSTOM" "C:\Users\Default\NTUSER.DAT"
REM make the desired registry changes
regedit /s %1%\Scripts\Win8UserSpecifcConfig.reg
REM unload the .dat file - very important
REG UNLOAD "HKU\CUSTOM"
