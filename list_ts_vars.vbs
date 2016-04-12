On error resume next

Set wshShell = CreateObject( "WScript.Shell")

Set env = wshShell.Environment("System")

Set env1 = CreateObject("Microsoft.SMS.TSEnvironment")

If Err Then

       wscript.echo "TS Environment not availble"

       wscript.echo "The script can only be used while the Task Sequence components are loaded"

       wscript.quit()

End if

 

If Wscript.Arguments.Count = 0 Then

              wscript.echo "No first letter(s) of variable provided so showing all"

 

              wscript.echo "list all environment variables"

              For Each strItem In env

                     WScript.Echo strItem

              Next

 

              wscript.echo "list all TS variables"

              For each v in env1.GetVariables

                     WScript.Echo v & " = " & env1(v)

              Next

 

 Else

     If Wscript.Arguments.Count > 0 Then

        VarLetter=WScript.Arguments.Item(0)

       If Len(Varletter) = 1 Then

 

              wscript.echo "list all environment variables starting with: " & Varletter

              For Each strItem In env

        '      If Ucase(Left(strItem,1)) = Ucase(Varletter) Then

                     WScript.Echo strItem

         '     End if

              Next

 

              wscript.echo "list all TS variables starting with: " & Varletter

 

              For each v in env1.GetVariables

       '       If Ucase(Left(v,1)) = Ucase(Varletter) Then

                     WScript.Echo v & " = " & env1(v)

        '      End if

              Next

 

       Else

 

              wscript.echo "list variable: " &Varletter

              varlen=Len(Varletter)

              For Each strItem In env

        '             If Ucase(Left(strItem,varlen)) = Ucase(Varletter) Then

                           WScript.Echo strItem

         '            End if

              Next

 

              wscript.echo "list TS variable: " &Varletter

              varlen=Len(Varletter)

              For each v in env1.GetVariables

         '            If Ucase(Left(v,varlen)) = Ucase(Varletter) Then

                           WScript.Echo v & " = " & env1(v)

          '           End if

              Next

       End if

   End If

 End If
