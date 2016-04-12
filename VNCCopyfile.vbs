Set oWSH = CreateObject("WScript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")

oWSH.CurrentDirectory = oFSO.GetParentFolderName(WScript.ScriptFullName)

oFSO.CopyFile "vnchooks.dll", "x:\windows\vnchooks.dll", True
oFSO.CopyFile "vncviewer.exe", "x:\windows\vncviewer.exe", True
oFSO.CopyFile "winvnc.exe", "x:\windows\winvnc.exe", True
oFSO.CopyFile "UltraVNC.ini", "x:\windows\UltraVNC.ini", True
