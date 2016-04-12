@ECHO OFF
C:\bginfo\Bginfo.exe /accepteula c:\bginfo\oem.bgi /timer:0
"C:\bginfo\imagemagick\convert.exe"  "%WINDIR%\BGInfo.bmp"   "%WINDIR%\backgroundDefault.jpg"
"C:\bginfo\imagemagick\convert.exe" "%WINDIR%\backgroundDefault.jpg" -resize 480x480 "%WINDIR%\backgroundDefault.jpg"
xcopy /Y "%WINDIR%\backgroundDefault.jpg" "%WINDIR%\System32\oobe\info\backgrounds\backgroundDefault.jpg"
xcopy /Y "%WINDIR%\backgroundDefault.jpg" "%WINDIR%\SysWOW64\oobe\info\backgrounds\backgroundDefault.jpg"
icacls "%WINDIR%\System32\oobe\info\backgrounds\backgroundDefault.jpg" /grant Administrator:(D,WDAC)
icacls "%WINDIR%\SysWOW64\oobe\info\backgrounds\backgroundDefault.jpg" /grant Administrator:(D,WDAC)
icacls "%WINDIR%\System32\oobe\info\backgrounds\backgroundDefault.jpg" /grant Users:(D,WDAC)
icacls "%WINDIR%\SysWOW64\oobe\info\backgrounds\backgroundDefault.jpg" /grant Users:(D,WDAC)

