@echo off
cls
echo ============================================================
echo    PREPARATION DE L'ACTIVATION AUTO D'OFFICE (FORCE)
echo ============================================================
echo.

set "URL_MAS=https://raw.githubusercontent.com/Albambinou/automaj-pc/refs/heads/main/MAS_AIO.cmd"
set "TEMP_MAS=%TEMP%\MAS_AIO.cmd"

echo  -^> Recuperation de ton script depuis GitHub...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%URL_MAS%' -OutFile '%TEMP_MAS%'"

if not exist "%TEMP_MAS%" (
    echo [ERREUR] Impossible de recuperer le fichier depuis GitHub.
    pause
    exit
)

echo  -^> Lancement de l'activation automatique d'Office...
echo.

:: On utilise START /WAIT pour forcer le script initial à attendre la fin du processus de MAS
start /wait "" "%TEMP_MAS%" /Ohook

echo.
echo  -^> Nettoyage...
if exist "%TEMP_MAS%" del /f /q "%TEMP_MAS%"

echo.
echo Processus termine.
pause
exit
