@echo off
TITLE Default setup rollout script
GOTO check_Permissions

:check_Permissions
    ECHO:
    ECHO Checking for administrative permissions...
    ECHO:
    TIMEOUT 2 >nul

    
    NET SESSION >nul 2>&1
    IF %errorLevel% == 0 (
        ECHO Administrative permissions confirmed
        TIMEOUT 3 >nul
        GOTO Winget_check
    ) ELSE (
        ECHO Current permissions inadequate
        ECHO:
        ECHO Restarting file as administrator
        ECHO:
        PAUSE
        powershell Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
        EXIT /b
    )


:Winget_check
CLS
ECHO:
ECHO Checking if winget is installed
ECHO:
ECHO Current Winget version:
winget -v
ECHO:

:Winget_test
SET WINGET=
SET /P "WINGET=Is winget installed (Y/n)? "
IF /I "%WINGET%"=="N" GOTO winget
IF /I "%WINGET%"=="Y" GOTO Question
goto Question

:Question
CLS
ECHO:
ECHO:
ECHO 1. Install all apps
ECHO 2. Install default apps (Exclude Office 365)
ECHO 3. Install Office 365
ECHO 4. Run Winget Updates
ECHO X. Exit
SET INSTALL=
SET /P "INSTALL=Select option (1-4,X)? "
IF /I "%INSTALL%"=="1" GOTO Default_Apps
if /I "%INSTALL%"=="2" GOTO Default_Apps
if /I "%INSTALL%"=="3" GOTO Office
if /I "%INSTALL%"=="4" GOTO Updater
if /I "%INSTALL%"=="X" GOTO EOF
GOTO Question


:winget
CLS
ECHO:
ECHO Installing Winget
ECHO:
(cd %temp% && curl "https://raw.githubusercontent.com/crazytil/msp-tools/main/installwinget.ps1" -o installwinget.ps1)
powershell -ExecutionPolicy Bypass -File %temp%\installwinget.ps1
GOTO Question


:Default_Apps
CLS
ECHO:
ECHO Installing default programs
ECHO:
winget install --id=Microsoft.Teams -e -h --accept-source-agreements  --accept-package-agreements 
winget install --id=Adobe.Acrobat.Reader.64-bit -e -h 
winget install --id=Oracle.JavaRuntimeEnvironment -e -h 
winget install --id=Google.Chrome -e -h 
winget install --id=7zip.7zip -e -h 
winget install --id=VideoLAN.VLC -e -h
if /I "%INSTALL%"=="1" GOTO Office
ECHO:
GOTO Question


:Office
CLS
ECHO:
ECHO Installing Office 365
ECHO:
(cd %temp% && curl "https://raw.githubusercontent.com/crazytil/msp-tools/main/O365/setup.exe" -o setup.exe)
(cd %temp% && curl "https://raw.githubusercontent.com/crazytil/msp-tools/main/O365/Configuration.xml" -o config.xml)
%temp%\setup.exe /configure %temp%\config.xml
GOTO Question


:Updater
CLS
ECHO:
ECHO Updating apps using Winget
ECHO:
winget upgrade --all -h
GOTO Question


:EOF
ECHO All done!
ECHO Press any key to exit . . .
PAUSE >nul