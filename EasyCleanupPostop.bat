:: Automatically check & get admin rights
::::::::::::::::::::::::::::::::::::::::::::
 @echo off
 set count=1
 color 06
 CLS
 ECHO.
 ECHO =============================
 ECHO Running PostOp Util
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~dpnx0"
 rem this works also from cmd shell, other than %~0
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"
  
  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)


 ::::::::::::::::::::::::::::
 ::START
 ::::::::::::::::::::::::::::

@echo off

title POSTOP Cleanup Util
:menu
color 6
cls

echo '##::: ##:'########:'########::'########:::::'##::::'##:'########:'########::'########::
echo _###:: ##:_##.....::_##...._##:_##...._##::::_##::::_##:_##.....::_##.... ##:_##.... ##:
echo _####: ##:_##:::::::_##::::_##:_##::::_##::::_##::::_##:_##:::::::_##:::: ##:_##:::: ##:
echo _## ## ##:_######:::_########::_##::::_##::::_#########:_######:::_########::_##:::: ##:
echo _##. ####:_##...::::_##.._##:::_##::::_##::::_##...._##:_##...::::_##.._##:::_##:::: ##:
echo _##:. ###:_##:::::::_##::._##::_##::::_##::::_##::::_##:_##:::::::_##::._##::_##:::: ##:
echo _##::. ##:_########:_##:::._##:_########:::::_##::::_##:_########:_##:::._##:_########::
echo ..::::..::........::..:::::..::........::::::..:::::..::........::..:::::..::........:::

echo.
echo =============================================================================[0m
echo.
echo POSTOP Cleanup Util[0m
echo.
echo =============================================================================[0m
echo.
echo.
echo [33mSelect a Tool[0m
echo ============
echo.

echo [34m[0] -------Windows updates------   {Deletes Cookies for Edge and Chrome}[0m

echo [92m[1] ---Delete Browser Cookies---   {Deletes Cookies for Edge and Chrome}[0m

echo [96m[2] --Delete Temp browser data--   {Deletes data like site permissions and history}[0m

echo [91m[3] --------Disk Cleanup--------   {Cleans temporary system files}[0m

echo [95m[4] ---------Disk Defrag--------   {Runs windows Disk Defragment}[0m

echo [93m[5] ------------SFC-------------   {Runs Windows System File Continuity}[0m

echo [6] ------------DISM------------   {Runs Windows DISM restorehealth}

echo [94m[7] ------------All-------------   {Runs all the commands except Defrag and Full Virus scan}[0m

echo [32m[8] ---------RK and ART---------   {Runs RogueKiller and Adware Removal Tool from the cmd line}[0m

echo [31m[9] ------Quick Virus Scan------   {Runs a quick scan using Windows Defender}[0m

echo [35m[10]-------Full Virus Scan------   {Runs a thorough scan using Windows Defender}[0m

echo [92m[11]------Open GUI version------   {Opens a gui version of this batch with extra win options}[0m
echo [33m[12] Exit[0m
echo.
echo.
echo [94m[TIP]To skip parts of the All command use CTRL+C then hit N to continue past or Y to completely cancel the process[0m
echo.
echo.

set /p op=Run:
 if %op%==0 goto update
 if %op%==1 goto 1
 if %op%==2 goto 2
 if %op%==3 goto 3
 if %op%==4 goto 4
 if %op%==5 goto sfc
 if %op%==6 goto dism
 if %op%==7 goto 5
 if %op%==8 goto art
 if %op%==9 goto 9
 if %op%==10 goto 10
 if %op%==11 goto 11
 if %op%==12 goto exit
 if %op%==13 goto 12
goto error

:1
color a
cls
echo =============================================================================
echo.
echo Deleting Browser Cookies
echo =============================================================================
echo.
echo Deleting Cookies...
ping localhost -n 3 >nul
if exist "%LocalAppData%\Google\Chrome\User Data\Default\cookies\*.*" del /f /q "%LocalAppData%\Google\Chrome\User Data\Default\cookies\*.*"
if not %op%==7 cls
echo =============================================================================
echo.
echo Delete Browser Cookies
echo =============================================================================
echo.
echo Operation completed.
echo.
if not %op%==7 echo Press any key to return to the menu..
if not %op%==7 pause >nul
if %op%==7 goto 2
if not %op%==7 goto menu

:2
color b
if not %op%==7 cls
echo =============================================================================
echo.
echo Delete Temp browser Data
echo =============================================================================
echo.
echo Deleting Temp Browser Data
ping localhost -n 3 >nul
if exist "%userprofile%\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*" del /f /q "%userprofile%\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*"
if not %op%==7 cls
echo =============================================================================
echo.
echo Delete Temp Browser Data
echo =============================================================================
echo.
echo Operation completed.
if not %op%==7 echo Press any key to return to the menu...
if not %op%==7 pause >nul
if %op%==7 goto 3
if not %op%==7 goto menu
goto menu

:3
color c
if not %op%==7 cls
echo =============================================================================
echo.
echo Disk Cleanup
echo =============================================================================
echo.
echo Running Disk Cleanup...
cleanmgr.exe /sagerun
ping localhost -n 3 >nul
if exist "C:\\WINDOWS\temp"del /f /q "C:\\WINDOWS\temp\*.*"
if exist "C:\\WINDOWS\tmp"del /f /q "C:\\WINDOWS\tmp\*.*"
if exist "C:\tmp" del /f /q "C:\tmp\*.*"
if exist "C:\temp" del /f /q "C:\temp\*.*"
if exist "%temp%" del /f /q "%temp%\*.*"
if exist "%tmp%" del /f /q "%tmp%\*.*"
if not exist "C:\WINDOWS\Users\*.*" goto skip
if exist "C:\WINDOWS\Users\*.zip" del "C:\WINDOWS\Users\*.zip" /f /q
if exist "C:\WINDOWS\Users\*.exe" del "C:\WINDOWS\Users\*.exe" /f /q
if exist "C:\WINDOWS\Users\*.gif" del "C:\WINDOWS\Users\*.gif" /f /q
if exist "C:\WINDOWS\Users\*.jpg" del "C:\WINDOWS\Users\*.jpg" /f /q
if exist "C:\WINDOWS\Users\*.png" del "C:\WINDOWS\Users\*.png" /f /q
if exist "C:\WINDOWS\Users\*.bmp" del "C:\WINDOWS\Users\*.bmp" /f /q
if exist "C:\WINDOWS\Users\*.avi" del "C:\WINDOWS\Users\*.avi" /f /q
if exist "C:\WINDOWS\Users\*.mpg" del "C:\WINDOWS\Users\*.mpg" /f /q
if exist "C:\WINDOWS\Users\*.mpeg" del "C:\WINDOWS\Users\*.mpeg" /f /q
if exist "C:\WINDOWS\Users\*.ra" del "C:\WINDOWS\Users\*.ra" /f /q
if exist "C:\WINDOWS\Users\*.ram" del "C:\WINDOWS\Users\*.ram"/f /q
if exist "C:\WINDOWS\Users\*.mp3" del "C:\WINDOWS\Users\*.mp3" /f /q
if exist "C:\WINDOWS\Users\*.mov" del "C:\WINDOWS\Users\*.mov" /f /q
if exist "C:\WINDOWS\Users\*.qt" del "C:\WINDOWS\Users\*.qt" /f /q
if exist "C:\WINDOWS\Users\*.asf" del "C:\WINDOWS\Users\*.asf" /f /q

:skip
if not exist C:\WINDOWS\Users\Users\*.* goto skippy /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.zip del C:\WINDOWS\Users\Users\*.zip /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.exe del C:\WINDOWS\Users\Users\*.exe /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.gif del C:\WINDOWS\Users\Users\*.gif /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.jpg del C:\WINDOWS\Users\Users\*.jpg /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.png del C:\WINDOWS\Users\Users\*.png /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.bmp del C:\WINDOWS\Users\Users\*.bmp /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.avi del C:\WINDOWS\Users\Users\*.avi /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.mpg del C:\WINDOWS\Users\Users\*.mpg /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.mpeg del C:\WINDOWS\Users\Users\*.mpeg /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.ra del C:\WINDOWS\Users\Users\*.ra /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.ram del C:\WINDOWS\Users\Users\*.ram /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.mp3 del C:\WINDOWS\Users\Users\*.mp3 /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.asf del C:\WINDOWS\Users\Users\*.asf /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.qt del C:\WINDOWS\Users\Users\*.qt /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.mov del C:\WINDOWS\Users\Users\*.mov /f /q

:skippy
if exist "C:\WINDOWS\ff*.tmp" del C:\WINDOWS\ff*.tmp /f /q
if exist C:\WINDOWS\ShellIconCache del /f /q "C:\WINDOWS\ShellI~1\*.*"
if not %op%==7 cls
echo =============================================================================
echo.
echo Disk Cleanup
echo =============================================================================
echo.
echo Disk Cleanup successful!
echo.
if not %op%==7 pause
if %op%==7 goto 9
if not %op%==7 goto menu
goto menu

:4
color d
if not %op%==7 cls
echo =============================================================================
echo.
echo Disk Defragment
echo =============================================================================
echo.
echo Defragmenting hard disks...
ping localhost -n 3 >nul
defrag -c -v
if not %op%==7 cls
echo =============================================================================
echo.
echo Disk Defragment
echo =============================================================================
echo.
echo Disk Defrag successful!
echo.
if not %op%==7 pause
if %op%==7 goto 9
if not %op%==7 goto menu
goto menu

:5
color e
call :1

:9
color 4
cls
echo =============================================================================
echo.
echo Quick Virus Scan
echo =============================================================================
echo.
cd "C:\ProgramData\Microsoft\Windows Defender\Platform\4.18*"
MpCmdRun -scan -ScanType 1
cd C:\WINDOWS\system32
if not %op%==7 echo Operation complete.
if not %op%==7 goto menu
if %op%==7 goto sfc 



:10
color 5
cls
echo =============================================================================
echo.
echo Full Virus Scan
echo.
echo =============================================================================
cd "C:\ProgramData\Microsoft\Windows Defender\Platform\4.18*"
MpCmdRun -scan -ScanType 2
echo Operation complete.
cd C:\WINDOWS\system32
goto menu

:11
pushd%~dp0
start WindowsTweakGUI.bat

:error
cls
echo Command not recognized.
ping localhost -n 4 >nul
goto menu

:art
color 2
cls
echo =============================================================================
echo.
echo Adware Removal Tool by Tsa.
echo.
echo =============================================================================
echo.
 echo Starting ART v5.1
echo [91mHit Ctrl C to cancel[0m
echo.
 cd "C:\ProgramData\Microsoft\Windows Defender\Platform\4.18*"
 MpCmdRun -scan -ScanType 1 -ListAll
 cd C:\WINDOWS\system32
echo Operation Complete.
goto rk

:rk
color 2
if not %op%==7 cls
echo =============================================================================
echo.
echo Rogue Killer
echo.
echo =============================================================================
echo.
echo running automated RogueKiller
 pushd "\\10.32.115.242\Agent\POSTOP Tools"
 RogueKillerCMD.exe -scan -no-interact -deleteall -reportpath C:\Users\%userprofile%\Documents\RKreport.txt -reportformat txt
 echo running Rogue Killer
 timeout /t 2 /nobreak
 cd C:\WINDOWS\system32
 pause
if not %op%==7 goto menu
 if not %op%==7 echo Returning to menu...
 if %op%==7 goto update

:update
color 1
if not %op%==7 cls
echo =============================================================================
echo.
echo Windows Update
echo.
echo =============================================================================
echo.
echo [91mChecking for Updates...[0m
powershell -Command "Install-Module PSWindowsUpdate"
powershell -Command "Get-WindowsUpdate"
echo [91mDownloading Updates...[0m
powershell -Command "Install-WindowsUpdate"
echo [91mInstalling Updates...[0m
echo [91mUpdates Complete![0m
echo Press any button to return to menu..
pause >nul
if not %op%==7 goto menu
if %op%==7 goto menu

:dism
if not %op%==7 cls
color f
echo =============================================================================
echo DISM
echo =============================================================================
 dism /online /cleanup-image /restorehealth
 echo Operation complete
 if not %op%==7 pause
 if not %op%==7 echo Press any button to return to menu
 if %op%==7 goto art
 if not %op%==7 goto menu


:sfc 
if not %op%==7 cls
color e
echo =============================================================================
echo SFC
echo =============================================================================
 sfc/scannow
 echo Operation complete
 if not %op%==7 echo Press any button to return to menu
 if %op%==7 goto dism
 if not %op%==7 goto menu

:12
pushd ~%dp0
start loading.bat
goto menu

:exit
cls
color f
echo [91m                  =============================================================================[0m
echo [91m                  =                           [96mOperations Complete.[0m [91m                           =[0m
echo [91m                  =============================================================================[0m
echo [91m                               #----------------------------------------------#[0m
echo [91m                               #[96m Thanks for using POSTOP Cleanup Util by Ryan[0m [91m#[0m
echo [91m                               #----------------------------------------------#[0m
echo [91m                                            press any key to exit..[0m
ping 127.0.0.1 >nul
pause >nul
exit

