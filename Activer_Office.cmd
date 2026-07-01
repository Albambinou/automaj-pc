@echo off
cls
echo ============================================================
echo   PREPARATION DE L'ACTIVATION VIA GITHUB
echo ============================================================
echo.

:: 1. Définition du lien RAW vers ton fichier MAS_AIO.cmd sur GitHub
:: (Pense à remplacer VOTRE_PSEUDO et VOTRE_DEPOT par tes vraies infos)
set "URL_MAS=https://raw.githubusercontent.com/Albambinou/automaj-pc/refs/heads/main/MAS_AIO.cmd"
set "TEMP_MAS=%TEMP%\MAS_AIO.cmd"

echo  -^> Recuperation des outils d'activation...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%URL_MAS%' -OutFile '%TEMP_MAS%'"

if not exist "%TEMP_MAS%" (
    echo [ERREUR] Impossible de recuperer les outils depuis GitHub.
    pause
    exit
)

echo  -^> Lancement de l'activation...
echo.

:: 2. On lance le fichier MAS_AIO.cmd qui a été téléchargé dans les fichiers temporaires
call "%TEMP_MAS%"

:: 3. Nettoyage du fichier temporaire après la fermeture
if exist "%TEMP_MAS%" del /f /q "%TEMP_MAS%"
exit
