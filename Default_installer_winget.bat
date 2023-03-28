@echo off

ECHO Checking if winget is installed
ECHO:
ECHO Current Winget version:
winget -v
ECHO:


SET WINGET=
SET /P "WINGET=Is winget installed (Y/N)? "
IF /I "%WINGET%"=="N" GOTO winget

:Prompt
CLS
ECHO:
ECHO:
ECHO 1. Install all apps
ECHO 2. Install default apps (Exclude Office 365)
ECHO 3. Install Office 365
ECHO 4. Install Office 365
SET INSTALL=
SET /P "INSTALL=Select option (1-4)? "
IF /I "%INSTALL%"=="1" GOTO Default_Apps
if /I "%INSTALL%"=="2" GOTO Default_Apps
if /I "%INSTALL%"=="3" GOTO Office
if /I "%INSTALL%"=="4" GOTO Updater
GOTO Prompt




:winget
echo Installing Winget
(cd %temp% && curl "https://raw.githubusercontent.com/crazytil/msp-tools/main/installwinget.ps1" -o installwinget.ps1)
powershell -ExecutionPolicy Bypass -File %temp%\installwinget.ps1
goto Prompt


:Default_Apps
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
GOTO :EOF


:Office
ECHO Installing Office 365
(cd %temp% && curl "https://raw.githubusercontent.com/crazytil/msp-tools/main/O365/setup.exe" -o setup.exe)
(cd %temp% && curl "https://raw.githubusercontent.com/crazytil/msp-tools/main/O365/Configuration.xml" -o config.xml)
%temp%\setup.exe /configure %temp%\config.xml
GOTO :EOF

:EOF
Echo All done!
PAUSE