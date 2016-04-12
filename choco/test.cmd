echo @off
setlocal EnableDelayedExpansion
set "cmd=findstr /R /N "^^" software.list | find /C /V "#""

for /f  %%a in ('!cmd!') do set number=%%a
echo %number%
set /A count=1
for /f "eol=# tokens=*" %%a in (software.list) do (
echo "counter is: !count!"

set /A count+=1


)
