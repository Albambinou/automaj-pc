@echo off
cls
echo ============================================================
echo    PREPARATION DE L'ACTIVATION AUTO D'OFFICE
echo ============================================================
echo.

set "URL_MAS=https://raw.githubusercontent.com/Albambinou/automaj-pc/refs/heads/main/MAS_AIO.cmd"
set "TEMP_MAS=%TEMP%\MAS_AIO.cmd"

echo  -^> Recuperation des outils d'activation...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%URL_MAS%' -OutFile '%TEMP_MAS%'"

if not exist "%TEMP_MAS%" (
    echo [ERREUR] Impossible de recuperer les outils depuis GitHub.
    pause
    exit
)

echo  -^> Lancement de l'activation automatique d'Office (Ohook)...
echo.

:: MODIFICATION ICI : On ajoute le commutateur /ohk pour forcer l'option [2] en mode silencieux
call "%TEMP_MAS%" /ohk

:: Nettoyage du fichier temporaire
if exist "%TEMP_MAS%" del /f /q "%TEMP_MAS%"
exit
