@echo off
setlocal EnableExtensions EnableDelayedExpansion
mode con: cols=96 lines=48 >nul 2>&1
title RAYMOND'S ENDPOINT TOOLKIT - Diagnostics - Security - Repair - Optimization
color 0A

:: ============================================================
:: RAYMOND'S ENDPOINT TOOLKIT
:: Windows Diagnostics, Security, Repair and Optimization Utility
::
:: Raymond  Endpoint Toolkit
:: Version: 0.9.2-beta
:: Author:  Raymond Hernandez
:: Date:    August 18, 2026
::
:: Purpose:
::   Portable Windows endpoint toolkit for technicians.
::   Provides troubleshooting, repair, diagnostics, security auditing,
::   optimization, recovery, and administrative utilities from one menu.
:: ============================================================

:: ============================================================
:: FORCE ADMINISTRATOR
:: ============================================================

powershell.exe -NoProfile -Command "if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit 1 }"

if errorlevel 1 (
    cls
    set "RAYMOND_TOOLKIT=%~f0"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath $env:RAYMOND_TOOLKIT -Verb RunAs"
    exit /b
)

:: ============================================================
:: INITIALIZE TOOLKIT
:: ============================================================

set "TOOLKITDIR=%~dp0"
set "LOGDIR=%TOOLKITDIR%logs"

if not exist "%LOGDIR%" (
    mkdir "%LOGDIR%" >nul 2>&1
)

:: Create a Windows-safe timestamp.
for /f %%A in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do (
    set "TIMESTAMP=%%A"
)

set "LOGFILE=%LOGDIR%\RaymondEndpointToolkit-%COMPUTERNAME%-%TIMESTAMP%.log"

call :WriteLog "============================================================"
call :WriteLog "RAYMOND'S ENDPOINT TOOLKIT started"
call :WriteLog "Computer: %COMPUTERNAME%"
call :WriteLog "User: %USERNAME%"
call :WriteLog "Date: %DATE% %TIME%"
call :WriteLog "============================================================"


:: ============================================================
:: MAIN MENU
:: ============================================================

:MENU
@echo off
cls
color 0A

echo ================================================================================================
echo        __    __  ___  ___  ___ _____    __  _____   _____  ___  ___  __         _____  _____
echo       /__\/\ \ \/   \/ _ \/___\\_   \/\ \ \/__   \ /__   \/___\/___\/ /   /\ /\ \_   \/__   \
echo      /_\ /  \/ / /\ / /_)//  // / /\/  \/ /  / /\/   / /\//  ///  // /   / //_/  / /\/  / /\/
echo     //__/ /\  / /_// ___/ \_//\/ /_/ /\  /  / /     / / / \_// \_// /___/ __ \/\/ /_   / /
echo     \__/\_\ \/___,'\/   \___/\____/\_\ \/   \/      \/  \___/\___/\____/\/  \/\____/   \/
echo                        Raymond Hernandez (raymondhernandez@outlook.com)
echo                        Computer: %COMPUTERNAME%     User: %USERNAME%
echo ================================================================================================
echo NETWORK / WI-FI             WINDOWS REPAIR / HARDWARE         WINDOWS / ADMIN TOOLS
echo ================================================================================================
echo [1]  Full Network Report    [12] Run System File Checker      [18] Open Device Manager
echo [2]  Release / Renew IP     [13] DISM CheckHealth             [19] Open Windows Update
echo [3]  Flush DNS Cache        [14] DISM ScanHealth              [26] Enable God Mode
echo [4]  Reset TCP/IP           [15] DISM RestoreHealth           [27] Event Viewer + Reliability
echo [5]  Reset Winsock          [16] Scan for Hardware Changes    [28] Open Services
echo [6]  Network Reset          [17] Generate Driver Report       [29] Open Computer Management
echo [7]  Test Internet          [58] Windows Update Repair        [30] Open Task Manager
echo [8]  Show Wi-Fi Profiles    [60] User Profile Health          [31] Open Programs and Features
echo [9]  Show Wi-Fi Password    [61] Windows Shell Repair
echo [10] Current Network        [62] Registry Diagnostics
echo [11] Wi-Fi Report
echo.
echo ================================================================================================
echo DIAGNOSTICS / REPORTING     AUDIT REPORTS                     SECURITY / SYSTEM ^& FORENSICS
echo ================================================================================================
echo [20] System Information     [35] USB Device Security          [45] User / Local Admin
echo [21] Disk / Drive Health    [36] Browser History              [46] Authentication / Logon
echo [22] Running Process        [37] Network Artifact             [47] Installed Software Security
echo [23] Show System Uptime     [38] Port and Service Exposure    [48] Remote Access Software
echo [24] Generate Battery       [39] MS Defender Maintenance      [49] Network Conf Security
echo [25] BitLocker Status       [40] MS Defender Offline Scan     [50] File Integrity
echo [32] Full Diagnostic        [41] Security Configuration       [51] Windows Update Health
echo [33] Open Toolkit Logs      [42] Persistence / Startup        [52] Crash / Stability
echo [34] Deep Audio Diagnostic  [43] Scheduled Task Audit         [53] Incident Response Snapshot
echo                             [44] Windows Service Audit
echo.
echo ================================================================================================
echo PERFORMANCE / OPTIMIZATION  PORTABLE / MAINTENANCE
echo ================================================================================================
echo [54] Performance Analyzer   [59] Driver Backup
echo [55] Optimization Center    [63] App Updates - WinGet
echo [56] Power / Sleep
echo [57] Startup Performance
echo ================================================================================================

set "selection="
set /p "selection=Select an option or press 0 to exit: "

if "%selection%"=="0" goto EXITTOOLKIT
if "%selection%"=="1" goto NETWORKINFO
if "%selection%"=="2" goto RELEASE_RENEW
if "%selection%"=="3" goto FLUSHDNS
if "%selection%"=="4" goto TCPRESET
if "%selection%"=="5" goto WINSOCK
if "%selection%"=="6" goto NETWORKRESET
if "%selection%"=="7" goto CONNECTIVITY
if "%selection%"=="8" goto WIFIPROFILES
if "%selection%"=="9" goto WIFIPASSWORD
if "%selection%"=="10" goto WIFIINFO
if "%selection%"=="11" goto WIFIREPORT
if "%selection%"=="12" goto SFC
if "%selection%"=="13" goto DISMCHECK
if "%selection%"=="14" goto DISMSCAN
if "%selection%"=="15" goto DISMREPAIR
if "%selection%"=="16" goto HARDWARESCAN
if "%selection%"=="17" goto DRIVERS
if "%selection%"=="18" goto DEVMGMT
if "%selection%"=="19" goto WINDOWSUPDATE
if "%selection%"=="20" goto SYSINFO
if "%selection%"=="21" goto DISKINFO
if "%selection%"=="22" goto PROCESSES
if "%selection%"=="23" goto UPTIME
if "%selection%"=="24" goto BATTERY
if "%selection%"=="25" goto BITLOCKER
if "%selection%"=="26" goto GODMODE
if "%selection%"=="27" goto EVENTVIEWER
if "%selection%"=="28" goto SERVICES
if "%selection%"=="29" goto COMPMGMT
if "%selection%"=="30" goto TASKMGR
if "%selection%"=="31" goto PROGRAMS
if "%selection%"=="32" goto FULLREPORT
if "%selection%"=="33" goto OPENLOGS
if "%selection%"=="34" goto AUDIOREPORT
if "%selection%"=="35" goto USBAUDIT
if "%selection%"=="36" goto BROWSERAUDIT
if "%selection%"=="37" goto PRIVATEAUDIT
if "%selection%"=="38" goto PORTAUDIT
if "%selection%"=="39" goto DEFENDER
if "%selection%"=="40" goto DEFENDEROFFLINE
if "%selection%"=="41" goto SECURITYCONFIG
if "%selection%"=="42" goto PERSISTENCEAUDIT
if "%selection%"=="43" goto TASKAUDIT
if "%selection%"=="44" goto SERVICEAUDIT
if "%selection%"=="45" goto USERAUDIT
if "%selection%"=="46" goto LOGONAUDIT
if "%selection%"=="47" goto SOFTWAREAUDIT
if "%selection%"=="48" goto REMOTEAUDIT
if "%selection%"=="49" goto NETSECAUDIT
if "%selection%"=="50" goto FILEAUDIT
if "%selection%"=="51" goto UPDATEAUDIT
if "%selection%"=="52" goto STABILITYAUDIT
if "%selection%"=="53" goto IRSNAPSHOT
if "%selection%"=="54" goto PERFORMANCE
if "%selection%"=="55" goto OPTIMIZATIONCENTER
if "%selection%"=="56" goto POWERSLEEP
if "%selection%"=="57" goto STARTUPPERF
if "%selection%"=="58" goto UPDATEREPAIR
if "%selection%"=="59" goto DRIVERBACKUP
if "%selection%"=="60" goto PROFILEHEALTH
if "%selection%"=="61" goto SHELLREPAIR
if "%selection%"=="62" goto REGISTRYCENTER
if "%selection%"=="63" goto WINGETCENTER

echo.
echo Invalid selection.
timeout /t 2 >nul
goto MENU


:: ============================================================
:: NETWORK - FULL HTML REPORT
:: ============================================================

:NETWORKINFO
call :GenericMaintenanceReport "Network" "NetworkReport" "FULL NETWORK REPORT"
goto MENU


:: ============================================================
:: NETWORK - RELEASE / RENEW
:: ============================================================

:RELEASE_RENEW
cls
echo ============================================================
echo RELEASE / RENEW IP ADDRESS
echo ============================================================
echo.
echo This will temporarily disconnect active DHCP connections.
echo.

choice /C YN /N /M "Continue? [Y/N]: "

if errorlevel 2 goto MENU

call :WriteLog "IP release/renew started"

echo.
echo Releasing DHCP addresses...
ipconfig /release

echo.
echo Renewing DHCP addresses...
ipconfig /renew

echo.
echo Current configuration:
ipconfig

call :WriteLog "IP release/renew completed"

echo.
pause
goto MENU


:: ============================================================
:: NETWORK - FLUSH DNS
:: ============================================================

:FLUSHDNS
cls
echo ============================================================
echo FLUSH DNS CACHE
echo ============================================================
echo.

call :WriteLog "DNS cache flush started"

ipconfig /flushdns

call :WriteLog "DNS cache flush completed"

echo.
pause
goto MENU


:: ============================================================
:: NETWORK - TCP/IP RESET
:: ============================================================

:TCPRESET
cls
echo ============================================================
echo RESET TCP/IP STACK
echo ============================================================
echo.
echo This resets Windows TCP/IP configuration.
echo A restart may be required afterward.
echo.

choice /C YN /N /M "Continue? [Y/N]: "

if errorlevel 2 goto MENU

call :WriteLog "TCP/IP reset started"

netsh int ip reset

call :WriteLog "TCP/IP reset completed"

echo.
echo TCP/IP reset complete.
echo Restart Windows if network problems continue.
echo.
pause
goto MENU


:: ============================================================
:: NETWORK - WINSOCK RESET
:: ============================================================

:WINSOCK
cls
echo ============================================================
echo RESET WINSOCK
echo ============================================================
echo.
echo This resets the Windows Winsock catalog.
echo A restart is recommended afterward.
echo.

choice /C YN /N /M "Continue? [Y/N]: "

if errorlevel 2 goto MENU

call :WriteLog "Winsock reset started"

netsh winsock reset

call :WriteLog "Winsock reset completed"

echo.
echo Winsock reset complete.
echo Restart Windows to complete the reset.
echo.
pause
goto MENU


:: ============================================================
:: NETWORK - COMPLETE RESET
:: ============================================================

:NETWORKRESET
cls
echo ============================================================
echo COMPLETE NETWORK RESET
echo ============================================================
echo.
echo The following actions will be performed:
echo.
echo   - Release DHCP address
echo   - Flush DNS cache
echo   - Reset Winsock
echo   - Reset TCP/IP
echo   - Renew DHCP address
echo.
echo Active network connections may temporarily disconnect.
echo A restart is strongly recommended afterward.
echo.

choice /C YN /N /M "Perform complete network reset? [Y/N]: "

if errorlevel 2 goto MENU

call :WriteLog "Complete network reset started"

echo.
echo [1/5] Releasing IP address...
ipconfig /release

echo.
echo [2/5] Flushing DNS cache...
ipconfig /flushdns

echo.
echo [3/5] Resetting Winsock...
netsh winsock reset

echo.
echo [4/5] Resetting TCP/IP...
netsh int ip reset

echo.
echo [5/5] Renewing IP address...
ipconfig /renew

call :WriteLog "Complete network reset completed"

echo.
echo ============================================================
echo Network reset completed.
echo ============================================================
echo.
echo Restart Windows to ensure all changes take effect.
echo.
pause
goto MENU


:: ============================================================
:: NETWORK - CONNECTIVITY TEST
:: ============================================================

:CONNECTIVITY
cls
echo ============================================================
echo INTERNET CONNECTIVITY TEST
echo ============================================================
echo.

call :WriteLog "Connectivity test started"

echo Testing local TCP/IP stack...
ping 127.0.0.1 -n 2

echo.
echo ------------------------------------------------------------
echo Testing Cloudflare DNS - 1.1.1.1
echo ------------------------------------------------------------
echo.

ping 1.1.1.1 -n 4

echo.
echo ------------------------------------------------------------
echo Testing Google DNS - 8.8.8.8
echo ------------------------------------------------------------
echo.

ping 8.8.8.8 -n 4

echo.
echo ------------------------------------------------------------
echo Testing DNS resolution
echo ------------------------------------------------------------
echo.

nslookup microsoft.com

echo.
echo ------------------------------------------------------------
echo Tracing route to Cloudflare
echo ------------------------------------------------------------
echo.

tracert -d 1.1.1.1

call :WriteLog "Connectivity test completed"

echo.
pause
goto MENU


:: ============================================================
:: WI-FI - SAVED PROFILES
:: ============================================================

:WIFIPROFILES
cls
echo ============================================================
echo SAVED WI-FI PROFILES
echo ============================================================
echo.

call :WriteLog "Saved Wi-Fi profiles viewed"

netsh wlan show profiles

echo.
pause
goto MENU


:: ============================================================
:: WI-FI - SHOW SAVED PASSWORD
:: ============================================================

:WIFIPASSWORD
cls
echo ============================================================
echo SAVED WI-FI PASSWORD
echo ============================================================
echo.
echo Enter the exact name of a saved Wi-Fi profile.
echo.
echo Tip: Use option [8] first to view saved Wi-Fi profiles.
echo.

setlocal DisableDelayedExpansion

set "WIFI_SSID="
set "WIFI_PASSWORD="
set /p "WIFI_SSID=Enter Wi-Fi SSID: "

if not defined WIFI_SSID (
    echo.
    echo No Wi-Fi profile was entered.
    echo.
    endlocal
    pause
    goto MENU
)

echo.
echo ------------------------------------------------------------
echo Wi-Fi Profile: %WIFI_SSID%
echo ------------------------------------------------------------
echo.

:: Verify profile exists.
netsh wlan show profile name="%WIFI_SSID%" >nul 2>&1

if errorlevel 1 (
    echo ERROR: Wi-Fi profile "%WIFI_SSID%" was not found.
    echo.
    echo Use option [8] to view the exact saved profile names.
    echo.
    endlocal
    pause
    goto MENU
)

:: Extract the saved key.
for /f "tokens=1,* delims=:" %%A in ('netsh wlan show profile name^="%WIFI_SSID%" key^=clear ^| findstr /I "Key Content"') do (
    for /f "tokens=* delims= " %%C in ("%%B") do set "WIFI_PASSWORD=%%C"
)

if defined WIFI_PASSWORD (

    call :WriteLog "Saved Wi-Fi password viewed for profile: %WIFI_SSID%"

    echo SSID     : %WIFI_SSID%
    echo Password : %WIFI_PASSWORD%
) else (
    echo Unable to automatically extract the password.
    echo.
    echo Showing the full Wi-Fi profile below:
    echo.
    netsh wlan show profile name="%WIFI_SSID%" key=clear
)

echo.
endlocal
pause
goto MENU

:: ============================================================
:: CURRENT NETWORK CONNECTION
:: ============================================================

:WIFIINFO
@echo off
cls

echo ============================================================
echo CURRENT NETWORK CONNECTION
echo ============================================================
echo.

call :WriteLog "Current network connection viewed"

powershell.exe -NoProfile -Command "$adapters = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'}; foreach($a in $adapters){if($a.NdisPhysicalMedium -eq 9 -or $a.InterfaceDescription -match 'Wireless|Wi-Fi|802.11'){Write-Host ('Connection : Wi-Fi'); Write-Host ('Adapter    : ' + $a.Name); Write-Host ('Device     : ' + $a.InterfaceDescription)}else{Write-Host ('Connection : Wired / Ethernet'); Write-Host ('Adapter    : ' + $a.Name); Write-Host ('Device     : ' + $a.InterfaceDescription)}; Write-Host ''}"

echo ------------------------------------------------------------
echo IP ADDRESS INFORMATION
echo ------------------------------------------------------------
echo.

ipconfig

echo.
pause
goto MENU


:: ============================================================
:: WI-FI - WLAN REPORT
:: ============================================================

:WIFIREPORT
cls
echo ============================================================
echo WINDOWS WI-FI REPORT
echo ============================================================
echo.

call :WriteLog "Wi-Fi report generation started"

netsh wlan show wlanreport

echo.
echo Windows Wi-Fi report generated.
echo.
echo Default location:
echo C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html
echo.

choice /C YN /N /M "Open the Wi-Fi report now? [Y/N]: "

if errorlevel 2 goto MENU

if exist "C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html" (
    start "" "C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html"
) else (
    echo.
    echo Unable to locate the Wi-Fi report.
    pause
)

goto MENU


:: ============================================================
:: WINDOWS REPAIR - SFC
:: ============================================================

:SFC
cls
echo ============================================================
echo SYSTEM FILE CHECKER
echo ============================================================
echo.
echo Command:
echo sfc /scannow
echo.
echo This can take several minutes.
echo.

choice /C YN /N /M "Start System File Checker? [Y/N]: "

if errorlevel 2 goto MENU

call :WriteLog "SFC scan started"

sfc /scannow

call :WriteLog "SFC scan completed with exit code %errorlevel%"

echo.
pause
goto MENU


:: ============================================================
:: WINDOWS REPAIR - DISM CHECKHEALTH
:: ============================================================

:DISMCHECK
cls
echo ============================================================
echo DISM - CHECK WINDOWS IMAGE HEALTH
echo ============================================================
echo.

call :WriteLog "DISM CheckHealth started"

DISM /Online /Cleanup-Image /CheckHealth

call :WriteLog "DISM CheckHealth completed with exit code %errorlevel%"

echo.
pause
goto MENU


:: ============================================================
:: WINDOWS REPAIR - DISM SCANHEALTH
:: ============================================================

:DISMSCAN
cls
echo ============================================================
echo DISM - SCAN WINDOWS IMAGE HEALTH
echo ============================================================
echo.
echo This scan can take several minutes.
echo.

choice /C YN /N /M "Start DISM ScanHealth? [Y/N]: "

if errorlevel 2 goto MENU

call :WriteLog "DISM ScanHealth started"

DISM /Online /Cleanup-Image /ScanHealth

call :WriteLog "DISM ScanHealth completed with exit code %errorlevel%"

echo.
pause
goto MENU


:: ============================================================
:: WINDOWS REPAIR - DISM RESTOREHEALTH
:: ============================================================

:DISMREPAIR
cls
echo ============================================================
echo DISM - REPAIR WINDOWS IMAGE
echo ============================================================
echo.
echo Command:
echo DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo This operation can take a significant amount of time.
echo Internet access may be required if Windows needs repair
echo content from Windows Update.
echo.

choice /C YN /N /M "Start Windows image repair? [Y/N]: "

if errorlevel 2 goto MENU

call :WriteLog "DISM RestoreHealth started"

DISM /Online /Cleanup-Image /RestoreHealth

call :WriteLog "DISM RestoreHealth completed with exit code %errorlevel%"

echo.
pause
goto MENU


:: ============================================================
:: HARDWARE - SCAN DEVICES
:: ============================================================

:HARDWARESCAN
cls
echo ============================================================
echo SCAN FOR HARDWARE CHANGES
echo ============================================================
echo.

call :WriteLog "Hardware scan started"

pnputil /scan-devices

call :WriteLog "Hardware scan completed"

echo.
pause
goto MENU


:: ============================================================
:: DRIVER INFORMATION - HTML REPORT
:: ============================================================

:DRIVERS
call :GenericMaintenanceReport "Drivers" "Drivers" "DRIVER INFORMATION REPORT"
goto MENU


:: ============================================================
:: DEVICE MANAGER
:: ============================================================

:DEVMGMT
call :WriteLog "Device Manager opened"
start "" devmgmt.msc
goto MENU


:: ============================================================
:: WINDOWS UPDATE
:: ============================================================

:WINDOWSUPDATE
call :WriteLog "Windows Update opened"
start "" ms-settings:windowsupdate
goto MENU


:: ============================================================
:: SYSTEM INFORMATION - HTML REPORT
:: ============================================================

:SYSINFO
call :GenericMaintenanceReport "System" "SystemInfo" "SYSTEM INFORMATION REPORT"
goto MENU


:: ============================================================
:: DISK INFORMATION / STORAGE HEALTH - HTML REPORT
:: ============================================================

:DISKINFO
call :GenericMaintenanceReport "DiskHealth" "DiskInfo" "DISK INFORMATION / STORAGE HEALTH"
goto MENU


:: ============================================================
:: RUNNING PROCESSES - HTML REPORT
:: ============================================================

:PROCESSES
call :GenericMaintenanceReport "Processes" "Processes" "RUNNING PROCESS REPORT"
goto MENU


:: ============================================================
:: SYSTEM UPTIME
:: ============================================================

:UPTIME
cls
echo ============================================================
echo SYSTEM UPTIME
echo ============================================================
echo.

call :WriteLog "System uptime viewed"

powershell.exe -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $uptime=(Get-Date)-$os.LastBootUpTime; Write-Host ('Last Boot : '+$os.LastBootUpTime); Write-Host ('Uptime    : {0} days, {1} hours, {2} minutes' -f $uptime.Days,$uptime.Hours,$uptime.Minutes)"

echo.
pause
goto MENU


:: ============================================================
:: BATTERY REPORT
:: ============================================================

:BATTERY
cls
echo ============================================================
echo BATTERY HEALTH REPORT
echo ============================================================
echo.

call :NewReportTimestamp
set "BATTERYREPORT=%LOGDIR%\Battery-%COMPUTERNAME%-%REPORTSTAMP%.html"

call :WriteLog "Battery report requested"

powercfg /batteryreport /output "%BATTERYREPORT%"

if exist "%BATTERYREPORT%" (
    echo.
    echo Battery report created:
    echo %BATTERYREPORT%
    echo.
    choice /C YN /N /M "Open battery report? [Y/N]: "

    if errorlevel 2 goto MENU

    start "" "%BATTERYREPORT%"
) else (
    echo.
    echo Battery report could not be generated.
    echo This computer may not contain a battery.
    echo.
    pause
)

goto MENU


:: ============================================================
:: BITLOCKER STATUS - HTML REPORT
:: ============================================================

:BITLOCKER
call :GenericMaintenanceReport "BitLocker" "BitLocker" "BITLOCKER STATUS REPORT"
goto MENU


:GODMODE
cls
echo ============================================================
echo ENABLE GOD MODE
echo ============================================================
echo.
echo Creating God Mode...
echo.

:: Get the real Desktop path for the current profile
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do (
    set "DESKTOPPATH=%%D"
)

set "GODMODE=%DESKTOPPATH%\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"

echo Desktop detected:
echo %DESKTOPPATH%
echo.

if exist "%GODMODE%" (
    echo God Mode already exists.
    call :WriteLog "God Mode already exists: %GODMODE%"
    echo.
    echo Opening God Mode...
    start "" "%GODMODE%"
    echo.
    pause
    goto MENU
)

mkdir "%GODMODE%" >nul 2>&1

if exist "%GODMODE%" (
    call :WriteLog "God Mode folder created: %GODMODE%"
    echo.
    echo God Mode successfully created.
    echo.
    echo Opening God Mode...
    start "" "%GODMODE%"
) else (
    call :WriteLog "ERROR: God Mode folder creation failed"
    echo.
    echo ERROR: God Mode could not be created.
    echo.
    echo Attempted location:
    echo %GODMODE%
)

echo.
pause
goto MENU

:: ============================================================
:: EVENT VIEWER + RELIABILITY MONITOR
:: ============================================================

:EVENTVIEWER
@echo off
cls

echo ============================================================
echo EVENT VIEWER + RELIABILITY MONITOR
echo ============================================================
echo.
echo Opening Event Viewer...
echo Opening Reliability Monitor...
echo.

call :WriteLog "Event Viewer and Reliability Monitor opened"

:: Open Event Viewer
start "" eventvwr.msc

:: Small delay so both consoles do not launch simultaneously
timeout /t 1 /nobreak >nul

:: Open Reliability Monitor
start "" perfmon.exe /rel

timeout /t 2 /nobreak >nul
goto MENU


:: ============================================================
:: SERVICES
:: ============================================================

:SERVICES
call :WriteLog "Services console opened"
start "" services.msc
goto MENU


:: ============================================================
:: COMPUTER MANAGEMENT
:: ============================================================

:COMPMGMT
call :WriteLog "Computer Management opened"
start "" compmgmt.msc
goto MENU


:: ============================================================
:: TASK MANAGER
:: ============================================================

:TASKMGR
call :WriteLog "Task Manager opened"
start "" taskmgr.exe
goto MENU


:: ============================================================
:: PROGRAMS AND FEATURES
:: ============================================================

:PROGRAMS
call :WriteLog "Programs and Features opened"
start "" appwiz.cpl
goto MENU


:: ============================================================
:: FULL DIAGNOSTIC REPORT - HTML
:: ============================================================

:FULLREPORT
@echo off
cls

echo ============================================================
echo FULL DIAGNOSTIC REPORT
echo ============================================================
echo.
echo Collecting system diagnostics...
echo.

call :WriteLog "Full diagnostic HTML report started"

call :NewReportTimestamp
set "REPORT=%LOGDIR%\Diagnostic-%COMPUTERNAME%-%REPORTSTAMP%.html"
set "REPORTSCRIPT=%TEMP%\Raymond_FullReport_%RANDOM%_%RANDOM%.ps1"

:: Let PowerShell know where this BAT and temporary script are.
set "RAYMOND_TOOLKIT=%~f0"
set "RAYMOND_REPORTSCRIPT=%REPORTSCRIPT%"

:: Extract the embedded PowerShell section from this BAT.
powershell.exe -NoProfile -Command "$c=Get-Content -LiteralPath $env:RAYMOND_TOOLKIT; $s=[Array]::IndexOf($c,'::PS_FULLREPORT_BEGIN'); $e=[Array]::IndexOf($c,'::PS_FULLREPORT_END'); if($s -lt 0 -or $e -le $s){exit 1}; $c[($s+1)..($e-1)] | Set-Content -LiteralPath $env:RAYMOND_REPORTSCRIPT -Encoding UTF8"

if errorlevel 1 (
    echo.
    echo ERROR: Could not prepare diagnostic report engine.
    call :WriteLog "ERROR: Could not extract Full Report PowerShell module"
    echo.
    pause
    goto MENU
)

:: Run the report generator.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%REPORTSCRIPT%" -ReportPath "%REPORT%"

set "REPORTERROR=%errorlevel%"

:: Remove temporary PowerShell file.
del /f /q "%REPORTSCRIPT%" >nul 2>&1

if not "%REPORTERROR%"=="0" (
    echo.
    echo ERROR: Diagnostic collection failed.
    echo.
    call :WriteLog "ERROR: Full diagnostic PowerShell module returned %REPORTERROR%"
    pause
    goto MENU
)

if exist "%REPORT%" (
    call :WriteLog "Full diagnostic HTML report created: %REPORT%"

    echo Diagnostic report successfully generated.
    echo.
    echo Opening report...
    echo.

    start "" "%REPORT%"
) else (
    call :WriteLog "ERROR: Full diagnostic HTML report was not created"

    echo.
    echo ERROR: Diagnostic report could not be generated.
)

echo.
pause
goto MENU


::PS_FULLREPORT_BEGIN
param(
    [Parameter(Mandatory = $true)]
    [string]$ReportPath
)

$ErrorActionPreference = 'SilentlyContinue'

function Encode-Html {
    param($Value)

    if ($null -eq $Value) {
        return ''
    }

    return [System.Net.WebUtility]::HtmlEncode([string]$Value)
}

function Get-PnpErrorText {
    param([int]$Code)

    switch ($Code) {
        1  { 'Device not configured correctly' }
        3  { 'Driver may be corrupted or system resources are low' }
        10 { 'Device cannot start' }
        12 { 'Not enough resources' }
        14 { 'Restart required' }
        18 { 'Reinstall drivers' }
        19 { 'Registry configuration problem' }
        24 { 'Device not present or not working correctly' }
        28 { 'Drivers are not installed' }
        31 { 'Windows cannot load required drivers' }
        37 { 'Windows cannot initialize the driver' }
        39 { 'Driver corrupted or missing' }
        41 { 'Driver loaded but device not found' }
        42 { 'Duplicate device detected' }
        43 { 'Device reported a failure' }
        47 { 'Device prepared for safe removal' }
        48 { 'Driver blocked because of compatibility problems' }
        default { 'Windows Plug and Play error' }
    }
}

try {

    # ------------------------------------------------------------
    # COLLECT SYSTEM INFORMATION
    # ------------------------------------------------------------

    $computer = Get-CimInstance Win32_ComputerSystem
    $os       = Get-CimInstance Win32_OperatingSystem
    $bios     = Get-CimInstance Win32_BIOS
    $cpu      = Get-CimInstance Win32_Processor
    $gpu      = Get-CimInstance Win32_VideoController

    $physicalDisks = @(Get-PhysicalDisk)
    $volumes       = @(Get-Volume)
    $network       = @(Get-NetAdapter)
    $firewall      = @(Get-NetFirewallProfile)

    $defender = Get-MpComputerStatus

    # Use both PnP sources because they expose different useful data:
    # - Get-PnpDevice provides the visible Status shown by Device Manager/PowerShell.
    # - Win32_PnPEntity provides ConfigManagerErrorCode and HardwareID.
    $pnpCim     = @(Get-CimInstance Win32_PnPEntity)
    $pnpDevices = @(Get-PnpDevice)
    $drivers    = @(Get-CimInstance Win32_PnPSignedDriver)

    # Real PnP problems are based on Windows Config Manager error codes.
    # Code 22 = intentionally disabled.
    # Code 45 = currently disconnected.
    $problemDevices = @(
        foreach ($cimDevice in $pnpCim) {

            if (
                $cimDevice.ConfigManagerErrorCode -ne 0 -and
                $cimDevice.ConfigManagerErrorCode -ne 22 -and
                $cimDevice.ConfigManagerErrorCode -ne 45
            ) {

                $pnpMatch = $pnpDevices |
                    Where-Object {
                        $_.InstanceId -eq $cimDevice.PNPDeviceID
                    } |
                    Select-Object -First 1

                [PSCustomObject]@{
                    Name                   = $cimDevice.Name
                    Class                  = $cimDevice.PNPClass
                    Status                 = if ($pnpMatch) { $pnpMatch.Status } else { $cimDevice.Status }
                    ConfigManagerErrorCode = $cimDevice.ConfigManagerErrorCode
                    InstanceId             = $cimDevice.PNPDeviceID
                    HardwareID             = $cimDevice.HardwareID
                }
            }
        }
    )

    # Get-PnpDevice can report Unknown even when Config Manager reports no error.
    # Keep those devices in a neutral review section rather than flagging them red.
    $reviewDevices = @(
        foreach ($pnpDevice in $pnpDevices) {

            if ($pnpDevice.Status -eq 'Unknown') {

                $cimMatch = $pnpCim |
                    Where-Object {
                        $_.PNPDeviceID -eq $pnpDevice.InstanceId
                    } |
                    Select-Object -First 1

                if (
                    $null -eq $cimMatch -or
                    $cimMatch.ConfigManagerErrorCode -eq 0
                ) {

                    [PSCustomObject]@{
                        Name       = $pnpDevice.FriendlyName
                        Class      = $pnpDevice.Class
                        Status     = $pnpDevice.Status
                        ErrorCode  = if ($cimMatch) { $cimMatch.ConfigManagerErrorCode } else { 0 }
                        InstanceId = $pnpDevice.InstanceId
                    }
                }
            }
        }
    )

    try {
        $events = @(
            Get-WinEvent -FilterHashtable @{
                LogName   = 'System'
                Level     = 1,2
                StartTime = (Get-Date).AddDays(-3)
            } | Select-Object -First 50
        )
    }
    catch {
        $events = @()
    }

    $uptime = (Get-Date) - $os.LastBootUpTime

    $totalRamGB = [math]::Round(
        $computer.TotalPhysicalMemory / 1GB,
        2
    )

    $freeRamGB = [math]::Round(
        $os.FreePhysicalMemory * 1KB / 1GB,
        2
    )

    if ($totalRamGB -gt 0) {
        $freeRamPercent = [math]::Round(
            ($freeRamGB / $totalRamGB) * 100,
            1
        )
    }
    else {
        $freeRamPercent = 0
    }

    $badDiskCount = @(
        $physicalDisks |
        Where-Object {
            $_.HealthStatus -and
            $_.HealthStatus -ne 'Healthy'
        }
    ).Count

    $problemDeviceCount = $problemDevices.Count

    $criticalEventCount = @(
        $events |
        Where-Object LevelDisplayName -eq 'Critical'
    ).Count

    $errorEventCount = @(
        $events |
        Where-Object LevelDisplayName -eq 'Error'
    ).Count


    # ------------------------------------------------------------
    # HTML HEADER
    # ------------------------------------------------------------

    $html = @"
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Diagnostic Report - $env:COMPUTERNAME</title>

<style>

body {
    font-family: Segoe UI, Arial, sans-serif;
    background: #111;
    color: #ddd;
    margin: 30px;
}

h1 {
    color: #4CAF50;
}

h2 {
    color: #6fcf73;
    border-bottom: 1px solid #444;
    padding-bottom: 6px;
    margin-top: 35px;
}

table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 25px;
}

th,
td {
    text-align: left;
    padding: 8px;
    border-bottom: 1px solid #333;
    vertical-align: top;
}

th {
    color: #8be28f;
}

.good {
    color: #55dd77;
    font-weight: bold;
}

.warn {
    color: #ffd54f;
    font-weight: bold;
}

.bad {
    color: #ff5c5c;
    font-weight: bold;
}

.review {
    color: #9aa0a6;
    font-weight: bold;
}

.mono {
    font-family: Consolas, monospace;
    font-size: 12px;
}

.note {
    color: #aaa;
}

.footer {
    color: #777;
    margin-top: 40px;
}

</style>
</head>

<body>

<h1>RAYMOND'S ENDPOINT TOOLKIT</h1>
<p>Full Windows Diagnostic Report</p>
"@


    # ------------------------------------------------------------
    # OVERALL HEALTH FLAGS
    # ------------------------------------------------------------

    $memoryClass =
        if ($freeRamPercent -lt 10) {
            'bad'
        }
        elseif ($freeRamPercent -lt 20) {
            'warn'
        }
        else {
            'good'
        }

    $diskClass =
        if ($badDiskCount -gt 0) {
            'bad'
        }
        else {
            'good'
        }

    $deviceClass =
        if ($problemDeviceCount -gt 0) {
            'bad'
        }
        else {
            'good'
        }

    $criticalClass =
        if ($criticalEventCount -gt 0) {
            'bad'
        }
        else {
            'good'
        }

    $eventClass =
        if ($errorEventCount -gt 10) {
            'bad'
        }
        elseif ($errorEventCount -gt 0) {
            'warn'
        }
        else {
            'good'
        }

    $html += @"
<h2>Overall Health Flags</h2>

<table>
<tr>
    <th>Free Memory</th>
    <td class="$memoryClass">$freeRamGB GB ($freeRamPercent%)</td>
</tr>

<tr>
    <th>Disk Health Issues</th>
    <td class="$diskClass">$badDiskCount</td>
</tr>

<tr>
    <th>Problem Devices</th>
    <td class="$deviceClass">$problemDeviceCount</td>
</tr>

<tr>
    <th>Critical Events - Last 3 Days</th>
    <td class="$criticalClass">$criticalEventCount</td>
</tr>

<tr>
    <th>Error Events - Last 3 Days</th>
    <td class="$eventClass">$errorEventCount</td>
</tr>

</table>
"@


    # ------------------------------------------------------------
    # COMPUTER / WINDOWS
    # ------------------------------------------------------------

    $html += @"
<h2>System</h2>

<table>
<tr><th>Computer Name</th><td>$(Encode-Html $env:COMPUTERNAME)</td></tr>
<tr><th>Manufacturer</th><td>$(Encode-Html $computer.Manufacturer)</td></tr>
<tr><th>Model</th><td>$(Encode-Html $computer.Model)</td></tr>
<tr><th>Total RAM</th><td>$totalRamGB GB</td></tr>
<tr><th>Free RAM</th><td class="$memoryClass">$freeRamGB GB ($freeRamPercent%)</td></tr>
</table>

<h2>Windows</h2>

<table>
<tr><th>Operating System</th><td>$(Encode-Html $os.Caption)</td></tr>
<tr><th>Version</th><td>$(Encode-Html $os.Version)</td></tr>
<tr><th>Build</th><td>$(Encode-Html $os.BuildNumber)</td></tr>
<tr><th>Architecture</th><td>$(Encode-Html $os.OSArchitecture)</td></tr>
<tr><th>Last Boot</th><td>$(Encode-Html $os.LastBootUpTime)</td></tr>
<tr><th>Uptime</th><td>$($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes</td></tr>
</table>

<h2>BIOS</h2>

<table>
<tr><th>Manufacturer</th><td>$(Encode-Html $bios.Manufacturer)</td></tr>
<tr><th>BIOS Version</th><td>$(Encode-Html $bios.SMBIOSBIOSVersion)</td></tr>
<tr><th>Serial Number</th><td>$(Encode-Html $bios.SerialNumber)</td></tr>
</table>
"@


    # ------------------------------------------------------------
    # CPU
    # ------------------------------------------------------------

    $html += '<h2>Processor</h2><table>'

    foreach ($item in $cpu) {

        $html += '<tr><th>CPU</th><td>' +
            (Encode-Html $item.Name) +
            '</td></tr>'

        $html += '<tr><th>Cores / Threads</th><td>' +
            $item.NumberOfCores +
            ' / ' +
            $item.NumberOfLogicalProcessors +
            '</td></tr>'
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # GPU
    # ------------------------------------------------------------

    $html += '<h2>Graphics</h2><table>'

    foreach ($item in $gpu) {

        $html += '<tr><th>GPU</th><td>' +
            (Encode-Html $item.Name) +
            '</td></tr>'

        $html += '<tr><th>Driver Version</th><td>' +
            (Encode-Html $item.DriverVersion) +
            '</td></tr>'
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # PHYSICAL DISKS
    # ------------------------------------------------------------

    $html += @"
<h2>Storage Health</h2>

<table>
<tr>
<th>Disk</th>
<th>Media</th>
<th>Health</th>
<th>Status</th>
<th>Size</th>
</tr>
"@

    foreach ($disk in $physicalDisks) {

        $healthClass =
            if ($disk.HealthStatus -eq 'Healthy') {
                'good'
            }
            else {
                'bad'
            }

        $sizeGB = [math]::Round(
            $disk.Size / 1GB,
            2
        )

        $html += '<tr>'

        $html += '<td>' +
            (Encode-Html $disk.FriendlyName) +
            '</td>'

        $html += '<td>' +
            (Encode-Html $disk.MediaType) +
            '</td>'

        $html += '<td class="' +
            $healthClass +
            '">' +
            (Encode-Html $disk.HealthStatus) +
            '</td>'

        $html += '<td>' +
            (Encode-Html ($disk.OperationalStatus -join ', ')) +
            '</td>'

        $html += '<td>' +
            $sizeGB +
            ' GB</td>'

        $html += '</tr>'
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # VOLUMES
    # ------------------------------------------------------------

    $html += @"
<h2>Volumes</h2>

<table>
<tr>
<th>Drive</th>
<th>File System</th>
<th>Health</th>
<th>Size</th>
<th>Free</th>
<th>Free %</th>
</tr>
"@

    foreach ($volume in $volumes) {

        if ($volume.Size -gt 0) {
            $freePercent = [math]::Round(
                ($volume.SizeRemaining / $volume.Size) * 100,
                1
            )
        }
        else {
            $freePercent = 100
        }

        $volumeClass =
            if ($freePercent -lt 10) {
                'bad'
            }
            elseif ($freePercent -lt 20) {
                'warn'
            }
            else {
                'good'
            }

        $sizeGB = [math]::Round(
            $volume.Size / 1GB,
            2
        )

        $remainingGB = [math]::Round(
            $volume.SizeRemaining / 1GB,
            2
        )

        $html += '<tr>'

        $html += '<td>' +
            (Encode-Html $volume.DriveLetter) +
            '</td>'

        $html += '<td>' +
            (Encode-Html $volume.FileSystem) +
            '</td>'

        $html += '<td>' +
            (Encode-Html $volume.HealthStatus) +
            '</td>'

        $html += "<td>$sizeGB GB</td>"
        $html += "<td>$remainingGB GB</td>"

        $html += '<td class="' +
            $volumeClass +
            '">' +
            $freePercent +
            '%</td>'

        $html += '</tr>'
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # NETWORK
    # ------------------------------------------------------------

    $html += @"
<h2>Network Adapters</h2>

<table>
<tr>
<th>Name</th>
<th>Description</th>
<th>Status</th>
<th>Link Speed</th>
</tr>
"@

    foreach ($adapter in $network) {

        $html += '<tr>'

        $html += '<td>' +
            (Encode-Html $adapter.Name) +
            '</td>'

        $html += '<td>' +
            (Encode-Html $adapter.InterfaceDescription) +
            '</td>'

        $html += '<td>' +
            (Encode-Html $adapter.Status) +
            '</td>'

        $html += '<td>' +
            (Encode-Html $adapter.LinkSpeed) +
            '</td>'

        $html += '</tr>'
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # MICROSOFT DEFENDER
    # ------------------------------------------------------------

    $html += '<h2>Microsoft Defender</h2><table>'

    if ($null -ne $defender) {

        $avClass =
            if ($defender.AntivirusEnabled) {
                'good'
            }
            else {
                'bad'
            }

        $rtClass =
            if ($defender.RealTimeProtectionEnabled) {
                'good'
            }
            else {
                'bad'
            }

        $signatureClass =
            if ($defender.AntivirusSignatureAge -gt 7) {
                'bad'
            }
            elseif ($defender.AntivirusSignatureAge -gt 3) {
                'warn'
            }
            else {
                'good'
            }

        $html += '<tr><th>Antivirus Enabled</th><td class="' +
            $avClass +
            '">' +
            $defender.AntivirusEnabled +
            '</td></tr>'

        $html += '<tr><th>Real-Time Protection</th><td class="' +
            $rtClass +
            '">' +
            $defender.RealTimeProtectionEnabled +
            '</td></tr>'

        $html += '<tr><th>Signature Age</th><td class="' +
            $signatureClass +
            '">' +
            $defender.AntivirusSignatureAge +
            ' days</td></tr>'
    }
    else {

        $html += @"
<tr>
<th>Status</th>
<td class="review">
Microsoft Defender status could not be queried.
A third-party security product may be installed.
</td>
</tr>
"@
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # FIREWALL
    # ------------------------------------------------------------

    $html += @"
<h2>Windows Firewall</h2>

<table>
<tr>
<th>Profile</th>
<th>Enabled</th>
</tr>
"@

    foreach ($profile in $firewall) {

        $firewallClass =
            if ($profile.Enabled) {
                'good'
            }
            else {
                'bad'
            }

        $html += '<tr>'

        $html += '<td>' +
            (Encode-Html $profile.Name) +
            '</td>'

        $html += '<td class="' +
            $firewallClass +
            '">' +
            $profile.Enabled +
            '</td>'

        $html += '</tr>'
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # ------------------------------------------------------------
    # REAL PROBLEM DEVICES
    # ------------------------------------------------------------

    $html += @"
<h2>Problem Devices</h2>

<p class="note">
Only devices with an actual Windows Plug and Play error code are
flagged red. Disabled and disconnected devices are excluded.
</p>

<table>
<tr>
<th>Device</th>
<th>Class</th>
<th>Status</th>
<th>Error</th>
<th>Driver Provider</th>
<th>Driver Version</th>
<th>Driver Date</th>
<th>Instance ID</th>
<th>Hardware ID</th>
</tr>
"@

    if ($problemDeviceCount -eq 0) {

        $html += @"
<tr>
<td colspan="9" class="good">
No active Plug and Play device errors detected
</td>
</tr>
"@
    }
    else {

        foreach ($device in $problemDevices) {

            $driver = $drivers |
                Where-Object {
                    $_.DeviceID -eq $device.InstanceId
                } |
                Select-Object -First 1

            if ($device.HardwareID) {
                $hardwareId =
                    Encode-Html ($device.HardwareID -join ', ')
            }
            else {
                $hardwareId = 'Not available'
            }

            $errorText = Get-PnpErrorText `
                -Code ([int]$device.ConfigManagerErrorCode)

            $html += '<tr>'

            $html += '<td>' +
                (Encode-Html $device.Name) +
                '</td>'

            $html += '<td>' +
                (Encode-Html $device.Class) +
                '</td>'

            $html += '<td class="bad">' +
                (Encode-Html $device.Status) +
                '</td>'

            $html += '<td class="bad"><strong>Code ' +
                $device.ConfigManagerErrorCode +
                '</strong><br>' +
                (Encode-Html $errorText) +
                '</td>'

            $html += '<td>' +
                (Encode-Html $driver.DriverProviderName) +
                '</td>'

            $html += '<td>' +
                (Encode-Html $driver.DriverVersion) +
                '</td>'

            $html += '<td>' +
                (Encode-Html $driver.DriverDate) +
                '</td>'

            $html += '<td class="mono">' +
                (Encode-Html $device.InstanceId) +
                '</td>'

            $html += '<td class="mono">' +
                $hardwareId +
                '</td>'

            $html += '</tr>'
        }
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # UNKNOWN / INACTIVE DEVICES
    # ------------------------------------------------------------

    $html += @"
<h2>Devices for Review</h2>

<p class="note">
These devices report Unknown status through Get-PnpDevice, while
Windows Config Manager reports no active error. They may simply be
disconnected, historical, virtual, USB, monitor, media, or inactive devices.
</p>

<table>
<tr>
<th>Device</th>
<th>Class</th>
<th>Status</th>
<th>Error Code</th>
<th>Instance ID</th>
</tr>
"@

    if ($reviewDevices.Count -eq 0) {

        $html += @"
<tr>
<td colspan="5" class="good">
No unknown-status devices found
</td>
</tr>
"@
    }
    else {

        foreach ($device in $reviewDevices) {

            $html += '<tr>'

            $html += '<td>' +
                (Encode-Html $device.Name) +
                '</td>'

            $html += '<td>' +
                (Encode-Html $device.Class) +
                '</td>'

            $html += '<td class="review">' +
                (Encode-Html $device.Status) +
                '</td>'

            $html += '<td class="good">' +
                $device.ErrorCode +
                '</td>'

            $html += '<td class="mono">' +
                (Encode-Html $device.InstanceId) +
                '</td>'

            $html += '</tr>'
        }
    }

    $html += '</table>'


    # EVENT LOG ERRORS
    # ------------------------------------------------------------

    $html += @"
<h2>Recent Critical / Error Events</h2>

<p class="note">
System log events from the last three days.
A logged error does not automatically mean the computer has a
current fault.
</p>

<table>
<tr>
<th>Time</th>
<th>Level</th>
<th>Event ID</th>
<th>Source</th>
<th>Message</th>
</tr>
"@

    if ($events.Count -eq 0) {

        $html += @"
<tr>
<td colspan="5" class="good">
No recent critical or error events were returned.
</td>
</tr>
"@
    }
    else {

        foreach ($event in $events) {

            $eventClass =
                if ($event.LevelDisplayName -eq 'Critical') {
                    'bad'
                }
                else {
                    'warn'
                }

            $html += '<tr>'

            $html += '<td>' +
                (Encode-Html $event.TimeCreated) +
                '</td>'

            $html += '<td class="' +
                $eventClass +
                '">' +
                (Encode-Html $event.LevelDisplayName) +
                '</td>'

            $html += '<td>' +
                $event.Id +
                '</td>'

            $html += '<td>' +
                (Encode-Html $event.ProviderName) +
                '</td>'

            $html += '<td>' +
                (Encode-Html $event.Message) +
                '</td>'

            $html += '</tr>'
        }
    }

    $html += '</table>'


    # ------------------------------------------------------------
    # FOOTER
    # ------------------------------------------------------------

    $html += @"
<div class="footer">
Generated: $(Get-Date)<br>
RAYMOND'S ENDPOINT TOOLKIT
</div>

</body>
</html>
"@

    $html | Out-File `
        -LiteralPath $ReportPath `
        -Encoding UTF8

    exit 0
}
catch {

    Write-Host
    Write-Host 'Diagnostic report failed:' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host

    exit 1
}
::PS_FULLREPORT_END


:: ============================================================
:: AUDIO DIAGNOSTIC REPORT - HTML
:: ============================================================

:AUDIOREPORT
@echo off
cls

echo ============================================================
echo DEEP AUDIO DIAGNOSTIC REPORT
echo ============================================================
echo.
echo Collecting audio services, devices, drivers and events...
echo.

call :WriteLog "Deep audio diagnostic report started"

call :NewReportTimestamp
set "AUDIOREPORT=%LOGDIR%\AudioDiagnostic-%COMPUTERNAME%-%REPORTSTAMP%.html"
set "AUDIOSCRIPT=%TEMP%\Raymond_AudioReport_%RANDOM%_%RANDOM%.ps1"

set "RAYMOND_TOOLKIT=%~f0"
set "RAYMOND_AUDIOSCRIPT=%AUDIOSCRIPT%"

:: Extract the embedded PowerShell audio report engine from this BAT.
powershell.exe -NoProfile -Command "$c=Get-Content -LiteralPath $env:RAYMOND_TOOLKIT; $s=[Array]::IndexOf($c,'::PS_AUDIOREPORT_BEGIN'); $e=[Array]::IndexOf($c,'::PS_AUDIOREPORT_END'); if($s -lt 0 -or $e -le $s){exit 1}; $c[($s+1)..($e-1)] | Set-Content -LiteralPath $env:RAYMOND_AUDIOSCRIPT -Encoding UTF8"

if errorlevel 1 (
    echo.
    echo ERROR: Could not prepare audio diagnostic engine.
    call :WriteLog "ERROR: Could not extract Audio Report PowerShell module"
    echo.
    pause
    goto MENU
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%AUDIOSCRIPT%" -ReportPath "%AUDIOREPORT%"
set "AUDIOERROR=%errorlevel%"

del /f /q "%AUDIOSCRIPT%" >nul 2>&1

if not "%AUDIOERROR%"=="0" (
    echo.
    echo ERROR: Audio diagnostic collection failed.
    call :WriteLog "ERROR: Audio diagnostic PowerShell module returned %AUDIOERROR%"
    echo.
    pause
    goto MENU
)

if exist "%AUDIOREPORT%" (
    call :WriteLog "Audio diagnostic report created: %AUDIOREPORT%"
    echo Audio diagnostic report successfully generated.
    echo.
    echo Opening report...
    echo.
    start "" "%AUDIOREPORT%"
) else (
    call :WriteLog "ERROR: Audio diagnostic HTML report was not created"
    echo.
    echo ERROR: Audio diagnostic report could not be generated.
)

echo.
pause
goto MENU


::PS_AUDIOREPORT_BEGIN
param(
    [Parameter(Mandatory = $true)]
    [string]$ReportPath
)

$ErrorActionPreference = 'SilentlyContinue'

function Encode-Html {
    param($Value)

    if ($null -eq $Value) {
        return ''
    }

    return [System.Net.WebUtility]::HtmlEncode([string]$Value)
}

function Get-PnpErrorText {
    param([int]$Code)

    switch ($Code) {
        1  { 'Device not configured correctly' }
        3  { 'Driver may be corrupted or system resources are low' }
        10 { 'Device cannot start' }
        12 { 'Not enough resources' }
        14 { 'Restart required' }
        18 { 'Reinstall drivers' }
        19 { 'Registry configuration problem' }
        24 { 'Device not present or not working correctly' }
        28 { 'Drivers are not installed' }
        31 { 'Windows cannot load required drivers' }
        37 { 'Windows cannot initialize the driver' }
        39 { 'Driver corrupted or missing' }
        41 { 'Driver loaded but device not found' }
        42 { 'Duplicate device detected' }
        43 { 'Device reported a failure' }
        47 { 'Device prepared for safe removal' }
        48 { 'Driver blocked because of compatibility problems' }
        default { 'Windows Plug and Play error' }
    }
}

try {

    # ------------------------------------------------------------
    # AUDIO SERVICES
    # ------------------------------------------------------------

    $criticalServiceNames = @(
        'Audiosrv',
        'AudioEndpointBuilder'
    )

    $supportServiceNames = @(
        'MMCSS'
    )

    $audioServices = @(
        foreach ($serviceName in ($criticalServiceNames + $supportServiceNames)) {

            $service = Get-CimInstance Win32_Service -Filter "Name='$serviceName'"

            if ($service) {
                [PSCustomObject]@{
                    Name      = $service.Name
                    Display   = $service.DisplayName
                    State     = $service.State
                    StartMode = $service.StartMode
                    Critical  = $criticalServiceNames -contains $service.Name
                }
            }
        }
    )

    # ------------------------------------------------------------
    # AUDIO DEVICES FROM BOTH PNP SOURCES
    # ------------------------------------------------------------

    $allPnp = @(Get-PnpDevice)
    $allPnpCim = @(Get-CimInstance Win32_PnPEntity)

    $audioPnp = @(
        $allPnp | Where-Object {
            $_.Class -in @('AudioEndpoint','MEDIA') -or
            $_.FriendlyName -match 'Audio|Realtek|Sound|Speaker|Headphone|Microphone|NVIDIA High Definition|AMD High Definition|Intel.*Display Audio|DualSense'
        }
    )

    $audioPnpCim = @(
        $allPnpCim | Where-Object {
            $_.PNPClass -in @('AudioEndpoint','MEDIA') -or
            $_.Name -match 'Audio|Realtek|Sound|Speaker|Headphone|Microphone|NVIDIA High Definition|AMD High Definition|Intel.*Display Audio|DualSense'
        }
    )

    $soundControllers = @(Get-CimInstance Win32_SoundDevice)

    $audioDrivers = @(
        Get-CimInstance Win32_PnPSignedDriver |
        Where-Object {
            $_.DeviceClass -eq 'MEDIA' -or
            $_.DeviceName -match 'Audio|Realtek|Sound|NVIDIA High Definition|AMD High Definition|Intel.*Display Audio'
        } |
        Sort-Object DeviceName
    )

    # ------------------------------------------------------------
    # REAL AUDIO PNP ERRORS
    # ------------------------------------------------------------

    $problemDevices = @(
        foreach ($cimDevice in $audioPnpCim) {

            if (
                $cimDevice.ConfigManagerErrorCode -ne 0 -and
                $cimDevice.ConfigManagerErrorCode -ne 22 -and
                $cimDevice.ConfigManagerErrorCode -ne 45
            ) {

                $pnpMatch = $allPnp |
                    Where-Object {
                        $_.InstanceId -eq $cimDevice.PNPDeviceID
                    } |
                    Select-Object -First 1

                [PSCustomObject]@{
                    Name                   = $cimDevice.Name
                    Class                  = $cimDevice.PNPClass
                    Status                 = if ($pnpMatch) { $pnpMatch.Status } else { $cimDevice.Status }
                    ConfigManagerErrorCode = $cimDevice.ConfigManagerErrorCode
                    InstanceId             = $cimDevice.PNPDeviceID
                    HardwareID             = $cimDevice.HardwareID
                }
            }
        }
    )

    # Neutral Unknown audio devices with no Config Manager error.
    $reviewDevices = @(
        foreach ($pnpDevice in $audioPnp) {

            if ($pnpDevice.Status -eq 'Unknown') {

                $cimMatch = $allPnpCim |
                    Where-Object {
                        $_.PNPDeviceID -eq $pnpDevice.InstanceId
                    } |
                    Select-Object -First 1

                if (
                    $null -eq $cimMatch -or
                    $cimMatch.ConfigManagerErrorCode -eq 0
                ) {
                    [PSCustomObject]@{
                        Name       = $pnpDevice.FriendlyName
                        Class      = $pnpDevice.Class
                        Status     = $pnpDevice.Status
                        ErrorCode  = if ($cimMatch) { $cimMatch.ConfigManagerErrorCode } else { 0 }
                        InstanceId = $pnpDevice.InstanceId
                    }
                }
            }
        }
    )

    # ------------------------------------------------------------
    # AUDIO ENGINE PROCESS
    # ------------------------------------------------------------

    $audioEngineProcesses = @(
        Get-Process audiodg -ErrorAction SilentlyContinue |
        ForEach-Object {
            [PSCustomObject]@{
                ProcessName = $_.ProcessName
                PID         = $_.Id
                CPUSeconds  = if ($null -ne $_.CPU) { [math]::Round($_.CPU,2) } else { 0 }
                MemoryMB    = [math]::Round($_.WorkingSet64 / 1MB,2)
                Threads     = $_.Threads.Count
            }
        }
    )

    # ------------------------------------------------------------
    # AUDIO-RELATED EVENTS - LAST 3 DAYS
    # ------------------------------------------------------------

    $since = (Get-Date).AddDays(-3)

    try {
        $systemEvents = @(
            Get-WinEvent -FilterHashtable @{
                LogName   = 'System'
                StartTime = $since
                Level     = 1,2,3
            } -MaxEvents 400
        )
    }
    catch {
        $systemEvents = @()
    }

    try {
        $applicationEvents = @(
            Get-WinEvent -FilterHashtable @{
                LogName   = 'Application'
                StartTime = $since
                Level     = 1,2,3
            } -MaxEvents 400
        )
    }
    catch {
        $applicationEvents = @()
    }

    $audioEvents = @(
        ($systemEvents + $applicationEvents) |
        Where-Object {
            $_.ProviderName -match 'Audio|Audiosrv|AudioSrv|Kernel-PnP|DeviceSetupManager' -or
            $_.Message -match 'audio|audiodg|Realtek|NVIDIA High Definition Audio|AMD High Definition Audio|sound device|audio endpoint'
        } |
        Sort-Object TimeCreated -Descending |
        Select-Object -First 75
    )

    # ------------------------------------------------------------
    # POWER PLAN - USEFUL FOR STUTTER/REAL-TIME AUDIO CONTEXT
    # ------------------------------------------------------------

    $activePowerPlan = ''

    try {
        $powerOutput = (& powercfg.exe /getactivescheme 2>$null | Out-String).Trim()
        $activePowerPlan = $powerOutput
    }
    catch {
        $activePowerPlan = 'Unable to query active power plan'
    }

    # ------------------------------------------------------------
    # SUMMARY COUNTS
    # ------------------------------------------------------------

    $criticalServicesStopped = @(
        $audioServices |
        Where-Object {
            $_.Critical -and $_.State -ne 'Running'
        }
    ).Count

    $supportServicesStopped = @(
        $audioServices |
        Where-Object {
            -not $_.Critical -and $_.State -ne 'Running'
        }
    ).Count

    $problemDeviceCount = $problemDevices.Count

    $endpointErrorCount = @(
        $audioPnp |
        Where-Object {
            $_.Status -in @('Error','Degraded')
        }
    ).Count

    $criticalEventCount = @(
        $audioEvents |
        Where-Object LevelDisplayName -eq 'Critical'
    ).Count

    $errorEventCount = @(
        $audioEvents |
        Where-Object LevelDisplayName -eq 'Error'
    ).Count

    $warningEventCount = @(
        $audioEvents |
        Where-Object LevelDisplayName -eq 'Warning'
    ).Count

    # ------------------------------------------------------------
    # HTML HEADER / CSS
    # ------------------------------------------------------------

    $html = @"
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Audio Diagnostic Report - $env:COMPUTERNAME</title>
<style>
body{font-family:Segoe UI,Arial,sans-serif;background:#111;color:#ddd;margin:30px}
h1{color:#4CAF50}
h2{color:#6fcf73;border-bottom:1px solid #444;padding-bottom:6px;margin-top:35px}
table{border-collapse:collapse;width:100%;margin-bottom:25px}
th,td{text-align:left;padding:8px;border-bottom:1px solid #333;vertical-align:top}
th{color:#8be28f}
.good{color:#55dd77;font-weight:bold}
.warn{color:#ffd54f;font-weight:bold}
.bad{color:#ff5c5c;font-weight:bold}
.review{color:#9aa0a6;font-weight:bold}
.mono{font-family:Consolas,monospace;font-size:12px;word-break:break-all}
.note{color:#aaa}
.footer{color:#777;margin-top:40px}
</style>
</head>
<body>
<h1>RAYMOND'S ENDPOINT TOOLKIT</h1>
<p>Deep Audio Diagnostic Report</p>
"@

    # ------------------------------------------------------------
    # HEALTH SUMMARY
    # ------------------------------------------------------------

    $serviceClass = if ($criticalServicesStopped -gt 0) { 'bad' } else { 'good' }
    $supportClass = if ($supportServicesStopped -gt 0) { 'warn' } else { 'good' }
    $deviceClass  = if ($problemDeviceCount -gt 0) { 'bad' } else { 'good' }
    $endpointClass = if ($endpointErrorCount -gt 0) { 'bad' } else { 'good' }
    $eventClass = if (($criticalEventCount + $errorEventCount) -gt 0) { 'bad' } elseif ($warningEventCount -gt 0) { 'warn' } else { 'good' }

    $html += @"
<h2>Audio Health Summary</h2>
<table>
<tr><th>Critical Audio Services Stopped</th><td class="$serviceClass">$criticalServicesStopped</td></tr>
<tr><th>Supporting Audio Services Stopped</th><td class="$supportClass">$supportServicesStopped</td></tr>
<tr><th>Actual Audio PnP Errors</th><td class="$deviceClass">$problemDeviceCount</td></tr>
<tr><th>Endpoints Reporting Error / Degraded</th><td class="$endpointClass">$endpointErrorCount</td></tr>
<tr><th>Critical Events - 3 Days</th><td class="$eventClass">$criticalEventCount</td></tr>
<tr><th>Error Events - 3 Days</th><td class="$eventClass">$errorEventCount</td></tr>
<tr><th>Warning Events - 3 Days</th><td class="$eventClass">$warningEventCount</td></tr>
</table>
"@

    # ------------------------------------------------------------
    # SERVICES
    # ------------------------------------------------------------

    $html += '<h2>Windows Audio Services</h2><table><tr><th>Service</th><th>Name</th><th>Status</th><th>Startup</th><th>Role</th></tr>'

    foreach ($service in $audioServices) {

        $serviceStateClass = if ($service.State -eq 'Running') { 'good' } elseif ($service.Critical) { 'bad' } else { 'warn' }
        $role = if ($service.Critical) { 'Critical' } else { 'Supporting' }

        $html += '<tr>'
        $html += '<td>' + (Encode-Html $service.Display) + '</td>'
        $html += '<td>' + (Encode-Html $service.Name) + '</td>'
        $html += '<td class="' + $serviceStateClass + '">' + (Encode-Html $service.State) + '</td>'
        $html += '<td>' + (Encode-Html $service.StartMode) + '</td>'
        $html += '<td>' + $role + '</td>'
        $html += '</tr>'
    }

    $html += '</table>'

    # ------------------------------------------------------------
    # SOUND CONTROLLERS
    # ------------------------------------------------------------

    $html += '<h2>Sound Controllers</h2><table><tr><th>Name</th><th>Manufacturer</th><th>Status</th><th>Device ID</th></tr>'

    foreach ($device in $soundControllers) {

        $controllerClass = if ($device.Status -eq 'OK') { 'good' } else { 'warn' }

        $html += '<tr>'
        $html += '<td>' + (Encode-Html $device.Name) + '</td>'
        $html += '<td>' + (Encode-Html $device.Manufacturer) + '</td>'
        $html += '<td class="' + $controllerClass + '">' + (Encode-Html $device.Status) + '</td>'
        $html += '<td class="mono">' + (Encode-Html $device.PNPDeviceID) + '</td>'
        $html += '</tr>'
    }

    $html += '</table>'

    # ------------------------------------------------------------
    # AUDIO ENDPOINTS / PNP DEVICES
    # ------------------------------------------------------------

    $html += '<h2>Audio Endpoints and PnP Devices</h2><table><tr><th>Device</th><th>Class</th><th>Status</th><th>Instance ID</th></tr>'

    foreach ($device in $audioPnp) {

        $endpointClassName = if ($device.Status -eq 'OK') { 'good' } elseif ($device.Status -in @('Error','Degraded')) { 'bad' } else { 'review' }

        $html += '<tr>'
        $html += '<td>' + (Encode-Html $device.FriendlyName) + '</td>'
        $html += '<td>' + (Encode-Html $device.Class) + '</td>'
        $html += '<td class="' + $endpointClassName + '">' + (Encode-Html $device.Status) + '</td>'
        $html += '<td class="mono">' + (Encode-Html $device.InstanceId) + '</td>'
        $html += '</tr>'
    }

    $html += '</table>'

    # ------------------------------------------------------------
    # ACTUAL AUDIO DEVICE ERRORS
    # ------------------------------------------------------------

    $html += @"
<h2>Actual Audio Device Errors</h2>
<p class="note">Only active audio-related Plug and Play errors are shown here. Code 22 disabled devices and Code 45 disconnected devices are excluded.</p>
<table>
<tr><th>Device</th><th>Class</th><th>Status</th><th>Error</th><th>Driver Provider</th><th>Driver Version</th><th>Instance ID</th><th>Hardware ID</th></tr>
"@

    if ($problemDeviceCount -eq 0) {
        $html += '<tr><td colspan="8" class="good">No active audio Plug and Play errors detected.</td></tr>'
    }
    else {
        foreach ($device in $problemDevices) {

            $driver = $audioDrivers |
                Where-Object { $_.DeviceID -eq $device.InstanceId } |
                Select-Object -First 1

            $hardwareId = if ($device.HardwareID) { Encode-Html ($device.HardwareID -join ', ') } else { 'Not available' }
            $errorText = Get-PnpErrorText -Code ([int]$device.ConfigManagerErrorCode)

            $html += '<tr>'
            $html += '<td>' + (Encode-Html $device.Name) + '</td>'
            $html += '<td>' + (Encode-Html $device.Class) + '</td>'
            $html += '<td class="bad">' + (Encode-Html $device.Status) + '</td>'
            $html += '<td class="bad"><strong>Code ' + $device.ConfigManagerErrorCode + '</strong><br>' + (Encode-Html $errorText) + '</td>'
            $html += '<td>' + (Encode-Html $driver.DriverProviderName) + '</td>'
            $html += '<td>' + (Encode-Html $driver.DriverVersion) + '</td>'
            $html += '<td class="mono">' + (Encode-Html $device.InstanceId) + '</td>'
            $html += '<td class="mono">' + $hardwareId + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'

    # ------------------------------------------------------------
    # UNKNOWN AUDIO DEVICES FOR REVIEW
    # ------------------------------------------------------------

    $html += @"
<h2>Audio Devices for Review</h2>
<p class="note">These devices report Unknown through Get-PnpDevice but have no actual Config Manager error. They are not treated as failures.</p>
<table>
<tr><th>Device</th><th>Class</th><th>Status</th><th>Error Code</th><th>Instance ID</th></tr>
"@

    if ($reviewDevices.Count -eq 0) {
        $html += '<tr><td colspan="5" class="good">No unknown-status audio devices found.</td></tr>'
    }
    else {
        foreach ($device in $reviewDevices) {
            $html += '<tr>'
            $html += '<td>' + (Encode-Html $device.Name) + '</td>'
            $html += '<td>' + (Encode-Html $device.Class) + '</td>'
            $html += '<td class="review">' + (Encode-Html $device.Status) + '</td>'
            $html += '<td class="good">' + $device.ErrorCode + '</td>'
            $html += '<td class="mono">' + (Encode-Html $device.InstanceId) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'

    # ------------------------------------------------------------
    # AUDIO DRIVERS
    # ------------------------------------------------------------

    $html += '<h2>Audio Drivers</h2><table><tr><th>Device</th><th>Provider</th><th>Version</th><th>Date</th><th>INF</th></tr>'

    foreach ($driver in $audioDrivers) {
        $html += '<tr>'
        $html += '<td>' + (Encode-Html $driver.DeviceName) + '</td>'
        $html += '<td>' + (Encode-Html $driver.DriverProviderName) + '</td>'
        $html += '<td>' + (Encode-Html $driver.DriverVersion) + '</td>'
        $html += '<td>' + (Encode-Html $driver.DriverDate) + '</td>'
        $html += '<td class="mono">' + (Encode-Html $driver.InfName) + '</td>'
        $html += '</tr>'
    }

    $html += '</table>'

    # ------------------------------------------------------------
    # WINDOWS AUDIO ENGINE PROCESS
    # ------------------------------------------------------------

    $html += '<h2>Windows Audio Engine Process</h2><table><tr><th>Process</th><th>PID</th><th>CPU Seconds</th><th>Memory MB</th><th>Threads</th></tr>'

    if ($audioEngineProcesses.Count -eq 0) {
        $html += '<tr><td colspan="5" class="review">audiodg.exe is not currently running. This can be normal when no audio stream is active.</td></tr>'
    }
    else {
        foreach ($process in $audioEngineProcesses) {
            $html += '<tr>'
            $html += '<td>' + (Encode-Html $process.ProcessName) + '</td>'
            $html += '<td>' + $process.PID + '</td>'
            $html += '<td>' + $process.CPUSeconds + '</td>'
            $html += '<td>' + $process.MemoryMB + '</td>'
            $html += '<td>' + $process.Threads + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'

    # ------------------------------------------------------------
    # POWER PLAN
    # ------------------------------------------------------------

    $html += '<h2>Power Configuration</h2><table><tr><th>Active Power Plan</th><td class="mono">' + (Encode-Html $activePowerPlan) + '</td></tr></table>'

    # ------------------------------------------------------------
    # AUDIO EVENT LOG
    # ------------------------------------------------------------

    $html += @"
<h2>Recent Audio-Related Events</h2>
<p class="note">System and Application warnings, errors and critical events from the last three days that mention audio components or common audio-related PnP providers.</p>
<table>
<tr><th>Time</th><th>Level</th><th>Event ID</th><th>Provider</th><th>Message</th></tr>
"@

    if ($audioEvents.Count -eq 0) {
        $html += '<tr><td colspan="5" class="good">No recent audio-related warning, error or critical events were detected.</td></tr>'
    }
    else {
        foreach ($event in $audioEvents) {

            $eventClassName = if ($event.LevelDisplayName -in @('Critical','Error')) { 'bad' } else { 'warn' }

            $html += '<tr>'
            $html += '<td>' + (Encode-Html $event.TimeCreated) + '</td>'
            $html += '<td class="' + $eventClassName + '">' + (Encode-Html $event.LevelDisplayName) + '</td>'
            $html += '<td>' + $event.Id + '</td>'
            $html += '<td>' + (Encode-Html $event.ProviderName) + '</td>'
            $html += '<td>' + (Encode-Html $event.Message) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'

    # ------------------------------------------------------------
    # TECHNICIAN INTERPRETATION NOTES
    # ------------------------------------------------------------

    $html += @"
<h2>Technician Interpretation Notes</h2>
<table>
<tr><th>Critical service stopped</th><td>Windows Audio or Windows Audio Endpoint Builder being stopped is a strong red flag.</td></tr>
<tr><th>Code 10</th><td>Device cannot start. Investigate the driver, device initialization and hardware path.</td></tr>
<tr><th>Code 28</th><td>Driver is not installed.</td></tr>
<tr><th>Code 31</th><td>Windows cannot load the required driver.</td></tr>
<tr><th>Code 43</th><td>The device reported a failure. Investigate the driver, USB/device connection, firmware and hardware.</td></tr>
<tr><th>Unknown with Code 0</th><td>Review only. This commonly represents disconnected, historical or inactive audio endpoints and is not automatically a fault.</td></tr>
<tr><th>Multiple audio devices</th><td>Realtek, HDMI/DisplayPort, NVIDIA/AMD, Bluetooth, USB and controller audio devices can coexist normally.</td></tr>
<tr><th>Choppy or stuttering audio</th><td>This report can identify service, driver, PnP and event-log clues, but it does not directly measure DPC/ISR latency. If these checks are clean, latency testing is a logical next step.</td></tr>
</table>

<div class="footer">Generated: $(Get-Date)<br>RAYMOND'S ENDPOINT TOOLKIT</div>
</body>
</html>
"@

    $html | Out-File -LiteralPath $ReportPath -Encoding UTF8

    exit 0
}
catch {
    Write-Host
    Write-Host 'Audio diagnostic report failed:' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host
    exit 1
}
::PS_AUDIOREPORT_END


:: ============================================================
:: USB DEVICE SECURITY AUDIT
:: ============================================================

:USBAUDIT
@echo off
cls

echo ============================================================
echo USB DEVICE SECURITY AUDIT
echo ============================================================
echo.
echo Auditing connected and historical USB devices...
echo.

call :WriteLog "USB device security audit started"

call :NewReportTimestamp
set "USBREPORT=%LOGDIR%\USBAudit-%COMPUTERNAME%-%REPORTSTAMP%.html"
set "USBSCRIPT=%TEMP%\Raymond_USBAudit_%RANDOM%_%RANDOM%.ps1"
set "RAYMOND_TOOLKIT=%~f0"
set "RAYMOND_USBSCRIPT=%USBSCRIPT%"

powershell.exe -NoProfile -Command "$c=Get-Content -LiteralPath $env:RAYMOND_TOOLKIT; $s=[Array]::IndexOf($c,'::PS_USBAUDIT_BEGIN'); $e=[Array]::IndexOf($c,'::PS_USBAUDIT_END'); if($s -lt 0 -or $e -le $s){exit 1}; $c[($s+1)..($e-1)] | Set-Content -LiteralPath $env:RAYMOND_USBSCRIPT -Encoding UTF8"

if errorlevel 1 (
    echo.
    echo ERROR: Could not prepare USB audit engine.
    call :WriteLog "ERROR: USB audit module extraction failed"
    pause
    goto MENU
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%USBSCRIPT%" -ReportPath "%USBREPORT%"
set "USBERROR=%errorlevel%"
del /f /q "%USBSCRIPT%" >nul 2>&1

if not "%USBERROR%"=="0" (
    echo.
    echo ERROR: USB audit failed.
    call :WriteLog "ERROR: USB audit returned %USBERROR%"
    pause
    goto MENU
)

if exist "%USBREPORT%" (
    call :WriteLog "USB security report created: %USBREPORT%"
    echo USB audit report generated.
    echo.
    echo Opening report...
    start "" "%USBREPORT%"
) else (
    echo.
    echo ERROR: USB audit report could not be generated.
)

echo.
pause
goto MENU


::PS_USBAUDIT_BEGIN
param([Parameter(Mandatory=$true)][string]$ReportPath)
$ErrorActionPreference='SilentlyContinue'
function HtmlEncodeValue($v){if($null -eq $v){return ''};[System.Net.WebUtility]::HtmlEncode([string]$v)}
function VidPid($id){$vid='';$productId='';if($id -match 'VID_([0-9A-Fa-f]{4})'){$vid=$Matches[1].ToUpper()};if($id -match 'PID_([0-9A-Fa-f]{4})'){$productId=$Matches[1].ToUpper()};return @($vid,$productId)}
try {
    $present=@(Get-PnpDevice -PresentOnly | Where-Object {$_.InstanceId -match '^(USB|HID)\\'})
    $all=@(Get-PnpDevice | Where-Object {$_.InstanceId -match '^(USB|HID)\\'})
    $cim=@(Get-CimInstance Win32_PnPEntity | Where-Object {$_.PNPDeviceID -match '^(USB|HID)\\'})
    $signed=@(Get-CimInstance Win32_PnPSignedDriver)
    $presentIds=@{}; foreach($d in $present){$presentIds[$d.InstanceId]=$true}
    $rows=foreach($d in $all){
        $ci=$cim|Where-Object {$_.PNPDeviceID -eq $d.InstanceId}|Select-Object -First 1
        $dr=$signed|Where-Object {$_.DeviceID -eq $d.InstanceId}|Select-Object -First 1
        $vp=VidPid $d.InstanceId
        $isPresent=$presentIds.ContainsKey($d.InstanceId)
        $category='USB Device'
        if($d.Class -eq 'Keyboard' -or $d.FriendlyName -match 'keyboard'){$category='Keyboard / HID'}
        elseif($d.Class -eq 'Mouse' -or $d.FriendlyName -match 'mouse'){$category='Mouse / HID'}
        elseif($d.Class -eq 'HIDClass'){$category='Generic HID'}
        elseif($d.Class -eq 'DiskDrive' -or $d.FriendlyName -match 'Mass Storage|Flash|USB Device'){$category='USB Storage'}
        elseif($d.FriendlyName -match 'Composite'){$category='Composite Device'}
        elseif($d.Class -match 'Net'){$category='USB Network'}
        $flags=@()
        if($isPresent -and $category -in @('Keyboard / HID','Mouse / HID','Generic HID')){$flags+='Active input/HID device'}
        if($category -eq 'USB Storage'){$flags+='USB storage'}
        if($d.FriendlyName -match 'Unknown USB Device'){$flags+='Unknown USB device'}
        if(-not $dr.DriverProviderName -or $dr.DriverProviderName -eq 'Unknown'){$flags+='No clear driver provider'}
        if($ci.ConfigManagerErrorCode -and $ci.ConfigManagerErrorCode -notin 0,22,45){$flags+="PnP error code $($ci.ConfigManagerErrorCode)"}
        [pscustomobject]@{Present=$isPresent;Name=$d.FriendlyName;Class=$d.Class;Category=$category;Status=$d.Status;VID=$vp[0];PID=$vp[1];Manufacturer=$dr.Manufacturer;Provider=$dr.DriverProviderName;DriverVersion=$dr.DriverVersion;ErrorCode=$ci.ConfigManagerErrorCode;InstanceId=$d.InstanceId;Flags=($flags -join '; ')}
    }
    $active=@($rows|Where-Object Present)
    $historical=@($rows|Where-Object {-not $_.Present})
    $review=@($rows|Where-Object {$_.Flags})
    $regStorage=@()
    $usbStor='HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR'
    if(Test-Path $usbStor){foreach($type in Get-ChildItem $usbStor){foreach($inst in Get-ChildItem $type.PSPath){$p=Get-ItemProperty $inst.PSPath;$regStorage+=[pscustomobject]@{Device=$type.PSChildName;Instance=$inst.PSChildName;FriendlyName=$p.FriendlyName;Service=$p.Service}}}}
    $css='body{font-family:Segoe UI,Arial;background:#111;color:#ddd;margin:30px}h1{color:#4CAF50}h2{color:#6fcf73;border-bottom:1px solid #444;padding-bottom:6px}table{border-collapse:collapse;width:100%;margin-bottom:25px}th,td{text-align:left;padding:8px;border-bottom:1px solid #333;vertical-align:top}th{color:#8be28f}.good{color:#55dd77;font-weight:bold}.warn{color:#ffd54f;font-weight:bold}.bad{color:#ff5c5c;font-weight:bold}.review{color:#9aa0a6}.mono{font-family:Consolas,monospace;font-size:12px}.note{color:#aaa}.good{color:#55dd77;font-weight:bold}.warn{color:#ffd54f;font-weight:bold}'
    $html="<!doctype html><html><head><meta charset='utf-8'><title>USB Audit - $env:COMPUTERNAME</title><style>$css</style></head><body><h1>RAYMOND'S ENDPOINT TOOLKIT</h1><p>USB Device Security Audit</p>"
    $html+="<h2>Security Summary</h2><table><tr><th>USB/HID Devices Present</th><td class='good'>$($active.Count)</td></tr><tr><th>Historical / Unplugged USB/HID</th><td>$($historical.Count)</td></tr><tr><th>Items Requiring Review</th><td class='$(if($review.Count){'warn'}else{'good'})'>$($review.Count)</td></tr><tr><th>USB Storage History Entries</th><td class='$(if($regStorage.Count){'warn'}else{'good'})'>$($regStorage.Count)</td></tr></table>"
    $html+="<p class='note'>A HID device is not automatically malicious. Mouse jigglers often appear as ordinary HID mice/keyboards, and some hardware keyloggers may be invisible to Windows. Flags below mean technician review is appropriate, not that malware was proven.</p>"
    function AddTable($title,$items){$script:html+="<h2>$title</h2><table><tr><th>Device</th><th>Category</th><th>Class</th><th>Status</th><th>VID</th><th>PID</th><th>Manufacturer / Provider</th><th>Driver</th><th>Error</th><th>Flags</th><th>Instance ID</th></tr>";if(@($items).Count -eq 0){$script:html+="<tr><td colspan='11' class='good'>None found</td></tr>"}else{foreach($x in $items){$cl=if($x.ErrorCode -and $x.ErrorCode -notin 0,22,45){'bad'}elseif($x.Flags){'warn'}else{'good'};$script:html+="<tr><td>$(HtmlEncodeValue $x.Name)</td><td>$(HtmlEncodeValue $x.Category)</td><td>$(HtmlEncodeValue $x.Class)</td><td class='$cl'>$(HtmlEncodeValue $x.Status)</td><td>$(HtmlEncodeValue $x.VID)</td><td>$(HtmlEncodeValue $x.PID)</td><td>$(HtmlEncodeValue (($x.Manufacturer,$x.Provider|Where-Object {$_}) -join ' / '))</td><td>$(HtmlEncodeValue $x.DriverVersion)</td><td>$(HtmlEncodeValue $x.ErrorCode)</td><td class='$cl'>$(HtmlEncodeValue $x.Flags)</td><td class='mono'>$(HtmlEncodeValue $x.InstanceId)</td></tr>"}};$script:html+='</table>'}
    AddTable 'Currently Connected USB / HID Devices' $active
    AddTable 'Historical / Currently Unplugged USB / HID Devices' $historical
    $html+='<h2>USB Storage History</h2><table><tr><th>Device</th><th>Instance / Serial</th><th>Friendly Name</th><th>Service</th></tr>'
    if($regStorage.Count -eq 0){$html+="<tr><td colspan='4' class='good'>No USBSTOR history entries found</td></tr>"}else{foreach($x in $regStorage){$html+="<tr><td class='mono'>$(HtmlEncodeValue $x.Device)</td><td class='mono'>$(HtmlEncodeValue $x.Instance)</td><td>$(HtmlEncodeValue $x.FriendlyName)</td><td>$(HtmlEncodeValue $x.Service)</td></tr>"}}
    $html+="</table><h2>Interpretation</h2><table><tr><th>Active HID</th><td>Verify unexpected keyboards, mice, generic HID, and composite devices against known peripherals.</td></tr><tr><th>Historical Devices</th><td>Shows devices Windows still knows about even when unplugged. Historical presence alone is not proof of misuse.</td></tr><tr><th>VID / PID</th><td>Use vendor and product IDs to identify unfamiliar hardware. Some devices intentionally use generic identifiers.</td></tr><tr><th>Hardware keyloggers</th><td>Inline hardware keyloggers can be transparent to Windows and cannot be ruled out solely by software inventory.</td></tr></table><p class='note'>Generated: $(Get-Date)</p></body></html>"
    $html|Out-File -LiteralPath $ReportPath -Encoding UTF8
    exit 0
} catch {Write-Host $_.Exception.Message -ForegroundColor Red;exit 1}
::PS_USBAUDIT_END


:: ============================================================
:: BROWSER HISTORY AUDIT
:: ============================================================

:BROWSERAUDIT
@echo off
cls

echo ============================================================
echo BROWSER HISTORY AUDIT
echo ============================================================
echo.
echo Reading local Chrome, Edge, Brave and Firefox history...
echo.
echo NOTE: Browsing history can contain sensitive user information.
echo Use this function only on systems you are authorized to audit.
echo.

choice /C YN /N /M "Continue with browser history audit? [Y/N]: "
if errorlevel 2 goto MENU

call :WriteLog "Browser history audit started"

call :NewReportTimestamp
set "BROWSERREPORT=%LOGDIR%\BrowserHistory-%COMPUTERNAME%-%REPORTSTAMP%.html"
set "BROWSERSCRIPT=%TEMP%\Raymond_BrowserAudit_%RANDOM%_%RANDOM%.ps1"
set "RAYMOND_TOOLKIT=%~f0"
set "RAYMOND_BROWSERSCRIPT=%BROWSERSCRIPT%"

powershell.exe -NoProfile -Command "$c=Get-Content -LiteralPath $env:RAYMOND_TOOLKIT; $s=[Array]::IndexOf($c,'::PS_BROWSERAUDIT_BEGIN'); $e=[Array]::IndexOf($c,'::PS_BROWSERAUDIT_END'); if($s -lt 0 -or $e -le $s){exit 1}; $c[($s+1)..($e-1)] | Set-Content -LiteralPath $env:RAYMOND_BROWSERSCRIPT -Encoding UTF8"

if errorlevel 1 (
    echo.
    echo ERROR: Could not prepare browser audit engine.
    call :WriteLog "ERROR: Browser audit module extraction failed"
    pause
    goto MENU
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%BROWSERSCRIPT%" -ReportPath "%BROWSERREPORT%"
set "BROWSERERROR=%errorlevel%"
del /f /q "%BROWSERSCRIPT%" >nul 2>&1

if not "%BROWSERERROR%"=="0" (
    echo.
    echo ERROR: Browser history audit failed.
    call :WriteLog "ERROR: Browser audit returned %BROWSERERROR%"
    pause
    goto MENU
)

if exist "%BROWSERREPORT%" (
    call :WriteLog "Browser history report created: %BROWSERREPORT%"
    echo Browser history report generated.
    echo.
    echo Opening report...
    start "" "%BROWSERREPORT%"
) else (
    echo.
    echo ERROR: Browser history report could not be generated.
)

echo.
pause
goto MENU


::PS_BROWSERAUDIT_BEGIN
param([Parameter(Mandatory=$true)][string]$ReportPath)
$ErrorActionPreference='SilentlyContinue'
function HtmlEncodeValue($v){if($null -eq $v){return ''};[System.Net.WebUtility]::HtmlEncode([string]$v)}
$cs=@'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public static class WinSqlite {
 public static string LastError = "";
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_open16", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl, CharSet=CharSet.Unicode)] static extern int sqlite3_open16([MarshalAs(UnmanagedType.LPWStr)] string filename,out IntPtr db);
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_close", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl)] static extern int sqlite3_close(IntPtr db);
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_prepare16_v2", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl, CharSet=CharSet.Unicode)] static extern int sqlite3_prepare16_v2(IntPtr db,[MarshalAs(UnmanagedType.LPWStr)] string sql,int nByte,out IntPtr stmt,IntPtr tail);
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_step", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl)] static extern int sqlite3_step(IntPtr stmt);
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_finalize", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl)] static extern int sqlite3_finalize(IntPtr stmt);
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_column_count", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl)] static extern int sqlite3_column_count(IntPtr stmt);
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_column_name16", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl)] static extern IntPtr sqlite3_column_name16(IntPtr stmt,int i);
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_column_text16", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl)] static extern IntPtr sqlite3_column_text16(IntPtr stmt,int i);
 [DllImport("winsqlite3.dll", EntryPoint="sqlite3_errmsg16", ExactSpelling=true, CallingConvention=CallingConvention.Cdecl)] static extern IntPtr sqlite3_errmsg16(IntPtr db);
 static string ErrorText(IntPtr db){IntPtr p=sqlite3_errmsg16(db);return p==IntPtr.Zero?"Unknown SQLite error":Marshal.PtrToStringUni(p);}
 public static List<Dictionary<string,string>> Query(string path,string sql){var r=new List<Dictionary<string,string>>();IntPtr db=IntPtr.Zero,st=IntPtr.Zero;LastError="";int rc=sqlite3_open16(path,out db);if(rc!=0){LastError="Open failed ("+rc+"): "+(db==IntPtr.Zero?"No database handle":ErrorText(db));if(db!=IntPtr.Zero)sqlite3_close(db);return r;}try{rc=sqlite3_prepare16_v2(db,sql,-1,out st,IntPtr.Zero);if(rc!=0){LastError="Prepare failed ("+rc+"): "+ErrorText(db);return r;}try{int n=sqlite3_column_count(st);while((rc=sqlite3_step(st))==100){var d=new Dictionary<string,string>();for(int i=0;i<n;i++){string k=Marshal.PtrToStringUni(sqlite3_column_name16(st,i));IntPtr p=sqlite3_column_text16(st,i);d[k]=p==IntPtr.Zero?"":Marshal.PtrToStringUni(p);}r.Add(d);}if(rc!=101){LastError="Step failed ("+rc+"): "+ErrorText(db);}}finally{if(st!=IntPtr.Zero)sqlite3_finalize(st);}}finally{sqlite3_close(db);}return r;}
}
'@
try{Add-Type -TypeDefinition $cs -Language CSharp -ErrorAction Stop}catch{}
try {
    $tempRoot=Join-Path $env:TEMP ('RaymondBrowser_'+[guid]::NewGuid().ToString('N'));New-Item -ItemType Directory -Path $tempRoot|Out-Null
    $records=New-Object System.Collections.Generic.List[object]
    $dbChecks=New-Object System.Collections.Generic.List[object]
    function Copy-SqliteSet($source,$destination){Copy-Item -LiteralPath $source -Destination $destination -Force -ErrorAction Stop;foreach($suffix in @('-wal','-shm')){if(Test-Path -LiteralPath ($source+$suffix)){Copy-Item -LiteralPath ($source+$suffix) -Destination ($destination+$suffix) -Force -ErrorAction SilentlyContinue}}}
    function AddChromium($browser,$root){if(-not(Test-Path $root)){$dbChecks.Add([pscustomobject]@{Browser=$browser;Profile='';Database=$root;Status='Browser data folder not found';Records=0});return};Get-ChildItem $root -Directory|Where-Object {$_.Name -eq 'Default' -or $_.Name -match '^Profile '}|ForEach-Object{$profileName=$_.Name;$db=Join-Path $_.FullName 'History';if(Test-Path $db){$copy=Join-Path $tempRoot ($browser+'_'+$profileName.Replace(' ','_')+'_'+[guid]::NewGuid().ToString('N')+'.db');try{Copy-SqliteSet $db $copy;$sql='SELECT url,title,visit_count,last_visit_time FROM urls ORDER BY last_visit_time DESC LIMIT 500';$q=@([WinSqlite]::Query($copy,$sql));$status=if([WinSqlite]::LastError){[WinSqlite]::LastError}else{'OK'};$dbChecks.Add([pscustomobject]@{Browser=$browser;Profile=$profileName;Database=$db;Status=$status;Records=$q.Count});foreach($r in $q){try{$t=[datetime]::FromFileTimeUtc(([long]$r['last_visit_time'])*10).ToLocalTime()}catch{$t=$null};try{$domain=([uri]$r['url']).Host}catch{$domain=''};$records.Add([pscustomobject]@{Browser=$browser;Profile=$profileName;Time=$t;Title=$r['title'];Url=$r['url'];Domain=$domain;Visits=$r['visit_count']})}}catch{$dbChecks.Add([pscustomobject]@{Browser=$browser;Profile=$profileName;Database=$db;Status=('Copy/query failed: '+$_.Exception.Message);Records=0})}}}}
    AddChromium 'Chrome' (Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data')
    AddChromium 'Edge' (Join-Path $env:LOCALAPPDATA 'Microsoft\Edge\User Data')
    AddChromium 'Brave' (Join-Path $env:LOCALAPPDATA 'BraveSoftware\Brave-Browser\User Data')
    $ffroot=Join-Path $env:APPDATA 'Mozilla\Firefox\Profiles';if(Test-Path $ffroot){Get-ChildItem $ffroot -Directory|ForEach-Object{$profileName=$_.Name;$db=Join-Path $_.FullName 'places.sqlite';if(Test-Path $db){$copy=Join-Path $tempRoot ('Firefox_'+[guid]::NewGuid().ToString('N')+'.db');try{Copy-SqliteSet $db $copy;$sql='SELECT url,title,visit_count,last_visit_date FROM moz_places WHERE last_visit_date IS NOT NULL ORDER BY last_visit_date DESC LIMIT 500';$q=@([WinSqlite]::Query($copy,$sql));$status=if([WinSqlite]::LastError){[WinSqlite]::LastError}else{'OK'};$dbChecks.Add([pscustomobject]@{Browser='Firefox';Profile=$profileName;Database=$db;Status=$status;Records=$q.Count});foreach($r in $q){try{$t=[DateTimeOffset]::FromUnixTimeMilliseconds(([long]$r['last_visit_date'])/1000).LocalDateTime}catch{$t=$null};try{$domain=([uri]$r['url']).Host}catch{$domain=''};$records.Add([pscustomobject]@{Browser='Firefox';Profile=$profileName;Time=$t;Title=$r['title'];Url=$r['url'];Domain=$domain;Visits=$r['visit_count']})}}catch{$dbChecks.Add([pscustomobject]@{Browser='Firefox';Profile=$profileName;Database=$db;Status=('Copy/query failed: '+$_.Exception.Message);Records=0})}}}}else{$dbChecks.Add([pscustomobject]@{Browser='Firefox';Profile='';Database=$ffroot;Status='Browser data folder not found';Records=0})}
    $rows=@($records|Sort-Object Time -Descending)
    $domains=@($rows|Where-Object Domain|Group-Object Domain|Sort-Object Count -Descending|Select-Object -First 50)
    $profiles=@($rows|Group-Object Browser,Profile|Sort-Object Name)
    $css='body{font-family:Segoe UI,Arial;background:#111;color:#ddd;margin:30px}h1{color:#4CAF50}h2{color:#6fcf73;border-bottom:1px solid #444;padding-bottom:6px}table{border-collapse:collapse;width:100%;margin-bottom:25px}th,td{text-align:left;padding:8px;border-bottom:1px solid #333;vertical-align:top}th{color:#8be28f}a{color:#72a7ff}.mono{font-family:Consolas,monospace;font-size:12px}.note{color:#aaa}'
    $html="<!doctype html><html><head><meta charset='utf-8'><title>Browser History - $env:COMPUTERNAME</title><style>$css</style></head><body><h1>RAYMOND'S ENDPOINT TOOLKIT</h1><p>Browser History Audit</p><p class='note'>This report contains sensitive local browsing history. It intentionally does not collect passwords, cookies, autofill data, or saved credentials.</p>"
    $html+="<h2>Summary</h2><table><tr><th>History Records Collected</th><td>$($rows.Count)</td></tr><tr><th>Browser Profiles With History</th><td>$($profiles.Count)</td></tr><tr><th>Browsers</th><td>$(HtmlEncodeValue (($rows.Browser|Sort-Object -Unique)-join ', '))</td></tr></table>"
    $html+="<h2>Audit Target</h2><table><tr><th>Windows User</th><td>$(HtmlEncodeValue $env:USERNAME)</td></tr><tr><th>User Profile</th><td class='mono'>$(HtmlEncodeValue $env:USERPROFILE)</td></tr></table>"
    $html+='<h2>Browser Database Checks</h2><table><tr><th>Browser</th><th>Profile</th><th>Database</th><th>Status</th><th>Records</th></tr>';foreach($d in $dbChecks){$statusClass=if($d.Status -eq 'OK'){'good'}else{'warn'};$html+="<tr><td>$(HtmlEncodeValue $d.Browser)</td><td>$(HtmlEncodeValue $d.Profile)</td><td class='mono'>$(HtmlEncodeValue $d.Database)</td><td class='$statusClass'>$(HtmlEncodeValue $d.Status)</td><td>$($d.Records)</td></tr>"};$html+='</table>'
    $html+='<h2>Browser Profiles</h2><table><tr><th>Browser / Profile</th><th>Records</th></tr>';if($profiles.Count -eq 0){$html+="<tr><td colspan='2'>No supported browser history found.</td></tr>"}else{foreach($g in $profiles){$html+="<tr><td>$(HtmlEncodeValue $g.Name)</td><td>$($g.Count)</td></tr>"}};$html+='</table>'
    $html+='<h2>Most Visited Domains in Collected History</h2><table><tr><th>Domain</th><th>Records</th></tr>';foreach($g in $domains){$html+="<tr><td>$(HtmlEncodeValue $g.Name)</td><td>$($g.Count)</td></tr>"};$html+='</table>'
    $html+='<h2>Recent Browser History</h2><table><tr><th>Time</th><th>Browser</th><th>Profile</th><th>Domain</th><th>Title</th><th>URL</th><th>Visit Count</th></tr>'
    if($rows.Count -eq 0){$html+="<tr><td colspan='7'>No supported browser history records found.</td></tr>"}else{foreach($x in $rows|Select-Object -First 1000){$url=HtmlEncodeValue $x.Url;$html+="<tr><td>$(HtmlEncodeValue $x.Time)</td><td>$(HtmlEncodeValue $x.Browser)</td><td>$(HtmlEncodeValue $x.Profile)</td><td>$(HtmlEncodeValue $x.Domain)</td><td>$(HtmlEncodeValue $x.Title)</td><td class='mono'><a href='$url'>$url</a></td><td>$(HtmlEncodeValue $x.Visits)</td></tr>"}}
    $html+="</table><p class='note'>Generated: $(Get-Date)</p></body></html>";$html|Out-File -LiteralPath $ReportPath -Encoding UTF8
    Remove-Item $tempRoot -Recurse -Force
    exit 0
}catch{if($tempRoot){Remove-Item $tempRoot -Recurse -Force};Write-Host $_.Exception.Message -ForegroundColor Red;exit 1}
::PS_BROWSERAUDIT_END


:: ============================================================
:: PRIVATE BROWSING / NETWORK / P2P ARTIFACT AUDIT
:: ============================================================

:PRIVATEAUDIT
@echo off
cls

echo ============================================================
echo PRIVATE / NETWORK / P2P ARTIFACT AUDIT
echo ============================================================
echo.
echo This audit does NOT recover deleted Incognito/InPrivate history.
echo It collects residual endpoint and network artifacts that may
echo remain after private browsing activity.
echo.
echo Sources include:
echo   - Current DNS cache
echo   - DNS Client event log, when enabled
echo   - Active browser network connections
echo   - Active browser launch flags
echo   - Recent downloaded files and Zone.Identifier source URLs
echo   - Recent browser session artifact files
echo   - Torrent / P2P client and download artifacts
echo   - Torrent client execution evidence and active connections
echo.
echo NOTE: Results are circumstantial and require technician review.
echo Use only on systems you are authorized to audit.
echo.

choice /C YN /N /M "Continue with private browsing artifact audit? [Y/N]: "
if errorlevel 2 goto MENU

echo.
echo Collecting private browsing, network, and P2P artifacts...
echo.

call :WriteLog "Private browsing/network/P2P artifact audit started"

call :NewReportTimestamp
set "PRIVATEREPORT=%LOGDIR%\PrivateBrowsingArtifacts-%COMPUTERNAME%-%REPORTSTAMP%.html"
set "PRIVATESCRIPT=%TEMP%\Raymond_PrivateAudit_%RANDOM%_%RANDOM%.ps1"
set "RAYMOND_TOOLKIT=%~f0"
set "RAYMOND_PRIVATESCRIPT=%PRIVATESCRIPT%"

powershell.exe -NoProfile -Command "$c=Get-Content -LiteralPath $env:RAYMOND_TOOLKIT; $s=[Array]::IndexOf($c,'::PS_PRIVATEAUDIT_BEGIN'); $e=[Array]::IndexOf($c,'::PS_PRIVATEAUDIT_END'); if($s -lt 0 -or $e -le $s){exit 1}; $c[($s+1)..($e-1)] | Set-Content -LiteralPath $env:RAYMOND_PRIVATESCRIPT -Encoding UTF8"

if errorlevel 1 (
    echo.
    echo ERROR: Could not prepare private browsing audit engine.
    call :WriteLog "ERROR: Private browsing audit module extraction failed"
    pause
    goto MENU
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PRIVATESCRIPT%" -ReportPath "%PRIVATEREPORT%"
set "PRIVATEERROR=%errorlevel%"

del /f /q "%PRIVATESCRIPT%" >nul 2>&1

if not "%PRIVATEERROR%"=="0" (
    echo.
    echo ERROR: Private browsing artifact audit failed.
    call :WriteLog "ERROR: Private browsing audit returned %PRIVATEERROR%"
    echo.
    pause
    goto MENU
)

if exist "%PRIVATEREPORT%" (
    call :WriteLog "Private browsing artifact report created: %PRIVATEREPORT%"
    echo Private browsing artifact report generated.
    echo.
    echo Opening report...
    start "" "%PRIVATEREPORT%"
) else (
    echo.
    echo ERROR: Private browsing artifact report could not be generated.
)

echo.
pause
goto MENU


::PS_PRIVATEAUDIT_BEGIN
param(
    [Parameter(Mandatory = $true)]
    [string]$ReportPath
)

$ErrorActionPreference = 'SilentlyContinue'

function HtmlEncodeValue {
    param($Value)

    if ($null -eq $Value) {
        return ''
    }

    return [System.Net.WebUtility]::HtmlEncode([string]$Value)
}

try {
    $since = (Get-Date).AddDays(-3)

    # ------------------------------------------------------------
    # ACTIVE BROWSER PROCESSES
    # ------------------------------------------------------------

    $browserExecutables = @(
        'chrome.exe',
        'msedge.exe',
        'brave.exe',
        'firefox.exe'
    )

    $browserProcesses = @(
        Get-CimInstance Win32_Process |
        Where-Object {
            $_.Name -in $browserExecutables
        }
    )

    $processRows = foreach ($process in $browserProcesses) {
        $privateFlag = ''

        if ($process.CommandLine -match '(?i)--incognito') {
            $privateFlag = 'Chrome/Chromium --incognito flag observed'
        }
        elseif ($process.CommandLine -match '(?i)--inprivate') {
            $privateFlag = 'Edge --inprivate flag observed'
        }
        elseif ($process.CommandLine -match '(?i)-private-window') {
            $privateFlag = 'Firefox -private-window flag observed'
        }

        [PSCustomObject]@{
            Browser     = $process.Name
            PID         = $process.ProcessId
            Executable  = $process.ExecutablePath
            PrivateFlag = $privateFlag
            CommandLine = $process.CommandLine
        }
    }

    $privateFlagRows = @(
        $processRows |
        Where-Object {
            $_.PrivateFlag
        }
    )


    # ------------------------------------------------------------
    # ACTIVE BROWSER NETWORK CONNECTIONS
    # ------------------------------------------------------------

    $processMap = @{}

    foreach ($process in $processRows) {
        $processMap[[int]$process.PID] = $process.Browser
    }

    $browserPids = @($processRows.PID)

    $networkConnections = @()

    if ($browserPids.Count -gt 0) {
        $networkConnections = @(
            Get-NetTCPConnection -State Established |
            Where-Object {
                $_.OwningProcess -in $browserPids
            } |
            ForEach-Object {
                [PSCustomObject]@{
                    Browser       = $processMap[[int]$_.OwningProcess]
                    PID           = $_.OwningProcess
                    LocalAddress  = $_.LocalAddress
                    LocalPort     = $_.LocalPort
                    RemoteAddress = $_.RemoteAddress
                    RemotePort    = $_.RemotePort
                    State         = $_.State
                }
            }
        )
    }


    # ------------------------------------------------------------
    # WINDOWS DNS CACHE
    # ------------------------------------------------------------

    $dnsCache = @(
        Get-DnsClientCache |
        ForEach-Object {
            $recordName = ''

            if ($_.Entry) {
                $recordName = $_.Entry
            }
            elseif ($_.Name) {
                $recordName = $_.Name
            }
            elseif ($_.RecordName) {
                $recordName = $_.RecordName
            }

            [PSCustomObject]@{
                Name       = $recordName
                Type       = $_.Type
                Data       = $_.Data
                Status     = $_.Status
                TimeToLive = $_.TimeToLive
            }
        } |
        Where-Object {
            $_.Name
        } |
        Sort-Object Name -Unique
    )


    # ------------------------------------------------------------
    # DNS CLIENT OPERATIONAL LOG
    # ------------------------------------------------------------

    $dnsEvents = @()
    $dnsLogStatus = ''

    try {
        $dnsLog = Get-WinEvent -ListLog 'Microsoft-Windows-DNS-Client/Operational' -ErrorAction Stop

        if ($dnsLog.IsEnabled) {
            $dnsEvents = @(
                Get-WinEvent -FilterHashtable @{
                    LogName   = 'Microsoft-Windows-DNS-Client/Operational'
                    StartTime = $since
                } -MaxEvents 200 -ErrorAction Stop
            )

            $dnsLogStatus = 'Enabled - recent events collected'
        }
        else {
            $dnsLogStatus = 'DNS Client Operational log is disabled'
        }
    }
    catch {
        $dnsLogStatus = 'DNS Client Operational log unavailable'
    }


    # ------------------------------------------------------------
    # RECENT DOWNLOADS + MARK OF THE WEB
    # ------------------------------------------------------------

    $downloadRoot = Join-Path $env:USERPROFILE 'Downloads'
    $recentDownloads = @()

    if (Test-Path -LiteralPath $downloadRoot) {
        $downloadFiles = @(
            Get-ChildItem -LiteralPath $downloadRoot -File -Recurse -ErrorAction SilentlyContinue |
            Where-Object {
                $_.LastWriteTime -ge $since
            } |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 250
        )

        $recentDownloads = foreach ($file in $downloadFiles) {
            $zoneText = @(
                Get-Content -LiteralPath $file.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue
            )

            $hostUrl = ''
            $referrerUrl = ''
            $zoneId = ''

            foreach ($line in $zoneText) {
                if ($line -like 'HostUrl=*') {
                    $hostUrl = $line.Substring(8)
                }
                elseif ($line -like 'ReferrerUrl=*') {
                    $referrerUrl = $line.Substring(12)
                }
                elseif ($line -like 'ZoneId=*') {
                    $zoneId = $line.Substring(7)
                }
            }

            [PSCustomObject]@{
                File         = $file.Name
                FullPath     = $file.FullName
                LastWrite    = $file.LastWriteTime
                SizeKB       = [math]::Round($file.Length / 1KB, 1)
                ZoneId       = $zoneId
                HostUrl      = $hostUrl
                ReferrerUrl  = $referrerUrl
            }
        }
    }

    $downloadsWithSource = @(
        $recentDownloads |
        Where-Object {
            $_.HostUrl -or $_.ReferrerUrl
        }
    )


    # ------------------------------------------------------------
    # RECENT BROWSER SESSION ARTIFACT FILES
    # ------------------------------------------------------------

    $sessionArtifacts = New-Object System.Collections.Generic.List[object]

    $chromiumRoots = @(
        [PSCustomObject]@{
            Browser = 'Chrome'
            Root    = Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data'
        },
        [PSCustomObject]@{
            Browser = 'Edge'
            Root    = Join-Path $env:LOCALAPPDATA 'Microsoft\Edge\User Data'
        },
        [PSCustomObject]@{
            Browser = 'Brave'
            Root    = Join-Path $env:LOCALAPPDATA 'BraveSoftware\Brave-Browser\User Data'
        }
    )

    foreach ($browserRoot in $chromiumRoots) {
        if (-not (Test-Path -LiteralPath $browserRoot.Root)) {
            continue
        }

        $profiles = @(
            Get-ChildItem -LiteralPath $browserRoot.Root -Directory |
            Where-Object {
                $_.Name -eq 'Default' -or
                $_.Name -match '^Profile '
            }
        )

        foreach ($profile in $profiles) {
            $candidateLocations = @(
                (Join-Path $profile.FullName 'Sessions'),
                $profile.FullName
            )

            foreach ($location in $candidateLocations) {
                if (-not (Test-Path -LiteralPath $location)) {
                    continue
                }

                Get-ChildItem -LiteralPath $location -File -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.LastWriteTime -ge $since -and
                    $_.Name -match '^(Session_|Tabs_|Current Session$|Current Tabs$|Last Session$|Last Tabs$)'
                } |
                ForEach-Object {
                    $sessionArtifacts.Add(
                        [PSCustomObject]@{
                            Browser   = $browserRoot.Browser
                            Profile   = $profile.Name
                            File      = $_.Name
                            Path      = $_.FullName
                            LastWrite = $_.LastWriteTime
                        }
                    )
                }
            }
        }
    }

    $firefoxRoot = Join-Path $env:APPDATA 'Mozilla\Firefox\Profiles'

    if (Test-Path -LiteralPath $firefoxRoot) {
        Get-ChildItem -LiteralPath $firefoxRoot -Directory |
        ForEach-Object {
            $profile = $_
            $locations = @(
                $profile.FullName,
                (Join-Path $profile.FullName 'sessionstore-backups')
            )

            foreach ($location in $locations) {
                if (-not (Test-Path -LiteralPath $location)) {
                    continue
                }

                Get-ChildItem -LiteralPath $location -File -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.LastWriteTime -ge $since -and
                    $_.Name -match 'sessionstore|recovery|previous'
                } |
                ForEach-Object {
                    $sessionArtifacts.Add(
                        [PSCustomObject]@{
                            Browser   = 'Firefox'
                            Profile   = $profile.Name
                            File      = $_.Name
                            Path      = $_.FullName
                            LastWrite = $_.LastWriteTime
                        }
                    )
                }
            }
        }
    }

    $sessionArtifacts = @(
        $sessionArtifacts |
        Sort-Object LastWrite -Descending |
        Select-Object -First 250
    )


    # ------------------------------------------------------------
    # TORRENT / P2P ARTIFACT AUDIT
    # ------------------------------------------------------------

    # This section looks for multiple independent indicators. A single
    # artifact is not treated as proof of a specific download or activity.
    $torrentClientRegex = '(?i)(qbittorrent|utorrent|bittorrent|deluge|transmission|tixati|vuze|azureus|biglybt|webtorrent)'

    $runningTorrentClients = @(
        Get-CimInstance Win32_Process |
        Where-Object {
            $_.Name -match $torrentClientRegex -or
            $_.ExecutablePath -match $torrentClientRegex
        } |
        ForEach-Object {
            [PSCustomObject]@{
                Process    = $_.Name
                PID        = $_.ProcessId
                Executable = $_.ExecutablePath
                CommandLine = $_.CommandLine
            }
        }
    )

    # Installed-client evidence from machine and current-user uninstall keys.
    $installedTorrentClients = New-Object System.Collections.Generic.List[object]
    $uninstallRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )

    foreach ($root in $uninstallRoots) {
        Get-ItemProperty -Path $root -ErrorAction SilentlyContinue |
        Where-Object {
            $_.DisplayName -and $_.DisplayName -match $torrentClientRegex
        } |
        ForEach-Object {
            $installedTorrentClients.Add(
                [PSCustomObject]@{
                    Name        = $_.DisplayName
                    Version     = $_.DisplayVersion
                    Publisher   = $_.Publisher
                    InstallDate = $_.InstallDate
                    InstallPath = $_.InstallLocation
                }
            )
        }
    }

    $installedTorrentClients = @(
        $installedTorrentClients |
        Sort-Object Name, Version -Unique
    )

    # Known client profile/configuration locations. Resume metadata or
    # client-owned .torrent files are stronger evidence than folder presence.
    $torrentClientLocations = @(
        [PSCustomObject]@{ Client='qBittorrent'; Path=(Join-Path $env:APPDATA 'qBittorrent') },
        [PSCustomObject]@{ Client='qBittorrent'; Path=(Join-Path $env:LOCALAPPDATA 'qBittorrent') },
        [PSCustomObject]@{ Client='uTorrent';     Path=(Join-Path $env:APPDATA 'uTorrent') },
        [PSCustomObject]@{ Client='BitTorrent';   Path=(Join-Path $env:APPDATA 'BitTorrent') },
        [PSCustomObject]@{ Client='Deluge';       Path=(Join-Path $env:APPDATA 'deluge') },
        [PSCustomObject]@{ Client='Transmission'; Path=(Join-Path $env:APPDATA 'Transmission') },
        [PSCustomObject]@{ Client='Transmission'; Path=(Join-Path $env:LOCALAPPDATA 'Transmission') },
        [PSCustomObject]@{ Client='Tixati';       Path=(Join-Path $env:APPDATA 'tixati') },
        [PSCustomObject]@{ Client='Vuze/Azureus'; Path=(Join-Path $env:APPDATA 'Azureus') },
        [PSCustomObject]@{ Client='BiglyBT';      Path=(Join-Path $env:APPDATA 'BiglyBT') },
        [PSCustomObject]@{ Client='WebTorrent';   Path=(Join-Path $env:APPDATA 'WebTorrent') },
        [PSCustomObject]@{ Client='WebTorrent';   Path=(Join-Path $env:LOCALAPPDATA 'WebTorrent') }
    )

    $torrentClientFolders = New-Object System.Collections.Generic.List[object]
    $torrentClientArtifacts = New-Object System.Collections.Generic.List[object]

    foreach ($location in $torrentClientLocations) {
        if (-not (Test-Path -LiteralPath $location.Path)) {
            continue
        }

        $folderInfo = Get-Item -LiteralPath $location.Path -ErrorAction SilentlyContinue
        $torrentClientFolders.Add(
            [PSCustomObject]@{
                Client    = $location.Client
                Path      = $location.Path
                LastWrite = $folderInfo.LastWriteTime
            }
        )

        Get-ChildItem -LiteralPath $location.Path -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Name -match '(?i)(\.torrent$|\.fastresume$|^resume\.dat$|^settings\.dat$|\.state$|\.log$)' -or
            $_.DirectoryName -match '(?i)(BT_backup|state)'
        } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 500 |
        ForEach-Object {
            $evidenceType = 'Client artifact'

            if ($_.Extension -ieq '.fastresume' -or $_.Name -ieq 'resume.dat') {
                $evidenceType = 'Resume metadata'
            }
            elseif ($_.Extension -ieq '.torrent') {
                $evidenceType = 'Torrent metadata'
            }

            $torrentClientArtifacts.Add(
                [PSCustomObject]@{
                    Client       = $location.Client
                    EvidenceType = $evidenceType
                    File         = $_.Name
                    LastWrite    = $_.LastWriteTime
                    SizeKB       = [math]::Round($_.Length / 1KB, 1)
                    Path         = $_.FullName
                }
            )
        }
    }

    $torrentClientFolders = @(
        $torrentClientFolders |
        Sort-Object Client, Path -Unique
    )

    $torrentClientArtifacts = @(
        $torrentClientArtifacts |
        Sort-Object Path -Unique |
        Sort-Object LastWrite -Descending
    )

    $resumeArtifacts = @(
        $torrentClientArtifacts |
        Where-Object {
            $_.EvidenceType -eq 'Resume metadata' -or
            $_.EvidenceType -eq 'Torrent metadata'
        }
    )

    # Standalone .torrent files retained in common user data locations.
    $torrentFiles = New-Object System.Collections.Generic.List[object]
    $torrentSearchRoots = @(
        (Join-Path $env:USERPROFILE 'Downloads'),
        (Join-Path $env:USERPROFILE 'Desktop'),
        (Join-Path $env:USERPROFILE 'Documents')
    )

    foreach ($root in $torrentSearchRoots) {
        if (-not (Test-Path -LiteralPath $root)) {
            continue
        }

        Get-ChildItem -LiteralPath $root -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Extension -ieq '.torrent'
        } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 500 |
        ForEach-Object {
            $torrentFiles.Add(
                [PSCustomObject]@{
                    File      = $_.Name
                    LastWrite = $_.LastWriteTime
                    SizeKB    = [math]::Round($_.Length / 1KB, 1)
                    Path      = $_.FullName
                }
            )
        }
    }

    $torrentFiles = @(
        $torrentFiles |
        Sort-Object Path -Unique |
        Sort-Object LastWrite -Descending
    )

    # Windows Prefetch can preserve evidence that a known client executable
    # ran previously, even when the application is no longer installed.
    $torrentPrefetch = @()
    $prefetchRoot = Join-Path $env:SystemRoot 'Prefetch'

    if (Test-Path -LiteralPath $prefetchRoot) {
        $torrentPrefetch = @(
            Get-ChildItem -LiteralPath $prefetchRoot -File -Filter '*.pf' -ErrorAction SilentlyContinue |
            Where-Object {
                $_.Name -match $torrentClientRegex
            } |
            Sort-Object LastWriteTime -Descending |
            ForEach-Object {
                [PSCustomObject]@{
                    File      = $_.Name
                    LastWrite = $_.LastWriteTime
                    Path      = $_.FullName
                }
            }
        )
    }

    # Background Activity Moderator (BAM) may retain executable-path evidence.
    # Availability varies by Windows build and retention period.
    $torrentBam = New-Object System.Collections.Generic.List[object]
    $bamRoots = @(
        'HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings',
        'HKLM:\SYSTEM\CurrentControlSet\Services\bam\UserSettings'
    )

    foreach ($bamRoot in $bamRoots) {
        if (-not (Test-Path -LiteralPath $bamRoot)) {
            continue
        }

        Get-ChildItem -LiteralPath $bamRoot -ErrorAction SilentlyContinue |
        ForEach-Object {
            $sidKey = $_
            $properties = Get-ItemProperty -LiteralPath $sidKey.PSPath -ErrorAction SilentlyContinue

            foreach ($property in $properties.PSObject.Properties) {
                if ($property.Name -notmatch $torrentClientRegex) {
                    continue
                }

                $lastExecution = ''

                try {
                    if ($property.Value -is [byte[]] -and $property.Value.Length -ge 8) {
                        $fileTime = [BitConverter]::ToInt64($property.Value, 0)
                        if ($fileTime -gt 0) {
                            $lastExecution = [DateTime]::FromFileTimeUtc($fileTime).ToLocalTime()
                        }
                    }
                }
                catch {
                    $lastExecution = ''
                }

                $torrentBam.Add(
                    [PSCustomObject]@{
                        SID           = $sidKey.PSChildName
                        Executable    = $property.Name
                        LastExecution = $lastExecution
                    }
                )
            }
        }
    }

    $torrentBam = @(
        $torrentBam |
        Sort-Object SID, Executable -Unique
    )

    # Current network connections are only associated with known torrent-client
    # processes. Remote ports alone are not used to infer BitTorrent activity.
    $torrentConnections = @()
    $torrentPidMap = @{}

    foreach ($process in $runningTorrentClients) {
        $torrentPidMap[[int]$process.PID] = $process.Process
    }

    $torrentPids = @($runningTorrentClients.PID)

    if ($torrentPids.Count -gt 0) {
        $torrentConnections = @(
            Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue |
            Where-Object {
                $_.OwningProcess -in $torrentPids
            } |
            ForEach-Object {
                [PSCustomObject]@{
                    Client        = $torrentPidMap[[int]$_.OwningProcess]
                    PID           = $_.OwningProcess
                    LocalAddress  = $_.LocalAddress
                    LocalPort     = $_.LocalPort
                    RemoteAddress = $_.RemoteAddress
                    RemotePort    = $_.RemotePort
                    State         = $_.State
                }
            }
        )
    }

    $strongP2PEvidenceCount = @($runningTorrentClients).Count + @($resumeArtifacts).Count
    $supportingP2PEvidenceCount = @($installedTorrentClients).Count + @($torrentClientFolders).Count + @($torrentFiles).Count + @($torrentPrefetch).Count + @($torrentBam).Count

    if ($strongP2PEvidenceCount -gt 0) {
        $p2pConfidence = 'HIGH'
        $p2pClass = 'bad'
        $p2pSummary = 'Strong torrent / P2P artifacts were found. Technician review is recommended.'
    }
    elseif ($supportingP2PEvidenceCount -gt 0) {
        $p2pConfidence = 'MEDIUM'
        $p2pClass = 'warn'
        $p2pSummary = 'Supporting torrent / P2P artifacts were found, but they do not prove a specific transfer.'
    }
    else {
        $p2pConfidence = 'NONE OBSERVED'
        $p2pClass = 'good'
        $p2pSummary = 'No common torrent / P2P artifacts were detected by this audit.'
    }

    # ------------------------------------------------------------
    # HTML REPORT
    # ------------------------------------------------------------

    $css = @'
body{font-family:Segoe UI,Arial;background:#111;color:#ddd;margin:30px}
h1{color:#4CAF50}
h2{color:#6fcf73;border-bottom:1px solid #444;padding-bottom:6px;margin-top:35px}
table{border-collapse:collapse;width:100%;margin-bottom:25px}
th,td{text-align:left;padding:8px;border-bottom:1px solid #333;vertical-align:top}
th{color:#8be28f}
.good{color:#55dd77;font-weight:bold}
.warn{color:#ffd54f;font-weight:bold}
.bad{color:#ff5c5c;font-weight:bold}
.review{color:#9aa0a6}
.mono{font-family:Consolas,monospace;font-size:12px;word-break:break-all}
.note{color:#aaa}
'@

    $privateFlagClass = if ($privateFlagRows.Count -gt 0) { 'warn' } else { 'good' }
    $downloadSourceClass = if ($downloadsWithSource.Count -gt 0) { 'review' } else { 'good' }

    $html = @"
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Private / Network / P2P Artifact Audit - $env:COMPUTERNAME</title>
<style>$css</style>
</head>
<body>
<h1>RAYMOND'S ENDPOINT TOOLKIT</h1>
<p>Private Browsing / Network / P2P Artifact Audit</p>

<p class="note">
This report does not recover deleted Incognito, InPrivate, or Private Browsing history.
It inventories residual artifacts that may correlate with private browsing activity.
DNS entries, network connections, session files, and downloaded-file metadata are not
proof by themselves that a site was visited in private mode.
</p>

<h2>Audit Summary</h2>
<table>
<tr><th>Audit Window</th><td>Last 3 days plus current in-memory/network state</td></tr>
<tr><th>Windows User</th><td>$(HtmlEncodeValue $env:USERNAME)</td></tr>
<tr><th>User Profile</th><td class="mono">$(HtmlEncodeValue $env:USERPROFILE)</td></tr>
<tr><th>Active Browser Processes</th><td>$($processRows.Count)</td></tr>
<tr><th>Private-Mode Launch Flags Observed</th><td class="$privateFlagClass">$($privateFlagRows.Count)</td></tr>
<tr><th>Active Browser TCP Connections</th><td>$($networkConnections.Count)</td></tr>
<tr><th>Current DNS Cache Records</th><td>$($dnsCache.Count)</td></tr>
<tr><th>Recent Downloads</th><td>$($recentDownloads.Count)</td></tr>
<tr><th>Downloads With Source URL Metadata</th><td class="$downloadSourceClass">$($downloadsWithSource.Count)</td></tr>
<tr><th>Recent Browser Session Artifact Files</th><td>$($sessionArtifacts.Count)</td></tr>
<tr><th>Torrent / P2P Evidence Confidence</th><td class="$p2pClass">$p2pConfidence</td></tr>
<tr><th>Running Torrent Clients</th><td class="$(if($runningTorrentClients.Count -gt 0){'bad'}else{'good'})">$($runningTorrentClients.Count)</td></tr>
<tr><th>Known Client Resume / Torrent Metadata</th><td class="$(if($resumeArtifacts.Count -gt 0){'bad'}else{'good'})">$($resumeArtifacts.Count)</td></tr>
<tr><th>Standalone .torrent Files</th><td class="$(if($torrentFiles.Count -gt 0){'warn'}else{'good'})">$($torrentFiles.Count)</td></tr>
<tr><th>Historical Client Execution Artifacts</th><td class="$(if(($torrentPrefetch.Count + $torrentBam.Count) -gt 0){'warn'}else{'good'})">$(($torrentPrefetch.Count + $torrentBam.Count))</td></tr>
</table>

<h2>Interpretation</h2>
<table>
<tr><th>Private launch flag</th><td>A command-line private-mode flag was visible on a currently running browser process. This is useful evidence but may not represent every private window.</td></tr>
<tr><th>DNS cache</th><td>May contain domains resolved by browsers and other applications. Entries cannot be reliably attributed to Incognito/InPrivate alone.</td></tr>
<tr><th>Active connections</th><td>Shows browser-owned TCP connections present at collection time. IP addresses do not necessarily identify the exact page being viewed.</td></tr>
<tr><th>Zone.Identifier</th><td>Downloaded files may retain HostUrl or ReferrerUrl metadata even after private browsing closes, if the downloaded file remains on disk.</td></tr>
<tr><th>Session artifacts</th><td>Shows recent browser session-related files only. Their presence is not proof that private browsing content was persisted.</td></tr>
<tr><th>Torrent / P2P evidence</th><td>Client resume data, running clients, and client-owned torrent metadata are stronger indicators. Installed software, Prefetch, BAM entries, and standalone .torrent files are supporting artifacts and do not prove a particular file was downloaded.</td></tr>
</table>
"@


    # Active browser processes
    $html += '<h2>Active Browser Processes</h2><table><tr><th>Browser</th><th>PID</th><th>Private Mode Indicator</th><th>Executable</th><th>Command Line</th></tr>'

    if ($processRows.Count -eq 0) {
        $html += '<tr><td colspan="5" class="good">No supported browser processes are currently running.</td></tr>'
    }
    else {
        foreach ($row in $processRows) {
            $flagClass = if ($row.PrivateFlag) { 'warn' } else { 'review' }
            $flagText = if ($row.PrivateFlag) { $row.PrivateFlag } else { 'No private-mode launch flag observed' }

            $html += '<tr>'
            $html += '<td>' + (HtmlEncodeValue $row.Browser) + '</td>'
            $html += '<td>' + $row.PID + '</td>'
            $html += '<td class="' + $flagClass + '">' + (HtmlEncodeValue $flagText) + '</td>'
            $html += '<td class="mono">' + (HtmlEncodeValue $row.Executable) + '</td>'
            $html += '<td class="mono">' + (HtmlEncodeValue $row.CommandLine) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'


    # Active browser TCP connections
    $html += '<h2>Active Browser Network Connections</h2><p class="note">Point-in-time established TCP connections owned by supported browser processes.</p><table><tr><th>Browser</th><th>PID</th><th>Local</th><th>Remote</th><th>State</th></tr>'

    if ($networkConnections.Count -eq 0) {
        $html += '<tr><td colspan="5" class="good">No established browser-owned TCP connections were found at collection time.</td></tr>'
    }
    else {
        foreach ($row in $networkConnections) {
            $html += '<tr>'
            $html += '<td>' + (HtmlEncodeValue $row.Browser) + '</td>'
            $html += '<td>' + $row.PID + '</td>'
            $html += '<td class="mono">' + (HtmlEncodeValue ($row.LocalAddress + ':' + $row.LocalPort)) + '</td>'
            $html += '<td class="mono">' + (HtmlEncodeValue ($row.RemoteAddress + ':' + $row.RemotePort)) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.State) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'


    # DNS cache
    $html += '<h2>Current Windows DNS Cache</h2><p class="note">These records may originate from browsers, Windows, or other applications. They are not private-browsing-specific.</p><table><tr><th>Name</th><th>Type</th><th>Data</th><th>Status</th><th>TTL</th></tr>'

    if ($dnsCache.Count -eq 0) {
        $html += '<tr><td colspan="5">No DNS cache entries were returned.</td></tr>'
    }
    else {
        foreach ($row in $dnsCache | Select-Object -First 500) {
            $html += '<tr>'
            $html += '<td class="mono">' + (HtmlEncodeValue $row.Name) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.Type) + '</td>'
            $html += '<td class="mono">' + (HtmlEncodeValue $row.Data) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.Status) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.TimeToLive) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'


    # DNS event log
    $html += '<h2>DNS Client Operational Log</h2>'
    $html += '<p class="note">Status: ' + (HtmlEncodeValue $dnsLogStatus) + '</p>'
    $html += '<table><tr><th>Time</th><th>Event ID</th><th>Provider</th><th>Message</th></tr>'

    if ($dnsEvents.Count -eq 0) {
        $html += '<tr><td colspan="4">No DNS Client Operational events were collected.</td></tr>'
    }
    else {
        foreach ($event in $dnsEvents) {
            $html += '<tr>'
            $html += '<td>' + (HtmlEncodeValue $event.TimeCreated) + '</td>'
            $html += '<td>' + $event.Id + '</td>'
            $html += '<td>' + (HtmlEncodeValue $event.ProviderName) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $event.Message) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'


    # Recent downloads
    $html += '<h2>Recent Downloads and Source Metadata</h2><p class="note">Files modified within the last three days under the current user Downloads folder. HostUrl/ReferrerUrl come from the Windows Zone.Identifier stream when present.</p><table><tr><th>Time</th><th>File</th><th>Size KB</th><th>Zone</th><th>Host URL</th><th>Referrer URL</th><th>Path</th></tr>'

    if ($recentDownloads.Count -eq 0) {
        $html += '<tr><td colspan="7">No recent files were found in Downloads.</td></tr>'
    }
    else {
        foreach ($row in $recentDownloads) {
            $sourceClass = if ($row.HostUrl -or $row.ReferrerUrl) { 'warn' } else { 'review' }

            $html += '<tr>'
            $html += '<td>' + (HtmlEncodeValue $row.LastWrite) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.File) + '</td>'
            $html += '<td>' + $row.SizeKB + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.ZoneId) + '</td>'
            $html += '<td class="' + $sourceClass + ' mono">' + (HtmlEncodeValue $row.HostUrl) + '</td>'
            $html += '<td class="mono">' + (HtmlEncodeValue $row.ReferrerUrl) + '</td>'
            $html += '<td class="mono">' + (HtmlEncodeValue $row.FullPath) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'


    # Session artifacts
    $html += '<h2>Recent Browser Session Artifact Files</h2><p class="note">Metadata only. The toolkit does not parse or claim to recover private session contents from these files.</p><table><tr><th>Browser</th><th>Profile</th><th>Last Modified</th><th>File</th><th>Path</th></tr>'

    if ($sessionArtifacts.Count -eq 0) {
        $html += '<tr><td colspan="5">No recent session artifact files were found for supported browsers.</td></tr>'
    }
    else {
        foreach ($row in $sessionArtifacts) {
            $html += '<tr>'
            $html += '<td>' + (HtmlEncodeValue $row.Browser) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.Profile) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.LastWrite) + '</td>'
            $html += '<td>' + (HtmlEncodeValue $row.File) + '</td>'
            $html += '<td class="mono">' + (HtmlEncodeValue $row.Path) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'

    # Torrent / P2P evidence
    $html += '<h2>Torrent / P2P Evidence</h2>'
    $html += '<p class="note">' + (HtmlEncodeValue $p2pSummary) + ' This section reports endpoint artifacts only and does not determine legality, content, or user intent.</p>'
    $html += '<table><tr><th>Evidence Confidence</th><td class="' + $p2pClass + '">' + (HtmlEncodeValue $p2pConfidence) + '</td></tr>'
    $html += '<tr><th>Running Known Clients</th><td>' + $runningTorrentClients.Count + '</td></tr>'
    $html += '<tr><th>Installed Known Clients</th><td>' + $installedTorrentClients.Count + '</td></tr>'
    $html += '<tr><th>Client Profile Folders</th><td>' + $torrentClientFolders.Count + '</td></tr>'
    $html += '<tr><th>Resume / Torrent Metadata</th><td>' + $resumeArtifacts.Count + '</td></tr>'
    $html += '<tr><th>Standalone .torrent Files</th><td>' + $torrentFiles.Count + '</td></tr>'
    $html += '<tr><th>Prefetch Entries</th><td>' + $torrentPrefetch.Count + '</td></tr>'
    $html += '<tr><th>BAM Execution Entries</th><td>' + $torrentBam.Count + '</td></tr>'
    $html += '<tr><th>Current Client TCP Connections</th><td>' + $torrentConnections.Count + '</td></tr></table>'

    $html += '<h2>Running Torrent / P2P Clients</h2><table><tr><th>Process</th><th>PID</th><th>Executable</th><th>Command Line</th></tr>'
    if ($runningTorrentClients.Count -eq 0) {
        $html += '<tr><td colspan="4" class="good">No known torrent client process is currently running.</td></tr>'
    }
    else {
        foreach ($row in $runningTorrentClients) {
            $html += '<tr><td class="bad">' + (HtmlEncodeValue $row.Process) + '</td><td>' + $row.PID + '</td><td class="mono">' + (HtmlEncodeValue $row.Executable) + '</td><td class="mono">' + (HtmlEncodeValue $row.CommandLine) + '</td></tr>'
        }
    }
    $html += '</table>'

    $html += '<h2>Installed Torrent / P2P Clients</h2><table><tr><th>Name</th><th>Version</th><th>Publisher</th><th>Install Date</th><th>Install Path</th></tr>'
    if ($installedTorrentClients.Count -eq 0) {
        $html += '<tr><td colspan="5" class="good">No common torrent client is currently registered as installed.</td></tr>'
    }
    else {
        foreach ($row in $installedTorrentClients) {
            $html += '<tr><td class="warn">' + (HtmlEncodeValue $row.Name) + '</td><td>' + (HtmlEncodeValue $row.Version) + '</td><td>' + (HtmlEncodeValue $row.Publisher) + '</td><td>' + (HtmlEncodeValue $row.InstallDate) + '</td><td class="mono">' + (HtmlEncodeValue $row.InstallPath) + '</td></tr>'
        }
    }
    $html += '</table>'

    $html += '<h2>Torrent Client Profile / Resume Artifacts</h2><p class="note">Resume metadata and client-owned .torrent files are stronger evidence that a torrent client maintained transfer state.</p><table><tr><th>Client</th><th>Evidence</th><th>Last Modified</th><th>File</th><th>Size KB</th><th>Path</th></tr>'
    if ($torrentClientArtifacts.Count -eq 0) {
        $html += '<tr><td colspan="6" class="good">No known client resume/configuration artifacts were found in the audited profile.</td></tr>'
    }
    else {
        foreach ($row in $torrentClientArtifacts | Select-Object -First 500) {
            $artifactClass = if ($row.EvidenceType -eq 'Resume metadata' -or $row.EvidenceType -eq 'Torrent metadata') { 'bad' } else { 'review' }
            $html += '<tr><td>' + (HtmlEncodeValue $row.Client) + '</td><td class="' + $artifactClass + '">' + (HtmlEncodeValue $row.EvidenceType) + '</td><td>' + (HtmlEncodeValue $row.LastWrite) + '</td><td>' + (HtmlEncodeValue $row.File) + '</td><td>' + $row.SizeKB + '</td><td class="mono">' + (HtmlEncodeValue $row.Path) + '</td></tr>'
        }
    }
    $html += '</table>'

    $html += '<h2>Standalone .torrent Files</h2><p class="note">Searched Downloads, Desktop, and Documents for the current Windows profile. A .torrent file alone does not prove that the transfer was started or completed.</p><table><tr><th>Last Modified</th><th>File</th><th>Size KB</th><th>Path</th></tr>'
    if ($torrentFiles.Count -eq 0) {
        $html += '<tr><td colspan="4" class="good">No standalone .torrent files were found in the common user folders searched.</td></tr>'
    }
    else {
        foreach ($row in $torrentFiles | Select-Object -First 500) {
            $html += '<tr><td>' + (HtmlEncodeValue $row.LastWrite) + '</td><td class="warn">' + (HtmlEncodeValue $row.File) + '</td><td>' + $row.SizeKB + '</td><td class="mono">' + (HtmlEncodeValue $row.Path) + '</td></tr>'
        }
    }
    $html += '</table>'

    $html += '<h2>Historical Torrent Client Execution Evidence</h2><p class="note">Prefetch and BAM may survive after a client is closed or uninstalled. Their availability and retention vary by Windows configuration.</p>'
    $html += '<h3>Prefetch</h3><table><tr><th>Last Modified</th><th>File</th><th>Path</th></tr>'
    if ($torrentPrefetch.Count -eq 0) {
        $html += '<tr><td colspan="3">No matching Prefetch entries were found.</td></tr>'
    }
    else {
        foreach ($row in $torrentPrefetch) {
            $html += '<tr><td>' + (HtmlEncodeValue $row.LastWrite) + '</td><td class="warn">' + (HtmlEncodeValue $row.File) + '</td><td class="mono">' + (HtmlEncodeValue $row.Path) + '</td></tr>'
        }
    }
    $html += '</table>'

    $html += '<h3>Background Activity Moderator (BAM)</h3><table><tr><th>SID</th><th>Last Execution</th><th>Executable</th></tr>'
    if ($torrentBam.Count -eq 0) {
        $html += '<tr><td colspan="3">No matching BAM execution entries were found.</td></tr>'
    }
    else {
        foreach ($row in $torrentBam) {
            $html += '<tr><td class="mono">' + (HtmlEncodeValue $row.SID) + '</td><td>' + (HtmlEncodeValue $row.LastExecution) + '</td><td class="mono warn">' + (HtmlEncodeValue $row.Executable) + '</td></tr>'
        }
    }
    $html += '</table>'

    $html += '<h2>Current Torrent Client Network Connections</h2><p class="note">Only established TCP connections owned by a currently running known torrent client are shown. The presence of a connection does not identify the transferred content.</p><table><tr><th>Client</th><th>PID</th><th>Local</th><th>Remote</th><th>State</th></tr>'
    if ($torrentConnections.Count -eq 0) {
        $html += '<tr><td colspan="5" class="good">No established TCP connections owned by a known torrent client were observed at collection time.</td></tr>'
    }
    else {
        foreach ($row in $torrentConnections) {
            $html += '<tr><td class="bad">' + (HtmlEncodeValue $row.Client) + '</td><td>' + $row.PID + '</td><td class="mono">' + (HtmlEncodeValue ($row.LocalAddress + ':' + $row.LocalPort)) + '</td><td class="mono">' + (HtmlEncodeValue ($row.RemoteAddress + ':' + $row.RemotePort)) + '</td><td>' + (HtmlEncodeValue $row.State) + '</td></tr>'
        }
    }
    $html += '</table>'

    $html += @"
<h2>Limitations</h2>
<table>
<tr><th>Incognito/InPrivate history</th><td>Private-mode browsers are designed not to persist ordinary browsing history after the session closes. This report therefore looks for indirect evidence only.</td></tr>
<tr><th>DNS</th><td>DNS cache entries can expire, be flushed, or come from applications other than the browser.</td></tr>
<tr><th>Encrypted DNS</th><td>DNS-over-HTTPS or a VPN can reduce the usefulness of local Windows DNS artifacts.</td></tr>
<tr><th>Network connections</th><td>Only connections active at collection time are visible here.</td></tr>
<tr><th>Downloads</th><td>Downloaded files can remain after private browsing closes. If the file or Zone.Identifier stream is removed, that evidence is no longer available.</td></tr>
<tr><th>Memory</th><td>This toolkit does not dump browser process memory.</td></tr>
<tr><th>Torrent / P2P</th><td>Artifacts can be deleted, aged out, or absent. This audit cannot prove that a specific payload completed downloading, identify content legality, or attribute activity to a particular person.</td></tr>
</table>

<p class="note">Generated: $(Get-Date)</p>
</body>
</html>
"@

    $html | Out-File -LiteralPath $ReportPath -Encoding UTF8
    exit 0
}
catch {
    Write-Host
    Write-Host 'Private browsing artifact audit failed:' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host
    exit 1
}
::PS_PRIVATEAUDIT_END


:: ============================================================
:: PORT & SERVICE EXPOSURE AUDIT
:: ============================================================

:PORTAUDIT
@echo off
cls

echo ============================================================
echo PORT AND SERVICE EXPOSURE AUDIT
echo ============================================================
echo.
echo Reviewing local listening ports, services and security settings...
echo.

call :WriteLog "Port and service exposure audit started"

call :NewReportTimestamp
set "PORTREPORT=%LOGDIR%\PortExposure-%COMPUTERNAME%-%REPORTSTAMP%.html"
set "PORTSCRIPT=%TEMP%\Raymond_PortAudit_%RANDOM%_%RANDOM%.ps1"

set "RAYMOND_TOOLKIT=%~f0"
set "RAYMOND_PORTSCRIPT=%PORTSCRIPT%"

powershell.exe -NoProfile -Command "$c=Get-Content -LiteralPath $env:RAYMOND_TOOLKIT; $s=[Array]::IndexOf($c,'::PS_PORTAUDIT_BEGIN'); $e=[Array]::IndexOf($c,'::PS_PORTAUDIT_END'); if($s -lt 0 -or $e -le $s){exit 1}; $c[($s+1)..($e-1)] | Set-Content -LiteralPath $env:RAYMOND_PORTSCRIPT -Encoding UTF8"

if errorlevel 1 (
    echo.
    echo ERROR: Could not prepare port audit engine.
    call :WriteLog "ERROR: Port audit PowerShell module extraction failed"
    echo.
    pause
    goto MENU
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PORTSCRIPT%" -ReportPath "%PORTREPORT%"

set "PORTERROR=%errorlevel%"

del /f /q "%PORTSCRIPT%" >nul 2>&1

if not "%PORTERROR%"=="0" (
    echo.
    echo ERROR: Port and service exposure audit failed.
    call :WriteLog "ERROR: Port audit returned %PORTERROR%"
    echo.
    pause
    goto MENU
)

if exist "%PORTREPORT%" (
    call :WriteLog "Port exposure report created: %PORTREPORT%"
    echo Port and service exposure report generated.
    echo.
    echo Opening report...
    start "" "%PORTREPORT%"
) else (
    echo.
    echo ERROR: Port exposure report could not be generated.
    call :WriteLog "ERROR: Port exposure HTML report was not created"
)

echo.
pause
goto MENU


::PS_PORTAUDIT_BEGIN
param(
    [Parameter(Mandatory = $true)]
    [string]$ReportPath
)

$ErrorActionPreference = 'Stop'

function ConvertTo-HtmlText {
    param($Value)

    if ($null -eq $Value) {
        return ''
    }

    return [System.Net.WebUtility]::HtmlEncode([string]$Value)
}

function Get-BindScope {
    param([string]$Address)

    if ([string]::IsNullOrWhiteSpace($Address)) {
        return 'Unknown'
    }

    if ($Address -eq '127.0.0.1' -or $Address -eq '::1') {
        return 'Local Only'
    }

    if ($Address -eq '0.0.0.0' -or $Address -eq '::') {
        return 'All Interfaces'
    }

    return 'Specific Interface'
}

function Get-PortAssessment {
    param(
        [string]$Protocol,
        [int]$Port,
        [string]$Scope,
        [string]$ProcessName,
        [string]$SignatureStatus
    )

    $serviceName = ''
    $risk = 'Info'
    $cssClass = 'review'
    $reason = 'Listening service detected.'

    $knownPorts = @{
        21    = @('FTP', 'Review', 'FTP control port detected. Verify whether encrypted alternatives and appropriate firewall restrictions are used.')
        22    = @('SSH', 'Review', 'SSH service detected. Confirm it is expected and restricted to authorized networks/users.')
        23    = @('Telnet', 'High', 'Telnet is a plaintext remote administration protocol and should normally be disabled.')
        25    = @('SMTP', 'Review', 'SMTP listener detected. Confirm the service is expected and relay/authentication settings are secure.')
        53    = @('DNS', 'Review', 'DNS service detected. Confirm it is expected and not unnecessarily exposed.')
        80    = @('HTTP', 'Review', 'HTTP service detected. Verify whether plaintext HTTP exposure is intended.')
        110   = @('POP3', 'Review', 'POP3 listener detected. Verify whether encrypted mail access is required.')
        135   = @('RPC', 'Review', 'Windows RPC endpoint mapper detected. Restrict exposure to trusted networks.')
        137   = @('NetBIOS', 'Review', 'Legacy NetBIOS service detected. Confirm it is required.')
        138   = @('NetBIOS', 'Review', 'Legacy NetBIOS service detected. Confirm it is required.')
        139   = @('NetBIOS/SMB', 'Review', 'Legacy NetBIOS/SMB service detected. Confirm it is required.')
        143   = @('IMAP', 'Review', 'IMAP listener detected. Verify whether encrypted mail access is required.')
        389   = @('LDAP', 'Review', 'LDAP listener detected. Verify authentication, signing and encryption requirements.')
        443   = @('HTTPS', 'Info', 'HTTPS listener detected. Review certificate and TLS configuration separately if this service is externally reachable.')
        445   = @('SMB', 'Review', 'SMB service detected. Restrict it to trusted networks and verify SMB hardening.')
        1433  = @('SQL Server', 'Review', 'Microsoft SQL Server port detected. Database services should normally be restricted to required hosts.')
        1521  = @('Oracle', 'Review', 'Oracle database listener detected. Confirm network exposure is required.')
        3306  = @('MySQL', 'Review', 'MySQL listener detected. Database services should normally be restricted to required hosts.')
        3389  = @('RDP', 'Review', 'Remote Desktop listener detected. Confirm NLA, firewall scope and access controls.')
        5432  = @('PostgreSQL', 'Review', 'PostgreSQL listener detected. Database services should normally be restricted to required hosts.')
        5900  = @('VNC', 'Review', 'VNC listener detected. Confirm encryption and access controls.')
        5985  = @('WinRM HTTP', 'Review', 'WinRM over HTTP detected. Confirm authentication and network restrictions.')
        5986  = @('WinRM HTTPS', 'Info', 'WinRM over HTTPS detected. Confirm it is expected and appropriately restricted.')
        6379  = @('Redis', 'High', 'Redis is network-facing. Verify authentication, protected mode and firewall restrictions.')
        8080  = @('HTTP Alternate', 'Review', 'Alternate HTTP service detected. Confirm it is expected and appropriately restricted.')
        8443  = @('HTTPS Alternate', 'Review', 'Alternate HTTPS service detected. Confirm it is expected and appropriately restricted.')
        9200  = @('Elasticsearch', 'Review', 'Elasticsearch listener detected. Confirm authentication and network restrictions.')
        11211 = @('Memcached', 'High', 'Memcached is network-facing. It should not normally be exposed to untrusted networks.')
        27017 = @('MongoDB', 'Review', 'MongoDB listener detected. Confirm authentication and network restrictions.')
    }

    if ($knownPorts.ContainsKey($Port)) {
        $entry = $knownPorts[$Port]
        $serviceName = $entry[0]
        $risk = $entry[1]
        $reason = $entry[2]
    }

    if ($Scope -eq 'Local Only') {
        if ($risk -eq 'High') {
            $risk = 'Review'
            $reason += ' The listener is currently bound to loopback only.'
        }
        elseif ($risk -eq 'Review') {
            $risk = 'Info'
            $reason += ' The listener is currently bound to loopback only.'
        }
    }
    elseif ($Scope -eq 'All Interfaces' -or $Scope -eq 'Specific Interface') {
        if (-not $knownPorts.ContainsKey($Port)) {
            $risk = 'Info'
            $reason = 'Network-facing listener detected. Confirm the owning process is expected.'

            if ($SignatureStatus -eq 'NotSigned' -or $SignatureStatus -eq 'HashMismatch' -or $SignatureStatus -eq 'UnknownError') {
                $risk = 'Review'
                $reason = 'Network-facing listener is owned by a process without a valid Authenticode signature. Verify the application.'
            }
        }
    }

    switch ($risk) {
        'High'   { $cssClass = 'bad' }
        'Review' { $cssClass = 'warn' }
        default  { $cssClass = 'good' }
    }

    return [PSCustomObject]@{
        ServiceName = $serviceName
        Risk        = $risk
        CssClass    = $cssClass
        Reason      = $reason
    }
}

try {
    $tcpListeners = @(Get-NetTCPConnection -State Listen -ErrorAction Stop | Sort-Object LocalPort, LocalAddress)
    $udpEndpoints = @(Get-NetUDPEndpoint -ErrorAction Stop | Sort-Object LocalPort, LocalAddress)

    $processes = @(Get-CimInstance Win32_Process)
    $services = @(Get-CimInstance Win32_Service | Where-Object { $_.ProcessId -gt 0 })
    $firewallProfiles = @(Get-NetFirewallProfile -ErrorAction SilentlyContinue)

    $processMap = @{}

    foreach ($process in $processes) {
        $processMap[[int]$process.ProcessId] = $process
    }

    $serviceMap = @{}

    foreach ($service in $services) {
        $key = [int]$service.ProcessId

        if (-not $serviceMap.ContainsKey($key)) {
            $serviceMap[$key] = @()
        }

        $serviceMap[$key] += $service.Name
    }

    $signatureMap = @{}

    function Get-ProcessSignatureStatus {
        param([int]$OwningPid)

        if ($signatureMap.ContainsKey($OwningPid)) {
            return $signatureMap[$OwningPid]
        }

        $status = 'Unavailable'
        $process = $processMap[$OwningPid]

        if ($process -and $process.ExecutablePath -and (Test-Path -LiteralPath $process.ExecutablePath)) {
            try {
                $signature = Get-AuthenticodeSignature -LiteralPath $process.ExecutablePath -ErrorAction Stop
                $status = [string]$signature.Status
            }
            catch {
                $status = 'UnknownError'
            }
        }
        elseif ($OwningPid -eq 4) {
            $status = 'Windows System'
        }

        $signatureMap[$OwningPid] = $status
        return $status
    }

    $tcpRows = @()

    foreach ($listener in $tcpListeners) {
        $owningPid = [int]$listener.OwningProcess
        $process = $processMap[$owningPid]
        $processName = if ($process) { $process.Name } else { 'Unknown' }
        $processPath = if ($process) { $process.ExecutablePath } else { '' }
        $scope = Get-BindScope -Address $listener.LocalAddress
        $signatureStatus = Get-ProcessSignatureStatus -OwningPid $owningPid
        $assessment = Get-PortAssessment -Protocol 'TCP' -Port ([int]$listener.LocalPort) -Scope $scope -ProcessName $processName -SignatureStatus $signatureStatus
        $serviceNames = if ($serviceMap.ContainsKey($owningPid)) { $serviceMap[$owningPid] -join ', ' } else { '' }

        $tcpRows += [PSCustomObject]@{
            Protocol        = 'TCP'
            LocalAddress    = $listener.LocalAddress
            Port            = [int]$listener.LocalPort
            Scope           = $scope
            PID             = $owningPid
            Process         = $processName
            Path            = $processPath
            Services        = $serviceNames
            Signature       = $signatureStatus
            CommonService   = $assessment.ServiceName
            Risk            = $assessment.Risk
            CssClass        = $assessment.CssClass
            Reason          = $assessment.Reason
        }
    }

    $udpRows = @()

    foreach ($endpoint in $udpEndpoints) {
        $owningPid = [int]$endpoint.OwningProcess
        $process = $processMap[$owningPid]
        $processName = if ($process) { $process.Name } else { 'Unknown' }
        $processPath = if ($process) { $process.ExecutablePath } else { '' }
        $scope = Get-BindScope -Address $endpoint.LocalAddress
        $signatureStatus = Get-ProcessSignatureStatus -OwningPid $owningPid
        $assessment = Get-PortAssessment -Protocol 'UDP' -Port ([int]$endpoint.LocalPort) -Scope $scope -ProcessName $processName -SignatureStatus $signatureStatus
        $serviceNames = if ($serviceMap.ContainsKey($owningPid)) { $serviceMap[$owningPid] -join ', ' } else { '' }

        $udpRows += [PSCustomObject]@{
            Protocol        = 'UDP'
            LocalAddress    = $endpoint.LocalAddress
            Port            = [int]$endpoint.LocalPort
            Scope           = $scope
            PID             = $owningPid
            Process         = $processName
            Path            = $processPath
            Services        = $serviceNames
            Signature       = $signatureStatus
            CommonService   = $assessment.ServiceName
            Risk            = $assessment.Risk
            CssClass        = $assessment.CssClass
            Reason          = $assessment.Reason
        }
    }

    $networkFacingTcp = @($tcpRows | Where-Object { $_.Scope -ne 'Local Only' })
    $allInterfaceTcp = @($tcpRows | Where-Object { $_.Scope -eq 'All Interfaces' })
    $highRiskRows = @($tcpRows + $udpRows | Where-Object { $_.Risk -eq 'High' })
    $reviewRows = @($tcpRows + $udpRows | Where-Object { $_.Risk -eq 'Review' })

    $disabledFirewallProfiles = @($firewallProfiles | Where-Object { -not $_.Enabled })

    $smb1State = 'Unavailable'

    try {
        $smb1Feature = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction Stop
        $smb1State = [string]$smb1Feature.State
    }
    catch {
        $smb1State = 'Unable to query'
    }

    $rdpEnabled = $false
    $nlaEnabled = $null

    try {
        $rdpSetting = Get-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -ErrorAction Stop
        $rdpEnabled = ($rdpSetting.fDenyTSConnections -eq 0)
    }
    catch {
        $rdpEnabled = $false
    }

    if ($rdpEnabled) {
        try {
            $nlaSetting = Get-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -ErrorAction Stop
            $nlaEnabled = ($nlaSetting.UserAuthentication -eq 1)
        }
        catch {
            $nlaEnabled = $null
        }
    }

    $smbSigning = $null

    try {
        $smbConfig = Get-SmbServerConfiguration -ErrorAction Stop
        $smbSigning = [PSCustomObject]@{
            Enabled  = $smbConfig.EnableSecuritySignature
            Required = $smbConfig.RequireSecuritySignature
        }
    }
    catch {
        $smbSigning = $null
    }

    $securityFlags = @()

    if ($disabledFirewallProfiles.Count -gt 0) {
        $securityFlags += [PSCustomObject]@{
            Severity = 'High'
            CssClass = 'bad'
            Finding  = 'Windows Firewall profile disabled'
            Details  = 'Disabled profile(s): ' + (($disabledFirewallProfiles | Select-Object -ExpandProperty Name) -join ', ')
        }
    }

    if ($smb1State -eq 'Enabled') {
        $securityFlags += [PSCustomObject]@{
            Severity = 'High'
            CssClass = 'bad'
            Finding  = 'SMBv1 enabled'
            Details  = 'The legacy SMB1Protocol Windows feature is enabled. Review whether it can be disabled.'
        }
    }

    if ($rdpEnabled -and $nlaEnabled -eq $false) {
        $securityFlags += [PSCustomObject]@{
            Severity = 'High'
            CssClass = 'bad'
            Finding  = 'Remote Desktop enabled without NLA'
            Details  = 'RDP is enabled and Network Level Authentication is not enabled.'
        }
    }
    elseif ($rdpEnabled) {
        $securityFlags += [PSCustomObject]@{
            Severity = 'Review'
            CssClass = 'warn'
            Finding  = 'Remote Desktop enabled'
            Details  = if ($nlaEnabled -eq $true) { 'RDP is enabled and NLA is enabled. Confirm firewall scope and business need.' } else { 'RDP is enabled. NLA status could not be determined.' }
        }
    }

    foreach ($row in $highRiskRows) {
        $securityFlags += [PSCustomObject]@{
            Severity = 'High'
            CssClass = 'bad'
            Finding  = "$($row.Protocol) port $($row.Port) - $($row.CommonService)"
            Details  = "$($row.Scope); process $($row.Process) (PID $($row.PID)). $($row.Reason)"
        }
    }

    foreach ($row in $reviewRows | Select-Object -First 20) {
        $securityFlags += [PSCustomObject]@{
            Severity = 'Review'
            CssClass = 'warn'
            Finding  = "$($row.Protocol) port $($row.Port)" + $(if ($row.CommonService) { " - $($row.CommonService)" } else { '' })
            Details  = "$($row.Scope); process $($row.Process) (PID $($row.PID)). $($row.Reason)"
        }
    }

    if ($securityFlags.Count -eq 0) {
        $securityFlags += [PSCustomObject]@{
            Severity = 'Info'
            CssClass = 'good'
            Finding  = 'No high-risk configuration indicators detected'
            Details  = 'Listening ports still require context. This audit does not prove that a service is vulnerability-free.'
        }
    }

    $overallClass = if (@($securityFlags | Where-Object Severity -eq 'High').Count -gt 0) { 'bad' } elseif (@($securityFlags | Where-Object Severity -eq 'Review').Count -gt 0) { 'warn' } else { 'good' }
    $overallText = if ($overallClass -eq 'bad') { 'HIGH-PRIORITY FINDINGS' } elseif ($overallClass -eq 'warn') { 'REVIEW RECOMMENDED' } else { 'NO HIGH-PRIORITY FINDINGS' }

    $html = @"
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Port & Service Exposure Audit - $env:COMPUTERNAME</title>
<style>
body{font-family:Segoe UI,Arial,sans-serif;background:#111;color:#ddd;margin:30px}
h1{color:#4CAF50}
h2{color:#6fcf73;border-bottom:1px solid #444;padding-bottom:6px;margin-top:35px}
table{border-collapse:collapse;width:100%;margin-bottom:25px}
th,td{text-align:left;padding:8px;border-bottom:1px solid #333;vertical-align:top}
th{color:#8be28f}
.good{color:#55dd77;font-weight:bold}
.warn{color:#ffd54f;font-weight:bold}
.bad{color:#ff5c5c;font-weight:bold}
.review{color:#9aa0a6}
.mono{font-family:Consolas,monospace;font-size:12px;word-break:break-all}
.note{color:#aaa}
.footer{color:#777;margin-top:40px}
</style>
</head>
<body>
<h1>RAYMOND'S ENDPOINT TOOLKIT</h1>
<p>Port &amp; Service Exposure Audit</p>
<p class="note">This is a local exposure and configuration audit. An open port is not automatically a vulnerability, and a closed or firewalled port does not guarantee that the associated software is secure.</p>

<h2>Exposure Summary</h2>
<table>
<tr><th>Overall Review</th><td class="$overallClass">$overallText</td></tr>
<tr><th>TCP Listening Ports</th><td>$($tcpRows.Count)</td></tr>
<tr><th>Network-Facing TCP Listeners</th><td>$($networkFacingTcp.Count)</td></tr>
<tr><th>TCP Listeners on All Interfaces</th><td>$($allInterfaceTcp.Count)</td></tr>
<tr><th>UDP Endpoints</th><td>$($udpRows.Count)</td></tr>
<tr><th>High-Priority Findings</th><td class="$(if ($highRiskRows.Count -gt 0) {'bad'} else {'good'})">$($highRiskRows.Count)</td></tr>
<tr><th>Review Findings</th><td class="$(if ($reviewRows.Count -gt 0) {'warn'} else {'good'})">$($reviewRows.Count)</td></tr>
</table>
"@

    $html += '<h2>Security Flags</h2><table><tr><th>Severity</th><th>Finding</th><th>Details</th></tr>'

    foreach ($flag in $securityFlags) {
        $html += '<tr>'
        $html += '<td class="' + $flag.CssClass + '">' + (ConvertTo-HtmlText $flag.Severity) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $flag.Finding) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $flag.Details) + '</td>'
        $html += '</tr>'
    }

    $html += '</table>'

    $html += '<h2>Windows Firewall</h2><table><tr><th>Profile</th><th>Enabled</th><th>Default Inbound</th><th>Default Outbound</th></tr>'

    if ($firewallProfiles.Count -eq 0) {
        $html += '<tr><td colspan="4" class="review">Firewall profile information could not be queried.</td></tr>'
    }
    else {
        foreach ($profile in $firewallProfiles) {
            $fwClass = if ($profile.Enabled) { 'good' } else { 'bad' }
            $html += '<tr>'
            $html += '<td>' + (ConvertTo-HtmlText $profile.Name) + '</td>'
            $html += '<td class="' + $fwClass + '">' + (ConvertTo-HtmlText $profile.Enabled) + '</td>'
            $html += '<td>' + (ConvertTo-HtmlText $profile.DefaultInboundAction) + '</td>'
            $html += '<td>' + (ConvertTo-HtmlText $profile.DefaultOutboundAction) + '</td>'
            $html += '</tr>'
        }
    }

    $html += '</table>'

    $smb1Class = if ($smb1State -eq 'Enabled') { 'bad' } elseif ($smb1State -eq 'Disabled') { 'good' } else { 'review' }
    $rdpClass = if (-not $rdpEnabled) { 'good' } elseif ($nlaEnabled -eq $false) { 'bad' } else { 'warn' }

    $html += '<h2>Remote Access / Legacy Protocol Checks</h2><table>'
    $html += '<tr><th>SMBv1 Feature</th><td class="' + $smb1Class + '">' + (ConvertTo-HtmlText $smb1State) + '</td></tr>'
    $html += '<tr><th>Remote Desktop Enabled</th><td class="' + $rdpClass + '">' + (ConvertTo-HtmlText $rdpEnabled) + '</td></tr>'
    $html += '<tr><th>RDP Network Level Authentication</th><td>' + $(if (-not $rdpEnabled) { 'Not applicable' } elseif ($null -eq $nlaEnabled) { 'Unable to determine' } else { ConvertTo-HtmlText $nlaEnabled }) + '</td></tr>'

    if ($null -ne $smbSigning) {
        $signingClass = if ($smbSigning.Required) { 'good' } else { 'warn' }
        $html += '<tr><th>SMB Signing Enabled</th><td>' + (ConvertTo-HtmlText $smbSigning.Enabled) + '</td></tr>'
        $html += '<tr><th>SMB Signing Required</th><td class="' + $signingClass + '">' + (ConvertTo-HtmlText $smbSigning.Required) + '</td></tr>'
    }
    else {
        $html += '<tr><th>SMB Signing</th><td class="review">Unable to query SMB server configuration.</td></tr>'
    }

    $html += '</table>'

    $html += '<h2>TCP Listening Ports</h2><table><tr><th>Port</th><th>Bind Address</th><th>Exposure</th><th>Process</th><th>PID</th><th>Service</th><th>Signature</th><th>Assessment</th><th>Reason</th><th>Executable</th></tr>'

    foreach ($row in $tcpRows) {
        $serviceDisplay = if ($row.CommonService) { $row.CommonService + $(if ($row.Services) { ' / ' + $row.Services } else { '' }) } else { $row.Services }
        $html += '<tr>'
        $html += '<td class="mono">' + $row.Port + '/TCP</td>'
        $html += '<td class="mono">' + (ConvertTo-HtmlText $row.LocalAddress) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $row.Scope) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $row.Process) + '</td>'
        $html += '<td>' + $row.PID + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $serviceDisplay) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $row.Signature) + '</td>'
        $html += '<td class="' + $row.CssClass + '">' + (ConvertTo-HtmlText $row.Risk) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $row.Reason) + '</td>'
        $html += '<td class="mono">' + (ConvertTo-HtmlText $row.Path) + '</td>'
        $html += '</tr>'
    }

    if ($tcpRows.Count -eq 0) {
        $html += '<tr><td colspan="10" class="good">No TCP listeners were returned.</td></tr>'
    }

    $html += '</table>'

    $html += '<h2>UDP Endpoints</h2><table><tr><th>Port</th><th>Bind Address</th><th>Exposure</th><th>Process</th><th>PID</th><th>Service</th><th>Signature</th><th>Assessment</th><th>Reason</th><th>Executable</th></tr>'

    foreach ($row in $udpRows) {
        $serviceDisplay = if ($row.CommonService) { $row.CommonService + $(if ($row.Services) { ' / ' + $row.Services } else { '' }) } else { $row.Services }
        $html += '<tr>'
        $html += '<td class="mono">' + $row.Port + '/UDP</td>'
        $html += '<td class="mono">' + (ConvertTo-HtmlText $row.LocalAddress) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $row.Scope) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $row.Process) + '</td>'
        $html += '<td>' + $row.PID + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $serviceDisplay) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $row.Signature) + '</td>'
        $html += '<td class="' + $row.CssClass + '">' + (ConvertTo-HtmlText $row.Risk) + '</td>'
        $html += '<td>' + (ConvertTo-HtmlText $row.Reason) + '</td>'
        $html += '<td class="mono">' + (ConvertTo-HtmlText $row.Path) + '</td>'
        $html += '</tr>'
    }

    if ($udpRows.Count -eq 0) {
        $html += '<tr><td colspan="10" class="good">No UDP endpoints were returned.</td></tr>'
    }

    $html += '</table>'

    $html += @"
<h2>How to Interpret This Report</h2>
<table>
<tr><th>High</th><td class="bad">A configuration or network-facing service deserves prompt technician review. It is not automatic proof of exploitable vulnerability.</td></tr>
<tr><th>Review</th><td class="warn">The listener may be legitimate, but confirm business need, firewall scope, authentication and current patching.</td></tr>
<tr><th>Info</th><td class="good">Informational or lower-concern finding based on local configuration. Service-specific vulnerability testing is outside the scope of this audit.</td></tr>
</table>
<p class="note">This option audits the local machine only. It does not scan other hosts, exploit services, or determine CVE exposure from an open port alone.</p>
<div class="footer">Generated: $(Get-Date)<br>RAYMOND'S ENDPOINT TOOLKIT</div>
</body>
</html>
"@

    $html | Out-File -LiteralPath $ReportPath -Encoding UTF8
    exit 0
}
catch {
    Write-Host
    Write-Host 'Port and service exposure audit failed:' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host
    exit 1
}
::PS_PORTAUDIT_END



:: ============================================================
:: MICROSOFT DEFENDER MAINTENANCE
:: ============================================================

:DEFENDER
:DEFENDER_MENU
@echo off
cls
color 0A

echo ============================================================
echo MICROSOFT DEFENDER MAINTENANCE
echo ============================================================
echo.
echo [1] Show Defender Status
echo [2] Update Security Intelligence
echo [3] Run Quick Scan
echo [4] Run Full Scan
echo [5] Scan Specific File / Folder
echo [6] View Threat History
echo [7] Audit Defender Exclusions
echo [8] Generate Defender HTML Report
echo [0] Back to Main Menu
echo.

set "defchoice="
set /p "defchoice=Select an option: "

if "%defchoice%"=="0" goto MENU
if "%defchoice%"=="1" goto DEFENDERSTATUS
if "%defchoice%"=="2" goto DEFENDERUPDATE
if "%defchoice%"=="3" goto DEFENDERQUICK
if "%defchoice%"=="4" goto DEFENDERFULL
if "%defchoice%"=="5" goto DEFENDERCUSTOM
if "%defchoice%"=="6" goto DEFENDERTHREATS
if "%defchoice%"=="7" goto DEFENDEREXCLUSIONS
if "%defchoice%"=="8" goto DEFENDERREPORT

echo.
echo Invalid selection.
timeout /t 2 >nul
goto DEFENDER_MENU

:DEFENDERSTATUS
cls
echo ============================================================
echo MICROSOFT DEFENDER STATUS
echo ============================================================
echo.
call :WriteLog "Microsoft Defender status requested"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$m=Get-MpComputerStatus -ErrorAction SilentlyContinue;if(-not $m){Write-Host 'Microsoft Defender status is unavailable. A third-party antivirus may be active.';exit};$m | Select-Object AMServiceEnabled,AntivirusEnabled,AntispywareEnabled,BehaviorMonitorEnabled,IoavProtectionEnabled,NISEnabled,OnAccessProtectionEnabled,RealTimeProtectionEnabled,AntivirusSignatureLastUpdated,AntivirusSignatureAge,QuickScanAge,FullScanAge | Format-List"
echo.
pause
goto DEFENDER_MENU

:DEFENDERUPDATE
cls
echo ============================================================
echo UPDATE MICROSOFT DEFENDER SECURITY INTELLIGENCE
echo ============================================================
echo.
call :WriteLog "Microsoft Defender signature update started"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Update-MpSignature"
call :WriteLog "Microsoft Defender signature update completed with exit code %errorlevel%"
echo.
pause
goto DEFENDER_MENU

:DEFENDERQUICK
cls
echo ============================================================
echo MICROSOFT DEFENDER QUICK SCAN
echo ============================================================
echo.
echo A Quick Scan can take several minutes.
echo.
choice /C YN /N /M "Start Quick Scan? [Y/N]: "
if errorlevel 2 goto DEFENDER_MENU
call :WriteLog "Microsoft Defender Quick Scan started"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-MpScan -ScanType QuickScan"
call :WriteLog "Microsoft Defender Quick Scan completed with exit code %errorlevel%"
echo.
pause
goto DEFENDER_MENU

:DEFENDERFULL
cls
echo ============================================================
echo MICROSOFT DEFENDER FULL SCAN
echo ============================================================
echo.
echo WARNING: A Full Scan may take a long time.
echo It will run in a separate PowerShell window.
echo.
choice /C YN /N /M "Start Full Scan? [Y/N]: "
if errorlevel 2 goto DEFENDER_MENU
call :WriteLog "Microsoft Defender Full Scan launched"
start "Defender Full Scan" powershell.exe -NoProfile -ExecutionPolicy Bypass -NoExit -Command "Write-Host 'Microsoft Defender Full Scan started.' -ForegroundColor Green; Start-MpScan -ScanType FullScan; Write-Host ''; Write-Host 'Full Scan completed.' -ForegroundColor Green"
goto DEFENDER_MENU

:DEFENDERCUSTOM
cls
echo ============================================================
echo MICROSOFT DEFENDER CUSTOM SCAN
echo ============================================================
echo.
echo Enter a full file or folder path.
echo.
setlocal DisableDelayedExpansion
set "SCANPATH="
set /p "SCANPATH=Path: "
if not defined SCANPATH (
    endlocal
    goto DEFENDER_MENU
)
if not exist "%SCANPATH%" (
    echo.
    echo ERROR: The path does not exist.
    echo.
    endlocal
    pause
    goto DEFENDER_MENU
)
set "RAYMOND_SCANPATH=%SCANPATH%"
call :WriteLog "Microsoft Defender custom scan requested"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-MpScan -ScanType CustomScan -ScanPath $env:RAYMOND_SCANPATH"
endlocal
echo.
pause
goto DEFENDER_MENU

:DEFENDERTHREATS
cls
echo ============================================================
echo MICROSOFT DEFENDER THREAT HISTORY
echo ============================================================
echo.
call :WriteLog "Microsoft Defender threat history viewed"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$t=Get-MpThreatDetection -ErrorAction SilentlyContinue;if(-not $t){Write-Host 'No Defender threat detections were returned.';exit};$t | Select-Object InitialDetectionTime,LastThreatStatusChangeTime,ThreatID,ActionSuccess,@{N='Resources';E={$_.Resources -join '; '}} | Sort-Object InitialDetectionTime -Descending | Format-Table -Wrap -AutoSize"
echo.
pause
goto DEFENDER_MENU

:DEFENDEREXCLUSIONS
cls
echo ============================================================
echo MICROSOFT DEFENDER EXCLUSIONS
echo ============================================================
echo.
call :WriteLog "Microsoft Defender exclusions viewed"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$p=Get-MpPreference -ErrorAction SilentlyContinue;if(-not $p){Write-Host 'Defender preferences are unavailable.';exit};Write-Host 'Excluded Paths:' -ForegroundColor Yellow;$p.ExclusionPath;Write-Host '';Write-Host 'Excluded Processes:' -ForegroundColor Yellow;$p.ExclusionProcess;Write-Host '';Write-Host 'Excluded Extensions:' -ForegroundColor Yellow;$p.ExclusionExtension;Write-Host '';Write-Host 'Excluded IP Addresses:' -ForegroundColor Yellow;$p.ExclusionIpAddress"
echo.
pause
goto DEFENDER_MENU

:DEFENDERREPORT
cls
echo ============================================================
echo MICROSOFT DEFENDER HTML REPORT
echo ============================================================
echo.
call :NewReportTimestamp
set "SECURITYREPORT=%LOGDIR%\Defender-%COMPUTERNAME%-%REPORTSTAMP%.html"
call :RunSecurityReport "Defender" "%SECURITYREPORT%"
if errorlevel 1 (
    echo.
    echo ERROR: Defender report generation failed.
    pause
    goto DEFENDER_MENU
)
call :WriteLog "Microsoft Defender HTML report created: %SECURITYREPORT%"
start "" "%SECURITYREPORT%"
goto DEFENDER_MENU


:: ============================================================
:: MICROSOFT DEFENDER OFFLINE SCAN
:: ============================================================

:DEFENDEROFFLINE
@echo off
cls
echo ============================================================
echo MICROSOFT DEFENDER OFFLINE SCAN
echo ============================================================
echo.
echo WARNING:
echo.
echo This starts Microsoft Defender Offline.
echo Windows may restart automatically to perform the scan.
echo Save all work and close applications before continuing.
echo.
choice /C YN /N /M "Start Defender Offline Scan? [Y/N]: "
if errorlevel 2 goto MENU
call :WriteLog "Microsoft Defender Offline Scan requested"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-MpWDOScan"
if errorlevel 1 (
    echo.
    echo Defender Offline Scan could not be started.
    echo Defender may be disabled or managed by another security product.
    pause
    goto MENU
)
echo.
echo Defender Offline Scan command submitted.
echo Windows may restart shortly.
echo.
pause
goto MENU


:: ============================================================
:: SECURITY REPORT HANDLERS
:: ============================================================

:SECURITYCONFIG
call :GenericSecurityReport "SecurityConfig" "SecurityConfiguration" "Security configuration audit"
goto MENU

:PERSISTENCEAUDIT
call :GenericSecurityReport "Persistence" "PersistenceStartup" "Persistence and startup audit"
goto MENU

:TASKAUDIT
call :GenericSecurityReport "Tasks" "ScheduledTasks" "Scheduled task audit"
goto MENU

:SERVICEAUDIT
call :GenericSecurityReport "Services" "WindowsServices" "Windows service audit"
goto MENU

:USERAUDIT
call :GenericSecurityReport "Users" "UserLocalAdmin" "User and local administrator audit"
goto MENU

:LOGONAUDIT
call :GenericSecurityReport "Logons" "AuthenticationLogons" "Authentication and logon audit"
goto MENU

:SOFTWAREAUDIT
call :GenericSecurityReport "Software" "InstalledSoftware" "Installed software security audit"
goto MENU

:REMOTEAUDIT
call :GenericSecurityReport "RemoteAccess" "RemoteAccess" "Remote access software audit"
goto MENU

:NETSECAUDIT
call :GenericSecurityReport "NetworkSecurity" "NetworkSecurity" "Network configuration security audit"
goto MENU

:FILEAUDIT
call :GenericSecurityReport "Files" "SuspiciousFiles" "File integrity and suspicious file audit"
goto MENU

:UPDATEAUDIT
call :GenericSecurityReport "Updates" "WindowsUpdateHealth" "Windows Update health audit"
goto MENU

:STABILITYAUDIT
call :GenericSecurityReport "Stability" "CrashStability" "Crash and stability audit"
goto MENU

:IRSNAPSHOT
call :GenericSecurityReport "IRSnapshot" "IncidentResponseSnapshot" "Incident response snapshot"
goto MENU


:: ============================================================
:: GENERIC SECURITY REPORT LAUNCHER
:: ============================================================

:GenericSecurityReport
@echo off
setlocal
set "SECMODE=%~1"
set "SECBASENAME=%~2"
set "SECTITLE=%~3"
call :NewReportTimestamp
set "SECURITYREPORT=%LOGDIR%\%SECBASENAME%-%COMPUTERNAME%-%REPORTSTAMP%.html"

echo ============================================================
echo %SECTITLE%
echo ============================================================
echo.
echo Collecting information...
echo.

call :WriteLog "%SECTITLE% started"
call :RunSecurityReport "%SECMODE%" "%SECURITYREPORT%"
set "SECRC=%errorlevel%"

if not "%SECRC%"=="0" (
    echo.
    echo ERROR: %SECTITLE% failed.
    echo.
    call :WriteLog "ERROR: %SECTITLE% returned %SECRC%"
    pause
    endlocal
    exit /b 1
)

if exist "%SECURITYREPORT%" (
    echo Report generated successfully.
    echo.
    echo Opening report...
    call :WriteLog "%SECTITLE% created: %SECURITYREPORT%"
    start "" "%SECURITYREPORT%"
) else (
    echo.
    echo ERROR: Report file was not created.
    call :WriteLog "ERROR: %SECTITLE% report was not created"
)

echo.
pause
endlocal
exit /b 0


:: ============================================================
:: EMBEDDED SECURITY SUITE RUNNER
:: ============================================================

:RunSecurityReport
@echo off
setlocal
set "SECMODE=%~1"
set "SECOUT=%~2"
set "SECSCRIPT=%TEMP%\Raymond_SecuritySuite_%RANDOM%_%RANDOM%.ps1"
set "RAYMOND_TOOLKIT=%~f0"
set "RAYMOND_SECSCRIPT=%SECSCRIPT%"

powershell.exe -NoProfile -Command "$c=Get-Content -LiteralPath $env:RAYMOND_TOOLKIT; $s=[Array]::IndexOf($c,'::PS_SECURITYSUITE_BEGIN'); $e=[Array]::IndexOf($c,'::PS_SECURITYSUITE_END'); if($s -lt 0 -or $e -le $s){exit 1}; $c[($s+1)..($e-1)] | Set-Content -LiteralPath $env:RAYMOND_SECSCRIPT -Encoding UTF8"
if errorlevel 1 (
    del /f /q "%SECSCRIPT%" >nul 2>&1
    endlocal
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SECSCRIPT%" -Mode "%SECMODE%" -ReportPath "%SECOUT%"
set "SECRC=%errorlevel%"
del /f /q "%SECSCRIPT%" >nul 2>&1
endlocal & exit /b %SECRC%


::PS_SECURITYSUITE_BEGIN
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('Defender','SecurityConfig','Persistence','Tasks','Services','Users','Logons','Software','RemoteAccess','NetworkSecurity','Files','Updates','Stability','IRSnapshot')]
    [string]$Mode,

    [Parameter(Mandatory=$true)]
    [string]$ReportPath
)

$ErrorActionPreference = 'SilentlyContinue'

function ConvertTo-HtmlText {
    param($Value)
    if ($null -eq $Value) { return '' }
    if ($Value -is [System.Array]) { $Value = $Value -join ', ' }
    return [System.Net.WebUtility]::HtmlEncode([string]$Value)
}

function Get-CssClass {
    param([string]$Assessment)
    switch -Regex ($Assessment) {
        '^(High|Critical|Bad|Error|Disabled - Risk|Attention)' { 'bad'; break }
        '^(Review|Warning|Warn|Medium)' { 'warn'; break }
        '^(Good|Healthy|OK|Info|Low|Normal)' { 'good'; break }
        default { 'review' }
    }
}

function New-ReportHeader {
    param([string]$Title,[string]$Subtitle)
    return @"
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>$Title - $env:COMPUTERNAME</title>
<style>
body{font-family:Segoe UI,Arial,sans-serif;background:#111;color:#ddd;margin:30px}
h1{color:#4CAF50}h2{color:#6fcf73;border-bottom:1px solid #444;padding-bottom:6px;margin-top:34px}
table{border-collapse:collapse;width:100%;margin-bottom:25px}th,td{text-align:left;padding:8px;border-bottom:1px solid #333;vertical-align:top}th{color:#8be28f}
.good{color:#55dd77;font-weight:bold}.warn{color:#ffd54f;font-weight:bold}.bad{color:#ff5c5c;font-weight:bold}.review{color:#9aa0a6;font-weight:bold}
.mono{font-family:Consolas,monospace;font-size:12px}.note{color:#aaa}.footer{color:#777;margin-top:40px}
</style>
</head>
<body>
<h1>RAYMOND'S ENDPOINT TOOLKIT</h1>
<p>$Subtitle</p>
"@
}

function Add-ObjectTable {
    param(
        [string]$Title,
        [array]$Rows,
        $Columns,
        [string]$EmptyMessage = 'No records returned.'
    )

    $s = '<h2>' + (ConvertTo-HtmlText $Title) + '</h2><table><tr>'
    foreach ($entry in $Columns.GetEnumerator()) {
        $s += '<th>' + (ConvertTo-HtmlText $entry.Value) + '</th>'
    }
    $s += '</tr>'

    if (@($Rows).Count -eq 0) {
        $s += '<tr><td colspan="' + $Columns.Count + '" class="good">' + (ConvertTo-HtmlText $EmptyMessage) + '</td></tr>'
    }
    else {
        foreach ($row in $Rows) {
            $s += '<tr>'
            foreach ($entry in $Columns.GetEnumerator()) {
                $name = [string]$entry.Key
                $value = $row.$name
                $class = ''
                if ($name -in @('Assessment','Risk','Health','Flag')) {
                    $class = Get-CssClass ([string]$value)
                }
                elseif ($name -eq 'Status' -and [string]$value -match 'Error|Failed|Disabled') {
                    $class = 'bad'
                }
                elseif ($name -eq 'Status' -and [string]$value -match 'OK|Running|Healthy|Enabled|Succeeded') {
                    $class = 'good'
                }
                $mono = if ($name -match 'Path|Command|Instance|SID|Address|URL|Hash|Executable') { ' mono' } else { '' }
                $s += '<td class="' + $class + $mono + '">' + (ConvertTo-HtmlText $value) + '</td>'
            }
            $s += '</tr>'
        }
    }

    $s += '</table>'
    return $s
}

function Close-Report {
    return '<div class="footer">Generated: ' + (ConvertTo-HtmlText (Get-Date)) + '<br>Computer: ' + (ConvertTo-HtmlText $env:COMPUTERNAME) + '<br>RAYMOND''S ENDPOINT TOOLKIT</div></body></html>'
}

function Get-ExecutablePath {
    param([string]$Command)
    if ([string]::IsNullOrWhiteSpace($Command)) { return '' }
    if ($Command -match '^\s*"([^"]+\.exe)"') { return $matches[1] }
    if ($Command -match '^\s*(.+?\.exe)(?:\s|$)') { return $matches[1].Trim() }
    return ''
}

function Get-SignatureState {
    param([string]$Path)
    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 'Unavailable' }
    try {
        $sig = Get-AuthenticodeSignature -LiteralPath $Path
        if ($sig.Status -eq 'Valid') {
            if ($sig.SignerCertificate) { return 'Valid - ' + $sig.SignerCertificate.Subject }
            return 'Valid'
        }
        return [string]$sig.Status
    }
    catch { return 'Unavailable' }
}

function Test-UserWritableLocation {
    param([string]$Path)
    if (-not $Path) { return $false }
    return ($Path -match '\\Users\\|\\AppData\\|\\Temp\\|\\Downloads\\|\\Desktop\\')
}

function Get-InstalledSoftware {
    $paths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $items = foreach ($path in $paths) {
        Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object DisplayName | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.DisplayName
                Version = $_.DisplayVersion
                Publisher = $_.Publisher
                InstallDate = $_.InstallDate
                InstallLocation = $_.InstallLocation
                UninstallString = $_.UninstallString
            }
        }
    }
    return @($items | Sort-Object Name -Unique)
}

function Get-LocalGroupMembersSafe {
    param([string]$GroupName)
    $rows = @()
    try {
        $group = [ADSI]("WinNT://$env:COMPUTERNAME/$GroupName,group")
        foreach ($member in @($group.psbase.Invoke('Members'))) {
            $name = $member.GetType().InvokeMember('Name','GetProperty',$null,$member,$null)
            $path = $member.GetType().InvokeMember('ADsPath','GetProperty',$null,$member,$null)
            $rows += [PSCustomObject]@{ Name=$name; Path=$path }
        }
    }
    catch {}
    return $rows
}

function Get-EventDataMap {
    param($Event)
    $map = @{}
    try {
        $xml = [xml]$Event.ToXml()
        foreach ($d in $xml.Event.EventData.Data) {
            if ($d.Name) { $map[[string]$d.Name] = [string]$d.'#text' }
        }
    }
    catch {}
    return $map
}

function Get-RunEntries {
    $locations = @(
        @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Run';Scope='HKCU Run'},
        @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce';Scope='HKCU RunOnce'},
        @{Path='HKLM:\Software\Microsoft\Windows\CurrentVersion\Run';Scope='HKLM Run'},
        @{Path='HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce';Scope='HKLM RunOnce'},
        @{Path='HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run';Scope='HKLM 32-bit Run'}
    )
    $rows = @()
    foreach ($loc in $locations) {
        if (Test-Path $loc.Path) {
            $p = Get-ItemProperty $loc.Path
            foreach ($prop in $p.PSObject.Properties | Where-Object {$_.Name -notmatch '^PS'}) {
                $rows += [PSCustomObject]@{ Location=$loc.Scope; Name=$prop.Name; Command=[string]$prop.Value }
            }
        }
    }
    return $rows
}

function Write-Report {
    param([string]$Content)
    $Content | Out-File -LiteralPath $ReportPath -Encoding UTF8
}

try {

switch ($Mode) {

'Defender' {
    $html = New-ReportHeader 'Microsoft Defender Report' 'Microsoft Defender status, security intelligence, exclusions and recent detections.'
    $statusRows = @()
    $m = Get-MpComputerStatus -ErrorAction SilentlyContinue
    if ($m) {
        $checks = @(
            @('Antivirus Enabled',$m.AntivirusEnabled),
            @('Real-Time Protection',$m.RealTimeProtectionEnabled),
            @('Behavior Monitor',$m.BehaviorMonitorEnabled),
            @('IOAV Protection',$m.IoavProtectionEnabled),
            @('Network Inspection',$m.NISEnabled),
            @('Antivirus Signature Age',$m.AntivirusSignatureAge),
            @('Signature Last Updated',$m.AntivirusSignatureLastUpdated),
            @('Quick Scan Age',$m.QuickScanAge),
            @('Full Scan Age',$m.FullScanAge)
        )
        foreach ($c in $checks) {
            $assessment = 'Info'
            if ($c[0] -match 'Enabled|Protection|Monitor|Inspection') { $assessment = if ($c[1]) {'Good'} else {'High'} }
            elseif ($c[0] -eq 'Antivirus Signature Age') { $assessment = if ([int]$c[1] -gt 7) {'High'} elseif ([int]$c[1] -gt 3) {'Review'} else {'Good'} }
            $statusRows += [PSCustomObject]@{ Setting=$c[0]; Value=$c[1]; Assessment=$assessment }
        }
    }
    else {
        $statusRows += [PSCustomObject]@{Setting='Defender Status';Value='Unavailable';Assessment='Review'}
    }
    $html += Add-ObjectTable 'Defender Health' $statusRows ([ordered]@{Setting='Setting';Value='Value';Assessment='Assessment'})

    $pref = Get-MpPreference -ErrorAction SilentlyContinue
    $exclusions = @()
    if ($pref) {
        foreach ($v in @($pref.ExclusionPath)) { if ($v) {$exclusions += [PSCustomObject]@{Type='Path';Value=$v;Assessment='Review'}} }
        foreach ($v in @($pref.ExclusionProcess)) { if ($v) {$exclusions += [PSCustomObject]@{Type='Process';Value=$v;Assessment='Review'}} }
        foreach ($v in @($pref.ExclusionExtension)) { if ($v) {$exclusions += [PSCustomObject]@{Type='Extension';Value=$v;Assessment='Review'}} }
        foreach ($v in @($pref.ExclusionIpAddress)) { if ($v) {$exclusions += [PSCustomObject]@{Type='IP Address';Value=$v;Assessment='Review'}} }
    }
    $html += Add-ObjectTable 'Defender Exclusions' $exclusions ([ordered]@{Type='Type';Value='Value';Assessment='Assessment'}) 'No Defender exclusions returned.'

    $threats = @(Get-MpThreatDetection -ErrorAction SilentlyContinue | Sort-Object InitialDetectionTime -Descending | Select-Object -First 50 | ForEach-Object {
        [PSCustomObject]@{Time=$_.InitialDetectionTime;ThreatID=$_.ThreatID;ActionSuccess=$_.ActionSuccess;Resources=($_.Resources -join '; ');Assessment=if($_.ActionSuccess){'Review'}else{'High'}}
    })
    $html += Add-ObjectTable 'Recent Threat Detections' $threats ([ordered]@{Time='Detection Time';ThreatID='Threat ID';ActionSuccess='Action Success';Resources='Resources';Assessment='Assessment'}) 'No recent Defender threat detections returned.'
    $html += Close-Report
    Write-Report $html
}

'SecurityConfig' {
    $html = New-ReportHeader 'Security Configuration Audit' 'Core Windows security configuration with conservative technician review flags.'
    $rows = @()
    $m = Get-MpComputerStatus -ErrorAction SilentlyContinue
    if ($m) {
        $rows += [PSCustomObject]@{Area='Defender';Setting='Real-Time Protection';Value=$m.RealTimeProtectionEnabled;Assessment=if($m.RealTimeProtectionEnabled){'Good'}else{'High'};Reason='Real-time malware protection'}
        $rows += [PSCustomObject]@{Area='Defender';Setting='Signature Age';Value=([string]$m.AntivirusSignatureAge+' days');Assessment=if($m.AntivirusSignatureAge -gt 7){'High'}elseif($m.AntivirusSignatureAge -gt 3){'Review'}else{'Good'};Reason='Security intelligence freshness'}
    } else { $rows += [PSCustomObject]@{Area='Defender';Setting='Status';Value='Unavailable';Assessment='Review';Reason='Third-party AV may be active'} }

    foreach ($f in @(Get-NetFirewallProfile -ErrorAction SilentlyContinue)) {
        $rows += [PSCustomObject]@{Area='Firewall';Setting=$f.Name;Value=$f.Enabled;Assessment=if($f.Enabled){'Good'}else{'High'};Reason='Windows Firewall profile'}
    }

    foreach ($b in @(Get-BitLockerVolume -ErrorAction SilentlyContinue)) {
        if ($b.MountPoint) { $rows += [PSCustomObject]@{Area='BitLocker';Setting=$b.MountPoint;Value=$b.ProtectionStatus;Assessment=if($b.ProtectionStatus -eq 'On'){'Good'}else{'Review'};Reason=[string]$b.EncryptionMethod} }
    }

    try {$sb=Confirm-SecureBootUEFI -ErrorAction Stop;$rows += [PSCustomObject]@{Area='Boot';Setting='Secure Boot';Value=$sb;Assessment=if($sb){'Good'}else{'High'};Reason='UEFI Secure Boot'}} catch {$rows += [PSCustomObject]@{Area='Boot';Setting='Secure Boot';Value='Unavailable/Unsupported';Assessment='Review';Reason='May be legacy BIOS or unsupported'}}
    $tpm = Get-Tpm -ErrorAction SilentlyContinue
    if ($tpm) { $rows += [PSCustomObject]@{Area='TPM';Setting='TPM Ready';Value=$tpm.TpmReady;Assessment=if($tpm.TpmReady){'Good'}else{'Review'};Reason=('Present: '+$tpm.TpmPresent)} }

    $uac = Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -ErrorAction SilentlyContinue
    $rows += [PSCustomObject]@{Area='UAC';Setting='EnableLUA';Value=$uac.EnableLUA;Assessment=if($uac.EnableLUA -eq 1){'Good'}else{'High'};Reason='User Account Control'}

    $smb1 = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction SilentlyContinue
    if ($smb1) { $rows += [PSCustomObject]@{Area='SMB';Setting='SMBv1 Feature';Value=$smb1.State;Assessment=if($smb1.State -eq 'Enabled'){'High'}else{'Good'};Reason='Legacy SMBv1 should normally remain disabled'} }
    $smb = Get-SmbServerConfiguration -ErrorAction SilentlyContinue
    if ($smb) {
        $rows += [PSCustomObject]@{Area='SMB';Setting='Server SMB1';Value=$smb.EnableSMB1Protocol;Assessment=if($smb.EnableSMB1Protocol){'High'}else{'Good'};Reason='SMB server protocol'}
        $rows += [PSCustomObject]@{Area='SMB';Setting='Require Signing';Value=$smb.RequireSecuritySignature;Assessment=if($smb.RequireSecuritySignature){'Good'}else{'Review'};Reason='SMB signing policy'}
    }

    $ts = Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -ErrorAction SilentlyContinue
    $rdpEnabled = ($ts.fDenyTSConnections -eq 0)
    $nla = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -ErrorAction SilentlyContinue).UserAuthentication
    $rows += [PSCustomObject]@{Area='RDP';Setting='Remote Desktop';Value=if($rdpEnabled){'Enabled'}else{'Disabled'};Assessment=if($rdpEnabled){'Review'}else{'Good'};Reason='Confirm remote access requirement'}
    if ($rdpEnabled) { $rows += [PSCustomObject]@{Area='RDP';Setting='Network Level Authentication';Value=$nla;Assessment=if($nla -eq 1){'Good'}else{'High'};Reason='NLA protects RDP authentication'}}

    $rr = Get-Service RemoteRegistry -ErrorAction SilentlyContinue
    if ($rr) { $rows += [PSCustomObject]@{Area='Service';Setting='Remote Registry';Value=($rr.Status.ToString()+' / '+$rr.StartType);Assessment=if($rr.Status -eq 'Running'){'Review'}else{'Good'};Reason='Remote registry service'}}
    $wrm = Get-Service WinRM -ErrorAction SilentlyContinue
    if ($wrm) { $rows += [PSCustomObject]@{Area='Service';Setting='WinRM';Value=($wrm.Status.ToString()+' / '+$wrm.StartType);Assessment=if($wrm.Status -eq 'Running'){'Review'}else{'Info'};Reason='Remote management'}}

    $guest = Get-CimInstance Win32_UserAccount -Filter "LocalAccount=True AND Name='Guest'" -ErrorAction SilentlyContinue
    if ($guest) { $rows += [PSCustomObject]@{Area='Accounts';Setting='Guest Account';Value=if($guest.Disabled){'Disabled'}else{'Enabled'};Assessment=if($guest.Disabled){'Good'}else{'High'};Reason='Built-in Guest account'}}

    $html += Add-ObjectTable 'Security Findings' $rows ([ordered]@{Area='Area';Setting='Setting';Value='Value';Assessment='Assessment';Reason='Reason'})
    $admins = Get-LocalGroupMembersSafe 'Administrators'
    $html += Add-ObjectTable 'Local Administrators' $admins ([ordered]@{Name='Member';Path='Account Path'}) 'No local Administrators members returned.'
    $html += '<h2>PowerShell Execution Policies</h2><pre class="mono">'+(ConvertTo-HtmlText ((Get-ExecutionPolicy -List | Out-String)))+'</pre>'
    $html += Close-Report
    Write-Report $html
}

'Persistence' {
    $html = New-ReportHeader 'Persistence / Startup Audit' 'Common Windows persistence locations, startup entries and user-writable launch points.'
    $entries = @()
    foreach ($r in @(Get-RunEntries)) {
        $exe = Get-ExecutablePath $r.Command
        $sig = Get-SignatureState $exe
        $risk = if ((Test-UserWritableLocation $exe) -and $sig -notmatch '^Valid') {'High'} elseif (Test-UserWritableLocation $exe) {'Review'} elseif ($sig -in @('NotSigned','HashMismatch','UnknownError')) {'Review'} else {'Info'}
        $entries += [PSCustomObject]@{Type='Registry Startup';Location=$r.Location;Name=$r.Name;Command=$r.Command;Signature=$sig;Assessment=$risk}
    }

    $startupFolders = @([Environment]::GetFolderPath('Startup'),[Environment]::GetFolderPath('CommonStartup')) | Where-Object {$_ -and (Test-Path $_)}
    foreach ($folder in $startupFolders) {
        foreach ($f in @(Get-ChildItem -LiteralPath $folder -File -ErrorAction SilentlyContinue)) {
            $sig=Get-SignatureState $f.FullName
            $entries += [PSCustomObject]@{Type='Startup Folder';Location=$folder;Name=$f.Name;Command=$f.FullName;Signature=$sig;Assessment=if($sig -match '^Valid'){'Info'}else{'Review'}}
        }
    }

    foreach ($task in @(Get-ScheduledTask -ErrorAction SilentlyContinue)) {
        if ($task.TaskPath -like '\Microsoft\*') { continue }
        foreach ($a in @($task.Actions)) {
            if (-not $a.Execute) {continue}
            $sig=Get-SignatureState $a.Execute
            $entries += [PSCustomObject]@{Type='Scheduled Task';Location=$task.TaskPath;Name=$task.TaskName;Command=($a.Execute+' '+$a.Arguments);Signature=$sig;Assessment=if((Test-UserWritableLocation $a.Execute)-and $sig -notmatch '^Valid'){'High'}elseif($sig -notmatch '^Valid' -and $a.Execute){'Review'}else{'Info'}}
        }
    }

    foreach ($svc in @(Get-CimInstance Win32_Service -ErrorAction SilentlyContinue | Where-Object {$_.StartMode -eq 'Auto'})) {
        $exe=Get-ExecutablePath $svc.PathName
        if (Test-UserWritableLocation $exe) {
            $sig=Get-SignatureState $exe
            $entries += [PSCustomObject]@{Type='Automatic Service';Location=$svc.StartName;Name=$svc.Name;Command=$svc.PathName;Signature=$sig;Assessment=if($sig -match '^Valid'){'Review'}else{'High'}}
        }
    }

    $wmiRows=@()
    foreach ($c in @('CommandLineEventConsumer','ActiveScriptEventConsumer')) {
        foreach ($x in @(Get-CimInstance -Namespace root\subscription -ClassName $c -ErrorAction SilentlyContinue)) {
            $cmd = if($x.CommandLineTemplate){$x.CommandLineTemplate}else{$x.ScriptText}
            $wmiRows += [PSCustomObject]@{Class=$c;Name=$x.Name;Command=$cmd;Assessment='Review'}
        }
    }

    $html += Add-ObjectTable 'Startup / Persistence Entries' $entries ([ordered]@{Type='Type';Location='Location';Name='Name';Command='Command';Signature='Signature';Assessment='Assessment'}) 'No persistence entries were returned from the audited locations.'
    $html += Add-ObjectTable 'WMI Event Consumers' $wmiRows ([ordered]@{Class='Class';Name='Name';Command='Command';Assessment='Assessment'}) 'No command-line or script WMI event consumers detected.'
    $html += Close-Report
    Write-Report $html
}

'Tasks' {
    $html = New-ReportHeader 'Scheduled Task Audit' 'Scheduled tasks with actions, run-as identity, recent run state and executable trust indicators.'
    $rows=@()
    foreach($t in @(Get-ScheduledTask -ErrorAction SilentlyContinue)) {
        $info=Get-ScheduledTaskInfo -TaskName $t.TaskName -TaskPath $t.TaskPath -ErrorAction SilentlyContinue
        foreach($a in @($t.Actions)) {
            $exe=[string]$a.Execute
            $sig=Get-SignatureState $exe
            $assessment='Info'
            if((Test-UserWritableLocation $exe)-and $sig -notmatch '^Valid'){$assessment='High'}
            elseif($t.TaskPath -notlike '\Microsoft\*' -and $sig -notmatch '^Valid' -and $exe){$assessment='Review'}
            $rows += [PSCustomObject]@{Task=($t.TaskPath+$t.TaskName);State=$t.State;RunAs=$t.Principal.UserId;RunLevel=$t.Principal.RunLevel;Executable=$exe;Arguments=$a.Arguments;Signature=$sig;LastRun=$info.LastRunTime;NextRun=$info.NextRunTime;Result=$info.LastTaskResult;Assessment=$assessment}
        }
    }
    $html += Add-ObjectTable 'Scheduled Tasks' $rows ([ordered]@{Task='Task';State='State';RunAs='Run As';RunLevel='Run Level';Executable='Executable';Arguments='Arguments';Signature='Signature';LastRun='Last Run';NextRun='Next Run';Result='Last Result';Assessment='Assessment'})
    $html += Close-Report
    Write-Report $html
}

'Services' {
    $html = New-ReportHeader 'Windows Service Audit' 'Windows services with executable paths, service accounts, signature state and common path weaknesses.'
    $rows=@()
    foreach($s in @(Get-CimInstance Win32_Service -ErrorAction SilentlyContinue)) {
        $exe=Get-ExecutablePath $s.PathName
        $sig=Get-SignatureState $exe
        $unquoted=$false
        if($s.PathName -and $s.PathName -notmatch '^\s*"' -and $exe -match '\s'){$unquoted=$true}
        $assessment='Info';$reason=''
        if((Test-UserWritableLocation $exe)-and $sig -notmatch '^Valid'){$assessment='High';$reason='Service executable in a user-writable location and not validly signed'}
        elseif($unquoted){$assessment='Review';$reason='Unquoted service executable path contains spaces'}
        elseif($exe -and -not(Test-Path -LiteralPath $exe)){$assessment='Review';$reason='Executable path could not be found'}
        elseif($sig -notmatch '^Valid' -and $exe){$assessment='Review';$reason='Executable does not have a valid signature'}
        $rows += [PSCustomObject]@{Name=$s.Name;DisplayName=$s.DisplayName;State=$s.State;StartMode=$s.StartMode;Account=$s.StartName;Executable=$exe;Command=$s.PathName;Signature=$sig;Assessment=$assessment;Reason=$reason}
    }
    $html += Add-ObjectTable 'Windows Services' $rows ([ordered]@{Name='Service';DisplayName='Display Name';State='State';StartMode='Startup';Account='Account';Executable='Executable';Signature='Signature';Assessment='Assessment';Reason='Reason';Command='Full Command'})
    $html += Close-Report
    Write-Report $html
}

'Users' {
    $html = New-ReportHeader 'User / Local Administrator Audit' 'Local accounts and privileged local group membership.'
    $admins=@(Get-LocalGroupMembersSafe 'Administrators')
    $rdp=@(Get-LocalGroupMembersSafe 'Remote Desktop Users')
    $adminNames=@($admins | ForEach-Object {$_.Name})
    $rows=@()
    foreach($u in @(Get-CimInstance Win32_UserAccount -Filter 'LocalAccount=True' -ErrorAction SilentlyContinue)) {
        $assessment='Info';$reason=''
        if($u.Name -eq 'Guest' -and -not $u.Disabled){$assessment='High';$reason='Built-in Guest account is enabled'}
        elseif($adminNames -contains $u.Name){$assessment='Review';$reason='Member of local Administrators'}
        elseif(-not $u.Disabled){$assessment='Info';$reason='Enabled local account'}
        $rows += [PSCustomObject]@{Name=$u.Name;Disabled=$u.Disabled;Lockout=$u.Lockout;PasswordRequired=$u.PasswordRequired;PasswordExpires=$u.PasswordExpires;SID=$u.SID;Assessment=$assessment;Reason=$reason}
    }
    $html += Add-ObjectTable 'Local Accounts' $rows ([ordered]@{Name='Account';Disabled='Disabled';Lockout='Locked';PasswordRequired='Password Required';PasswordExpires='Password Expires';SID='SID';Assessment='Assessment';Reason='Reason'})
    $html += Add-ObjectTable 'Local Administrators' $admins ([ordered]@{Name='Member';Path='Account Path'})
    $html += Add-ObjectTable 'Remote Desktop Users' $rdp ([ordered]@{Name='Member';Path='Account Path'}) 'No Remote Desktop Users members returned.'
    $html += Close-Report
    Write-Report $html
}

'Logons' {
    $html = New-ReportHeader 'Authentication / Logon Audit' 'Recent successful logons, failed logons, lockouts and RDP authentication evidence from Windows event logs.'
    $since=(Get-Date).AddDays(-7)
    $events=@(Get-WinEvent -FilterHashtable @{LogName='Security';Id=4624,4625,4740;StartTime=$since} -ErrorAction SilentlyContinue | Select-Object -First 1000)
    $rows=@()
    $typeMap=@{'2'='Interactive';'3'='Network';'4'='Batch';'5'='Service';'7'='Unlock';'8'='NetworkCleartext';'9'='NewCredentials';'10'='RemoteInteractive/RDP';'11'='CachedInteractive'}
    foreach($e in $events){
        $d=Get-EventDataMap $e
        $user=$d.TargetUserName;if(-not $user){$user=$d.TargetUserName}
        $ip=$d.IpAddress;if(-not $ip){$ip=$d.ClientAddress}
        $lt=$d.LogonType;$ltName=if($typeMap.ContainsKey([string]$lt)){$typeMap[[string]$lt]}else{$lt}
        $result=if($e.Id -eq 4624){'Success'}elseif($e.Id -eq 4625){'Failed'}else{'Lockout'}
        $assessment=if($result -eq 'Failed'){'Review'}elseif($result -eq 'Lockout'){'High'}else{'Info'}
        $rows += [PSCustomObject]@{Time=$e.TimeCreated;EventID=$e.Id;Result=$result;User=$user;Domain=$d.TargetDomainName;LogonType=$ltName;SourceAddress=$ip;Workstation=$d.WorkstationName;Assessment=$assessment}
    }
    $rdpEvents=@()
    try{$rdpRaw=Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational';Id=1149;StartTime=$since} -ErrorAction Stop | Select-Object -First 200}catch{$rdpRaw=@()}
    foreach($e in @($rdpRaw)){$d=Get-EventDataMap $e;$rdpEvents += [PSCustomObject]@{Time=$e.TimeCreated;User=$d.Param1;Domain=$d.Param2;SourceAddress=$d.Param3;Assessment='Review'}}
    $html += Add-ObjectTable 'Security Log Authentication Events - Last 7 Days' $rows ([ordered]@{Time='Time';EventID='Event ID';Result='Result';User='User';Domain='Domain';LogonType='Logon Type';SourceAddress='Source IP';Workstation='Workstation';Assessment='Assessment'}) 'No matching Security log authentication events returned.'
    $html += Add-ObjectTable 'RDP Authentication Events - Event 1149' $rdpEvents ([ordered]@{Time='Time';User='User';Domain='Domain';SourceAddress='Source IP';Assessment='Assessment'}) 'No recent RDP 1149 events returned.'
    $html += Close-Report
    Write-Report $html
}

'Software' {
    $html = New-ReportHeader 'Installed Software Security Audit' 'Installed software inventory with review categories for remote access, P2P, VPN and scripting/runtime tools.'
    $rows=@()
    foreach($s in @(Get-InstalledSoftware)) {
        $category='General';$assessment='Info'
        if($s.Name -match 'AnyDesk|TeamViewer|ScreenConnect|ConnectWise Control|Splashtop|RustDesk|VNC|LogMeIn|Remote Utilities|Chrome Remote Desktop|GoToAssist|DWService|Dameware|Zoho Assist'){$category='Remote Access';$assessment='Review'}
        elseif($s.Name -match 'qBittorrent|uTorrent|BitTorrent|Deluge|Transmission|Tixati|Vuze|Azureus|BiglyBT|WebTorrent'){$category='P2P / Torrent';$assessment='Review'}
        elseif($s.Name -match 'OpenVPN|WireGuard|Tailscale|ZeroTier|NordVPN|ExpressVPN|Proton VPN|Cisco AnyConnect|GlobalProtect|FortiClient|Cloudflare WARP'){$category='VPN / Tunnel';$assessment='Review'}
        elseif($s.Name -match 'Python|Node.js|Ruby|Perl|Git|PowerShell'){$category='Scripting / Development';$assessment='Info'}
        $rows += [PSCustomObject]@{Name=$s.Name;Version=$s.Version;Publisher=$s.Publisher;InstallDate=$s.InstallDate;Category=$category;InstallLocation=$s.InstallLocation;Assessment=$assessment}
    }
    $html += Add-ObjectTable 'Installed Applications' $rows ([ordered]@{Name='Application';Version='Version';Publisher='Publisher';InstallDate='Install Date';Category='Category';InstallLocation='Install Location';Assessment='Assessment'})
    $html += Close-Report
    Write-Report $html
}

'RemoteAccess' {
    $html = New-ReportHeader 'Remote Access Software Audit' 'Installed, running and service-based remote access software plus Windows RDP status.'
    $pattern='AnyDesk|TeamViewer|ScreenConnect|ConnectWise|Splashtop|RustDesk|VNC|LogMeIn|Remote Utilities|Chrome Remote Desktop|GoToAssist|DWService|Dameware|Zoho|MeshCentral|RemotePC'
    $rows=@()
    foreach($s in @(Get-InstalledSoftware | Where-Object {$_.Name -match $pattern})){$rows += [PSCustomObject]@{Source='Installed Software';Name=$s.Name;Status='Installed';Executable=$s.InstallLocation;Assessment='Review'}}
    foreach($p in @(Get-Process -ErrorAction SilentlyContinue | Where-Object {$_.ProcessName -match $pattern})){$rows += [PSCustomObject]@{Source='Running Process';Name=$p.ProcessName;Status='Running';Executable=$p.Path;Assessment='High'}}
    foreach($s in @(Get-CimInstance Win32_Service -ErrorAction SilentlyContinue | Where-Object {$_.Name -match $pattern -or $_.DisplayName -match $pattern -or $_.PathName -match $pattern})){$rows += [PSCustomObject]@{Source='Windows Service';Name=$s.DisplayName;Status=$s.State;Executable=$s.PathName;Assessment=if($s.State -eq 'Running'){'High'}else{'Review'}}}
    $ts=Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -ErrorAction SilentlyContinue
    $rdpEnabled=($ts.fDenyTSConnections -eq 0)
    $rows += [PSCustomObject]@{Source='Windows RDP';Name='Remote Desktop';Status=if($rdpEnabled){'Enabled'}else{'Disabled'};Executable='TCP/3389';Assessment=if($rdpEnabled){'Review'}else{'Good'}}
    $html += Add-ObjectTable 'Remote Access Findings' $rows ([ordered]@{Source='Evidence Source';Name='Product / Component';Status='Status';Executable='Path / Detail';Assessment='Assessment'}) 'No known third-party remote access software evidence returned.'
    $html += Close-Report
    Write-Report $html
}

'NetworkSecurity' {
    $html = New-ReportHeader 'Network Configuration Security Audit' 'DNS, proxy, hosts file, network profiles, routes, shares, SMB and firewall configuration.'
    $adapterRows=@()
    foreach($c in @(Get-NetIPConfiguration -ErrorAction SilentlyContinue)){
        $adapterRows += [PSCustomObject]@{Interface=$c.InterfaceAlias;IPv4=(@($c.IPv4Address.IPAddress)-join ', ');Gateway=(@($c.IPv4DefaultGateway.NextHop)-join ', ');DNS=(@($c.DNSServer.ServerAddresses)-join ', ');Assessment='Info'}
    }
    $html += Add-ObjectTable 'IP / DNS Configuration' $adapterRows ([ordered]@{Interface='Interface';IPv4='IPv4';Gateway='Gateway';DNS='DNS Servers';Assessment='Assessment'})

    $proxy=Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction SilentlyContinue
    $proxyRows=@([PSCustomObject]@{Setting='User Proxy Enabled';Value=$proxy.ProxyEnable;Assessment=if($proxy.ProxyEnable -eq 1){'Review'}else{'Good'}},[PSCustomObject]@{Setting='Proxy Server';Value=$proxy.ProxyServer;Assessment=if($proxy.ProxyServer){'Review'}else{'Info'}},[PSCustomObject]@{Setting='Auto Config URL';Value=$proxy.AutoConfigURL;Assessment=if($proxy.AutoConfigURL){'Review'}else{'Info'}})
    $html += Add-ObjectTable 'Proxy Configuration' $proxyRows ([ordered]@{Setting='Setting';Value='Value';Assessment='Assessment'})
    $html += '<h2>WinHTTP Proxy</h2><pre class="mono">'+(ConvertTo-HtmlText ((netsh winhttp show proxy | Out-String)))+'</pre>'

    $hostsPath="$env:SystemRoot\System32\drivers\etc\hosts";$hostRows=@()
    if(Test-Path $hostsPath){foreach($line in @(Get-Content $hostsPath | Where-Object {$_.Trim() -and -not $_.Trim().StartsWith('#')})){$hostRows += [PSCustomObject]@{Entry=$line;Assessment='Review'}}}
    $html += Add-ObjectTable 'Custom Hosts File Entries' $hostRows ([ordered]@{Entry='Entry';Assessment='Assessment'}) 'No custom hosts-file entries found.'

    $profileRows=@(Get-NetConnectionProfile -ErrorAction SilentlyContinue | ForEach-Object {[PSCustomObject]@{Name=$_.Name;Interface=$_.InterfaceAlias;Category=$_.NetworkCategory;IPv4=$_.IPv4Connectivity;Assessment=if($_.NetworkCategory -eq 'Public'){'Review'}else{'Info'}}})
    $html += Add-ObjectTable 'Network Profiles' $profileRows ([ordered]@{Name='Network';Interface='Interface';Category='Category';IPv4='IPv4 Connectivity';Assessment='Assessment'})

    $shareRows=@(Get-SmbShare -ErrorAction SilentlyContinue | ForEach-Object {[PSCustomObject]@{Name=$_.Name;Path=$_.Path;Description=$_.Description;Assessment=if($_.Name -in @('ADMIN$','C$','IPC$')){'Info'}else{'Review'}}})
    $html += Add-ObjectTable 'SMB Shares' $shareRows ([ordered]@{Name='Share';Path='Path';Description='Description';Assessment='Assessment'})

    $fwRows=@(Get-NetFirewallProfile -ErrorAction SilentlyContinue | ForEach-Object {[PSCustomObject]@{Profile=$_.Name;Enabled=$_.Enabled;DefaultInbound=$_.DefaultInboundAction;DefaultOutbound=$_.DefaultOutboundAction;Assessment=if($_.Enabled){'Good'}else{'High'}}})
    $html += Add-ObjectTable 'Firewall Profiles' $fwRows ([ordered]@{Profile='Profile';Enabled='Enabled';DefaultInbound='Default Inbound';DefaultOutbound='Default Outbound';Assessment='Assessment'})
    $html += Close-Report
    Write-Report $html
}

'Files' {
    $html = New-ReportHeader 'File Integrity / Suspicious File Audit' 'Recent executable and script files in common user-writable locations, with signatures, hashes and Mark-of-the-Web evidence.'
    $since=(Get-Date).AddDays(-30)
    $roots=@($env:USERPROFILE+'\Downloads',[Environment]::GetFolderPath('Desktop'),$env:TEMP,$env:LOCALAPPDATA+'\Temp',[Environment]::GetFolderPath('Startup')) | Where-Object {$_ -and (Test-Path $_)} | Select-Object -Unique
    $ext=@('.exe','.dll','.msi','.ps1','.bat','.cmd','.vbs','.js','.jse','.wsf','.scr','.com')
    $files=@()
    foreach($root in $roots){
        foreach($f in @(Get-ChildItem -LiteralPath $root -File -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.LastWriteTime -ge $since -and $ext -contains $_.Extension.ToLower()} | Select-Object -First 300)){
            $sig=Get-SignatureState $f.FullName
            $zone='';$source=''
            try{$z=Get-Content -LiteralPath ($f.FullName+':Zone.Identifier') -ErrorAction Stop;$zone=($z | Select-String '^ZoneId=' | Select-Object -First 1).Line;$source=($z | Select-String '^(HostUrl|ReferrerUrl)=' | ForEach-Object {$_.Line}) -join '; '}catch{}
            $hash='Skipped'
            if($f.Length -le 200MB){try{$hash=(Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash}catch{$hash='Unavailable'}}
            $assessment='Info'
            if($f.Extension -in @('.exe','.dll','.msi','.scr','.com') -and $sig -notmatch '^Valid' -and $zone){$assessment='High'}
            elseif($sig -notmatch '^Valid' -or $zone){$assessment='Review'}
            $files += [PSCustomObject]@{Modified=$f.LastWriteTime;Name=$f.Name;Path=$f.FullName;SizeMB=[math]::Round($f.Length/1MB,2);Signature=$sig;Zone=$zone;SourceURL=$source;SHA256=$hash;Assessment=$assessment}
        }
    }
    $html += Add-ObjectTable 'Recent Executable / Script Files' $files ([ordered]@{Modified='Modified';Name='File';Path='Path';SizeMB='Size MB';Signature='Signature';Zone='Zone';SourceURL='Source URL';SHA256='SHA-256';Assessment='Assessment'}) 'No matching recent files were found in the audited locations.'
    $html += '<p class="note">Audit window: last 30 days. Hashing is skipped for files larger than 200 MB to keep the portable toolkit responsive.</p>'
    $html += Close-Report
    Write-Report $html
}

'Updates' {
    $html = New-ReportHeader 'Windows Update Health' 'Windows build, update services, pending reboot indicators, installed hotfixes and Windows Update history.'
    $os=Get-CimInstance Win32_OperatingSystem
    $summary=@([PSCustomObject]@{Setting='Operating System';Value=$os.Caption;Assessment='Info'},[PSCustomObject]@{Setting='Version / Build';Value=($os.Version+' / '+$os.BuildNumber);Assessment='Info'})
    $pending=$false
    if(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'){$pending=$true}
    if(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'){$pending=$true}
    $pf=(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue).PendingFileRenameOperations
    if($pf){$pending=$true}
    $summary += [PSCustomObject]@{Setting='Pending Reboot';Value=$pending;Assessment=if($pending){'Review'}else{'Good'}}
    $html += Add-ObjectTable 'Update Summary' $summary ([ordered]@{Setting='Setting';Value='Value';Assessment='Assessment'})

    $services=@()
    foreach($name in @('wuauserv','BITS','CryptSvc','UsoSvc','WaaSMedicSvc')){$s=Get-CimInstance Win32_Service -Filter "Name='$name'" -ErrorAction SilentlyContinue;if($s){$services += [PSCustomObject]@{Name=$s.Name;DisplayName=$s.DisplayName;State=$s.State;StartMode=$s.StartMode;Assessment=if($s.StartMode -eq 'Disabled'){'Review'}else{'Info'}}}}
    $html += Add-ObjectTable 'Windows Update Services' $services ([ordered]@{Name='Service';DisplayName='Display Name';State='State';StartMode='Startup';Assessment='Assessment'})

    $hotfix=@(Get-HotFix -ErrorAction SilentlyContinue | Sort-Object InstalledOn -Descending | Select-Object -First 30 | ForEach-Object {[PSCustomObject]@{HotFixID=$_.HotFixID;Description=$_.Description;InstalledOn=$_.InstalledOn;InstalledBy=$_.InstalledBy}})
    $html += Add-ObjectTable 'Recent Installed Hotfixes' $hotfix ([ordered]@{HotFixID='KB';Description='Description';InstalledOn='Installed On';InstalledBy='Installed By'})

    $history=@()
    try{$session=New-Object -ComObject Microsoft.Update.Session;$searcher=$session.CreateUpdateSearcher();$count=[math]::Min($searcher.GetTotalHistoryCount(),50);if($count -gt 0){foreach($h in @($searcher.QueryHistory(0,$count))){$result=switch($h.ResultCode){2{'Succeeded'}3{'Succeeded with errors'}4{'Failed'}5{'Aborted'}default{[string]$h.ResultCode}};$history += [PSCustomObject]@{Date=$h.Date;Title=$h.Title;Result=$result;Assessment=if($result -eq 'Failed'){'High'}elseif($result -like '*errors*' -or $result -eq 'Aborted'){'Review'}else{'Good'}}}}}catch{}
    $html += Add-ObjectTable 'Windows Update History' $history ([ordered]@{Date='Date';Title='Update';Result='Result';Assessment='Assessment'}) 'Windows Update COM history was unavailable or empty.'
    $html += Close-Report
    Write-Report $html
}

'Stability' {
    $html = New-ReportHeader 'Crash / Stability Audit' 'Recent unexpected shutdowns, bugchecks, WHEA hardware events, application crashes and hangs.'
    $since=(Get-Date).AddDays(-7)
    $rows=@()
    foreach($e in @(Get-WinEvent -FilterHashtable @{LogName='System';StartTime=$since} -ErrorAction SilentlyContinue | Where-Object {$_.Id -in 41,6008,1001 -or $_.ProviderName -eq 'Microsoft-Windows-WHEA-Logger'} | Select-Object -First 300)){
        $assessment=if($e.ProviderName -eq 'Microsoft-Windows-WHEA-Logger' -or $e.Id -eq 1001){'High'}else{'Review'}
        $rows += [PSCustomObject]@{Time=$e.TimeCreated;Log='System';Provider=$e.ProviderName;EventID=$e.Id;Level=$e.LevelDisplayName;Message=$e.Message;Assessment=$assessment}
    }
    foreach($e in @(Get-WinEvent -FilterHashtable @{LogName='Application';StartTime=$since;Id=1000,1001,1002} -ErrorAction SilentlyContinue | Select-Object -First 300)){
        $rows += [PSCustomObject]@{Time=$e.TimeCreated;Log='Application';Provider=$e.ProviderName;EventID=$e.Id;Level=$e.LevelDisplayName;Message=$e.Message;Assessment='Review'}
    }
    $rows=@($rows | Sort-Object Time -Descending | Select-Object -First 300)
    $html += Add-ObjectTable 'Crash / Stability Events - Last 7 Days' $rows ([ordered]@{Time='Time';Log='Log';Provider='Provider';EventID='Event ID';Level='Level';Message='Message';Assessment='Assessment'}) 'No matching crash or stability events returned.'
    $html += Close-Report
    Write-Report $html
}

'IRSnapshot' {
    $html = New-ReportHeader 'Incident Response Snapshot' 'Point-in-time endpoint snapshot for technician triage. This is collection and correlation, not proof of compromise.'
    $cs=Get-CimInstance Win32_ComputerSystem;$os=Get-CimInstance Win32_OperatingSystem
    $summary=@([PSCustomObject]@{Item='Computer';Value=$env:COMPUTERNAME},[PSCustomObject]@{Item='Logged-on User';Value=$cs.UserName},[PSCustomObject]@{Item='Windows';Value=($os.Caption+' '+$os.Version+' Build '+$os.BuildNumber)},[PSCustomObject]@{Item='Last Boot';Value=$os.LastBootUpTime})
    $html += Add-ObjectTable 'System Snapshot' $summary ([ordered]@{Item='Item';Value='Value'})

    $proc=@(Get-Process -ErrorAction SilentlyContinue | Sort-Object WorkingSet64 -Descending | Select-Object -First 100 | ForEach-Object {[PSCustomObject]@{Name=$_.ProcessName;PID=$_.Id;MemoryMB=[math]::Round($_.WorkingSet64/1MB,1);CPU=[math]::Round($_.CPU,1);Executable=$_.Path}})
    $html += Add-ObjectTable 'Top Processes' $proc ([ordered]@{Name='Process';PID='PID';MemoryMB='Memory MB';CPU='CPU Time';Executable='Executable'})

    $tcp=@(Get-NetTCPConnection -ErrorAction SilentlyContinue | Where-Object {$_.State -in @('Listen','Established')} | Select-Object -First 250 | ForEach-Object {$p=Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue;[PSCustomObject]@{State=$_.State;LocalAddress=$_.LocalAddress;LocalPort=$_.LocalPort;RemoteAddress=$_.RemoteAddress;RemotePort=$_.RemotePort;PID=$_.OwningProcess;Process=$p.ProcessName}})
    $html += Add-ObjectTable 'Listening / Established TCP Connections' $tcp ([ordered]@{State='State';LocalAddress='Local Address';LocalPort='Local Port';RemoteAddress='Remote Address';RemotePort='Remote Port';PID='PID';Process='Process'})

    $runs=Get-RunEntries
    $html += Add-ObjectTable 'Registry Startup Entries' $runs ([ordered]@{Location='Location';Name='Name';Command='Command'}) 'No Run/RunOnce entries returned.'

    $defRows=@();$m=Get-MpComputerStatus -ErrorAction SilentlyContinue;if($m){$defRows += [PSCustomObject]@{Setting='Real-Time Protection';Value=$m.RealTimeProtectionEnabled;Assessment=if($m.RealTimeProtectionEnabled){'Good'}else{'High'}};$defRows += [PSCustomObject]@{Setting='Signature Age';Value=([string]$m.AntivirusSignatureAge+' days');Assessment=if($m.AntivirusSignatureAge -gt 7){'High'}else{'Info'}}}
    $html += Add-ObjectTable 'Defender Status' $defRows ([ordered]@{Setting='Setting';Value='Value';Assessment='Assessment'}) 'Defender status unavailable.'

    $usb=@(Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue | Where-Object {$_.InstanceId -like 'USB*' -or $_.Class -in @('USB','HIDClass','Keyboard','Mouse','DiskDrive')} | Select-Object -First 200 | ForEach-Object {[PSCustomObject]@{Device=$_.FriendlyName;Class=$_.Class;Status=$_.Status;InstanceId=$_.InstanceId}})
    $html += Add-ObjectTable 'Present USB / Input Devices' $usb ([ordered]@{Device='Device';Class='Class';Status='Status';InstanceId='Instance ID'})

    $dns=@(Get-DnsClientCache -ErrorAction SilentlyContinue | Select-Object -First 150 | ForEach-Object {[PSCustomObject]@{Name=$_.Entry;Type=$_.Type;Data=$_.Data;Status=$_.Status}})
    $html += Add-ObjectTable 'Current DNS Cache' $dns ([ordered]@{Name='Name';Type='Type';Data='Data';Status='Status'}) 'DNS cache unavailable or empty.'

    $neighbors=@(Get-NetNeighbor -ErrorAction SilentlyContinue | Where-Object {$_.State -ne 'Unreachable'} | Select-Object -First 150 | ForEach-Object {[PSCustomObject]@{Interface=$_.InterfaceAlias;Address=$_.IPAddress;LinkLayerAddress=$_.LinkLayerAddress;State=$_.State}})
    $html += Add-ObjectTable 'Neighbor / ARP Cache' $neighbors ([ordered]@{Interface='Interface';Address='IP Address';LinkLayerAddress='MAC Address';State='State'})

    $remotePattern='AnyDesk|TeamViewer|ScreenConnect|ConnectWise|Splashtop|RustDesk|VNC|LogMeIn|Remote Utilities|Chrome Remote Desktop|GoToAssist|DWService|Dameware|Zoho|MeshCentral|RemotePC'
    $remote=@(Get-InstalledSoftware | Where-Object {$_.Name -match $remotePattern} | ForEach-Object {[PSCustomObject]@{Name=$_.Name;Version=$_.Version;Publisher=$_.Publisher;Assessment='Review'}})
    $html += Add-ObjectTable 'Installed Remote Access Software' $remote ([ordered]@{Name='Application';Version='Version';Publisher='Publisher';Assessment='Assessment'}) 'No known remote access products found in uninstall inventory.'

    $since=(Get-Date).AddHours(-24);$auth=@(Get-WinEvent -FilterHashtable @{LogName='Security';Id=4624,4625;StartTime=$since} -ErrorAction SilentlyContinue | Select-Object -First 300 | ForEach-Object {$d=Get-EventDataMap $_;[PSCustomObject]@{Time=$_.TimeCreated;Result=if($_.Id -eq 4624){'Success'}else{'Failed'};User=$d.TargetUserName;SourceAddress=$d.IpAddress;LogonType=$d.LogonType;Assessment=if($_.Id -eq 4625){'Review'}else{'Info'}}})
    $html += Add-ObjectTable 'Authentication Events - Last 24 Hours' $auth ([ordered]@{Time='Time';Result='Result';User='User';SourceAddress='Source IP';LogonType='Logon Type';Assessment='Assessment'}) 'No matching recent authentication events returned.'
    $html += Close-Report
    Write-Report $html
}

}

if (-not (Test-Path -LiteralPath $ReportPath)) { throw 'Report file was not created.' }
exit 0
}
catch {
    Write-Host
    Write-Host 'Security report failed:' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host
    exit 1
}
::PS_SECURITYSUITE_END


:: ============================================================
:: PERFORMANCE / OPTIMIZATION REPORTS
:: ============================================================

:PERFORMANCE
call :GenericMaintenanceReport "Performance" "Performance" "PERFORMANCE BOTTLENECK ANALYZER"
goto MENU

:STARTUPPERF
call :GenericMaintenanceReport "Startup" "StartupPerformance" "STARTUP PERFORMANCE ANALYZER"
goto MENU

:PROFILEHEALTH
call :GenericMaintenanceReport "Profile" "UserProfileHealth" "USER PROFILE HEALTH AUDIT"
goto MENU


:: ============================================================
:: OPTIMIZATION AND MAINTENANCE CENTER
:: ============================================================

:OPTIMIZATIONCENTER
:OPTIMIZATION_MENU
@echo off
cls
color 0A

echo ============================================================
echo OPTIMIZATION AND MAINTENANCE CENTER
echo ============================================================
echo.
echo [1] Performance Bottleneck Analysis
echo [2] Analyze Windows Component Store
echo [3] Safe Temporary File Cleanup
echo [4] Windows Component Store Cleanup
echo [5] Optimize System Drive ^(media-aware^)
echo [6] Open Windows Storage Settings
echo [7] Quick Safe Maintenance
echo [0] Back to Main Menu
echo.

set "optchoice="
set /p "optchoice=Select an option: "

if "%optchoice%"=="0" goto MENU
if "%optchoice%"=="1" goto OPT_PERFORMANCE
if "%optchoice%"=="2" goto OPT_COMPONENT_ANALYZE
if "%optchoice%"=="3" goto OPT_TEMP_CLEANUP
if "%optchoice%"=="4" goto OPT_COMPONENT_CLEANUP
if "%optchoice%"=="5" goto OPT_VOLUME
if "%optchoice%"=="6" goto OPT_STORAGE_SETTINGS
if "%optchoice%"=="7" goto OPT_QUICK

echo.
echo Invalid selection.
timeout /t 2 >nul
goto OPTIMIZATION_MENU

:OPT_PERFORMANCE
call :GenericMaintenanceReport "Performance" "Performance" "PERFORMANCE BOTTLENECK ANALYZER"
goto OPTIMIZATION_MENU

:OPT_COMPONENT_ANALYZE
cls
echo ============================================================
echo ANALYZE WINDOWS COMPONENT STORE
echo ============================================================
echo.
call :WriteLog "Component Store analysis started"
DISM /Online /Cleanup-Image /AnalyzeComponentStore
call :WriteLog "Component Store analysis completed with exit code %errorlevel%"
echo.
pause
goto OPTIMIZATION_MENU

:OPT_TEMP_CLEANUP
cls
echo ============================================================
echo SAFE TEMPORARY FILE CLEANUP
echo ============================================================
echo.
echo Files older than 48 hours in the current user TEMP folder
echo and Windows TEMP folder will be removed when they are not in use.
echo Active or locked files are skipped.
echo.
choice /C YN /N /M "Continue? [Y/N]: "
if errorlevel 2 goto OPTIMIZATION_MENU
call :WriteLog "Safe temporary file cleanup started"
call :RunMaintenanceModule "TempCleanup" "" ""
call :WriteLog "Safe temporary file cleanup completed with exit code %errorlevel%"
echo.
pause
goto OPTIMIZATION_MENU

:OPT_COMPONENT_CLEANUP
cls
echo ============================================================
echo WINDOWS COMPONENT STORE CLEANUP
echo ============================================================
echo.
echo This runs DISM StartComponentCleanup.
echo It does NOT use ResetBase.
echo.
choice /C YN /N /M "Continue? [Y/N]: "
if errorlevel 2 goto OPTIMIZATION_MENU
call :WriteLog "Component Store cleanup started"
DISM /Online /Cleanup-Image /StartComponentCleanup
call :WriteLog "Component Store cleanup completed with exit code %errorlevel%"
echo.
pause
goto OPTIMIZATION_MENU

:OPT_VOLUME
cls
echo ============================================================
echo OPTIMIZE SYSTEM DRIVE
echo ============================================================
echo.
echo Windows will choose the appropriate operation for the media.
echo SSDs are retrimmed when supported; HDDs use defragmentation.
echo.
choice /C YN /N /M "Optimize %SystemDrive% now? [Y/N]: "
if errorlevel 2 goto OPTIMIZATION_MENU
call :WriteLog "System volume optimization started"
call :RunMaintenanceModule "OptimizeVolume" "" ""
call :WriteLog "System volume optimization completed with exit code %errorlevel%"
echo.
pause
goto OPTIMIZATION_MENU

:OPT_STORAGE_SETTINGS
start "" ms-settings:storagesense
goto OPTIMIZATION_MENU

:OPT_QUICK
cls
echo ============================================================
echo QUICK SAFE MAINTENANCE
echo ============================================================
echo.
echo This will perform:
echo   - Safe temporary file cleanup ^(older than 48 hours^)
echo   - Microsoft Defender security intelligence update
echo   - Windows Component Store cleanup
echo   - Media-aware optimization of %SystemDrive%
echo.
echo This can take several minutes.
echo.
choice /C YN /N /M "Run Quick Safe Maintenance? [Y/N]: "
if errorlevel 2 goto OPTIMIZATION_MENU
call :WriteLog "Quick Safe Maintenance started"
call :RunMaintenanceModule "TempCleanup" "" ""
echo.
echo Updating Microsoft Defender security intelligence...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Update-MpSignature -ErrorAction SilentlyContinue"
echo.
echo Cleaning Windows Component Store...
DISM /Online /Cleanup-Image /StartComponentCleanup
echo.
echo Optimizing system drive...
call :RunMaintenanceModule "OptimizeVolume" "" ""
call :WriteLog "Quick Safe Maintenance completed"
echo.
echo Maintenance actions completed.
echo A performance report will now be generated.
echo.
call :GenericMaintenanceReport "Performance" "Performance-AfterMaintenance" "POST-MAINTENANCE PERFORMANCE ANALYSIS"
goto OPTIMIZATION_MENU


:: ============================================================
:: POWER / SLEEP DIAGNOSTICS
:: ============================================================

:POWERSLEEP
:POWERSLEEP_MENU
@echo off
cls
color 0A

echo ============================================================
echo POWER / SLEEP DIAGNOSTICS
echo ============================================================
echo.
echo [1] Generate Power / Sleep Overview
echo [2] Generate Energy Efficiency Report ^(30 seconds^)
echo [3] Generate Sleep Study
echo [4] Generate System Power Report
echo [0] Back to Main Menu
echo.

set "powerchoice="
set /p "powerchoice=Select an option: "

if "%powerchoice%"=="0" goto MENU
if "%powerchoice%"=="1" goto POWER_OVERVIEW
if "%powerchoice%"=="2" goto POWER_ENERGY
if "%powerchoice%"=="3" goto POWER_SLEEPSTUDY
if "%powerchoice%"=="4" goto POWER_SYSTEMREPORT

echo.
echo Invalid selection.
timeout /t 2 >nul
goto POWERSLEEP_MENU

:POWER_OVERVIEW
call :GenericMaintenanceReport "Power" "PowerSleep" "POWER / SLEEP DIAGNOSTIC REPORT"
goto POWERSLEEP_MENU

:POWER_ENERGY
cls
call :NewReportTimestamp
set "ENERGYREPORT=%LOGDIR%\Energy-%COMPUTERNAME%-%REPORTSTAMP%.html"
echo ============================================================
echo ENERGY EFFICIENCY REPORT
echo ============================================================
echo.
echo Windows will observe the system for 30 seconds.
echo.
call :WriteLog "Powercfg energy report started"
powercfg /energy /duration 30 /output "%ENERGYREPORT%"
if exist "%ENERGYREPORT%" (
    call :WriteLog "Energy report created: %ENERGYREPORT%"
    start "" "%ENERGYREPORT%"
) else (
    echo.
    echo Energy report was not created.
)
echo.
pause
goto POWERSLEEP_MENU

:POWER_SLEEPSTUDY
cls
call :NewReportTimestamp
set "SLEEPREPORT=%LOGDIR%\SleepStudy-%COMPUTERNAME%-%REPORTSTAMP%.html"
echo ============================================================
echo SLEEP STUDY
echo ============================================================
echo.
call :WriteLog "Sleep Study requested"
powercfg /sleepstudy /output "%SLEEPREPORT%"
if exist "%SLEEPREPORT%" (
    call :WriteLog "Sleep Study created: %SLEEPREPORT%"
    start "" "%SLEEPREPORT%"
) else (
    echo.
    echo Sleep Study was not created.
    echo This system may not support Modern Standby / Sleep Study.
)
echo.
pause
goto POWERSLEEP_MENU

:POWER_SYSTEMREPORT
cls
call :NewReportTimestamp
set "POWERREPORT=%LOGDIR%\SystemPower-%COMPUTERNAME%-%REPORTSTAMP%.html"
echo ============================================================
echo SYSTEM POWER REPORT
echo ============================================================
echo.
call :WriteLog "System Power Report requested"
powercfg /systempowerreport /output "%POWERREPORT%"
if exist "%POWERREPORT%" (
    call :WriteLog "System Power Report created: %POWERREPORT%"
    start "" "%POWERREPORT%"
) else (
    echo.
    echo System Power Report was not created.
)
echo.
pause
goto POWERSLEEP_MENU


:: ============================================================
:: WINDOWS UPDATE REPAIR
:: ============================================================

:UPDATEREPAIR
:UPDATEREPAIR_MENU
@echo off
cls
color 0A

echo ============================================================
echo WINDOWS UPDATE REPAIR
echo ============================================================
echo.
echo [1] Generate Windows Update Health Report
echo [2] Restart Windows Update Services
echo [3] Reset Windows Update Cache ^(advanced^)
echo [4] Run DISM RestoreHealth
echo [5] Open Windows Update
echo [0] Back to Main Menu
echo.

set "updatechoice="
set /p "updatechoice=Select an option: "

if "%updatechoice%"=="0" goto MENU
if "%updatechoice%"=="1" goto UPDATE_REPAIR_REPORT
if "%updatechoice%"=="2" goto UPDATE_REPAIR_SERVICES
if "%updatechoice%"=="3" goto UPDATE_REPAIR_CACHE
if "%updatechoice%"=="4" goto UPDATE_REPAIR_DISM
if "%updatechoice%"=="5" goto UPDATE_REPAIR_SETTINGS

echo.
echo Invalid selection.
timeout /t 2 >nul
goto UPDATEREPAIR_MENU

:UPDATE_REPAIR_REPORT
call :GenericSecurityReport "Updates" "WindowsUpdateHealth" "Windows Update health audit"
goto UPDATEREPAIR_MENU

:UPDATE_REPAIR_SERVICES
cls
echo ============================================================
echo RESTART WINDOWS UPDATE SERVICES
echo ============================================================
echo.
choice /C YN /N /M "Restart BITS, Windows Update and Cryptographic Services? [Y/N]: "
if errorlevel 2 goto UPDATEREPAIR_MENU
call :WriteLog "Windows Update service restart requested"
call :RunMaintenanceModule "UpdateServices" "" ""
echo.
pause
goto UPDATEREPAIR_MENU

:UPDATE_REPAIR_CACHE
cls
echo ============================================================
echo RESET WINDOWS UPDATE CACHE
echo ============================================================
echo.
echo This stops the core update services and RENAMES the current
echo SoftwareDistribution and catroot2 folders as timestamped backups.
echo Windows will create fresh working folders automatically.
echo Installed updates are not removed.
echo.
choice /C YN /N /M "Reset the Windows Update cache? [Y/N]: "
if errorlevel 2 goto UPDATEREPAIR_MENU
call :WriteLog "Windows Update cache reset requested"
call :RunMaintenanceModule "UpdateReset" "" ""
echo.
pause
goto UPDATEREPAIR_MENU

:UPDATE_REPAIR_DISM
cls
echo ============================================================
echo DISM RESTOREHEALTH
echo ============================================================
echo.
choice /C YN /N /M "Run DISM RestoreHealth? [Y/N]: "
if errorlevel 2 goto UPDATEREPAIR_MENU
call :WriteLog "DISM RestoreHealth started from Update Repair"
DISM /Online /Cleanup-Image /RestoreHealth
call :WriteLog "DISM RestoreHealth completed with exit code %errorlevel%"
echo.
pause
goto UPDATEREPAIR_MENU

:UPDATE_REPAIR_SETTINGS
start "" ms-settings:windowsupdate
goto UPDATEREPAIR_MENU


:: ============================================================
:: PORTABLE DRIVER BACKUP
:: ============================================================

:DRIVERBACKUP
@echo off
cls
call :NewReportTimestamp
set "DRIVERBACKUPROOT=%TOOLKITDIR%DriverBackups\%COMPUTERNAME%"
set "DRIVERBACKUP=%DRIVERBACKUPROOT%\%REPORTSTAMP%"

echo ============================================================
echo DRIVER BACKUP
echo ============================================================
echo.
echo Third-party driver packages will be exported to:
echo %DRIVERBACKUP%
echo.
choice /C YN /N /M "Continue? [Y/N]: "
if errorlevel 2 goto MENU

mkdir "%DRIVERBACKUP%" >nul 2>&1
if not exist "%DRIVERBACKUP%" (
    echo.
    echo ERROR: Backup folder could not be created.
    echo Verify the toolkit drive is writable.
    echo.
    pause
    goto MENU
)

call :WriteLog "Driver backup started: %DRIVERBACKUP%"
echo.
echo Exporting third-party driver packages...
pnputil /export-driver * "%DRIVERBACKUP%"
set "DRIVERBACKUPRC=%errorlevel%"

echo.
echo Saving driver inventory and system information...
pnputil /enum-drivers /files > "%DRIVERBACKUP%\DriverInventory.txt" 2>&1
if errorlevel 1 pnputil /enum-drivers > "%DRIVERBACKUP%\DriverInventory.txt" 2>&1
systeminfo > "%DRIVERBACKUP%\SystemInfo.txt" 2>&1

if "%DRIVERBACKUPRC%"=="0" (
    echo.
    echo Driver backup completed successfully.
    call :WriteLog "Driver backup completed: %DRIVERBACKUP%"
    start "" explorer.exe "%DRIVERBACKUP%"
) else (
    echo.
    echo Driver export returned exit code %DRIVERBACKUPRC%.
    echo Review the output and backup folder.
    call :WriteLog "Driver backup returned exit code %DRIVERBACKUPRC%"
)

echo.
pause
goto MENU


:: ============================================================
:: WINDOWS SHELL REPAIR
:: ============================================================

:SHELLREPAIR
:SHELLREPAIR_MENU
@echo off
cls
color 0A

echo ============================================================
echo WINDOWS SHELL REPAIR
echo ============================================================
echo.
echo [1] Restart Windows Explorer
echo [2] Restart Start Menu / Shell Experience Hosts
echo [3] Re-register ShellExperienceHost
echo [4] Re-register StartMenuExperienceHost
echo [5] Re-register Both Shell Packages
echo [0] Back to Main Menu
echo.

echo NOTE: Re-registration applies to the Windows account running
echo this elevated toolkit session.
echo.

set "shellchoice="
set /p "shellchoice=Select an option: "

if "%shellchoice%"=="0" goto MENU
if "%shellchoice%"=="1" goto SHELL_EXPLORER
if "%shellchoice%"=="2" goto SHELL_HOSTS
if "%shellchoice%"=="3" goto SHELL_REGISTER_SHELL
if "%shellchoice%"=="4" goto SHELL_REGISTER_START
if "%shellchoice%"=="5" goto SHELL_REGISTER_BOTH

echo.
echo Invalid selection.
timeout /t 2 >nul
goto SHELLREPAIR_MENU

:SHELL_EXPLORER
call :WriteLog "Windows Explorer restart requested"
call :RunMaintenanceModule "ShellRestartExplorer" "" ""
echo.
pause
goto SHELLREPAIR_MENU

:SHELL_HOSTS
call :WriteLog "Windows shell host restart requested"
call :RunMaintenanceModule "ShellRestartHosts" "" ""
echo.
pause
goto SHELLREPAIR_MENU

:SHELL_REGISTER_SHELL
choice /C YN /N /M "Re-register ShellExperienceHost? [Y/N]: "
if errorlevel 2 goto SHELLREPAIR_MENU
call :WriteLog "ShellExperienceHost re-registration requested"
call :RunMaintenanceModule "ShellReregisterShell" "" ""
echo.
pause
goto SHELLREPAIR_MENU

:SHELL_REGISTER_START
choice /C YN /N /M "Re-register StartMenuExperienceHost? [Y/N]: "
if errorlevel 2 goto SHELLREPAIR_MENU
call :WriteLog "StartMenuExperienceHost re-registration requested"
call :RunMaintenanceModule "ShellReregisterStart" "" ""
echo.
pause
goto SHELLREPAIR_MENU

:SHELL_REGISTER_BOTH
choice /C YN /N /M "Re-register both Windows shell packages? [Y/N]: "
if errorlevel 2 goto SHELLREPAIR_MENU
call :WriteLog "Windows shell package re-registration requested"
call :RunMaintenanceModule "ShellReregisterBoth" "" ""
echo.
pause
goto SHELLREPAIR_MENU


:: ============================================================
:: APPLICATION UPDATES - WINGET
:: ============================================================

:WINGETCENTER
:WINGET_MENU
@echo off
cls
color 0A

echo ============================================================
echo APPLICATION UPDATES - WINGET
echo ============================================================
echo.

where winget.exe >nul 2>&1
if errorlevel 1 (
    echo Windows Package Manager ^(WinGet^) was not found.
    echo.
    echo WinGet is normally provided by Microsoft App Installer.
    echo This toolkit will not install or modify WinGet automatically.
    echo.
    pause
    goto MENU
)

echo [1] Show Available App Updates
echo [2] Update Selected App by Package ID
echo [3] Update All Available Apps
echo [4] Refresh WinGet Sources
echo [5] Generate App Update HTML Report
echo [0] Back to Main Menu
echo.

set "wingchoice="
set /p "wingchoice=Select an option: "

if "%wingchoice%"=="0" goto MENU
if "%wingchoice%"=="1" goto WINGET_CHECK
if "%wingchoice%"=="2" goto WINGET_SELECTED
if "%wingchoice%"=="3" goto WINGET_ALL
if "%wingchoice%"=="4" goto WINGET_SOURCE_UPDATE
if "%wingchoice%"=="5" goto WINGET_REPORT

echo.
echo Invalid selection.
timeout /t 2 >nul
goto WINGET_MENU

:WINGET_CHECK
cls
echo ============================================================
echo AVAILABLE APPLICATION UPDATES
echo ============================================================
echo.
call :WriteLog "WinGet available-updates check started"
winget.exe list --upgrade-available --accept-source-agreements
echo.
pause
goto WINGET_MENU

:WINGET_SELECTED
cls
echo ============================================================
echo UPDATE SELECTED APPLICATION
echo ============================================================
echo.
echo Use the exact Package ID shown by WinGet.
echo Example: Microsoft.PowerToys
echo.
setlocal DisableDelayedExpansion
set "WINGET_ID="
set /p "WINGET_ID=Package ID: "
if not defined WINGET_ID (
    endlocal
    goto WINGET_MENU
)
echo.
echo Selected package: %WINGET_ID%
echo.
choice /C YN /N /M "Update this application? [Y/N]: "
if errorlevel 2 (
    endlocal
    goto WINGET_MENU
)
call :WriteLog "WinGet selected application update requested: %WINGET_ID%"
winget.exe upgrade --id "%WINGET_ID%" --exact --accept-source-agreements --accept-package-agreements
set "WINGET_RC=%errorlevel%"
call :WriteLog "WinGet selected application update completed with exit code %WINGET_RC%: %WINGET_ID%"
echo.
endlocal
pause
goto WINGET_MENU

:WINGET_ALL
cls
echo ============================================================
echo UPDATE ALL AVAILABLE APPLICATIONS
echo ============================================================
echo.
echo WinGet will attempt to update all eligible applications.
echo Pinned packages and packages with unknown versions are not forced.
echo Individual installers may still require interaction or a restart.
echo.
choice /C YN /N /M "Continue with Update All? [Y/N]: "
if errorlevel 2 goto WINGET_MENU
call :WriteLog "WinGet update-all started"
winget.exe upgrade --all --accept-source-agreements --accept-package-agreements
set "WINGET_RC=%errorlevel%"
call :WriteLog "WinGet update-all completed with exit code %WINGET_RC%"
echo.
pause
goto WINGET_MENU

:WINGET_SOURCE_UPDATE
cls
echo ============================================================
echo REFRESH WINGET SOURCES
echo ============================================================
echo.
call :WriteLog "WinGet source refresh started"
winget.exe source update
set "WINGET_RC=%errorlevel%"
call :WriteLog "WinGet source refresh completed with exit code %WINGET_RC%"
echo.
pause
goto WINGET_MENU

:WINGET_REPORT
call :GenericMaintenanceReport "WinGetUpdates" "AppUpdates" "APPLICATION UPDATE REPORT"
goto WINGET_MENU


:: ============================================================
:: REGISTRY DIAGNOSTIC / REPAIR CENTER
:: ============================================================

:REGISTRYCENTER
:REGISTRY_MENU
@echo off
cls
color 0A

echo ============================================================
echo REGISTRY DIAGNOSTIC / REPAIR CENTER
echo ============================================================
echo.
echo [1]  Registry Health Overview
echo [2]  Backup Registry Key
echo [3]  Restore Registry Backup
echo [4]  User Profile Registry Audit
echo [5]  Explorer / Start Menu Policies
echo [6]  Windows Update Registry Audit
echo [7]  Network / Proxy Registry Audit
echo [8]  Startup Registry Audit
echo [9]  Security Policy Registry Audit
echo [10] Search Registry
echo [11] Registry Snapshot / Compare
echo [12] Open Registry Editor
echo [0]  Back to Main Menu
echo.
echo NOTE: Registry changes can affect Windows startup and user profiles.
echo       Backup and restore actions require explicit confirmation.
echo.

set "regchoice="
set /p "regchoice=Select an option: "

if "%regchoice%"=="0" goto MENU
if "%regchoice%"=="1" goto REG_HEALTH
if "%regchoice%"=="2" goto REG_BACKUP
if "%regchoice%"=="3" goto REG_RESTORE
if "%regchoice%"=="4" goto REG_PROFILE
if "%regchoice%"=="5" goto REG_EXPLORER
if "%regchoice%"=="6" goto REG_WINDOWSUPDATE
if "%regchoice%"=="7" goto REG_NETWORK
if "%regchoice%"=="8" goto REG_STARTUP
if "%regchoice%"=="9" goto REG_SECURITY
if "%regchoice%"=="10" goto REG_SEARCH
if "%regchoice%"=="11" goto REG_SNAPSHOT_MENU
if "%regchoice%"=="12" goto REG_OPEN_EDITOR

echo.
echo Invalid selection.
timeout /t 2 >nul
goto REGISTRY_MENU

:REG_HEALTH
call :GenericMaintenanceReport "RegistryHealth" "RegistryHealth" "REGISTRY HEALTH OVERVIEW"
goto REGISTRY_MENU

:REG_PROFILE
call :GenericMaintenanceReport "Profile" "UserProfileRegistry" "USER PROFILE REGISTRY AUDIT"
goto REGISTRY_MENU

:REG_EXPLORER
call :GenericMaintenanceReport "RegistryExplorer" "RegistryExplorerPolicies" "EXPLORER / START MENU REGISTRY AUDIT"
goto REGISTRY_MENU

:REG_WINDOWSUPDATE
call :GenericMaintenanceReport "RegistryWindowsUpdate" "RegistryWindowsUpdate" "WINDOWS UPDATE REGISTRY AUDIT"
goto REGISTRY_MENU

:REG_NETWORK
call :GenericMaintenanceReport "RegistryNetwork" "RegistryNetworkProxy" "NETWORK / PROXY REGISTRY AUDIT"
goto REGISTRY_MENU

:REG_STARTUP
call :GenericMaintenanceReport "RegistryStartup" "RegistryStartup" "STARTUP REGISTRY AUDIT"
goto REGISTRY_MENU

:REG_SECURITY
call :GenericMaintenanceReport "RegistrySecurity" "RegistrySecurityPolicy" "SECURITY POLICY REGISTRY AUDIT"
goto REGISTRY_MENU

:REG_BACKUP
@echo off
cls
setlocal DisableDelayedExpansion
echo ============================================================
echo BACKUP REGISTRY KEY
echo ============================================================
echo.
echo Enter a registry key using REG.EXE notation.
echo Example:
echo HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
echo.
set "REGKEY="
set /p "REGKEY=Registry key: "
if not defined REGKEY (
    endlocal
    goto REGISTRY_MENU
)

reg.exe query "%REGKEY%" >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Registry key was not found or could not be accessed.
    echo.
    pause
    endlocal
    goto REGISTRY_MENU
)

for /f %%A in ('powershell.exe -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss-fff"') do set "REGSTAMP=%%A"
set "REGBACKUPDIR=%LOGDIR%\RegistryBackups\%COMPUTERNAME%"
set "REGBACKUPFILE=%REGBACKUPDIR%\RegistryBackup-%REGSTAMP%.reg"
set "REGMETAFILE=%REGBACKUPDIR%\RegistryBackup-%REGSTAMP%.txt"

if not exist "%REGBACKUPDIR%" mkdir "%REGBACKUPDIR%" >nul 2>&1
if not exist "%REGBACKUPDIR%" (
    echo.
    echo ERROR: Registry backup directory could not be created.
    echo.
    pause
    endlocal
    goto REGISTRY_MENU
)

echo.
echo Registry key : %REGKEY%
echo Backup file  : %REGBACKUPFILE%
echo.
choice /C YN /N /M "Export this registry key? [Y/N]: "
if errorlevel 2 (
    endlocal
    goto REGISTRY_MENU
)

reg.exe export "%REGKEY%" "%REGBACKUPFILE%" /y
set "REGRC=%errorlevel%"

if "%REGRC%"=="0" (
    >"%REGMETAFILE%" echo Raymond Endpoint Toolkit Registry Backup
    >>"%REGMETAFILE%" echo Computer: %COMPUTERNAME%
    >>"%REGMETAFILE%" echo User: %USERNAME%
    >>"%REGMETAFILE%" echo Date: %DATE% %TIME%
    >>"%REGMETAFILE%" echo Registry Key: %REGKEY%
    >>"%REGMETAFILE%" echo Backup File: %REGBACKUPFILE%
    call :WriteLog "Registry key exported: %REGKEY%"
    echo.
    echo Registry backup completed successfully.
    echo.
    start "" explorer.exe "%REGBACKUPDIR%"
) else (
    call :WriteLog "ERROR: Registry export failed with exit code %REGRC%"
    echo.
    echo ERROR: Registry export failed with exit code %REGRC%.
)

echo.
pause
endlocal
goto REGISTRY_MENU

:REG_RESTORE
@echo off
cls
setlocal DisableDelayedExpansion
echo ============================================================
echo RESTORE REGISTRY BACKUP
echo ============================================================
echo.
echo WARNING:
echo Importing a .reg file changes the live Windows registry.
echo Use only a backup you trust and understand.
echo.
echo Paste the full path to a .reg file.
echo Example:
echo E:\logs\RegistryBackups\PC01\RegistryBackup-2026-08-17.reg
echo.
set "REGRESTORE="
set /p "REGRESTORE=Backup file: "
set "REGRESTORE=%REGRESTORE:"=%"

if not defined REGRESTORE (
    endlocal
    goto REGISTRY_MENU
)

if not exist "%REGRESTORE%" (
    echo.
    echo ERROR: File not found.
    echo.
    pause
    endlocal
    goto REGISTRY_MENU
)

for %%F in ("%REGRESTORE%") do if /I not "%%~xF"==".reg" (
    echo.
    echo ERROR: The selected file is not a .reg registry export.
    echo.
    pause
    endlocal
    goto REGISTRY_MENU
)

echo.
echo File to import:
echo %REGRESTORE%
echo.
choice /C YN /N /M "Import this registry backup? [Y/N]: "
if errorlevel 2 (
    endlocal
    goto REGISTRY_MENU
)

echo.
choice /C YN /N /M "FINAL CONFIRMATION - modify the Windows registry? [Y/N]: "
if errorlevel 2 (
    endlocal
    goto REGISTRY_MENU
)

reg.exe import "%REGRESTORE%"
set "REGRC=%errorlevel%"

if "%REGRC%"=="0" (
    call :WriteLog "Registry backup imported: %REGRESTORE%"
    echo.
    echo Registry import completed successfully.
    echo Restart or sign out if the restored setting requires it.
) else (
    call :WriteLog "ERROR: Registry import failed with exit code %REGRC%"
    echo.
    echo ERROR: Registry import failed with exit code %REGRC%.
)

echo.
pause
endlocal
goto REGISTRY_MENU

:REG_SEARCH
@echo off
cls
setlocal DisableDelayedExpansion
echo ============================================================
echo SEARCH REGISTRY
echo ============================================================
echo.
echo Searches common diagnostic registry locations for matching
echo key names, value names, and value data.
echo.
echo Broad searches can take several minutes.
echo.
set "REGSEARCH="
set /p "REGSEARCH=Search term: "
set "REGSEARCH=%REGSEARCH:"=%"
if not defined REGSEARCH (
    endlocal
    goto REGISTRY_MENU
)

for /f %%A in ('powershell.exe -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss-fff"') do set "REGSTAMP=%%A"
set "REGSEARCHREPORT=%LOGDIR%\RegistrySearch-%COMPUTERNAME%-%REGSTAMP%.html"

echo.
echo Searching registry. Please wait...
echo.
call :WriteLog "Registry search started"
call :RunMaintenanceModule "RegistrySearch" "%REGSEARCHREPORT%" "%REGSEARCH%"
set "REGRC=%errorlevel%"

if "%REGRC%"=="0" (
    if exist "%REGSEARCHREPORT%" (
        call :WriteLog "Registry search report created: %REGSEARCHREPORT%"
        start "" "%REGSEARCHREPORT%"
    ) else (
        echo.
        echo ERROR: Registry search completed but the report file was not created.
    )
) else (
    echo.
    echo ERROR: Registry search failed with exit code %REGRC%.
)

echo.
pause
endlocal
goto REGISTRY_MENU

:REG_SNAPSHOT_MENU
@echo off
cls
echo ============================================================
echo REGISTRY SNAPSHOT / COMPARE
echo ============================================================
echo.
echo [1] Create Troubleshooting Snapshot
echo [2] Compare Two Saved Snapshots
echo [0] Back to Registry Center
echo.
set "regsnapchoice="
set /p "regsnapchoice=Select an option: "
if "%regsnapchoice%"=="0" goto REGISTRY_MENU
if "%regsnapchoice%"=="1" goto REG_SNAPSHOT_CREATE
if "%regsnapchoice%"=="2" goto REG_SNAPSHOT_COMPARE

echo.
echo Invalid selection.
timeout /t 2 >nul
goto REG_SNAPSHOT_MENU

:REG_SNAPSHOT_CREATE
@echo off
cls
call :NewReportTimestamp
set "REGSNAPDIR=%LOGDIR%\RegistrySnapshots\%COMPUTERNAME%"
set "REGSNAPSHOT=%REGSNAPDIR%\RegistrySnapshot-%COMPUTERNAME%-%REPORTSTAMP%.json"
if not exist "%REGSNAPDIR%" mkdir "%REGSNAPDIR%" >nul 2>&1

echo ============================================================
echo CREATE REGISTRY TROUBLESHOOTING SNAPSHOT
echo ============================================================
echo.
echo This captures selected troubleshooting registry locations used by
echo Windows profiles, policies, startup, networking, RDP and shell settings.
echo It is NOT a complete backup of the Windows registry.
echo.
echo Snapshot:
echo %REGSNAPSHOT%
echo.
choice /C YN /N /M "Create snapshot? [Y/N]: "
if errorlevel 2 goto REG_SNAPSHOT_MENU

call :WriteLog "Registry troubleshooting snapshot started"
call :RunMaintenanceModule "RegistrySnapshot" "" "%REGSNAPSHOT%"
set "REGRC=%errorlevel%"

if "%REGRC%"=="0" (
    if exist "%REGSNAPSHOT%" (
        call :WriteLog "Registry snapshot created: %REGSNAPSHOT%"
        echo.
        echo Registry snapshot created successfully.
        start "" explorer.exe "%REGSNAPDIR%"
    ) else (
        echo.
        echo ERROR: Snapshot module completed but the snapshot file was not created.
    )
) else (
    echo.
    echo ERROR: Registry snapshot failed with exit code %REGRC%.
)

echo.
pause
goto REG_SNAPSHOT_MENU

:REG_SNAPSHOT_COMPARE
@echo off
cls
setlocal DisableDelayedExpansion
echo ============================================================
echo COMPARE REGISTRY SNAPSHOTS
echo ============================================================
echo.
echo Paste two snapshot JSON paths created by this toolkit.
echo.
set "REGBASE="
set "REGNEW="
set /p "REGBASE=Baseline snapshot : "
set "REGBASE=%REGBASE:"=%"
if not defined REGBASE (
    endlocal
    goto REG_SNAPSHOT_MENU
)
if not exist "%REGBASE%" (
    echo.
    echo ERROR: Baseline snapshot was not found.
    echo.
    pause
    endlocal
    goto REG_SNAPSHOT_MENU
)

echo.
set /p "REGNEW=Comparison snapshot: "
set "REGNEW=%REGNEW:"=%"
if not defined REGNEW (
    endlocal
    goto REG_SNAPSHOT_MENU
)
if not exist "%REGNEW%" (
    echo.
    echo ERROR: Comparison snapshot was not found.
    echo.
    pause
    endlocal
    goto REG_SNAPSHOT_MENU
)

for /f %%A in ('powershell.exe -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss-fff"') do set "REGSTAMP=%%A"
set "REGCOMPAREREPORT=%LOGDIR%\RegistryCompare-%COMPUTERNAME%-%REGSTAMP%.html"

echo.
echo Comparing snapshots...
echo.
call :WriteLog "Registry snapshot comparison started"
call :RunMaintenanceModule "RegistryCompare" "%REGCOMPAREREPORT%" "%REGBASE%|%REGNEW%"
set "REGRC=%errorlevel%"

if "%REGRC%"=="0" (
    if exist "%REGCOMPAREREPORT%" (
        call :WriteLog "Registry comparison report created: %REGCOMPAREREPORT%"
        start "" "%REGCOMPAREREPORT%"
    ) else (
        echo.
        echo ERROR: Comparison completed but the report file was not created.
    )
) else (
    echo.
    echo ERROR: Registry comparison failed with exit code %REGRC%.
)

echo.
pause
endlocal
goto REG_SNAPSHOT_MENU

:REG_OPEN_EDITOR
call :WriteLog "Registry Editor opened"
start "" regedit.exe
goto REGISTRY_MENU


:: ============================================================
:: GENERIC MAINTENANCE REPORT LAUNCHER
:: ============================================================

:GenericMaintenanceReport
@echo off
setlocal
set "MAINTMODE=%~1"
set "MAINTBASENAME=%~2"
set "MAINTTITLE=%~3"
call :NewReportTimestamp
set "MAINTREPORT=%LOGDIR%\%MAINTBASENAME%-%COMPUTERNAME%-%REPORTSTAMP%.html"

echo ============================================================
echo %MAINTTITLE%
echo ============================================================
echo.
echo Collecting information...
echo.

call :WriteLog "%MAINTTITLE% started"
call :RunMaintenanceModule "%MAINTMODE%" "%MAINTREPORT%" ""
set "MAINTRC=%errorlevel%"

if not "%MAINTRC%"=="0" (
    echo.
    echo ERROR: %MAINTTITLE% failed.
    call :WriteLog "ERROR: %MAINTTITLE% returned %MAINTRC%"
    echo.
    pause
    endlocal
    exit /b 1
)

if exist "%MAINTREPORT%" (
    echo Report generated successfully.
    echo.
    echo Opening report...
    call :WriteLog "%MAINTTITLE% created: %MAINTREPORT%"
    start "" "%MAINTREPORT%"
) else (
    echo.
    echo ERROR: Report file was not created.
    call :WriteLog "ERROR: %MAINTTITLE% report was not created"
)

echo.
pause
endlocal
exit /b 0


:: ============================================================
:: EMBEDDED MAINTENANCE / PERFORMANCE RUNNER
:: ============================================================

:RunMaintenanceModule
@echo off
setlocal
set "MAINTMODE=%~1"
set "MAINTOUT=%~2"
set "MAINTTARGET=%~3"
set "MAINTSCRIPT=%TEMP%\Raymond_Maintenance_%RANDOM%_%RANDOM%.ps1"
set "RAYMOND_TOOLKIT=%~f0"
set "RAYMOND_MAINTSCRIPT=%MAINTSCRIPT%"

powershell.exe -NoProfile -Command "$c=Get-Content -LiteralPath $env:RAYMOND_TOOLKIT; $s=[Array]::IndexOf($c,'::PS_MAINTENANCE_BEGIN'); $e=[Array]::IndexOf($c,'::PS_MAINTENANCE_END'); if($s -lt 0 -or $e -le $s){exit 1}; $c[($s+1)..($e-1)] | Set-Content -LiteralPath $env:RAYMOND_MAINTSCRIPT -Encoding UTF8"
if errorlevel 1 (
    del /f /q "%MAINTSCRIPT%" >nul 2>&1
    endlocal
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%MAINTSCRIPT%" -Mode "%MAINTMODE%" -ReportPath "%MAINTOUT%" -TargetPath "%MAINTTARGET%"
set "MAINTRC=%errorlevel%"
del /f /q "%MAINTSCRIPT%" >nul 2>&1
endlocal & exit /b %MAINTRC%


::PS_MAINTENANCE_BEGIN
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        'Drivers','System','Network','DiskHealth','Processes','BitLocker',
        'Performance','Startup','Power','Profile','WinGetUpdates',
        'RegistryHealth','RegistryExplorer','RegistryWindowsUpdate','RegistryNetwork',
        'RegistryStartup','RegistrySecurity','RegistrySearch','RegistrySnapshot','RegistryCompare',
        'TempCleanup','OptimizeVolume','UpdateServices','UpdateReset',
        'ShellRestartExplorer','ShellRestartHosts',
        'ShellReregisterShell','ShellReregisterStart','ShellReregisterBoth'
    )]
    [string]$Mode,

    [string]$ReportPath = '',
    [string]$TargetPath = ''
)

$ErrorActionPreference = 'SilentlyContinue'

function HtmlEncodeValue {
    param($Value)
    if ($null -eq $Value) { return '' }
    if ($Value -is [System.Array]) { $Value = $Value -join ', ' }
    return [System.Net.WebUtility]::HtmlEncode([string]$Value)
}

function Get-AssessmentClass {
    param([string]$Assessment)
    switch -Regex ($Assessment) {
        '^(High|Critical|Bad|Error)' { return 'bad' }
        '^(Review|Warning|Warn|Medium)' { return 'warn' }
        '^(Good|Healthy|OK|Normal|Low)' { return 'good' }
        default { return 'review' }
    }
}

function New-HtmlHeader {
    param([string]$Title,[string]$Subtitle)
    return @"
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>$Title - $env:COMPUTERNAME</title>
<style>
body{font-family:Segoe UI,Arial,sans-serif;background:#111;color:#ddd;margin:30px}
h1{color:#4CAF50}h2{color:#6fcf73;border-bottom:1px solid #444;padding-bottom:6px;margin-top:34px}
table{border-collapse:collapse;width:100%;margin-bottom:25px}th,td{text-align:left;padding:8px;border-bottom:1px solid #333;vertical-align:top}th{color:#8be28f}
.good{color:#55dd77;font-weight:bold}.warn{color:#ffd54f;font-weight:bold}.bad{color:#ff5c5c;font-weight:bold}.review{color:#9aa0a6;font-weight:bold}
.mono{font-family:Consolas,monospace;font-size:12px;word-break:break-all}.note{color:#aaa}.footer{color:#777;margin-top:40px}
pre{background:#191919;border:1px solid #333;padding:12px;white-space:pre-wrap;word-break:break-word}
</style>
</head>
<body>
<h1>RAYMOND'S ENDPOINT TOOLKIT</h1>
<p>$Subtitle</p>
"@
}

function Add-HtmlTable {
    param([string]$Title,[array]$Rows,$Columns,[string]$EmptyMessage='No records returned.')
    $html = '<h2>' + (HtmlEncodeValue $Title) + '</h2><table><tr>'
    foreach ($entry in $Columns.GetEnumerator()) {
        $html += '<th>' + (HtmlEncodeValue $entry.Value) + '</th>'
    }
    $html += '</tr>'
    if (@($Rows).Count -eq 0) {
        $html += '<tr><td colspan="' + $Columns.Count + '" class="review">' + (HtmlEncodeValue $EmptyMessage) + '</td></tr>'
    }
    else {
        foreach ($row in $Rows) {
            $html += '<tr>'
            foreach ($entry in $Columns.GetEnumerator()) {
                $name = [string]$entry.Key
                $value = $row.$name
                $class = ''
                if ($name -in @('Assessment','Health','Risk')) { $class = Get-AssessmentClass ([string]$value) }
                $mono = if ($name -match 'Path|Command|Executable|SID|Location') { ' mono' } else { '' }
                $html += '<td class="' + $class + $mono + '">' + (HtmlEncodeValue $value) + '</td>'
            }
            $html += '</tr>'
        }
    }
    $html += '</table>'
    return $html
}

function Close-HtmlReport {
    return '<div class="footer">Generated: ' + (HtmlEncodeValue (Get-Date)) + '<br>Computer: ' + (HtmlEncodeValue $env:COMPUTERNAME) + '<br>RAYMOND''S ENDPOINT TOOLKIT</div></body></html>'
}

function Write-HtmlReport {
    param([string]$Content)
    if ([string]::IsNullOrWhiteSpace($ReportPath)) { throw 'A report path was not supplied.' }
    $Content | Out-File -LiteralPath $ReportPath -Encoding UTF8
}

function Get-CounterAverage {
    param($Samples,[string]$Pattern)
    $values = @($Samples.CounterSamples | Where-Object { $_.Path -match $Pattern } | ForEach-Object { $_.CookedValue } | Where-Object { $_ -ne $null })
    if ($values.Count -eq 0) { return $null }
    return [math]::Round((($values | Measure-Object -Average).Average),2)
}

function Get-ExecutableFromCommand {
    param([string]$Command)
    if ([string]::IsNullOrWhiteSpace($Command)) { return '' }
    if ($Command -match '^\s*"([^"]+\.exe)"') { return $matches[1] }
    if ($Command -match '^\s*(.+?\.exe)(?:\s|$)') { return $matches[1].Trim() }
    return ''
}

function Get-SignatureSummary {
    param([string]$Path)
    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 'Unavailable' }
    try {
        $sig = Get-AuthenticodeSignature -LiteralPath $Path
        if ($sig.Status -eq 'Valid' -and $sig.SignerCertificate) { return 'Valid - ' + $sig.SignerCertificate.Subject }
        return [string]$sig.Status
    }
    catch { return 'Unavailable' }
}

function Get-EventDataMap {
    param($Event)
    $map = @{}
    try {
        $xml = [xml]$Event.ToXml()
        foreach ($item in $xml.Event.EventData.Data) {
            if ($item.Name) { $map[[string]$item.Name] = [string]$item.'#text' }
        }
    }
    catch {}
    return $map
}

function Invoke-PowerCfgText {
    param([string[]]$Arguments)
    try { return ((& powercfg.exe @Arguments 2>&1) | Out-String).Trim() }
    catch { return $_.Exception.Message }
}

function Convert-RegistryDataToText {
    param($Value)
    if ($null -eq $Value) { return '' }
    if ($Value -is [byte[]]) { return ([BitConverter]::ToString($Value)) }
    if ($Value -is [System.Array]) { return (($Value | ForEach-Object {[string]$_}) -join ' | ') }
    return [string]$Value
}

function Get-RegistryValueRows {
    param(
        [string[]]$Paths,
        [string]$DefaultAssessment = 'Info',
        [switch]$Recurse
    )

    $rows = @()
    foreach ($root in $Paths) {
        if (-not (Test-Path -LiteralPath $root)) { continue }

        $keys = @()
        try {
            $keys += Get-Item -LiteralPath $root -ErrorAction SilentlyContinue
            if ($Recurse) {
                $keys += Get-ChildItem -LiteralPath $root -Recurse -ErrorAction SilentlyContinue
            }
        }
        catch {}

        foreach ($key in $keys) {
            if (-not $key) { continue }
            $props = Get-ItemProperty -LiteralPath $key.PSPath -ErrorAction SilentlyContinue
            if (-not $props) { continue }

            foreach ($prop in @($props.PSObject.Properties | Where-Object {$_.Name -notmatch '^PS(Path|ParentPath|ChildName|Drive|Provider)$'})) {
                $kind = ''
                try { $kind = $key.GetValueKind($prop.Name).ToString() } catch {}
                $rows += [PSCustomObject]@{
                    Key = $key.Name
                    Name = $prop.Name
                    Type = $kind
                    Value = Convert-RegistryDataToText $prop.Value
                    Assessment = $DefaultAssessment
                }
            }
        }
    }
    return $rows
}

function Get-ToolkitRegistrySnapshotRows {
    $roots = @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\SOFTWARE\Policies\Microsoft\Windows',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies',
        'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
        'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters',
        'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server'
    )

    $rows = @()
    foreach ($root in $roots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        $keys = @()
        try {
            $keys += Get-Item -LiteralPath $root -ErrorAction SilentlyContinue
            $keys += Get-ChildItem -LiteralPath $root -Recurse -ErrorAction SilentlyContinue
        }
        catch {}

        foreach ($key in $keys) {
            if (-not $key) { continue }
            $props = Get-ItemProperty -LiteralPath $key.PSPath -ErrorAction SilentlyContinue
            if (-not $props) { continue }
            foreach ($prop in @($props.PSObject.Properties | Where-Object {$_.Name -notmatch '^PS(Path|ParentPath|ChildName|Drive|Provider)$'})) {
                $kind = ''
                try { $kind = $key.GetValueKind($prop.Name).ToString() } catch {}
                $rows += [PSCustomObject]@{
                    Key = [string]$key.Name
                    Name = [string]$prop.Name
                    Type = [string]$kind
                    Value = Convert-RegistryDataToText $prop.Value
                }
            }
        }
    }
    return @($rows | Sort-Object Key,Name -Unique)
}

try {

switch ($Mode) {

'Drivers' {
    $html = New-HtmlHeader 'Installed Driver Report' 'Signed Plug and Play driver inventory for the local Windows endpoint.'
    $rows = @(Get-CimInstance Win32_PnPSignedDriver -ErrorAction SilentlyContinue | Where-Object {$_.DeviceName} | Sort-Object DeviceName | ForEach-Object {
        [PSCustomObject]@{
            Device=$_.DeviceName
            Class=$_.DeviceClass
            Manufacturer=$_.Manufacturer
            Provider=$_.DriverProviderName
            Version=$_.DriverVersion
            DriverDate=$_.DriverDate
            INF=$_.InfName
            Signed=$_.IsSigned
            Signer=$_.Signer
            Assessment=if($_.IsSigned){'Good'}else{'Review'}
        }
    })
    $html += Add-HtmlTable 'Installed Plug and Play Drivers' $rows ([ordered]@{Device='Device';Class='Class';Manufacturer='Manufacturer';Provider='Provider';Version='Version';DriverDate='Driver Date';INF='INF';Signed='Signed';Signer='Signer';Assessment='Assessment'}) 'No signed-driver inventory was returned.'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'System' {
    $html = New-HtmlHeader 'System Information Report' 'Core Windows, firmware, processor, graphics, storage and network inventory.'
    $computer=Get-CimInstance Win32_ComputerSystem
    $os=Get-CimInstance Win32_OperatingSystem
    $bios=Get-CimInstance Win32_BIOS
    $uptime=(Get-Date)-$os.LastBootUpTime
    $systemRows=@(
        [PSCustomObject]@{Item='Computer Name';Value=$env:COMPUTERNAME},
        [PSCustomObject]@{Item='Manufacturer';Value=$computer.Manufacturer},
        [PSCustomObject]@{Item='Model';Value=$computer.Model},
        [PSCustomObject]@{Item='Total RAM';Value=([math]::Round($computer.TotalPhysicalMemory/1GB,2).ToString()+' GB')},
        [PSCustomObject]@{Item='Operating System';Value=$os.Caption},
        [PSCustomObject]@{Item='Version / Build';Value=($os.Version+' / '+$os.BuildNumber)},
        [PSCustomObject]@{Item='Architecture';Value=$os.OSArchitecture},
        [PSCustomObject]@{Item='Last Boot';Value=$os.LastBootUpTime},
        [PSCustomObject]@{Item='Uptime';Value=($uptime.Days.ToString()+' days, '+$uptime.Hours+' hours, '+$uptime.Minutes+' minutes')},
        [PSCustomObject]@{Item='BIOS Version';Value=$bios.SMBIOSBIOSVersion},
        [PSCustomObject]@{Item='Serial Number';Value=$bios.SerialNumber}
    )
    $html += Add-HtmlTable 'System' $systemRows ([ordered]@{Item='Item';Value='Value'})
    $cpuRows=@(Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | ForEach-Object {[PSCustomObject]@{CPU=$_.Name;Cores=$_.NumberOfCores;LogicalProcessors=$_.NumberOfLogicalProcessors;MaxClockMHz=$_.MaxClockSpeed}})
    $html += Add-HtmlTable 'Processor' $cpuRows ([ordered]@{CPU='CPU';Cores='Cores';LogicalProcessors='Logical Processors';MaxClockMHz='Max Clock MHz'})
    $gpuRows=@(Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue | ForEach-Object {[PSCustomObject]@{GPU=$_.Name;DriverVersion=$_.DriverVersion;VideoMode=$_.VideoModeDescription;AdapterRAMGB=if($_.AdapterRAM){[math]::Round($_.AdapterRAM/1GB,2)}else{''}}})
    $html += Add-HtmlTable 'Graphics' $gpuRows ([ordered]@{GPU='GPU';DriverVersion='Driver Version';VideoMode='Video Mode';AdapterRAMGB='Adapter RAM GB'})
    $netRows=@(Get-NetAdapter -ErrorAction SilentlyContinue | Sort-Object Status,Name | ForEach-Object {[PSCustomObject]@{Name=$_.Name;Description=$_.InterfaceDescription;Status=$_.Status;LinkSpeed=$_.LinkSpeed;MacAddress=$_.MacAddress}})
    $html += Add-HtmlTable 'Network Adapters' $netRows ([ordered]@{Name='Adapter';Description='Description';Status='Status';LinkSpeed='Link Speed';MacAddress='MAC Address'})
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

 'Network' {
    $html = New-HtmlHeader 'Full Network Report' 'Comprehensive local network configuration, addressing, DNS, routing, proxy and active-interface information.'

    $adapterRows = @(Get-NetAdapter -ErrorAction SilentlyContinue | Sort-Object Status,Name | ForEach-Object {
        [PSCustomObject]@{
            Name=$_.Name
            Description=$_.InterfaceDescription
            Status=$_.Status
            LinkSpeed=$_.LinkSpeed
            MacAddress=$_.MacAddress
            MediaType=$_.MediaType
            PhysicalMediaType=$_.PhysicalMediaType
        }
    })
    $html += Add-HtmlTable 'Network Adapters' $adapterRows ([ordered]@{Name='Adapter';Description='Description';Status='Status';LinkSpeed='Link Speed';MacAddress='MAC Address';MediaType='Media Type';PhysicalMediaType='Physical Media Type'}) 'No network adapters were returned.'

    $configRows = @()
    foreach($cfg in @(Get-NetIPConfiguration -ErrorAction SilentlyContinue)) {
        $ipv4 = @($cfg.IPv4Address | ForEach-Object {$_.IPAddress}) -join ', '
        $ipv6 = @($cfg.IPv6Address | ForEach-Object {$_.IPAddress}) -join ', '
        $gateway = @($cfg.IPv4DefaultGateway | ForEach-Object {$_.NextHop}) -join ', '
        $dns = @($cfg.DNSServer.ServerAddresses) -join ', '
        $configRows += [PSCustomObject]@{
            Interface=$cfg.InterfaceAlias
            Description=$cfg.InterfaceDescription
            IPv4=$ipv4
            IPv6=$ipv6
            DefaultGateway=$gateway
            DNSServers=$dns
            NetProfile=if($cfg.NetProfile){$cfg.NetProfile.Name}else{''}
        }
    }
    $html += Add-HtmlTable 'IP Configuration' $configRows ([ordered]@{Interface='Interface';Description='Description';IPv4='IPv4';IPv6='IPv6';DefaultGateway='Default Gateway';DNSServers='DNS Servers';NetProfile='Network Profile'}) 'No IP configuration was returned.'

    $dnsRows = @(Get-DnsClientServerAddress -ErrorAction SilentlyContinue | Where-Object {$_.ServerAddresses.Count -gt 0} | ForEach-Object {
        [PSCustomObject]@{Interface=$_.InterfaceAlias;Family=$_.AddressFamily;Servers=($_.ServerAddresses -join ', ')}
    })
    $html += Add-HtmlTable 'DNS Server Configuration' $dnsRows ([ordered]@{Interface='Interface';Family='Address Family';Servers='DNS Servers'}) 'No DNS server addresses were returned.'

    $routeRows = @(Get-NetRoute -ErrorAction SilentlyContinue | Sort-Object RouteMetric,DestinationPrefix | Select-Object -First 250 | ForEach-Object {
        [PSCustomObject]@{Destination=$_.DestinationPrefix;NextHop=$_.NextHop;Interface=$_.InterfaceAlias;Metric=$_.RouteMetric;Protocol=$_.Protocol;State=$_.State}
    })
    $html += Add-HtmlTable 'Routing Table' $routeRows ([ordered]@{Destination='Destination';NextHop='Next Hop';Interface='Interface';Metric='Metric';Protocol='Protocol';State='State'}) 'No route information was returned.'

    $cacheRows = @(Get-DnsClientCache -ErrorAction SilentlyContinue | Sort-Object Entry,Type | Select-Object -First 500 | ForEach-Object {
        [PSCustomObject]@{Entry=$_.Entry;Type=$_.Type;Data=$_.Data;TimeToLive=$_.TimeToLive;Status=$_.Status}
    })
    $html += Add-HtmlTable 'DNS Resolver Cache - First 500 Records' $cacheRows ([ordered]@{Entry='Entry';Type='Type';Data='Data';TimeToLive='TTL';Status='Status'}) 'DNS cache is empty or could not be queried.'

    $profiles = @(Get-NetConnectionProfile -ErrorAction SilentlyContinue | ForEach-Object {
        [PSCustomObject]@{Name=$_.Name;InterfaceAlias=$_.InterfaceAlias;Category=$_.NetworkCategory;IPv4Connectivity=$_.IPv4Connectivity;IPv6Connectivity=$_.IPv6Connectivity}
    })
    $html += Add-HtmlTable 'Network Connection Profiles' $profiles ([ordered]@{Name='Profile';InterfaceAlias='Interface';Category='Category';IPv4Connectivity='IPv4 Connectivity';IPv6Connectivity='IPv6 Connectivity'}) 'No network connection profiles were returned.'

    $ipconfigText = ((& ipconfig.exe /all 2>&1) | Out-String).Trim()
    $routeText = ((& route.exe print 2>&1) | Out-String).Trim()
    $proxyText = ((& netsh.exe winhttp show proxy 2>&1) | Out-String).Trim()
    $wifiText = ((& netsh.exe wlan show interfaces 2>&1) | Out-String).Trim()

    $html += '<h2>WinHTTP Proxy</h2><pre>' + (HtmlEncodeValue $proxyText) + '</pre>'
    $html += '<h2>Wi-Fi Interface Details</h2><pre>' + (HtmlEncodeValue $wifiText) + '</pre>'
    $html += '<h2>IPCONFIG /ALL</h2><pre>' + (HtmlEncodeValue $ipconfigText) + '</pre>'
    $html += '<h2>ROUTE PRINT</h2><pre>' + (HtmlEncodeValue $routeText) + '</pre>'
    $html += '<p class="note">This report is a point-in-time snapshot. VPN, Wi-Fi, DHCP, DNS and route information can change after collection.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'Processes' {
    $html = New-HtmlHeader 'Running Process Report' 'Current process inventory sorted by working set, including CPU time, memory, thread count and executable path when accessible.'
    $rows=@(Get-Process -ErrorAction SilentlyContinue | ForEach-Object {
        $path='';$start=''
        try{$path=$_.Path}catch{}
        try{$start=$_.StartTime}catch{}
        [PSCustomObject]@{Process=$_.ProcessName;PID=$_.Id;CPUSeconds=if($_.CPU -ne $null){[math]::Round($_.CPU,2)}else{''};MemoryMB=[math]::Round($_.WorkingSet64/1MB,1);Threads=$_.Threads.Count;StartTime=$start;Executable=$path}
    } | Sort-Object MemoryMB -Descending)
    $html += Add-HtmlTable 'Running Processes' $rows ([ordered]@{Process='Process';PID='PID';CPUSeconds='CPU Seconds';MemoryMB='Memory MB';Threads='Threads';StartTime='Start Time';Executable='Executable'}) 'No running processes returned.'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'BitLocker' {
    $html = New-HtmlHeader 'BitLocker Status Report' 'Encryption and protection status. Recovery passwords are intentionally excluded.'
    $rows=@()
    foreach($v in @(Get-BitLockerVolume -ErrorAction SilentlyContinue)){
        $protectors=@($v.KeyProtector | ForEach-Object {$_.KeyProtectorType}) -join ', '
        $assessment=if([string]$v.ProtectionStatus -match 'On'){ 'Good' } elseif($v.VolumeType -eq 'OperatingSystem'){ 'High' } else { 'Review' }
        $rows += [PSCustomObject]@{Drive=$v.MountPoint;VolumeType=$v.VolumeType;Protection=$v.ProtectionStatus;VolumeStatus=$v.VolumeStatus;EncryptionMethod=$v.EncryptionMethod;EncryptedPercent=$v.EncryptionPercentage;AutoUnlock=$v.AutoUnlockEnabled;KeyProtectorTypes=$protectors;Assessment=$assessment}
    }
    $html += Add-HtmlTable 'BitLocker Volumes' $rows ([ordered]@{Drive='Drive';VolumeType='Volume Type';Protection='Protection';VolumeStatus='Volume Status';EncryptionMethod='Encryption Method';EncryptedPercent='Encrypted %';AutoUnlock='Auto Unlock';KeyProtectorTypes='Key Protector Types';Assessment='Assessment'}) 'BitLocker volume information was unavailable.'
    $html += '<p class="note">Recovery passwords and key material are intentionally not collected by this report.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'Performance' {
    $html = New-HtmlHeader 'Performance Bottleneck Analyzer' 'Short-duration CPU, memory, disk and process sampling for endpoint performance triage.'
    $logicalProcessors = [int](Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
    if ($logicalProcessors -lt 1) { $logicalProcessors = 1 }
    $os = Get-CimInstance Win32_OperatingSystem
    $computer = Get-CimInstance Win32_ComputerSystem
    $counterError = ''
    $samples = $null
    try {
        $counterList = @(
            '\Processor(_Total)\% Processor Time',
            '\Memory\Available MBytes',
            '\Memory\Pages/sec',
            '\PhysicalDisk(_Total)\% Disk Time',
            '\PhysicalDisk(_Total)\Avg. Disk sec/Transfer',
            '\System\Processor Queue Length'
        )
        $samples = Get-Counter -Counter $counterList -SampleInterval 1 -MaxSamples 10 -ErrorAction Stop
    }
    catch { $counterError = $_.Exception.Message }

    if ($samples) {
        $cpuAvg = Get-CounterAverage $samples '\\processor\(_total\)\\% processor time$'
        $availableMB = Get-CounterAverage $samples '\\memory\\available mbytes$'
        $pagesSec = Get-CounterAverage $samples '\\memory\\pages/sec$'
        $diskBusy = Get-CounterAverage $samples '\\physicaldisk\(_total\)\\% disk time$'
        $diskLatency = Get-CounterAverage $samples '\\physicaldisk\(_total\)\\avg\. disk sec/transfer$'
        $queue = Get-CounterAverage $samples '\\system\\processor queue length$'
    }
    else {
        $cpuAvg = [math]::Round(((Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average),2)
        $availableMB = [math]::Round($os.FreePhysicalMemory / 1024,2)
        $pagesSec = $null
        $diskBusy = $null
        $diskLatency = $null
        $queue = $null
    }

    $totalMB = [math]::Round($computer.TotalPhysicalMemory / 1MB,2)
    $memoryFreePercent = if ($totalMB -gt 0) { [math]::Round(($availableMB / $totalMB) * 100,1) } else { 0 }

    $cpuAssessment = if ($cpuAvg -ge 85) {'High'} elseif ($cpuAvg -ge 70) {'Review'} else {'Good'}
    $memoryAssessment = if ($memoryFreePercent -lt 10) {'High'} elseif ($memoryFreePercent -lt 20) {'Review'} else {'Good'}
    $diskAssessment = 'Good'
    if ($diskLatency -ne $null -and $diskLatency -ge 0.05) { $diskAssessment = 'High' }
    elseif (($diskLatency -ne $null -and $diskLatency -ge 0.02) -or ($diskBusy -ne $null -and $diskBusy -ge 90)) { $diskAssessment = 'Review' }
    $queueAssessment = if ($queue -ne $null -and $queue -gt ($logicalProcessors * 2)) {'Review'} else {'Good'}

    $bottlenecks = @()
    if ($cpuAssessment -ne 'Good') { $bottlenecks += 'CPU' }
    if ($memoryAssessment -ne 'Good') { $bottlenecks += 'Memory' }
    if ($diskAssessment -ne 'Good') { $bottlenecks += 'Disk' }
    $likely = if ($bottlenecks.Count -gt 0) { $bottlenecks -join ', ' } else { 'No sustained bottleneck observed during this sample' }

    $summary = @(
        [PSCustomObject]@{Metric='Likely Bottleneck';Value=$likely;Assessment=if($bottlenecks.Count -gt 0){'Review'}else{'Good'}},
        [PSCustomObject]@{Metric='Average CPU';Value=if($cpuAvg -ne $null){"$cpuAvg %"}else{'Unavailable'};Assessment=$cpuAssessment},
        [PSCustomObject]@{Metric='Available Memory';Value=if($availableMB -ne $null){"$availableMB MB ($memoryFreePercent% free)"}else{'Unavailable'};Assessment=$memoryAssessment},
        [PSCustomObject]@{Metric='Average Disk Busy';Value=if($diskBusy -ne $null){"$diskBusy %"}else{'Unavailable'};Assessment=$diskAssessment},
        [PSCustomObject]@{Metric='Average Disk Latency';Value=if($diskLatency -ne $null){([math]::Round($diskLatency*1000,2).ToString()+' ms')}else{'Unavailable'};Assessment=$diskAssessment},
        [PSCustomObject]@{Metric='Processor Queue';Value=if($queue -ne $null){$queue}else{'Unavailable'};Assessment=$queueAssessment},
        [PSCustomObject]@{Metric='Memory Pages/sec';Value=if($pagesSec -ne $null){$pagesSec}else{'Unavailable'};Assessment='Info'}
    )
    $html += Add-HtmlTable 'Performance Summary - 10 Second Sample' $summary ([ordered]@{Metric='Metric';Value='Value';Assessment='Assessment'})

    $procRows = @()
    foreach ($p in @(Get-CimInstance Win32_PerfFormattedData_PerfProc_Process | Where-Object {$_.Name -notin @('_Total','Idle') -and $_.IDProcess -gt 0} | Sort-Object PercentProcessorTime -Descending | Select-Object -First 20)) {
        $normalizedCpu = [math]::Round(([double]$p.PercentProcessorTime / $logicalProcessors),1)
        $procRows += [PSCustomObject]@{
            Process=$p.Name
            PID=$p.IDProcess
            CPUPercent=$normalizedCpu
            WorkingSetMB=[math]::Round(([double]$p.WorkingSetPrivate/1MB),1)
            IOBytesPerSec=$p.IODataBytesPersec
        }
    }
    $html += Add-HtmlTable 'Top Active Processes' $procRows ([ordered]@{Process='Process';PID='PID';CPUPercent='CPU %';WorkingSetMB='Private Memory MB';IOBytesPerSec='I/O Bytes/sec'}) 'Process performance counters were unavailable.'

    if ($counterError) {
        $html += '<h2>Collection Note</h2><p class="note">Performance counter collection failed and the report used a reduced fallback snapshot: ' + (HtmlEncodeValue $counterError) + '</p>'
    }
    else {
        $html += '<p class="note">This is a short sample. Intermittent issues may require a longer trace or repeated sampling.</p>'
    }
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'DiskHealth' {
    $html = New-HtmlHeader 'Disk Information / Storage Health' 'Physical disks, volumes and supported storage reliability counters including temperature, wear and error data.'
    $diskRows = @()
    foreach ($disk in @(Get-PhysicalDisk -ErrorAction SilentlyContinue)) {
        $rel = $null
        try { $rel = $disk | Get-StorageReliabilityCounter -ErrorAction SilentlyContinue }
        catch {}
        $readUncorrected = if ($rel) {[int64]$rel.ReadErrorsUncorrected}else{0}
        $writeUncorrected = if ($rel) {[int64]$rel.WriteErrorsUncorrected}else{0}
        $temp = if ($rel -and $rel.Temperature -ne $null) {$rel.Temperature}else{$null}
        $assessment = if ($disk.HealthStatus -and $disk.HealthStatus -ne 'Healthy') {'High'} elseif (($readUncorrected + $writeUncorrected) -gt 0) {'High'} elseif ($temp -ne $null -and $temp -ge 70) {'High'} elseif ($temp -ne $null -and $temp -ge 60) {'Review'} else {'Good'}
        $diskRows += [PSCustomObject]@{
            Disk=$disk.FriendlyName
            Media=$disk.MediaType
            Bus=$disk.BusType
            SizeGB=[math]::Round($disk.Size/1GB,2)
            Health=$disk.HealthStatus
            Operational=($disk.OperationalStatus -join ', ')
            Temperature=if($temp -ne $null){"$temp C"}else{'N/A'}
            TemperatureMax=if($rel -and $rel.TemperatureMax -ne $null){"$($rel.TemperatureMax) C"}else{'N/A'}
            Wear=if($rel -and $rel.Wear -ne $null){$rel.Wear}else{'N/A'}
            PowerOnHours=if($rel -and $rel.PowerOnHours -ne $null){$rel.PowerOnHours}else{'N/A'}
            ReadErrors=if($rel -and $rel.ReadErrorsTotal -ne $null){$rel.ReadErrorsTotal}else{'N/A'}
            WriteErrors=if($rel -and $rel.WriteErrorsTotal -ne $null){$rel.WriteErrorsTotal}else{'N/A'}
            UncorrectedErrors=($readUncorrected + $writeUncorrected)
            Assessment=$assessment
        }
    }
    $html += Add-HtmlTable 'Physical Disk Health' $diskRows ([ordered]@{Disk='Disk';Media='Media';Bus='Bus';SizeGB='Size GB';Health='Health';Operational='Operational Status';Temperature='Temperature';TemperatureMax='Max Temperature';Wear='Wear';PowerOnHours='Power-On Hours';ReadErrors='Read Errors';WriteErrors='Write Errors';UncorrectedErrors='Uncorrected Errors';Assessment='Assessment'}) 'No physical disk information returned.'

    $volumeRows = @()
    foreach ($v in @(Get-Volume -ErrorAction SilentlyContinue | Where-Object {$_.Size -gt 0})) {
        $freePercent = [math]::Round(($v.SizeRemaining/$v.Size)*100,1)
        $assessment = if ($v.HealthStatus -and $v.HealthStatus -ne 'Healthy') {'High'} elseif ($freePercent -lt 10) {'High'} elseif ($freePercent -lt 20) {'Review'} else {'Good'}
        $volumeRows += [PSCustomObject]@{
            Drive=if($v.DriveLetter){$v.DriveLetter+':'}else{''}
            Label=$v.FileSystemLabel
            FileSystem=$v.FileSystem
            Health=$v.HealthStatus
            SizeGB=[math]::Round($v.Size/1GB,2)
            FreeGB=[math]::Round($v.SizeRemaining/1GB,2)
            FreePercent="$freePercent %"
            Assessment=$assessment
        }
    }
    $html += Add-HtmlTable 'Volumes' $volumeRows ([ordered]@{Drive='Drive';Label='Label';FileSystem='File System';Health='Health';SizeGB='Size GB';FreeGB='Free GB';FreePercent='Free %';Assessment='Assessment'}) 'No volume information returned.'
    $html += '<p class="note">Reliability counters depend on drive/controller support. N/A does not by itself indicate a problem.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'Startup' {
    $html = New-HtmlHeader 'Startup Performance Analyzer' 'Startup entries plus recent Windows Diagnostics-Performance boot and startup degradation events.'
    $startupRows = @()
    foreach ($item in @(Get-CimInstance Win32_StartupCommand -ErrorAction SilentlyContinue | Sort-Object Name)) {
        $exe = Get-ExecutableFromCommand ([string]$item.Command)
        $signature = Get-SignatureSummary $exe
        $assessment = if ($exe -and (Test-Path -LiteralPath $exe) -and $signature -notlike 'Valid*') {'Review'} elseif ($item.Command -match '\\AppData\\|\\Temp\\|\\Downloads\\') {'Review'} else {'Info'}
        $startupRows += [PSCustomObject]@{Name=$item.Name;User=$item.User;Location=$item.Location;Command=$item.Command;Executable=$exe;Signature=$signature;Assessment=$assessment}
    }
    $html += Add-HtmlTable 'Startup Commands' $startupRows ([ordered]@{Name='Name';User='User';Location='Location';Command='Command';Executable='Executable';Signature='Signature';Assessment='Assessment'}) 'No Win32_StartupCommand entries returned.'

    $bootRows = @()
    $degradeRows = @()
    $logName = 'Microsoft-Windows-Diagnostics-Performance/Operational'
    foreach ($event in @(Get-WinEvent -FilterHashtable @{LogName=$logName;StartTime=(Get-Date).AddDays(-14)} -ErrorAction SilentlyContinue | Where-Object {$_.Id -ge 100 -and $_.Id -le 110} | Select-Object -First 150)) {
        $data = Get-EventDataMap $event
        if ($event.Id -eq 100) {
            $bootRows += [PSCustomObject]@{
                Time=$event.TimeCreated
                BootSeconds=if($data.BootTime){[math]::Round(([double]$data.BootTime/1000),1)}else{''}
                MainPathSeconds=if($data.MainPathBootTime){[math]::Round(([double]$data.MainPathBootTime/1000),1)}else{''}
                PostBootSeconds=if($data.BootPostBootTime){[math]::Round(([double]$data.BootPostBootTime/1000),1)}else{''}
                Assessment=if($data.BootTime -and [double]$data.BootTime -gt 120000){'Review'}else{'Info'}
            }
        }
        else {
            $degradeRows += [PSCustomObject]@{
                Time=$event.TimeCreated
                EventID=$event.Id
                Name=if($data.FriendlyName){$data.FriendlyName}elseif($data.Name){$data.Name}else{$event.ProviderName}
                TotalTimeMs=$data.TotalTime
                DegradationMs=$data.DegradationTime
                Message=$event.Message
                Assessment='Review'
            }
        }
    }
    $html += Add-HtmlTable 'Recent Boot Duration Events' $bootRows ([ordered]@{Time='Time';BootSeconds='Boot Seconds';MainPathSeconds='Main Path Seconds';PostBootSeconds='Post-Boot Seconds';Assessment='Assessment'}) 'No Diagnostics-Performance boot events returned.'
    $html += Add-HtmlTable 'Startup Degradation Events' $degradeRows ([ordered]@{Time='Time';EventID='Event ID';Name='Component / App';TotalTimeMs='Total Time ms';DegradationMs='Degradation ms';Message='Message';Assessment='Assessment'}) 'No startup degradation events returned in the last 14 days.'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'Power' {
    $html = New-HtmlHeader 'Power / Sleep Diagnostics' 'Current power plan, supported sleep states, active power requests, wake evidence and wake-capable devices.'
    $battery = @(Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue | ForEach-Object {[PSCustomObject]@{Name=$_.Name;Status=$_.Status;EstimatedChargeRemaining=$_.EstimatedChargeRemaining;EstimatedRunTime=$_.EstimatedRunTime}})
    $html += Add-HtmlTable 'Battery Snapshot' $battery ([ordered]@{Name='Battery';Status='Status';EstimatedChargeRemaining='Charge %';EstimatedRunTime='Estimated Runtime'}) 'No battery was reported.'

    $sections = [ordered]@{
        'Active Power Scheme' = Invoke-PowerCfgText @('/getactivescheme')
        'Available Sleep States' = Invoke-PowerCfgText @('/a')
        'Active Power Requests' = Invoke-PowerCfgText @('/requests')
        'Last Wake Source' = Invoke-PowerCfgText @('/lastwake')
        'Wake Timers' = Invoke-PowerCfgText @('/waketimers')
        'Devices Armed to Wake' = Invoke-PowerCfgText @('/devicequery','wake_armed')
    }
    foreach ($entry in $sections.GetEnumerator()) {
        $html += '<h2>' + (HtmlEncodeValue $entry.Key) + '</h2><pre>' + (HtmlEncodeValue $entry.Value) + '</pre>'
    }
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'Profile' {
    $html = New-HtmlHeader 'User Profile Health Audit' 'ProfileList registry mappings, profile folders and Win32_UserProfile state. This report does not automatically modify profile registry keys.'
    $currentSid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $summary = @(
        [PSCustomObject]@{Item='Current User';Value=$env:USERNAME;Assessment='Info'},
        [PSCustomObject]@{Item='Current SID';Value=$currentSid;Assessment='Info'},
        [PSCustomObject]@{Item='Current USERPROFILE';Value=$env:USERPROFILE;Assessment=if(Test-Path -LiteralPath $env:USERPROFILE){'Good'}else{'High'}}
    )
    $html += Add-HtmlTable 'Current Profile' $summary ([ordered]@{Item='Item';Value='Value';Assessment='Assessment'})

    $profileRows = @()
    $base = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'
    foreach ($key in @(Get-ChildItem -LiteralPath $base -ErrorAction SilentlyContinue)) {
        $p = Get-ItemProperty -LiteralPath $key.PSPath -ErrorAction SilentlyContinue
        $path = [Environment]::ExpandEnvironmentVariables([string]$p.ProfileImagePath)
        $assessment = 'Good'
        $notes = @()
        if ($key.PSChildName -like '*.bak') { $assessment='Review'; $notes += '.bak ProfileList key' }
        if ($path -and -not (Test-Path -LiteralPath $path)) { $assessment='High'; $notes += 'Profile folder missing' }
        if ($path -match '\\Users\\TEMP(?:$|\\)') { $assessment='High'; $notes += 'Temporary profile path' }
        if ($p.State -and [int64]$p.State -ne 0) { if($assessment -eq 'Good'){$assessment='Review'}; $notes += ('State=' + $p.State) }
        if ($p.RefCount -and [int64]$p.RefCount -gt 0 -and $key.PSChildName -ne $currentSid) { if($assessment -eq 'Good'){$assessment='Review'}; $notes += ('RefCount=' + $p.RefCount) }
        $profileRows += [PSCustomObject]@{
            SID=$key.PSChildName
            ProfilePath=$path
            FolderExists=if($path){Test-Path -LiteralPath $path}else{$false}
            State=$p.State
            RefCount=$p.RefCount
            Current=($key.PSChildName -eq $currentSid)
            Notes=($notes -join '; ')
            Assessment=$assessment
        }
    }
    $html += Add-HtmlTable 'ProfileList Registry' $profileRows ([ordered]@{SID='SID / Registry Key';ProfilePath='Profile Path';FolderExists='Folder Exists';State='State';RefCount='RefCount';Current='Current';Notes='Notes';Assessment='Assessment'}) 'No ProfileList entries returned.'

    $wmiRows = @(Get-CimInstance Win32_UserProfile -ErrorAction SilentlyContinue | Where-Object {-not $_.Special} | Sort-Object LastUseTime -Descending | ForEach-Object {[PSCustomObject]@{SID=$_.SID;LocalPath=$_.LocalPath;Loaded=$_.Loaded;LastUseTime=$_.LastUseTime;Status=$_.Status}})
    $html += Add-HtmlTable 'Windows User Profiles' $wmiRows ([ordered]@{SID='SID';LocalPath='Local Path';Loaded='Loaded';LastUseTime='Last Use';Status='Status'}) 'No user profiles returned.'
    $html += '<p class="note">A .bak key, missing profile folder, or TEMP profile mapping warrants technician review. Automatic registry repair is intentionally not performed while a profile may be loaded.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

 'WinGetUpdates' {
    $html = New-HtmlHeader 'Application Update Report' 'Windows Package Manager inventory of applications that currently have an available upgrade.'
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget) {
        $rows = @([PSCustomObject]@{Item='WinGet';Value='Not found';Assessment='Review'})
        $html += Add-HtmlTable 'WinGet Status' $rows ([ordered]@{Item='Item';Value='Value';Assessment='Assessment'})
        $html += '<p class="note">WinGet is normally supplied by Microsoft App Installer. The toolkit does not install it automatically.</p>'
    }
    else {
        $versionText = ((& $winget.Source --version 2>&1) | Out-String).Trim()
        $sourceText = ((& $winget.Source source list 2>&1) | Out-String).Trim()
        $updateText = ((& $winget.Source list --upgrade-available --accept-source-agreements --disable-interactivity 2>&1) | Out-String).Trim()
        $statusRows = @(
            [PSCustomObject]@{Item='Executable';Value=$winget.Source;Assessment='Good'},
            [PSCustomObject]@{Item='Version';Value=$versionText;Assessment='Good'}
        )
        $html += Add-HtmlTable 'WinGet Status' $statusRows ([ordered]@{Item='Item';Value='Value';Assessment='Assessment'})
        $html += '<h2>Configured Sources</h2><pre>' + (HtmlEncodeValue $sourceText) + '</pre>'
        $html += '<h2>Applications With Available Updates</h2><pre>' + (HtmlEncodeValue $updateText) + '</pre>'
        $html += '<p class="note">The update list is intentionally preserved as WinGet output because package names, versions and sources vary by machine and locale. Pinned packages may not appear as normal update candidates.</p>'
    }
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

 'RegistryHealth' {
    $html = New-HtmlHeader 'Registry Health Overview' 'Read-only registry and hive health checks for endpoint troubleshooting. This report does not clean or rewrite the registry.'

    $hiveChecks = @(
        @{Name='HKLM - SYSTEM';Path='HKLM:\SYSTEM';File=(Join-Path $env:WINDIR 'System32\config\SYSTEM')},
        @{Name='HKLM - SOFTWARE';Path='HKLM:\SOFTWARE';File=(Join-Path $env:WINDIR 'System32\config\SOFTWARE')},
        @{Name='HKLM - SAM';Path='HKLM:\SAM';File=(Join-Path $env:WINDIR 'System32\config\SAM');Protected=$true},
        @{Name='HKLM - SECURITY';Path='HKLM:\SECURITY';File=(Join-Path $env:WINDIR 'System32\config\SECURITY');Protected=$true},
        @{Name='HKU - DEFAULT';Path='Registry::HKEY_USERS\.DEFAULT';File=(Join-Path $env:WINDIR 'System32\config\DEFAULT')},
        @{Name='HKCU';Path='HKCU:\';File=''}
    )

    $hiveRows = @()
    foreach ($h in $hiveChecks) {
        $accessible = Test-Path -LiteralPath $h.Path
        $fileExists = if ($h.File) { Test-Path -LiteralPath $h.File } else { $true }
        $sizeMB = ''
        $lastWrite = ''
        if ($h.File -and $fileExists) {
            $f = Get-Item -LiteralPath $h.File -ErrorAction SilentlyContinue
            if ($f) { $sizeMB=[math]::Round($f.Length/1MB,2); $lastWrite=$f.LastWriteTime }
        }
        $assessment = if (-not $fileExists) {'High'} elseif (-not $accessible -and $h.Protected) {'Info'} elseif (-not $accessible) {'Review'} else {'Good'}
        $hiveRows += [PSCustomObject]@{Hive=$h.Name;Accessible=$accessible;HiveFile=$h.File;FileExists=$fileExists;SizeMB=$sizeMB;LastWrite=$lastWrite;Assessment=$assessment}
    }
    $html += Add-HtmlTable 'Registry Hive Availability' $hiveRows ([ordered]@{Hive='Hive';Accessible='Accessible';HiveFile='Hive File';FileExists='File Exists';SizeMB='Size MB';LastWrite='Last Modified';Assessment='Assessment'})

    $regBackPath = Join-Path $env:WINDIR 'System32\config\RegBack'
    $regBackRows = @()
    foreach ($name in @('SYSTEM','SOFTWARE','SAM','SECURITY','DEFAULT')) {
        $file = Join-Path $regBackPath $name
        $item = Get-Item -LiteralPath $file -ErrorAction SilentlyContinue
        $regBackRows += [PSCustomObject]@{
            Hive=$name
            File=$file
            Exists=[bool]$item
            SizeMB=if($item){[math]::Round($item.Length/1MB,2)}else{''}
            LastWrite=if($item){$item.LastWriteTime}else{''}
            Assessment='Info'
        }
    }
    $html += Add-HtmlTable 'RegBack Folder Status' $regBackRows ([ordered]@{Hive='Hive';File='File';Exists='Exists';SizeMB='Size MB';LastWrite='Last Modified';Assessment='Assessment'})
    $html += '<p class="note">Modern Windows versions may leave RegBack hive files at zero bytes by design. A zero-byte RegBack file alone is not treated as registry corruption.</p>'

    $eventRows = @()
    try {
        $events = @(Get-WinEvent -FilterHashtable @{LogName=@('System','Application');StartTime=(Get-Date).AddDays(-7)} -ErrorAction SilentlyContinue |
            Where-Object { $_.Message -match '(?i)registry|registry hive|hive file' } |
            Select-Object -First 50)
        foreach($e in $events){
            $eventRows += [PSCustomObject]@{Time=$e.TimeCreated;Log=$e.LogName;Level=$e.LevelDisplayName;EventID=$e.Id;Provider=$e.ProviderName;Message=$e.Message;Assessment=if($e.LevelDisplayName -in @('Critical','Error')){'Review'}else{'Info'}}
        }
    }
    catch {}
    $html += Add-HtmlTable 'Recent Registry-Related Events' $eventRows ([ordered]@{Time='Time';Log='Log';Level='Level';EventID='Event ID';Provider='Provider';Message='Message';Assessment='Assessment'}) 'No recent registry-related events were returned.'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'RegistryExplorer' {
    $html = New-HtmlHeader 'Explorer / Start Menu Registry Audit' 'Explorer, Start menu and Winlogon registry settings that can affect the Windows shell. Policy values may be intentional in managed environments.'

    $policyPaths = @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    )
    $policyRows = @(Get-RegistryValueRows -Paths $policyPaths)
    foreach($row in $policyRows){
        if ($row.Name -match '^(NoClose|NoRun|NoControlPanel|DisableTaskMgr|NoViewContextMenu|NoDesktop|NoLogoff|NoSetTaskbar|NoTrayContextMenu)$' -and [string]$row.Value -notin @('0','')) {
            $row.Assessment='Review'
        }
    }
    $html += Add-HtmlTable 'Explorer / System Policy Values' $policyRows ([ordered]@{Key='Registry Key';Name='Value';Type='Type';Value='Data';Assessment='Assessment'}) 'No Explorer/System policy values were configured in the checked locations.'

    $winlogon = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -ErrorAction SilentlyContinue
    $shell = [string]$winlogon.Shell
    $userinit = [string]$winlogon.Userinit
    $shellRows = @(
        [PSCustomObject]@{Setting='Winlogon Shell';Value=$shell;Expected='explorer.exe';Assessment=if($shell -and $shell.Trim().ToLower() -eq 'explorer.exe'){'Good'}else{'Review'}},
        [PSCustomObject]@{Setting='Winlogon Userinit';Value=$userinit;Expected='%SystemRoot%\system32\userinit.exe,';Assessment=if($userinit -match '(?i)\\userinit\.exe,?\s*$'){'Good'}else{'Review'}}
    )
    $html += Add-HtmlTable 'Winlogon Shell Values' $shellRows ([ordered]@{Setting='Setting';Value='Current Value';Expected='Expected';Assessment='Assessment'})
    $html += '<p class="note">A configured policy is not automatically an error. Domain, Intune, security baselines, kiosk settings and accessibility requirements can intentionally configure these values.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'RegistryWindowsUpdate' {
    $html = New-HtmlHeader 'Windows Update Registry Audit' 'Registry-backed Windows Update policy and target-version settings.'
    $paths = @(
        'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate',
        'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU',
        'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
    )
    $rows = @(Get-RegistryValueRows -Paths $paths)
    foreach($row in $rows){
        switch -Regex ($row.Name) {
            '^(DisableWindowsUpdateAccess|NoAutoUpdate)$' { if([string]$row.Value -notin @('0','')){$row.Assessment='Review'} }
            '^(WUServer|WUStatusServer|TargetReleaseVersion|TargetReleaseVersionInfo|ProductVersion|UseWUServer)$' { $row.Assessment='Info' }
            '^DoNotConnectToWindowsUpdateInternetLocations$' { if([string]$row.Value -notin @('0','')){$row.Assessment='Review'} }
        }
    }
    $html += Add-HtmlTable 'Windows Update Registry Settings' $rows ([ordered]@{Key='Registry Key';Name='Value';Type='Type';Value='Data';Assessment='Assessment'}) 'No Windows Update values were returned from the checked locations.'
    $html += '<p class="note">WSUS, target-release and Windows Update policy values are often intentionally configured by enterprise management. Review them against the organization standard rather than treating their presence as a fault.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'RegistryNetwork' {
    $html = New-HtmlHeader 'Network / Proxy Registry Audit' 'User proxy, PAC, TCP/IP, DNS override and hosts-file settings that can affect endpoint connectivity.'

    $internet = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction SilentlyContinue
    $proxyRows = @(
        [PSCustomObject]@{Setting='ProxyEnable';Value=$internet.ProxyEnable;Assessment=if([int]$internet.ProxyEnable -eq 1){'Review'}else{'Good'}},
        [PSCustomObject]@{Setting='ProxyServer';Value=$internet.ProxyServer;Assessment=if($internet.ProxyServer){'Review'}else{'Info'}},
        [PSCustomObject]@{Setting='AutoConfigURL';Value=$internet.AutoConfigURL;Assessment=if($internet.AutoConfigURL){'Review'}else{'Info'}},
        [PSCustomObject]@{Setting='AutoDetect';Value=$internet.AutoDetect;Assessment='Info'}
    )
    $html += Add-HtmlTable 'Current User Internet Settings' $proxyRows ([ordered]@{Setting='Setting';Value='Value';Assessment='Assessment'})

    $winHttp = ''
    try { $winHttp = ((& netsh.exe winhttp show proxy 2>&1) | Out-String).Trim() } catch { $winHttp=$_.Exception.Message }
    $html += '<h2>WinHTTP Proxy</h2><pre>' + (HtmlEncodeValue $winHttp) + '</pre>'

    $tcpPaths = @('HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters')
    $tcpRows = @(Get-RegistryValueRows -Paths $tcpPaths)
    $tcpRows = @($tcpRows | Where-Object {$_.Name -match '^(NameServer|DhcpNameServer|Domain|NV Domain|SearchList|EnableICMPRedirect|IPEnableRouter)$'})
    foreach($row in $tcpRows){ if($row.Name -in @('NameServer','SearchList') -and $row.Value){$row.Assessment='Review'} }
    $html += Add-HtmlTable 'TCP/IP Registry Settings' $tcpRows ([ordered]@{Key='Registry Key';Name='Value';Type='Type';Value='Data';Assessment='Assessment'}) 'No selected TCP/IP values were returned.'

    $dnsRows = @()
    foreach($key in @(Get-ChildItem -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' -ErrorAction SilentlyContinue)){
        $p=Get-ItemProperty -LiteralPath $key.PSPath -ErrorAction SilentlyContinue
        if($p.NameServer -or $p.DhcpNameServer){
            $dnsRows += [PSCustomObject]@{Interface=$key.PSChildName;StaticDNS=$p.NameServer;DhcpDNS=$p.DhcpNameServer;Assessment=if($p.NameServer){'Review'}else{'Info'}}
        }
    }
    $html += Add-HtmlTable 'Interface DNS Registry Values' $dnsRows ([ordered]@{Interface='Interface GUID';StaticDNS='Static DNS';DhcpDNS='DHCP DNS';Assessment='Assessment'}) 'No interface DNS registry values were returned.'

    $hostsPath = Join-Path $env:WINDIR 'System32\drivers\etc\hosts'
    $hostsRows=@()
    if(Test-Path -LiteralPath $hostsPath){
        foreach($line in @(Get-Content -LiteralPath $hostsPath -ErrorAction SilentlyContinue)){
            $trim=$line.Trim()
            if($trim -and -not $trim.StartsWith('#')){$hostsRows += [PSCustomObject]@{Entry=$trim;Assessment='Review'}}
        }
    }
    $html += Add-HtmlTable 'Custom Hosts File Entries' $hostsRows ([ordered]@{Entry='Entry';Assessment='Assessment'}) 'No active custom hosts-file entries were found.'
    $html += '<p class="note">Proxies, PAC files, static DNS and hosts-file entries can be legitimate. They are surfaced for technician review because stale or unexpected values frequently cause connectivity issues.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'RegistryStartup' {
    $html = New-HtmlHeader 'Startup Registry Audit' 'Run and RunOnce registry entries with executable path and Authenticode review where resolvable.'
    $paths = @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce'
    )
    $rows=@()
    foreach($path in $paths){
        if(-not (Test-Path -LiteralPath $path)){continue}
        $p=Get-ItemProperty -LiteralPath $path -ErrorAction SilentlyContinue
        foreach($prop in @($p.PSObject.Properties | Where-Object {$_.Name -notmatch '^PS(Path|ParentPath|ChildName|Drive|Provider)$'})){
            $command=[string]$prop.Value
            $exe=Get-ExecutableFromCommand $command
            $sig=Get-SignatureSummary $exe
            $assessment='Info'
            if($exe -and -not (Test-Path -LiteralPath $exe)){$assessment='High'}
            elseif($command -match '(?i)\\Temp\\|\\Downloads\\'){$assessment='Review'}
            elseif($exe -and (Test-Path -LiteralPath $exe) -and $sig -notlike 'Valid*'){$assessment='Review'}
            $rows += [PSCustomObject]@{Location=$path;Name=$prop.Name;Command=$command;Executable=$exe;Signature=$sig;Assessment=$assessment}
        }
    }
    $html += Add-HtmlTable 'Run / RunOnce Entries' $rows ([ordered]@{Location='Location';Name='Value Name';Command='Command';Executable='Executable';Signature='Signature';Assessment='Assessment'}) 'No Run/RunOnce registry startup entries were found.'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'RegistrySecurity' {
    $html = New-HtmlHeader 'Security Policy Registry Audit' 'Selected registry-backed Windows security settings. Results should be compared with the organization security baseline.'

    $uac = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -ErrorAction SilentlyContinue
    $rdp = Get-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -ErrorAction SilentlyContinue
    $rdpTcp = Get-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -ErrorAction SilentlyContinue
    $lsa = Get-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -ErrorAction SilentlyContinue
    $smb = Get-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -ErrorAction SilentlyContinue
    $defender = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -ErrorAction SilentlyContinue
    $defenderRt = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' -ErrorAction SilentlyContinue
    $wshMachine = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings' -ErrorAction SilentlyContinue

    $rdpEnabled = ([int]$rdp.fDenyTSConnections -eq 0)
    $rows = @(
        [PSCustomObject]@{Area='UAC';Setting='EnableLUA';Value=$uac.EnableLUA;Assessment=if([int]$uac.EnableLUA -eq 1){'Good'}else{'High'}},
        [PSCustomObject]@{Area='UAC';Setting='ConsentPromptBehaviorAdmin';Value=$uac.ConsentPromptBehaviorAdmin;Assessment=if([int]$uac.ConsentPromptBehaviorAdmin -eq 0){'Review'}else{'Info'}},
        [PSCustomObject]@{Area='UAC';Setting='PromptOnSecureDesktop';Value=$uac.PromptOnSecureDesktop;Assessment=if([int]$uac.PromptOnSecureDesktop -eq 1){'Good'}else{'Review'}},
        [PSCustomObject]@{Area='RDP';Setting='Remote Desktop Enabled';Value=$rdpEnabled;Assessment=if($rdpEnabled){'Review'}else{'Good'}},
        [PSCustomObject]@{Area='RDP';Setting='Network Level Authentication';Value=$rdpTcp.UserAuthentication;Assessment=if($rdpEnabled -and [int]$rdpTcp.UserAuthentication -ne 1){'High'}elseif([int]$rdpTcp.UserAuthentication -eq 1){'Good'}else{'Info'}},
        [PSCustomObject]@{Area='LSA';Setting='RunAsPPL';Value=$lsa.RunAsPPL;Assessment=if([int]$lsa.RunAsPPL -in @(1,2)){'Good'}else{'Review'}},
        [PSCustomObject]@{Area='LSA';Setting='LmCompatibilityLevel';Value=$lsa.LmCompatibilityLevel;Assessment=if($lsa.LmCompatibilityLevel -ne $null -and [int]$lsa.LmCompatibilityLevel -lt 3){'Review'}else{'Info'}},
        [PSCustomObject]@{Area='SMB';Setting='SMB1';Value=$smb.SMB1;Assessment=if([int]$smb.SMB1 -eq 1){'High'}elseif($smb.SMB1 -eq $null){'Info'}else{'Good'}},
        [PSCustomObject]@{Area='Defender Policy';Setting='DisableAntiSpyware';Value=$defender.DisableAntiSpyware;Assessment=if([int]$defender.DisableAntiSpyware -eq 1){'High'}else{'Info'}},
        [PSCustomObject]@{Area='Defender Policy';Setting='DisableRealtimeMonitoring';Value=$defenderRt.DisableRealtimeMonitoring;Assessment=if([int]$defenderRt.DisableRealtimeMonitoring -eq 1){'High'}else{'Info'}},
        [PSCustomObject]@{Area='Windows Script Host';Setting='Enabled';Value=$wshMachine.Enabled;Assessment='Info'}
    )
    $html += Add-HtmlTable 'Selected Security Registry Settings' $rows ([ordered]@{Area='Area';Setting='Setting';Value='Value';Assessment='Assessment'})

    $policyRoots=@('HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender','HKLM:\SOFTWARE\Policies\Microsoft\Windows\System')
    $policyRows=@(Get-RegistryValueRows -Paths $policyRoots -Recurse)
    $html += Add-HtmlTable 'Additional Security Policy Values' $policyRows ([ordered]@{Key='Registry Key';Name='Value';Type='Type';Value='Data';Assessment='Assessment'}) 'No additional values were returned from the selected policy roots.'
    $html += '<p class="note">A Review result is not automatically insecure. Managed endpoints can intentionally configure these values through Group Policy, Intune or another security baseline.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'RegistrySearch' {
    if ([string]::IsNullOrWhiteSpace($TargetPath)) { throw 'A registry search term was not supplied.' }
    $term = $TargetPath.Trim()
    $html = New-HtmlHeader 'Registry Search' ('Search results for: ' + (HtmlEncodeValue $term))
    $roots = @('HKCU\Software','HKLM\SOFTWARE','HKLM\SYSTEM\CurrentControlSet\Services')
    $rows=@()
    foreach($root in $roots){
        $output=@()
        try { $output = @(& reg.exe query $root /f $term /s 2>&1) } catch { $output=@($_.Exception.Message) }
        foreach($line in $output){
            $value=[string]$line
            if([string]::IsNullOrWhiteSpace($value)){continue}
            if($value -match '^End of search'){continue}
            $rows += [PSCustomObject]@{Root=$root;Result=$value.Trim();Assessment='Info'}
            if($rows.Count -ge 1000){break}
        }
        if($rows.Count -ge 1000){break}
    }
    $html += Add-HtmlTable 'Matches' $rows ([ordered]@{Root='Search Root';Result='Result';Assessment='Assessment'}) 'No matches were returned from the selected registry roots.'
    if($rows.Count -ge 1000){$html += '<p class="note">Result display was capped at 1,000 lines. Refine the search term for a narrower result set.</p>'}
    $html += '<p class="note">Search scope: HKCU\\Software, HKLM\\SOFTWARE and HKLM\\SYSTEM\\CurrentControlSet\\Services. This is intentionally narrower than a full-hive forensic search to keep technician searches practical.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'RegistrySnapshot' {
    if ([string]::IsNullOrWhiteSpace($TargetPath)) { throw 'A snapshot output path was not supplied.' }
    $snapshotRows = @(Get-ToolkitRegistrySnapshotRows)
    $snapshot = [PSCustomObject]@{
        FormatVersion = 1
        Toolkit = "Raymond Endpoint Toolkit"
        Computer = $env:COMPUTERNAME
        User = $env:USERNAME
        Created = (Get-Date).ToString('o')
        EntryCount = $snapshotRows.Count
        Entries = $snapshotRows
    }
    $parent = Split-Path -Parent $TargetPath
    if($parent -and -not (Test-Path -LiteralPath $parent)){New-Item -ItemType Directory -Path $parent -Force | Out-Null}
    $snapshot | ConvertTo-Json -Depth 6 | Out-File -LiteralPath $TargetPath -Encoding UTF8
    Write-Host ('Snapshot entries: ' + $snapshotRows.Count) -ForegroundColor Green
    Write-Host ('Snapshot file   : ' + $TargetPath) -ForegroundColor Green
}

'RegistryCompare' {
    if ([string]::IsNullOrWhiteSpace($TargetPath)) { throw 'Snapshot paths were not supplied.' }
    $parts = $TargetPath -split '\|',2
    if($parts.Count -ne 2){throw 'Two snapshot paths are required.'}
    $baselinePath=$parts[0]
    $comparisonPath=$parts[1]
    if(-not (Test-Path -LiteralPath $baselinePath)){throw 'Baseline snapshot not found.'}
    if(-not (Test-Path -LiteralPath $comparisonPath)){throw 'Comparison snapshot not found.'}

    $baseline = Get-Content -LiteralPath $baselinePath -Raw | ConvertFrom-Json
    $comparison = Get-Content -LiteralPath $comparisonPath -Raw | ConvertFrom-Json
    $before=@{};$after=@{}
    foreach($row in @($baseline.Entries)){$before[([string]$row.Key+'|'+[string]$row.Name)]=$row}
    foreach($row in @($comparison.Entries)){$after[([string]$row.Key+'|'+[string]$row.Name)]=$row}

    $allKeys=@($before.Keys + $after.Keys | Sort-Object -Unique)
    $changes=@()
    foreach($id in $allKeys){
        $b=$before[$id];$a=$after[$id]
        if($null -eq $b){
            $changes += [PSCustomObject]@{Change='Added';Key=$a.Key;Name=$a.Name;Before='';After=$a.Value;Assessment='Review'}
        }
        elseif($null -eq $a){
            $changes += [PSCustomObject]@{Change='Removed';Key=$b.Key;Name=$b.Name;Before=$b.Value;After='';Assessment='Review'}
        }
        elseif(([string]$b.Type -ne [string]$a.Type) -or ([string]$b.Value -ne [string]$a.Value)){
            $changes += [PSCustomObject]@{Change='Changed';Key=$a.Key;Name=$a.Name;Before=$b.Value;After=$a.Value;Assessment='Review'}
        }
    }

    $html=New-HtmlHeader 'Registry Snapshot Comparison' 'Differences between two targeted Raymond Endpoint Toolkit registry troubleshooting snapshots.'
    $summary=@(
        [PSCustomObject]@{Item='Baseline Computer';Value=$baseline.Computer;Assessment='Info'},
        [PSCustomObject]@{Item='Baseline Created';Value=$baseline.Created;Assessment='Info'},
        [PSCustomObject]@{Item='Comparison Computer';Value=$comparison.Computer;Assessment=if([string]$baseline.Computer -ne [string]$comparison.Computer){'Review'}else{'Info'}},
        [PSCustomObject]@{Item='Comparison Created';Value=$comparison.Created;Assessment='Info'},
        [PSCustomObject]@{Item='Changes';Value=$changes.Count;Assessment=if($changes.Count -gt 0){'Review'}else{'Good'}}
    )
    $html += Add-HtmlTable 'Comparison Summary' $summary ([ordered]@{Item='Item';Value='Value';Assessment='Assessment'})
    $html += Add-HtmlTable 'Registry Differences' $changes ([ordered]@{Change='Change';Key='Registry Key';Name='Value';Before='Before';After='After';Assessment='Assessment'}) 'No differences were detected in the targeted snapshot locations.'
    $html += '<p class="note">Snapshots cover selected troubleshooting locations, not the complete Windows registry. Changes can be caused by Windows, applications, Group Policy, Intune or user actions.</p>'
    $html += Close-HtmlReport
    Write-HtmlReport $html
}

'TempCleanup' {
    $cutoff = (Get-Date).AddHours(-48)
    $targets = @($env:TEMP, (Join-Path $env:WINDIR 'Temp')) | Where-Object {$_} | Select-Object -Unique
    $removedFiles = 0
    [int64]$removedBytes = 0
    foreach ($target in $targets) {
        if (-not (Test-Path -LiteralPath $target)) { continue }
        Write-Host ('Cleaning: ' + $target) -ForegroundColor Cyan
        foreach ($file in @(Get-ChildItem -LiteralPath $target -File -Force -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.LastWriteTime -lt $cutoff})) {
            try {
                $size = [int64]$file.Length
                Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
                $removedFiles++
                $removedBytes += $size
            }
            catch {}
        }
        foreach ($dir in @(Get-ChildItem -LiteralPath $target -Directory -Force -Recurse -ErrorAction SilentlyContinue | Sort-Object FullName -Descending)) {
            try { if (-not (Get-ChildItem -LiteralPath $dir.FullName -Force -ErrorAction Stop | Select-Object -First 1)) { Remove-Item -LiteralPath $dir.FullName -Force -ErrorAction Stop } } catch {}
        }
    }
    Write-Host
    Write-Host ('Removed files : ' + $removedFiles) -ForegroundColor Green
    Write-Host ('Space removed : ' + [math]::Round($removedBytes/1MB,2) + ' MB') -ForegroundColor Green
}

'OptimizeVolume' {
    $driveLetter = $env:SystemDrive.TrimEnd(':')
    Write-Host ('Optimizing ' + $env:SystemDrive + ' using Windows media-aware optimization...') -ForegroundColor Cyan
    Optimize-Volume -DriveLetter $driveLetter -Verbose -ErrorAction Stop
}

'UpdateServices' {
    foreach ($name in @('BITS','wuauserv','CryptSvc')) {
        Write-Host ('Restarting ' + $name + '...') -ForegroundColor Cyan
        try { Restart-Service -Name $name -Force -ErrorAction Stop; Write-Host '  OK' -ForegroundColor Green }
        catch { Write-Host ('  ' + $_.Exception.Message) -ForegroundColor Yellow }
    }
}

'UpdateReset' {
    $services = @('BITS','wuauserv','CryptSvc')
    foreach ($name in $services) { try { Stop-Service -Name $name -Force -ErrorAction SilentlyContinue } catch {} }
    Start-Sleep -Seconds 2
    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $softwareDistribution = Join-Path $env:WINDIR 'SoftwareDistribution'
    $catroot2 = Join-Path $env:WINDIR 'System32\catroot2'
    foreach ($folder in @($softwareDistribution,$catroot2)) {
        if (Test-Path -LiteralPath $folder) {
            $backup = $folder + '.bak_' + $stamp
            try {
                Move-Item -LiteralPath $folder -Destination $backup -Force -ErrorAction Stop
                Write-Host ('Renamed: ' + $folder) -ForegroundColor Green
                Write-Host ('Backup : ' + $backup) -ForegroundColor DarkGray
            }
            catch { Write-Host ('Could not rename ' + $folder + ': ' + $_.Exception.Message) -ForegroundColor Yellow }
        }
    }
    foreach ($name in @('CryptSvc','BITS','wuauserv')) {
        try { Start-Service -Name $name -ErrorAction SilentlyContinue } catch {}
    }
    Write-Host
    Write-Host 'Windows Update cache reset attempt completed.' -ForegroundColor Green
}

'ShellRestartExplorer' {
    Write-Host 'Restarting Windows Explorer...' -ForegroundColor Cyan
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    Start-Process explorer.exe
    Write-Host 'Windows Explorer restarted.' -ForegroundColor Green
}

'ShellRestartHosts' {
    Write-Host 'Restarting Start Menu and Shell Experience processes...' -ForegroundColor Cyan
    Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
    Stop-Process -Name ShellExperienceHost -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Write-Host 'Windows will automatically restart the shell host processes as needed.' -ForegroundColor Green
}

'ShellReregisterShell' {
    $packages = @(Get-AppxPackage Microsoft.Windows.ShellExperienceHost -ErrorAction SilentlyContinue)
    if ($packages.Count -eq 0) { throw 'ShellExperienceHost package was not found for the current user.' }
    foreach ($pkg in $packages) { Add-AppxPackage -DisableDevelopmentMode -Register (Join-Path $pkg.InstallLocation 'AppXManifest.xml') -ErrorAction Stop }
    Stop-Process -Name ShellExperienceHost -Force -ErrorAction SilentlyContinue
    Write-Host 'ShellExperienceHost re-registered.' -ForegroundColor Green
}

'ShellReregisterStart' {
    $packages = @(Get-AppxPackage Microsoft.Windows.StartMenuExperienceHost -ErrorAction SilentlyContinue)
    if ($packages.Count -eq 0) { throw 'StartMenuExperienceHost package was not found for the current user.' }
    foreach ($pkg in $packages) { Add-AppxPackage -DisableDevelopmentMode -Register (Join-Path $pkg.InstallLocation 'AppXManifest.xml') -ErrorAction Stop }
    Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
    Write-Host 'StartMenuExperienceHost re-registered.' -ForegroundColor Green
}

'ShellReregisterBoth' {
    foreach ($name in @('Microsoft.Windows.ShellExperienceHost','Microsoft.Windows.StartMenuExperienceHost')) {
        $packages = @(Get-AppxPackage $name -ErrorAction SilentlyContinue)
        if ($packages.Count -eq 0) { Write-Host ($name + ' was not found for the current user.') -ForegroundColor Yellow; continue }
        foreach ($pkg in $packages) {
            try { Add-AppxPackage -DisableDevelopmentMode -Register (Join-Path $pkg.InstallLocation 'AppXManifest.xml') -ErrorAction Stop; Write-Host ($name + ' re-registered.') -ForegroundColor Green }
            catch { Write-Host ($name + ': ' + $_.Exception.Message) -ForegroundColor Yellow }
        }
    }
    Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
    Stop-Process -Name ShellExperienceHost -Force -ErrorAction SilentlyContinue
}

}

if ($ReportPath -and $Mode -in @('Network','Performance','DiskHealth','Startup','Power','Profile','WinGetUpdates','RegistryHealth','RegistryExplorer','RegistryWindowsUpdate','RegistryNetwork','RegistryStartup','RegistrySecurity','RegistrySearch','RegistryCompare')) {
    if (-not (Test-Path -LiteralPath $ReportPath)) { throw 'Report file was not created.' }
}
exit 0
}
catch {
    Write-Host
    Write-Host 'Maintenance module failed:' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host
    exit 1
}
::PS_MAINTENANCE_END


:: ============================================================
:: OPEN LOG DIRECTORY
:: ============================================================

:OPENLOGS
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
start "" explorer.exe "%LOGDIR%"
goto MENU


:: ============================================================
:: REPORT TIMESTAMP HELPER
:: ============================================================

:NewReportTimestamp
for /f %%A in ('powershell.exe -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss-fff"') do set "REPORTSTAMP=%%A"
exit /b


:: ============================================================
:: LOGGING FUNCTION
:: ============================================================

:WriteLog
echo [%DATE% %TIME%] %~1 >> "%LOGFILE%"
exit /b


:: ============================================================
:: EXIT TOOLKIT
:: ============================================================

:EXITTOOLKIT
cls
echo ============================================================
echo EXIT RAYMOND ENDPOINT TOOLKIT
echo ============================================================
echo.
echo Closing toolkit...
echo.

call :WriteLog "Toolkit exited by user"

timeout /t 1 /nobreak >nul

endlocal
exit /b
