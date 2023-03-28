@echo off

ECHO Checking if winget is installed
ECHO:
ECHO Current Winget version:
winget -v
ECHO:

SET WINGET=
SET /P "WINGET=Is winget installed (Y/N)? "
IF /I "%WINGET%"=="N" GOTO winget
if /I "%WINGET%"=="Y" GOTO cont

:winget
echo Installing Winget
(cd %temp% && curl "https://raw.githubusercontent.com/crazytil/msp-tools/main/installwinget.ps1" -o installwinget.ps1)
powershell -ExecutionPolicy Bypass -File %temp%\installwinget.ps1
goto cont


:cont
ECHO Installing default programs
ECHO:
winget install --id=Microsoft.Teams -e -h --accept-source-agreements  --accept-package-agreements 
winget install --id=Adobe.Acrobat.Reader.64-bit -e -h 
winget install --id=Oracle.JavaRuntimeEnvironment -e -h 
winget install --id=Google.Chrome -e -h 
winget install --id=7zip.7zip -e -h 
winget install --id=VideoLAN.VLC -e -h
ECHO:

SET OFFICE=
SET /P "OFFICE=Does Office 365 need to be installed (Y/N)? "
IF /I "%OFFICE%"=="Y" GOTO Office
IF /I "%OFFICE%"=="N" GOTO EOF

:Office
ECHO Installing Office 365
(cd %temp% && curl "https://raw.githubusercontent.com/crazytil/msp-tools/main/installwinget.ps1" -o installwinget.ps1)

goto :EOF

:EOF
Echo All done!
PAUSE