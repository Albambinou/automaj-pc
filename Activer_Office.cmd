@echo off
:: Vérification des privilèges administrateur
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Veuillez executer ce script en tant qu'Administrateur.
    pause
    exit /b
)

echo Activation de Microsoft Office en cours...
echo Utilisation du fichier MAS_AIO.cmd local...

:: Vérification de la présence du fichier MAS dans le même dossier
if not exist "%~dp0MAS_AIO.cmd" (
    echo.
    echo [ERREUR] Le fichier MAS_AIO.cmd est introuvable dans ce dossier.
    echo Assurez-vous que 'MAS_AIO.cmd' et ce script soient dans le meme repertoire.
    pause
    exit /b
)

:: Exécution locale avec l'argument Ohook pour Office
call "%~dp0MAS_AIO.cmd" /ohook

echo.
echo Processus termine ! Verifiez le statut dans votre application Office (Fichier - Compte).
pause