' *********************************************************************************************
' *********************************************************************************************
'
' This script disables the "Found New Hardware Wizard" dialog and closes any existing ones
' The script has been tested on Windows XP-x86 SP3.  
' Earlier versions of Windows XP and Windows Server 2003 may require a hotfix. See Microsoft KB938596
' 
' Usage:
' cscript [/nologo] NewHwWiz.vbs <Disable|Enable>
'
' ***** DISCLAIMER *****
' This is a sample script provided by Intrinsic Technologies
' Use of this script implies no warranties and confers no rights!
'
' **********************************************************************************************
' **********************************************************************************************

Option explicit
'Const procFilter = "Imagename eq rundll32.exe"
Const procFilter = "Windowtitle eq Found New Hardware Wizard"
Const timeout = 30000

Dim wshShell
Set wshShell =  WScript.CreateObject("WScript.Shell")

if (WScript.Arguments.Count = 0) Then
   ShowUsage
ElseIf (InStr(1, WScript.Arguments(0), "Dis", 1) <> 0) Then
   Disable
ElseIf (InStr(1, WScript.Arguments(0), "Ena", 1) <> 0) Then
   ClearReg
Else
   WScript.Echo "Invalid operation"
   ShowUsage
End if
  

Sub Disable()
   SetReg
   WScript.Echo "Checking for running windows to close"
   Do
      Kill
      WScript.Echo "Sleeping for " & timeout & " milliseconds"
      WScript.Sleep timeout
   Loop Until CheckRunning() = "false"
End Sub

Function CheckRunning()
   Dim oExec, strLine
   CheckRunning = "false"
   Set oExec = wshShell.Exec("cmd.exe /c tasklist.exe /fi " & chr(34) & procFilter & chr(34))
   Do Until oExec.StdOut.AtEndOfStream
      strLine = oExec.StdOut.ReadLine()
      WScript.Echo strLine
      if (InStr(1, strLine, "Image Name", 1) <> 0) Then
         CheckRunning = "true"
      End if
   Loop
   'if there are any errors sent to the error stream, show them
   WScript.Echo oExec.StdErr.ReadAll()
   Set oExec = Nothing
End Function

Sub Kill()
   Dim oExec
   Set oExec = wshShell.Exec("cmd.exe /c taskkill.exe /f /fi " & chr(34) & procFilter & chr(34))
   WScript.Echo oExec.StdOut.ReadAll()
   'if there are any errors sent to the error stream, show them
   WScript.Echo oExec.StdErr.ReadAll()
   Set oExec = Nothing
End sub

Sub SetReg()
   'XP 32 bit
   wshShell.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings\SuppressNewHWUI", 1, "REG_DWORD"
   'XP 64 bit and server 2003
   wshShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Services\PlugPlay\Parameters\SuppressUI", 1, "REG_DWORD" 
End Sub

Sub ClearReg()
   On Error Resume Next 
   wshShell.RegDelete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings\"
   wshShell.RegDelete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\"
   wshShell.RegDelete "HKLM\SYSTEM\CurrentControlSet\Services\PlugPlay\Parameters\"
End Sub

Sub ShowUsage()
   WScript.Echo ""
   WScript.Echo "Usage: cscript [/nologo] NewHwWiz.vbs <Disable|Enable>"
End Sub