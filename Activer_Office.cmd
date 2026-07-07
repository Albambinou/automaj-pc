@echo off
cls
echo ============================================================
echo    PREPARATION DE L'ACTIVATION AUTO D'OFFICE (DIAGNOSTIC)
echo ============================================================
echo.

:: URL Azure DevOps
set "URL_MAS=https://dev.azure.com/massgrave/Microsoft-Activation-Scripts/_apis/git/repositories/Microsoft-Activation-Scripts/items?path=/MAS/All-In-One-Version-KL/MAS_AIO.cmd&versionType=Commit&version=05c4f881efec946c0040cdd552d1afa9a519704b"
set "TEMP_MAS=%TEMP%\MAS_AIO.cmd"

echo  -^> Recuperation des outils officiels depuis Azure...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%URL_MAS%' -OutFile '%TEMP_MAS%'"

if not exist "%TEMP_MAS%" (
    echo.
    echo [ERREUR] Le telechargement a echoue ou le fichier n'a pas pu etre cree.
    echo Verifie ta connexion internet ou si ton antivirus bloque PowerShell.
    echo.
    pause
    exit
)

echo  -^> Lancement de l'activation automatique d'Office (Ohook)...
echo.

:: Lance l'outil officiel
call "%TEMP_MAS%" /ohk

echo.
echo  -^> Nettoyage...
if exist "%TEMP_MAS%" del /f /q "%TEMP_MAS%"

echo.
echo Processus termine.
pause
exit
