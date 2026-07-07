@::Veuillez cesser de signaler ce script comme faux positif à répétition. C'est la troisième fois que je dois le mettre à jour pour corriger ces faux positifs.
@::Ce script ne contient rien de malveillant et il est utilisé quotidiennement par des milliers de personnes.
Est-ce qu'une vraie personne décide de signaler ceci ou est-ce que Copilot a reçu l'ordre de signaler tout ce qui lui déplaît ?
Si une campagne utilise ce script comme couverture, veuillez signaler des parties de la campagne plutôt que le script lui-même. Ce n'est pas la première fois que nous subissons des dommages collatéraux à cause de campagnes qui ne nous sont absolument pas liées.
Si vous contestez le caractère malveillant de MAS, nous vous serions reconnaissants de bien vouloir nous contacter afin de nous expliquer en quoi MAS est considéré comme « Sonbokli », et nous examinerons la question. Merci.
@set masver=3.12
@setlocal DésactiverExpansionDélai
@echo désactivé



Pour les options de ligne de commande, consultez m{}assgrave{dot}dev/command_line_switches
:: Si vous souhaitez mieux comprendre le script, consultez la version dans les fichiers séparés.



:===============================================================================
::
:: Page d'accueil : m{}assgrave{dot}dev
::
:===============================================================================



:=================================================================================================================================================

Définissez les variables d'environnement ; cela peut être utile si elles sont mal configurées dans le système.

setlocal EnableExtensions
setlocal DésactiverExpansionDélai

définir "PathExt=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC"

définir "SysPath=%SystemRoot%\System32"
définir "Path=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\"
si le fichier "%SystemRoot%\Sysnative\reg.exe" existe (
définir "SysPath=%SystemRoot%\Sysnative"
définir "Path=%SystemRoot%\Sysnative;%SystemRoot%;%SystemRoot%\Sysnative\Wbem;%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\;%Path%"
)

définir "ComSpec=%SysPath%\cmd.exe"
définir "PSModulePath=%ProgramFiles%\WindowsPowerShell\Modules;%SysPath%\WindowsPowerShell\v1.0\Modules"

cd /d "%SysPath%"

:: Solution de contournement pour https://github.com/microsoft/terminal/issues/15212, lorsque %0 commence par un guillemet, l'expansion du paramètre %0 n'est pas traitée de manière spéciale.
:: Remplacer %0 par une valeur qui n'est pas entre guillemets permet de contourner le problème.
aller à arg_workaround_end
:arg_workaround
définir "_cmdf=%~f0"
quitter /b
:arg_workaround_end

appel :arg_workaround

définir re1=
définir re2=
pour %%# dans (%*) faire (
si /i "%%#"="re1" définir re1=1
si /i "%%#"="re2" définir re2=1
si /i "%%#"=="-qedit" (set re1=1&set re2=1)
)

Relancez le script avec un processus x64 s'il a été lancé par un processus x86 sous Windows 64 bits.
:: ou avec un processus ARM64 s'il a été initié par un processus x86/ARM32 sur Windows ARM64

si %SystemRoot%\Sysnative\cmd.exe existe, si re1 n'est pas défini (
setlocal EnableDelayedExpansion
démarrer %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" %* re1"
quitter /b
)

Relancez le script avec le processus ARM32 s'il a été lancé par un processus x64 sur Windows ARM64.

si %SystemRoot%\SysArm32\cmd.exe existe si %PROCESSOR_ARCHITECTURE%==AMD64 si non défini re2 (
setlocal EnableDelayedExpansion
démarrer %SystemRoot%\SysArm32\cmd.exe /c ""!_cmdf!" %* re2"
quitter /b
)

:=================================================================================================================================================

définir "blank="
définir "mas=ht%blank%tps%blank%://m%blank%ass%blank%grave.dev/"
définir "github=ht%blank%tps%blank%://github.com/m%blank%assgra%blank%vel/Micro%blank%soft-Acti%blank%vation-Scripts"
définir "selfgit=ht%blank%tps%blank%://git.acti%blank%vated.win/Micr%blank%osoft-Act%blank%ivation-Scripts"

:: Vérifiez si le service Null fonctionne, c'est important pour le script batch

sc query Null | find /i "RUNNING"
si %errorlevel% NEQ 0 (
écho:
Le service Null n'est pas en cours d'exécution, le script risque de planter...
écho:
écho:
echo Consultez cette page Web pour obtenir de l'aide - %mas%fix_service
écho:
écho:
ping 127.0.0.1 -n 20
)
cls

:: Vérifier la fin de la ligne LF

>nul findstr /v "$" "%_cmdf%" && (
écho:
echo Erreur - Le script présente soit un problème de fin de ligne LF, soit une ligne vide est manquante à la fin du script.
écho:
écho:
echo Consultez cette page Web pour obtenir de l'aide - %mas%troubleshoot
écho:
écho:
ping 127.0.0.1 -n 20 >nul
quitter /b
)

:=================================================================================================================================================

cls
couleur 07
titre Scripts d'activation Microsoft %masver%

définir _args=
définir _elev=
définir _unattended=0

définir _args=%*
si _args est défini, définissez _args=%_args:"=%
si _args est défini, définir _args=%_args:re1=%
si _args est défini, définir _args=%_args:re2=%
si défini _args (
pour %%A dans (%_args%) faire (
si /i "%%A"="-el" définir _elev=1
)
)

si _args est défini, afficher "%_args%" | trouver /i "/" >nul && définir _unattended=1

:=================================================================================================================================================

définir "nul1=1>nul"
définir "nul2=2>nul"
définir "nul6=2^>nul"
définir "nul=>nul 2>&1"

appel :dk_setvar

si %winbuild% EQU 1 (
%eline%
Échec de la détection du numéro de build Windows.
écho:
setlocal EnableDelayedExpansion
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)

si le compte "%Systemdrive%\Users\WDAGUtilityAccount" existe (
sc query gcs | find /i "RUNNING" %nul% && (
%eline%
Écoutez, Windows Sandbox a été détecté ; l’activation n’est pas prise en charge.
Le script ne peut pas s'exécuter en raison de composants de licence manquants. Abandon…
écho:
aller à dk_done
)
)

si %winbuild% LSS 6001 (
%nceline%
echo Version du système d'exploitation non prise en charge détectée [%winbuild%].
echo MAS ne prend en charge que Windows Vista/7/8/8.1/10/11 et leurs équivalents serveur.
si %winbuild% est égal à 6000 (
écho:
Windows Vista RTM n'est pas pris en charge car PowerShell ne peut pas être installé.
Mise à jour vers Windows Vista SP1 ou SP2.
)
aller à dk_done
)

si %winbuild% LSS 7600 si n'existe pas "%SysPath%\WindowsPowerShell\v1.0\Modules" (
%nceline%
si %ps% n'existe pas (
PowerShell n'est pas installé sur votre système.
)
echo Installez PowerShell 2.0 en utilisant l'URL suivante.
écho:
Afficher https://www.catalog.update.microsoft.com/Search.aspx?q=KB968930
Si %_unattended%==0, démarrer https://www.catalog.update.microsoft.com/Search.aspx?q=KB968930
aller à dk_done
)

:=================================================================================================================================================

:: Correction des limitations de caractères spéciaux dans les noms de chemin

définir "_work=%~dp0"
si "%_work:~-1%"="\" définir "_work=%_work:~0,-1%"

définir "_batp=%_cmdf:'=''%"

définir _PSarg="""%_cmdf%""" -el %_args%
définir _PSarg=%_PSarg:'=''%

définir "_ttemp=%userprofile%\AppData\Local\Temp"

setlocal EnableDelayedExpansion

:=================================================================================================================================================

echo "!_cmdf!" | find /i "!_ttemp!" %nul1% && (
si /i n'est pas "!_work!"=="!_ttemp!" (
%eline%
echo Le script a été lancé depuis le dossier temporaire.
Vous exécutez très probablement le script directement depuis le fichier d'archive.
écho:
echo Extrayez le fichier d'archive et lancez le script depuis le dossier extrait.
aller à dk_done
)
)

:=================================================================================================================================================

:: Exécuter le script en tant qu'administrateur, transmettre les arguments et éviter les boucles

%nul1% fltmc || (
if not defined _elev %psc% "start cmd.exe -arg '/c \"!_PSarg!\"' -verb runas" && exit /b
%eline%
echo Ce script nécessite des droits d'administrateur.
echo Faites un clic droit sur ce script et sélectionnez « Exécuter en tant qu'administrateur ».
aller à dk_done
)

:=================================================================================================================================================

:: Vérifier PowerShell

::pstst $ExecutionContext.SessionState.LanguageMode :pstst

for /f "delims=" %%a in ('%psc% "if ($PSVersionTable.PSEdition -ne 'Core') {$f=[IO.File]::ReadAllText('!_batp!') -split ':pstst';. ([scriptblock]::Create($f[1]))}" %nul6%') do (set tstresult=%%a)

si /i n'est pas "%tstresult%"="FullLanguage" (
%eline%
for /f "delims=" %%a in ('%psc% "$ExecutionContext.SessionState.LanguageMode" %nul6%') do (set tstresult2=%%a)
echo Test 1 - %tstresult%
echo Test 2 - !tstresult2!
écho:

REM vérifier le mode de langue

echo: !tstresult2! | findstr /i "ConstrainedLanguage RestrictedLanguage NoLanguage" %nul1% && (
Mode FullLanguage introuvable dans PowerShell. Abandon…
Si vous avez appliqué des restrictions à PowerShell, annulez ces modifications.
définir les correctifs=%fixes% %mas%fix_powershell
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%fix_powershell"
aller à dk_done
)

REM vérifier la version du noyau PowerShell

cmd /c "%psc% "$PSVersionTable.PSEdition"" | find /i "Core" %nul1% && (
Windows PowerShell est nécessaire pour MAS, mais il semble avoir été remplacé par PowerShell Core. Abandon…
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
aller à dk_done
)

REM vérifie la présence de logiciels malveillants susceptibles de causer des problèmes avec PowerShell.

pour /r "%ProgramFiles%\" %%f dans (secureboot.exe) faire si existe "%%f" (
écho "%%f"
echo Logiciel malveillant détecté, PowerShell ne fonctionne pas correctement.
définir les correctifs=%fixes% %mas%supprimer_mal%w%ware
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%remove_mal%w%ware"
aller à dk_done
)

REM vérifier si .NET fonctionne correctement

si /i "!tstresult2!"=="FullLanguage" (
cmd /c "%psc% ""try {[System.AppDomain]::CurrentDomain.GetAssemblies(); [System.Math]::Sqrt(144)} catch {Exit 3}""" %nul%
si !errorlevel!==3 (
Windows PowerShell n'a pas pu charger la commande .NET. Abandon…
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
aller à dk_done
)
)

REM vérifie l'antivirus et autres erreurs

PowerShell ne fonctionne pas correctement. Abandon…

si /i "!tstresult2!"=="FullLanguage" (
écho:
Votre logiciel antivirus bloque peut-être le script.
écho:
sc query sense | find /i "RUNNING" %nul% && (
écho Antivirus installé - Microsoft Defender pour Endpoint
)
cmd /c "%psc% ""$av = Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct; $n = @(); foreach ($i in $av) { $n += $i.displayName }; if ($n) { Write-Host ('Antivirus installé - ' + ($n -join ', '))}"""
)

définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)

:=================================================================================================================================================

Désactivez QuickEdit et lancez le programme depuis conhost.exe pour éviter d'utiliser l'application Terminal.

si %winbuild% GEQ 17763 (
définir terminal=1
) autre (
définir le terminal=
)

:: Vérifier si le script est en cours d'exécution dans l'application Terminal

si terminal défini (
définir lignes=0
pour /f "skip=3 tokens=* delims=" %%A dans ('mode con') faire si "!lines!"=="0" (
pour %%B dans (%%A) faire définir lignes=%%B
)
si !lignes! GEQ 100 définir terminal=
)

si %_unattended%==1 aller à :skipQE
pour %%# dans (%_args%) faire (si /i "%%#"=="-qedit" aller à :skipQE)

:: Relancez l'application pour désactiver QuickEdit dans la session actuelle et utiliser conhost.exe au lieu de l'application Terminal.
Ce code désactive QuickEdit pour la session cmd.exe en cours sans modifier définitivement le registre.
:: Ceci est inclus car cliquer sur la fenêtre du script peut interrompre l'exécution, ce qui peut prêter à confusion et laisser croire que le script s'est arrêté en raison d'une erreur.

définir resetQE=1
reg query HKCU\Console /v QuickEdit %nul2% | find /i "0x0" %nul1% && set resetQE=0
reg add HKCU\Console /v QuickEdit /t REG_DWORD /d 0 /f %nul1%

si terminal défini (
démarrer conhost.exe "!_cmdf!" %_args% -qedit
démarrer l'ajout de registre HKCU\Console /v QuickEdit /t REG_DWORD /d %resetQE% /f %nul1%
quitter /b
) sinon si %resetQE% EQU 1 (
démarrer cmd.exe /c ""!_cmdf!" %_args% -qedit"
démarrer l'ajout de registre HKCU\Console /v QuickEdit /t REG_DWORD /d %resetQE% /f %nul1%
quitter /b
)

:skipQE

:=================================================================================================================================================

:: Vérifier les mises à jour

ensemble -=
définir ancien=
définir pingp=
définir upver=%masver:.=%

pour %%A dans (
activ%-%ated.win
masse%-%grave.dev
) faire si pingp n'est pas défini (
pour /f "delims=[] tokens=2" %%B dans ('ping -n 1 %%A') faire (
si ce n'est pas "%%B"="" (définir old=1& définir pingp=1)
pour /f "delims=[] tokens=2" %%C dans ('ping -n 1 updatecheck%upver%.%%A') faire (
si non "%%C"="" définir ancien=
)
)
)

si défini ancien (
écho ________________________________________________
%eline%
echo Votre version de MAS [%masver%] est obsolète.
écho ________________________________________________
écho:
si %_unattended% n'est pas égal à 1 (
echo [1] Obtenir le dernier MAS
echo [0] Continuer quand même
écho:
appel :dk_color %_Green% "Choisissez une option de menu à l'aide de votre clavier [1,0] :"
choix /C:10 /N
si !errorlevel!==2 rem
if !errorlevel!==1 (start %selfgit% & start %github% & start %mas% & exit /b)
)
)

:=================================================================================================================================================

if not exist "%SystemRoot%\Temp\" mkdir "%SystemRoot%\Temp" %nul%

:: Exécuter un script avec des paramètres en mode sans surveillance

définir _elev=
si _args est défini echo "%_args%" | find /i "/S" %nul% && (set "_silent=%nul%") || (set _silent=)
si _args est défini echo "%_args%" | find /i "/" %nul% && (
echo "%_args%" | find /i "/HWID" %nul% && (setlocal & cls & (call :HWIDActivation %_args% %_silent%) & endlocal)
echo "%_args%" | find /i "/Z-" %nul% && (setlocal & cls & (call :TSforgeActivation %_args% %_silent%) & endlocal)
echo "%_args%" | find /i "/K-" %nul% && (setlocal & cls & (call :KMSActivation %_args% %_silent%) & endlocal)
echo "%_args%" | find /i "/Ohook" %nul% && (setlocal & cls & (call :OhookActivation %_args% %_silent%) & endlocal)
quitter /b
)

:=================================================================================================================================================

setlocal DésactiverExpansionDélai

:: Vérifier l'emplacement du bureau

définir le bureau=
for /f "skip=2 tokens=2*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop') do call set "desktop=%%b"
si le bureau n'est pas défini pour /f "delims=" %%a dans ('%psc% "& {write-host $([Environment]::GetFolderPath('Desktop'))}"') do call set "desktop=%%a"
définir "_pdesk=%desktop:'=''%"

setlocal EnableDelayedExpansion

si non défini bureau (
%eline%
Impossible de détecter l'emplacement du bureau, abandon...
aller à dk_done
)

:=================================================================================================================================================

:Menu principal

cls
couleur 07
titre Microsoft %blank%Activation %blank%Scripts %masver%
si le mode terminal n'est pas défini, 76, 34

si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum" existe, définissez _serexist=1
Si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-*EvalEdition~*.mum" existe, définissez _evalexist=1
si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-EnterpriseS*dition~*.mum" existe, définissez _ltscexist=1
si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-EnterpriseSN*dition~*.mum" existe, définissez _ltscnexist=1

si %winbuild% GEQ 10240 si non défini _serexist si non défini _evalexist définir _hwidgo=1
si %winbuild% GTR 14393 si défini _ltscnexist définir _hwidgo=
si _hwidgo n'est pas défini, définir _tsforgego=1

définir _ohookgo=1
si %winbuild% GEQ 9200 (
si %winbuild% LSS 10240 définir _ohookgo=
si %winbuild% GEQ 19041 si %winbuild% LEQ 19045 définir _ohookgo=
si _serexist est défini, définir _ohookgo=
si _evalexist est défini, définir _ohookgo=
si _ltscexist est défini, définir _ohookgo=
reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration /v ProductReleaseIds %nul2% | find /i "O365" %nul% && set _ohookgo=1
reg query HKLM\SOFTWARE\Wow6432Node\Microsoft\Office\ClickToRun\Configuration /v ProductReleaseIds %nul2% | find /i "O365" %nul% && set _ohookgo=1
)
si _ohookgo n'est pas défini, définir _tsforgego=1

écho:
écho:
écho:
si %winbuild% GEQ 10240 si %winbuild% LEQ 19045 si non défini _serexist si non défini _evalexist si non défini _ltscexist (
appel :dk_color2 %_Green% " Conseil :" %_White% " Pour activer les mises à jour ESU après la fin de vie de W10, utilisez l'option TSforge."
)
écho:
écho:
écho : ______________________________________________________________
écho:
echo : Méthodes d'activation :
écho:
si défini _hwidgo (
appel :dk_color3 %_Blanc% " [1] " %_Vert% "HWID" %_Blanc% " - Windows"
) autre (
echo : [1] HWID - Windows
)
si défini _ohookgo (
appel :dk_color3 %_Blanc% " [2] " %_Vert% "Ohook" %_Blanc% " - Bureau"
) autre (
écho : [2] Ohook - Bureau
)
si défini _tsforgego (
appel :dk_color3 %_Blanc% " [3] " %_Vert% "TSforge" %_Blanc% " - Windows / Office / ESU"
) autre (
echo: [3] TSforge - Windows / Office / ESU
)
echo: [4] KMS en ligne - Windows / Office
écho : __________________________________________________
écho:
echo : [5] Vérifier l’état d’activation
echo: [6] Changer d'édition Windows
echo: [7] Changer d'édition Office
écho : __________________________________________________      
écho:
écho : [8] Dépannage
écho : [E] Extras
echo: [H] Aide
echo: [0] Sortie
écho : ______________________________________________________________
écho:
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier [1,2,3...E,H,0] :"
choix /C:12345678EH0 /N
définir _erl=%errorlevel%

si %_erl%==11 quitter /b
si %_erl%==10 (démarrer %selfgit% & démarrer %github% & démarrer %mas%troubleshoot & aller à :MainMenu)
si %_erl%==9 aller à :Extras
if %_erl%==8 setlocal & call :troubleshoot & cls & endlocal & goto :MainMenu
if %_erl%==7 setlocal & call :change_offedition & cls & endlocal & goto :MainMenu
si %_erl%==6 setlocal & call :change_winedition & cls & endlocal & goto :MainMenu
if %_erl%==5 setlocal & call :check_actstatus & cls & endlocal & goto :MainMenu
if %_erl%==4 setlocal & call :KMSActivation & cls & endlocal & goto :MainMenu
if %_erl%==3 setlocal & call :TSforgeActivation & cls & endlocal & goto :MainMenu
if %_erl%==2 setlocal & call :OhookActivation & cls & endlocal & goto :MainMenu
if %_erl%==1 setlocal & call :HWIDActivation & cls & endlocal & goto :MainMenu
aller à : Menu principal

:dk_color3

si %_NCS% est égal à 1 (
écho %esc%[%~1%~2%esc%[%~3%~4%esc%[%~5%~6%esc%[0m
) autre (
%psc% write-host -back '%1' -fore '%2' '%3' -NoNewline; write-host -back '%4' -fore '%5' '%6'-NoNewline; write-host -back '%7' -fore '%8' '%9'
)
quitter /b

:=================================================================================================================================================

:Extras

cls
titres Extras
si le mode terminal n'est pas défini, 76, 30
écho:
écho:
écho:
écho:
écho:
écho : ______________________________________________________
écho:           
echo: [1] Extraire le dossier $OEM$
écho:                  
echo: [2] Télécharger Windows/Office authentique
écho : ____________________________________________      
écho:                                                                          
echo: [0] Aller au menu principal
écho : ______________________________________________________
écho:
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier [1,2,0] :"
choix /C:120 /N
définir _erl=%errorlevel%

si %_erl%==3 aller à :Menu principal
si %_erl%==2 démarrer %mas%genuine-installation-media & aller à :Extras
si %_erl%==1 aller à :Extraire$OEM$
Aller à : Extras

:=================================================================================================================================================

:Extraire$OEM$

cls
Titre : Extraire le dossier $OEM$
si le mode terminal n'est pas défini, 76, 30

si existe "!desktop!\$OEM$\" (
%eline%
echo Le dossier $OEM$ existe déjà sur le Bureau.
écho _____________________________________________________
écho:
appel :dk_color %_Yellow% "Appuyez sur la touche [0] pour %_exitmsg%..."
choix /c 0 /n
Aller à : Extras
)

:Extraire$OEM$2

cls
Titre : Extraire le dossier $OEM$
si le mode terminal n'est pas défini, 78, 30
écho:
écho:
écho:
écho:
echo: Extraire le dossier $OEM$ sur le bureau           
écho : ____________________________________________________________
écho:
écho : [1] HWID [Windows]
écho : [2] Ohook [Bureau]
echo: [3] TSforge [Windows / ESU / Office]
écho : [4] KMS en ligne [Windows / Office]
écho:
écho : [5] HWID [Windows] ^+ Ohook [Office]
echo: [6] HWID [Windows] ^+ Ohook [Office] ^+ TSforge [ESU]
echo: [7] TSforge [Windows / ESU] ^+ Ohook [Office]
écho:
appel :dk_color2 %_Blanc% " [R] " %_Vert% "Lisez-moi"
echo: [0] Retour
écho : ____________________________________________________________
écho:  
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier :"
choix /C:1234567R0 /N
définir _erl=%errorlevel%

si %_erl%==9 aller à:Extras
si %_erl%==8 démarrer %mas%oem-folder &goto:Extract$OEM$2
si %_erl%==7 (définir "_oem=TSforge [Windows / ESU] + Ohook [Office]" & définir "para=/Z-Windows /Z-ESU /Ohook" & aller à:Extract$OEM$3)
si %_erl%==6 (définir "_oem=HWID [Windows] + Ohook [Office] + TSforge [ESU]" & définir "para=/HWID /Ohook /Z-ESU" & aller à:Extract$OEM$3)
si %_erl%==5 (définir "_oem=HWID [Windows] + Ohook [Office]" & définir "para=/HWID /Ohook" & aller à:Extract$OEM$3)
si %_erl%==4 (définir "_oem=Online KMS" & définir "para=/K-WindowsOffice" &goto:Extract$OEM$3)
si %_erl%==3 (définir "_oem=TSforge" & définir "para=/Z-WindowsESUOffice" & aller à:Extract$OEM$3)
si %_erl%==2 (définir "_oem=Ohook" & définir "para=/Ohook" & aller à:Extract$OEM$3)
si %_erl%==1 (définir "_oem=HWID" & définir "para=/HWID" & aller à:Extraire$OEM$3)
aller à :Extraire$OEM$2

:=================================================================================================================================================

:Extraire$OEM$3

cls
définir "_dir=!desktop!\$OEM$\$$\Setup\Scripts"
md "!_dir!\"

:: Ajouter des données aléatoires en haut pour créer un fichier unique, ce qui permet d'éviter la détection par les antivirus.
%psc% "$f=[IO.File]::ReadAllText('!_batp!'); [io.file]::WriteAllText('!_pdesk!\$OEM$\$$\Setup\Scripts\MAS_AIO.cmd', '@::RANDOM-' + [Guid]::NewGuid().Guid + [Environment]::NewLine + $f, [System.Text.Encoding]::ASCII)"

(
echo @echo off
echo fltmc ^>nul ^|^| exit /b
appel d'écho "%%~dp0MAS_AIO.cmd" %para%
echo cd \
echo ^(goto^) 2^>nul ^& ^(if "%%~dp0"=="%%SystemRoot%%\Setup\Scripts\" rd /s /q "%%~dp0"^)
)>"!_dir!\SetupComplete.cmd"

définir _erreur=
Si le fichier «!_dir!\MAS_AIO.cmd» n'existe pas, définir _error=1
Si le fichier « !_dir!\SetupComplete.cmd » n'existe pas, définir _error=1

si défini _erreur (
%eline%
echo Le script n'a pas pu créer le dossier $OEM$.
si le répertoire «!desktop!\$OEM$\.*» existe, supprimez-le avec la commande `rmdir /s /q "!desktop!\$OEM$\" %nul%`.
) autre (
écho:
appel :dk_color %Bleu% "%_oem%"
appel :dk_color %Green% "Le dossier $OEM$ a été créé avec succès sur votre Bureau."
)
écho ___________________________________________________________________
écho:
appel :dk_color %_Yellow% "Appuyez sur la touche [0] pour %_exitmsg%..."
choix /c 0 /n
Aller aux extras

:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:Activation HWID

Pour activer, exécutez le script avec le paramètre « /HWID » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _act=0

Pour désactiver le changement d'édition si l'édition actuelle ne prend pas en charge l'activation HWID, remplacez la valeur 0 par 1 ou exécutez le script avec le paramètre « /HWID-NoEditionChange ».
définir _NoEditionChange=0

Si une valeur est modifiée dans les lignes ci-dessus ou si un paramètre est utilisé, le script s'exécutera en mode sans surveillance.

:=================================================================================================================================================

cls
couleur 07
Activation HWID %masver%

définir _args=
définir _elev=
définir _unattended=0

définir _args=%*
si _args est défini, définissez _args=%_args:"=%
si défini _args (
pour %%A dans (%_args%) faire (
si /i "%%A"="/HWID" définir _act=1
si /i "%%A"="/HWID-NoEditionChange" définir _NoEditionChange=1
si /i "%%A"="-el" définir _elev=1
)
)

pour %%A dans (%_act% %_NoEditionChange%) faire (si "%%A"=="1" définir _unattended=1)

:=================================================================================================================================================

si %winbuild% LSS 10240 (
%eline%
echo Version du système d'exploitation non prise en charge détectée [%winbuild%].
L'activation HWID d'echo n'est prise en charge que sous Windows 10/11.
appel :dk_color %Blue% "Utilisez l'option d'activation TSforge du menu principal."
aller à dk_done
)

si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum" existe (
%eline%
L'activation HWID n'est pas prise en charge sur Windows Server.
appel :dk_color %Blue% "Utilisez l'option d'activation TSforge du menu principal."
aller à dk_done
)

setlocal EnableDelayedExpansion

:=================================================================================================================================================

cls
si le terminal n'est pas défini (
mode 110, 34
si le chemin « %SysPath%\spp\store_test » existe, mode 134, 34
)
Activation HWID %masver%

écho:
Initialisation en cours...
appel :dk_chkmal

pour %%# dans (
sppsvc.exe
ClipUp.exe
) faire (
si %SysPath%\%%# n'existe pas (
%eline%
Le fichier [%SysPath%\%%#] est manquant, arrêt...
écho:
si les résultats ne sont pas définis (
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez Dépannage et exécutez les options de restauration DISM et d'analyse SFC."
appel :dk_color %Blue% "Après cela, redémarrez le système et réessayez l'activation."
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Si l'erreur persiste, procédez comme suit : " %_Yellow% " %mas%in-place_repair_upgrade"
)
aller à dk_done
)
)

:=================================================================================================================================================

définir spp=SoftwareLicensingProduct
définir sps=SoftwareLicensingService

appel :dk_ckeckwmic
appel :dk_checksku
appel :dk_product
appel :dk_sppissue

:=================================================================================================================================================

:: Vérifiez si le système est activé en permanence ou non

appel :dk_checkperm
si défini _perm (
cls
écho ___________________________________________________________________________________________
écho:
appel :dk_color2 %_White% " " %Green% "%winos% est déjà activé en permanence."
écho ___________________________________________________________________________________________
si %_unattended%==1 aller à dk_done
écho:
choix /C:10 /N /M "> [1] Activer quand même [0] %_exitmsg% : "
Si le niveau d'erreur est 2, quitter /b
)
cls

:=================================================================================================================================================

:: Vérifier la version d'évaluation

si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-*EvalEdition~*.mum" existe (
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID %nul2% | find /i "Eval" %nul1% && (
%eline%
écho [%winos% ^| %winbuild%]
écho:
Les versions d'évaluation d'Echo ne peuvent pas être activées en dehors de leur période d'évaluation.
appel :dk_color %Blue% "Utilisez l'option d'activation TSforge du menu principal pour réinitialiser la période d'évaluation."
définir les correctifs=%fixes% %mas%evaluation_editions
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%evaluation_editions"
aller à dk_done
)
)

:=================================================================================================================================================

définir l'erreur=

cls
écho:
appel :dk_showosinfo

:: Vérifier la connexion Internet

définir _int=
pour %%a dans (l.root-servers.net resolver1.opendns.com download.windowsupdate.com google.com) faire si non défini _int (
for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%a') do (if not "%%#"=="" set _int=1)
)

si non défini _int (
%psc% "Si([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet){Exit 0}Else{Exit 1}"
if !errorlevel!==0 (set _int=1&set ping_f= Mais le ping a échoué)
)

si défini _int (
écho Vérification de la connexion Internet [Connecté%ping_f%]
) autre (
définir erreur=1
appel :dk_color %Red% "Vérification de la connexion Internet [Non connecté]"
appel :dk_color %Blue% "Internet requis pour l'activation HWID."
)

:=================================================================================================================================================

écho Lancement des tests de diagnostic...

définir "_serv=ClipSVC wlidsvc sppsvc KeyIso LicenseManager Winmgmt"

:: Service de licences client (ClipSVC)
:: Assistant de connexion au compte Microsoft
:: Protection logicielle
:: Isolation de la clé CNG
:: Service de gestion des licences Windows
:: Instrumentation de gestion Windows

appel :dk_errorcheck

:=================================================================================================================================================

:: Détecter la clé

définir la clé=
définir la touche alternative=
définir changekey=
définir altapplist=
définir l'édition=
définir non fonctionnel=

appel :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f
si défini, allapps appelle: clé hwiddata
si la clé n'est pas définie (
for /f "delims=" %%a in ('%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':getactivationid\:.*';. ([scriptblock]::Create($f[1]))"') do (set altapplist=%%a)
si altapplist est défini, appelez :hwiddata clé
)

Si défini, appelez :hwidfallback
Si la clé n'est pas définie, appelez :hwidfallback

si altkey est défini (set key=%altkey%&set changekey=1&set notworking=)

si défini ne fonctionne pas si défini notfoundaltactID (
appel :dk_color %Red% "Vérification de l'édition alternative pour l'identifiant matériel [%altedition% ID d'activation introuvable]"
)

si la clé n'est pas définie (
%eline%
echo [%winos% ^| %winbuild% ^| SKU:%osSKU%]
si non défini skunotfound (
Ce produit ne prend pas en charge l'activation HWID.
echo Assurez-vous d'utiliser la dernière version du script.
Si c'est le cas, essayez l'option d'activation TSforge depuis le menu principal.
définir les correctifs=%fixes% %mas%
écho %mas%
) autre (
echo Fichiers de licence requis introuvables dans %SysPath%\spp\tokens\skus\
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)
écho:
aller à dk_done
)

si défini ne fonctionne pas, définir erreur=1

:=================================================================================================================================================

:: Clé d'installation

écho:
si la clé de changement est définie (
appel :dk_color %Blue% "La clé de produit de l'édition [%altedition%] sera utilisée pour activer l'activation HWID."
écho:
)

si winsub est défini (
appel :dk_color %Blue% "Abonnement Windows [ID SKU-%slcSKU%] détecté. Le script activera l'édition de base [ID SKU-%regSKU%].
écho:
)

définir generickey=1
appel :dk_inskey "[%key%]"

:=================================================================================================================================================

Changez la région de Windows en États-Unis pour éviter les problèmes d'activation, car la licence du Microsoft Store n'est pas disponible dans de nombreux pays.

for /f "skip=2 tokens=2*" %%a in ('reg query "HKCU\Control Panel\International\Geo" /v Name %nul6%') do set "name=%%b"
for /f "skip=2 tokens=2*" %%a in ('reg query "HKCU\Control Panel\International\Geo" /v Nation %nul6%') do set "nation=%%b"

:: Ignorer le changement de région dans les pays les plus populaires

définir regionchange=1
pour %%# dans (US CN IN BR DE JP GB FR MX ID IT PK TR KR CA ES AU NG VN PL PH NL EG AR TH CO SA TW MY CL) faire si /i "%name%"=="%%#" définir regionchange=

si la région change (
%psc% "Set-WinHomeLocation -GeoId 244" %nul%
si !errorlevel! EQU 0 (
echo Changement de région Windows vers les États-Unis [Réussi] [Le script rétablira la région précédente]
) autre (
appel :dk_color %Red% "Changement de région Windows vers USA [Échec]"
)
)

:==========================================================================================================================================

:: Générez le fichier GenuineTicket.xml et appliquez-le
:: Dans certains cas, la méthode clipup -v -o échoue, et dans d'autres, la méthode de redémarrage du service échoue également.
:: Afin de maximiser le taux de réussite et d'obtenir des détails d'erreur plus précis, le script installera les tickets deux fois (redémarrage du service + clipup -v -o)

définir "tdir=%ProgramData%\Microsoft\Windows\ClipSVC\GenuineTicket"
si "%tdir%" n'existe pas md "%tdir%" %nul%

if exist "%tdir%\Genuine*" del /f /q "%tdir%\Genuine*" %nul%
if exist "%tdir%\*.xml" del /f /q "%tdir%\*.xml" %nul%
if exist "%ProgramData%\Microsoft\Windows\ClipSVC\Install\Migration\*" del /f /q "%ProgramData%\Microsoft\Windows\ClipSVC\Install\Migration\*" %nul%

appel : ticket hwiddata

copier /y /b "%tdir%\GenuineTicket" "%tdir%\GenuineTicket.xml" %nul%

si le fichier "%tdir%\GenuineTicket.xml" n'existe pas (
appel :dk_color %Red% "Génération de GenuineTicket.xml [Échec, abandon...]"
écho [%encodé%]
if exist "%tdir%\Genuine*" del /f /q "%tdir%\Genuine*" %nul%
aller à :dl_final
) autre (
echo Génération de GenuineTicket.xml [Réussie]
)

définir "_xmlexist=si existe "%tdir%\GenuineTicket.xml""

%_xmlexist% (
%psc% "Démarrer-Tâche { Redémarrer-Service ClipSVC } | Attendre-Tâche -Délai 20 | Sortie-Null"
%_xmlexist% délai d'attente /t 2 %nul%
%_xmlexist% délai d'attente /t 2 %nul%

%_xmlexist% (
définir erreur=1
if exist "%tdir%\*.xml" del /f /q "%tdir%\*.xml" %nul%
appel :dk_color %Gray% "Installation de GenuineTicket.xml [Échec du redémarrage du service ClipSVC, veuillez patienter...]"
)
)

copier /y /b "%tdir%\GenuineTicket" "%tdir%\GenuineTicket.xml" %nul%
clipup -v -o

définir rebuildinfo=

si le fichier %ProgramData%\Microsoft\Windows\ClipSVC\tokens.dat n'existe pas (
définir erreur=1
définir rebuildinfo=1
appel :dk_color %Red% "Vérification de ClipSVC tokens.dat [Introuvable]"
)

%_xmlexist% (
définir erreur=1
définir rebuildinfo=1
appel :dk_color %Red% "Installation de GenuineTicket.xml [Échec avec clipup -v -o]"
)

si le fichier "%ProgramData%\Microsoft\Windows\ClipSVC\Install\Migration\*.xml" existe (
définir erreur=1
définir rebuildinfo=1
appel :dk_color %Red% "Vérification de la migration du ticket [Échec]"
)

si non défini altapplist si non défini showfix si défini rebuildinfo (
définir showfix=1
appel :dk_color %Bleu% "%_fixmsg%"
écho:
)

if exist "%tdir%\Genuine*" del /f /q "%tdir%\Genuine*" %nul%

:==========================================================================================================================================

appel :dk_product

écho:
Activation en cours...

appel :dk_act
appel :dk_checkperm
si défini _perm (
écho:
appel :dk_color %Green% "%winos% est activé de manière permanente avec une licence numérique."
aller à :dl_final
)

:==========================================================================================================================================

:: Effacer le registre associé à l'identifiant du magasin pour corriger l'activation si une connexion Internet est établie

définir "_ident=HKU\S-1-5-19\SOFTWARE\Microsoft\IdentityCRL"

si %keyerror% EQU 0 si défini _int (
reg delete "%_ident%" /f %nul%
for %%# in (wlidsvc LicenseManager sppsvc) do (%psc% "Start-Job { Restart-Service %%# } | Wait-Job -Timeout 20 | Out-Null")
appel :dk_refresh
appel :dk_act
appel :dk_checkperm

requête reg "%_ident%" %nul% || (
définir erreur=1
écho:
appel :dk_color %Red% "Génération d'un nouveau registre IdentityCRL [Échec] [%_ident%]"
)
)

:==========================================================================================================================================

:: Tests étendus des serveurs de licences au cas où aucune erreur ne serait détectée et que l'activation échouerait

si %keyerror% EQU 0 si non défini _perm si défini _int (
ipconfig /flushdns %nul%
définir "tls=[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;"

pour %%# dans (
licensing.mp.microsoft.com/v7.0/licenses/content
login.live.com/ppsecure/deviceaddcredential.srf
achat.mp.microsoft.com/v7.0/users/me/orders
) faire si non défini resfail (
%psc% "try { !tls! irm https://%%# -Method POST } catch { if ($_.Exception.Response -eq $null) { Write-Host """"[%%#] $($_.Exception.Message)"""" -ForegroundColor Red -BackgroundColor Black; exit 3 } }"
si !errorlevel!==3 définir resfail=1
)
)

si défini resfail (
définir erreur=1
pour %%# dans (
en direct.com
microsoft.com
login.live.com
achat.mp.microsoft.com
licensing.mp.microsoft.com
) faire (
findstr /i "%%#" "%SysPath%\drivers\etc\hosts" %nul1% && set "hosfail= [%%# Bloqué dans Hosts]"
)
appel :dk_color %Red% "Vérification des serveurs de licences [Échec de la connexion] !hosfail !"
définir les correctifs=%fixes% %mas%licensing-servers-issue
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%licensing-servers-issue"
écho:
)

:==========================================================================================================================================

:: Vérification des mises à jour Windows et du blocage du Microsoft Store

si %keyerror% EQU 0 si non défini _perm si défini _int (

reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableWindowsUpdateAccess %nul2% | find /i "0x1" %nul% && set wublock=1
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DoNotConnectToWindowsUpdateInternetLocations %nul2% | find /i "0x1" %nul% && set wublock=1
si wublock est défini (
appel :dk_color %Red% "Vérification du bloqueur de mise à jour dans le registre [Trouvé]"
appel :dk_color %Blue% "L'activation HWID nécessite des mises à jour Windows fonctionnelles. Si vous avez utilisé un outil pour bloquer les mises à jour, annulez-le."
écho:
)

reg query "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v DisableStoreApps %nul2% | find /i "0x1" %nul% && (
définir storeblock=1
appel :dk_color %Red% "Vérification du bloqueur de magasin dans le registre [Trouvé]"
appel :dk_color %Blue% "Si vous avez utilisé un outil pour bloquer le Store, annulez-le."
écho:
)

définir wcount=0
pour %%G dans (DependOnService Description DisplayName ErrorControl ImagePath ObjectName Start Type ServiceSidType RequiredPrivileges FailureActions) faire (
reg query HKLM\SYSTEM\CurrentControlSet\Services\wuauserv /v %%G %nul% || (set wucorrupt=1&set /a wcount+=1)
)

pour %%G dans (Paramètres de sécurité) faire (
reg query HKLM\SYSTEM\CurrentControlSet\Services\wuauserv\%%G %nul% || (set wucorrupt=1&set /a wcount+=1)
)

si défini wucorrupt (
définir erreur=1
appel :dk_color %Red% "Vérification du registre de mise à jour Windows [Corruption détectée]"
si !wcount! GTR 2 (
appel :dk_color %Red% "Windows semble être infecté par Mal%w%ware."
définir les correctifs=%fixes% %mas%supprimer_mal%w%ware
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%remove_mal%w%ware"
écho:
) autre (
appel :dk_color %Blue% "L'activation HWID nécessite des mises à jour Windows fonctionnelles. Si vous avez utilisé un outil pour bloquer les mises à jour, annulez-le."
écho:
)
) autre (
%psc% "Démarrer-Tâche { Démarrer-Service wuauserv } | Attendre-Tâche -Délai 20 | Sortie-Null"
sc query wuauserv | find /i "RUNNING" %nul% || (
définir erreur=1
définir wuerror=1
sc démarre wuauserv %nul%
appel :dk_color %Red% "Démarrage du service Windows Update [Échec] [!errorlevel!]"
appel :dk_color %Blue% "L'activation HWID nécessite des mises à jour Windows fonctionnelles. Si vous avez utilisé un outil pour bloquer les mises à jour, annulez-le."
écho:
)
)
)

:==========================================================================================================================================

:: Vérifier les codes d'erreur liés à Internet

si %keyerror% EQU 0 si non défini _perm si défini _int (
si non défini wucorrupt si non défini wublock si non défini wuerror si non défini storeblock si non défini resfail (
echo "%error_code%" | findstr /i "0x80072e 0x80072f 0x800704cf 0x87e10bcf 0x800705b4" %nul% && (
appel :dk_color %Red% "Vérification des problèmes Internet [Détecté] %error_code%"
définir les correctifs=%fixes% %mas%licensing-servers-issue
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%licensing-servers-issue"
écho:
)
)
)

:==========================================================================================================================================

écho:
si défini _perm (
appel :dk_color %Green% "%winos% est activé de manière permanente avec une licence numérique."
) autre (
appel :dk_color %Red% "Échec de l'activation %error_code%"
si défini ne fonctionne pas (
appel :dk_color %Blue% "Au moment de la rédaction, l'activation HWID n'est pas prise en charge pour ce produit."
appel :dk_color %Blue% "Utilisez plutôt l'option d'activation TSforge du menu principal."
) autre (
appel d'erreur si non défini :dk_color %Blue% "%_fixmsg%"
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)
)

:=================================================================================================================================================

:dl_final

écho:

si la région change (
%psc% "Set-WinHomeLocation -GeoId %nation%" %nul%
si !errorlevel! EQU 0 (
restauration de la région Windows [Réussie]
) autre (
appel :dk_color %Red% "Restauration de la région Windows [Échec] [%name% - %nation%]"
)
)

REM si %osSKU%==175 appel :dk_color %Red% "%winos% ne prend pas en charge l'activation sur les plateformes non-Azure."

:: Déclencher une réévaluation des tâches planifiées de SPP

si défini _perm (
appel :dk_reeval %nul%
)
aller à :dk_done

:=================================================================================================================================================

:: Définir les variables

:dk_setvar

définir ps=%SysPath%\WindowsPowerShell\v1.0\powershell.exe
définir psc=%ps% -nop -c
définir winbuild=1
for /f "tokens=2 delims=[]" %%G in ('ver') do for /f "tokens=2,3,4 delims=. " %%H in ("%%~G") do set "winbuild=%%J"

définir _slexe=sppsvc.exe& définir _slser=sppsvc
si %winbuild% LEQ 6300 (définir _slexe=SLsvc.exe& définir _slser=SLsvc)
si %winbuild% LSS 7600 si existe "%SysPath%\SLsvc.exe" (définir _slexe=SLsvc.exe& définir _slser=SLsvc)
si %_slexe%==SLsvc.exe définir _vis=1

définir _NCS=1
si %winbuild% LSS 10586 définir _NCS=0
si %winbuild% GEQ 10586 reg query "HKCU\Console" /v ForceV2 %nul2% | find /i "0x0" %nul1% && (set _NCS=0)

echo "%PROCESSOR_ARCHITECTURE% %PROCESSOR_ARCHITEW6432%" | find /i "ARM64" %nul1% && (if %winbuild% LSS 21277 set ps32onArm=1)

si %_NCS% est égal à 1 (
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"
définir "Rouge="41;97m""
définir "Gris="100;97m""
définir "Vert="42;97m""
définir "Bleu="44;97m""
définir "Blanc="107;91m""
définir "_Rouge="40;91m""
définir "_Blanc="40;37m""
définir "_Green="40;92m""
définir "_Jaune="40;93m""
) autre (
définir "Rouge="Rouge" "blanc"
définir "Gris="Gris foncé" "blanc"
définir "Vert="Vert foncé" "blanc"
définir "Bleu="Bleu" "blanc"
définir "Blanc="Blanc" "Rouge"
définir "_Rouge="Noir" "Rouge"
définir "_Blanc="Noir" "Gris""
définir "_Vert="Noir" "Vert"
définir "_Jaune="Noir" "Jaune""
)

définir "nceline=echo: &echo ==== ERREUR ==== &echo:"
définir "eline=echo: &call :dk_color %Red% "==== ERREUR ====" &echo:"
si %~z0 GEQ 200000 (
définir "_exitmsg=Retour"
définir "_fixmsg=Retournez au menu principal, sélectionnez Dépannage et exécutez l'option Réparer la licence."
) autre (
définir "_exitmsg=Sortie"
définir "_fixmsg=Dans le dossier MAS, exécutez le script de dépannage et sélectionnez l'option de correction de licence."
)
quitter /b

:: Afficher les informations du système d'exploitation

:dk_showosinfo

for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE') do set osarch=%%b

pour /f "tokens=6-7 delims=[]. " %%i dans ('ver') faire si non "%%j"=="" (
définir fullbuild=%%i.%%j
) autre (
for /f "tokens=3" %%G in ('"reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR" %nul6%') do if not errorlevel 1 set /a "UBR=%%G"
pour /f "skip=2 tokens=3,4 delims=. " %%G dans ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v BuildLabEx') faire (
si UBR est défini (définir "fullbuild=%%G.!UBR!") sinon (définir "fullbuild=%%G.%%H")
)
)

écho Vérification des informations du système d'exploitation [%winos% ^| %fullbuild% ^| %osarch%]
quitter /b

:: Vérifier la valeur SKU

:dk_checksku

appel :dk_reflection

définir osSKU=
définir slcSKU=
définir wmiSKU=
définir regSKU=
définir winsub=

si %winbuild% GEQ 14393 (définir info=Kernel-BrandingInfo) sinon (définir info=Kernel-ProductInfo)
définir d1=%ref% [void]$TypeBuilder.DefinePInvokeMethod('SLGetWindowsInformationDWORD', 'slc.dll', 'Public, Static', 1, [int], @([String], [int].MakeByRefType()), 1, 3);
définir d1=%d1% $Sku = 0; [void]$TypeBuilder.CreateType()::SLGetWindowsInformationDWORD('%info%', [ref]$Sku); $Sku
pour /f "delims=" %%s dans ('"%psc% %d1%"') faire si non errorlevel 1 (définir slcSKU=%%s)
définir slcSKU=%slcSKU: =%
si "%slcSKU%"="0" définir slcSKU=
pour /f "tokens=* delims=0123456789" %%a dans ("%slcSKU%") faire (si non "[%%a]"=="[]" définir slcSKU=)

for /f "tokens=3 delims=." %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\ProductOptions" /v OSProductPfn %nul6%') do set "regSKU=%%a"
si %_wmic% EQU 1 pour /f "tokens=2 delims==" %%a dans ('"wmic Path Win32_OperatingSystem Get OperatingSystemSKU /format:LIST" %nul6%') faire si not errorlevel 1 définir "wmiSKU=%%a"
si %_wmic% EQU 0 pour /f "tokens=1" %%a dans ('%psc% "([WMI]'Win32_OperatingSystem=@').OperatingSystemSKU" %nul6%') faire si not errorlevel 1 définir "wmiSKU=%%a"

si %winbuild% GEQ 15063 %psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':winsubstatus\:.*';. ([scriptblock]::Create($f[1]))" %nul2% | find /i "Subscription_is_activated" %nul% && (
si défini regSKU si défini slcSKU si non "%regSKU%"=="%slcSKU%" (
définir winsub=1
définir osSKU=%regSKU%
)
)

si osSKU n'est pas défini, définissez osSKU=%slcSKU%
si osSKU n'est pas défini, définissez osSKU=%wmiSKU%
si osSKU n'est pas défini, définissez osSKU=%regSKU%
quitter /b

::   Obtenir l'état de l'abonnement Windows

:winsubstatus:
$DM = [AppDomain]::CurrentDomain.DefineDynamicAssembly(6, 1).DefineDynamicModule(4).DefineType(2)
[void]$DM.DefinePInvokeMethod('ClipGetSubscriptionStatus', 'Clipc.dll', 22, 1, [Int32], @([IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
$m = [System.Runtime.InteropServices.Marshal]
$p = $m::AllocHGlobal(12)
$r = $DM.CreateType()::ClipGetSubscriptionStatus([ref]$p)
si ($r -eq 0) {
  $activé = $m::ReadInt32($p)
  si ($enabled -ge 1) {
    $état = $m::ReadInt32($p, 8)
    si ($state -eq 1) {
        "L'abonnement est activé."
    }
  }
}
:winsubstatus:

:: Obtenir l'état d'activation permanente de Windows

:dk_checkperm

si %_wmic% EQU 1 wmic path %spp% où (LicenseStatus='1' et GracePeriodRemaining='0' et PartialProductKey n'est pas NULL ET LicenseDependsOn est NULL) obtenir Name /value %nul2% | findstr /i "Windows" %nul1% && set _perm=1||set _perm=
si %_wmic% EQU 0 %psc% "(([WMISEARCHER]'SELECT Name FROM %spp% WHERE LicenseStatus=1 AND GracePeriodRemaining=0 AND PartialProductKey IS NOT NULL AND LicenseDependsOn is NULL').Get()).Name | %% {echo ('Name='+$_)}" %nul2% | findstr /i "Windows" %nul1% && set _perm=1||set _perm=
quitter /b

:: Actualiser l'état de la licence

:dk_refresh

si %_wmic% EQU 1 wmic path %sps% où __CLASS='%sps%' appel RefreshLicenseStatus %nul%
si %_wmic% EQU 0 %psc% "$null=(([WMICLASS]'%sps%').GetInstances()).RefreshLicenseStatus()" %nul%
quitter /b

:: Clé d'installation

:dk_inskey

si %_wmic% EQU 1 wmic path %sps% où __CLASS='%sps%' appel InstallProductKey ProductKey="%key%" %nul%
if %_wmic% EQU 0 %psc% "try { $null=(([WMISEARCHER]'SELECT Version FROM %sps%').Get()).InstallProductKey('%key%'); exit 0 } catch { exit $_.Exception.InnerException.HResult }" %nul%
définir keyerror=%errorlevel%
cmd /c exit /b %keyerror%
si %keyerror% NEQ 0 définir "keyerror=[0x%=ExitCode%]"

si generickey est défini (set "keyecho=Installation de la clé de produit générique ") sinon (set "keyecho=Installation de la clé de produit ")
si %keyerror% est égal à 0 (
si %sps%==SoftwareLicensingService appel :dk_refresh
echo %keyecho% %~1 [Réussi]
) autre (
appel :dk_color %Red% "%keyecho% %~1 [Échec] %keyerror%"
si non défini afficherfix (
si défini altapplist appel :dk_color %Red% "ID d'activation introuvable pour cette clé."
appel :dk_color %Bleu% "%_fixmsg%"
écho:
définir showfix=1
)
définir erreur=1
)

définir la clé générique=
quitter /b

:: Commande d'activation

:dk_act

définir le code d'erreur=
si %_wmic% EQU 1 wmic path %spp% où "ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' ET PartialProductKey N'EST PAS NULL ET LicenseDependsOn est NULL" appel Activate %nul%
if %_wmic% EQU 0 %psc% "try {$null=(([WMISEARCHER]'SELECT ID FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND PartialProductKey IS NOT NULL AND LicenseDependsOn is NULL').Get()).Activate(); exit 0} catch { exit $_.Exception.InnerException.HResult }" %nul%
définir error_code=%errorlevel%
cmd /c exit /b %code_erreur%
si %error_code% NEQ 0 (définir "error_code=[Code d'erreur : 0x%=ExitCode%]") sinon (définir error_code=)
quitter /b

:: Obtenir tous les identifiants d'activation des produits

:dk_actids

définir toutes les applications=
si %_wmic% EQU 1 définir "chkapp=for /f "tokens=2 delims==" %%a dans ('"wmic path %spp% où (ApplicationID='%1') obtenir ID /VALUE" %nul6%')"
si %_wmic% EQU 0 définir "chkapp=for /f "tokens=2 delims==" %%a dans ('%psc% "(([WMISEARCHER]'SELECT ID FROM %spp% WHERE ApplicationID=''%1''').Get()).ID ^| %% {echo ('ID='+$_)}" %nul6%')"
%chkapp% faire (si défini allapps (appeler set "allapps=!allapps! %%a") sinon (appeler set "allapps=%%a"))

:: Vérifier un éventuel plantage du script lorsque l'utilisateur installe manuellement un nombre excessif de licences Office (limite de longueur dans la variable)

si défini allapps si %1==0ff1ce15-a989-479d-af46-f275c6370663 (
définir la longueur à 0
echo:!allapps!> "!_ttemp!\chklen"
pour %%A dans ("!_ttemp!\chklen") faire (définir len=%%~zA)
supprimer "!_ttemp!\chklen" %nul%

si !len! GTR 6000 (
%eline%
echo Trop de licences sont installées, le script risque de planter.
appel :dk_color %Bleu% "%_fixmsg%"
délai d'attente dépassé /t 30
)
)
quitter /b

:: Obtenir les identifiants d'activation des produits installés

:dk_actid

définir les applications=
si %_wmic% EQU 1 définir "chkapp=for /f "tokens=2 delims==" %%a in ('"wmic path %spp% where (ApplicationID='%1' and PartialProductKey is not null) get ID /VALUE" %nul6%')"
si %_wmic% EQU 0 définir "chkapp=for /f "tokens=2 delims==" %%a dans ('%psc% "(([WMISEARCHER]'SELECT ID FROM %spp% WHERE ApplicationID=''%1'' AND PartialProductKey IS NOT NULL').Get()).ID ^| %% {echo ('ID='+$_)}" %nul6%')"
%chkapp% faire (si applications définies (appeler set "apps=!apps! %%a") sinon (appeler set "apps=%%a"))
quitter /b

:: Déclencher une réévaluation permet de mettre à jour les tâches SPP

:dk_reeval

if %winbuild% LSS 7600 exit /b

Cette clé est laissée par le système lors du processus de réarmement et le service sppsvc ne parvient parfois pas à la supprimer, ce qui perturbe le fonctionnement des tâches planifiées de SPP.

définir "ruleskey=HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\PersistedSystemState"
reg delete "%ruleskey%" /v "State" /f %nul%
reg delete "%ruleskey%" /v "SuppressRulesEngine" /f %nul%

définir r1=$TB = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1).DefineDynamicModule(2, $False).DefineType(0);
définir r2=%r1% [void]$TB.DefinePInvokeMethod('SLpTriggerServiceWorker', 'sppc.dll', 22, 1, [Int32], @([UInt32], [IntPtr], [String], [UInt32]), 1, 3);
définir d1=%r2% [void]$TB.CreateType()::SLpTriggerServiceWorker(0, 0, 'reeval', 0)
%psc% "Démarrer-Tâche { Arrêter-Service sppsvc -force } | Attendre-Tâche -Délai 20 | Sortie-Null; %d1%"
quitter /b

:: Récupérer les identifiants d'activation à partir des fichiers de licence s'ils ne sont pas trouvés via WMI

:getactivationid:
$folderPath = "$env:SysPath\spp\tokens\skus"
$files = Get-ChildItem -Path $folderPath -Recurse -Filter "*.xrm-ms"
$guids = @()
pour chaque fichier ($file) dans $files {
    $content = Get-Content -Path $file.FullName -Raw
    $matches = [regex]::Matches($content, 'name="productSkuId">\{([0-9a-fA-F\-]+)\}')
    pour chaque ($match dans $matches) {
        $guids += $match.Groups[1].Value
    }
}
$guids = $guids | Select-Object -Unique
$guidsString = $guids -join " "
$guidsString
:getactivationid:

:: Installez les fichiers de licence à l'aide de PowerShell/WMI au lieu de slmgr.vbs

:xrm:
fonction InstallLicenseFile($Lsc) {
    essayer {
        $null = $sls.InstallLicense([IO.File]::ReadAllText($Lsc))
    } attraper {
        $host.SetShouldExit($_.Exception.HResult)
    }
}
fonction InstallLicenseArr($Str) {
    $a = $Str -split ';'
    Pour chaque ($x dans $a) {Installer le fichier de licence "$x"}
}
fonction InstallLicenseDir($Loc) {
	Get-ChildItem $Loc -Recurse -Filter *.xrm-ms | ForEach-Object {InstallLicenseFile $_.FullName}
}
fonction RéinstallerLicences() {
	$Paths = @("$env:SysPath\oem", "$env:SysPath\licensing", "$env:SysPath\spp\tokens")
	pour chaque ($Path dans $Paths) {
    if (Test-Path $Path) { InstallLicenseDir "$Path" }
	}
}
:xrm:

:: Vérifier wmic.exe

:dk_ckeckwmic

si %winbuild% LSS 9200 (set _wmic=1&exit /b)
définir _wmic=0
pour %%# dans (wmic.exe) faire @si non "%%~$PATH:#"=="" (
cmd /c "wmic path Win32_ComputerSystem get CreationClassName /value" %nul2% | find /i "computersystem" %nul1% && set _wmic=1
)
quitter /b

:: Afficher les informations relatives à un éventuel blocage du script

:dk_sppissue

sc début %_slser% %nul%
définir spperror=%errorlevel%

si %spperror% NEQ 1056 si %spperror% NEQ 0 (
%eline%
echo sc start %_slser% [Code d'erreur : %spperror%]
si %spperror% est égal à 1053 (
appel :dk_color %Blue% "Redémarrez votre machine en utilisant l'option de redémarrage et réessayez."
Appelez :dk_color %Blue% "Si cela ne fonctionne toujours pas, retournez au menu principal, sélectionnez Dépannage et exécutez l'option Réparer le registre WPA."
)
)

écho:
%psc% "$job = Start-Job { (Get-WmiObject -Query 'SELECT * FROM %sps%').Version }; if (-not (Wait-Job $job -Timeout 30)) {write-host '%_slser% ne fonctionne pas correctement. Consultez cette page Web pour obtenir de l'aide - %mas%troubleshoot'}"
quitter /b

:: Obtenir le nom du produit (les méthodes WMI/REG ne sont pas fiables dans toutes les situations, c'est pourquoi la méthode winbrand.dll est utilisée)

:dk_product

définir d1=%ref% $meth = $TypeBuilder.DefinePInvokeMethod('BrandingFormatString', 'winbrand.dll', 'Public, Static', 1, [String], @([String]), 1, 3);
définir d1=%d1% $meth.SetImplementationFlags(128); $TypeBuilder.CreateType()::BrandingFormatString('%%WINDOWS_LONG%%') -replace [string][char]0xa9, '' -replace [string][char]0xae, '' -replace [string][char]0x2122, ''

définir winos=
for /f "delims=" %%s in ('"%psc% %d1%"') do if not errorlevel 1 (set winos=%%s)
echo "%winos%" | find /i "Windows" %nul1% || (
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName %nul6%') do set "winos=%%b"
si %winbuild% GEQ 22000 (
définir winos=!winos:Windows 10=Windows 11!
)
)

if not defined winsub exit /b

:: Vérifiez le nom du produit de l'édition de base si une licence d'abonnement Windows est trouvée

for %%# in (pkeyhelper.dll) do @if "%%~$PATH:#"=="" exit /b
définir d1=%ref% [void]$TypeBuilder.DefinePInvokeMethod('GetEditionNameFromId', 'pkeyhelper.dll', 'Public, Static', 1, [int], @([int], [IntPtr].MakeByRefType()), 1, 3);
définir d1=%d1% $out = 0; [void]$TypeBuilder.CreateType()::GetEditionNameFromId(%regSKU%, [ref]$out);$s=[Runtime.InteropServices.Marshal]::PtrToStringUni($out); $s

pour /f %%a dans ('%psc% "%d1%"') faire si pas errorlevel 1 (
si %winbuild% GEQ 22000 (
définir winos=Windows 11 %%a
) autre (
définir winos=Windows 10 %%a
)
)
quitter /b

:: Lignes courantes utilisées dans le code de réflexion PowerShell

:dk_reflection

définir ref=$AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1);
définir ref=%ref% $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule(2, $False);
définir ref=%ref% $TypeBuilder = $ModuleBuilder.DefineType(0);
quitter /b

:=================================================================================================================================================

:dk_chkmal

:: De nombreux utilisateurs téléchargent sans le savoir des logiciels malveillants en utilisant des activateurs trouvés via une recherche Google.
Ce code a pour but d'informer les utilisateurs que leur système a été infecté par un logiciel malveillant.

définir w=
résultats définis=
s'il existe "%ProgramFiles%\KM%w%Spico", définissez pupfound= KM%w%Spico
si non défini pupfound (
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\taskcache\tasks" /f Path /s | find /i "AutoPico" %nul% && set pupfound= KM%w%Spico
)

définir hcount=0
pour %%# dans (avira.com kaspersky.com virustotal.com mcafee.com) faire (
trouver /i "%%#" %SysPath%\drivers\etc\hosts %nul% && définir /a hcount+=1)
si %hcount%==4 définir "results=[Les URL antivirus sont bloquées dans les hôtes]"

sc début %_slser% %nul%
echo "%errorlevel%" | findstr "577 225" %nul% && (
définir "résultats=%résultats%[Infecteur de fichier probable]"
) || (
si %SysPath%\%_slexe% n'existe pas, si %SysPath%\alg.exe n'existe pas (définir "results=%results%[Infecteur de fichier probable]")
)

si ce n'est pas "%results%%pupfound%"="" (
si défini pupfound appel :dk_color %Gray% "Vérification des activateurs PUP [Trouvé%pupfound%]"
Si les résultats sont définis, appelez :dk_color %Red% "Vérification d'une infection probable par un logiciel malveillant..."
si les résultats sont définis (appel :dk_color %Red% "%results%"&set showfix=1)
définir les correctifs=%fixes% %mas%supprimer_mal%w%ware
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%remove_mal%w%ware"
écho:
)

:: Supprimez la tâche planifiée de R@1n-KMS (ancienne version) qui exécute la commande d'activation toutes les minutes, car elle entraîne une utilisation élevée du processeur.

si le fichier %SysPath%\Tasks\R@1n-KMS existe (
for /f %%A in ('dir /b /a:-d %SysPath%\Tasks\R@1n-KMS %nul6%') do (schtasks /delete /tn \R@1n-KMS\%%A /f %nul%)
)

quitter /b

:=================================================================================================================================================

:dk_errorcheck

définir showfix=
appel :dk_chkmal

::==============================

:: Vérifier le mode sandbox

sc query Null %nul% || (
appel :dk_color %Red% "Vérification du sandbox [Trouvé, le script risque de ne pas fonctionner correctement]"
si non défini afficherfix (
appel :dk_color %Blue% "Si vous utilisez un antivirus tiers, vérifiez s'il bloque le script."
écho:
)
définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier le mode WinPE

reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinPE" /v InstRoot %nul% && (

appel :dk_color %Red% "Vérification de WinPE [Trouvé]"
si non défini afficherfix (
appel :dk_color %Blue% "Mode WinPE détecté. Redémarrez le système et exécutez-le en mode normal."
écho:
)
définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier le mode sans échec

si safeboot_option est défini (
appel :dk_color %Red% "Vérification du mode de démarrage [%safeboot_option%]"
si non défini afficherfix (
appel :dk_color %Blue% "Mode sans échec détecté. Redémarrez le système et exécutez-le en mode normal."
écho:
)
définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier l'état de l'image
:: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-states

for /f "skip=2 tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State" /v ImageState') do (set imagestate=%%B)

si /i n'est pas "%imagestate%"="IMAGE_STATE_COMPLETE" (
appel :dk_color %Gray% "Vérification de l'état de la configuration de Windows [%imagestate%]"
echo "%imagestate%" | find /i "RESEAL" %nul% && (
si non défini afficherfix (
appel :dk_color %Blue% "Vous devez l'exécuter en mode normal si vous l'exécutez en mode audit."
écho:
)
définir erreur=1
définir showfix=1
)
echo "%imagestate%" | find /i "UNDEPLOYABLE" %nul% && (
si non défini afficherfix (
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Si l'activation échoue, faites ceci - " %_Yellow% " %mas%in-place_repair_upgrade"
écho:
)
)
)

::==============================

:: Vérifier les services corrompus

définir serv_cor=
pour %%# dans (%_serv%) faire (
définir _regcorr=
définir _corrompu=
sc début %%# %nul%
si !errorlevel! EQU 1060 définir _corrupt=1
sc query %%# %nul% || set _corrupt=1
pour %%G dans (DependOnService Description DisplayName ErrorControl ImagePath ObjectName Start Type) faire si non défini _regcorr (
reg query HKLM\SYSTEM\CurrentControlSet\Services\%%# /v %%G %nul% || (set _corrupt=1&set _regcorr=-RegistryError)
)

si défini _corrupt (si défini serv_cor (définir "serv_cor=!serv_cor! %%#!_regcorr!") sinon (définir "serv_cor=%%#!_regcorr!"))
)

si défini serv_cor (
appel :dk_color %Red% "Vérification des services corrompus [%serv_cor%]"

si non défini afficherfix (
écho:
si /i "%serv_cor%"="sppsvc-RegistryError" (
définir les correctifs=%fixes% %mas%service_correctifs
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%fix_service"
) autre (
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
)
écho:
)

définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier les services désactivés

définir serv_ste=
pour %%# dans (%_serv%) faire (
sc début %%# %nul%
si !errorlevel! EQU 1058 (si défini serv_ste (définir "serv_ste=!serv_ste! %%#") sinon (définir "serv_ste=%%#"))
)

:: Modifier le type de démarrage des services désactivés par défaut

définir serv_csts=
définir serv_cste=

si défini serv_ste (
pour %%# dans (%serv_ste%) faire (
si /i %%#==ClipSVC (reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%#" /v "Start" /t REG_DWORD /d "3" /f %nul% & sc config %%# start= demand %nul%)
si /i %%#==wlidsvc sc config %%# start= demande %nul%
si /i %%#==sppsvc (reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%#" /v "Start" /t REG_DWORD /d "2" /f %nul% & sc config %%# start= delayed-auto %nul%)
si /i %%#==SLsvc sc config %%# start= auto %nul%
si /i %%#==KeyIso sc config %%# start= demande %nul%
si /i %%#==LicenseManager sc config %%# start= demande %nul%
si /i %%#==Winmgmt sc config %%# start= auto %nul%
si !errorlevel!==0 (
si serv_csts est défini (définir "serv_csts=!serv_csts! %%#") sinon (définir "serv_csts=%%#")
) autre (
si serv_cste est défini (définir "serv_cste=!serv_cste! %%#") sinon (définir "serv_cste=%%#")
)
)
)

si défini serv_csts appel :dk_color %Gray% "Activation des services désactivés [Réussi] [%serv_csts%]"

si défini serv_cste (
appel :dk_color %Red% "Activation des services désactivés [Échec] [%serv_cste%]"

si non défini afficherfix (
écho:
écho %serv_cste% | findstr /i "ClipSVC sppsvc" %nul% && (
echo Une modification du registre a été appliquée pour activer le service désactivé.
Appel :dk_color %Blue% "Redémarrez votre machine en utilisant l'option de redémarrage pour corriger cette erreur."
) || (
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
)
écho:
)

définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier si les services sont en mesure de s'exécuter ou non
Des solutions de contournement ont été ajoutées pour obtenir le statut et le code d'erreur corrects, car la requête sc ne produit pas de résultats corrects dans certaines conditions.

définir serv_e=
pour %%# dans (%_serv%) faire (
définir le code d'erreur=
définir checkerror=

sc query %%# | find /i "RUNNING" %nul% || (
%psc% "Démarrer-Tâche { Démarrer-Service %%# } | Attendre-Tâche -Délai 20 | Sortie-Null"
définir errorcode=!errorlevel!
sc query %%# | find /i "RUNNING" %nul% || set checkerror=1
)

sc début %%# %nul%
si !errorlevel! NEQ 1056 si !errorlevel! NEQ 0 (définir errorcode=!errorlevel!&définir checkerror=1)
Si la fonction checkerror est définie, si la fonction serv_e est définie (définir "serv_e=!serv_e!, %%#-!errorcode!") sinon (définir "serv_e=%%#-!errorcode!")
)

si défini serv_e (
appel :dk_color %Red% "Démarrage des services [Échec] [%serv_e%]"

si non défini afficherfix (
définir listwospp=%_serv:sppsvc=%
echo %serv_e% | findstr /i "!listwospp!" %nul% && (
définir showfix=1
appel :dk_color %Blue% "Redémarrez votre machine en utilisant l'option de redémarrage et exécutez à nouveau le script."
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Si l'erreur de service n'est toujours pas corrigée, faites ceci - " %_Yellow% " %mas%in-place_repair_upgrade"
écho:
)
)
définir erreur=1
)

::==============================

:: Vérifier WMI

définir wmifailed=
if %_wmic% EQU 1 wmic path Win32_ComputerSystem get CreationClassName /value %nul2% | find /i "computersystem" %nul1%
si %_wmic% EQU 0 %psc% "Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property CreationClassName" %nul2% | find /i "computersystem" %nul1%

si %errorlevel% NEQ 0, définissez wmifailed=1

si %_wmic% EQU 1 wmic path %sps% obtenir la version %nul%
si %_wmic% EQU 0 %psc% "try { $null=([WMISEARCHER]'SELECT * FROM %sps%').Get().Version; exit 0 } catch { exit $_.Exception.InnerException.HResult }" %nul%
définir error_code=%errorlevel%
cmd /c exit /b %code_erreur%
si %error_code% NEQ 0 définir "error_code=0x%=ExitCode%"

echo "%error_code%" | findstr /i "0x800410 0x800440 0x80131501" %nul1% && set wmifailed=1& :: https://learn.microsoft.com/en-us/windows/win32/wmisdk/wmi-error-constants

si défini wmifailed (
appel :dk_color %Red% "Vérification WMI [Ne fonctionne pas]"

si non défini afficherfix (
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez Dépannage et exécutez l'option Réparer WMI."
écho:
)
définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier la clé de registre SPP

si %winbuild% GEQ 7600 reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\Plugins\Objects\msft:rm/algorithm/hwid/4.0" /f ba02fed39662 /d %nul% || (
appel :dk_color %Red% "Vérification de la clé de registre SPP [ModuleId incorrect trouvé] [Probablement causé par des tricheurs dans les jeux]"
si non défini afficherfix (
définir les correctifs=%fixes% %mas%issues_due_to_gaming_spoofers
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%issues_due_to_gaming_spoofers"
écho:
)
définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier la clé de registre TokenStore

définir tokenstore=
si %winbuild% GEQ 7600 (
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v TokenStore %nul6%') do call set "tokenstore=%%b"
si %winbuild% LSS 9200 définir "tokenstore=%Systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform"

si %winbuild% GEQ 9200 si /i n'est pas "!tokenstore!"=="%SysPath%\spp\store" si /i n'est pas "!tokenstore!"=="%SysPath%\spp\store\2.0" si /i n'est pas "!tokenstore!"=="%SysPath%\spp\store_test\2.0" (
appel :dk_color %Red% "Vérification de la clé de registre TokenStore [Chemin d'accès incorrect introuvable] [!tokenstore!]"
si non défini afficherfix (
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
écho:
)
définir toerr=1
définir erreur=1
définir showfix=1
)
)

::==============================

Ce code crée le dossier des jetons uniquement s'il est absent et définit ses permissions par défaut.

si %winbuild% GEQ 7600 si non défini toerr si n'existe pas "%tokenstore%\" (

mkdir "%tokenstore%" %nul%

si %winbuild% LSS 9200 définit "d=$sddl = 'O:NSG:NSD:AI(A;OICIID;FA;;;SY)(A;OICIID;FA;;;BA)(A;OICIID;FA;;;NS)';"
si %winbuild% GEQ 9200 définit "d=$sddl = 'O:BAG:BAD:PAI(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICIIO;GR;;;BU)(A;;FR;;;BU)( A;OICI;FA;;;S-1-5-80-123231216-2592883651-3715271367-3753151631-4175906628)';"
définir "d=!d! $AclObject = New-Object System.Security.AccessControl.DirectorySecurity;"
définir "d=!d! $AclObject.SetSecurityDescriptorSddlForm($sddl);"
définir "d=!d! Set-Acl -Path %tokenstore% -AclObject $AclObject;"
%psc% "!d!" %nul%

si existe "%tokenstore%\" (
appel :dk_color %Gray% "Vérification du dossier de jetons SPP [Introuvable, créé maintenant] [%tokenstore%\]"
) autre (
appel :dk_color %Red% "Vérification du dossier de jetons SPP [Introuvable, échec de la création] [%tokenstore%\]"
si non défini afficherfix (
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
écho:
)
définir erreur=1
définir showfix=1
)
)

::==============================

Ce code vérifie si SPP dispose des autorisations d'accès au dossier des jetons et aux clés de registre requises. Ce problème est souvent causé par des tricheurs dans les jeux vidéo.

définir permerror=
si %winbuild% GEQ 9200 si non défini toerr si non défini ps32onArm si existe "%tokenstore%\" (
pour %%# dans (
"%tokenstore%+FullControl"
"HKLM:\SYSTEM\WPA+QueryValues, EnumerateSubKeys, WriteKey"
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform+SetValue"
) faire pour /f "tokens=1,2 delims=+" %%A dans (%%#) faire si non défini permerror (
%psc% "$acl = (Get-Acl '%%A' | fl | Out-String); if (-not ($acl -match 'NT SERVICE\\sppsvc Allow %%B') -or ($acl -match 'NT SERVICE\\sppsvc Deny')) {Exit 2}" %nul%
si !errorlevel!==2 (
si "%%A"="%tokenstore%" (
définir "permerror=Erreur trouvée dans le dossier des jetons"
) autre (
définir "permerror=Erreur trouvée dans les registres SPP"
)
)
)

REM https://learn.microsoft.com/en-us/office/troubleshoot/activation/license-issue-when-start-office-application

si non défini permerror (
reg query "HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion" %nul% && (
définir "pol=HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\Policies"
reg query "!pol!" %nul% || reg add "!pol!" %nul%
%psc% "$netServ = (New-Object Security.Principal.SecurityIdentifier('S-1-5-20')).Translate([Security.Principal.NTAccount]).Value; $aclString = Get-Acl 'Registry::!pol!' | Format-List | Out-String; if (-not ($aclString.Contains($netServ + ' Allow FullControl') -or $aclString.Contains('NT SERVICE\sppsvc Allow FullControl')) -or ($aclString.Contains('Deny'))) {Exit 3}" %nul%
si !errorlevel!==3 définir "permerror=Erreur trouvée dans S-1-5-20 SPP"
)
)

si permerror défini (
appel :dk_color %Red% "Vérification des autorisations SPP [!permerror!]"
si non défini afficherfix (
appel :dk_color %Bleu% "%_fixmsg%"
écho:
)
définir erreur=1
définir showfix=1
)
)

::==============================

:: Vérifier les erreurs du registre WPA

définir chkalp=
définir wpainfo=Introuvable
for /f "delims=" %%a in ('%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':wpatest\:.*';. ([scriptblock]::Create($f[1]))" %nul6%') do (set wpainfo=%%a)
for /f "delims=0123456789" %%i in ("%wpainfo%") do set chkalp=%%i

si défini chkalp (
appel :dk_color %Red% "Vérification des erreurs du registre WPA [%wpainfo%]"
si non défini afficherfix (
echo "%wpainfo%" | find /i "Erreur trouvée" %nul% && (
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez Dépannage et exécutez l'option Réparer le registre WPA."
écho:
définir erreur=1
définir showfix=1
)
)
définir wpainfo=a
)

si non défini chkalp (
si %wpainfo% GEQ 5000 (
appel :dk_color %Gray% "Vérification du nombre d'entrées du registre WPA [%wpainfo%]"
appel :dk_color %Blue% "Un grand nombre de registres WPA ont été trouvés, ce qui peut entraîner une utilisation élevée du processeur."
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez Dépannage et exécutez l'option Réparer le registre WPA."
écho:
) autre (
echo Vérification du nombre de registres WPA [%wpainfo%]
)
)

::==============================

:: Vérifier le réarmement

reg query "HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\PersistedTSReArmed" %nul% && (
appel :dk_color %Red% "Vérification du réarmement [Le système est réarmé]"
si non défini afficherfix (
Appel :dk_color %Blue% "Redémarrez votre machine en utilisant l'option de redémarrage pour corriger cette erreur."
écho:
)
définir erreur=1
définir showfix=1
)


reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ClipSVC\Volatile\PersistedSystemState" %nul% && (
appel :dk_color %Red% "Vérification de ClipSVC PersistedSystemState [Trouvé]"
si non défini afficherfix (
Appel :dk_color %Blue% "Redémarrez votre machine en utilisant l'option de redémarrage pour corriger cette erreur."
écho:
)
définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier le service de gestion des licences logicielles

si %error_code% NEQ 0 (
appel :dk_color %Red% "Vérification du service de licences logicielles [Ne fonctionne pas] [%error_code%]"
si non défini afficherfix (
appel :dk_color %Bleu% "%_fixmsg%"
appel :dk_color %Blue% "Si l'activation échoue toujours, exécutez l'option Réparer le registre WPA."
écho:
)
définir erreur=1
définir showfix=1
)

::==============================

:: Vérifier les identifiants d'activation

appel :dk_actid 55c92734-d682-4d71-983e-d6ec3f16059f

si les applications ne sont pas définies (
%psc% "if (-not $env:_vis) {Start-Job { Stop-Service %_slser% -force } | Wait-Job -Timeout 20 | Out-Null}; $sls = Get-WmiObject SoftwareLicensingService; $f=[IO.File]::ReadAllText('!_batp!') -split ':xrm\:.*';. ([scriptblock]::Create($f[1])); ReinstallLicenses" %nul%
si _vis n'est pas défini si !errorlevel! NEQ 0 définir rlicfailed=1
appel :dk_actid 55c92734-d682-4d71-983e-d6ec3f16059f
)

Si les applications ne sont pas définies, appelez :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f

si non défini apps si défini allapps si non défini notwinact (
appel :dk_color %Gray% "Vérification des ID d'activation [Clé non installée ou ID d'acte introuvable]"
)

si non défini applications si non défini allapps (
appel :dk_color %Red% "Vérification des identifiants d'activation [Introuvable]"
si non défini afficherfix (
appel :dk_color %Bleu% "%_fixmsg%"
appel :dk_color %Blue% "Si l'activation échoue toujours, exécutez l'option Réparer le registre WPA."
écho:
)
définir erreur=1
définir showfix=1
)

si non défini afficher la correction si défini rlicfailed (
appel :dk_color %Bleu% "%_fixmsg%"
appel :dk_color %Blue% "Si l'activation échoue toujours, exécutez l'option Réparer le registre WPA."
écho:
)

si %winbuild% GEQ 7600 si existe "%tokenstore%\" si n'existe pas "%tokenstore%\tokens.dat" (
appel :dk_color %Red% "Vérification de SPP tokens.dat [Introuvable] [%tokenstore%\]"
)

::==============================

:: Vérifier les fenêtres d'évaluation

si non défini notwinact si existe "%SystemRoot%\Servicing\Packages\Microsoft-Windows-*EvalEdition~*.mum" (
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID %nul2% | find /i "Eval" %nul1% || (
appel :dk_color %Red% "Vérification des packages d'évaluation [Échange de licences détecté. Des licences non d'évaluation sont installées dans des fenêtres d'évaluation]"
si non défini afficherfix (
Appel :dk_color %Blue% « L’échange de licence n’est pas la bonne méthode pour passer à la version complète. Apprenez la méthode correcte en suivant le lien ci-dessous. »
définir les correctifs=%fixes% %mas%evaluation_editions
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%evaluation_editions"
écho:
)
définir erreur=1
définir showfix=1
)
)

::==============================

Vérifiez le registre HKU\S-1-5-20\Software ; sur certains systèmes, il est absent, ce qui provoque des problèmes d’activation de Windows.

requête reg "HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion" %nul% || (
appel :dk_color %Red% "Vérification du registre HKU\S-1-5-20 [Introuvable]"
si non défini afficherfix (
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
écho:
)
définir erreur=1
définir showfix=1
)

::==============================

:: Vérifiez la licence et les fichiers du package pour l'édition actuelle

définir osedition=0
si %_wmic% EQU 1 définir "chkedi=for /f "tokens=2 delims==" %%a dans ('"wmic path %spp% où (ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' ET LicenseDependsOn est NULL ET PartialProductKey N'EST PAS NULL) obtenir LicenseFamily /VALUE" %nul6%')"
if %_wmic% EQU 0 set "chkedi=for /f "tokens=2 delims==" %%a in ('%psc% "(([WMISEARCHER]'SELECT LicenseFamily FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND LicenseDependsOn is NULL AND PartialProductKey IS NOT NULL').Get()).LicenseFamily ^| %% {echo ('LicenseFamily='+$_)}" %nul6%')"
%chkedi% faire si le niveau d'erreur n'est pas 1 (appeler set "osedition=%%a")

si %osedition%==0 pour /f "skip=2 tokens=3" %%a dans ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID %nul6%') faire définir "osedition=%%a"

Solution de contournement pour un problème rencontré dans les versions 1607 à 1709 où ProfessionalEducation s'affiche comme Professional

si %osedition% n'est pas égal à 0 (
si "%osSKU%"="164" définir osedition=ProfessionalEducation
si "%osSKU%"="165" définir osedition=ProfessionalEducationN
)

si non défini notwinact (
si %osedition%==0 (
appel :dk_color %Red% "Vérification du nom de l'édition [Introuvable dans le registre]"
) autre (
si le fichier "%SysPath%\spp\tokens\skus\%osedition%\%osedition%*.xrm-ms" n'existe pas si le fichier "%SysPath%\spp\tokens\skus\Security-SPP-Component-SKU-%osedition%\*-%osedition%-*.xrm-ms" n'existe pas si le fichier "%SysPath%\licensing\skus\Security-Licensing-SLC-Component-SKU-%osedition%\*-%osedition%-*.xrm-ms" n'existe pas (
définir skunotfound=1
appel :dk_color %Red% "Vérification des fichiers de licence [Introuvable] [%osedition%]"
)
si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-*-%osedition%-*.mum" n'existe pas (
si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-%osedition%Edition*.mum" n'existe pas (
appel :dk_color %Red% "Vérification des fichiers du package [Introuvable] [%osedition%]"
si non défini afficherfix (
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
écho:
)
définir erreur=1
définir showfix=1
)
)
)
)

::==============================

:: Vérifiez la valeur SKU pour voir s'il y a une différence

si non défini notwinact (
si %winbuild% GEQ 10240 (
%nul% set /a "sum=%slcSKU%+%regSKU%+%wmiSKU%"
définir /a "somme/=3"
si ce n'est pas "!sum!"="%slcSKU%" (
appel :dk_color %Gray% "Vérification de la référence SLC/WMI/REG [Différence trouvée - SLC :%slcSKU% WMI :%wmiSKU% Reg :%regSKU%]"
)
) autre (
%nul% définir /a "somme=%slcSKU%+%wmiSKU%"
définir /a "somme/=2"
si ce n'est pas "!sum!"="%slcSKU%" (
appel :dk_color %Gray% "Vérification de la référence SLC/WMI [Différence trouvée - SLC :%slcSKU% WMI :%wmiSKU%]"
)
)
)

::==============================

:: Ce service « WLMS » était inclus dans les précédentes éditions d'évaluation (qui étaient activables) pour arrêter automatiquement le système toutes les heures après l'expiration de la période d'évaluation et empêcher l'arrêt de SPPSVC.

requête sc wlms %nul%

si %errorlevel% NEQ 1060 (
écho Vérification du service Eval WLMS [Trouvé]
)

::==============================

:: Vérifier les interférences SPP dans IFEO

pour %%# dans (SppEx%w%tComObj.exe SLsvc.exe sppsvc.exe sppsvc.exe\PerfOptions) faire (
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Ima%w%ge File Execu%w%tion Options\%%#" %nul% && (if defined _sppint (set "_sppint=!_sppint!, %%#") else (set "_sppint=%%#"))
)
si défini _sppint (
echo %_sppint% | find /i "PerfOptions" %nul% && (
appel :dk_color %Red% "Vérification des interférences SPP dans IFEO [%_sppint% - Le système pourrait se désactiver ultérieurement]"
si non défini afficherfix (
appel :dk_color %Bleu% "%_fixmsg%"
écho:
)
définir showfix=1
) || (
écho Vérification du SPP dans IFEO [%_sppint%]
)
)

::==============================

:: Vérifier et corriger la valeur de registre SkipRearm

si %winbuild% GEQ 7600 pour /f "skip=2 tokens=2*" %%a dans ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "SkipRearm" %nul6%') faire si /i %%b NEQ 0x0 (
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "SkipRearm" /t REG_DWORD /d "0" /f %nul%
appel :dk_color %Gray% "Vérification de SkipRearm [Valeur par défaut 0 introuvable. Passage à 0]"
%psc% "Démarrer-Tâche { Arrêter-Service sppsvc -force } | Attendre-Tâche -Délai 20 | Sortie-Null"
)

::==============================

Vérifiez l'état de SvcRestartTask ; cette tâche permet de garantir que le système reste activé.

si %winbuild% GEQ 9200 si n'existe pas "%SystemRoot%\Servicing\Packages\Microsoft-Windows-*EvalEdition~*.mum" (
%psc% "Get-WmiObject -Query 'SELECT Description FROM SoftwareLicensingProduct WHERE PartialProductKey IS NOT NULL AND LicenseDependsOn IS NULL' | Select-Object -Property Description" %nul2% | findstr /i "KMS_" %nul1% || (
for /f "delims=" %%a in ('%psc% "$s=New-Object -ComObject 'Schedule.Service'; $s.Connect(); $state=$s.GetFolder('\Microsoft\Windows\SoftwareProtectionPlatform').GetTask('SvcRestartTask').State; @{0='Unknown';1='Disabled';2='Queued';3='Ready';4='Running'}[$state]" %nul6%') do (set taskinfo=%%a)

echo !taskinfo! | find /i "Ready" %nul% || (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "actionlist" /f %nul%
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTask" %nul% || set taskinfo=Removed
si "!taskinfo!"="" définir "taskinfo=Non trouvé"

appel :dk_color %Gray% "Vérification de l'état de SvcRestartTask [!taskinfo!. Le système pourrait se désactiver ultérieurement.]"
si non défini afficherfix (
echo "!taskinfo!" | findstr /i "Supprimé Introuvable" %nul1% && (
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%in-place_repair_upgrade"
) || (
appel :dk_color %Blue% "Redémarrez votre machine en utilisant l'option de redémarrage et exécutez à nouveau le script."
)
écho:
)
)
)
)

::==============================

quitter /b

Ce code vérifie la présence de clés de registre invalides dans HKLM\SYSTEM\WPA. Ce problème peut survenir même sur des systèmes en bon état de fonctionnement.

:wpatest:
$wpaKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $env:COMPUTERNAME).OpenSubKey("SYSTEM\\WPA")
$count = 0
foreach ($subkeyName in $wpaKey.GetSubKeyNames()) {
    si ($subkeyName -match '8DEC0AF1-0341-4b93-85CD-72606C2DF94C.*') {
        $count++
    }
}
$osVersion = [System.Environment]::OSVersion.Version
$minBuildNumber = 14393
si ($osVersion.Build -ge $minBuildNumber) {
    $subkeyHashTable = @{}
    foreach ($subkeyName in $wpaKey.GetSubKeyNames()) {
        si ($subkeyName -match '8DEC0AF1-0341-4b93-85CD-72606C2DF94C.*') {
            $keyNumber = $subkeyName -remplacer '.*-', ''
            $subkeyHashTable[$keyNumber] = $true
        }
    }
    pour ($i=1; $i -le $count; $i++) {
        si (-not $subkeyHashTable.ContainsKey("$i")) {
            Write-Output "Nombre total de clés : $count. Erreur détectée : la clé $i n'existe pas."
			$wpaKey.Fermer()
			sortie
        }
    }
}
$wpaKey.GetSubKeyNames() | ForEach-Object {
    si ($_ -match '8DEC0AF1-0341-4b93-85CD-72606C2DF94C.*') {
        si ($PSVersionTable.PSVersion.Major -lt 3) {
            cmd /c "reg query "HKLM\SYSTEM\WPA\$_" /ve /t REG_BINARY >nul 2>&1"
			si ($LASTEXITCODE -ne 0) {
            Write-Host "Nombre total de clés : $count. Erreur détectée : les données binaires sont corrompues."
			$wpaKey.Fermer()
			sortie
			}
        } autre {
            $sous-clé = $wpaKey.OpenSubKey($_)
            $p = $subkey.GetValueNames()
            si (($p | Where-Object { $subkey.GetValueKind($_) -eq [Microsoft.Win32.RegistryValueKind]::Binary }).Count -eq 0) {
                Write-Host "Nombre total de clés : $count. Erreur détectée : les données binaires sont corrompues."
				$wpaKey.Fermer()
				sortie
            }
        }
    }
}
$count
$wpaKey.Fermer()
:wpatest:

:=================================================================================================================================================

:dk_color

si %_NCS% est égal à 1 (
écho %esc%[%~1%~2%esc%[0m
) sinon si %ps% existe (
%psc% écrire-hôte -back '%1' -fore '%2' '%3'
) sinon si %ps% n'existe pas (
écho %~3
)
quitter /b

:dk_color2

si %_NCS% est égal à 1 (
écho %esc%[%~1%~2%esc%[%~3%~4%esc%[0m
) sinon si %ps% existe (
%psc% write-host -back '%1' -fore '%2' '%3' -NoNewline; write-host -back '%4' -fore '%5' '%6'
) sinon si %ps% n'existe pas (
écho %~3 %~6
)
quitter /b

:=================================================================================================================================================

:dk_done

écho:
si %_unattended%==1 délai d'attente /t 2 & quitter /b

si des correctifs définis (
appel :dk_color %White% "Suivez TOUTES les lignes bleues CI-DESSUS."
appel :dk_color2 %Bleu% "Appuyez sur [1] pour ouvrir la page Web d'assistance " %Gris% "Appuyez sur [0] pour ignorer"
choix /C:10 /N
if !errorlevel!==2 exit /b
si !errorlevel!==1 (démarrer %selfgit% & démarrer %github% & pour %%# dans (%fixes%) faire (démarrer %%#))
)

si terminal défini (
appel :dk_color %_Yellow% "Appuyez sur la touche [0] pour %_exitmsg%..."
choix /c 0 /n
) autre (
appel :dk_color %_Yellow% "Appuyez sur n'importe quelle touche pour %_exitmsg%..."
pause %nul1%
)

quitter /b

:=================================================================================================================================================

:: 1ère colonne = ID d'activation
:: 2e colonne = Clé générique de vente au détail/OEM/MAK
:: 3e colonne = ID SKU
:: 4e colonne = Numéro de pièce clé
:: 5e colonne = 1 = l'activation ne fonctionne pas (au moment de la rédaction), 0 = l'activation fonctionne
:: 6e colonne = Type de clé
:: 7e colonne = ID de l'édition WMI (À titre indicatif uniquement)
:: 8e colonne = Nom de la version au cas où le même ID d'édition serait utilisé dans différentes versions du système d'exploitation avec des clés différentes
:: Séparateur = _


:hwiddata

définir f=
pour %%# dans (
8b351c9c-f398-4515-9900-09df49427262_XGVPP-NMH47-7TTHJ-W3FW7-8H%f%V2C___4_X19-99683_0_OEM:NONSLP_Enterprise
c83cef07-6b72-4bbc-a28f-a00386872839_3V6Q6-NQXCX-V8YXR-9QCYV-QP%f%FCT__27_X19-98746_0_Volume:MAK_EnterpriseN
4de7cb65-cdf1-4de9-8ae8-e3cce27b9f2c_VK7JG-NPHTM-C97JM-9MPGT-3V%f%66T__48_X19-98841_0_____Retail_Professional
9fbaf5d6-4d83-4422-870d-fdda6e5858aa_2B87N-8KFHP-DKV6R-Y2C8J-PK%f%CKT__49_X19-98859_0_____Retail_ProfessionalN
f742e4ff-909d-4fe9-aacb-3231d24a0c58_4CPRK-NM3K3-X6XXQ-RXX86-WX%f%CHW__98_X19-98877_0_____Retail_CoreN
1d1bac85-7365-4fea-949a-96978ec91ae0_N2434-X9D7W-8PF6X-8DV9T-8T%f%YMD__99_X19-99652_0____Retail_CoreCountrySpecific
3ae2cc14-ab2d-41f4-972f-5e20142771dc_BT79Q-G7N6G-PGBYW-4YWX6-6F%f%4BT_100_X19-99661_0_____Retail_CoreSingleLanguage
2b1f36bb-c1cd-4306-bf5c-a0367c2d97d8_YTMG3-N6DKC-DKB77-7M9GH-8H%f%VX7_101_X19-98868_0____Retail_Core
2a6137f3-75c0-4f26-8e3e-d83d802865a4_XKCNC-J26Q9-KFHD2-FKTHY-KD%f%72Y_119_X19-99606_0_OEM:NONSLP_PPIPro
e558417a-5123-4f6f-91e7-385c1c7ca9d4_YNMGQ-8RYV3-4PGQ3-C8XTP-7C%f%FBY_121_X19-98886_0_____Commerce_de_détail_Éducation
c5198a66-e435-4432-89cf-ec777c9d0352_84NGF-MHBT6-FXBX8-QWJK7-DR%f%R8H_122_X19-98892_0_____Commerce_de_détail_ÉducationN
f6e29426-a256-4316-88bf-cc5b0f95ec0c_PJB47-8PN2T-MCGDY-JTY3D-CB%f%CPV_125_X23-50331_1_Volume:MAK_EnterpriseS_Ge
cce9d2de-98ee-4ce2-8113-222620c64a27_KCNVH-YKWX8-GJJB9-H9FDT-6F%f%7W2_125_X22-66075_1_Volume:MAK_EnterpriseS_VB
d06934ee-5448-4fd1-964a-cd077618aa06_43TBQ-NH92J-XKTM7-KT3KK-P3%f%9PB_125_X21-83233_0_OEM:NONSLP_EnterpriseS_RS5
706e0cfd-23f4-43bb-a9af-1a492b9f1302_NK96Y-D9CD8-W44CQ-R8YTK-DY%f%JWX_125_X21-05035_0_OEM:NONSLP_EnterpriseS_RS1
faa57748-75c8-40a2-b851-71ce92aa8b45_FWN7H-PF93Q-4GGP8-M8RF3-MD%f%WWW_125_X19-99617_0_OEM:NONSLP_EnterpriseS_TH
3d1022d8-969f-4222-b54b-327f5a5af4c9_2DBW3-N2PJG-MVHW3-G7TDK-9H%f%KR4_126_X21-04921_0_Volume:MAK_EnterpriseSN_RS1
60c243e1-f90b-4a1b-ba89-387294948fb6_NTX6B-BRYC2-K6786-F6MVQ-M7%f%V2X_126_X19-98770_0_Volume:MAK_EnterpriseSN_TH
01eb852c-424d-4060-94b8-c10d799d7364_3XP6D-CRND4-DRYM2-GM84D-4G%f%G8Y_139_X23-37869_1_____Retail_ProfessionalCountrySpecific_Zn
eb6d346f-1c60-4643-b960-40ec31596c45_DXG7C-N36C4-C4HTG-X4T3X-2Y%f%V77_161_X21-43626_0_____Station de travail professionnelle pour la vente au détail
89e87510-ba92-45f6-8329-3afa905e3e83_WYPNQ-8C467-V2W6J-TX4WX-WT%f%2RQ_162_X21-43644_0_____Retail_ProfessionalWorkstationN
62f0c100-9c53-4e02-b886-a3528ddfe7f6_8PTT6-RNW4C-6V7J2-C2D3X-MH%f%BPB_164_X21-04955_0_____Formation_Professionnelle_Commerce_de_Détail
13a38698-4a49-4b9e-8e83-98fe51110953_GJTYN-HDMQY-FRR76-HVGC7-QP%f%F8P_165_X21-04956_0_____Retail_ProfessionalEducationN
df96023b-dcd9-4be2-afa0-c6c871159ebe_NJCF7-PW8QT-3324D-688JX-2Y%f%V66_175_X21-41295_0____Retail_ServerRdsh
d4ef7282-3d2c-4cf0-9976-8854e64a8d1e_V3WVW-N2PV2-CGWC3-34QGF-VM%f%J2C_178_X21-32983_0_____Retail_Cloud
af5c9381-9240-417d-8d35-eb40cd03e484_NH9J3-68WK7-6FB93-4K3DF-DJ%f%4F6_179_X21-32987_0_____Retail_CloudN
8ab9bdd1-1f67-4997-82d9-8878520837d9_XQQYW-NFFMW-XJPBH-K8732-CK%f%FFD_188_X21-99378_0_____OEM:DM_IoTEnterprise
ed655016-a9e8-4434-95d9-4345352c2552_QPM6N-7J2WJ-P88HH-P3YRH-YY%f%74H_191_X21-99682_0_OEM:NONSLP_IoTEnterpriseS_VB
6c4de1b8-24bb-4c17-9a77-7b939414c298_CGK42-GYN6Y-VD22B-BX98W-J8%f%JXD_191_X23-12617_0_OEM:NONSLP_IoTEnterpriseS_Ge
d4bdc678-0a4b-4a32-a5b3-aaa24c3b0f24_K9VKN-3BGWV-Y624W-MCRMQ-BH%f%DCD_202_X22-53884_0_____Retail_CloudEditionN
92fb8726-92a8-4ffc-94ce-f82e07444653_KY7PN-VR6RX-83W6Y-6DDYQ-T6%f%R4W_203_X22-53847_0_____Retail_CloudEdition
5a85300a-bfce-474f-ac07-a30983e3fb90_N979K-XWD77-YW3GB-HBGH6-D3%f%2MH_205_X23-15042_0_____OEM:DM_IoTEnterpriseSK
80083eae-7031-4394-9e88-4901973d56fe_P8Q7T-WNK7X-PMFXY-VXHBG-RR%f%K69_206_X23-62084_0_____OEM:DM_IoTEnterpriseK
1bc2140b-285b-4351-b99c-26a126104b29_TMP2N-KGFHJ-PWM6F-68KCQ-3P%f%JBP_210_X23-60513_0_____Retail_WNC
) faire (
pour /f "tokens=1-9 delims=_" %%A dans ("%%#") faire (

Touche REM Détection

si %1==clé si %osSKU%==%%C si clé non définie (
echo "!allapps! !altapplist!" | trouver /i "%%A" %nul1% && (
si %%E==1 définir notworking=1
définir la clé=%%B
)
)

REM Générer un billet

si %1==ticket si "%key%"=="%%B" (
définir "SessionIdStr=OSMajorVersion=5;OSMinorVersion=1;OSPlatformId=2;PP=0;Pfn=Microsoft.Windows.%%C.%%D_8wekyb3d8bbwe;PKeyIID=221306452340115677963964261259250411589493550039199940431586886;"
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':sign\:.*';. ([scriptblock]::Create($f[1]))"
)

)
)
quitter /b

:=================================================================================================================================================

:signe:
$ErrorActionPreference = "Arrêter"

fonction SignProperties {
    param (
        Propriétés,
        $rsa
    )

    $sha256 = [Security.Cryptography.SHA256]::Create()
    $bytes = [Text.Encoding]::UTF8.GetBytes($Properties)
    $hash = $sha256.ComputeHash($bytes)

    $signature = $rsa.SignHash($hash, [Security.Cryptography.HashAlgorithmName]::SHA256, [Security.Cryptography.RSASignaturePadding]::Pkcs1)
    retourner [Convert]::ToBase64String($signature)

}

[octet[]] ​​$key = 0x07,0x02,0x00,0x00,0x00,0xA4,0x00,0x00,0x52,0x53,0x41,0x32,0x00,0x04,0x00,0x00,
                0x01,0x00,0x01,0x00,0x29,0x87,0xBA,0x3F,0x52,0x90,0x57,0xD8,0x12,0x26,0x6B,0x38,
                0xB2,0x3B,0xF9,0x67,0x08,0x4F,0xDD,0x8B,0xF5,0xE3,0x11,0xB8,0x61,0x3A,0x33,0x42,
                0x51,0x65,0x05,0x86,0x1E,0x00,0x41,0xDE,0xC5,0xDD,0x44,0x60,0x56,0x3D,0x14,0x39,
                0xB7,0x43,0x65,0xE9,0xF7,0x2B,0xA5,0xF0,0xA3,0x65,0x68,0xE9,0xE4,0x8B,0x5C,0x03,
                0x2D,0x36,0xFE,0x28,0x4C,0xD1,0x3C,0x3D,0xC1,0x90,0x75,0xF9,0x6E,0x02,0xE0,0x58,
                0x97,0x6A,0xCA,0x80,0x02,0x42,0x3F,0x6C,0x15,0x85,0x4D,0x83,0x23,0x6A,0x95,0x9E,
                0x38,0x52,0x59,0x38,0x6A,0x99,0xF0,0xB5,0xCD,0x53,0x7E,0x08,0x7C,0xB5,0x51,0xD3,
                0x8F,0xA3,0x0D,0xA0,0xFA,0x8D,0x87,0x3C,0xFC,0x59,0x21,0xD8,0x2E,0xD9,0x97,0x8B,
                0x40,0x60,0xB1,0xD7,0x2B,0x0A,0x6E,0x60,0xB5,0x50,0xCC,0x3C,0xB1,0x57,0xE4,0xB7,
                0xDC,0x5A,0x4D,0xE1,0x5C,0xE0,0x94,0x4C,0x5E,0x28,0xFF,0xFA,0x80,0x6A,0x13,0x53,
                0x52,0xDB,0xF3,0x04,0x92,0x43,0x38,0xB9,0x1B,0xD9,0x85,0x54,0x7B,0x14,0xC7,0x89,
                0x16,0x8A,0x4B,0x82,0xA1,0x08,0x02,0x99,0x23,0x48,0xDD,0x75,0x9C,0xC8,0xC1,0xCE,
                0xB0,0xD7,0x1B,0xD8,0xFB,0x2D,0xA7,0x2E,0x47,0xA7,0x18,0x4B,0xF6,0x29,0x69,0x44,
                0x30,0x33,0xBA,0xA7,0x1F,0xCE,0x96,0x9E,0x40,0xE1,0x43,0xF0,0xE0,0x0D,0x0A,0x32,
                0xB4,0xEE,0xA1,0xC3,0x5E,0x9B,0xC7,0x7F,0xF5,0x9D,0xD8,0xF2,0x0F,0xD9,0x8F,0xAD,
                0x75,0x0A,0x00,0xD5,0x25,0x43,0xF7,0xAE,0x51,0x7F,0xB7,0xDE,0xB7,0xAD,0xFB,0xCE,
                0x83,0xE1,0x81,0xFF,0xDD,0xA2,0x77,0xFE,0xEB,0x27,0x1F,0x10,0xFA,0x82,0x37,0xF4,
                0x7E,0xCC,0xE2,0xA1,0x58,0xC8,0xAF,0x1D,0x1A,0x81,0x31,0x6E,0xF4,0x8B,0x63,0x34,
                0xF3,0x05,0x0F,0xE1,0xCC,0x15,0xDC,0xA4,0x28,0x7A,0x9E,0xEB,0x62,0xD8,0xD8,0x8C,
                0x85,0xD7,0x07,0x87,0x90,0x2F,0xF7,0x1C,0x56,0x85,0x2F,0xEF,0x32,0x37,0x07,0xAB,
                0xB0,0xE6,0xB5,0x02,0x19,0x35,0xAF,0xDB,0xD4,0xA2,0x9C,0x36,0x80,0xC6,0xDC,0x82,
                0x08,0xE0,0xC0,0x5F,0x3C,0x59,0xAA,0x4E,0x26,0x03,0x29,0xB3,0x62,0x58,0x41,0x59,
                0x3A,0x37,0x43,0x35,0xE3,0x9F,0x34,0xE2,0xA1,0x04,0x97,0x12,0x9D,0x8C,0xAD,0xF7,
                0xFB,0x8C,0xA1,0xA2,0xE9,0xE4,0xEF,0xD9,0xC5,0xE5,0xDF,0x0E,0xBF,0x4A,0xE0,0x7A,
                0x1E,0x10,0x50,0x58,0x63,0x51,0xE1,0xD4,0xFE,0x57,0xB0,0x9E,0xD7,0xDA,0x8C,0xED,
                0x7D,0x82,0xAC,0x2F,0x25,0x58,0x0A,0x58,0xE6,0xA4,0xF4,0x57,0x4B,0xA4,0x1B,0x65,
                0xB9,0x4A,0x87,0x46,0xEB,0x8C,0x0F,0x9A,0x48,0x90,0xF9,0x9F,0x76,0x69,0x03,0x72,
                0x77,0xEC,0xC1,0x42,0x4C,0x87,0xDB,0x0B,0x3C,0xD4,0x74,0xEF,0xE5,0x34,0xE0,0x32,
                0x45,0xB0,0xF8,0xAB,0xD5,0x26,0x21,0xD7,0xD2,0x98,0x54,0x8F,0x64,0x88,0x20,0x2B,
                0x14,0xE3,0x82,0xD5,0x2A,0x4B,0x8F,0x4E,0x35,0x20,0x82,0x7E,0x1B,0xFE,0xFA,0x2C,
                0x79,0x6C,0x6E,0x66,0x94,0xBB,0x0A,0xEB,0xBA,0xD9,0x70,0x61,0xE9,0x47,0xB5,0x82,
                0xFC,0x18,0x3C,0x66,0x3A,0x09,0x2E,0x1F,0x61,0x74,0xCA,0xCB,0xF6,0x7A,0x52,0x37,
                0x1D,0xAC,0x8D,0x63,0x69,0x84,0x8E,0xC7,0x70,0x59,0xDD,0x2D,0x91,0x1E,0xF7,0xB1,
                0x56,0xED,0x7A,0x06,0x9D,0x5B,0x33,0x15,0xDD,0x31,0xD0,0xE6,0x16,0x07,0x9B,0xA5,
                0x94,0x06,0x7D,0xC1,0xE9,0xD6,0xC8,0xAF,0xB4,0x1E,0x2D,0x88,0x06,0xA7,0x63,0xB8,
                0xCF,0xC8,0xA2,0x6E,0x84,0xB3,0x8D,0xE5,0x47,0xE6,0x13,0x63,0x8E,0xD1,0x7F,0xD4,
                0x81,0x44,0x38,0xBF

$rsa = New-Object Security.Cryptography.RSACryptoServiceProvider
$rsa.ImportCspBlob($key)
$SessionId = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($env:SessionIdStr + [char]0))
$PropertiesStr = "OA3xOriginalProductId=;OA3xOriginalProductKey=;SessionId=$SessionId;TimeStampClient=2022-10-11T12:00:00Z"
$SignatureStr = SignProperties $PropertiesStr $rsa

$xml = @"
<?xml version="1.0" encoding="utf-8"?><genuineAuthorization xmlns="http://www.microsoft.com/DRM/SL/GenuineAuthorization/1.0"><version>1.0</version><genuineProperties origin="sppclient"><properties>$PropertiesStr</properties><signatures><signature name="clientLockboxKey" method="rsa-sha256">$SignatureStr</signature></signatures></genuineProperties></genuineAuthorization>
"@
[IO.File]::WriteAllText("$env:ProgramData\Microsoft\Windows\ClipSVC\GenuineTicket\GenuineTicket", ($xml -join ""), [System.Text.Encoding]::ASCII)
:signe:

:=================================================================================================================================================

Le code ci-dessous permet d'obtenir le nom et la clé d'une autre édition si l'édition actuelle ne prend pas en charge l'activation HWID.

:: 1ère colonne = ID SKU actuel
:: 2e colonne = Nom de l'édition actuelle
:: 3e colonne = ID d'activation de l'édition actuelle
:: 4e colonne = ID d'activation de l'édition alternative
:: 5e colonne = Clé HWID de l'édition alternative
:: 6e colonne = Nom de l'édition alternative
:: Séparateur = _


:hwidfallback

définir notfoundaltactID=
si %_NoEditionChange%==1 quitter /b

pour %%# dans (
125_EnterpriseS-2021_______________cce9d2de-98ee-4ce2-8113-222620c64a27_ed655016-a9e8-4434-95d9-4345352c2552_QPM6N-7J2WJ-P88HH-P3YRH-YY%f%74H_IoTEnterpriseS-2021
125_EnterpriseS-2024_______________f6e29426-a256-4316-88bf-cc5b0f95ec0c_6c4de1b8-24bb-4c17-9a77-7b939414c298_CGK42-GYN6Y-VD22B-BX98W-J8%f%JXD_IoTEnterpriseS-2024
138_ProfessionnelMonolingue_____a48938aa-62fa-4966-9d44-9f04da3f72f2_4de7cb65-cdf1-4de9-8ae8-e3cce27b9f2c_VK7JG-NPHTM-C97JM-9MPGT-3V%f%66T_Professionnel
139_ProfessionnelPaysSpécifique____f7af7d09-40e4-419c-a49b-eae366689ebd_4de7cb65-cdf1-4de9-8ae8-e3cce27b9f2c_VK7JG-NPHTM-C97JM-9MPGT-3V%f%66T_Professionnel
139_ProfessionnelPaysSpécifique-Zn_01eb852c-424d-4060-94b8-c10d799d7364_4de7cb65-cdf1-4de9-8ae8-e3cce27b9f2c_VK7JG-NPHTM-C97JM-9MPGT-3V%f%66T_Professionnel
) faire (
pour /f "tokens=1-6 delims=_" %%A dans ("%%#") faire si %osSKU%==%%A (
echo "!allapps! !altapplist!" | trouver /i "%%C" %nul1% && (
echo "!allapps!" | trouver /i "%%D" %nul1% && (
définir altkey=%%E
définir l'édition=%%F
) || (
définir l'édition=%%F
définir notfoundaltactID=1
)
)
)
)
quitter /b

:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:OhookActivation

Pour activer Office avec Ohook, exécutez le script avec le paramètre « /Ohook » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _act=0

Pour désactiver Ohook, exécutez le script avec le paramètre /Ohook-Uninstall ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _rem=0

Si une valeur est modifiée dans les lignes ci-dessus ou si un paramètre est utilisé, le script s'exécutera en mode sans surveillance.

:=================================================================================================================================================

cls
couleur 07
Activation Ohook %masver%

définir _args=
définir _elev=
définir _unattended=0

définir _args=%*
si _args est défini, définissez _args=%_args:"=%
si défini _args (
pour %%A dans (%_args%) faire (
si /i "%%A"="/Ohook" définir _act=1
si /i "%%A"="/Ohook-Uninstall" définir _rem=1
si /i "%%A"="-el" définir _elev=1
)
)

pour %%A dans (%_act% %_rem%) faire (si "%%A"=="1" définir _unattended=1)

:=================================================================================================================================================

si %_rem%==1 aller à :oh_désinstaller

:oh_menu

si %_unattended%==0 (
cls
si le mode terminal n'est pas défini, 76, 25
Activation Ohook %masver%
appel :oh_checkapps
écho:
écho:
écho:
écho:
si checknames est défini (appel :dk_color %_Yellow% " Fermez [!checknames!] avant de continuer...")
écho ____________________________________________________________
écho:
echo [1] Installation de l'activation d'Ohook Office
écho:
echo [2] Désinstaller Ohook
écho ____________________________________________
écho:
echo [3] Télécharger Office
écho:
echo [0] %_exitmsg%
écho ____________________________________________________________
écho:
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier [1,2,3,0]"
choix /C:1230 /N
définir _el=!errorlevel!
if !_el!==4 exit /b
if !_el!==3 start %mas%genuine-installation-media &goto :oh_menu
if !_el!==2 goto :oh_uninstall
si !_el!==1 aller à :oh_menu2
aller à :oh_menu
)

:=================================================================================================================================================

:oh_menu2

cls
si le terminal n'est pas défini (
mode 140, 32
%psc% "&{$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=32;$B.Height=300;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}" %nul%
)
Activation Ohook %masver%

écho:
Initialisation en cours...
appel :dk_chkmal

si %SysPath%\%_slexe% n'existe pas (
%eline%
Le fichier [%SysPath%\%_slexe%] est manquant, arrêt...
écho:
si les résultats ne sont pas définis (
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez Dépannage et exécutez les options de restauration DISM et d'analyse SFC."
appel :dk_color %Blue% "Après cela, redémarrez le système et réessayez l'activation."
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Si l'erreur persiste, procédez comme suit : " %_Yellow% " %mas%in-place_repair_upgrade"
)
aller à dk_done
)

:=================================================================================================================================================

définir spp=SoftwareLicensingProduct
définir sps=SoftwareLicensingService

appel :dk_reflection
appel :dk_ckeckwmic
appel :dk_product
appel :dk_sppissue

:=================================================================================================================================================

définir l'erreur=

cls
écho:
appel :dk_showosinfo

:=================================================================================================================================================

écho Lancement des tests de diagnostic...

définir "_serv=%_slser% Winmgmt"

:: Protection logicielle
:: Instrumentation de gestion Windows

définir notwinact=1
définir ohookact=1
appel :dk_errorcheck

appel :oh_setspp

:: Vérifier les versions d'Office non prises en charge

définir o14c2r=
définir o16uwp=

définir _68=HKLM\SOFTWARE\Microsoft\Office
définir _86=HKLM\SOFTWARE\Wow6432Node\Microsoft\Office
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\14.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o14msi=Office 2010 MSI )
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\14.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o14msi=Office 2010 MSI )
%nul% reg query %_68%\14.0\CVH /f Click2run /k && set o14c2r=Office 2010 C2R
%nul% reg query %_86%\14.0\CVH /f Click2run /k && set o14c2r=Office 2010 C2R

si %winbuild% GEQ 10240 (
for /f "delims=" %%a in ('%psc% "(Get-AppxPackage -name 'Microsoft.Office.Desktop' | Select-Object -ExpandProperty InstallLocation)" %nul6%') do (if exist "%%a\Integration\Integrator.exe" set o16uwp=Office UWP )
)

si ce n'est pas "%o14c2r%%o16uwp%"="" (
écho:
appel :dk_color %Red% "Vérification de l'installation Office non prise en charge [ %o14c2r%%o16uwp%]"
if not "%o16uwp%"=="" call :dk_color %Blue% "Utilisez l'option TSforge pour l'activer."
)

si %winbuild% GEQ 10240 %psc% "Get-AppxPackage -name "Microsoft.MicrosoftOfficeHub"" | find /i "Office" %nul1% && (
définir ohub=1
)

:=================================================================================================================================================

:: Vérifier les versions d'Office prises en charge

appel :oh_getpath

sc query ClickToRunSvc %nul%
définir error1=%errorlevel%

si défini o16c2r si %error1% EQU 1060 (
appel :dk_color %Red% "Vérification du service ClickToRun [Introuvable, fichiers Office 16.0 trouvés]"
définir o16c2r=
définir erreur=1
)

sc query OfficeSvc %nul%
définir error2=%errorlevel%

si défini o15c2r si %error1% EQU 1060 si %error2% EQU 1060 (
appel :dk_color %Red% "Vérification du service ClickToRun [Introuvable, fichiers Office 15.0 trouvés]"
définir o15c2r=
définir erreur=1
)

si "%o16c2r%%o15c2r%%o16msi%%o15msi%%o14msi%"="" (
définir erreur=1
écho:
si ce n'est pas "%o14c2r%%o16uwp%"="" (
appel :dk_color %Red% "Vérification de l'installation d'Office prise en charge [Introuvable]"
) autre (
appel :dk_color %Red% "Vérification d'Office installé [Introuvable]"
)

si ohub est défini (
écho:
Vous n'avez installé que l'application Office Dashboard ; vous devez installer la version complète d'Office.
)
appel :dk_color %Blue% "Téléchargez et installez Office à partir de l'URL ci-dessous, puis réessayez."
définir les correctifs=%fixes% %mas%genuine-installation-media
appel :dk_color %_Yellow% "%mas%genuine-installation-media"
aller à dk_done
)

définir multioffice=
si ce n'est pas "%o16c2r%%o15c2r%%o16msi%%o15msi%%o14msi%"="1", définir multioffice=1
si ce n'est pas "%o14c2r%%o16uwp%"="" définir multioffice=1

si défini multioffice (
appel :dk_color %Gray% "Vérification de plusieurs installations d'Office [Détecté, il est recommandé d'installer une seule version]"
)

:=================================================================================================================================================

:: Vérifier le serveur Windows

définir winserver=
reg query "HKLM\SYSTEM\CurrentControlSet\Control\ProductOptions" /v ProductType %nul2% | find /i "WinNT" %nul1% || set winserver=1
si non défini winserver (
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID %nul2% | find /i "Server" %nul1% && set winserver=1
)

:=================================================================================================================================================

:: Vérifier le contrôle de l'application intelligente

définir "sacstate="
si %winbuild% GEQ 22621 (
for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v VerifiedAndReputablePolicyState %nul6%') do set "sacstate=%%a"
)
si sacstate défini (
si "%sacstate%"=="0x1" (
appel :dk_color %Gray% "Vérification de l'état du contrôle intelligent de l'application [Activé]"
appel :dk_color %Blue% "Le contrôle intelligent des applications peut vous empêcher d'ouvrir Office après l'activation d'Ohook."
appel :dk_color %Blue% "Vous devrez le désactiver dans les paramètres de Windows Defender si c'est le cas."
) sinon si "%sacstate%"=="0x2" (
appel :dk_color %Gray% "Vérification de l'état du contrôle de l'application intelligente [Évaluation]"
appel :dk_color %Blue% "Le contrôle intelligent des applications peut vous empêcher d'ouvrir Office à l'avenir s'il s'active après la période d'évaluation."
appel :dk_color %Blue% "Il est recommandé de le désactiver dans les paramètres de Windows Defender."
)
)

:=================================================================================================================================================

:: Process Office 15.0 C2R

Si o15c2r n'est pas défini, aller à :starto16c2r

appel :oh_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir oVer=15
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg% /v InstallPath" %nul6%') do (set "_oRoot=%%b\root")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v Platform" %nul6%') do (set "_oArch=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v VersionToReport" %nul6%') do (set "_version=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v ProductReleaseIds" %nul6%') do (set "_prids=%o15c2r_reg%\Configuration /v ProductReleaseIds" & set "_config=%o15c2r_reg%\Configuration")
si _oArch n'est pas défini pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o15c2r_reg%\propertyBag /v Platform" %nul6%') faire (définir "_oArch=%%b")
si la version n'est pas définie pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o15c2r_reg%\propertyBag /v version" %nul6%') faire (définir "_version=%%b")
Si la variable `_prids` n'est pas définie pour `/f "skip=2 tokens=2*" %%a` dans `'"reg query %o15c2r_reg%\propertyBag /v ProductReleaseId" %nul6%'`, alors `(set "_prids=%o15c2r_reg%\propertyBag /v ProductReleaseId" & set "_config=%o15c2r_reg%\propertyBag")`

echo "%o15c2r_reg%" | find /i "Wow6432Node" %nul1% && (set _tok=10) || (set _tok=9)
pour /f "tokens=%_tok% delims=\" %%a dans ('reg query %o15c2r_reg%\ProductReleaseIDs\Active %nul6% ^| findstr /i "Retail Volume"') faire (
echo "!_oIds!" | find /i " %%a " %nul1% || (set "_oIds= !_oIds! %%a ")
)

définir "_oLPath=%_oRoot%\Licenses"
définir "_oIntegrator=%_oRoot%\integration\integrator.exe"

si /i "%_oArch%"="x64" (définir "_hookPath=%_oRoot%\vfs\System" & définir "_hook=sppc64.dll")
si /i "%_oArch%"="x86" (définir "_hookPath=%_oRoot%\vfs\SystemX86" et définir "_hook=sppc32.dll")

appel :oh_ppcpath

écho:
echo Activation d'Office... [C2R ^| %_version% ^| %_oArch%]

si non défini _oIds (
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
définir erreur=1
aller à :starto16c2r
)

si défini noOsppc (
appel :dk_color %Red% "Vérification de OSPPC.DLL [Introuvable. Activation annulée...]"
appel :dk_color %Bleu% "%_fixmsg%"
définir erreur=1
aller à :starto16c2r
)

appel :oh_expiredpreview 2013
appel :oh_fixprids
appel :oh_process
si défini isOspp (
appel :oh_hookinstall_ospp
) autre (
appel :oh_hookinstall
)

:=================================================================================================================================================

:starto16c2r

:: Process Office 16.0 C2R

Si o16c2r n'est pas défini, aller à :startmsi

appel :oh_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir oVer=16
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg% /v InstallPath" %nul6%') do (set "_oRoot=%%b\root")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v Platform" %nul6%') do (set "_oArch=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v VersionToReport" %nul6%') do (set "_version=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v AudienceData" %nul6%') do (set "_AudienceData=^| %%b ")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v ProductReleaseIds" %nul6%') do (set "_prids=%o16c2r_reg%\Configuration /v ProductReleaseIds" & set "_config=%o16c2r_reg%\Configuration")

echo "%o16c2r_reg%" | find /i "Wow6432Node" %nul1% && (set _tok=9) || (set _tok=8)
pour /f "tokens=%_tok% delims=\" %%a dans ('reg query "%o16c2r_reg%\ProductReleaseIDs" /s /f ".16" /k %nul6% ^| findstr /i "Retail Volume"') faire (
echo "!_oIds!" | find /i " %%a " %nul1% || (set "_oIds= !_oIds! %%a ")
)
définir _oIds=%_oIds:.16=%
définir _o16c2rIds=%_oIds%

définir "_oLPath=%_oRoot%\Licenses16"
définir "_oIntegrator=%_oRoot%\integration\integrator.exe"

si /i "%_oArch%"="x64" (définir "_hookPath=%_oRoot%\vfs\System" & définir "_hook=sppc64.dll")
si /i "%_oArch%"="x86" (définir "_hookPath=%_oRoot%\vfs\SystemX86" et définir "_hook=sppc32.dll")

appel :oh_ppcpath

écho:
echo Activation d'Office... [C2R ^| %_version% %_AudienceData%^| %_oArch%]

si non défini _oIds (
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
définir erreur=1
aller à :startmsi
)

si défini noOsppc (
appel :dk_color %Red% "Vérification de OSPPC.DLL [Introuvable. Activation annulée...]"
appel :dk_color %Bleu% "%_fixmsg%"
définir erreur=1
aller à :startmsi
)

appel :oh_expiredpreview 2016 2019 2021 2024
appel :oh_fixprids
appel :oh_process
si défini isOspp (
appel :oh_hookinstall_ospp
) autre (
appel :oh_hookinstall
)

:=================================================================================================================================================

:: Les anciennes versions d'Office avec clé de licence d'abonnement peuvent afficher une bannière invitant à se connecter pour résoudre le problème de licence.
:: Bien que le script applique une entrée de registre Resiliency pour corriger ce problème, il ne fonctionne pas sur les anciennes versions d'Office.
:: Le code ci-dessous vérifie cette condition et informe l'utilisateur qu'il doit mettre à jour Office.

si défini _sublic (
si le fichier "%_oLPath%\Word2021VL_KMS_Client_AE*.xrm-ms" n'existe pas (
appel :dk_color %Gray% "Vérification de l'ancienne version d'Office avec sous-licence [Trouvée. Mettez à jour Office, sinon une bannière relative à un problème de licence peut s'afficher.]"
)
)

:=================================================================================================================================================

:: mass{}grave{dot}dev/office-license-is-not-genuine
:: Ajouter des clés de registre pour les produits en volume afin que le bandeau « non authentique » n'apparaisse pas
Le script utilise déjà MAK au lieu de GVLK, il n'apparaîtra donc pas. Toutefois, des clés de registre sont ajoutées au cas où Office installerait la clé de grâce GVLK par défaut pour les produits en volume.

définir "kmskey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\0ff1ce15-a989-479d-af46-f275c6370663"
echo "%_oIds%" | find /i "Volume" %nul1% && (
si %winbuild% GEQ 9200 (
si ce n'est pas "%osarch%"="x86" (
reg delete "%kmskey%" /f /reg:32 %nul%
reg add "%kmskey%" /f /v KeyManagementServiceName /t REG_SZ /d "10.0.0.10" /reg:32 %nul%
)
reg delete "%kmskey%" /f %nul%
reg add "%kmskey%" /f /v KeyManagementServiceName /t REG_SZ /d "10.0.0.10" %nul%
echo Ajout d'une entrée de registre pour empêcher l'affichage de la bannière [Réussi]
)
)

:=================================================================================================================================================

:startmsi

si défini o14msi appel :oh_setspp 14
si défini o14msi appel :oh_processmsi 14 %o14msi_reg%
appel :oh_setspp
si défini o15msi appel :oh_processmsi 15 %o15msi_reg%
si défini o16msi appel :oh_processmsi 16 %o 16msi_reg%

:=================================================================================================================================================

appel :oh_clearblock
appel :oh_uninstkey
appel :oh_licrefresh

:=================================================================================================================================================

écho:
erreur si non définie (
appel :dk_color %Green% "Office est activé en permanence."
Si défini, appel ohub :dk_color %Gray% "Les applications Office telles que Word et Excel sont activées, utilisez-les directement. Ignorez le bouton « Acheter » dans l’application Tableau de bord Office."
echo Aide : %mas%dépannage
) autre (
appel :dk_color %Red% "Des erreurs ont été détectées."
si non défini ierror si non défini showfix appel :dk_color %Blue% "%_fixmsg%"
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)

aller à :dk_done

:=================================================================================================================================================

:oh_désinstaller

cls
si le mode terminal n'est pas défini, 145, 32
Titre Désinstaller Ohook Activation %masver%

définir _présent=
définir _unerror=
appel :oh_reset
appel :oh_getpath

écho:
écho Désinstallation de l'activation Ohook...
écho:

si o16c2r_reg est défini (pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o16c2r_reg% /v InstallPath" %nul6%') faire (définir "_16CHook=%%b\root\vfs"))
si o15c2r_reg est défini (pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o15c2r_reg% /v InstallPath" %nul6%') faire (définir "_15CHook=%%b\root\vfs"))
si o16msi_reg est défini (pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o16msi_reg%\Common\InstallRoot /v Path" %nul6%') faire (définir "_16MHook=%%b"))
si o15msi_reg est défini (pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o15msi_reg%\Common\InstallRoot /v Path" %nul6%') faire (définir "_15MHook=%%b"))
si o14msi_reg est défini (pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o14msi_reg%\Common\InstallRoot /v Path" %nul6%') faire (définir "_14MHook=%%b"))

si _16CHook est défini (si "%_16CHook%\System\sppc*dll" existe (définir _present=1& supprimer /s /f /q "%_16CHook%\System\sppc*dll" & si "%_16CHook%\System\sppc*dll" existe, définir _unerror=1))
si _16CHook est défini (si "%_16CHook%\SystemX86\sppc*dll" existe (définir _present=1& supprimer /s /f /q "%_16CHook%\SystemX86\sppc*dll" & si "%_16CHook%\SystemX86\sppc*dll" existe, définir _unerror=1))
si _15CHook est défini (si "%_15CHook%\System\sppc*dll" existe (définir _present=1& supprimer /s /f /q "%_15CHook%\System\sppc*dll" & si "%_15CHook%\System\sppc*dll" existe, définir _unerror=1))
si _15CHook est défini (si "%_15CHook%\SystemX86\sppc*dll" existe (définir _present=1& supprimer /s /f /q "%_15CHook%\SystemX86\sppc*dll" & si "%_15CHook%\SystemX86\sppc*dll" existe, définir _unerror=1))
si _16MHook est défini (si "%_16MHook%sppc*dll" existe (définir _present=1& supprimer /s /f /q "%_16MHook%sppc*dll" & si "%_16MHook%sppc*dll" existe, définir _unerror=1))
si _15MHook est défini (si "%_15MHook%sppc*dll" existe (définir _present=1& supprimer /s /f /q "%_15MHook%sppc*dll" & si "%_15MHook%sppc*dll" existe, définir _unerror=1))
si _14MHook est défini (si "%_14MHook%sppc*dll" existe (définir _present=1& supprimer /s /f /q "%_14MHook%sppc*dll" & si "%_14MHook%sppc*dll" existe, définir _unerror=1))

pour %%# dans (14 15 16) faire (
pour %%A dans ("%ProgramFiles%" "%ProgramW6432%" "%ProgramFiles(x86)%") faire (
si le fichier "%%~A\Microsoft Office\Office%%#\sppc*dll" existe (définir _present=1& supprimer /s /f /q "%%~A\Microsoft Office\Office%%#\sppc*dll" & si le fichier "%%~A\Microsoft Office\Office%%#\sppc*dll" existe, définir _unerror=1)
)
)

pour %%# dans (System SystemX86) faire (
pour %%G dans ("Office 15" "Office") faire (
pour %%A dans ("%ProgramFiles%" "%ProgramW6432%" "%ProgramFiles(x86)%") faire (
si le fichier "%%~A\Microsoft %%~G\root\vfs\%%#\sppc*dll" existe (définir _present=1& supprimer /s /f /q "%%~A\Microsoft %%~G\root\vfs\%%#\sppc*dll" & si le fichier "%%~A\Microsoft %%~G\root\vfs\%%#\sppc*dll" existe, définir _unerror=1)
)
)
)

::==================================

pour %%# dans (OSPPC.DLL sppcs.dll) faire (
pour %%A dans ("%CommonProgramFiles%" "%CommonProgramW6432%" "%CommonProgramFiles(x86)%") faire (
pour %%G dans ("%%~A\Microsoft Shared\OfficeSoftwareProtectionPlatform\%%#") faire (
définir la taille=0
taille définie=%%~zG
si !taille! GEQ 1 si !taille! LSS 100000 (
définir _présent=1
supprimer /f /q "%%~G"
si "%%~G" existe (déplacer /y "%%~G" "!_ttemp!\needsToBeDeleted%random%" %nul%)
Si le fichier « %%~G » existe (définir _unerror=1) sinon (afficher Fichier supprimé - %%~G)
)
si /i sppcs.dll==%%# si !size! GEQ 100000 (
déplacer /y "%%~G" "%%~A\Microsoft Shared\OfficeSoftwareProtectionPlatform\OSPPC.DLL" %nul%
si "%%~G" existe (déplacer /y "%%~A\Microsoft Shared\OfficeSoftwareProtectionPlatform\OSPPC.DLL" "!_ttemp!\needsToBeDeleted%random%" %nul%)
déplacer /y "%%~G" "%%~A\Microsoft Shared\OfficeSoftwareProtectionPlatform\OSPPC.DLL" %nul%
Si le fichier "%%~G" existe (définir _unerror=1&echo Échec du renommage de sppcs.dll en "%%~A\Microsoft Shared\OfficeSoftwareProtectionPlatform\OSPPC.DLL") sinon (echo sppcs.dll a été renommé en "%%~A\Microsoft Shared\OfficeSoftwareProtectionPlatform\OSPPC.DLL")
)
)
)
)

::==================================

reg query HKCU\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency %nul% && (
écho:
Suppression des clés de registre pour ignorer la vérification de licence

charge reg HKU\DEF_TEMP %SystemDrive%\Users\Default\NTUSER.DAT %nul%
reg query HKU\DEF_TEMP\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency %nul% && reg delete HKU\DEF_TEMP\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency /f
décharger la registre HKU\DEF_TEMP %nul%

définir _sidlist=
for /f "tokens=* delims=" %%a in ('%psc% "$p = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'; Get-ChildItem $p | ForEach-Object { $pi = (Get-ItemProperty """"$p\$($_.PSChildName)"""").ProfileImagePath; if ($pi -like '*\Users\*' -and (Test-Path """"$pi\NTUSER.DAT"""") -and -not ($_.PSChildName -match '\.bak$')) { Split-Path $_.PSPath -Leaf } }" %nul6%') do (if defined _sidlist (set _sidlist=!_sidlist! %%a) else (set _sidlist=%%a))

si non défini _sidlist (
for /f "delims=" %%a in ('%psc% "$explorerProc = Get-Process -Name explorer | Where-Object {$_.SessionId -eq (Get-Process -Id $pid).SessionId} | Select-Object -First 1; $sid = (gwmi -Query ('Select * From Win32_Process Where ProcessID=' + $explorerProc.Id)).GetOwnerSid().Sid; $sid" %nul6%') do (set _sidlist=%%a)
)

pour %%# dans (!_sidlist!) faire (

reg query HKU\%%#\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency %nul% && reg delete HKU\%%#\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency /f

requête d'enregistrement HKU\%%#\Software %nul% || (
pour /f "skip=2 tokens=2*" %%a dans ('"reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\%%#" /v ProfileImagePath" %nul6%') faire (
charge d'enregistrement HKU\%%# "%%b\NTUSER.DAT" %nul%
reg query HKU\%%#\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency %nul% && reg delete HKU\%%#\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency /f
déchargement régulier HKU\%%# %nul%
)
)
)
)

::==================================

définir "kmskey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\0ff1ce15-a989-479d-af46-f275c6370663"
requête reg "%kmskey%" %nul% && (
écho:
Suppression de la bannière non authentique - Clés de registre
reg delete "%kmskey%" /f
)

requête reg "%kmskey%" /reg:32 %nul% && (
reg delete "%kmskey%" /f /reg:32
)

écho __________________________________________________________________________________________
écho:

si non défini _présent (
L'activation d'Ohook n'est pas installée.
) autre (
si défini _unerror (
appel :dk_color %Red% "Échec de la désinstallation de l'activation Ohook."
appel :oh_checkapps
si les noms de vérification sont définis (
appel :dk_color %Blue% "Fermez [!checknames!] et réessayez."
Appel :dk_color %Blue% "Si le problème persiste, redémarrez votre machine à l'aide de l'option de redémarrage et réessayez."
) autre (
appel :dk_color %Blue% "Redémarrez votre machine en utilisant l'option de redémarrage et réessayez."
)
) autre (
appel :dk_color %Green% "Activation Ohook désinstallée avec succès."
)
)
écho __________________________________________________________________________________________

aller à :dk_done

:=================================================================================================================================================

:oh_reset

définir la clé=
définir _oRoot=
définir _oArch=
définir _oIds=
définir _oLPath=
définir _hookPath=
définir _hook=
définir _sppcPath=
définir _osppPath=
définir _actid=
définir _prod=
définir _lic=
définir _arr=
définir _prids=
définir _config=
définir _version=
définir _Licence=
quitter /b

:=================================================================================================================================================

:oh_getpath

définir o16c2r=
définir o15c2r=
définir o16msi=
définir o15msi=
définir o14msi=

définir _68=HKLM\SOFTWARE\Microsoft\Office
définir _86=HKLM\SOFTWARE\Wow6432Node\Microsoft\Office

for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" (set o16c2r=1&set o16c2r_reg=%_86%\ClickToRun)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" (set o16c2r=1&set o16c2r_reg=%_68%\ClickToRun)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\15.0\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses\ProPlus*.xrm-ms" (set o15c2r=1&set o15c2r_reg=%_86%\15.0\ClickToRun)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\15.0\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses\ProPlus*.xrm-ms" (set o15c2r=1&set o15c2r_reg=%_68%\15.0\ClickToRun)

for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\16.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o16msi=1&set o16msi_reg=%_86%\16.0)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\16.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o16msi=1&set o16msi_reg=%_68%\16.0)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\15.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o15msi=1&set o15msi_reg=%_86%\15.0)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\15.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o15msi=1&set o15msi_reg=%_68%\15.0)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\14.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o14msi=1&set o14msi_reg=%_86%\14.0)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\14.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o14msi=1&set o14msi_reg=%_68%\14.0)

quitter /b

:=================================================================================================================================================

:oh_expiredpreview

echo %_oIds% | find /i "Volume" %nul% || exit /b

pour %%# dans (%*) faire (
si %%#==2013 définir _offver=
si %%#==2016 définir _offver=
si %%#==2019 définir _offver=2019
si %%#==2021 définir _offver=2021
si %%#==2024 définir _offver=2024
si existe "!_oLPath!\ProPlus!_offver!PreviewVL_*.xrm-ms" si n'existe pas "!_oLPath!\ProPlus!_offver!VL_*.xrm-ms" (
définir erreur=1
définir showfix=1
appel :dk_color %Red% "Vérification des produits d'aperçu expirés [Aperçu d'Office %%# trouvé]"
appel :dk_color %Blue% "Veuillez d'abord effectuer les mises à jour d'Office, puis réessayer de l'activer."
)
)

quitter /b

:=================================================================================================================================================

:oh_ppcpath

si non défini isOspp (
si ce n'est pas "%osarch%"="x86" (
si /i "%_oArch%"="x64" définir "_sppcPath=%SystemRoot%\System32\sppc.dll"
if /i "%_oArch%"="x86" set "_sppcPath=%SystemRoot%\SysWOW64\sppc.dll"
) autre (
définir "_sppcPath=%SystemRoot%\System32\sppc.dll"
)
)

définir noOsppc=
définir _hook68=
définir _hook86=
définir _osppPath68=
définir _osppPath86=

si défini isOspp (
si ce n'est pas "%osarch%"="x86" (
si /i "%_oArch%"="x64" (
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform /v Path" %nul6%') do (set "_osppPath68=%%b")
Si le fichier « !_osppPath68!OSPPC.DLL » n'existe pas, définissez noOsppc=1
)
si /i "%_oArch%"="x86" (
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform /v Path" %nul6%') do (set "_osppPath68=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Wow6432Node\Microsoft\OfficeSoftwareProtectionPlatform /v Path" %nul6%') do (set "_osppPath86=%%b")
Si le fichier « !_osppPath68!OSPPC.DLL » n'existe pas, définissez noOsppc=1
Si le fichier « !_osppPath86!OSPPC.DLL » n'existe pas, définissez noOsppc=1
)
) autre (
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform /v Path" %nul6%') do (set "_osppPath86=%%b")
Si le fichier « !_osppPath86!OSPPC.DLL » n'existe pas, définissez noOsppc=1
)
si "!_osppPath68:~-1!"=="\" définir "_osppPath68=!_osppPath68:~0,-1!"
si "!_osppPath86:~-1!"=="\" définir "_osppPath86=!_osppPath86:~0,-1!"
)

Si _osppPath68 est défini, définissez _hook68=sppc64.dll
Si _osppPath86 est défini, définissez _hook86=sppc32.dll

quitter /b

:=================================================================================================================================================

Certains outils de conversion Office Retail vers Volume peuvent modifier les ProductReleaseIds pour ajouter des produits VL. Ce code rétablit ces identifiants car cela peut affecter certaines fonctionnalités.

:oh_fixprids

si non défini _prids (
appel :dk_color %Gray% "Vérification des ProductReleaseIds dans le registre [Introuvable]"
quitter /b
)

définir _pridsR=
définir _pridsE=
for /f "skip=2 tokens=2*" %%a in ('"reg query %_prids%" %nul6%') do (set "_pridsR=%%b")

définir _pridsR=%_pridsR:,= %
pour %%# dans (%_pridsR%) faire (echo %%# | findstr /I "%_oIds%" %nul1% || set _pridsE=1)
pour %%# dans (%_oIds%) faire (echo %%# | findstr /I "%_pridsR%" %nul1% || set _pridsE=1)

si non défini _pridsE quitter /b
reg add %_prids% /t REG_SZ /d "" /f %nul1%

pour %%# dans (%_oIds%) faire (
pour /f "skip=2 tokens=2*" %%a dans ('reg query %_prids%') faire si non "%%b"=="" (
reg add %_prids% /t REG_SZ /d "%%b,%%#" /f %nul1%
) autre (
reg add %_prids% /t REG_SZ /d "%%#" /f %nul1%
)
)

quitter /b

:=================================================================================================================================================

:oh_installlic

si _oLPath n'est pas défini, quitter /b

si défini _oIntegrator (
si %oVer%==16 (
"!_oIntégrateur!" /I /License PRIDName=%_License%.16 PidKey=%key% %nul%
) autre (
"!_oIntégrateur!" /I /License PRIDName=%_License% PidKey=%key% %nul%
)
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663
echo "!allapps!" | trouver /i "!_actid!" %nul1% && quitter /b
)

:: Utiliser la méthode manuelle d'installation des licences si integrator.exe ne fonctionne pas

définir _License=%_License:XVolume=XC2RVL_%

définir _License=%_License:O365EduCloudRetail=O365EduCloudEDUR_%

définir _License=%_License:ProjectProRetail=ProjectProO365R_%
définir _License=%_License:ProjectStdRetail=ProjectStdO365R_%
définir _License=%_License:VisioProRetail=VisioProO365R_%
définir _License=%_License:VisioStdRetail=VisioStdO365R_%

si _preview est défini, définir _License=%_License:Volume=PreviewVL_%

définir _License=%_License:Retail=R_%
définir _License=%_License:Volume=VL_%

pour %%# dans ("!_oLPath!\client-issuance-*.xrm-ms") faire (
si _arr est défini (définir "_arr=!_arr!;"!_oLPath!\%%~nx#"") sinon (définir "_arr="!_oLPath!\%%~nx#"")
)

pour %%# dans ("!_oLPath!\%_License%*.xrm-ms") faire (
si _arr est défini (définir "_arr=!_arr!;"!_oLPath!\%%~nx#"") sinon (définir "_arr="!_oLPath!\%%~nx#"")
)

%psc% "$sls = Get-WmiObject %sps%; $f=[IO.File]::ReadAllText('!_batp!') -split ':xrm\:.*';. ([scriptblock]::Create($f[1])); InstallLicenseArr '!_arr!'; InstallLicenseFile '"!_oLPath!\pkeyconfig-office.xrm-ms"'" %nul%

appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663
echo "!allapps!" | trouver /i "!_actid!" %nul1% || (
définir erreur=1
appel :dk_color %Red% "Installation des fichiers de licence manquants [Office %oVer%.0 %_prod%] [Échec]"
)

quitter /b

:=================================================================================================================================================

:oh_hookinstall

définir ierror=
définir hasherror=

si %_hook%==sppc32.dll définir offset=2564
si %_hook%==sppc64.dll définir offset=3076

:========================================

:: Supprimer l'installation précédente

pour %%# dans (sppcs.dll sppc.dll) faire (
supprimer /f /q "%_hookPath%\%%#" %nul%
si "%_hookPath%\%%#" existe (déplacer /y "%_hookPath%\%%#" "!_ttemp!\needsToBeDeleted%random%" %nul%)
si "%_hookPath%\%%#" existe (définir "ierror=Supprimer l'installation Ohook précédente [%%#]")
)

si ierror est défini, aller à :oh_hookinstall_error

:========================================

mklink "%_hookPath%\sppcs.dll" "%_sppcPath%" %nul%
si le fichier "%_hookPath%\sppcs.dll" n'existe pas (
définir ierror=mklink sppcs.dll
aller à :oh_hookinstall_error
)

si le fichier "%_hookPath%\sppc.dll" n'existe pas (
appel :oh_extractdll "%_hookPath%\sppc.dll" "%offset%"
)
si le fichier "%_hookPath%\sppc.dll" n'existe pas (
définir ierror=Copie
aller à :oh_hookinstall_error
)

écho:
echo Création du lien symbolique de sppc.dll système ["%_hookPath%\sppcs.dll"] [Réussi]
echo Extraction du hook personnalisé %_hook% vers ["%_hookPath%\sppc.dll"] [Réussie]

aller à :oh_hookinstall_error

:=================================================================================================================================================

:oh_hookinstall_ospp

définir ierror=
définir hasherror=

si _hook86 est défini, définir offset86=2564
si _hook68 est défini, définir offset68=3076

:========================================

:: Supprimer l'installation précédente

pour %%# dans (OSPPC.DLL sppcs.dll) faire (
pour %%A dans ("%_osppPath68%\%%#" "%_osppPath86%\%%#") faire (
définir la taille=0
taille définie=%%~zA
si !taille! GEQ 1 si !taille! LSS 100000 (
supprimer /f /q "%%~A" %nul%
si "%%~A" existe (déplacer /y "%%~A" "!_ttemp!\needsToBeDeleted%random%" %nul%)
si "%%~A" existe (définir "ierror=Supprimer l'installation Ohook précédente [%%#]")
)
)
)

si ierror est défini, aller à :oh_hookinstall_error

pour %%A dans ("%_osppPath68%" "%_osppPath86%") faire (
si "%%~A\sppcs.dll" existe (déplacer /y "%%~A\sppcs.dll" "%%~A\OSPPC.DLL" %nul%)
si le fichier "%%~A\sppcs.dll" existe (
déplacer /y "%%~A\OSPPC.DLL" "!_ttemp!\needsToBeDeleted%random%" %nul%
déplacer /y "%%~A\sppcs.dll" "%%~A\OSPPC.DLL" %nul%
)
Si le fichier "%%~A\sppcs.dll" existe (définir "ierror=Remplacer sppcs.dll par OSPPC.DLL")
)

supprimer /f /q "%_hookPath%\sppcs.dll" %nul%
si le fichier "%_hookPath%\sppcs.dll" existe (déplacer /y "%_hookPath%\sppcs.dll" "!_ttemp!\needsToBeDeleted%random%" %nul%)
Si le fichier "%_hookPath%\sppcs.dll" existe (définir "ierror=Supprimer le lien Ohook précédent sppcs.dll")

si ierror est défini, aller à :oh_hookinstall_error

:========================================

si défini _osppPath68 (déplacer /y "%_osppPath68%\OSPPC.DLL" "%_osppPath68%\sppcs.dll" %nul% & si n'existe pas "%_osppPath68%\sppcs.dll" définir ierror=1)
si _osppPath86 est défini (déplacer /y "%_osppPath86%\OSPPC.DLL" "%_osppPath86%\sppcs.dll" %nul% & si "%_osppPath86%\sppcs.dll" n'existe pas, définir ierror=1)

si défini ierror (
définir "ierror=Renommer OSPPC.DLL"
aller à :oh_hookinstall_error
)

si défini _osppPath68 si défini _osppPath86 (mklink "%_hookPath%\sppcs.dll" "%_osppPath86%\sppcs.dll" %nul%)
si défini _osppPath68 sinon _osppPath86 (mklink "%_hookPath%\sppcs.dll" "%_osppPath68%\sppcs.dll" %nul%)
si défini _osppPath86 sinon _osppPath68 (mklink "%_hookPath%\sppcs.dll" "%_osppPath86%\sppcs.dll" %nul%)

si le fichier "%_hookPath%\sppcs.dll" n'existe pas (
définir ierror=mklink sppcs.dll
aller à :oh_hookinstall_error
)

si défini _osppPath68 (définir _hook=%_hook68%&appeler :oh_extractdll "%_osppPath68%\OSPPC.DLL" "%offset68%")
si _osppPath86 est défini (définir _hook=%_hook86%&appeler :oh_extractdll "%_osppPath86%\OSPPC.DLL" "%offset86%")

si _osppPath68 est défini (si le fichier "%_osppPath68%\OSPPC.DLL" n'existe pas, définir ierror=1)
si _osppPath86 est défini (si le fichier "%_osppPath86%\OSPPC.DLL" n'existe pas, définir ierror=1)

si défini ierror (
définir ierror=Copie
aller à :oh_hookinstall_error
)

écho:
si _osppPath68 est défini (echo Renommage de OSPPC.DLL en sppcs.dll ["%_osppPath68%\sppcs.dll"])
si _osppPath86 est défini (echo Renommage de OSPPC.DLL en sppcs.dll ["%_osppPath86%\sppcs.dll"])
si _osppPath68 est défini (echo Extraction du crochet personnalisé %_hook68% vers ["%_osppPath68%\OSPPC.DLL"])
si _osppPath86 est défini (echo Extraction du crochet personnalisé %_hook86% vers ["%_osppPath86%\OSPPC.DLL"])

echo Création d'un lien symbolique pour sppcs.dll renommé ["%_hookPath%\sppcs.dll"]

:=================================================================================================================================================

:oh_hookinstall_error

si défini ierror (
définir erreur=1
appel :dk_color %Red% "Installation d'Ohook [Échec de %ierror%]"
écho:
appel :oh_checkapps
si les noms de vérification sont définis (
appel :dk_color %Blue% "Fermez [!checknames!] et réessayez."
Appel :dk_color %Blue% "Si le problème persiste, redémarrez votre machine à l'aide de l'option de redémarrage et réessayez."
) autre (
if /i not "%ierror%"=="Copy" call :dk_color %Blue% "Redémarrez votre machine en utilisant l'option de redémarrage et réessayez."
if /i "%ierror%"=="Copy" call :dk_color %Blue% "Si vous utilisez un antivirus tiers, vérifiez s'il bloque le script."
)
écho:
)

si non défini exhook si non défini ierror (
si défini hasherror (
définir erreur=1
définir ierror=1
appel :dk_color %Red% "Modification du hachage de sppcs.dll personnalisé [Échec]"
) autre (
modification du hachage de sppcs.dll personnalisé [Réussie]
)
)

quitter /b

:=================================================================================================================================================

:oh_setspp

définir isOspp=
si %winbuild% GEQ 9200 (
définir spp=SoftwareLicensingProduct
définir sps=SoftwareLicensingService
) autre (
définir isOspp=1
définir spp=Produit de protection des logiciels de bureau
définir sps=OfficeSoftwareProtectionService
)
si "%1"="14" (
définir isOspp=1
définir spp=Produit de protection des logiciels de bureau
définir sps=OfficeSoftwareProtectionService
)
quitter /b

:=================================================================================================================================================

:oh_process

pour %%# dans (%_oIds%) faire (

définir la clé=
définir _actid=
définir _lic=
définir _preview=
définir _Licence=%%#

echo %%# | find /i "2024" %nul% && (
Si le fichier « !_oLPath!\ProPlus2024PreviewVL_*.xrm-ms » existe, sinon, définissez _preview=-Preview
)
définir _prod=%%#!_preview!

appel :ohookdata getinfo !_prod!

si ce n'est pas "!key!"="" (
echo "!allapps!" | trouver /i "!_actid!" %nul1% || appelle :oh_installlic
si %oVer% n'est pas égal à 14, définir generickey=1
appel :dk_inskey "[!key!] [!_prod!] [!_lic!]"
) autre (
définir erreur=1
appel :dk_color %Red% "Vérification du produit dans le script [Clé Office %oVer%.0 !_prod! introuvable dans le script]"
appel :dk_color %Blue% "Assurez-vous d'utiliser la dernière version de MAS."
définir les correctifs=%fixes% %mas%
appel :dk_color %_Yellow% "%mas%"
)
)

Ajoutez la clé de registre SharedComputerLicensing si Retail Office C2R est installé sur un serveur Windows.
:: https://learn.microsoft.com/en-us/office/troubleshoot/office-suite-issues/click-to-run-office-on-terminal-server

si winserver est défini si _config est défini si existe "%_oLPath%\Word2019VL_KMS_Client_AE*.xrm-ms" (
echo %_oIds% | find /i "Retail" %nul1% && (
définir scaIsNeeded=1
reg add %_config% /v SharedComputerLicensing /t REG_SZ /d "1" /f %nul1%
« Ajout réussi de l'enregistrement SharedComputerLicensing [Nécessaire sur le serveur hébergeant un point de vente] »
)
)

quitter /b

:=================================================================================================================================================

:oh_processmsi

:: Traitement de la version MSI d'Office

appel :oh_reset
si "%1"="14" (
appel :dk_actids 59a52881-a989-479d-af46-f275c6370663
) autre (
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663
)

définir oVer=%1
for /f "skip=2 tokens=2*" %%a in ('"reg query %2\Common\InstallRoot /v Path" %nul6%') do (set "_oRoot=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %2\Common\ProductVersion /v LastProduct" %nul6%') do (set "_version=%%b")
si "%_oRoot:~-1%"="\" définir "_oRoot=%_oRoot:~0,-1%"

echo "%2" | find /i "Wow6432Node" %nul1% && set _oArch=x86
Si la variable `_oArch` n'est pas définie, alors `_oArch` est définie sur `x64`.
si "%osarch%"="x86" définir _oArch=x86

if /i "%_oArch%"=="x64" (set "_hookPath=%_oRoot%" & set "_hook=sppc64.dll")
si /i "%_oArch%"="x86" (définir "_hookPath=%_oRoot%" et définir "_hook=sppc32.dll")

appel :oh_ppcpath

appel :msiofficedata %2

écho:
echo Activation d'Office... [MSI ^| %_version% ^| %_oArch%]

si non défini _oIds (
définir erreur=1
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables, activation annulée...]"
quitter /b
)

si défini noOsppc (
appel :dk_color %Red% "Vérification de OSPPC.DLL [Introuvable. Activation annulée...]"
appel :dk_color %Bleu% "%_fixmsg%"
définir erreur=1
quitter /b
)

si %oVer%==14 si SingleImage défini (
vérification des produits installés [Produit SingleImage trouvé, la clé Professional Retail sera utilisée pour l'activation]
)

appel :oh_process
si défini isOspp (
appel :oh_hookinstall_ospp
) autre (
appel :oh_hookinstall
)

quitter /b

:=================================================================================================================================================

:oh_clearblock

:: Recherchez les traces du blocage de licence Office vNext/partagée/appareil et supprimez-les, car elles empêchent l'affichage d'autres licences.
:: https://learn.microsoft.com/en-us/office/troubleshoot/activation/reset-office-365-proplus-activation-state

définir _sidlist=
for /f "tokens=* delims=" %%a in ('%psc% "$p = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'; Get-ChildItem $p | ForEach-Object { $pi = (Get-ItemProperty """"$p\$($_.PSChildName)"""").ProfileImagePath; if ($pi -like '*\Users\*' -and (Test-Path """"$pi\NTUSER.DAT"""") -and -not ($_.PSChildName -match '\.bak$')) { Split-Path $_.PSPath -Leaf } }" %nul6%') do (if defined _sidlist (set _sidlist=!_sidlist! %%a) else (set _sidlist=%%a))

si non défini _sidlist (
for /f "delims=" %%a in ('%psc% "$explorerProc = Get-Process -Name explorer | Where-Object {$_.SessionId -eq (Get-Process -Id $pid).SessionId} | Select-Object -First 1; $sid = (gwmi -Query ('Select * From Win32_Process Where ProcessID=' + $explorerProc.Id)).GetOwnerSid().Sid; $sid" %nul6%') do (set _sidlist=%%a)
)

::==========================

:: Charger le registre des comptes utilisateurs non chargé

définir loadedsids=
définir alrloadedsids=

pour %%# dans (%_sidlist%) faire (
requête reg HKU\%%#\Software %nul% && (
appel set "alrloadedsids=%%alrloadedsids%% %%#"
) || (
pour /f "skip=2 tokens=2*" %%a dans ('"reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\%%#" /v ProfileImagePath" %nul6%') faire (
charge d'enregistrement HKU\%%# "%%b\NTUSER.DAT" %nul%
requête reg HKU\%%#\Software %nul% && (
appel set "loadedsids=%%loadedsids%% %%#"
) || (
déchargement régulier HKU\%%# %nul%
)
)
)
)

::==========================

définir "_sidlist=%loadedsids% %alrloadedsids%"

définir /un compteur=0
pour %%# dans (%_sidlist%), définir /a compteur += 1

si %compteur% EQU 0 (
définir erreur=1
appel :dk_color %Red% "Vérification du SID des comptes utilisateurs [Introuvable]"
quitter /b
)

si %compteur% GTR 10 (
appel :dk_color %Gray% "Vérification du nombre total de comptes utilisateurs [%counter%]"
)

::==========================

:: Supprimez les blocages de licence vNext/partagée/de périphérique qui peuvent empêcher l'activation d'ohook

définir vnextexist=
rmdir /s /q "%ProgramData%\Microsoft\Office\Licenses\" %nul%

pour %%x dans (15 16) faire (
pour %%# dans (%_sidlist%) faire (
reg query HKU\%%#\Software\Microsoft\Office\%%x.0\Common\Licensing /s %nul2% | findstr /i "CIDToLicenseIdsMapping LicenseIdToEmailMapping @" %nul% && set vnextexist=1
reg delete HKU\%%#\Software\Microsoft\Office\%%x.0\Common\Licensing /f %nul%

pour /f "skip=2 tokens=2*" %%a dans ('"reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\%%#" /v ProfileImagePath" %nul6%') faire (
rmdir /s /q "%%b\AppData\Local\Microsoft\Office\Licenses\" %nul%
rmdir /s /q "%%b\AppData\Local\Microsoft\Office\%%x.0\Licensing\" %nul%
)
)
reg delete "HKLM\SOFTWARE\Microsoft\Office\%%x.0\Common\Licensing" /f %nul%
reg delete "HKLM\SOFTWARE\Microsoft\Office\%%x.0\Common\Licensing" /f /reg:32 %nul%
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Office\%%x.0\Common\Licensing" /f %nul%
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Office\%%x.0\Common\Licensing" /f /reg:32 %nul%
)

:: Effacer vNext dans Office UWP

si défini o16uwpapplist (
pour %%# dans (%_sidlist%) faire (
pour /f "skip=2 tokens=2*" %%a dans ('"reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\%%#" /v ProfileImagePath" %nul6%') faire (
rmdir /s /q "%%b\AppData\Local\Packages\Microsoft.Office.Desktop_8wekyb3d8bbwe\LocalCache\Local\Microsoft\Office\Licenses\" %nul%
si le fichier "%%b\AppData\Local\Packages\Microsoft.Office.Desktop_8wekyb3d8bbwe\SystemAppData\Helium\User.dat" existe (
définir defname=DEFTEMP-%%#
reg load HKU\!defname! "%%b\AppData\Local\Packages\Microsoft.Office.Desktop_8wekyb3d8bbwe\SystemAppData\Helium\User.dat" %nul%
reg query HKU\!defname!\Software\Microsoft\Office\16.0\Common\Licensing /s %nul2% | findstr /i "CIDToLicenseIdsMapping LicenseIdToEmailMapping @" %nul% && set vnextexist=1
reg delete HKU\!defname!\Software\Microsoft\Office\16.0\Common\Licensing /f %nul%
reg décharger HKU\!defname! %nul%
)
)
)
)

si vnextexist est défini (
écho:
appel :dk_color %Gray% "Le compte Office connecté possède une licence d'abonnement."
appel :dk_color %Blue% "Si l'abonnement est actif, il remplace les autres méthodes d'activation."
appel :dk_color %Blue% "Si l'expiration est imminente, relancez le script d'activation après son expiration."
appel :dk_color2 %Blue% "Si le code a déjà expiré et que l'activation échoue, obtenez de l'aide ici - " %_Yellow% " %mas%troubleshoot"
écho:
)

:: Clear SharedComputerLicensing pour les ordinateurs de bureau
:: https://learn.microsoft.com/en-us/deployoffice/overview-shared-computer-activation

si non défini scaIsNeeded (
reg delete HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration /v SharedComputerLicensing /f %nul%
reg delete HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration /v SharedComputerLicensing /f /reg:32 %nul%
reg delete HKLM\SOFTWARE\Microsoft\Office\15.0\ClickToRun\Configuration /v SharedComputerLicensing /f %nul%
reg delete HKLM\SOFTWARE\Microsoft\Office\15.0\ClickToRun\Configuration /v SharedComputerLicensing /f /reg:32 %nul%
)

:: Licence claire basée sur l'appareil
:: https://learn.microsoft.com/en-us/deployoffice/device-based-licensing

for /f %%# in ('reg query "%o16c2r_reg%\Configuration" /f *.DeviceBasedLicensing %nul6% ^| findstr REG_') do reg delete "%o16c2r_reg%\Configuration" /v %%# /f %nul%

:: Supprimer la clé de registre OEM
:: https://support.microsoft.com/en-us/office/office-repeatedly-prompts-you-to-activate-on-a-new-pc-a9a6b05f-f6ce-4d1f-8d49-eb5007b64ba1

pour %%# dans (15 16) faire (
reg delete "HKLM\SOFTWARE\Microsoft\Office\%%#.0\Common\OEM" /f %nul%
reg delete "HKLM\SOFTWARE\Microsoft\Office\%%#.0\Common\OEM" /f /reg:32 %nul%
)

reg delete "HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\Policies\0ff1ce15-a989-479d-af46-f275c6370663" /f %nul%
reg delete "HKU\S-1-5-20\Software\Microsoft\OfficeSoftwareProtectionPlatform\Policies\0ff1ce15-a989-479d-af46-f275c6370663" /f %nul%
reg delete "HKU\S-1-5-20\Software\Microsoft\OfficeSoftwareProtectionPlatform\Policies\59a52881-a989-479d-af46-f275c6370663" /f %nul%

echo Suppression des blocages de licence Office [Suppression réussie de tous les comptes d'utilisateurs %counter%]

::==========================

:: Certains produits destinés au commerce tentent de valider la licence et peuvent afficher une bannière « Un problème est survenu lors de la vérification de l'état de la licence de cet appareil. »
:: L'entrée du registre de résilience peut ignorer cette vérification

définir defname=DEFTEMP-%aléatoire%
for /f "skip=2 tokens=2*" %%a in ('"reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /v Default" %nul6%') do call set "defdat=%%b"

si défini o16c2r si défini ohookact (
s'il existe "%defdat%\NTUSER.DAT" (
reg charger HKU\%defname% "%defdat%\NTUSER.DAT" %nul%
requête reg HKU\%defname%\Software %nul% && (
reg add HKU\%defname%\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency /v "TimeOfLastHeartbeatFailure " /t REG_SZ /d "2040-01-01T00:00:00Z" /f %nul%
)
reg décharger HKU\%defname% %nul%
)

pour %%# dans (%_sidlist%) faire (
reg delete HKU\%%#\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency /f %nul%
reg add HKU\%%#\Software\Microsoft\Office\16.0\Common\Licensing\Resiliency /v "TimeOfLastHeartbeatFailure" /t REG_SZ /d "2040-01-01T00:00:00Z" /f %nul%
)
echo Ajout de l'entrée de registre pour ignorer la vérification de licence [Ajouté avec succès à tous les %counter% ^& futurs nouveaux comptes d'utilisateur]
)

::==========================

:: Décharger le registre des comptes utilisateurs chargé

pour %%# dans (%loadedsids%) faire (
déchargement régulier HKU\%%# %nul%
)

quitter /b

:=================================================================================================================================================

:: Désinstaller les autres clés / clés de grâce

:oh_uninstkey

définir upk_result=0
appel :dk_actid 0ff1ce15-a989-479d-af46-f275c6370663

si "%_actprojvis%"=="1" (
for /f "delims=" %%a in ('%psc% "Get-WmiObject -Query 'SELECT ID, Description, LicenseFamily FROM %spp% WHERE ApplicationID=''0ff1ce15-a989-479d-af46-f275c6370663'' AND PartialProductKey IS NOT NULL' | Where-Object { $_.LicenseFamily -notmatch 'Project' -and $_.LicenseFamily -notmatch 'Visio' } | Select-Object -ExpandProperty ID" %nul6%') do call set "_allactid=%%a !_allactid!"
for /f "delims=" %%a in ('%psc% "Get-WmiObject -Query 'SELECT ID, Description, LicenseFamily FROM %spp% WHERE ApplicationID=''0ff1ce15-a989-479d-af46-f275c6370663'' AND PartialProductKey IS NOT NULL' | Where-Object { '!_allactid!' -contains $_.ID -and ($_.LicenseFamily -match 'Project' -or $_.LicenseFamily -match 'Visio') } | Select-Object -ExpandProperty ID" %nul6%') do call set "_allactid=%%a !_allactid!"
)

pour %%# dans (%apps%) faire (
echo "%_allactid%" | find /i "%%#" %nul1% || (

si %_wmic% EQU 1 wmic path %spp% où ID='%%#' appel UninstallProductKey %nul%
si %_wmic% EQU 0 %psc% "$null=([WMI]'%spp%=''%%#''').UninstallProductKey()" %nul%

si !errorlevel!==0 (
définir upk_result=1
) autre (
définir erreur=1
définir upk_result=2
)
)
)

si défini ohookact si non %upk_result%==0 echo:
if %upk_result%==1 echo Désinstallation des autres clés/clés de grâce [Réussie]
si %upk_result%==2 (
appel :dk_color %Red% "Désinstallation des autres clés/clés de grâce [Échec]"
si non défini afficherfix (
appel :dk_color %Bleu% "%_fixmsg%"
écho:
définir showfix=1
)
)
quitter /b

:=================================================================================================================================================

:: Actualiser les licences Windows Insider Preview
:: Cela est requis dans les versions Insider, sinon Office risque de ne pas s'activer.

:oh_licrefresh

si le fichier "%SysPath%\spp\store_test\2.0\tokens.dat" existe (
%psc% "Stop-Service sppsvc -force; $sls = Get-WmiObject SoftwareLicensingService; $f=[IO.File]::ReadAllText('!_batp!') -split ':xrm\:.*';. ([scriptblock]::Create($f[1])); ReinstallLicenses" %nul%
if !errorlevel! NEQ 0 %psc% "$sls = Get-WmiObject SoftwareLicensingService; $f=[IO.File]::ReadAllText('!_batp!') -split ':xrm\:.*';. ([scriptblock]::Create($f[1])); ReinstallLicenses" %nul%
)
quitter /b

:=================================================================================================================================================

:: Vérifier les applications Office en cours d'exécution et notifier l'utilisateur

:oh_checkapps

définir checkapps=
définir checknames=
for /f "tokens=1" %%i in ('tasklist ^| findstr /I ".exe" %nul6%') do (set "checkapps=!checkapps! -%%i-")

pour %%# dans (
Accès_msaccess.exe
Excel_excel.exe
Groove_groove.exe
Lync_lync.exe
OneNote_onenote.exe
Outlook_outlook.exe
PowerPoint_powerpnt.exe
Projet_winproj.exe
Publisher_mspub.exe
Visio_visio.exe
Word_winword.exe
Lime_lime.exe
) faire (
pour /f "tokens=1-2 delims=_" %%A dans ("%%#") faire (
echo !checkapps! | find /i "-%%B-" %nul1% && (if defined checknames (set "checknames=!checknames! %%A") else (set "checknames=%%A"))
)
)
quitter /b

:=================================================================================================================================================

:: 1ère colonne = Numéro de version d'Office
:: 2e colonne = ID d'activation
:: 3e colonne = Pour Office 2013 et versions ultérieures, les clés générées sont listées. Pour Office 2010, les clés bloquées provenant d'Internet sont listées.
Pour Office 2013 et versions ultérieures, l'ordre de priorité des clés est le suivant : Retail:TB:Sub > Retail > OEM:NONSLP > Volume:MAK > Volume:GVLK
Pour Office 2010, la priorité des clés est la suivante : Vente au détail > Volume :MAK
:: 4e colonne = Dernière partie de la description de la licence
:: 5e colonne = Édition
:: 6e colonne = Identifiants des autres éditions si elles font partie du même produit principal (À titre indicatif uniquement)
:: Séparateur = "_"

::===============

Nous n'avons trouvé aucune clé d'activation (bloquée ou générique, peu importe) pour ces produits Office 2010. Si vous en possédez une, merci de nous la communiquer.

14_4eaff0d0-c6cb-4187-94f3-c7656d49a0aa_Commerce de détail________ExcelR_[HSExcelR]
14_7004b7f0-6407-4f45-8eac-966e5f868bde_Retail________GrooveR
14_133c8359-4e93-4241-8118-30bb18737ea0_Retail________PowerPointR_[HSPowerPointR]
14_db3bbc9c-ce52-41d1-a46f-1a1d68059119_Retail________WordR_[HSWordR]
14_dbe3aee0-5183-4ff7-8142-66050173cb01_Retail________SmallBusBasicsR_[SmallBusBasicsMSDNR]

Ces programmes d'installation ne sont pas disponibles publiquement, donc ce n'est pas grave si nous n'avons pas leurs clés.

14_19316117-30a8-4773-8fd9-7f7231f4e060_SubPrepid_____HomeBusinessSubR
14_4d06f72e-fd50-4bc2-a24b-d448d7f17ef2_SubPrepid_____ProjectProSubR
14_e98ef0c0-71c4-42ce-8305-287d8721e26c_SubPrepid_____ProPlusSubR
14_14f5946a-debc-4716-babc-7e2c240fec08_Retail________MondoR
14_533b656a-4425-480b-8e30-1a2358898350_MAK__________MondoVL

:ohookdata

définir f=
pour %%# dans (
:: Office 2010
14_4d463c2c-0505-4626-8cdb-a4da82e2d8ed_7KTYC-XR43P-C3MRW-BJKFD-XB%f%YPG_Retail________AccessR
14_745fb377-0a59-4ca9-b9a9-c359557a2c4e_7XHPQ-BQMYG-YBP49-CY8B2-T8%f%CGQ_ByPass________AccessRuntimeR
14_95ab3ec8-4106-4f9d-b632-03c019d1d23f_89RTQ-MT4GK-6CPTX-WWP7C-J9%f%KXR_MAK___________AccessVL
14_71dc86ff-f056-40d0-8ffb-9592705c9b76_39TRR-C2F37-9WYJ2-MJQXH-B9%f%38K_MAK___________ExcelVL
14_fdad0dfa-417d-4b4f-93e4-64ea8867b7fd_RCGT3-FPQDV-H49CD-PPDBF-TH%f%47G_MAK___________GrooveVL
14_7b7d1f17-fdcb-4820-9789-9bec6e377821_3YR9B-D9W79-BY66R-R8XYP-QY%f%YYY_Retail________HomeBusinessR_[HomeBusinessDemoR]
14_09e2d37e-474b-4121-8626-58ad9be5776f_3X43R-HHHXX-FRHRW-2M2WJ-8V%f%PHD_Retail________HomeStudentR_[HomeStudentDemoR]
14_ef1da464-01c8-43a6-91af-e4e5713744f9_XDGJY-KFHW9-JWX9X-YM4GW-GC%f%8WR_Retail________InfoPathR
14_85e22450-b741-430c-a172-a37962c938af_6GKT2-KMJPK-4RRBF-8VQKB-JB%f%6G6_MAK___________InfoPathVL
14_3f7aa693-9a7e-44fc-9309-bb3d8e604925_2TG3P-9DB76-4YT99-8RXGD-CW%f%XBP_Retail________OneNoteR_[HSOneNoteR]
14_6860b31f-6a67-48b8-84b9-e312b3485c4b_CV64P-F4VRH-BJ33D-PH6MR-X6%f%9RY_MAK___________OneNoteVL
14_fbf4ac36-31c8-4340-8666-79873129cf40_9D8FR-7GYBW-4YG8M-V36JK-VD%f%7CM_Retail________OutlookR
14_a9aeabd8-63b8-4079-a28e-f531807fd6b8_J8C9M-YXMH2-9CX44-2C3YG-V7%f%692_MAK___________OutlookVL
14_acb51361-c0db-4895-9497-1831c41f31a6_GMBWM-WVX26-7WHV4-DB43D-WV%f%DY2_Retail________PersonalR_[PersonalDemoR,PersonalPrepaidR]
14_38252940-718c-4aa6-81a4-135398e53851_HPBQP-RJHDR-Q3472-PT9Q6-PB%f%B72_MAK___________PowerPointVL
14_8b559c37-0117-413e-921b-b853aeb6e210_367X9-9HP9R-TKHY6-DH4QH-K9%f%PY7_Retail________ProfessionalR_[ProfessionalAcadR,ProfessionalDemoR,OEM-SingleImage]
14_725714d7-d58f-4d12-9fa8-35873c6f7215_6JD4G-KRW3J-48MGV-DM6FC-T9%f%WKR_Retail________ProjectProR_[ProjectProMSDNR]
14_1cf57a59-c532-4e56-9a7d-ffa2fe94b474_3XDTH-MMGJ6-F9MKX-THP8D-G9%f%BP7_MAK___________ProjectProVL
14_688f6589-2bd9-424e-a152-b13f36aa6de1_2W96V-RTQ9R-2BPVT-PT8H9-MV%f%68T_Retail________ProjectStdR
14_11b39439-6b93-4642-9570-f2eb81be2238_4DTT4-D4MKX-23KFH-JKR6T-YK%f%G2J_MAK___________ProjectStdVL
14_71af7e84-93e6-4363-9b69-699e04e74071_2J9H6-H4D3G-PCXD2-96XVM-TR%f%R73_Retail________ProPlusR_[ProPlusAcadR,ProPlusMSDNR,Sub4R]
14_fdf3ecb9-b56f-43b2-a9b8-1b48b6bae1a7_6CD6C-9R8PB-T2D9Y-8RKKX-W7%f%DFK_MAK___________ProPlusVL_[ProPlusAcadVL]
14_98677603-a668-4fa4-9980-3f1f05f78f69_CTRJP-P72VV-JBF8Y-4W6WW-HX%f%HVG_Retail________ÉditeurR
14_3d014759-b128-4466-9018-e80f6320d9d0_32YG9-3VX77-YXJVV-PRVFW-TT%f%8BV_MAK___________PublisherVL
14_8090771e-d41a-4482-929e-de87f1f47e46_7VKXH-9BWCG-RPTBB-JBRV3-GR%f%HYC_MAK___________SmallBusBasicsVL
14_b78df69e-0966-40b1-ae85-30a5134dedd0_H48K6-FB4Y6-P83GH-9J7XG-HD%f%KKX_ByPass________SPDR
14_b6d2565c-341d-4768-ad7d-addbe00bb5ce_W3BTX-H6BW7-Q6DFW-BXFFY-8R%f%VJP_Retail________StandardR_[StandardMSDNR][KeyisforMSDNR]
14_1f76e346-e0be-49bc-9954-70ec53a4fcfe_2XTQP-GDR7C-GTXPC-6W6PV-4R%f%XGC_MAK___________StandardVL_[StandardAcadVL]
14_2745e581-565a-4670-ae90-6bf7c57ffe43_VXHHB-W7HBD-7M342-RJ7P8-CH%f%BD6_ByPass________StarterR
14_66cad568-c2dc-459d-93ec-2f3cb967ee34_2RDPT-WPYQM-C2WXF-BTPDW-2J%f%2HM_Retail________VisioSIR_Prem[Pro,Std]
14_36756cb8-8e69-4d11-9522-68899507cd6a_7PKFT-X2MKQ-GT6X2-8CB2W-CH%f%C9K_MAK___________VisioSIVL_Prem[Pro,Std]
14_98d4050e-9c98-49bf-9be1-85e12eb3ab13_6J3XK-DFKGK-X373V-QJHYM-V3%f%FC2_MAK___________WordVL
:: Office 2013
15_ab4d047b-97cf-4126-a69f-34df08e2f254_B7RFY-7NXPK-Q4342-Y9X2H-3J%f%X4X_Retail________AccessRetail
15_259de5be-492b-44b3-9d78-9645f848f7b0_X3XNB-HJB7K-66THH-8DWQ3-XH%f%GJP_Bypass________AccessRuntimeRetail
15_4374022d-56b8-48c1-9bb7-d8f2fc726343_9MF9G-CN32B-HV7XT-9XJ8T-9K%f%VF4_MAK__________AccessVolume
15_1b1d9bd5-12ea-4063-964c-16e7e87d6e08_NT889-MBH4X-8MD4H-X8R2D-WQ%f%HF8_Retail________ExcelRetail
15_ac1ae7fd-b949-4e04-a330-849bc40638cf_Y3N36-YCHDK-XYWBG-KYQVV-BD%f%TJ2_MAK___________ExcelVolume
15_cfaf5356-49e3-48a8-ab3c-e729ab791250_BMK4W-6N88B-BP9QR-PHFCK-MG%f%7GF_Retail________GrooveRetail
15_4825ac28-ce41-45a7-9e6e-1fed74057601_RN84D-7HCWY-FTCBK-JMXWM-HT%f%7GJ_MAK___________GrooveVolume
15_c02fb62e-1cd5-4e18-ba25-e0480467ffaa_2WQNF-GBK4B-XVG6F-BBMX7-M4%f%F2Y_OEM-Perp______HomeBusinessPipcRetail
15_a2b90e7a-a797-4713-af90-f0becf52a1dd_YWD4R-CNKVT-VG8VJ-9333B-RC%f%W9F_Subscription__HomeBusinessRetail
15_1fdfb4e4-f9c9-41c4-b055-c80daf00697d_B92QY-NKYFQ-6KTKH-VWW2Q-3P%f%B3B_OEM-ARM_______HomeStudentARMRetail
15_ebef9f05-5273-404a-9253-c5e252f50555_QPG96-CNT7M-KH36K-KY4HQ-M7%f%TBR_OEM-ARM_______HomeStudentPlusARMRetail
15_f2de350d-3028-410a-bfae-283e00b44d0e_6WW3N-BDGM9-PCCHD-9QPP9-P3%f%4QG_Subscription__HomeStudentRetail
15_44984381-406e-4a35-b1c3-e54f499556e2_RV7NQ-HY3WW-7CKWH-QTVMW-29%f%VHC_Retail________InfoPathRetail
15_9e016989-4007-42a6-8051-64eb97110cf2_C4TGN-QQW6Y-FYKXC-6WJW7-X7%f%3VG_MAK___________InfoPathVolume
15_9103f3ce-1084-447a-827e-d6097f68c895_6MDN4-WF3FV-4WH3Q-W699V-RG%f%CMY_PrepidBypass__LyncAcademicRetail
15_ff693bf4-0276-4ddb-bb42-74ef1a0c9f4d_N42BF-CBY9F-W2C7R-X397X-DY%f%FQW_PrepidBypass__LyncEntryRetail
15_fada6658-bfc6-4c4e-825a-59a89822cda8_89P23-2NK2R-JXM2M-3Q8R8-BW%f%M3Y_Retail________LyncRetail
15_e1264e10-afaf-4439-a98b-256df8bb156f_3WKCD-RN489-4M7XJ-GJ2GQ-YB%f%FQ6_MAK___________LyncVolume
15_69ec9152-153b-471a-bf35-77ec88683eae_VNWHF-FKFBW-Q2RGD-HYHWF-R3%f%HH2_Subscription__MondoRetail
15_f33485a0-310b-4b72-9a0e-b1d605510dbd_2YNYQ-FQMVG-CB8KW-6XKYD-M7%f%RRJ_MAK___________MondoVolume
15_3391e125-f6e4-4b1e-899c-a25e6092d40d_4TGWV-6N9P6-G2H8Y-2HWKB-B4%f%FF4_Bypass________OneNoteFreeRetail
15_8b524bcc-67ea-4876-a509-45e46f6347e8_3KXXQ-PVN2C-8P7YY-HCV88-GV%f%GQ6_Retail________OneNoteRetail
15_b067e965-7521-455b-b9f7-c740204578a2_JDMWF-NJC7B-HRCHY-WFT8G-BP%f%XD9_MAK___________OneNoteVolume
15_12004b48-e6c8-4ffa-ad5a-ac8d4467765a_9N4RQ-CF8R2-HBVCB-J3C9V-94%f%P4D_Retail________OutlookRetail
15_8d577c50-ae5e-47fd-a240-24986f73d503_HNG29-GGWRG-RFC8C-JTFP4-2J%f%9FH_MAK___________OutlookVolume
15_5aab8561-1686-43f7-9ff5-2c861da58d17_9CYB3-NFMRW-YFDG6-XC7TF-BY%f%36J_OEM-Perp______PersonalPipcRetail
15_17e9df2d-ed91-4382-904b-4fed6a12caf0_2NCQJ-MFRMH-TXV83-J7V4C-RV%f%RWC_Retail________PersonalRetail
15_31743b82-bfbc-44b6-aa12-85d42e644d5b_HVMN2-KPHQH-DVQMK-7B3CM-FG%f%BFC_Retail________PowerPointRetail
15_e40dcb44-1d5c-4085-8e8f-943f33c4f004_47DKN-HPJP7-RF9M3-VCYT2-TM%f%Q4G_MAK___________PowerPointVolume
15_064383fa-1538-491c-859b-0ecab169a0ab_N3QMM-GKDT3-JQGX6-7X3MQ-4G%f%BG3_Retail________ProPlusRetail
15_2b88c4f2-ea8f-43cd-805e-4d41346e18a7_QKHNX-M9GGH-T3QMW-YPK4Q-QR%f%P9V_MAK___________ProPlusVolume
15_4e26cac1-e15a-4467-9069-cb47b67fe191_CF9DD-6CNW2-BJWJQ-CVCFX-Y7%f%TXD_OEM-Perp______ProfessionalPipcRetail
15_44bc70e2-fb83-4b09-9082-e5557e0c2ede_MBQBN-CQPT6-PXRMC-TYJFR-3C%f%8MY_Retail________ProfessionalRetail
15_2f72340c-b555-418d-8b46-355944fe66b8_WPY8N-PDPY4-FC7TF-KMP7P-KW%f%YFY_Subscription__ProjectProRetail
15_ed34dc89-1c27-4ecd-8b2f-63d0f4cedc32_WFCT2-NBFQ7-JD7VV-MFJX6-6F%f%2CM_MAK___________ProjectProVolume
15_58d95b09-6af6-453d-a976-8ef0ae0316b1_NTHQT-VKK6W-BRB87-HV346-Y9%f%6W8_Subscription__ProjectStdRetail
15_2b9e4a37-6230-4b42-bee2-e25ce86c8c7a_3CNQX-T34TY-99RH4-C4YD2-KW%f%YGV_MAK___________VolumeStandardDuProjet
15_c3a0814a-70a4-471f-af37-2313a6331111_TWNCJ-YR84W-X7PPF-6DPRP-D6%f%7VC_Retail________ÉditeurRetail
15_38ea49f6-ad1d-43f1-9888-99a35d7c9409_DJPHV-NCJV6-GWPT6-K26JX-C7%f%GX6_MAK___________ÉditeurVolume
15_ba3e3833-6a7e-445a-89d0-7802a9a68588_3NY6J-WHT3F-47BDV-JHF36-23%f%43W_PrepidBypass__SPDRetail
15_32255c0a-16b4-4ce2-b388-8a4267e219eb_V6VWN-KC2HR-YYDD6-9V7HQ-7T%f%7VP_Retail________StandardRetail
15_a24cca51-3d54-4c41-8a76-4031f5338cb2_9TN6B-PCYH4-MCVDQ-KT83C-TM%f%Q7T_MAK___________StandardVolume
15_a56a3b37-3a35-4bbb-a036-eee5f1898eee_NVK2G-2MY4G-7JX2P-7D6F2-VF%f%QBR_Subscription__VisioProRetail
15_3e4294dd-a765-49bc-8dbd-cf8b62a4bd3d_YN7CF-XRH6R-CGKRY-GKPV3-BG%f%7WF_MAK___________VisioProVolume
15_980f9e3e-f5a8-41c8-8596-61404addf677_NCRB7-VP48F-43FYY-62P3R-36%f%7WK_Subscription__VisioStdRetail
15_44a1f6ff-0876-4edb-9169-dbb43101ee89_RX63Y-4NFK2-XTYC8-C6B3W-YP%f%XPJ_MAK___________VisioStdVolume
15_191509f2-6977-456f-ab30-cf0492b1e93a_NB77V-RPFQ6-PMMKQ-T87DV-M4%f%D84_Retail________WordRetail
15_9cedef15-be37-4ff0-a08a-13a045540641_RPHPB-Y7NC4-3VYFM-DW7VD-G8%f%YJ8_MAK___________WordVolume
:: Office 365 - Version 15.0
15_742178ed-6b28-42dd-b3d7-b7c0ea78741b_Y9NF9-M2QWD-FF6RJ-QJW36-RR%f%F2T_SubTest_______O365BusinessRetail
15_a96f8dae-da54-4fad-bdc6-108da592707a_3NMDC-G7C3W-68RGP-CB4MH-4C%f%XCH_SubTest1______O365HomePremRetail
15_e3dacc06-3bc2-4e13-8e59-8e05f3232325_H8DN8-Y2YP3-CR9JT-DHDR9-C7%f%GP3_Subscription2_O365ProPlusRetail
15_0bc1dae4-6158-4a1c-a893-807665b934b2_2QCNB-RMDKJ-GC8PB-7QGQV-7Q%f%TQJ_Subscription2_O365SmallBusPremRetail
:: Office 365 - Version 16.0
16_dabaa1f2-109b-496d-bf49-1536cc862900_3HYJN-9KG99-F8VG9-V3DT8-JF%f%MHV_Subscription__O365AppsBasicRetail
16_742178ed-6b28-42dd-b3d7-b7c0ea78741b_Y9NF9-M2QWD-FF6RJ-QJW36-RR%f%F2T_SubTest_______O365BusinessRetail
16_2f5c71b4-5b7a-4005-bb68-f9fac26f2ea3_W62NQ-267QR-RTF74-PF2MH-JQ%f%MTH_Subscription__O365EduCloudRetail
16_a96f8dae-da54-4fad-bdc6-108da592707a_3NMDC-G7C3W-68RGP-CB4MH-4C%f%XCH_SubTest1______O365HomePremRetail
16_e3dacc06-3bc2-4e13-8e59-8e05f3232325_H8DN8-Y2YP3-CR9JT-DHDR9-C7%f%GP3_Subscription2_O365ProPlusRetail
16_0bc1dae4-6158-4a1c-a893-807665b934b2_2QCNB-RMDKJ-GC8PB-7QGQV-7Q%f%TQJ_Subscription2_O365SmallBusPremRetail
:: Office 2016
16_bfa358b0-98f1-4125-842e-585fa13032e6_WHK4N-YQGHB-XWXCC-G3HYC-6J%f%F94_Retail________AccessRetail
16_9d9faf9e-d345-4b49-afce-68cb0a539c7c_RNB7V-P48F4-3FYY6-2P3R3-63%f%BQV_PrepidBypass__AccessRuntimeRetail
16_3b2fa33f-cd5a-43a5-bd95-f49f3f546b0b_JJ2Y4-N8KM3-Y8KY3-Y22FR-R3%f%KVK_MAK__________AccessVolume
16_424d52ff-7ad2-4bc7-8ac6-748d767b455d_RKJBN-VWTM2-BDKXX-RKQFD-JT%f%YQ2_Retail________ExcelRetail
16_685062a7-6024-42e7-8c5f-6bb9e63e697f_FVGNR-X82B2-6PRJM-YT4W7-8H%f%V36_MAK___________ExcelVolume
16_c02fb62e-1cd5-4e18-ba25-e0480467ffaa_2WQNF-GBK4B-XVG6F-BBMX7-M4%f%F2Y_OEM-Perp______HomeBusinessPipcRetail
16_86834d00-7896-4a38-8fae-32f20b86fa2b_HM6FM-NVF78-KV9PM-F36B8-D9%f%MXD_Commerce de détail________AccueilCommerceCommerce de détail
16_090896a0-ea98-48ac-b545-ba5da0eb0c9c_PBQPJ-NC22K-69MXD-KWMRF-WF%f%G77_OEM-ARM_______HomeStudentARMRetail
16_6bbe2077-01a4-4269-bf15-5bf4d8efc0b2_6F2NY-7RTX4-MD9KM-TJ43H-94%f%TBT_OEM-ARM_______HomeStudentPlusARMRetail
16_c28acdb8-d8b3-4199-baa4-024d09e97c99_PNPRV-F2627-Q8JVC-3DGR9-WT%f%YRK_Retail________HomeStudentRetail
16_e2127526-b60c-43e0-bed1-3c9dc3d5a468_YWD4R-CNKVT-VG8VJ-9333B-RC%f%3B8_Retail________HomeStudentVNextRetail
16_69ec9152-153b-471a-bf35-77ec88683eae_VNWHF-FKFBW-Q2RGD-HYHWF-R3%f%HH2_Subscription__MondoRetail
16_2cd0ea7e-749f-4288-a05e-567c573b2a6c_FMTQQ-84NR8-2744R-MXF4P-PG%f%YR3_MAK___________MondoVolume
16_436366de-5579-4f24-96db-3893e4400030_XYNTG-R96FY-369HX-YFPHY-F9%f%CPM_Bypass________OneNoteFreeRetail
16_83ac4dd9-1b93-40ed-aa55-ede25bb6af38_FXF6F-CNC26-W643C-K6KB7-6X%f%XW3_Retail________OneNoteRetail
16_23b672da-a456-4860-a8f3-e062a501d7e8_9TYVN-D76HK-BVMWT-Y7G88-9T%f%PPV_MAK___________OneNoteVolume
16_5a670809-0983-4c2d-8aad-d3c2c5b7d5d1_7N4KG-P2QDH-86V9C-DJFVF-36%f%9W9_Retail________OutlookRetail
16_50059979-ac6f-4458-9e79-710bcb41721a_7QPNR-3HFDG-YP6T9-JQCKQ-KK%f%XXC_MAK___________OutlookVolume
16_5aab8561-1686-43f7-9ff5-2c861da58d17_9CYB3-NFMRW-YFDG6-XC7TF-BY%f%36J_OEM-Perp______PersonalPipcRetail
16_a9f645a1-0d6a-4978-926a-abcb363b72a6_FT7VF-XBN92-HPDJV-RHMBY-6V%f%KBF_Retail________PersonalRetail
16_f32d1284-0792-49da-9ac6-deb2bc9c80b6_N7GCB-WQT7K-QRHWG-TTPYD-7T%f%9XF_Retail________PowerPointRetail
16_9b4060c9-a7f5-4a66-b732-faf248b7240f_X3RT9-NDG64-VMK2M-KQ6XY-DP%f%FGV_MAK___________PowerPointVolume
16_de52bd50-9564-4adc-8fcb-a345c17f84f9_GM43N-F742Q-6JDDK-M622J-J8%f%GDV_Retail________ProPlusRetail
16_c47456e3-265d-47b6-8ca0-c30abbd0ca36_FNVK8-8DVCJ-F7X3J-KGVQB-RC%f%2QY_MAK___________ProPlusVolume
16_4e26cac1-e15a-4467-9069-cb47b67fe191_CF9DD-6CNW2-BJWJQ-CVCFX-Y7%f%TXD_OEM-Perp______ProfessionalPipcRetail
16_d64edc00-7453-4301-8428-197343fafb16_NXFTK-YD9Y7-X9MMJ-9BWM6-J2%f%QVH_Retail________ProfessionalRetail
16_2f72340c-b555-418d-8b46-355944fe66b8_WPY8N-PDPY4-FC7TF-KMP7P-KW%f%YFY_Subscription__ProjectProRetail
16_82f502b5-b0b0-4349-bd2c-c560df85b248_PKC3N-8F99H-28MVY-J4RYY-CW%f%GDH_MAK___________ProjectProVolume
16_16728639-a9ab-4994-b6d8-f81051e69833_JBNPH-YF2F7-Q9Y29-86CTG-C9%f%YGV_MAKC2R________ProjectProXVolume
16_58d95b09-6af6-453d-a976-8ef0ae0316b1_NTHQT-VKK6W-BRB87-HV346-Y9%f%6W8_Subscription__ProjectStdRetail
16_82e6b314-2a62-4e51-9220-61358dd230e6_4TGWV-6N9P6-G2H8Y-2HWKB-B4%f%G93_MAK___________ProjectStdVolume
16_431058f0-c059-44c5-b9e7-ed2dd46b6789_N3W2Q-69MBT-27RD9-BH8V3-JT%f%2C8_MAKC2R________ProjectStdXVolume
16_6e0c1d99-c72e-4968-bcb7-ab79e03e201e_WKWND-X6G9G-CDMTV-CPGYJ-6M%f%VBF_Retail________ÉditeurRetail
16_fcc1757b-5d5f-486a-87cf-c4d6dedb6032_9QVN2-PXXRX-8V4W8-Q7926-TJ%f%GD8_MAK___________ÉditeurVolume
16_9103f3ce-1084-447a-827e-d6097f68c895_6MDN4-WF3FV-4WH3Q-W699V-RG%f%CMY_PrepidBypass__SkypeServiceBypassRetail
16_971cd368-f2e1-49c1-aedd-330909ce18b6_4N4D8-3J7Y3-YYW7C-73HD2-V8%f%RHY_PrepidBypass__SkypeforBusinessEntryRetail
16_418d2b9f-b491-4d7f-84f1-49e27cc66597_PBJ79-77NY4-VRGFG-Y8WYC-CK%f%CRC_Retail________SkypeforBusinessRetail
16_03ca3b9a-0869-4749-8988-3cbc9d9f51bb_DMTCJ-KNRKR-JV8TQ-V2CR2-VF%f%TFH_MAK___________SkypeforBusinessVolume
16_4a31c291-3a12-4c64-b8ab-cd79212be45e_2FPWN-4H6CM-KD8QQ-8HCHC-P9%f%XYW_Retail________StandardRetail
16_0ed94aac-2234-4309-ba29-74bdbb887083_WHGMQ-JNMGT-MDQVF-WDR69-KQ%f%BWC_MAK___________Volume standard
16_a56a3b37-3a35-4bbb-a036-eee5f1898eee_NVK2G-2MY4G-7JX2P-7D6F2-VF%f%QBR_Subscription__VisioProRetail
16_295b2c03-4b1c-4221-b292-1411f468bd02_NRKT9-C8GP2-XDYXQ-YW72K-MG%f%92B_MAK___________VisioProVolume
16_0594dc12-8444-4912-936a-747ca742dbdb_G98Q2-B6N77-CFH9J-K824G-XQ%f%CC4_MAKC2R________VisioProXVolume
16_980f9e3e-f5a8-41c8-8596-61404addf677_NCRB7-VP48F-43FYY-62P3R-36%f%7WK_Subscription__VisioStdRetail
16_44151c2d-c398-471f-946f-7660542e3369_XNCJB-YY883-JRW64-DPXMX-JX%f%CR6_MAK__________VisioStdVolume
16_1d1c6879-39a3-47a5-9a6d-aceefa6a289d_B2HTN-JPH8C-J6Y6V-HCHKB-43%f%MGT_MAKC2R________VisioStdXVolume
16_cacaa1bf-da53-4c3b-9700-11738ef1c2a5_P8K82-NQ7GG-JKY8T-6VHVY-88%f%GGD_Retail________WordRetail
16_c3000759-551f-4f4a-bcac-a4b42cbf1de2_YHMWC-YN6V9-WJPXD-3WQKP-TM%f%VCV_MAK___________WordVolume
:: Office 2019
16_518687bd-dc55-45b9-8fa6-f918e1082e83_WRYJ6-G3NP7-7VH94-8X7KP-JB%f%7HC_Retail________Access2019Retail
16_385b91d6-9c2c-4a2e-86b5-f44d44a48c5f_6FWHX-NKYXK-BW34Q-7XC9F-Q9%f%PX7_MAK-AE________Access2019Volume
16_22e6b96c-1011-4cd5-8b35-3c8fb6366b86_FGQNJ-JWJCG-7Q8MG-RMRGJ-9T%f%QVF_PrepidBypass__AccessRuntime2019Retail
16_c201c2b7-02a1-41a8-b496-37c72910cd4a_KBPNW-64CMM-8KWCB-23F44-8B%f%7HM_Retail________Excel2019Retail
16_05cb4e1d-cc81-45d5-a769-f34b09b9b391_8NT4X-GQMCK-62X4P-TW6QP-YK%f%PYF_MAK-AE________Excel2019Volume
16_7fe09eef-5eed-4733-9a60-d7019df11cac_QBN2Y-9B284-9KW78-K48PB-R6%f%2YT_Retail________HomeBusiness2019Retail
16_6303d14a-afad-431f-8434-81052a65f575_DJTNY-4HDWM-TDWB2-8PWC2-W2%f%RRT_OEM-ARM_______HomeStudentARM2019Retail
16_215c841d-ffc1-4f03-bd11-5b27b6ab64cc_NM8WT-CFHB2-QBGXK-J8W6J-GV%f%K8F_OEM-ARM_______HomeStudentPlusARM2019Retail
16_4539aa2c-5c31-4d47-9139-543a868e5741_XNWPM-32XQC-Y7QJC-QGGBV-YY%f%7JK_Retail________HomeStudent2019Retail
16_20e359d5-927f-47c0-8a27-38adbdd27124_WR43D-NMWQQ-HCQR2-VKXDR-37%f%B7H_Retail________Outlook2019Retail
16_92a99ed8-2923-4cb7-a4c5-31da6b0b8cf3_RN3QB-GT6D7-YB3VH-F3RPB-3G%f%QYB_MAK-AE________Outlook2019Volume
16_2747b731-0f1f-413e-a92d-386ec1277dd8_NMBY8-V3CV7-BX6K6-2922Y-43%f%M7T_Retail________Personnel2019Retail
16_7e63cc20-ba37-42a1-822d-d5f29f33a108_HN27K-JHJ8R-7T7KK-WJYC3-FM%f%7MM_Retail________PowerPoint2019Retail
16_13c2d7bf-f10d-42eb-9e93-abf846785434_29GNM-VM33V-WR23K-HG2DT-KT%f%QYR_MAK-AE________PowerPoint2019Volume
16_a3072b8f-adcc-4e75-8d62-fdeb9bdfae57_BN4XJ-R9DYY-96W48-YK8DM-MY%f%7PY_Retail________ProPlus2019Retail
16_6755c7a7-4dfe-46f5-bce8-427be8e9dc62_T8YBN-4YV3X-KK24Q-QXBD7-T3%f%C63_MAK-AE________ProPlus2019Volume
16_1717c1e0-47d3-4899-a6d3-1022db7415e0_9NXDK-MRY98-2VJV8-GF73J-TQ%f%9FK_Retail________Professionnel2019Retail
16_0d270ef7-5aaf-4370-a372-bc806b96adb7_JDTNC-PP77T-T9H2W-G4J2J-VH%f%8JK_Retail________ProjectPro2019Retail
16_d4ebadd6-401b-40d5-adf4-a5d4accd72d1_TBXBD-FNWKJ-WRHBD-KBPHH-XD%f%9F2_MAK-AE________ProjectPro2019Volume
16_bb7ffe5f-daf9-4b79-b107-453e1c8427b5_R3JNT-8PBDP-MTWCK-VD2V8-HM%f%KF9_Retail________ProjectStd2019Retail
16_fdaa3c03-dc27-4a8d-8cbf-c3d843a28ddc_RBRFX-MQNDJ-4XFHF-7QVDR-JH%f%XGC_MAK-AE________ProjectStd2019Volume
16_f053a7c7-f342-4ab8-9526-a1d6e5105823_4QC36-NW3YH-D2Y9D-RJPC7-VV%f%B9D_Retail________Éditeur2019Retail
16_40055495-be00-444e-99cc-07446729b53e_K8F2D-NBM32-BF26V-YCKFJ-29%f%Y9W_MAK-AE________Éditeur2019Volume
16_b639e55c-8f3e-47fe-9761-26c6a786ad6b_JBDKF-6NCD6-49K3G-2TV79-BK%f%P73_Retail________SkypeforBusiness2019Retail
16_15a430d4-5e3f-4e6d-8a0a-14bf3caee4c7_9MNQ7-YPQ3B-6WJXM-G83T3-CB%f%BDK_MAK-AE________SkypeforBusiness2019Volume
16_f88cfdec-94ce-4463-a969-037be92bc0e7_N9722-BV9H6-WTJTT-FPB93-97%f%8MK_PrepidBypass__SkypeforBusinessEntry2019Retail
16_fdfa34dd-a472-4b85-bee6-cf07bf0aaa1c_NDGVM-MD27H-2XHVC-KDDX2-YK%f%P74_Retail________Standard2019Retail
16_beb5065c-1872-409e-94e2-403bcfb6a878_NT3V6-XMBK7-Q66MF-VMKR4-FC%f%33M_MAK-AE________Standard2019Volume
16_a6f69d68-5590-4e02-80b9-e7233dff204e_2NWVW-QGF4T-9CPMB-WYDQ9-7X%f%P79_Retail________VisioPro2019Retail
16_f41abf81-f409-4b0d-889d-92b3e3d7d005_33YF4-GNCQ3-J6GDM-J67P3-FM%f%7QP_MAK-AE________VisioPro2019Volume
16_4a582021-18c2-489f-9b3d-5186de48f1cd_263WK-3N797-7R437-28BKG-3V%f%8M8_Retail________VisioStd2019Retail
16_933ed0e3-747d-48b0-9c2c-7ceb4c7e473d_BGNHX-QTPRJ-F9C9G-R8QQG-8T%f%27F_MAK-AE________VisioStd2019Volume
16_72cee1c2-3376-4377-9f25-4024b6baadf8_JXR8H-NJ3MK-X66W8-78CWD-QR%f%VR2_Retail________Word2019Retail
16_fe5fe9d5-3b06-4015-aa35-b146f85c4709_9F36R-PNVHH-3DXGQ-7CD2H-R9%f%D3V_MAK-AE________Word2019Volume
:: Office 2021
16_f634398e-af69-48c9-b256-477bea3078b5_P286B-N3XYP-36QRQ-29CMP-RV%f%X9M_Retail________Access2021Retail
16_ae17db74-16b0-430b-912f-4fe456e271db_JBH3N-P97FP-FRTJD-MGK2C-VF%f%WG6_MAK-AE________Access2021Volume
16_844c36cb-851c-49e7-9079-12e62a049e2a_MNX9D-PB834-VCGY2-K2RW2-2D%f%P3D_Bypass________AccessRuntime2021Retail
16_fb099c19-d48b-4a2f-a160-4383011060aa_V6QFB-7N7G9-PF7W9-M8FQM-MY%f%8G9_Retail________Excel2021Retail
16_9da1ecdb-3a62-4273-a234-bf6d43dc0778_WNYR4-KMR9H-KVC8W-7HJ8B-K7%f%9DQ_MAK-AE________Excel2021Volume
16_38b92b63-1dff-4be7-8483-2a839441a2bc_JM99N-4MMD8-DQCGJ-VMYFY-R6%f%3YK_Subscription__HomeBusiness2021Retail
16_2f258377-738f-48dd-9397-287e43079958_N3CWD-38XVH-KRX2Y-YRP74-6R%f%BB2_Subscription__HomeStudent2021Retail
16_279706f4-3a4b-4877-949b-f8c299cf0cc5_NB2TQ-3Y79C-77C6M-QMY7H-7Q%f%Y8P_Retail________OneNote2021Retail
16_0c7af60d-0664-49fc-9b01-41b2dea81380_THNKC-KFR6C-Y86Q9-W8CB3-GF%f%7PD_MAK-AE________OneNote2021Volume
16_778ccb9a-2f6a-44e5-853c-eb22b7609643_CNM3W-V94GB-QJQHH-BDQ3J-33%f%Y8H_Bypass________OneNoteFree2021Retail
16_ecea2cfa-d406-4a7f-be0d-c6163250d126_4NCWR-9V92Y-34VB2-RPTHR-YT%f%GR7_Retail________Outlook2021Retail
16_45bf67f9-0fc8-4335-8b09-9226cef8a576_JQ9MJ-QYN6B-67PX9-GYFVY-QJ%f%6TB_MAK-AE________Outlook2021Volume
16_8f89391e-eedb-429d-af90-9d36fbf94de6_RRRYB-DN749-GCPW4-9H6VK-HC%f%HPT_Retail________Personnel2021Retail
16_c9bf5e86-f5e3-4ac6-8d52-e114a604d7bf_3KXXQ-PVN2C-8P7YY-HCV88-GV%f%M96_Retail1_______PowerPoint2021Retail
16_716f2434-41b6-4969-ab73-e61e593a3875_39G2N-3BD9C-C4XCM-BD4QG-FV%f%YDY_MAK-AE________PowerPoint2021Volume
16_c2f04adf-a5de-45c5-99a5-f5fddbda74a8_8WXTP-MN628-KY44G-VJWCK-C7%f%PCF_Retail________ProPlus2021Retail
16_3f180b30-9b05-4fe2-aa8d-0c1c4790f811_RNHJY-DTFXW-HW9F8-4982D-MD%f%2CW_MAK-AE1_______ProPlus2021Volume
16_96097a68-b5c5-4b19-8600-2e8d6841a0db_JRJNJ-33M7C-R73X3-P9XF7-R9%f%F6M_MAK-AE________ProPlusSPLA2021Volume
16_711e48a6-1a79-4b00-af10-73f4ca3aaac4_DJPHV-NCJV6-GWPT6-K26JX-C7%f%PBG_Retail________Professionnel2021Retail
16_3747d1d5-55a8-4bc3-b53d-19fff1913195_QKHNX-M9GGH-T3QMW-YPK4Q-QR%f%WMV_Retail________ProjectPro2021Retail
16_17739068-86c4-4924-8633-1e529abc7efc_HVC34-CVNPG-RVCMT-X2JRF-CR%f%7RK_MAK-AE1_______ProjectPro2021Volume
16_4ea64dca-227c-436b-813f-b6624be2d54c_2B96V-X9NJY-WFBRC-Q8MP2-7C%f%HRR_Retail________ProjectStd2021Retail
16_84313d1e-47c8-4e27-8ced-0476b7ee46c4_3CNQX-T34TY-99RH4-C4YD2-KW%f%6WH_MAK-AE________ProjectStd2021Volume
16_b769b746-53b1-4d89-8a68-41944dafe797_CDNFG-77T8D-VKQJX-B7KT3-KK%f%28V_Retail1_______Éditeur2021Retail
16_a0234cfe-99bd-4586-a812-4f296323c760_2KXJH-3NHTW-RDBPX-QFRXJ-MT%f%GXF_MAK-AE________Éditeur2021Volume
16_c3fb48b2-1fd4-4dc8-af39-819edf194288_DVBXN-HFT43-CVPRQ-J89TF-VM%f%MHG_Retail________SkypeforBusiness2021Retail
16_6029109c-ceb8-4ee5-b324-f8eb2981e99a_R3FCY-NHGC7-CBPVP-8Q934-YT%f%GXG_MAK-AE________SkypeforBusiness2021Volume
16_9e7e7b8e-a0e7-467b-9749-d0de82fb7297_HXNXB-J4JGM-TCF44-2X2CV-FJ%f%VVH_Retail________Standard2021Retail
16_223a60d8-9002-4a55-abac-593f5b66ca45_2CJN4-C9XK2-HFPQ6-YH498-82%f%TXH_MAK-AE________Standard2021Volume
16_b99ba8c4-e257-4b70-a31a-8bd308ce7073_BQWDW-NJ9YF-P7Y79-H6DCT-MK%f%Q9C_MAK-AE________StandardSPLA2021Volume
16_814014d3-c30b-4f63-a493-3708e0dc0ba8_T6P26-NJVBR-76BK8-WBCDY-TX%f%3BC_Retail________VisioPro2021Retail
16_c590605a-a08a-4cc7-8dc2-f1ffb3d06949_JNKBX-MH9P4-K8YYV-8CG2Y-VQ%f%2C8_MAK-AE________VisioPro2021Volume
16_16d43989-a5ef-47e2-9ff1-272784caee24_89NYY-KB93R-7X22F-93QDF-DJ%f%6YM_Retail________VisioStd2021Retail
16_d55f90ee-4ba2-4d02-b216-1300ee50e2af_BW43B-4PNFP-V637F-23TR2-J4%f%7TX_MAK-AE________VisioStd2021Volume
16_fb33d997-4aa3-494e-8b58-03e9ab0f181d_VNCC4-CJQVK-BKX34-77Y8H-CY%f%XMR_Retail________Word2021Retail
16_0c728382-95fb-4a55-8f12-62e605f91727_BJG97-NW3GM-8QQQ7-FH76G-68%f%6XM_MAK-AE________Word2021Volume
:: Office 2024
16_8fdb1f1e-663f-4f2e-8fdb-7c35aee7d5ea_GNXWX-DF797-B2JT3-82W27-KH%f%PXT_MAK-AE________ProPlus2024Volume-Preview
16_33b11b14-91fd-4f7b-b704-e64a055cf601_X86XX-N3QMW-B4WGQ-QCB69-V2%f%6KW_MAK-AE________ProjectPro2024Volume-Preview
16_eb074198-7384-4bdd-8e6c-c3342dac8435_DW99Y-H7NT6-6B29D-8JQ8F-R3%f%QT7_MAK-AE________VisioPro2024Volume-Preview
16_e563d108-7b0e-418a-8390-20e1d133d6bb_P6NMW-JMTRC-R6MQ6-HH3F2-BT%f%HKB_Retail________Access2024Retail
16_f748e2f7-5951-4bc2-8a06-5a1fbe42f5f4_CXNJT-98HPP-92HX7-MX6GY-2P%f%VFR_MAK-AE________Access2024Volume
16_f3a5e86a-e4f8-4d88-8220-1440c3bbcefa_82CNJ-W82TW-BY23W-BVJ6W-W4%f%8GP_Retail________Excel2024Retail
16_523fbbab-c290-460d-a6c9-48e49709cb8e_7Y287-9N2KC-8MRR3-BKY82-2D%f%QRV_MAK-AE________Excel2024Volume
16_885f83e0-5e18-4199-b8be-56697d0debfb_N69X7-73KPT-899FD-P8HQ4-QG%f%TP4_Retail________Home2024Retail
16_acd4eccb-ff89-4e6a-9350-d2d56276ec69_PRKQM-YNPQR-77QT6-328D7-BD%f%223_Commerce de détail________HomeBusiness2024Commerce de détail
16_6f5fd645-7119-44a4-91b4-eccfeeb738bf_2CFK4-N44KG-7XG89-CWDG6-P7%f%P27_Retail________Outlook2024Retail
16_9a1e1bac-2d8b-4890-832f-0a68b27c16e0_NQPXP-WVB87-H3MMB-FYBW2-9Q%f%FPB_MAK-AE________Outlook2024Volume
16_da9a57ae-81a8-4cb3-b764-5840e6b5d0bf_CT2KT-GTNWH-9HFGW-J2PWJ-XW%f%7KJ_Retail________PowerPoint2024Retail
16_eca0d8a6-e21b-4622-9a87-a7103ff14012_RRXFN-JJ26R-RVWD2-V7WMP-27%f%PWQ_MAK-AE________PowerPoint2024Volume
16_295dcc21-151a-4b4d-8f50-2b627ea197f6_GNJ6P-Y4RBM-C32WW-2VJKJ-MT%f%HKK_Retail________ProjectPro2024Retail
16_2141d341-41aa-4e45-9ca1-201e117d6495_WNFMR-HK4R7-7FJVM-VQ3JC-76%f%HF6_MAK-AE1_______ProjectPro2024Volume
16_ead42f74-817d-45b4-af6b-3beeb36ba650_C2PNM-2GQFC-CY3XR-WXCP4-GX%f%3XM_Retail________ProjectStd2024Retail
16_4b6d9b9b-c16e-429d-babe-8bb84c3c27d6_F2VNW-MW8TT-K622Q-4D96H-PW%f%J8X_MAK-AE________ProjectStd2024Volume
16_db249714-bb54-4422-8c78-2cc8d4c4a19f_VWCNX-7FKBD-FHJYG-XBR4B-88%f%KC6_Retail________ProPlus2024Retail
16_d77244dc-2b82-4f0a-b8ae-1fca00b7f3e2_4YV2J-VNG7W-YGTP3-443TK-TF%f%8CP_MAK-AE1_______ProPlus2024Volume
16_3046a03e-2277-4a51-8ccd-a6609eae8c19_XKRBW-KN2FF-G8CKY-HXVG6-FV%f%Y2V_MAK-AE________SkypeforBusiness2024Volume
16_44a07f51-8263-4b2f-b2a5-70340055c646_GVG6N-6WCHH-K2MVP-RQ78V-3J%f%7GJ_MAK-AE1_______Standard2024Volume
16_282d8f34-1111-4a6f-80fe-c17f70dec567_HGRBX-N68QF-6DY8J-CGX4W-XW%f%7KP_Retail________VisioPro2024Retail
16_4c2f32bf-9d0b-4d8c-8ab1-b4c6a0b9992d_GBNHB-B2G3Q-G42YB-3MFC2-7C%f%JCX_MAK-AE________VisioPro2024Volume
16_8504167d-887a-41ae-bd1d-f849d834352d_VBXPJ-38NR3-C4DKF-C8RT7-RG%f%HKQ_Retail________VisioStd2024Retail
16_0978336b-5611-497c-9414-96effaff4938_YNFTY-63K7P-FKHXK-28YYT-D3%f%2XB_MAK-AE________VisioStd2024Volume
16_f6b24e61-6aa7-4fd2-ab9b-4046cee4230a_XN33R-RP676-GMY2F-T3MH7-GC%f%VKR_Retail________Word2024Retail
16_06142aa2-e935-49ca-af5d-08069a3d84f3_WD8CQ-6KNQM-8W2CX-2RT63-KK%f%3TP_MAK-AE________Word2024Volume
) faire (
pour /f "tokens=1-5 delims=_" %%A dans ("%%#") faire (

si %1==getinfo si la clé n'est pas définie (
si %oVer%==%%A si /i "%2"=="%%E" (
définir la clé=%%C
définir _actid=%%B
définir _allactid=!_allactid! %%B
définir _lic=%%D
si %oVer%==16 (echo "%%D" | find /i "Subscription" %nul% && set _sublic=1)
)
)

)
)
quitter /b

:=================================================================================================================================================

Ce code permet de modifier la valeur d'horodatage du fichier DLL sppc afin de changer les sommes de contrôle.
Cela permet de réduire le risque de faux positifs détectés par les antivirus. À chaque installation, un fichier DLL SPPC unique sera installé.

:oh_extractdll

définir b=
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':%_hook%\:.*';$encoded = ($f[1]) -replace '-', 'A' -replace '_', 'a';$bytes = [Con%b%vert]::FromBas%b%e64String($encoded); $PePath='%1'; $offset='%2'; $m=[IO.File]::ReadAllText('!_batp!') -split ':hexedit\:.*';. ([scriptblock]::Create($m[1]))" %nul2% | find /i "Erreur trouvée" %nul1% && set hasherror=1
quitter /b

:hexedit:
# Utilisez un MemoryStream pour effectuer des opérations sur les octets
$MemoryStream = New-Object System.IO.MemoryStream
$Writer = New-Object System.IO.BinaryWriter($MemoryStream)
$Writer.Write($bytes)

# Définir l'assemblage dynamique, le module et le type
$AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1)
$ModuleBuilder = $AssemblyBuilder.DefineDynamicModule(2, $False)
$TypeBuilder = $ModuleBuilder.DefineType(0)

# Définir la méthode P/Invoke
[void]$TypeBuilder.DefinePInvokeMethod('MapFileAndCheckSum', 'imagehlp.dll', 'Public, Static', [Reflection.CallingConventions]::Standard, [int], @([string], [int].MakeByRefType(), [int].MakeByRefType()), [Runtime.InteropServices.CallingConvention]::Winapi, [Runtime.InteropServices.CharSet]::Auto)

# Créer le type
$Imagehlp = $TypeBuilder.CreateType()

# Informations sur la compensation
$timestampOffset = 136
$exportTimestampOffset = $offset
$checkSumOffset = 216

# Calculer l'horodatage
$currentTimestamp = [DateTime]::UtcNow
$unixTimestamp = [int]($currentTimestamp - (Get-Date -Year 1970 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0)).TotalSeconds

# Modifier les horodatages
$Writer.BaseStream.Position = $timestampOffset
$Writer.Write($unixTimestamp)

$Writer.BaseStream.Position = $exportTimestampOffset
$Writer.Write($unixTimestamp)

$Writer.Flush()

# Écrire l'état actuel du MemoryStream dans un fichier temporaire
$tempFilePath = "$env:windir\Temp\$([Guid]::NewGuid().Guid)"
[IO.File]::WriteAllBytes($tempFilePath, $MemoryStream.ToArray())

# Mettre à jour le hachage à l'aide du fichier temporaire
[int]$HeaderSum = 0
[int]$CheckSum = 0
[void]$Imagehlp::MapFileAndCheckSum($tempFilePath, [ref]$HeaderSum, [ref]$CheckSum)

# Si les sommes de contrôle ne correspondent pas, mettez à jour la somme de contrôle dans le flux de mémoire.
si ($HeaderSum -ne $CheckSum) {
    $Writer.BaseStream.Position = $checkSumOffset
    $Writer.Write($CheckSum)
    $Writer.Flush()
} autre {
    Erreur Write-host détectée
}

# Supprimer le fichier temporaire
Supprimer-Élément -Chemin $tempFilePath -Forcer

# Récupérer les octets modifiés
$modifiedBytes = $MemoryStream.ToArray()

# Écrire les octets modifiés dans le fichier final
[IO.File]::WriteAllBytes($PePath, $modifiedBytes)

[void]$Imagehlp::MapFileAndCheckSum($PePath, [ref]$HeaderSum, [ref]$CheckSum)
si ($HeaderSum -ne $CheckSum) {
    Erreur Write-host détectée
}

$MemoryStream.Close()
:hexedit:

:=================================================================================================================================================
::
:: Les blocs de texte ci-dessous sont encodés au format base64
:: Les blocs dans les étiquettes « sppc32.dll » et « sppc64.dll » contiennent les fichiers ci-dessous
::
:: 09865ea5993215965e8f27a74b8a41d15fd0f60f5f404cb7a8b3c7757acdab02 *sppc32.dll
:: 393a1fa26deb3663854e41f2b687c188a9eacd87b23f17ea09422c4715cb5a9f *sppc64.dll
::
:: Les fichiers sont encodés en base64 pour créer une version AIO.
::
:: mass{}grave{dot}dev/ohook
Vous trouverez ici le code source des fichiers et des informations sur la façon de reconstruire les fichiers sppc.dll identiques.
::
:: stackoverflow.com/a/35335273
Vous pouvez consulter ici la procédure d'extraction des fichiers sppc.dll à partir de base64.
::
Pour toute question supplémentaire, n'hésitez pas à nous contacter à l'adresse mass{}grave{dot}dev/contactus
::
:=================================================================================================================================================
::
:: Remplacez « - » par « A » et « _ » par « a » avant la conversion en base64
:: Cette modification a été apportée afin d'empêcher les antivirus de détecter et de signaler l'encodage base64.

:sppc32.dll:
TVqQ--M----E----//8--Lg---------Q-----------------------------------------------g-----4fug4-t-nNIbgB TM0hVGhpcyBwcm9ncmFtIGNhbm5vdCBiZSBydW4g_W4gRE9TIG1vZGUuDQ0KJ---------BQRQ--T-EH-MDc0GQ----------O--
DiML-QIo--I----e--------RxE----Q----------C-_g-Q-----g--B-----E----G----------CQ----B---+dY---IQE--C---B------E---E--------B------Q---jR----Bg---YQ---H---HgD-------------------------I---BQ---------
----------------------------------------------------------BsY---H------------------------------------C50ZXh0----cE----Q-----g----Q------------------C---G-ucmRhdGE--Bg-----I-----I----G----------------
--B---B-LmVoX2ZyYW2------D-----C----C-------------------Q---QC5lZGF0YQ--jR----B-----Eg----o------------------E---E-u_WRhdGE--BgB----Y-----I----c------------------B---D-LnJzcmM---B4-w---H-----E----Hg--
----------------Q---wC5yZWxvYw--F-----C------g--------CI------------------E---EI-----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------FWJ5VZTjUXwg+wwx0Xw-----IlEJBSNRfSJ
RCQQi0UMx0QkD-----CJRCQEi0UIx0QkC--ggGqJBCTHRfQ-----6-oB--CLNXhggGqD7BiFwInDi0Xwd-qJBCQx2//WUesyi1X0 x0QkB-oggGqJBCSJVCQI/xW-YIBqg+wMhcCLRfCJBCR0Cv/WuwE---BS6wP/1lCNZfiJ2FteXcNVieVXVlOD7DyLRRiLdRyJRCQQ
i0UUiXQkFIlEJ-yLRRCJRCQIi0UMiUQkBItFCIkEJOiE----McmD7BiJx4X-dVyLRRg5CHZV_9koiwYB2IN4E-B0RYlEJ-SLRQiJTeSJBCTo+/7//4tN5IX-dSwDHsdDE-E---DHQxQ-----x0MY-----MdDH-----DHQy------x0Mk-----EHrpI1l9In4W15fXcIY
-LgB----wgw-kP8lcGC-_pCQ/yVsYIBqkJD/////-----P////8-----------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------TgBh-G0-ZQ---Ec-cgBh-GM-ZQ----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------U----------F6Ug-Bf-gBGwwEBIgB---k----H----ODf//+d-----EEOCIUCQg0FSIYD
gwQCj8NBxkHFD-QEK----EQ---BV4P//qg----BBDgiF-kINBU_H-4YEgwUCm8NBxkHHQcUMB-QQ----c----NPg//8I------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----D-3NBk-----MZC---B----Qw---EM----oQ---NEE--EBC--DPQg--70I---VD---pQw--XUM--KFD--Dp Qw--F0Q--DVE--BnR---nUQ--ONE---tRQ--YUU--J9F--DTRQ--DUY--DtG--BxRg--r0Y--M9G--D7Rg--nR---FFH--BvRw--
n0c--NNH---RS---TUg--G9I--ClS---zUg---VJ--BBSQ--bUk--KdJ--C7SQ--+0k--DlK--BPSg--dUo--J1K--DTSg--B0s- -D1L--BpSw--pUs--ONL---NT---OUw--IlM--DRT---EU0--FlN--CjTQ--8U0--BtO--BHTg--h04--LtO--DnTg--K08--FtP
--C1Tw--608--CdQ--BdU---4kI--P1C---_Qw--RkM--IJD--DIQw---0Q--ClE--BRR---hUQ--MNE---LRQ--SkU--INF--C8 RQ--80U--CdG--BZRg--k0Y--MJG--DoRg--GUc--DFH--BjRw--ikc--LxH--D1Rw--Mkg--GFI--CNS---vEg--OxI---mSQ--
Wkk--I1J--C0SQ--3kk--B1K--BHSg--ZUo--IxK--C7Sg--8Eo--CVL--BWSw--iks--MdL--D7Sw--Jkw--GRM--CwT---9Ew --DhN--CBTQ--zU0---lO---0Tg--_k4--KRO--DUTg--DE8--EZP--CLTw--008---xQ--BFU---eF-------QC--MB--F--Y-
Bw-I--k-Cg-L--w-DQ-O--8-E--R-BI-Ew-U-BU-Fg-X-Bg-GQ-_-Bs-H--d-B4-Hw-g-CE-Ig-j-CQ-JQ-m-Cc-K--p-Co-Kw- s-C0-Lg-vD--MQ-y-DM-N--1-DY-Nw-4-Dk-Og-7-Dw-PQ-+-D8-Q-BB-EI-c3BwYy5kbGw-U1BQQ1MuU0xDYWxsU2VydmVy-FNM
Q2FsbFNlcnZlcgBTUFBDUy5TTENsb3Nl-FNMQ2xvc2U-U1BQQ1MuU0xDb25zdW1lUmln_HQ-U0xDb25zdW1lUmln_HQ-U1BQQ1Mu U0xEZXBvc2l0TWlncmF0_W9uQmxvYgBTTERlcG9z_XRN_WdyYXRpb25CbG9i-FNQUENTLlNMRGVwb3NpdE9mZmxpbmVDb25m_XJt
YXRpb25JZ-BTTERlcG9z_XRPZmZs_W5lQ29uZmlybWF0_W9uSWQ-U1BQQ1MuU0xEZXBvc2l0T2ZmbGluZUNvbmZpcm1hdGlvbklkRXg-U0xEZXBvc2l0T2ZmbGluZUNvbmZpcm1hdGlvbklkRXg-U1BQQ1MuU0xEZXBvc2l0U3RvcmVUb2tlbgBTTERlcG9z_XRTdG9y
ZVRv_2Vu-FNQUENTLlNMRmlyZUV2ZW50-FNMRmlyZUV2ZW50-FNQUENTLlNMR2F0_GVyTWlncmF0_W9uQmxvYgBTTEdhdGhlck1pZ3JhdGlvbkJsb2I-U1BQQ1MuU0xHYXRoZXJN_WdyYXRpb25CbG9iRXg-U0xHYXRoZXJN_WdyYXRpb25CbG9iRXg-U1BQQ1MuU0xH
ZW5lcmF0ZU9mZmxpbmVJbnN0YWxsYXRpb25JZ-BTTEdlbmVyYXRlT2ZmbGluZUluc3RhbGxhdGlvbklk-FNQUENTLlNMR2VuZXJhdGVPZmZs_W5lSW5zdGFsbGF0_W9uSWRFe-BTTEdlbmVyYXRlT2ZmbGluZUluc3RhbGxhdGlvbklkRXg-U1BQQ1MuU0xHZXRBY3Rp
dmVM_WNlbnNlSW5mbwBTTEdldEFjdGl2ZUxpY2Vuc2VJbmZv-FNQUENTLlNMR2V0QXBwbGljYXRpb25JbmZvcm1hdGlvbgBTTEdldEFwcGxpY2F0_W9uSW5mb3JtYXRpb24-U1BQQ1MuU0xHZXRBcHBs_WNhdGlvblBvbGljeQBTTEdldEFwcGxpY2F0_W9uUG9s_WN5
-FNQUENTLlNMR2V0QXV0_GVudGljYXRpb25SZXN1bHQ-U0xHZXRBdXRoZW50_WNhdGlvblJlc3Vsd-BTUFBDUy5TTEdldEVuY3J5cHRlZFBJREV4-FNMR2V0RW5jcnlwdGVkUElERXg-U1BQQ1MuU0xHZXRHZW51_W5lSW5mb3JtYXRpb24-U0xHZXRHZW51_W5lSW5m
b3JtYXRpb24-U1BQQ1MuU0xHZXRJbnN0YWxsZWRQcm9kdWN0S2V5SWRz-FNMR2V0SW5zdGFsbGVkUHJvZHVjdEtleUlkcwBTUFBDUy5TTEdldExpY2Vuc2U-U0xHZXRM_WNlbnNl-FNQUENTLlNMR2V0TGljZW5zZUZpbGVJZ-BTTEdldExpY2Vuc2VG_WxlSWQ-U1BQ
Q1MuU0xHZXRM_WNlbnNlSW5mb3JtYXRpb24-U0xHZXRM_WNlbnNlSW5mb3JtYXRpb24-U0xHZXRM_WNlbnNpbmdTdGF0dXNJbmZvcm1hdGlvbgBTUFBDUy5TTEdldFBLZXlJZ-BTTEdldFBLZXlJZ-BTUFBDUy5TTEdldFBLZXlJbmZvcm1hdGlvbgBTTEdldFBLZXlJ
bmZvcm1hdGlvbgBTUFBDUy5TTEdldFBvbGljeUluZm9ybWF0_W9u-FNMR2V0UG9s_WN5SW5mb3JtYXRpb24-U1BQQ1MuU0xHZXRQb2xpY3lJbmZvcm1hdGlvbkRXT1JE-FNMR2V0UG9s_WN5SW5mb3JtYXRpb25EV09SR-BTUFBDUy5TTEdldFByb2R1Y3RT_3VJbmZv
cm1hdGlvbgBTTEdldFByb2R1Y3RT_3VJbmZvcm1hdGlvbgBTUFBDUy5TTEdldFNMSURM_XN0-FNMR2V0U0xJRExpc3Q-U1BQQ1MuU0xHZXRTZXJ2_WNlSW5mb3JtYXRpb24-U0xHZXRTZXJ2_WNlSW5mb3JtYXRpb24-U1BQQ1MuU0xJbnN0YWxsTGljZW5zZQBTTElu
c3RhbGxM_WNlbnNl-FNQUENTLlNMSW5zdGFsbFByb29mT2ZQdXJj_GFzZQBTTEluc3RhbGxQcm9vZk9mUHVyY2hhc2U-U1BQQ1MuU0xJbnN0YWxsUHJvb2ZPZlB1cmNoYXNlRXg-U0xJbnN0YWxsUHJvb2ZPZlB1cmNoYXNlRXg-U1BQQ1MuU0xJc0dlbnVpbmVMb2Nh
bEV4-FNMSXNHZW51_W5lTG9jYWxFe-BTUFBDUy5TTExvYWRBcHBs_WNhdGlvblBvbGlj_WVz-FNMTG9hZEFwcGxpY2F0_W9uUG9s_WNpZXM-U1BQQ1MuU0xPcGVu-FNMT3BlbgBTUFBDUy5TTFBlcnNpc3RBcHBs_WNhdGlvblBvbGlj_WVz-FNMUGVyc2lzdEFwcGxp
Y2F0_W9uUG9s_WNpZXM-U1BQQ1MuU0xQZXJz_XN0UlRTUGF5bG9hZE92ZXJy_WRl-FNMUGVyc2lzdFJUU1BheWxvYWRPdmVycmlkZQBTUFBDUy5TTFJlQXJt-FNMUmVBcm0-U1BQQ1MuU0xSZWdpc3RlckV2ZW50-FNMUmVn_XN0ZXJFdmVud-BTUFBDUy5TTFJlZ2lz
dGVyUGx1Z2lu-FNMUmVn_XN0ZXJQbHVn_W4-U1BQQ1MuU0xTZXRBdXRoZW50_WNhdGlvbkRhdGE-U0xTZXRBdXRoZW50_WNhdGlv bkRhdGE-U1BQQ1MuU0xTZXRDdXJyZW50UHJvZHVjdEtleQBTTFNldEN1cnJlbnRQcm9kdWN0S2V5-FNQUENTLlNMU2V0R2VudWlu
ZUluZm9ybWF0_W9u-FNMU2V0R2VudWluZUluZm9ybWF0_W9u-FNQUENTLlNMVW5pbnN0YWxsTGljZW5zZQBTTFVu_W5zdGFsbExpY2Vuc2U-U1BQQ1MuU0xVbmluc3RhbGxQcm9vZk9mUHVyY2hhc2U-U0xVbmluc3RhbGxQcm9vZk9mUHVyY2hhc2U-U1BQQ1MuU0xV
bmxvYWRBcHBs_WNhdGlvblBvbGlj_WVz-FNMVW5sb2FkQXBwbGljYXRpb25Qb2xpY2llcwBTUFBDUy5TTFVucmVn_XN0ZXJFdmVu d-BTTFVucmVn_XN0ZXJFdmVud-BTUFBDUy5TTFVucmVn_XN0ZXJQbHVn_W4-U0xVbnJlZ2lzdGVyUGx1Z2lu-FNQUENTLlNMcEF1
dGhlbnRpY2F0ZUdlbnVpbmVU_WNrZXRSZXNwb25zZQBTTHBBdXRoZW50_WNhdGVHZW51_W5lVGlj_2V0UmVzcG9uc2U-U1BQQ1MuU0xwQmVn_W5HZW51_W5lVGlj_2V0VHJhbnNhY3Rpb24-U0xwQmVn_W5HZW51_W5lVGlj_2V0VHJhbnNhY3Rpb24-U1BQQ1MuU0xw
Q2xlYXJBY3RpdmF0_W9uSW5Qcm9ncmVzcwBTTHBDbGVhckFjdGl2YXRpb25JblByb2dyZXNz-FNQUENTLlNMcERlcG9z_XREb3dubGV2ZWxHZW51_W5lVGlj_2V0-FNQUENTLlNMcERlcG9z_XREb3dubGV2ZWxHZW51_W5lVGlj_2V0-FNQUENTLlNMcERlcG9z_XRUb2tlbkFj
dGl2YXRpb25SZXNwb25zZQBTTHBEZXBvc2l0VG9rZW5BY3RpdmF0_W9uUmVzcG9uc2U-U1BQQ1MuU0xwR2VuZXJhdGVUb2tlbkFjdGl2YXRpb25D_GFsbGVuZ2U-U0xwR2VuZXJhdGVUb2tlbkFjdGl2YXRpb25D_GFsbGVuZ2U-U1BQQ1MuU0xwR2V0R2VudWluZUJs
b2I-U0xwR2V0R2VudWluZUJsb2I-U1BQQ1MuU0xwR2V0R2VudWluZUxvY2Fs-FNMcEdldEdlbnVpbmVMb2Nhb-BTUFBDUy5TTHBHZXRM_WNlbnNlQWNxdWlz_XRpb25JbmZv-FNMcEdldExpY2Vuc2VBY3F1_XNpdGlvbkluZm8-U1BQQ1MuU0xwR2V0TVNQ_WRJbmZv
cm1hdGlvbgBTTHBHZXRNU1BpZEluZm9ybWF0_W9u-FNQUENTLlNMcEdldE1hY2hpbmVVR1VJR-BTTHBHZXRNYWNo_W5lVUdVSUQ-U1BQQ1MuU0xwR2V0VG9rZW5BY3RpdmF0_W9uR3JhbnRJbmZv-FNMcEdldFRv_2VuQWN0_XZhdGlvbkdyYW50SW5mbwBTUFBDUy5T
THBJQUFjdGl2YXRlUHJvZHVjd-BTTHBJQUFjdGl2YXRlUHJvZHVjd-BTUFBDUy5TTHBJc0N1cnJlbnRJbnN0YWxsZWRQcm9kdWN0 S2V5RGVmYXVsdEtleQBTTHBJc0N1cnJlbnRJbnN0YWxsZWRQcm9kdWN0S2V5RGVmYXVsdEtleQBTUFBDUy5TTHBQcm9jZXNzVk1Q
_XBlTWVzc2FnZQBTTHBQcm9jZXNzVk1Q_XBlTWVzc2FnZQBTUFBDUy5TTHBTZXRBY3RpdmF0_W9uSW5Qcm9ncmVzcwBTTHBTZXRBY3RpdmF0_W9uSW5Qcm9ncmVzcwBTUFBDUy5TTHBUcmlnZ2VyU2VydmljZVdvcmtlcgBTTHBUcmlnZ2VyU2VydmljZVdvcmtlcgBT
UFBDUy5TTHBWTEFjdGl2YXRlUHJvZHVjd-BTTHBWTEFjdGl2YXRlUHJvZHVjd-----------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------FBg-------------Ohg--BsY---XG--------------
+G---Hhg--BkY--------------MYQ--gG------------------------------iG---Kpg--------yG--------DUY--------Ihg--CqY--------Mhg--------1G---------C-FNMR2V0TGljZW5z_W5nU3RhdHVzSW5mb3JtYXRpb24--QBTTEdldFByb2R1
Y3RT_3VJbmZvcm1hdGlvbg--3QNMb2NhbEZyZWU-RwFTdHJTdHJOSVc--G----Bg--BzcHBjcy5kbGw----UY---S0VSTkVMMzIu ZGxs-----Chg--BTSExXQVBJLmRsb-----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------BB-----Y--C--------------------B--E----w--C--------------------B--kE--BI----WH---BwD-------------BwDN----FY-UwBf-FY-RQBS-FM-SQBP-E4-XwBJ-E4-
RgBP------C9BO/+---B--U---------BQ--------------------QB--C--------------------fI---E-UwB0-HI-_QBu -Gc-RgBp-Gw-ZQBJ-G4-ZgBv----WI---EM--0-D--OQ-w-DQ-RQ-0----eg-t--E-QwBv-G0-c-Bh-G4-eQBO-GE-bQBl----
--BB-G4-bwBt-GE-b-Bv-HU-cw-g-FM-bwBm-HQ-dwBh-HI-ZQ-g-EQ-ZQB0-GU-cgBp-G8-cgBh-HQ-_QBv-G4-I-BD-G8-cgBw -G8-cgBh-HQ-_QBv-G4------D4-Cw-B-EY-_QBs-GU-R-Bl-HM-YwBy-Gk-c-B0-Gk-bwBu------Bv-Gg-bwBv-Gs-I-BT-F--
U-BD-------w--g--QBG-Gk-b-Bl-FY-ZQBy-HM-_QBv-G4------D--Lg-1-C4-M--uD-----q--U--QBJ-G4-d-Bl-HI-bgBh -Gw-TgBh-G0-ZQ---HM-c-Bw-GM------Iw-N--B-Ew-ZQBn-GE-b-BD-G8-c-B5-HI-_QBn-Gg-d----Kk-I--yD--Mg-0-C--
QQBu-G8-bQBh-Gw-bwB1-HM-I-BT-G8-ZgB0-Hc-YQBy-GU-I-BE-GU-d-Bl-HI-_QBv-HI-YQB0-Gk-bwBu-C--QwBv-HI-c-Bv -HI-YQB0-Gk-bwBu----Og-J--E-TwBy-Gk-ZwBp-G4-YQBs-EY-_QBs-GU-bgBh-G0-ZQ---HM-c-Bw-GM-LgBk-Gw-b-------
L--G--EU-By-G8-Z-B1-GM-d-BO-GE-bQBl------Bv-Gg-bwBv-Gs----0--g--QBQ-HI-bwBk-HU-YwB0-FY-ZQBy-HM-_QBv -G4----w-C4-NQ-uD--Lg-w----R-----E-VgBh-HI-RgBp-Gw-ZQBJ-G4-ZgBv-------k--Q---BU-HI-YQBu-HM-b-Bh-HQ-
_QBv-G4-------kE5-Q-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------Q---U----MzBIMGkwdjBSMVox------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
:sppc32.dll:

:====================================================================================================================================================

:: Remplacez « - » par « A » et « _ » par « a » avant la conversion en base64
:: Cette modification a été apportée afin d'empêcher les antivirus de détecter et de signaler l'encodage base64.

:sppc64.dll:
TVqQ--M----E----//8--Lg---------Q-----------------------------------------------g-----4fug4-t-nNIbgBTM0hVGhpcyBwcm9ncmFtIGNhbm5vdCBiZSBydW4g_W4gRE9TIG1vZGUuDQ0KJ---------BQRQ--ZIYH-MDc0GQ----------P--
LiIL-gIo--I----e--------ExE----Q-----JIx-g-----Q-----g--B----------G----------CQ----B---LeY---IYE- -C---------Q-----------Q--------E--------------Q-----F---I0Q----c---UE---C---B4-w---D---CQ---------
--------------------------------------------------------------------------------iH---Dg------------------------------------udGV4d----HB----E-----I----E-------------------g--BgLnJkYXRh---g-----C-----C
----Bg------------------Q---QC5wZGF0YQ--J------w-----g----g------------------E---E-ueGRhdGE--CQ-----Q-----I----K------------------B---B-LmVkYXRh--CNE----F-----S----D-------------------Q---QC5pZGF0YQ--
UE---Bw-----g---B4-----------------E---M-ucnNyYw---HgD----g-----Q----g------------------B---D---------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------EFUU0iD7EhFMclMjQXvDw--SI1EJDjHRCQ0
-----EiJRCQoSI1EJDRIiUQkIEjHRCQ4-----OgF-Q--SItMJDhIix1ZY---hcBBicR0B//TRTHk6yhEi0QkNEiNF_kP--D/FUlg --BIi0wkOEiFwHQK/9NBv-E---Dr-v/TRIngSIPESFtBXMNBVUFUVVdWU0iD7Dgx9kyLrCSQ----SIusJJg---BMiWwkIEiJz0iJ
bCQo6J----BBicSFwHVEQTl1-HY+SGveKEiLVQBI-dqDeh--dChIifnoIv///4X-dRxI-10-SMdDE-E---BIx0MY-----EjHQy-- ----SP/G67xEieBIg8Q4W15fXUFcQV3Du-E---DDkJCQkJCQkP8lel8--JCQDx+E------D/JXpf--CQk-8fh-------/yVKXw--
kJD/JTpf--CQkP//////////--------------D//////////w---------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------TgBh-G0-ZQ---Ec-cgBh-GM-ZQ----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------E---iB----B---CIE---ExE---x----TEQ--GRE--CB-------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------EH-w-HggMw-s----EMBw-MYggwB2-Gc-VQBM-C0----Q----------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------MDc0GQ-----xlI---E---BD----Qw---ChQ---0UQ--QFI--M9S--DvUg--BVM--ClT--BdUw--oVM--OlT---XV---NVQ--GdU
--CdV---41Q--C1V--BhVQ--n1U--NNV---NVg--O1Y--HFW--CvVg--z1Y--PtW--CIE---UVc--G9X--CfVw--01c--BFY--BN W---b1g--KVY--DNW---BVk--EFZ--BtWQ--p1k--LtZ--D7WQ--OVo--E9_--B1Wg--nVo--NN_---HWw--PVs--Glb--ClWw--
41s---1c---5X---iVw--NFc---RXQ--WV0--KNd--DxXQ--G14--Ede--CHXg--u14--Ode---rXw--W18--LVf--DrXw--J2-- -F1g--DiUg--/VI--BpT--BGUw--glM--MhT---DV---KVQ--FFU--CFV---w1Q---tV--BKVQ--g1U--LxV--DzVQ--J1Y--FlW
--CTVg--wlY--OhW---ZVw--MVc--GNX--CKVw--vFc--PVX---yW---YVg--I1Y--C8W---7Fg--CZZ--B_WQ--jVk--LRZ--De WQ--HVo--Ed_--BlWg--jFo--Lt_--DwWg--JVs--FZb--CKWw--x1s--Ptb---mX---ZFw--LBc--D0X---OF0--IFd--DNXQ--
CV4--DRe--BqXg--pF4--NRe---MXw--Rl8--Itf--DTXw--DG---EVg--B4Y------B--I--wE--U-Bg-H--g-CQ-K--sD--N--4-Dw-Q-BE-Eg-T-BQ-FQ-W-Bc-G--Z-Bo-Gw-c-B0-Hg-fC--IQ-i-CM-J--l-CY-Jw-o-Ck-Kg-r-Cw-LQ-u-C8-M--x-DI-
Mw-0-DU-Ng-3-Dg-OQ-6-Ds-P--9-D4-PwB--EE-QgBzcHBjLmRsb-BTUFBDUy5TTENhbGxTZXJ2ZXI-U0xDYWxsU2VydmVy-FNQ UENTLlNMQ2xvc2U-U0xDbG9zZQBTUFBDUy5TTENvbnN1bWVS_Wdod-BTTENvbnN1bWVS_Wdod-BTUFBDUy5TTERlcG9z_XRN_Wdy
YXRpb25CbG9i-FNMRGVwb3NpdE1pZ3JhdGlvbkJsb2I-U1BQQ1MuU0xEZXBvc2l0T2ZmbGluZUNvbmZpcm1hdGlvbklk-FNMRGVwb3NpdE9mZmxpbmVDb25m_XJtYXRpb25JZ-BTUFBDUy5TTERlcG9z_XRPZmZs_W5lQ29uZmlybWF0_W9uSWRFe-BTTERlcG9z_XRP
ZmZs_W5lQ29uZmlybWF0_W9uSWRFe-BTUFBDUy5TTERlcG9z_XRTdG9yZVRv_2Vu-FNMRGVwb3NpdFN0b3JlVG9rZW4-U1BQQ1MuU0xG_XJlRXZlbnQ-U0xG_XJlRXZlbnQ-U1BQQ1MuU0xHYXRoZXJN_WdyYXRpb25CbG9i-FNMR2F0_GVyTWlncmF0_W9uQmxvYgBT
UFBDUy5TTEdhdGhlck1pZ3JhdGlvbkJsb2JFe-BTTEdhdGhlck1pZ3JhdGlvbkJsb2JFe-BTUFBDUy5TTEdlbmVyYXRlT2ZmbGluZUluc3RhbGxhdGlvbklk-FNMR2VuZXJhdGVPZmZs_W5lSW5zdGFsbGF0_W9uSWQ-U1BQQ1MuU0xHZW5lcmF0ZU9mZmxpbmVJbnN0
YWxsYXRpb25JZEV4-FNMR2VuZXJhdGVPZmZs_W5lSW5zdGFsbGF0_W9uSWRFe-BTUFBDUy5TTEdldEFjdGl2ZUxpY2Vuc2VJbmZv-FNMR2V0QWN0_XZlTGljZW5zZUluZm8-U1BQQ1MuU0xHZXRBcHBs_WNhdGlvbkluZm9ybWF0_W9u-FNMR2V0QXBwbGljYXRpb25J
bmZvcm1hdGlvbgBTUFBDUy5TTEdldEFwcGxpY2F0_W9uUG9s_WN5-FNMR2V0QXBwbGljYXRpb25Qb2xpY3k-U1BQQ1MuU0xHZXRBdXRoZW50_WNhdGlvblJlc3Vsd-BTTEdldEF1dGhlbnRpY2F0_W9uUmVzdWx0-FNQUENTLlNMR2V0RW5jcnlwdGVkUElERXg-U0xH
ZXRFbmNyeXB0ZWRQSURFe-BTUFBDUy5TTEdldEdlbnVpbmVJbmZvcm1hdGlvbgBTTEdldEdlbnVpbmVJbmZvcm1hdGlvbgBTUFBDUy5TTEdldEluc3RhbGxlZFByb2R1Y3RLZXlJZHM-U0xHZXRJbnN0YWxsZWRQcm9kdWN0S2V5SWRz-FNQUENTLlNMR2V0TGljZW5z
ZQBTTEdldExpY2Vuc2U-U1BQQ1MuU0xHZXRM_WNlbnNlRmlsZUlk-FNMR2V0TGljZW5zZUZpbGVJZ-BTUFBDUy5TTEdldExpY2Vuc2VJbmZvcm1hdGlvbgBTTEdldExpY2Vuc2VJbmZvcm1hdGlvbgBTTEdldExpY2Vuc2luZ1N0YXR1c0luZm9ybWF0_W9u-FNQUENT
LlNMR2V0UEtleUlk-FNMR2V0UEtleUlk-FNQUENTLlNMR2V0UEtleUluZm9ybWF0_W9u-FNMR2V0UEtleUluZm9ybWF0_W9u-FNQUENTLlNMR2V0UG9s_WN5SW5mb3JtYXRpb24-U0xHZXRQb2xpY3lJbmZvcm1hdGlvbgBTUFBDUy5TTEdldFBvbGljeUluZm9ybWF0
_W9uRFdPUkQ-U0xHZXRQb2xpY3lJbmZvcm1hdGlvbkRXT1JE-FNQUENTLlNMR2V0UHJvZHVjdFNrdUluZm9ybWF0_W9u-FNMR2V0UHJvZHVjdFNrdUluZm9ybWF0_W9u-FNQUENTLlNMR2V0U0xJRExpc3Q-U0xHZXRTTElETGlzd-BTUFBDUy5TTEdldFNlcnZpY2VJ
bmZvcm1hdGlvbgBTTEdldFNlcnZpY2VJbmZvcm1hdGlvbgBTUFBDUy5TTEluc3RhbGxM_WNlbnNl-FNMSW5zdGFsbExpY2Vuc2U-U1BQQ1MuU0xJbnN0YWxsUHJvb2ZPZlB1cmNoYXNl-FNMSW5zdGFsbFByb29mT2ZQdXJj_GFzZQBTUFBDUy5TTEluc3RhbGxQcm9v
Zk9mUHVyY2hhc2VFe-BTTEluc3RhbGxQcm9vZk9mUHVyY2hhc2VFe-BTUFBDUy5TTElzR2VudWluZUxvY2FsRXg-U0xJc0dlbnVpbmVMb2NhbEV4-FNQUENTLlNMTG9hZEFwcGxpY2F0_W9uUG9s_WNpZXM-U0xMb2FkQXBwbGljYXRpb25Qb2xpY2llcwBTUFBDUy5T
TE9wZW4-U0xPcGVu-FNQUENTLlNMUGVyc2lzdEFwcGxpY2F0_W9uUG9s_WNpZXM-U0xQZXJz_XN0QXBwbGljYXRpb25Qb2xpY2llcwBTUFBDUy5TTFBlcnNpc3RSVFNQYXlsb2FkT3ZlcnJpZGU-U0xQZXJz_XN0UlRTUGF5bG9hZE92ZXJy_WRl-FNQUENTLlNMUmVB
cm0-U0xSZUFybQBTUFBDUy5TTFJlZ2lzdGVyRXZlbnQ-U0xSZWdpc3RlckV2ZW50-FNQUENTLlNMUmVn_XN0ZXJQbHVn_W4-U0xSZWdpc3RlclBsdWdpbgBTUFBDUy5TTFNldEF1dGhlbnRpY2F0_W9uRGF0YQBTTFNldEF1dGhlbnRpY2F0_W9uRGF0YQBTUFBDUy5T
TFNldEN1cnJlbnRQcm9kdWN0S2V5-FNMU2V0Q3VycmVudFByb2R1Y3RLZXk-U1BQQ1MuU0xTZXRHZW51_W5lSW5mb3JtYXRpb24-U0xTZXRHZW51_W5lSW5mb3JtYXRpb24-U1BQQ1MuU0xVbmluc3RhbGxM_WNlbnNl-FNMVW5pbnN0YWxsTGljZW5zZQBTUFBDUy5T
TFVu_W5zdGFsbFByb29mT2ZQdXJj_GFzZQBTTFVu_W5zdGFsbFByb29mT2ZQdXJj_GFzZQBTUFBDUy5TTFVubG9hZEFwcGxpY2F0_W9uUG9s_WNpZXM-U0xVbmxvYWRBcHBs_WNhdGlvblBvbGlj_WVz-FNQUENTLlNMVW5yZWdpc3RlckV2ZW50-FNMVW5yZWdpc3Rl
ckV2ZW50-FNQUENTLlNMVW5yZWdpc3RlclBsdWdpbgBTTFVucmVn_XN0ZXJQbHVn_W4-U1BQQ1MuU0xwQXV0_GVudGljYXRlR2VudWluZVRpY2tldFJlc3BvbnNl-FNMcEF1dGhlbnRpY2F0ZUdlbnVpbmVU_WNrZXRSZXNwb25zZQBTUFBDUy5TTHBCZWdpbkdlbnVp
bmVU_WNrZXRUcmFuc2FjdGlvbgBTTHBCZWdpbkdlbnVpbmVU_WNrZXRUcmFuc2FjdGlvbgBTUFBDUy5TTHBDbGVhckFjdGl2YXRpb25JblByb2dyZXNz-FNMcENsZWFyQWN0_XZhdGlvbkluUHJvZ3Jlc3M-U1BQQ1MuU0xwRGVwb3NpdERvd25sZXZlbEdlbnVpbmVU
_WNrZXQ-U0xwRGVwb3NpdERvd25sZXZlbEdlbnVpbmVU_WNrZXQ-U1BQQ1MuU0xwRGVwb3NpdFRv_2VuQWN0_XZhdGlvblJlc3BvbnNl-FNMcERlcG9z_XRUb2tlbkFjdGl2YXRpb25SZXNwb25zZQBTUFBDUy5TTHBHZW5lcmF0ZVRv_2VuQWN0_XZhdGlvbkNoYWxs
ZW5nZQBTTHBHZW5lcmF0ZVRv_2VuQWN0_XZhdGlvbkNoYWxsZW5nZQBTUFBDUy5TTHBHZXRHZW51_W5lQmxvYgBTTHBHZXRHZW51_W5lQmxvYgBTUFBDUy5TTHBHZXRHZW51_W5lTG9jYWw-U0xwR2V0R2VudWluZUxvY2Fs-FNQUENTLlNMcEdldExpY2Vuc2VBY3F1
_XNpdGlvbkluZm8-U0xwR2V0TGljZW5zZUFjcXVpc2l0_W9uSW5mbwBTUFBDUy5TTHBHZXRNU1BpZEluZm9ybWF0_W9u-FNMcEdldE1TUGlkSW5mb3JtYXRpb24-U1BQQ1MuU0xwR2V0TWFj_GluZVVHVUlE-FNMcEdldE1hY2hpbmVVR1VJR-BTUFBDUy5TTHBHZXRU
b2tlbkFjdGl2YXRpb25HcmFudEluZm8-U0xwR2V0VG9rZW5BY3RpdmF0_W9uR3JhbnRJbmZv-FNQUENTLlNMcElBQWN0_XZhdGVQcm9kdWN0-FNQUENTLlNMcElzQ3VycmVudEluc3RhbGxlZFByb2R1Y3RLZXlEZWZhdWx0S2V5
-FNMcElzQ3VycmVudEluc3RhbGxlZFByb2R1Y3RLZXlEZWZhdWx0S2V5-FNQUENTLlNMcFByb2Nlc3NWTVBpcGVNZXNzYWdl-FNMcFByb2Nlc3NWTVBpcGVNZXNzYWdl-FNQUENTLlNMcFNldEFjdGl2YXRpb25JblByb2dyZXNz-FNMcFNldEFjdGl2YXRpb25JblBy
b2dyZXNz-FNQUENTLlNMcFRy_WdnZXJTZXJ2_WNlV29y_2Vy-FNMcFRy_WdnZXJTZXJ2_WNlV29y_2Vy-FNQUENTLlNMcFZMQWN0_XZhdGVQcm9kdWN0-FNMcFZMQWN0_XZhdGVQcm9kdWN0--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------UH--------------IHE--Ihw--Boc--------------wcQ--oH---Hhw-------------ERx--Cwc-----------------------------Dc--------OJw--------------------cQ------------------
DHE------------------MBw--------4n--------------------Bx-------------------McQ-------------------gBTTEdldExpY2Vuc2luZ1N0YXR1c0luZm9ybWF0_W9u--E-U0xHZXRQcm9kdWN0U2t1SW5mb3JtYXRpb24--OgDTG9jYWxGcmVl-FEB
U3RyU3RyTklX--Bw----c---c3BwY3MuZGxs----FH---EtFUk5FTDMyLmRsb------oc---U0hMV0FQSS5kbGw------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------EE----Bg--I--------------------E--Q---D---I--------------
------E-CQQ--Par exemple---BYg---HM-------------H-M0----VgBT-F8-VgBF-FI-UwBJ-E8-TgBf-Ek-TgBG-E8------L0E7/4- --E-BQ---------F--------------------B--E--I-------------------B8-g---QBT-HQ-cgBp-G4-ZwBG-Gk-b-Bl-Ek-
bgBm-G8---BY-g---Qw-DQ-M--5-D--N-BF-DQ---B6-C0--QBD-G8-bQBw-GE-bgB5-E4-YQBt-GU------EE-bgBv-G0-YQBs -G8-dQBz-C--UwBv-GY-d-B3-GE-cgBl-C--R-Bl-HQ-ZQBy-Gk-bwBy-GE-d-Bp-G8-bg-g-EM-bwBy-H--bwBy-GE-d-Bp-G8-
bg------Pg-L--E-RgBp-Gw-ZQBE-GU-cwBj-HI-_QBw-HQ-_QBv-G4------G8-_-Bv-G8-_w-g-FM-U-BQ-EM------D--C--B -EY-_QBs-GU-VgBl-HI-cwBp-G8-bg------M--u-DU-Lg-w-C4-M----Co-BQ-B-Ek-bgB0-GU-cgBu-GE-b-BO-GE-bQBl----
cwBw-H--Yw------j--0--ET-Bl-Gc-YQBs-EM-bwBw-Hk-cgBp-Gc-_-B0----qQ-g-DI-M--y-DQ-I-BB-G4-bwBt-GE-b-Bv -HU-cw-g-FM-bwBm-HQ-dwBh-HI-ZQ-g-EQ-ZQB0-GU-cgBp-G8-cgBh-HQ-_QBv-G4-I-BD-G8-cgBw-G8-cgBh-HQ-_QBv-G4-
---6--k--QBP-HI-_QBn-Gk-bgBh-Gw-RgBp-Gw-ZQBu-GE-bQBl----cwBw-H--Yw-u-GQ-b-Bs-------s--Y--QBQ-HI-bwB k-HU-YwB0-E4-YQBt-GU------G8-_-Bv-G8-_w---DQ-C--BF--cgBv-GQ-dQBj-HQ-VgBl-HI-cwBp-G8-bg---D--Lg-1-C4-
M--uD----BE-----QBW-GE-cgBG-Gk-b-Bl-Ek-bgBm-G8------CQ-B----FQ-cgBh-G4-cwBs-GE-d-Bp-G8-bg------CQTkB---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
:sppc64.dll:

:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:TSforgeActivation

Pour activer Windows, exécutez le script avec le paramètre « /Z-Windows » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actwin=0

Pour activer Windows ESU, exécutez le script avec le paramètre « /Z-ESU » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actesu=0

Pour activer toutes les applications Office (y compris Project/Visio), exécutez le script avec le paramètre « /Z-Office » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actoff=0

Pour activer uniquement Project/Visio, exécutez le script avec le paramètre « /Z-ProjectVisio » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actprojvis=0

Pour activer tous les services Windows/ESU/Office, exécutez le script avec le paramètre « /Z-WindowsESUOffice » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actwinesuoff=0

:: Options avancées :
Pour activer l'hôte KMS Windows (csvlk), exécutez le script avec le paramètre « /Z-WinHost » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actwinhost=0

Pour activer l'hôte KMS Office (csvlk), exécutez le script avec le paramètre « /Z-OffHost » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actoffhost=0

Pour activer le chargement latéral d'applications (APPX) sous Windows 8/8.1 (APPXLOB), exécutez le script avec le paramètre « /Z-APPX » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actappx=0

Pour activer certains identifiants d'activation, remplacez le 0 par un 1 dans la ligne ci-dessous et définissez les identifiants d'activation dans la variable « tsids ». Vous pouvez en saisir plusieurs en ajoutant un espace après chacun d'eux.
Vous pouvez également exécuter le script avec le paramètre « /Z-ID-ActivationIdGoesHere ». Si vous souhaitez ajouter plusieurs paramètres, transmettez-les séparément.
définir _actman=
définir tsids=

Pour réinitialiser le compteur de réarmement, la période d'évaluation et effacer l'état d'antivol, ainsi que le verrouillage de la clé, exécutez le script avec le paramètre « /Z-Reset » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _resall=0

:: Choisissez la méthode d'activation :
Dans les versions 26100 et ultérieures, le script sélectionnera automatiquement StaticCID (connexion Internet requise). En l'absence de connexion Internet, il sélectionnera automatiquement la méthode KMS4k. Pour les versions antérieures à 26100, le script sélectionnera automatiquement ZeroCID.
:: Pour modifier la méthode d'activation, exécutez le script avec les paramètres "/Z-SCID", "/Z-ZCID" ou "/Z-KMS4k", ou modifiez l'option de Auto à SCID, ZCID ou KMS4k dans la ligne ci-dessous.
définir _actmethod=Auto

:: Mode débogage :
Pour exécuter le script en mode débogage, remplacez 0 par n'importe quel paramètre ci-dessus que vous souhaitez exécuter, dans la ligne ci-dessous.
définir "_debug=0"

:: Le script s'exécutera en mode sans surveillance si des paramètres sont utilisés OU si une valeur est modifiée dans les lignes ci-dessus.
:: Si plusieurs options sont sélectionnées, le script n'en choisira qu'une seule parmi les options avancées.



:=================================================================================================================================================

cls
couleur 07
définir KS=K%vide%MS
Titre Activation TSforge %masver%

définir _args=
définir _elev=
définir _unattended=0

définir _args=%*
si _args est défini, définissez _args=%_args:"=%
si _args est défini pour %%A dans (%_args%) faire (
si /i "%%A"="-el" (définir _elev=1)
si /i "%%A"="/Z-Windows" (définir _actwin=1)
si /i "%%A"="/Z-ESU" (définir _actesu=1)
si /i "%%A"="/Z-Office" (définir _actoff=1)
si /i "%%A"=="/Z-ProjectVisio" (définir _actprojvis=1)
si /i "%%A"="/Z-WindowsESUOffice" (définir _actwinesuoff=1)
si /i "%%A"="/Z-WinHost" (définir _actwinhost=1)
si /i "%%A"="/Z-OffHost" (définir _actoffhost=1)
si /i "%%A"="/Z-APPX" (définir _actappx=1)
echo "%%A" | find /i "/Z-ID-" >nul && (set _actman=1& set "filtsids=%%A" & call set "filtsids=%%filtsids:~6%%" & if defined filtsids call set tsids=%%filtsids%% %%tsids%%)
si /i "%%A"="/Z-Reset" (définir _resall=1)
si /i "%%A"="/Z-SCID" (définir _actmethod=SCID)
si /i "%%A"="/Z-ZCID" (définir _actmethod=ZCID)
si /i "%%A"="/Z-KMS4k" (définir _actmethod=KMS4k)
)

si tsids n'est pas défini, définir _actman=0
pour %%A dans (%_actwin% %_actesu% %_actoff% %_actprojvis% %_actwinesuoff% %_actwinhost% %_actoffhost% %_actappx% %_actman% %_resall%) faire (si "%%A"=="1" définir _unattended=1)
if /i not %_actmethod%==Auto set _unattended=1

si %winbuild% LSS 7600 (
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" /v Install %nul2% | find /i "0x1" %nul1% || (
%eline%
echo .NET Framework 3.5 n'est pas installé sur votre système.
echo Installez-le en utilisant l'URL suivante.
écho:
Afficher https://www.microsoft.com/en-us/download/details.aspx?id=25150
Si %_unattended%==0, démarrer https://www.microsoft.com/en-us/download/details.aspx?id=25150
aller à dk_done
)
)

:=================================================================================================================================================

:ts_menu

si %_unattended%==0 (
cls
si le mode terminal n'est pas défini, 76, 33
Titre Activation TSforge %masver%

écho:
écho:
écho:
écho ______________________________________________________________
écho:
echo [1] Activer - Windows
écho [2] Activer - ESU
écho [3] Activer - Office [Tous]
echo [4] Activer - Office [Project/Visio]
écho [5] Activer - Tout
écho _______________________________________________  
écho:
Options avancées de echo :
écho:
echo [A] Activer - Hôte Windows %KS%
echo [B] Activer - Hôte du bureau %KS%
echo [C] Activer - Chargement latéral d'applications Windows 8/8.1
echo [D] Activer - Sélectionner manuellement les produits
si défini _vis (
écho [E] Réinitialisation - Réarmement/Minuteries
) autre (
echo [E] Réinitialisation - Réarmement/Minuteries/Sabotage/Verrouillage
)
echo [F] Changer - Méthode d'activation [%_actmethod%]
écho _______________________________________________       
écho:
echo [6] Supprimer l'activation TSforge
echo [7] Télécharger Office
echo [0] %_exitmsg%
écho ______________________________________________________________
écho:
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier..."
choix /C:12345ABCDEF670 /N
définir _el=!errorlevel!

if !_el!==14 exit /b
if !_el!==13 start %mas%genuine-installation-media & goto :ts_menu
if !_el!==12 call :ts_remove & cls & goto :ts_menu
si !_el!==11 aller à :ts_changemethod
if !_el!==10 cls & setlocal & set "_resall=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==9 cls & setlocal & set "_actman=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==8 cls & setlocal & set "_actappx=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==7 cls & setlocal & set "_actoffhost=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==6 cls & setlocal & set "_actwinhost=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==5 cls & setlocal & set "_actwinesuoff=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==4 cls & setlocal & set "_actprojvis=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==3 cls & setlocal & set "_actoff=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==2 cls & setlocal & set "_actesu=1" & call :ts_start & endlocal & cls & goto :ts_menu
if !_el!==1 cls & setlocal & set "_actwin=1" & call :ts_start & endlocal & cls & goto :ts_menu
aller à :ts_menu
)

aller à :ts_start

:=================================================================================================================================================

:ts_changemethod

cls
si le mode terminal n'est pas défini, 76, 36

écho:
écho:
écho:
écho ______________________________________________________________
écho:
appel :dk_color2 %_Blanc% " [1] " %_Vert% "Auto"
echo Builds ^>= 26100 - Windows uniquement - KMS4k
echo Autres options - StaticCID
écho:
echo Builds ^< 26100 - ZeroCID
écho __________________________________________________
écho:
écho [2] StaticCID
Echo a besoin d'Internet
Non compatible avec Windows 7 ou les versions antérieures.
écho __________________________________________________
écho:
écho [3] ZeroCID
Fonctionne de manière fiable sur les versions inférieures à 26100
echo Ne fonctionne pas sur les versions supérieures à 26100.4188
écho __________________________________________________
écho:
écho [4] KMS4k
Licences en volume uniquement
Echo s'active pendant plus de 4000 ans
écho __________________________________________________
écho:
echo [5] En savoir plus
echo [0] %_exitmsg%
écho ______________________________________________________________
écho:
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier..."
choix /C:123450 /N
définir _el=!errorlevel!

si !_el!==6 aller à :ts_menu
if !_el!==5 cls & start %mas%tsforge &goto :ts_menu
if !_el!==4 cls & set "_actmethod=KMS4k" & goto :ts_menu
if !_el!==3 cls & set "_actmethod=ZCID" & goto :ts_menu
if !_el!==2 cls & set "_actmethod=SCID" & goto :ts_menu
if !_el!==1 cls & set "_actmethod=Auto" & goto :ts_menu
aller à :ts_changemethod

:=================================================================================================================================================

:ts_start

cls

si %_actwinesuoff%==1 (définir la hauteur=38) sinon (définir la hauteur=32)
si le terminal n'est pas défini (
mode 125, %hauteur%
si le fichier "%SysPath%\spp\store_test\" existe en mode 134, %hauteur%
%psc% "&{$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=%height%;$B.Height=300;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}" %nul%
)
Titre Activation TSforge %masver%

écho:
Initialisation en cours...
appel :dk_chkmal

si %SysPath%\%_slexe% n'existe pas (
%eline%
Le fichier [%SysPath%\%_slexe%] est manquant, arrêt...
écho:
si les résultats ne sont pas définis (
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez Dépannage et exécutez les options de restauration DISM et d'analyse SFC."
appel :dk_color %Blue% "Après cela, redémarrez le système et réessayez l'activation."
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Si l'erreur persiste, procédez comme suit : " %_Yellow% " %mas%in-place_repair_upgrade"
)
aller à dk_done
)

pour /f "delims=" %%a dans ('%psc% "[System.Environment]::Version.Major" %nul6%') faire si "%%a"=="2" (
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" /v Install %nul2% | find /i "0x1" %nul1% || (
%eline%
Le framework .NET 3.5 est corrompu ou manquant. Abandon de l'opération…
si existe "%SysPath%\spp\tokens\skus\Security-SPP-Component-SKU-Embedded" (
echo Installez .NET Framework 4.8 et Windows Management Framework 5.1
)
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)
)

si %winbuild% LSS 9200 si existe "%SysPath%\wlms\wlms.exe" (
sc query wlms | find /i "RUNNING" %nul% && (
sc stop %_slser% %nul%
si !errorlevel! EQU 1051 (
%eline%
Le service WLMS d'évaluation est en cours d'exécution. Impossible d'arrêter le service %_slser%. Abandon…
echo Installer la version non-évaluation pour la build Windows %winbuild%.
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)
)
)

:=================================================================================================================================================

si %_actwinesuoff%==1 (définir "_actwin=1" & définir "_actesu=1" & définir "_actoff=1")
si %_actprojvis%==1 (définir "_actoff=1")

définir spp=SoftwareLicensingProduct
définir sps=SoftwareLicensingService

appel :dk_ckeckwmic
appel :dk_checksku
appel :dk_product
appel :dk_sppissue

:=================================================================================================================================================

définir l'erreur=

cls
écho:
appel :dk_showosinfo

si /i %_actmethod%==SCID définir tsmethod=StaticCID
si /i %_actmethod%==ZCID définir tsmethod=ZeroCID
si /i %_actmethod%==KMS4k définir tsmethod=KMS4k

si /i %_actmethod%==Auto (
si %winbuild% GEQ 26100 (
définir tsmethod=StaticCID
si !_actwin!==1 si non !_actwinesuoff!==1 (
définir tsmethod=KMS4k
)
) autre (
définir tsmethod=ZeroCID
)
)

si %winbuild% LSS 9200 si /i %tsmethod%==StaticCID (
%eline%
La méthode StaticCID est prise en charge uniquement sous Windows 8 et versions ultérieures.
aller à dk_done
)

:=================================================================================================================================================

:: Vérifier la connexion Internet

si /i %tsmethod%==StaticCID (
définir _int=
pour %%a dans (l.root-servers.net resolver1.opendns.com download.windowsupdate.com google.com) faire si non défini _int (
for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%a') do (if not "%%#"=="" set _int=1)
)

si non défini _int (
%psc% "Si([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet){Exit 0}Else{Exit 1}"
if !errorlevel!==0 (set _int=1&set ping_f= Mais le ping a échoué)
)

si défini _int (
écho Vérification de la connexion Internet [Connecté !ping_f !]
) autre (
si /i %_actmethod%==Auto si non %_actman%==1 définir tsmethod=KMS4k
si /i !tsmethod!==KMS4k (
appel :dk_color %Red% "Vérification de la connexion Internet [Non connecté]"
appel :dk_color %Blue% "Passage à l'activation KMS4k car Internet est nécessaire pour la méthode StaticCID."
) autre (
définir erreur=1
appel :dk_color %Red% "Vérification de la connexion Internet [Non connecté]"
appel :dk_color %Blue% "Internet requis pour l'option TSforge StaticCID."
)
écho:
)
)

:=================================================================================================================================================

écho Lancement des tests de diagnostic...

définir "_serv=%_slser% Winmgmt"

:: Protection logicielle
:: Instrumentation de gestion Windows

appel :dk_errorcheck

appel :ts_getedition
si non défini tsedition (
appel :dk_color %Red% "Vérification de l'ID de l'édition Windows [Introuvable dans les licences installées, abandon...]"
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à :dk_done
)

si /i !tsmethod!==KMS4k (
appel :_taskclear-cache
echo Nettoyage du cache %KS% [Réussi]
)

:=================================================================================================================================================

si %_resall%==1 aller à :ts_resetall
si %_actman%==1 aller à :ts_actman
si %_actappx%==1 aller à :ts_appxlob
si %_actwinhost%==1 aller à :ts_whost
si %_actoffhost%==1 aller à :ts_ohost
si %_actwin% n'est pas égal à 1, aller à :ts_esu

:=================================================================================================================================================

:: Processus Windows
:: Vérifiez si le système est activé en permanence ou non

écho:
écho Traitement Windows...

echo %tsedition% | find /i "Eval" %nul1% && (
aller à :ts_wineval
)

définir /a UBR=0
si %winbuild% EQU 26100 (
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR %nul6%') do if not errorlevel 1 set /a UBR=%%b
si !UBR! LSS 4188 (définir dontcheckact=1)
)

si non défini, ne pas appeler :ts_checkwinperm
si défini _perm (
appel :dk_color %Gray% "Vérification de l'activation du système d'exploitation [Windows est déjà activé de façon permanente]"
aller à :ts_esu
)

si %winbuild% LSS 9200 si /i %tsmethod%==KMS4k aller à :ts_oldks
si _vis est défini, aller à :ts_winvista

définir tempid=
si /i %tsmethod%==KMS4k (définir keytype=ks) sinon (définir keytype=zero)
pour /f "delims=" %%a dans ('%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':wintsid\:.*';. ([scriptblock]::Create($f[1]))" %nul6%') faire (
echo "%%a" | findstr /r ".*-.*-.*-.*-.*" %nul1% && (set tsids=!tsids! %%a& set tempid=%%a)
)

si tempid défini (
echo Vérification de l'ID d'activation [%tempid%] [%tsedition%]
) autre (
appel :dk_color %Red% "Vérification de l'ID d'activation [Introuvable] [%tsedition%] [%osSKU%]"
définir erreur=1
si /i %tsmethod%==KMS4k (
si /i %_actmethod%==Auto (
Appel : dk_color %Blue% « Retournez au menu précédent et sélectionnez la méthode d’activation StaticCID. Une connexion Internet est requise pour l’activation. »
) autre (
appel :dk_color %Blue% "Utilisez les options d'activation non-KMS4K du menu précédent."
)
)
aller à :ts_esu
)

si winsub est défini (
appel :dk_color %Blue% "Abonnement Windows [ID SKU-%slcSKU%] trouvé. Le script activera l'édition de base [ID SKU-%regSKU%].
écho:
)

aller à :ts_esu

:=================================================================================================================================================

:ts_oldks

Clés KMS pour la méthode KMS4k car TSforge ne peut pas installer de clé KMS sur Windows Vista et 7.

:: 1ère colonne = ID d'activation
:: 2e colonne = Clé générique
:: 3e colonne = ID de l'édition
:: Séparateur = _

définir f=
définir la clé=
définir tempid=
Si non défini, appel à allapps :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f

pour %%# dans (
:: Windows 7
ae2ee509-1b34-41c0-acb7-6d4650168915_33PXH-7Y6KF-2VJC9-XBBR8-HV%f%THH_Enterprise
1cb6d605-11b3-4e14-bb30-da91c8e3983a_YDRBP-3D83W-TY26F-D46B2-XC%f%KRJ_EnterpriseN
b92e9980-b9d5-4821-9c94-140f632f6312_FJ82H-XT6CR-J8D7P-XQJJ2-GP%f%DD4_Professionnel
54a09a0d-d57b-4c10-8b69-a842d6590ad5_MRPKT-YTG23-K7D7T-X2JMM-QY%f%7MG_ProfessionalN
db537896-376f-48ae-a492-53d0547773d0_YBYF6-BHCR3-JPKRB-CDW7B-F9%f%BK4_Embedded_POSReady
aa6dd3aa-c2b4-40e2-a544-a6bbb3f5c395_73KQT-CD9G6-K7TQG-66MRP-CQ%f%22C_Embedded_ThinPC
5a041529-fef8-4d07-b06f-b59b573b32d2_W82YF-2Q76Y-63HXB-FGJG9-GF%f%7QX_ProfessionalE
46bbed08-9c7b-48fc-a614-95250573f4ea_C29WB-22CC8-VJ326-GHFJW-H9%f%DH4_EnterpriseE
:: Windows Server 2008 R2
68531fb9-5511-4989-97be-d11a0f55633f_YC6KT-GKW9T-YTKYR-T4X34-R7%f%VHC_ServerStandard
7482e61b-c589-4b7f-8ecc-46d455ac3b87_74YFP-3QFB3-KQT8W-PMXWJ-7M%f%648_ServerDatacenter
620e2b3d-09e7-42fd-802a-17a13652fe7a_489J6-VHDMP-X63PK-3K798-CP%f%X3Y_ServerEnterprise
7482e61b-c589-4b7f-8ecc-46d455ac3b87_74YFP-3QFB3-KQT8W-PMXWJ-7M%f%648_ServerDatacenterCore
68531fb9-5511-4989-97be-d11a0f55633f_YC6KT-GKW9T-YTKYR-T4X34-R7%f%VHC_ServerStandardCore
620e2b3d-09e7-42fd-802a-17a13652fe7a_489J6-VHDMP-X63PK-3K798-CP%f%X3Y_ServerEnterpriseCore
8a26851c-1c7e-48d3-a687-fbca9b9ac16b_GT63C-RJFQ3-4GMB6-BRFB9-CB%f%83V_ServerEnterpriseIA64
a78b8bd9-8017-4df5-b86a-09f756affa7c_6TPJF-RBVHG-WBW2R-86QPH-6R%f%TM4_ServerWeb
cda18cf3-c196-46ad-b289-60c072869994_TT8MH-CG224-D3D7Q-498W2-9Q%f%CTX_ServerHPC
a78b8bd9-8017-4df5-b86a-09f756affa7c_6TPJF-RBVHG-WBW2R-86QPH-6R%f%TM4_ServerWebCore
f772515c-0e87-48d5-a676-e6962c3e1195_736RG-XDKJK-V34PF-BHK87-J6%f%X3K_ServerEmbeddedSolution
:: Windows Vista
cfd8ff08-c0d7-452b-9f60-ef5c70c32094_VKK3X-68KWM-X2YGT-QR4M6-4B%f%WMV_Enterprise
4f3d1606-3fea-4c01-be3c-8d671c401e3b_YFKBB-PQJJV-G996G-VWGXY-2V%f%3X8_Business
2c682dc2-8b68-4f63-a165-ae291d4cf138_HMBQG-8H2RH-C77VX-27R82-VM%f%QBT_BusinessN
d4f54950-26f2-4fb4-ba21-ffab16afcade_VTC42-BM838-43QHV-84HX6-XJ%f%XKV_EnterpriseN
:: Windows Server 2008
ad2542d4-9154-4c6d-8a44-30f11ee96989_TM24T-X9RMF-VWXK6-X8JC9-BF%f%GM2_ServerStandard
68b6e220-cf09-466b-92d3-45cd964b9509_7M67G-PC374-GR742-YH8V4-TC%f%BY3_ServerDatacenter
c1af4d90-d1bc-44ca-85d4-003ba33db3b9_YQGMW-MPWTJ-34KDK-48M3W-X4%f%Q6V_ServerEnterprise
01ef176b-3e0d-422a-b4f8-4ea880035e8f_4DWFP-JF3DJ-B7DTH-78FJB-PD%f%RHK_ServerEnterpriseIA64
ddfa9f7c-f09e-40b9-8c1a-be877a9a7f4b_WYR28-R7TFJ-3X2YQ-YCY4H-M2%f%49D_ServerWeb
7afb1156-2c1d-40fc-b260-aab7442b62fe_RCTX3-KWVHP-BR6TB-RB6DM-6X%f%7HP_ServerComputeCluster
2401e3d0-c50a-4b58-87b2-7e794b7d2607_W7VD6-7JFBR-RX26B-YKQ3Y-6F%f%FFJ_ServerStandardV
fd09ef77-5647-4eff-809c-af2b64659a45_22XQ2-VRXRG-P8D42-K34TD-G3%f%QQC_ServerDatacenterV
8198490a-add0-47b2-b3ba-316b12d647b4_39BXF-X8Q23-P2WWT-38T2F-G3%f%FPG_ServerEnterpriseV
) faire (
pour /f "tokens=1-3 delims=_" %%A dans ("%%#") faire si %tsedition%==%%C si la clé n'est pas définie (
écho "%allapps%" | trouver /i "%%A" %nul1% && (
définir la clé=%%B
définir tempid=%%A
)
)
)

si la clé n'est pas définie (
appel :dk_color %Red% "Vérification de l'ID d'activation [%tsedition% SKU-%osSKU% %KS% clé non disponible]"
appel :dk_color %Blue% "Utilisez la méthode d'activation ZeroCID du menu précédent."
aller à :ts_esu
)

echo Vérification de l'ID d'activation [%tempid%] [%tsedition%]

définir oldks=1
définir generickey=1
appel :dk_inskey "[%key%]"
définir tsids=%tsids% %tempid%
aller à :ts_esu

:=================================================================================================================================================

:ts_winvista

:: Processus Windows Vista

:: 1ère colonne = ID d'activation
:: 2e colonne = Clé générique
:: 3e colonne = Canal clé
:: 4e colonne = ID de l'édition
:: Séparateur = _

Les clés d'activation ne sont pas disponibles pour ces éditions, mais comme ces éditions ne sont pas disponibles au public, cela n'a pas d'importance.
:: a797d61e-1475-470b-86c8-f737a72c188d DémarreurN
:: 5e9f548a-c8a9-44e6-a6c2-3f8d0a7a99dd ServerComputeClusterV

définir f=
définir la clé=
définir tempid=
Si non défini, appel à allapps :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f

pour %%# dans (
:: Windows Vista
9de9abe2-d01d-4538-af84-4498bdbc2ba3_4D2XH-PRBMM-8Q22B-K8BM3-MR%f%W4W_____Commerce_de_détail
db442be4-81ed-4ab3-9d66-2417e8a5c81c_76884-QXFY2-6Q2WX-2QTQ8-QX%f%X44_____Commerce_de_détailN
b51791c2-b562-4b73-97b0-735a0e4429a6_YQPQV-RW8R3-XMPFG-RXG9R-JG%f%TVF_____Entreprise de vente au détail
58c37517-42f8-4723-bb44-30b05791ff2a_Q7J9R-G63R4-BFMHF-FWM9R-RW%f%DMV_____Retail_EnterpriseN
95c6e80a-0ff8-4bd0-95f2-c4a39b79d09e_RCG7P-TX42D-HM8FM-TCFCW-3V%f%4VD_____Détail_Maison_Basique
d0333dad-c14e-46f2-b62a-8b47a1b9768b_HY2VV-XC6FF-MD6WV-FPYBQ-GF%f%JBT_____Retail_HomeBasicN
9e042223-03bf-49ae-808f-ff37f128d40d_X9HTF-MKJQQ-XK376-TJ7T4-76%f%PKF_____Retail_HomePremium
92d8977c-d506-4e63-b500-6d39283b6cd5_KJ6TP-PF9W2-23T3Q-XTV7M-PX%f%DT2_____Retail_HomePremiumN
89e51a3c-76c0-4beb-a650-53d34c8f8186_X9PYV-YBQRV-9BXWV-TQDMK-QD%f%WK4_____Retail_Starter
30fab9cc-8614-4339-989f-7ce61fb7a5c4_VMCB9-FDRV6-6CDQM-RV23K-RP%f%8F7_____Retail_Ultimate
1eefed20-8ac0-478c-8774-70cd44782ea1_CVX38-P27B4-2X8BT-RXD4J-V7%f%CKX_____Retail_UltimateN
:: WindowsServer2008
c9ad502b-ef48-41d1-a2a0-38a38e82fed0_24FV9-H7JW8-C8Q6X-BQKMK-K9%f%77J_____Retail_ServerComputeCluster
866e924e-c2a3-4872-aca1-6b48c13962d5_6QBHY-DXTPJ-T9W3P-DTJXX-4V%f%QMB_____Centre de données du serveur de vente au détail
d020c729-07f0-4f8f-87ce-bf803275c786_83TWG-TD3TC-HRDP2-K93FJ-Y3%f%4YC_OEM:NONSLP_ServerDatacenterV
32b40e5e-0c6d-4c6f-ab12-a031933fd2c6_MRB7H-QJRHG-FXTBR-B2Q2M-8W%f%MTJ_____Retail_ServerEnterprise
256cc990-1692-4ea8-965c-2d423d5dd24e_H4VB6-QPRWH-VDCYM-996P8-MH%f%KFY_OEM:NONSLP_ServerEnterpriseIA64
1ba5e036-e386-42c4-b7eb-16bdb4fa1945_H8H7M-HDPQT-PJHQF-M7B83-9C%f%VGV_____Retail_ServerEnterpriseV
8df04457-07c8-4301-bce9-d61eb76cb2d6_RGBMC-PQBVF-94Q9K-HD63B-VY%f%6MP_____Retail_ServerHomePremium
5bd23b19-aa71-4a5b-8b68-c8801c2baff6_6C8KR-MD3QK-9GWFW-44CY2-W9%f%CBM_____Retail_ServerHomeStandard
b86c7736-91ff-4de9-bfa9-b32b8a09acac_7XRBY-6MP2K-VQPT8-F37JV-YY%f%Q83_____Retail_ServerMediumBusinessManagement
d3f5642f-081d-40b2-a4b9-efd3054d4584_6PDTD-JK48J-662TF-8J2QV-R4%f%CRB_____Retail_ServerMediumBusinessMessaging
c6936a36-69f3-4994-9857-3069c7b9ec7a_D694V-CMWKH-PY92X-PFQKQ-JC%f%B69_____Retail_ServerMediumBusinessSecurity
cc4c2cf8-ef29-4d8e-b168-2b65a3db3309_MRDK3-YYQF3-88BQJ-D6FJG-69%f%YJY_____Retail_ServerSBSPremium
b3827b27-bd38-4284-98af-e4f4d1c051a0_2KB23-GJRBD-W3T9C-6CH2W-39%f%B7V_____Retail_ServerSBSPrime
5dad0eff-3f6f-4310-8844-422f9dc7c84b_H4XDD-B27GY-667P6-XWVV7-GY%f%G8J_____Retail_ServerSBSStandard
603504f9-109f-49f0-9271-8c66f7878f58_8YVM4-YQBDH-7WDQM-R27WR-WV%f%CWG_____Retail_ServerStandard
65ab7338-9ad0-43fe-af1b-190b577495e2_H9MW3-6V7GK-94P9G-7FTPJ-VK%f%CKF_____Retail_ServerStandardV
2be204da-24a0-4943-b66c-81e8464acd7e_2264C-TD9T8-P8HPW-CC9GH-MH%f%M2V_____Retail_ServerStorageEnterprise
60207eba-8b4a-486c-a013-023b4b742c2f_RCYMT-YX342-8T6YY-XYHYC-3D%f%D7X_____Retail_ServerStorageExpress
368856e9-43f7-4601-8358-e561f36c7dd8_FKFT2-WXYY9-WBPY7-6YMY4-X4%f%8JF_____Retail_ServerStorageStandard
4bf433fa-ab04-4c6c-b55b-00170e14b8cd_8X9J7-HCJ7J-3WDJT-QM7D8-46%f%4YH_____Groupe de travail de stockage du serveur de vente au détail
a77a6806-f59e-4953-97d7-229317b8e6a6_BGT39-9FYH7-X2CYD-T628F-QP%f%QPW_____Retail_ServerWeb
f92f836d-4d3e-4e90-a08f-2d612d65e716_HPH76-FHFPP-DRW9D-7W2V4-HW%f%GKT_____Retail_ServerWinSB
3059a9fd-b068-4f0d-acaf-66324dca67ac_2V8G6-KRXYR-MMGXJ-6RWM3-GX%f%CCG_____Retail_ServerWinSBV
) faire (
pour /f "tokens=1-4 delims=_" %%A dans ("%%#") faire si %tsedition%==%%D si la clé n'est pas définie (
écho "%allapps%" | trouver /i "%%A" %nul1% && (
définir la clé=%%B
définir tempid=%%A
)
)
)

si la clé n'est pas définie (
définir erreur=1
appel :dk_color %Red% "Vérification de l'ID d'activation [%tsedition% SKU-%osSKU% introuvable dans le système]"
appel :dk_color %Bleu% "%_fixmsg%"
aller à :ts_esu
)

echo Vérification de l'ID d'activation [%tempid%] [%tsedition%]

définir generickey=1
appel :dk_inskey "[%key%]"
définir tsids=%tsids% %tempid%
aller à :ts_esu

:=================================================================================================================================================

:ts_wineval

appel :dk_color %Gray% "Vérification de l'édition du système d'exploitation [%tsedition%] [Édition d'évaluation trouvée]"
appel :dk_color %Blue% "Les éditions d'évaluation ne peuvent pas être activées en dehors de la période d'évaluation."

si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum" existe (
appel :dk_color %Blue% "Ce script réinitialisera la période d'évaluation, mais activera Windows de manière permanente,"
appel :dk_color %Blue% "Retournez au menu principal et utilisez l'option [Changer d'édition] pour passer à l'édition non-évaluée."
) autre (
appel :dk_color %Blue% "Ce script réinitialisera la période d'évaluation, mais pour activer Windows de manière permanente, installez l'édition non-évaluation."
appel :dk_color %_Yellow% "%mas%evaluation_editions"
)

:: Vérifier la connexion Internet

définir _int=
pour %%a dans (l.root-servers.net resolver1.opendns.com download.windowsupdate.com google.com) faire si non défini _int (
for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%a') do (if not "%%#"=="" set _int=1)
)

si non défini _int (
%psc% "Si([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet){Exit 0}Else{Exit 1}"
if !errorlevel!==0 (set _int=1&set ping_f= Mais le ping a échoué)
)

si défini _int (
écho Vérification de la connexion Internet [Connecté%ping_f%]
) autre (
définir erreur=1
appel :dk_color %Red% "Vérification de la connexion Internet [Non connecté]"
appel :dk_color %Blue% "Internet requis pour l'activation de l'évaluation de Windows."
)

:: Liste des produits sans clés d'évaluation activables et ISO

:: c4b908d2-c4b9-439d-8ff0-48b656a24da4_EmbeddedIndustryEEval_8.1
:: 9b74255b-afe1-4da7-a143-98d1874b2a6c_EnterpriseNEval_8
:: 7fd0a88b-fb89-415f-9b79-84adc6a7cd56_EnterpriseNEval_8.1
:: 994578eb-193c-4c99-bea0-2483274c9afd_EnterpriseSNEval_2015
:: b9f3109c-bfa9-4f37-9824-6dba9ee62056_ServerStorageStandardEval_2012R2
:: 2d3b7269-65f4-467d-9d51-dbe0e5a4e668_ServerStorageWorkgroupEval_2012R2

:: --------

:: 1ère colonne = ID d'activation
:: 2e colonne = Clé d'évaluation activable
:: 3e colonne = ID de l'édition
:: 4e colonne = Version Windows (à titre indicatif uniquement)
:: 5e colonne = NoAct = l'activation ne fonctionne pas
:: Séparateur = _

définir f=
définir la clé=
définir eval=
Si non défini, appel à allapps :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f

pour %%# dans (
d9eea459-1e6b-499d-8486-e68163f2a8be_N3QJR-YCWKK-RVJGK-GQFMX-T8%f%2BF_EmbeddedIndustryEval_8.1
fbd4c5c6-adc6-4740-bc65-b2dc6dc249c1_MJ8TN-42JH8-886MT-8THCF-36%f%67B_EnterpriseEval_8_NoAct_ REM Nouvelle activation basée sur le temps non disponible
0eebbb45-29d4-49cb-ba87-a23db0cce40a_76FKW-8NR3K-QDH4P-3C87F-JH%f%TTW_EnterpriseEval_8.1
3f4c0546-36c6-46a8-a37f-be13cdd0cf25_7HBDQ-QNKVG-K4RBF-HMBY6-YG%f%9R6_EnterpriseEval_10
1f8dbfe8-defa-4676-b5a6-f76949a01540_4N8VT-7Y686-43DGV-THTW9-M9%f%8W7_EnterpriseNEval_10
57a4ebb6-8e0c-41f8-b79e-8872ddc971ef_W63GF-7N4D9-GQH3K-K4FP7-9B%f%T6C_EnterpriseSEval_2015
b47dd250-fd6a-44c8-9217-03aca6e4812e_N4DMT-RJKDQ-XR6H7-3DKKP-3Y%f%JWT_EnterpriseSEval_2016
267bf82d-08e8-4046-b061-9ef3f8ac2b5a_N7HMH-MK36Q-M4X93-76KQ2-6J%f%HWR_EnterpriseSEval_2019
aff25f1f-fb53-4e27-95ef-b8e5aca10ac6_9V4NK-624Y3-VK47R-Q27GP-27%f%PGF_EnterpriseSEval_2021
399f0697-886b-4881-894c-4ff6c52e7d8f_CYPB3-XNV9V-QR4G4-Q3B8K-KQ%f%FGJ_EnterpriseSEval_2024
6162e8c2-3c30-46e1-b964-0de603498e2d_R34N9-HJ6Q3-GBX4F-Q24KQ-49%f%DF7_EnterpriseSNEval_2016
aed14fc8-907d-44fb-a3a1-d5d8e638acb3_MHN9Q-RD9PW-BFHDQ-9FTWQ-WQ%f%PF8_EnterpriseSNEval_2019
5dd0c869-eae9-40ce-af48-736692cd8e43_XCN62-29X92-C4T8X-WP82X-DY%f%MJ8_EnterpriseSNEval_2021
522cc0dc-3c7b-4258-ae68-f297ca63b64e_Y8DJM-NPXF3-QG4MH-W7WJK-KQ%f%FGM_EnterpriseSNEval_2024
aa708397-8618-42de-b120-a44190ef456d_R63DV-9NPDX-QVWJF-HMR8V-M4%f%K7D_IoTEnterpriseSEval_2024
cd25b1e8-5839-4a96-a769-b6abe3aa5dee_73BMN-332G9-DX6B8-FGDT3-GF%f%YT6_ServerDatacenterEval_2012
e628c5e8-2300-4429-8b80-a8b21bd7ce0a_WPR94-KN3J7-MRB7X-JPJV8-RX%f%7J2_ServerDatacenterEval_2012R2
01398239-85ff-487f-9e90-0e3cc5bcc92e_QVTQ9-GNRBH-JQ9G7-W7FBW-RX%f%9QR_ServerDatacenterEval_2016
5ea4af9e-fd59-4691-b61c-1fc1ff3e309e_KNW3G-22YD2-7QKQJ-2RF2X-H6%f%F8M_ServerDatacenterEval_2019
1d02774d-66ab-4c57-8b14-e254fdce09d4_PK7JN-24236-FH7JP-V792F-37%f%CYR_ServerDatacenterEval_2021
96794a98-097f-42fe-8f28-2c38ea115229_M4RNW-CRTHF-TY7BG-DDHG6-J2%f%T92_ServerDatacenterEval_2025
38d172c7-36b3-4e4b-b435-fd0b06b95c6e_RNFGD-WFFQR-XQ8BG-K7QQK-GJ%f%CP9_ServerStandardEval_2012
4fc45a88-26b5-4cf9-9eef-769ee3f0a016_79M8M-N36BX-8YGJY-2G9KP-3Y%f%GPC_ServerStandardEval_2012R2
9dfa8ec0-7665-4b9d-b2cb-bfc2dc37c9f4_9PBKX-4NHGT-QWV4C-4JD94-TV%f%KQ6_ServerStandardEval_2016
7783a126-c108-4cf7-b59f-13c78c7a7337_J4WNC-H9BG3-6XRX4-3XD8K-Y7%f%XRX_ServerStandardEval_2019
c1a197b6-ba5e-4394-b9bf-b659a6c1b873_7PBJM-MNVPD-MBQD7-TYTY4-W8%f%JDY_ServerStandardEval_2021
753c53a2-4274-4339-8c2e-f66c0b9646c5_YPBVM-HFNWQ-CTF9M-FR4RR-7H%f%9YG_ServerStandardEval_2025
0de5ff31-2d62-4912-b1a8-3ea01d2461fd_3CKBN-3GJ8X-7YT4X-D8DDC-D6%f%69B_ServerStorageStandardEval_2012
fb08f53a-e597-40dc-9f08-8bbf99f19b92_NCJ6J-J23VR-DBYB3-QQBJF-W8%f%CP7_ServerStorageWorkgroupEval_2012
) faire (
pour /f "tokens=1-5 delims=_" %%A dans ("%%#") faire si %tsedition%==%%C si la clé n'est pas définie (
écho "%allapps%" | trouver /i "%%A" %nul1% && (
définir la clé=%%B
définir eval=1
si /i "%%E"="NoAct" définir noact=1
écho Vérification de l'ID d'activation [%%A] [%%C]
)
)
)

si la clé n'est pas définie (
définir erreur=1
appel :dk_color %Red% "Vérification de l'ID d'activation [%tsedition% introuvable dans le script]"
appel :dk_color %Blue% "Assurez-vous d'utiliser la version mise à jour du script."
aller à :ts_esu
)

définir resetstuff=1
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':tsforge\:.*';. ([scriptblock]::Create($f[1]))"
définir resetstuff=
si !errorlevel!==3 (
définir erreur=1
appel :dk_color %Red% "Réinitialisation du réarmement / période de grâce [Échec]"
appel :dk_color %Bleu% "%_fixmsg%"
aller à :ts_esu
) autre (
écho Réinitialisation du réarmement / période de grâce [Réussie]
)

définir generickey=1
appel :dk_inskey "[%key%]"

:=================================================================================================================================================

:ts_esu

si %_actesu% n'est pas égal à 1, aller à :ts_off
si /i %tsmethod%==KMS4k (
appel :dk_color %Red% "Ignorer l'ESU Windows [la méthode KMS4k n'est pas prise en charge avec l'ESU Windows]"
si /i %_actmethod%==Auto (
Appel :dk_color %Blue% "Connectez-vous à Internet et réessayez. Le script utilisera la méthode d'activation StaticCID."
) autre (
appel :dk_color %Blue% "Utilisez les options d'activation non-KMS4K du menu précédent."
)
aller à :ts_off
)

:: Processus Windows ESU

écho:
écho Traitement Windows ESU...

définir esuexist=
définir esuexistsup=
définir esueditionlist=
définir esuexistbutnosup=

si %winbuild% GTR 14393 pour %%# dans (EnterpriseS IoTEnterpriseS IoTEnterpriseSK) faire (si /i %tsedition%==%%# définir isltsc=1)
Si le fichier « %SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum » existe, définissez isServer=1

si /i %tsedition%==Embedded (
Si le fichier « %SystemRoot%\Servicing\Packages\WinEmb-Branding-Embedded-ThinPC-Package*.mum » existe, définissez isThinpc=1
si le fichier "%SystemRoot%\Servicing\Packages\WinEmb-Branding-Embedded-POSReady7-Package*.mum" existe, définissez subEdition=[POS]
si le fichier "%SystemRoot%\Servicing\Packages\WinEmb-Branding-Embedded-Standard-Package*.mum" existe, définissez subEdition=[Standard]
)
Si non défini, appel à allapps :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f

définir w10EsuEditions=Éducation-ÉducationN-Entreprise-EntrepriseN-Professionnel-FormationProfessionnelle-FormationProfessionnelleN-ProfessionnelN-PosteDeTravailProfessionnel-PosteDeTravailProfessionnelN

définir minbuild=0
si /i %tsedition%==ServerRdsh définir minbuild=5552
pour %%# dans (Core CoreN CoreCountrySpecific CoreSingleLanguage IoTEnterprise) faire (si /i %tsedition%==%%# définir minbuild=6156)
si /i %tsedition%==PPIPro définir minbuild=6388

définir /a UBR=0
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR %nul6%') do if not errorlevel 1 set /a UBR=%%b
si %winbuild% EQU 19045 si %minbuild% GTR 0 si %UBR% GEQ %minbuild% (
définir w10EsuEditionsLaterAdded=%tsedition%-
)

si non défini isThinpc si non défini isltsc pour %%# dans (
REM Windows 7
4220f546-f522-46df-8202-4d07afd26454_Client-ESU-Année3[1-3y]_-Entreprise-EntrepriseE-EntrepriseN-Professionnel-ProfessionnelE-ProfessionnelN-Ultime-UltimeE-UltimeN-
7e94be23-b161-4956-a682-146ab291774c_Client-ESU-Année6[4-6y]_-Entreprise-EntrepriseE-EntrepriseN-Professionnel-ProfessionnelE-ProfessionnelN-Ultime-UltimeE-UltimeN-
REM Windows7EmbeddedPOSReady7
4f1f646c-1e66-4908-acc7-d1606229b29e_POS-ESU-Année3[1-3y]_-Intégré[POS]-
REM Windows 7 Embedded Standard
6aaf1c7d-527f-4ed5-b908-9fc039dfc654_WES-ESU-Année3[1-3y]_-Embedded[Standard]-
REM Windows Server 2008/Windows Server 2008 R2
8e7bfb1e-acc1-4f56-abae-b80fce56cd4b_Server-ESU-PA[1-6y]_-ServerDatacenter-ServerDatacenterCore-ServerDatacenterV-ServerDatacenterVCore-ServerStandard-ServerStandardCore-ServerStandardV-ServerStandardVCore-ServerEnterprise-ServerEnterpriseCore-ServerEnterpriseV-ServerEnterpriseVCore-
REM Windows 8.1
4afc620f-12a4-48ad-8015-2aebfbd6e47c_Client-ESU-Année3[1-3y]_-Entreprise-EntrepriseN-Professionnel-ProfessionnelN-
11be7019-a309-4763-9a09-091d1722ffe3_Client-FES-ESU-Année3[1-3y]_-EmbeddedIndustry-EmbeddedIndustryE-
REM Windows Server 2012/2012 R2
55b1dd2d-2209-4ea0-a805-06298bad25b3_Server-ESU-Year3[1-3y]_-ServerDatacenter-ServerDatacenterCore-ServerDatacenterV-ServerDatacenterVCore-ServerStandard-ServerStandardCore-ServerStandardV-ServerStandardVCore-
1b60284a-63b5-42da-8ec9-eaab825e2bc8_Server-ESU-Année5[4-5y]_-ServerDatacenter-ServerDatacenterCore-ServerDatacenterV-ServerDatacenterVCore-ServerStandard-ServerStandardCore-ServerStandardV-ServerStandardVCore-
REM Windows 10
f520e45e-7413-4a34-a497-d2765967d094_Client-ESU-Année1_-%w10EsuEditions%-%w10EsuEditionsLaterAdded%
1043add5-23b1-4afb-9a0f-64343c8f3f8d_Client-ESU-Année2_-%w10EsuEditions%-%w10EsuEditionsLaterAdded%
83d49986-add3-41d7-ba33-87c7bfb5c0fb_Client-ESU-Année3_-%w10EsuEditions%-%w10EsuEditionsLaterAdded%
0b533b5e-08b6-44f9-b885-c2de291ba456_Client-ESU-Année6[4-6y]_-%w10EsuEditions%-%w10EsuEditionsLaterAdded%
REM WindowsServer2016
91bcac0a-d7d3-4d2b-bd0c-72fed675f01b_Server-ESU-Année3[1-3y]_-ServerDatacenter-ServerDatacenterCore-ServerDatacenterV-ServerDatacenterVCore-ServerStandard-ServerStandardCore-ServerStandardV-ServerStandardVCore-
4cd0ab30-73a4-4dde-972c-512f05be31df_Server-ESU-Année6[4-6y]_-ServerDatacenter-ServerDatacenterCore-ServerDatacenterV-ServerDatacenterVCore-ServerStandard-ServerStandardCore-ServerStandardV-ServerStandardVCore-
REM Windows10LTSB2016
f2571710-2c24-4677-8fb5-a07d41d3c1aa_Client-ESU-Année3[1-3y]_-EnterpriseS-EnterpriseSN-
22badfe6-7d55-4485-874b-7ec317442134_Client-ESU-Année6[4-6y]_-EnterpriseS-EnterpriseSN-
) faire (
pour /f "tokens=1-3 delims=_" %%A dans ("%%#") faire (
écho "%allapps%" | trouver /i "%%A" %nul1% && (
définir esuexist=1
echo "%%C" | find /i "-%tsedition%%subEdition%-" %nul1% && (
définir esuexistsup=1
définir esueditionlist=
définir esuexistbutnosup=
définir tsids=!tsids! %%A
écho Vérification de l'ID d'activation [%%A] [%%B]
) || (
si non défini, esueditionlist est défini sur %%C
définir esuexistbutnosup=1
)
)
)
)

si défini esuexistsup si défini _vis (
définir la clé=9FPV7-MWGT8-7XPDF-JC23W-WT7TW
REM Ceci est une clé MAK bloquée non générique pour Server-ESU-PA
appel :dk_inskey "[!key!]"
aller à :ts_off
)

si défini esuexistsup (
echo "%tsids%" | find /i "4220f546-f522-46df-8202-4d07afd26454" %nul1% && (
echo "%tsids%" | find /i "7e94be23-b161-4956-a682-146ab291774c" %nul1% || (
appel :dk_color %Gray% "Pour obtenir la licence Client-ESU-Year6[4-6y], installez les mises à jour à partir de l'URL ci-dessous."
appel :dk_color %Blue% "%mas%tsforge#windows-esu"
)
)
aller à :ts_off
)

si défini isltsc (
appel :dk_color %Gray% "Vérification de l'ID d'activation [%tsedition% LTSC bénéficie déjà d'une prise en charge plus longue, l'ESU n'est pas applicable]"
aller à :ts_off
)

si défini esuexistbutnosup (
appel :dk_color %Red% "Vérification de l'ID d'activation [La licence ESU actuellement installée n'est pas prise en charge pour %tsedition%]"
écho:
si %winbuild% EQU 19045 si non défini w10EsuEditionsLaterAdded (
Appel :dk_color %Blue% "Pour obtenir la dernière version, accédez aux paramètres Windows et exécutez Windows Update. Ensuite, réessayez le script."
aller à :ts_off
)
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez l'option Changer l'édition de Windows et choisissez l'une des éditions listées ci-dessous."
echo [%esueditionlist%]
aller à :ts_off
)

définir esuavail=
si _vis est défini si isServer est défini définir esuavail=1
si %winbuild% LEQ 7602 si non défini _vis si non défini isThinpc définir esuavail=1
si %winbuild% GTR 7602 si %winbuild% LEQ 14393 si défini isServer définir esuavail=1
si %winbuild% GEQ 10240 si %winbuild% LEQ 19045 si non défini isServer définir esuavail=1
si %winbuild% EQU 9600 définir esuavail=1

si défini esuavail (
appel :dk_color %Red% "Vérification de l'ID d'activation [Licence ESU introuvable, assurez-vous que Windows est entièrement à jour]"
définir les correctifs=%fixes% %mas%tsforge#windows-esu
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%tsforge#windows-esu"
) autre (
appel :dk_color %Gray% "Vérification de l'ID d'activation [ESU n'est pas disponible pour %winos%]"
)

:=================================================================================================================================================

:ts_off

si %_actoff% n'est pas égal à 1, aller à :ts_act

si %winbuild% LSS 9200 (
écho:
appel :dk_color %Gray% "Vérification de la compatibilité avec Office [TSforge pour Office est compatible avec Windows 8 et versions ultérieures]"
appel :dk_color %Blue% "Sur Windows Vista / 7, utilisez plutôt l'option d'activation Ohook pour Office."
aller à :ts_act
)

:: Vérifier l'installation d'ohook

définir ohook=
pour %%# dans (15 16) faire (
pour %%A dans ("%ProgramFiles%" "%ProgramW6432%" "%ProgramFiles(x86)%") faire (
si le fichier "%%~A\Microsoft Office\Office%%#\sppc*dll" existe, définissez ohook=1
)
)

pour %%# dans (System SystemX86) faire (
pour %%G dans ("Office 15" "Office") faire (
pour %%A dans ("%ProgramFiles%" "%ProgramW6432%" "%ProgramFiles(x86)%") faire (
si le fichier "%%~A\Microsoft %%~G\root\vfs\%%#\sppc*dll" existe, définissez ohook=1
)
)
)

si défini ohook (
écho:
appel :dk_color %Gray% "Vérification d'Ohook [L'activation d'Ohook est déjà installée pour Office]"
)

:: Vérifier les versions d'Office non prises en charge

définir o14msi=
définir o14c2r=

définir _68=HKLM\SOFTWARE\Microsoft\Office
définir _86=HKLM\SOFTWARE\Wow6432Node\Microsoft\Office
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\14.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o14msi=Office 2010 MSI )
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\14.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o14msi=Office 2010 MSI )
%nul% reg query %_68%\14.0\CVH /f Click2run /k && set o14c2r=Office 2010 C2R
%nul% reg query %_86%\14.0\CVH /f Click2run /k && set o14c2r=Office 2010 C2R

si ce n'est pas "%o14msi%%o14c2r%"="" (
écho:
appel :dk_color %Red% "Vérification de l'installation Office non prise en charge [ %o14msi%%o14c2r%]"
si défini o14msi appel :dk_color %Blue% "Utiliser l'option d'activation Ohook pour Office 2010."
)

si %winbuild% GEQ 10240 %psc% "Get-AppxPackage -name "Microsoft.MicrosoftOfficeHub"" | find /i "Office" %nul1% && (
définir ohub=1
)

:=================================================================================================================================================

:: Vérifier les versions d'Office prises en charge

appel :ts_getpath

définir o16uwp=
définir o16uwp_path=

si %winbuild% GEQ 10240 (
for /f "delims=" %%a in ('%psc% "(Get-AppxPackage -name 'Microsoft.Office.Desktop' | Select-Object -ExpandProperty InstallLocation)" %nul6%') do (if exist "%%a\Integration\Integrator.exe" (set o16uwp=1&set "o16uwp_path=%%a"))
)

sc query ClickToRunSvc %nul%
définir error1=%errorlevel%

si défini o16c2r si %error1% EQU 1060 (
écho:
appel :dk_color %Red% "Vérification du service ClickToRun [Introuvable, fichiers Office 16.0 trouvés]"
définir o16c2r=
définir erreur=1
)

sc query OfficeSvc %nul%
définir error2=%errorlevel%

si défini o15c2r si %error1% EQU 1060 si %error2% EQU 1060 (
écho:
appel :dk_color %Red% "Vérification du service ClickToRun [Introuvable, fichiers Office 15.0 trouvés]"
définir o15c2r=
définir erreur=1
)

si "%o16uwp%%o16c2r%%o15c2r%%o16msi%%o15msi%"="" (
définir erreur=1
définir showfix=1
écho:
si ce n'est pas "%o14msi%%o14c2r%"="" (
appel :dk_color %Red% "Vérification de l'installation d'Office prise en charge [Introuvable]"
) autre (
si %_actwin%==0 (
appel :dk_color %Red% "Vérification d'Office installé [Introuvable]"
) autre (
appel :dk_color %Gray% "Vérification de l'installation d'Office [Introuvable]"
)
)

si ohub est défini (
écho:
Vous n'avez installé que l'application Office Dashboard ; vous devez installer la version complète d'Office.
)
appel :dk_color %Blue% "Téléchargez et installez Office à partir de l'URL ci-dessous, puis réessayez."
si %_actwin%==0 définir fixes=%fixes% %mas%genuine-installation-media
appel :dk_color %_Yellow% "%mas%genuine-installation-media"
aller à :ts_act
)

définir multioffice=
si ce n'est pas "%o16uwp%%o16c2r%%o15c2r%%o16msi%%o15msi%"="1", définir multioffice=1
si ce n'est pas "%o14c2r%%o14msi%"="" définir multioffice=1

si défini multioffice (
écho:
appel :dk_color %Gray% "Vérification de plusieurs installations d'Office [Détectées. Il est recommandé d'installer une seule version]"
)

:=================================================================================================================================================

:: Vérifier le serveur Windows

définir winserver=
reg query "HKLM\SYSTEM\CurrentControlSet\Control\ProductOptions" /v ProductType %nul2% | find /i "WinNT" %nul1% || set winserver=1
si non défini winserver (
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID %nul2% | find /i "Server" %nul1% && set winserver=1
)

:=================================================================================================================================================

:: Process Office UWP

Si o16uwp n'est pas défini, aller à :ts_starto15c2r

appel :ts_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir oVer=16
définir "_oLPath=%o16uwp_path%\Licenses16"
définir "pkeypath=%o16uwp_path%\Office16\pkeyconfig-office.xrm-ms"
for /f "delims=" %%a in ('%psc% "(Get-AppxPackage -name 'Microsoft.Office.Desktop' | Select-Object -ExpandProperty Dependencies) | Select-Object PackageFullName" %nul6%') do (set "o16uwpapplist=!o16uwpapplist! %%a")

echo "%o16uwpapplist%" | findstr /i "Access Excel OneNote Outlook PowerPoint Publisher SkypeForBusiness Word" %nul% && set "_oIds=O365HomePremRetail"

pour %%# dans (Projet Visio) faire (
echo "%o16uwpapplist%" | findstr /i "%%#" %nul% && (
définir _lat=
si le fichier "%_oLPath%\%%#Pro2024VL*.xrm-ms" existe, définissez "_oIds= !_oIds! %%#Pro2024Retail " et définissez _lat=1
Si la variable _lat n'est pas définie et que le fichier "%_oLPath%\%%#Pro2021VL*.xrm-ms" existe, alors définir "_oIds= !_oIds! %%#Pro2021Retail " et définir _lat=1
Si la variable _lat n'est pas définie et que le fichier "%_oLPath%\%%#Pro2019VL*.xrm-ms" existe, alors définir "_oIds= !_oIds! %%#Pro2019Retail " et définir _lat=1
si non défini _lat définir "_oIds= !_oIds! %%#ProRetail "
)
)

définir uwpinfo=%o16uwp_path:C:\Program Files\WindowsApps\Microsoft.Office.Desktop_=%

écho:
echo Bureau de traitement... [UWP ^| %uwpinfo%]

si non défini _oIds (
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
définir erreur=1
aller à :ts_starto15c2r
)

appel :ts_process

:=================================================================================================================================================

:ts_starto15c2r

:: Process Office 15.0 C2R

Si o15c2r n'est pas défini, aller à :ts_starto16c2r

appel :ts_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir oVer=15
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg% /v InstallPath" %nul6%') do (set "_oRoot=%%b\root")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v Platform" %nul6%') do (set "_oArch=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v VersionToReport" %nul6%') do (set "_version=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v ProductReleaseIds" %nul6%') do (set "_prids=%o15c2r_reg%\Configuration /v ProductReleaseIds" & set "_config=%o15c2r_reg%\Configuration")
si _oArch n'est pas défini pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o15c2r_reg%\propertyBag /v Platform" %nul6%') faire (définir "_oArch=%%b")
si la version n'est pas définie pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o15c2r_reg%\propertyBag /v version" %nul6%') faire (définir "_version=%%b")
Si la variable `_prids` n'est pas définie pour `/f "skip=2 tokens=2*" %%a` dans `'"reg query %o15c2r_reg%\propertyBag /v ProductReleaseId" %nul6%'`, alors `(set "_prids=%o15c2r_reg%\propertyBag /v ProductReleaseId" & set "_config=%o15c2r_reg%\propertyBag")`

echo "%o15c2r_reg%" | find /i "Wow6432Node" %nul1% && (set _tok=10) || (set _tok=9)
pour /f "tokens=%_tok% delims=\" %%a dans ('reg query %o15c2r_reg%\ProductReleaseIDs\Active %nul6% ^| findstr /i "Retail Volume"') faire (
echo "!_oIds!" | find /i " %%a " %nul1% || (set "_oIds= !_oIds! %%a ")
)

définir "_oLPath=%_oRoot%\Licenses"
définir "pkeypath=%_oRoot%\Office15\pkeyconfig-office.xrm-ms"
définir "_oIntegrator=%_oRoot%\integration\integrator.exe"

écho:
echo Traitement en cours... [C2R ^| %_version% ^| %_oArch%]

si non défini _oIds (
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
définir erreur=1
aller à :ts_starto16c2r
)

appel :oh_expiredpreview 2013
si "%_actprojvis%"=="0" appelez :oh_fixprids
appel :ts_process

:=================================================================================================================================================

:ts_starto16c2r

:: Process Office 16.0 C2R

Si o16c2r n'est pas défini, aller à :ts_startmsi

appel :ts_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir oVer=16
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg% /v InstallPath" %nul6%') do (set "_oRoot=%%b\root")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v Platform" %nul6%') do (set "_oArch=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v VersionToReport" %nul6%') do (set "_version=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v AudienceData" %nul6%') do (set "_AudienceData=^| %%b ")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v ProductReleaseIds" %nul6%') do (set "_prids=%o16c2r_reg%\Configuration /v ProductReleaseIds" & set "_config=%o16c2r_reg%\Configuration")

echo "%o16c2r_reg%" | find /i "Wow6432Node" %nul1% && (set _tok=9) || (set _tok=8)
pour /f "tokens=%_tok% delims=\" %%a dans ('reg query "%o16c2r_reg%\ProductReleaseIDs" /s /f ".16" /k %nul6% ^| findstr /i "Retail Volume"') faire (
echo "!_oIds!" | find /i " %%a " %nul1% || (set "_oIds= !_oIds! %%a ")
)
définir _oIds=%_oIds:.16=%
définir _o16c2rIds=%_oIds%

définir "_oLPath=%_oRoot%\Licenses16"
définir "pkeypath=%_oRoot%\Office16\pkeyconfig-office.xrm-ms"
définir "_oIntegrator=%_oRoot%\integration\integrator.exe"

écho:
echo Traitement en cours... [C2R ^| %_version% %_AudienceData%^| %_oArch%]

si non défini _oIds (
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
définir erreur=1
aller à :ts_startmsi
)

appel :oh_expiredpreview 2016 2019 2021 2024
si "%_actprojvis%"=="0" appelez :oh_fixprids
appel :ts_process

:=================================================================================================================================================

:: mass{}grave{dot}dev/office-license-is-not-genuine
:: Ajouter des clés de registre pour les produits en volume afin que le bandeau « non authentique » n'apparaisse pas

définir "kmskey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\0ff1ce15-a989-479d-af46-f275c6370663"
si /i %tsmethod%==KMS4k (
si %winbuild% GEQ 9200 (
si ce n'est pas "%osarch%"="x86" (
reg delete "%kmskey%" /f /reg:32 %nul%
reg add "%kmskey%" /f /v KeyManagementServiceName /t REG_SZ /d "10.0.0.10" /reg:32 %nul%
)
reg delete "%kmskey%" /f %nul%
reg add "%kmskey%" /f /v KeyManagementServiceName /t REG_SZ /d "10.0.0.10" %nul%
echo Ajout d'une entrée de registre pour empêcher l'affichage de la bannière [Réussi]
)
)

:=================================================================================================================================================

:ts_startmsi

si défini o15msi appel :ts_processmsi 15 %o15msi_reg%
si défini o16msi appel :ts_processmsi 16 %o16msi_reg%

:=================================================================================================================================================

écho:
appel :oh_clearblock
si "%o16msi%%o15msi%"="" si ce n'est pas "%o16uwp%%o16c2r%%o15c2r%"="" appeler :oh_uninstkey
appel :oh_licrefresh

aller à :ts_act

:=================================================================================================================================================

:ts_whost

:: Processus hôte KMS Windows

écho:
écho Traitement de l'hôte Windows %KS%...

si /i %tsmethod%==KMS4k (
écho:
appel :dk_color %Red% "Ignorer l'hôte Windows %KS% [La méthode KMS4k n'est pas prise en charge avec l'hôte Windows %KS%]"
si /i %_actmethod%==Auto (
Appel :dk_color %Blue% "Connectez-vous à Internet et réessayez. Le script utilisera la méthode d'activation StaticCID."
) autre (
appel :dk_color %Blue% "Utilisez les options d'activation non-KMS4K du menu précédent."
)
aller à :ts_act
)

écho:
si %winbuild% GEQ 10586 (
Appel :dk_color %Gray% "Avec une licence hôte %KS%, l'édition de Windows peut changer aléatoirement par la suite. Il s'agit d'un problème Windows qui peut être ignoré sans risque."
)
appel :dk_color %Gray% "La licence %KS% Host [à ne pas confondre avec %KS% Client] provoque l'exécution continue du service %_slser%."
appel :dk_color %Blue% "N'utilisez cette activation qu'en cas de besoin, vous pouvez revenir à l'activation normale depuis le menu précédent."

si %_unattended%==0 (
écho:
choix /C:0F /N /M "> [0] Retour [F] Continuer : "
if !errorlevel!==1 exit /b
écho:
)

définir _arr=
définir tempid=
définir keytype=kmshost

si _vis est défini, aller à :ts_whost_vista

Installez la licence CSVLK de l'édition actuelle afin que l'édition correcte soit prise en compte pour CSVLK.

si %winbuild% GEQ 10586 (
pour %%# dans ("%SysPath%\spp\tokens\skus\%tsedition%\*CSVLK*.xrm-ms") faire (
si _arr est défini (définir "_arr=!_arr!;"%SysPath%\spp\tokens\skus\%tsedition%\%%~nx#"") sinon (définir "_arr="%SysPath%\spp\tokens\skus\%tsedition%\%%~nx#"")
)
si défini _arr %psc% "$sls = Get-WmiObject %sps%; $f=[IO.File]::ReadAllText('!_batp!') -split ':xrm\:.*';. ([scriptblock]::Create($f[1])); InstallLicenseArr '!_arr!'" %nul%
)

pour /f "delims=" %%a dans ('%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':wintsid\:.*';. ([scriptblock]::Create($f[1]))" %nul6%') faire (
echo "%%a" | findstr /r ".*-.*-.*-.*-.*" %nul1% && (set tsids=!tsids! %%a& set tempid=%%a)
)

si tempid défini (
echo Vérification de l'ID d'activation [%tempid%] [%tsedition%]
) autre (
appel :dk_color %Red% "Vérification de l'ID d'activation [Introuvable] [%tsedition%] [%osSKU%]"
appel :dk_color %Blue% "%KS% La licence hôte est introuvable sur votre système. Elle est disponible pour les éditions ci-dessous."
appel :dk_color %Blue% "Éditions Professionnel, Éducation, ProfessionalWorkstation, Entreprise, EntrepriseS et Serveur, etc."
aller à :ts_act
)

si winsub est défini (
écho:
appel :dk_color %Blue% "Abonnement Windows [ID SKU-%slcSKU%] trouvé. Le script activera l'édition de base [ID SKU-%regSKU%].
)

aller à :ts_act

:=================================================================================================================================================

:ts_whost_vista

:: Processus hôte KMS Windows pour Vista

:: 1ère colonne = ID d'activation
:: 2e colonne = clé CSVLK
:: 3e colonne = Identifiants de l'édition
:: Séparateur = _

définir f=
définir la clé=
définir tempid=
Si non défini, appel à allapps :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f

pour %%# dans (
:: Windows Vista
212a64dc-43b1-4d3d-a30c-2fc69d2095c6_TWVG3-9Q4P8-W9XJF-Y76FJ-DW%f%Q4R_-Business-BusinessN-Enterprise-EnterpriseN-
:: WindowsServer2008
c90d1b4e-8aa8-439e-8b9e-b6d6b6a6d975_BHC4Q-6D7B7-QMVH7-4MKQH-Y9%f%VK7_-ServerComputeCluster-ServerDatacenter-ServerDatacenterV-ServerEnterprise-ServerEnterpriseIA64-ServerEnterpriseV-ServerStandard-ServerStandardV-ServerWeb-
56df4151-1f9f-41bf-acaa-2941c071872b_PVGKG-2R7XQ-7WTFD-FXTJR-DQ%f%BQ3_-ServerComputeCluster-ServerEnterprise-ServerEnterpriseV-ServerStandard-ServerStandardV-ServerWeb-
c448fa06-49d1-44ec-82bb-0085545c3b51_KH4PC-KJFX6-XFVHQ-GDK2G-JC%f%JY9_-ServerComputeCluster-ServerWeb-
) faire (
pour /f "tokens=1-3 delims=_" %%A dans ("%%#") faire si la clé n'est pas définie (
écho "%allapps%" | trouver /i "%%A" %nul1% && (
echo "%%C" | find /i "-%tsedition%-" %nul1% && (
définir la clé=%%B
définir tempid=%%A
)
)
)
)

si la clé est définie (
echo Vérification de l'ID d'activation [%tempid%] [%tsedition%]
) autre (
appel :dk_color %Red% "Vérification de l'ID d'activation [Introuvable] [%tsedition%] [%osSKU%]"
appel :dk_color %Blue% "%KS% La licence hôte est introuvable sur votre système. Elle est disponible pour les éditions ci-dessous."
appel :dk_color %Blue% "Éditions Business, BusinessN, Enterprise, EnterpriseN et Server, etc."
aller à :ts_act
)

appel :dk_inskey "[%key%]"
définir tsids=%tsids% %tempid%
aller à :ts_act

:=================================================================================================================================================

:ts_ohost

:: Hôte KMS de Process Office

écho:
écho Traitement du bureau %KS% Hôte...

si défini _vis (
écho:
appel :dk_color %Blue% "Windows Vista et Server 2008 ne prennent pas en charge l'installation de l'hôte KMS Office."
aller à :ts_act
)

si /i %tsmethod%==KMS4k (
écho:
appel :dk_color %Red% "Ignorer l'hôte Office %KS% [La méthode KMS4k n'est pas prise en charge avec l'hôte Office %KS%]"
si /i %_actmethod%==Auto (
Appel :dk_color %Blue% "Connectez-vous à Internet et réessayez. Le script utilisera la méthode d'activation StaticCID."
) autre (
appel :dk_color %Blue% "Utilisez les options d'activation non-KMS4K du menu précédent."
)
aller à :ts_act
)

définir ohostexist=
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663
définir ohostids=%allapps%
appel :dk_actids 59a52881-a989-479d-af46-f275c6370663
définir ohostids=%ohostids% %allapps%

pour %%# dans (
bfe7a195-4f8f-4f0b-a622-cf13c7d16864_KMSHost2010-ProPlusVL
f3d89bbf-c0ec-47ce-a8fa-e5a5f97e447f_KMSHost2024Volume
47f3b983-7c53-4d45-abc6-bcd91e2dd90a_KMSHost2021Volume
70512334-47b4-44db-a233-be5ea33b914c_KMSHost2019Volume
98ebfe73-2084-4c97-932c-c0cd1643bea7_KMSHost2016Volume
2e28138a-847f-42bc-9752-61b03fff33cd_KMSHost2013Volume
) faire (
pour /f "tokens=1-2 delims=_" %%A dans ("%%#") faire (
echo "%ohostids%" | find /i "%%A" %nul1% && (
définir ohostexist=1
définir tsids=!tsids! %%A
écho Vérification de l'ID d'activation [%%A] [%%B]
)
)
)

si non défini ohostexist (
appel :dk_color %Gray% "Vérification de l'ID d'activation [Introuvable pour l'hôte Office %KS%]"
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%tsforge#office-kms-host"
)

écho:
appel :dk_color %Gray% "La licence %KS% Host [à ne pas confondre avec %KS% Client] provoque l'exécution continue du service sppsvc."
appel :dk_color %Gray% "N'utilisez cette activation qu'en cas de besoin."

aller à :ts_act

:=================================================================================================================================================

:ts_appxlob

:: Traitement du chargement latéral d'applications Windows 8/8.1

écho:
echo Traitement de l'installation latérale d'applications Windows 8/8.1...

si %winbuild% LSS 9200 définir noappx=1
si %winbuild% GTR 9600 définir noappx=1

écho:
si défini noappx (
appel :dk_color %Gray% "Vérification de l'ID d'activation [La fonctionnalité de chargement latéral d'APPX est disponible uniquement sur Windows 8/8.1]"
aller à :dk_done
)

si /i %tsmethod%==KMS4k (
écho:
appel :dk_color %Red% "Ignorer l'APPX Windows 8/8.1 [La méthode KMS4k n'est pas prise en charge avec l'APPX Windows 8/8.1]"
si /i %_actmethod%==Auto (
Appel :dk_color %Blue% "Connectez-vous à Internet et réessayez. Le script utilisera la méthode d'activation StaticCID."
) autre (
appel :dk_color %Blue% "Utilisez les options d'activation non-KMS4K du menu précédent."
)
aller à :dk_done
)

définir appxexist=
Si non défini, appel à allapps :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f

pour %%# dans (
ec67814b-30e6-4a50-bf7b-d55daf729d1e_APPXLOB-Client
251ef9bf-2005-442f-94c4-86307de7bb32_APPXLOB-Intégré-Industrie
1e58c9d7-e3f1-4f69-9039-1f162463ac2c_APPXLOB-Embedded-Standard
3502d53e-5d43-436a-84af-714e8d334f8d_APPXLOB-Serveur
) faire (
pour /f "tokens=1-2 delims=_" %%A dans ("%%#") faire (
écho "%allapps%" | trouver /i "%%A" %nul1% && (
définir appxexist=1
définir tsids=!tsids! %%A
écho Vérification de l'ID d'activation [%%A] [%%B]
)
)
)

si non défini appxexist (
appel :dk_color %Red% "Vérification de l'ID d'activation [Introuvable]"
appel :dk_color %Blue% "La fonctionnalité de chargement latéral d'APPX est disponible uniquement sur les éditions Pro et supérieures."
)

aller à :ts_act

:=================================================================================================================================================

:ts_resetall

écho:
si défini _vis (
Écho Traitement Réinitialisation du réarmement / des minuteries...
) autre (
Écho Traitement Réinitialisation du réarmement / des minuteries / de la protection contre les sabotages / du verrouillage...
)
écho:

définir resetstuff=1
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':tsforge\:.*';. ([scriptblock]::Create($f[1]))"

si %errorlevel%==3 (
appel :dk_color %Red% "Échec de la réinitialisation."
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
) autre (
appel :dk_color %Green% "Le processus de réinitialisation a été effectué avec succès."
)

aller à :dk_done

:=================================================================================================================================================

:ts_actman

écho:
Activation manuelle du traitement de l'écho...
écho:

si /i %tsmethod%==KMS4k (
écho:
appel :dk_color %Red% "Activation manuelle ignorée [la méthode KMS4k n'est pas prise en charge]"
si /i %_actmethod%==Auto (
Appel :dk_color %Blue% "Connectez-vous à Internet et réessayez. Le script utilisera la méthode d'activation StaticCID."
) autre (
appel :dk_color %Blue% "Utilisez les options d'activation non-KMS4K du menu précédent."
)
aller à :dk_done
)

appel :dk_color %Gray% "Cette option est destinée aux utilisateurs avancés, à ceux qui savent déjà ce qu'ils font."
appel :dk_color %Blue% "Certains ID d'activation peuvent provoquer un plantage du système [incompatibilité MUI] ou des modifications irréversibles [CloudEdition etc.].

si %_unattended%==1 (
écho:
pour %%# dans (%tsids%) faire (afficher ID d'activation - %%#)
aller à :ts_act
)

appel :dk_color %Blue% "Bien que le script tente de supprimer ces identifiants de la liste, cela n'est pas entièrement garanti."
écho:
choix /C:0F /N /M "> [0] Retour [F] Continuer : "
si %errorlevel%==1 quitter /b

écho:
Récupération de la liste des identifiants d'activation pris en charge. Veuillez patienter...

%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':listactids\:.*';. ([scriptblock]::Create($f[1]))"
si %errorlevel%==3 (
appel :dk_color %Gray% "Aucun ID d'activation pris en charge trouvé, abandon..."
aller à :dk_done
)

for /f "delims=" %%a in ('%psc% "$ids = Get-WmiObject -Query 'SELECT ID FROM SoftwareLicensingProduct' | Select-Object -ExpandProperty ID; $ids" %nul6%') do call set "allactids= %%a !allactids! "

si défini _vis (
écho:
appel :dk_color %Blue% "Sur Windows Vista et Server 2008, vous devez installer manuellement la clé avant de l'activer."
)
écho:
appel :dk_color %Gray% "Saisissez / Collez l'ID d'activation affiché dans la première colonne du fichier texte ouvert, ou appuyez simplement sur Entrée pour revenir :"
Ajoutez un espace après chaque ID d'activation si vous en ajoutez plusieurs :
écho:
définir /p tsids=

del /f /q "%SystemRoot%\Temp\actids_159_*" %nul%
Si les identifiants TSID ne sont pas définis, aller à :dk_done

pour %%# dans (%tsids%) faire (
echo "%allactids%" | find /i " %%# " %nul1% || (
appel :dk_color %Red% "[%%#] ID d'activation incorrect saisi, abandon..."
aller à :dk_done
)
)

aller à :ts_act

:listactids:
$t = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1).DefineDynamicModule(2, $False).DefineType(0)
$t.DefinePInvokeMethod('SLOpen', 'slc.dll', 22, 1, [Int32], @([IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
$t.DefinePInvokeMethod('SLClose', 'slc.dll', 22, 1, [IntPtr], @([IntPtr]), 1, 3).SetImplementationFlags(128)
$t.DefinePInvokeMethod('SLGetProductSkuInformation', 'slc.dll', 22, 1, [Int32], @([IntPtr], [Guid].MakeByRefType(), [String], [UInt32].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
$t.DefinePInvokeMethod('SLGetLicense', 'slc.dll', 22, 1, [Int32], @([IntPtr], [Guid].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
$w = $t.CreateType()
$m = [Runtime.InteropServices.Marshal]

fonction slGetSkuInfo($SkuId) {
    $c = 0; $b = 0
    $r = $w::SLGetProductSkuInformation($hSLC, [ref][Guid]$SkuId, "msft:sl/EUL/PHONE/PUBLIC", [ref]$null, [ref]$c, [ref]$b)
    renvoyer ($r -eq 0)
}

fonction IsMuiNotLocked($SkuId) {
    $r = $true; $c = 0; $b = 0

    $LicId = [Guid]::Vide
    [void]$w::SLGetProductSkuInformation($hSLC, [ref][Guid]$SkuId, "fileId", [ref]$null, [ref]$c, [ref]$b)
    $FileId = $m::PtrToStringUni($b)

    $c = 0; $b = 0
    [void]$w::SLGetLicense($hSLC, [ref][Guid]$FileId, [ref]$c, [ref]$b)
    $blob = New-Object byte[] $c; $m::Copy($b, $blob, 0, $c)
    $cont = [Text.Encoding]::UTF8.GetString($blob)
    $xml = [xml]$cont.SubString($cont.IndexOf('<r'))

    $xml.licenseGroup.license[0].grant | foreach {
        $_.allConditions.allConditions.productPolicies.policyStr | where { $_.name -eq 'Kernel-MUI-Language-Allowed' } | foreach {
            if ($_.InnerText -ne 'VIDE') { $r = $false }
        }
    }
    retourner $r
}

$hSLC = 0; [void]$w::SLOpen([ref]$hSLC)
$results = Get-WmiObject -Query "SELECT ID, Name, Description FROM SoftwareLicensingProduct"
$maxNameWidth = 60

$filteredResults = $results | Where-Object {
    si ($env:tsedition -like "*CountrySpecific*") {
        $true
    }
    autre {
        $_.Name -like "*ESU*" -or $_.Name -notlike "*CountrySpecific*"
    }
} | Où-Objet {
    si ($env:tsedition -like "*CloudEdition*") {
        $true
    }
    autre {
        $_.Name -like "*ESU*" -or $_.Name -notlike "*CloudEdition*"
    }
} | Où-Objet {
    $_.Name -like "*CountrySpecific*" -or (IsMuiNotLocked $_.ID)
} | Où-Objet {
    slGetSkuInfo $_.ID
} | Pour chaque objet {
    "$($_.ID)`t$($_.Name.PadRight($maxNameWidth))`t$($_.Description)"
}

[void]$w::SLClose($hSLC)
si (-non $filteredResults) {
    Sortie 3
}

$sortedResults = $filteredResults | Sort-Object { $_.Split("`t")[1].Trim() }
$output = $sortedResults -join "`r`n"
$newGuid = [Guid]::NewGuid().Guid
$filename = "$env:SystemRoot\Temp\actids_159_$newGuid.txt"
$output | Set-Content -Path $filename -Encoding ASCII
Démarrer le processus notepad.exe $nom_du_fichier
:listactids:

:=================================================================================================================================================

:ts_act

si défini eval (
écho:
Activation en cours...
écho:
appel :dk_act

définir gpr=0
définir gprdays=0
définir actdone=
for /f "delims=" %%a in ('%psc% "(Get-WmiObject -Query 'SELECT GracePeriodRemaining FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND PartialProductKey IS NOT NULL AND LicenseDependsOn is NULL').GracePeriodRemaining" %nul6%') do set "gpr=%%a"
définir /a "gprdays=(!gpr!+1440-1)/1440"

si !gprdays! EQU 90 définir actdone=1
si !gprdays! EQU 180 définir actdone=1

si défini actdone (
appel :dk_color %Green% "[%winos%] a été réinitialisé et activé avec succès pour !gprdays! jours."
) autre (
définir erreur=1
définir showfix=1
appel :dk_color %Red% "[%winos%] Échec de l'activation %error_code%. Période restante : !gprdays! jours [!gpr! minutes].
si non défini noact (
appel :dk_color %Gray% "Pour activer, vérifiez votre connexion Internet et assurez-vous que la date et l'heure sont correctes."
) autre (
appel :dk_color %Blue% "Cette version de Windows est connue pour ne pas s'activer en raison de problèmes liés à MS Windows/Server."
)
si non défini, appel showfix :dk_color %Blue% "%_fixmsg%"
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)
)

si tsids définis (
écho:
Si la variable _vis n'est pas définie, si la variable oldks n'est pas définie, afficher « Installation des données de clé de produit falsifiées... »
si /i %tsmethod%==KMS4k (
echo Écriture des données TrustedStore...
) autre (
if /i %tsmethod%==StaticCID (echo Dépôt de l'ID de confirmation statique...) else (echo Dépôt de l'ID de confirmation nul...)
)
écho:
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':tsforge\:.*';. ([scriptblock]::Create($f[1])) %tsids%"
si !errorlevel!==3 (
si %_actman%==0 (si non défini, appel showfix :dk_color %Blue% "%_fixmsg%")
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
) autre (
si /i %tsmethod%==KMS4k si %winbuild% GEQ 26100 si %_actwin%==1 (
écho:
appel :dk_color %Gray% "Dans les paramètres Windows, vous pouvez voir une notification de renouvellement d'activation que vous pouvez ignorer."
if /i %_actmethod%==Auto call :dk_color %Gray% "Pour éviter cette notification, exécutez le script avec une connexion Internet pour utiliser la méthode StaticCID."
)
echo "%tsids%" | find /i "7e94be23-b161-4956-a682-146ab291774c" %nul1% && (
appel :dk_color %Gray% "Windows Update reçoit 1 à 3 ans de mises à jour ESU ; 4 à 6 ans sont non officielles mais vous permettent d'installer manuellement les mises à jour de Server 2008 R2."
)
echo "%tsids%" | findstr /i "4afc620f-12a4-48ad-8015-2aebfbd6e47c 11be7019-a309-4763-9a09-091d1722ffe3" %nul1% && (
appel :dk_color %Gray% "ESU n'est pas officiellement pris en charge sur Windows 8.1, mais les mises à jour peuvent être installées manuellement jusqu'en janvier 2024."
)
echo "%tsids%" | findstr /i "83d49986-add3-41d7-ba33-87c7bfb5c0fb 0b533b5e-08b6-44f9-b885-c2de291ba456" %nul1% && (
appel :dk_color %Gray% "Windows Update reçoit 1 à 3 ans de mises à jour ESU ; 4 à 6 ans sont non officielles mais peuvent vous permettre d'installer manuellement les mises à jour LTSC."
si le fichier %SysPath%\ClipESUConsumer.exe existe (%SysPath%\ClipESUConsumer.exe -evaluateEligibility)
si %SysPath%\ClipESU.exe existe (%SysPath%\ClipESU.exe %nul%)
)
)

si défini esuexistsup echo Aide : %mas%tsforge#windows-esu

si %_actwin%==1 pour %%# dans (407) faire si %osSKU%==%%# (
appel :dk_color %Red% "%winos% ne prend pas en charge l'activation sur les plateformes non-Azure."
)

si %_actoff%==1 si non défini erreur si défini ohub (
écho:
Appel :dk_color %Gray% « Les applications Office telles que Word et Excel sont activées, utilisez-les directement. Ignorez le bouton « Acheter » dans l’application Tableau de bord Office. »
)

REM Déclenche une réévaluation des tâches planifiées de SPP
appel :dk_reeval %nul%
)

si non défini tsids si défini erreur si non défini showfix (
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)

aller à :dk_done

:=================================================================================================================================================

:ts_supprimer

cls
si le terminal n'est pas défini (
mode 100, 30
)
Supprimer l'activation TSforge %masver%

écho:
L'activation de TSforge ne modifie aucun composant Windows et n'installe aucun nouveau fichier.
écho:
Au lieu de cela, il ajoute des données à l'un des fichiers de données utilisés par la plateforme de protection logicielle.
écho:
appel :dk_color %Gray% "Si vous souhaitez réinitialiser l'état d'activation,"
appel :dk_color %Bleu% "%_fixmsg%"
écho:

aller à :dk_done

:=================================================================================================================================================

:ts_reset

définir la clé=
définir _oRoot=
définir _oArch=
définir _oIds=
définir _oLPath=
définir _actid=
définir _prod=
définir _lic=
définir _arr=
définir _prids=
définir _config=
définir _version=
définir _Licence=
définir _oMSI=
quitter /b

:=================================================================================================================================================

:ts_getpath

définir o16c2r=
définir o15c2r=
définir o16msi=
définir o15msi=

définir _68=HKLM\SOFTWARE\Microsoft\Office
définir _86=HKLM\SOFTWARE\Wow6432Node\Microsoft\Office

for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" (set o16c2r=1&set o16c2r_reg=%_86%\ClickToRun)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" (set o16c2r=1&set o16c2r_reg=%_68%\ClickToRun)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\15.0\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses\ProPlus*.xrm-ms" (set o15c2r=1&set o15c2r_reg=%_86%\15.0\ClickToRun)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\15.0\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses\ProPlus*.xrm-ms" (set o15c2r=1&set o15c2r_reg=%_68%\15.0\ClickToRun)

for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\16.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o16msi=1&set o16msi_reg=%_86%\16.0)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\16.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o16msi=1&set o16msi_reg=%_68%\16.0)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\15.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o15msi=1&set o15msi_reg=%_86%\15.0)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\15.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set o15msi=1&set o15msi_reg=%_68%\15.0)

quitter /b

:=================================================================================================================================================

:ts_process

si "%pkeypath%" n'existe pas (
appel :dk_color %Red% "Vérification de pkeyconfig-office.xrm-ms [Introuvable. Activation annulée...]"
définir erreur=1
quitter /b
)

pour %%# dans (%_oIds%) faire (
définir _actid=
définir _preview=
définir _Licence=%%#

définir skipprocess=

définir foundprod=
appel :tsksdata chkprod %%#
si défini _oMSI si non défini foundprod si /i %tsmethod%==KMS4k (
définir skipprocess=1
appel :dk_color %Red% "Vérification du produit dans le script [%%# MSI Retail n'est pas pris en charge avec KMS4k]"
si /i %_actmethod%==Auto (
Appel :dk_color %Blue% "Connectez-vous à Internet et réessayez. Le script utilisera la méthode d'activation StaticCID."
) autre (
appel :dk_color %Blue% "Utilisez les options d'activation non-KMS4K du menu précédent."
)
)

si "%_actprojvis%"=="1" (
echo %%# | findstr /i "Project Visio" %nul% || (
définir skipprocess=1
appel :dk_color %Gray% "Ignoré car mode Projet/Visio [%%#]"
)
)

si "%_actprojvis%"=="0" si /i %tsmethod%==KMS4k echo %_oIds% | findstr /i "O365" %nul% && (
echo %%# | findstr /i "Project Visio" %nul% && (
définir skipprocess=1
echo Ignoré car Mondo est disponible [%%#]
)
)


si non défini ignorer le processus (

si /i n'est pas %tsmethod%==KMS4k (
ensemble no365=
si "%oVer%"=="15" (echo %%# | findstr /i "O365HomePremRetail" %nul% && set no365=1)
si "%oVer%"=="16" (echo %%# | findstr /i "O365" %nul% && set no365=1)

si défini no365 (
définir _License=MondoRetail
définir _altoffid=MondoRetail
appel :ks_osppready
echo Conversion d'Office O365 non pris en charge [%%# vers MondoRetail]
si "%oVer%"=="15" (appel :dk_color %Gray% "Mondo 2013 est équivalent à O365 [version 15.0] en termes de fonctionnalités les plus récentes.")
si "%oVer%"=="16" (appel :dk_color %Gray% "Mondo 2016 est équivalent à O365 en termes de fonctionnalités les plus récentes.")
)

si non défini _oMSI (
echo %%# | findstr /i "ARM" %nul% && (
définir _License=MondoRetail
définir _altoffid=MondoRetail
appel :ks_osppready
echo Conversion d'Office OEM-ARM non pris en charge [%%# vers MondoRetail]
)
)
)

si non défini _oMSI si /i %tsmethod%==KMS4k si non défini foundprod (
appel :tsksdata getinfo %%#
si défini _altoffid (
echo Conversion du commerce de détail en volume [%%# à !_altoffid!]
) autre (
définir _License=MondoVolume
définir _altoffid=MondoVolume
echo Conversion du commerce de détail en volume [%%# à !_altoffid!] [Utilisation de Mondo car %%# est introuvable dans le script]
)
echo %%# | find /i "O365" %nul% && (
si "%oVer%"=="15" (appel :dk_color %Gray% "Mondo 2013 est équivalent à O365 [version 15.0] en termes de fonctionnalités les plus récentes.")
si "%oVer%"=="16" (appel :dk_color %Gray% "Mondo 2016 est équivalent à O365 en termes de fonctionnalités les plus récentes.")
)
appel :ks_osppready
)

si /i %tsmethod%==KMS4k (
echo !_License! | find /i "Retail" %nul% && (set keytype=zero) || (set keytype=ks)
) autre (
définir keytype=zéro
)

pour /f "delims=" %%a dans ('%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':offtsid\:.*';. ([scriptblock]::Create($f[1]))" %nul6%') faire (
echo "%%a" | findstr /r ".*-.*-.*-.*-.*" %nul1% && (set tsids=!tsids! %%a& set _actid=%%a)
)
définir "_allactid=!tsids!"

si défini _actid (
echo Vérification de l'ID d'activation [!_actid!] [!_License!]
) autre (
appel :dk_color %Red% "Vérification de l'ID d'activation [Office %oVer%.0 !_License! introuvable]"
définir erreur=1
définir showfix=1
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)

echo %%# | find /i "2024" %nul% && (
Si le fichier « !_oLPath!\ProPlus2024PreviewVL_*.xrm-ms » existe, sinon, définissez _preview=1.
)

si défini _actid (
echo "!allapps!" | trouver /i "!_actid!" %nul1% || appelle :oh_installlic
)
)
)

Ajoutez la clé de registre SharedComputerLicensing si Retail Office C2R est installé sur un serveur Windows.
:: https://learn.microsoft.com/en-us/office/troubleshoot/office-suite-issues/click-to-run-office-on-terminal-server

si /i n'est pas %tsmethod%==KMS4k si winserver est défini si _config est défini si existe "%_oLPath%\Word2019VL_KMS_Client_AE*.xrm-ms" (
echo %_oIds% | find /i "Retail" %nul1% && (
définir scaIsNeeded=1
reg add %_config% /v SharedComputerLicensing /t REG_SZ /d "1" /f %nul1%
« Ajout réussi de l'enregistrement SharedComputerLicensing [Nécessaire sur le serveur hébergeant un point de vente] »
)
)

quitter /b

:=================================================================================================================================================

:ts_processmsi

:: Traitement de la version MSI d'Office

appel :ts_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir _oMSI=1
définir oVer=%1
for /f "skip=2 tokens=2*" %%a in ('"reg query %2\Common\InstallRoot /v Path" %nul6%') do (set "_oRoot=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %2\Common\ProductVersion /v LastProduct" %nul6%') do (set "_version=%%b")
si "%_oRoot:~-1%"="\" définir "_oRoot=%_oRoot:~0,-1%"

echo "%2" | find /i "Wow6432Node" %nul1% && set _oArch=x86
Si la variable `_oArch` n'est pas définie, alors `_oArch` est définie sur `x64`.
si "%osarch%"="x86" définir _oArch=x86

définir "_common=%CommonProgramFiles%"
si PROCESSOR_ARCHITEW6432 est défini, définissez "_common=%CommonProgramW6432%"
définir "_common2=%CommonProgramFiles(x86)%"

si le fichier "%_common%\Microsoft Shared\OFFICE%oVer%\Office Setup Controller\pkeyconfig-office.xrm-ms" existe (
définir "pkeypath=%_common%\Microsoft Shared\OFFICE%oVer%\Office Setup Controller\pkeyconfig-office.xrm-ms"
) sinon si existe "%_common2%\Microsoft Shared\OFFICE%oVer%\Office Setup Controller\pkeyconfig-office.xrm-ms" (
définir "pkeypath=%_common2%\Microsoft Shared\OFFICE%oVer%\Office Setup Controller\pkeyconfig-office.xrm-ms"
)

appel :msiofficedata %2

écho:
echo Traitement Office... [MSI ^| %_version% ^| %_oArch%]

si non défini _oIds (
définir erreur=1
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
quitter /b
)

appel :ts_process
quitter /b

:=================================================================================================================================================

:: Obtenir le statut d'activation permanente de Windows (hors CSVLK)

:ts_checkwinperm

%psc% "Get-WmiObject -Query 'SELECT Name, Description FROM SoftwareLicensingProduct WHERE LicenseStatus=''1'' AND GracePeriodRemaining=''0'' AND PartialProductKey IS NOT NULL AND LicenseDependsOn IS NULL' | Where-Object { $_.Description -notmatch 'KMS' } | Select-Object -Property Name" %nul2% | findstr /i "Windows" %nul1% && set _perm=1||set _perm=
quitter /b

:=================================================================================================================================================

:tsforge:
$src = @'
#si !POWERSHELL2
espace de noms ActivationWs
{

/*

Ce code est adapté d'ActivationWs.
Dépôt d'origine : https://github.com/dadorner-msft/activationws

Licence MIT

Droits d'auteur © Daniel Dorner

L'autorisation est accordée par la présente, à titre gratuit, à toute personne obtenant une copie
de ce logiciel et des fichiers de documentation associés (le « Logiciel »), pour traiter
dans le Logiciel sans restriction, y compris, sans limitation, les droits
utiliser, copier, modifier, fusionner, publier, distribuer, concéder en sous-licence et/ou vendre
des copies du Logiciel, et permettre aux personnes auxquelles le Logiciel est
fournis à cet effet, sous réserve des conditions suivantes :

La mention de droit d'auteur ci-dessus et la présente mention d'autorisation doivent être incluses dans tous les documents.
copies ou parties substantielles du Logiciel.

LE LOGICIEL EST FOURNI « TEL QUEL », SANS GARANTIE D'AUCUNE SORTE, EXPRESSE OU IMPLICITE.
IMPLICITES, Y COMPRIS, MAIS SANS S'Y LIMITER, LES GARANTIES DE QUALITÉ MARCHANDE,
ADÉQUATION À UN USAGE PARTICULIER ET ABSENCE DE CONTREFAÇON. EN AUCUN CAS, LE
LES AUTEURS OU LES DÉTENTEURS DE DROITS D'AUTEUR NE SERONT PAS RESPONSABLES DE TOUTE RÉCLAMATION, DE TOUT DOMMAGE OU DE TOUT AUTRE PRÉJUDICE
RESPONSABILITÉ, QUE CE SOIT DANS LE CADRE D'UNE ACTION CONTRACTUELLE, DÉLICTUELLE OU AUTRE, DÉCOULANT DE,
EN LIEN AVEC LE LOGICIEL OU SON UTILISATION OU AUTRES TRANSACTIONS RELATIVES À CE DERNIER
LOGICIEL.

*/

en utilisant le système ;
utilisation de System.IO ;
utilisation de System.Linq ;
utilisation de System.Net ;
utilisation de System.Security.Cryptography ;
utiliser System.Text;
utilisation de System.Xml.Linq ;

    classe publique statique ActivationHelper {
        // Clé pour la signature HMAC/SHA256.
        privé statique en lecture seule byte[] MacKey = nouveau byte[64] {
            254, 49, 152, 117, 251, 72, 132, 134,
            156, 243, 241, 206, 153, 168, 144, 100,
            171, 87, 31, 202, 71, 4, 80, 88,
            48, 36, 226, 20, 98, 135, 121, 160,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0
        };

        private const string Action = "http://www.microsoft.com/BatchActivationService/BatchActivate";

        private static readonly Uri Uri = new Uri("https://activation.sls.microsoft.com/BatchActivation/BatchActivation.asmx");

        private static readonly XNamespace SoapSchemaNs = "http://schemas.xmlsoap.org/soap/envelope/";
        private static readonly XNamespace XmlSchemaInstanceNs = "http://www.w3.org/2001/XMLSchema-instance";
        private static readonly XNamespace XmlSchemaNs = "http://www.w3.org/2001/XMLSchema";
        private static readonly XNamespace BatchActivationServiceNs = "http://www.microsoft.com/BatchActivationService";
        private static readonly XNamespace BatchActivationRequestNs = "http://www.microsoft.com/DRM/SL/BatchActivationRequest/1.0";
        private static readonly XNamespace BatchActivationResponseNs = "http://www.microsoft.com/DRM/SL/BatchActivationResponse/1.0";

        public static string CallWebService(int requestType, string installationId, string extendedProductId) {
            XDocument soapRequest = CreateSoapRequest(requestType, installationId, extendedProductId);
            HttpWebRequest webRequest = CreateWebRequest(soapRequest);
            XDocument soapResponse = new XDocument();

            essayer {
                IAsyncResult asyncResult = webRequest.BeginGetResponse(null, null);
                asyncResult.AsyncWaitHandle.WaitOne();

                // Lire les données du flux de réponse.
                using (WebResponse webResponse = webRequest.EndGetResponse(asyncResult))
                using (StreamReader streamReader = new StreamReader(webResponse.GetResponseStream())) {
                    soapResponse = XDocument.Parse(streamReader.ReadToEnd());
                }

                renvoie ParseSoapResponse(soapResponse);

            } attraper {
                lancer;
            }
        }

        private static XDocument CreateSoapRequest(int requestType, string installationId, string extendedProductId) {
            // Créer une demande d'activation.           
            XElement activationRequest = new XElement(BatchActivationRequestNs + "ActivationRequest",
                nouveau XElement(BatchActivationRequestNs + "VersionNumber", "2.0"),
                nouveau XElement(BatchActivationRequestNs + "RequestType", requestType),
                nouveau XElement(BatchActivationRequestNs + "Requêtes",
                    nouveau XElement(BatchActivationRequestNs + "Requête",
                        nouveau XElement(BatchActivationRequestNs + "PID", extendedProductId),
                        requestType == 1 ? new XElement(BatchActivationRequestNs + "IID", installationId) : null)
                )
            );

            // Récupérez le tableau d'octets Unicode de activationRequest et convertissez-le en Base64.
            byte[] bytes = Encoding.Unicode.GetBytes(activationRequest.ToString());
            chaîne requestXml = Convert.ToBase64String(bytes);

            XDocument soapRequest = nouveau XDocument();

            en utilisant (HMACSHA256 hMACSHA = nouveau HMACSHA256(MacKey)) {
                // Convertir les données hachées HMAC en Base64.
                condensé de chaîne = Convert.ToBase64String(hMACSHA.ComputeHash(bytes));

                soapRequest = new XDocument(
                nouvelle déclaration X("1.0", "UTF-8", "non"),
                nouveau XElement(SoapSchemaNs + "Enveloppe",
                    nouvel XAttribute(XNamespace.Xmlns + "soap", SoapSchemaNs),
                    nouvel XAttribute(XNamespace.Xmlns + "xsi", XmlSchemaInstanceNs),
                    nouvel XAttribute(XNamespace.Xmlns + "xsd", XmlSchemaNs),
                    nouveau XElement(SoapSchemaNs + "Corps",
                        nouveau XElement(BatchActivationServiceNs + "BatchActivate",
                            nouveau XElement(BatchActivationServiceNs + "requête",
                                nouveau XElement(BatchActivationServiceNs + "Digest", digest),
                                nouvel XElement(BatchActivationServiceNs + "RequestXml", requestXml)
                            )
                        )
                    )
                ));

            }

            renvoyer soapRequest;
        }

        private static HttpWebRequest CreateWebRequest(XDocument soapRequest) {
            HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(Uri);
            webRequest.Accept = "text/xml";
            webRequest.ContentType = "text/xml; charset=\"utf-8\";
            webRequest.Headers.Add("SOAPAction", Action);
            webRequest.Host = "activation.sls.microsoft.com";
            webRequest.Method = "POST";

            essayer {
                // Insérer l'enveloppe SOAP
                using (Stream stream = webRequest.GetRequestStream()) {
                    soapRequest.Save(stream);
                }

                renvoyer webRequest;

            } attraper {
                lancer;
            }
        }

        private static string ParseSoapResponse(XDocument soapResponse) {
            si (soapResponse == null) {
                throw new ArgumentNullException("soapResponse", "Le serveur distant a renvoyé une réponse inattendue.");
            }

            si (!soapResponse.Descendants(BatchActivationServiceNs + "ResponseXml").Any()) {
                throw new Exception("Le serveur distant a renvoyé une réponse inattendue");
            }

            essayer {
                XDocument responseXml = XDocument.Parse(soapResponse.Descendants(BatchActivationServiceNs + "ResponseXml").First().Value);

                si (responseXml.Descendants(BatchActivationResponseNs + "ErrorCode").Any()) {
                    chaîne errorCode = responseXml.Descendants(BatchActivationResponseNs + "ErrorCode").First().Value;

                    switch (code d'erreur) {
                        cas "0x7F" :
                            throw new Exception("La limite de clés d'activation multiples a été dépassée");

                        cas "0x67" :
                            throw new Exception("La clé de produit a été bloquée");

                        cas "0x68" :
                            lancer une nouvelle exception("Clé de produit invalide");

                        cas "0x86" :
                            lancer une nouvelle exception("Type de clé invalide");

                        cas "0x90" :
                            throw new Exception("Veuillez vérifier l'ID d'installation et réessayer");

                        défaut:
                            throw new Exception(string.Format("Le serveur distant a signalé une erreur ({0})", errorCode));
                    }

                } else if (responseXml.Descendants(BatchActivationResponseNs + "ResponseType").Any()) {
                    string responseType = responseXml.Descendants(BatchActivationResponseNs + "ResponseType").First().Value;

                    switch (responseType) {
                        cas « 1 » :
                            chaîne confirmationId = responseXml.Descendants(BatchActivationResponseNs + "CID").First().Value;
                            renvoyer confirmationId;

                        cas « 2 » :
                            chaîne activationsRemaining = responseXml.Descendants(BatchActivationResponseNs + "ActivationRemaining").First().Value;
                            renvoyer activationsRemaining;

                        défaut:
                            throw new Exception("Le serveur distant a renvoyé une réponse non reconnue");
                    }

                } autre {
                    throw new Exception("Le serveur distant a renvoyé une réponse non reconnue");
                }

            } attraper {
                lancer;
            }
        }
    }
}
#endif

// LibTSforge/Common.cs
espace de noms LibTSforge
{
    en utilisant le système ;
    utilisation de System.IO ;
    utilisation de System.Linq ;
    utilisation de System.Runtime.InteropServices ;
    utiliser System.Text;

    énumération publique PSVersion
    {
        Vue,
        Win7,
        Win8,
        WinBlue,
        WinModern
    }

    classe statique publique Constantes
    {
        public statique readonly byte[] UniversalHWIDBlock =
        {
            0x26, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1c, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x01, 0x0c, 0x01, 0x00
        };

        public statique readonly byte[] KMSv4Response =
        {
            0x00, 0x00, 0x04, 0x00, 0x62, 0x00, 0x00, 0x00, 0x30, 0x00, 0x35, 0x00, 0x34, 0x00, 0x32, 0x00,
            0x36, 0x00, 0x2D, ​​0x00, 0x30, 0x00, 0x30, 0x00, 0x32, 0x00, 0x30, 0x00, 0x36, 0x00, 0x2D, ​​0x00,
            0x31, 0x00, 0x36, 0x00, 0x31, 0x00, 0x2D, ​​0x00, 0x36, 0x00, 0x35, 0x00, 0x35, 0x00, 0x35, 0x00,
            0x30, 0x00, 0x36, 0x00, 0x2D, ​​0x00, 0x30, 0x00, 0x33, 0x00, 0x2D, ​​0x00, 0x31, 0x00, 0x30, 0x00,
            0x33, 0x00, 0x33, 0x00, 0x2D, ​​0x00, 0x39, 0x00, 0x32, 0x00, 0x30, 0x00, 0x30, 0x00, 0x2E, 0x00,
            0x30, 0x00, 0x30, 0x00, 0x30, 0x00, 0x30, 0x00, 0x2D, ​​0x00, 0x30, 0x00, 0x36, 0x00, 0x35, 0x00,
            0x32, 0x00, 0x30, 0x00, 0x31, 0x00, 0x33, 0x00, 0x00, 0x00, 0xDE, 0x19, 0x02, 0xCF, 0x1F, 0x35,
            0x97, 0x4E, 0x8A, 0x8F, 0xB8, 0x07, 0xB1, 0x92, 0xB5, 0xB5, 0x97, 0x42, 0xEC, 0x3A, 0x76, 0x84,
            0xD5, 0x01, 0x32, 0x00, 0x00, 0x00, 0x78, 0x00, 0x00, 0x00, 0x60, 0x27, 0x00, 0x00, 0xC4, 0x1E,
            0xAA, 0x8B, 0xDD, 0x0C, 0xAB, 0x55, 0x6A, 0xCE, 0xAF, 0xAC, 0x7F, 0x5F, 0xBD, 0xE9
        };

        public statique readonly byte[] KMSv5Response =
        {
            0x00, 0x00, 0x05, 0x00, 0xBE, 0x96, 0xF9, 0x04, 0x54, 0x17, 0x3F, 0xAF, 0xE3, 0x08, 0x50, 0xEB,
            0x22, 0xBA, 0x53, 0xBF, 0xF2, 0x6A, 0x7B, 0xC9, 0x05, 0x1D, 0xB5, 0x19, 0xDF, 0x98, 0xE2, 0x71,
            0x4D, 0x00, 0x61, 0xE9, 0x9D, 0x03, 0xFB, 0x31, 0xF9, 0x1F, 0x2E, 0x60, 0x59, 0xC7, 0x73, 0xC8,
            0xE8, 0xB6, 0xE1, 0x2B, 0x39, 0xC6, 0x35, 0x0E, 0x68, 0x7A, 0xAA, 0x4F, 0x28, 0x23, 0x12, 0x18,
            0xE3, 0xAA, 0x84, 0x81, 0x6E, 0x82, 0xF0, 0x3F, 0xD9, 0x69, 0xA9, 0xDF, 0xBA, 0x5F, 0xCA, 0x32,
            0x54, 0xB2, 0x52, 0x3B, 0x3E, 0xD1, 0x5C, 0x65, 0xBC, 0x3E, 0x59, 0x0D, 0x15, 0x9F, 0x37, 0xEC,
            0x30, 0x9C, 0xCC, 0x1B, 0x39, 0x0D, 0x21, 0x32, 0x29, 0xA2, 0xDD, 0xC7, 0xC1, 0x69, 0xF2, 0x72,
            0x3F, 0x00, 0x98, 0x1E, 0xF8, 0x9A, 0x79, 0x44, 0x5D, 0x25, 0x80, 0x7B, 0xF5, 0xE1, 0x7C, 0x68,
            0x25, 0xAA, 0x0D, 0x67, 0x98, 0xE5, 0x59, 0x9B, 0x04, 0xC1, 0x23, 0x33, 0x48, 0xFB, 0x28, 0xD0,
            0x76, 0xDF, 0x01, 0x56, 0xE7, 0xEC, 0xBF, 0x1A, 0xA2, 0x22, 0x28, 0xCA, 0xB1, 0xB4, 0x4C, 0x30,
            0x14, 0x6F, 0xD2, 0x2E, 0x01, 0x2A, 0x04, 0xE3, 0xBD, 0xA7, 0x41, 0x2F, 0xC9, 0xEF, 0x53, 0xC0,
            0x70, 0x48, 0xF1, 0xB2, 0xB6, 0xEA, 0xE7, 0x0F, 0x7A, 0x15, 0xD1, 0xA6, 0xFE, 0x23, 0xC8, 0xF3,
            0xE1, 0x02, 0x9E, 0xA0, 0x4E, 0xBD, 0xF5, 0xEA, 0x53, 0x74, 0x8E, 0x74, 0xA1, 0xA1, 0xBD, 0xBE,
            0x66, 0xC4, 0x73, 0x8F, 0x24, 0xA7, 0x2A, 0x2F, 0xE3, 0xD9, 0xF4, 0x28, 0xD9, 0xF8, 0xA3, 0x93,
            0x03, 0x9E, 0x29, 0xAB
        };

        public statique readonly byte[] KMSv6Response =
        {
            0x00, 0x00, 0x06, 0x00, 0x54, 0xD3, 0x40, 0x08, 0xF3, 0xCD, 0x03, 0xEF, 0xC8, 0x15, 0x87, 0x9E,
            0xCA, 0x2E, 0x85, 0xFB, 0xE6, 0xF6, 0x73, 0x66, 0xFB, 0xDA, 0xBB, 0x7B, 0xB1, 0xBC, 0xD6, 0xF9,
            0x5C, 0x41, 0xA0, 0xFE, 0xE1, 0x74, 0xC4, 0xBB, 0x91, 0xE5, 0xDE, 0x6D, 0x3A, 0x11, 0xD5, 0xFC,
            0x68, 0xC0, 0x7B, 0x82, 0xB2, 0x24, 0xD1, 0x85, 0xBA, 0x45, 0xBF, 0xF1, 0x26, 0xFA, 0xA5, 0xC6,
            0x61, 0x70, 0x69, 0x69, 0x6E, 0x0F, 0x0B, 0x60, 0xB7, 0x3D, 0xE8, 0xF1, 0x47, 0x0B, 0x65, 0xFD,
            0xA7, 0x30, 0x1E, 0xF6, 0xA4, 0xD0, 0x79, 0xC4, 0x58, 0x8D, 0x81, 0xFD, 0xA7, 0xE7, 0x53, 0xF1,
            0x67, 0x78, 0xF0, 0x0F, 0x60, 0x8F, 0xC8, 0x16, 0x35, 0x22, 0x94, 0x48, 0xCB, 0x0F, 0x8E, 0xB2,
            0x1D, 0xF7, 0x3E, 0x28, 0x42, 0x55, 0x6B, 0x07, 0xE3, 0xE8, 0x51, 0xD5, 0xFA, 0x22, 0x0C, 0x86,
            0x65, 0x0D, 0x3F, 0xDD, 0x8D, 0x9B, 0x1B, 0xC9, 0xD3, 0xB8, 0x3A, 0xEC, 0xF1, 0x11, 0x19, 0x25,
            0xF7, 0x84, 0x4A, 0x4C, 0x0A, 0xB5, 0x31, 0x94, 0x37, 0x76, 0xCE, 0xE7, 0xAB, 0xA9, 0x69, 0xDF,
            0xA4, 0xC9, 0x22, 0x6C, 0x23, 0xFF, 0x6B, 0xFC, 0xDA, 0x78, 0xD8, 0xC4, 0x8F, 0x74, 0xBB, 0x26,
            0x05, 0x00, 0x98, 0x9B, 0xE5, 0xE2, 0xAD, 0x0D, 0x57, 0x95, 0x80, 0x66, 0x8E, 0x43, 0x74, 0x87,
            0x93, 0x1F, 0xF4, 0xB2, 0x2C, 0x20, 0x5F, 0xD8, 0x9C, 0x4C, 0x56, 0xB3, 0x57, 0x44, 0x62, 0x68,
            0x8D, 0xAA, 0x40, 0x11, 0x9D, 0x84, 0x62, 0x0E, 0x43, 0x8A, 0x1D, 0xF0, 0x1C, 0x49, 0xD8, 0x56,
            0xEF, 0x4C, 0xD3, 0x64, 0xBA, 0x0D, 0xEF, 0x87, 0xB5, 0x2C, 0x88, 0xF3, 0x18, 0xFF, 0x3A, 0x8C,
            0xF5, 0xA6, 0x78, 0x5C, 0x62, 0xE3, 0x9E, 0x4C, 0xB6, 0x31, 0x2D, ​​0x06, 0x80, 0x92, 0xBC, 0x2E,
            0x92, 0xA6, 0x56, 0x96
        };

        // 2^31 - 8 minutes
        public static readonly ulong TimerMax = (ulong)TimeSpan.FromMinutes(2147483640).Ticks;

        public static readonly string ZeroCID = new string('0', 48);
    }

    classe publique statique BinaryReaderExt
    {
        public static void Aligner(this BinaryReader lecteur, int to)
        {
            int pos = (int)reader.BaseStream.Position;
            lecteur.BaseStream.Seek(-pos & (to - 1), SeekOrigin.Current);
        }

        public static string ReadNullTerminéString(this BinaryReader lecteur, int maxLen)
        {
            return Encoding.Unicode.GetString(reader.ReadBytes(maxLen)).Split(new char[] { '\0' }, 2)[0];
        }
    }

    classe publique statique BinaryWriterExt
    {
        public static void Aligner(this BinaryWriter writer, int to)
        {
            int pos = (int)writer.BaseStream.Position;
            écrivain.WritePadding(-pos & (à - 1));
        }

        public static void WritePadding(this BinaryWriter writer, int len)
        {
            écrivain.Write(Enumerable.Repeat((byte)0, len).ToArray());
        }

        public static void WriteFixedString(this BinaryWriter writer, string str, int bLen)
        {
            écrivain.Écrire(Encodage.ASCII.ObtenirOctets(str));
            écrivain.WritePadding(bLen - str.Length);
        }

        public static void WriteFixedString16(this BinaryWriter writer, string str, int bLen)
        {
            byte[] bstr = Utils.EncodeString(str);
            écrivain.Écrire(bstr);
            écrivain.WritePadding(bLen - bstr.Length);
        }

        public static byte[] GetBytes(this BinaryWriter writer)
        {
            retourner ((MemoryStream)writer.BaseStream).ToArray();
        }
    }

    classe publique statique ByteArrayExt
    {
        public static byte[] CastToArray<T>(this T data) où T : struct
        {
            int taille = Marshal.SizeOf(typeof(T));
            byte[] résultat = nouveau byte[taille];
            GCHandle handle = GCHandle.Alloc(result, GCHandleType.Pinned);
            essayer
            {
                Marshal.StructureToPtr(data, handle.AddrOfPinnedObject(), false);
            }
            enfin
            {
                poignée.Libre();
            }
            renvoyer le résultat ;
        }
    }

    classe publique statique FileStreamExt
    {
        public static byte[] ReadAllBytes(this FileStream fs)
        {
            BinaryReader br = nouveau BinaryReader(fs);
            renvoie br.ReadBytes((int)fs.Length);
        }

        public static void WriteAllBytes(this FileStream fs, byte[] data)
        {
            fs.Seek(0, SeekOrigin.Begin);
            fs.SetLength(data.Length);
            fs.Write(données, 0, données.Longueur);
        }
    }

    classe statique publique Utils
    {
        [DllImport("kernel32.dll")]
        public static extern uint GetSystemDefaultLCID();

        [DllImport("kernel32.dll")]
        public static extern bool Wow64EnableWow64FsRedirection(bool Wow64FsEnableRedirection);

        public static string DecodeString(byte[] data)
        {
            renvoie Encoding.Unicode.GetString(data).Trim('\0');
        }

        public static byte[] EncodeString(string str)
        {
            renvoie Encoding.Unicode.GetBytes(str + '\0');
        }

        public static uint CRC32(byte[] données)
        {
            const uint polynomial = 0x04C11DB7;
            uint crc = 0xffffffff;

            pour chaque octet b dans les données
            {
                crc ^= (uint)b << 24;
                pour (int bit = 0; bit < 8; bit++)
                {
                    si ((crc & 0x80000000) != 0)
                    {
                        crc = (crc << 1) ^ polynôme;
                    }
                    autre
                    {
                        crc <<= 1;
                    }
                }
            }
            renvoyer ~crc;
        }

        public static string GetArchitecture()
        {
            chaîne arch = Environment.GetEnvironmentVariable("PROCESSOR_ARCHITECTURE", EnvironmentVariableTarget.Machine).ToUpperInvariant();
            retourner arch == "AMD64" ? "X64" : arch;
        }

        public statique PSVersion DetectVersion()
        {
            int build = Environment.OSVersion.Version.Build;

            si (build >= 9600) retourner PSVersion.WinModern ;
            si (build >= 6000 && build <= 6003) retourner PSVersion.Vista ;
            si (build >= 7600 && build <= 7602) retourner PSVersion.Win7 ;
            si (build == 9200) retourner PSVersion.Win8 ;

            throw new NotSupportedException("Impossible de détecter automatiquement les informations de version");
        }
    }

    classe statique publique Logger
    {
        public statique bool HideOutput = false;

        public static void WriteLine(string line)
        {
            if (!HideOutput) Console.WriteLine(line);
        }
    }
}


// LibTSforge/SPP/PKeyConfig.cs
espace de noms LibTSforge.SPP
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;
    utilisation de System.IO ;
    utilisation de System.Linq ;
    utiliser System.Text;
    utilisation de System.Xml ;

    énumération publique PKeyAlgorithm
    {
        PKEY2005,
        PKEY2009
    }

    classe publique KeyRange
    {
        public int Début;
        public int Fin;
        public string EulaType;
        public string PartNumber;
        public booléen Valide;

        public bool Contient(int n)
        {
            retourner Début <= n && n <= Fin;
        }
    }

    classe publique ProductConfig
    {
        public int GroupId;
        chaîne publique Édition;
        public string Description;
        public string Channel;
        public bool Randomisé;
        Algorithme public PKeyAlgorithm ;
        public List<KeyRange> Ranges;
        ID d'activation Guid public ;

        privée List<KeyRange> GetPkeyRanges()
        {
            si (Ranges.Count == 0)
            {
                throw new ArgumentException("Aucune plage de clés.");
            }

            si (Algorithme == PKeyAlgorithm.PKEY2005)
            {
                renvoyer les plages ;
            }

            List<KeyRange> FilteredRanges = Ranges.Where(r => !r.EulaType.Contains("WAU")).ToList();

            si (FilteredRanges.Count == 0)
            {
                throw new NotSupportedException("L'ID d'activation spécifié ne peut être utilisé que pour Windows Anytime Upgrade. Veuillez utiliser un ID d'activation non compatible avec WAU à la place.");
            }

            renvoie FilteredRanges ;
        }

        clé de produit publique GetRandomKey()
        {
            List<KeyRange> KeyRanges = GetPkeyRanges();
            Aléatoire rnd = nouvel Aléatoire();

            KeyRange range = KeyRanges[rnd.Next(KeyRanges.Count)];
            int numéro_série = rnd.Next(range.Start, range.End);

            renvoie une nouvelle clé de produit(série, 0, faux, algorithme, ceci, plage);
        }
    }

    classe publique PKeyConfig
    {
        public readonly Dictionary<Guid, ProductConfig> Products = new Dictionary<Guid, ProductConfig>();
        privée en lecture seule List<Guid> loadedPkeyConfigs = new List<Guid>();

        public void LoadConfig(Guid actId)
        {
            chaîne pkcData;
            Guid pkcFileId = SLApi.GetPkeyConfigFileId(actId);

            si (loadedPkeyConfigs.Contains(pkcFileId)) retourner;

            chaîne licConts = SLApi.GetLicenseContents(pkcFileId);

            en utilisant (TextReader tr = new StringReader(licConts))
            {
                XmlDocument lic = new XmlDocument();
                lic.Charger(tr);

                Gestionnaire d'espace de noms XML nsmgr = nouveau Gestionnaire d'espace de noms XML(lic.NameTable);
                nsmgr.AddNamespace("rg", "urn:mpeg:mpeg21:2003:01-REL-R-NS");
                nsmgr.AddNamespace("r", "urn:mpeg:mpeg21:2003:01-REL-R-NS");
                nsmgr.AddNamespace("tm", "http://www.microsoft.com/DRM/XrML2/TM/v2");

                XmlNode racine = lic.DocumentElement;
                XmlNode pkcDataNode = root.SelectSingleNode("/rg:licenseGroup/r:license/r:otherInfo/tm:infoTables/tm:infoList/tm:infoBin[@name=\"pkeyConfigData\"]", nsmgr);
                pkcData = Encoding.UTF8.GetString(Convert.FromBase64String(pkcDataNode.InnerText));
            }

            en utilisant (TextReader tr = new StringReader(pkcData))
            {
                XmlDocument lic = new XmlDocument();
                lic.Charger(tr);

                Gestionnaire d'espace de noms XML nsmgr = nouveau Gestionnaire d'espace de noms XML(lic.NameTable);
                nsmgr.AddNamespace("p", "http://www.microsoft.com/DRM/PKEY/Configuration/2.0");
                XmlNodeList configNodes = lic.SelectNodes("//p:ProductKeyConfiguration/p:Configurations/p:Configuration", nsmgr);
                XmlNodeList rangeNodes = lic.SelectNodes("//p:ProductKeyConfiguration/p:KeyRanges/p:KeyRange", nsmgr);
                XmlNodeList pubKeyNodes = lic.SelectNodes("//p:ProductKeyConfiguration/p:PublicKeys/p:PublicKey", nsmgr);

                Dictionnaire<int, PKeyAlgorithm> algorithmes = nouveau Dictionnaire<int, PKeyAlgorithm>();
                Dictionnaire<chaîne, Liste<PlageClé>> plages = nouveau Dictionnaire<chaîne, Liste<PlageClé>>();

                Dictionnaire<chaîne, PKeyAlgorithm> algoConv = nouveau Dictionnaire<chaîne, PKeyAlgorithm>
                {
                    { "msft:rm/algorithm/pkey/2005", PKeyAlgorithm.PKEY2005 },
                    { "msft:rm/algorithm/pkey/2009", PKeyAlgorithm.PKEY2009 }
                };

                foreach (XmlNode pubKeyNode dans pubKeyNodes)
                {
                    int groupe = int.Parse(pubKeyNode.SelectSingleNode("./p:GroupId", nsmgr).InnerText);
                    algorithms[groupe] = algoConv[pubKeyNode.SelectSingleNode("./p:AlgorithmId", nsmgr).InnerText];
                }

                pour chaque (XmlNode rangeNode dans rangeNodes)
                {
                    chaîne refActIdStr = rangeNode.SelectSingleNode("./p:RefActConfigId", nsmgr).InnerText;

                    si (!ranges.ContainsKey(refActIdStr))
                    {
                        ranges[refActIdStr] = nouvelle List<KeyRange>();
                    }

                    KeyRange keyRange = nouveau KeyRange
                    {
                        Début = int.Parse(rangeNode.SelectSingleNode("./p:Début", nsmgr).InnerText),
                        Fin = int.Parse(rangeNode.SelectSingleNode("./p:Fin", nsmgr).InnerText),
                        TypeEula = rangeNode.SelectSingleNode("./p:TypeEula", nsmgr).InnerText,
                        NuméroDePièce = rangeNode.SelectSingleNode("./p:NuméroDePièce", nsmgr).InnerText,
                        Valide = rangeNode.SelectSingleNode("./p:IsValid", nsmgr).InnerText.ToLower() == "true"
                    };

                    ranges[refActIdStr].Add(keyRange);
                }

                pour chaque (XmlNode configNode dans configNodes)
                {
                    chaîne refActIdStr = configNode.SelectSingleNode("./p:ActConfigId", nsmgr).InnerText;
                    Guid refActId = nouveau Guid(refActIdStr);
                    int groupe = int.Parse(configNode.SelectSingleNode("./p:RefGroupId", nsmgr).InnerText);
                    Liste<KeyRange> keyRanges ;
                    ranges.TryGetValue(refActIdStr, out keyRanges);

                    si (keyRanges == null)
                    {
                        continuer;
                    }

                    si (keyRanges.Count > 0 && !Products.ContainsKey(refActId))
                    {
                        Algorithme PKeyAlgorithm ;
                        algorithms.TryGetValue(groupe, out algorithm);

                        ProductConfig productConfig = nouveau ProductConfig
                        {
                            GroupId = groupe,
                            Édition = configNode.SelectSingleNode("./p:EditionId", nsmgr).InnerText,
                            Description = configNode.SelectSingleNode("./p:ProductDescription", nsmgr).InnerText,
                            Canal = configNode.SelectSingleNode("./p:ProductKeyType", nsmgr).InnerText,
                            Randomized = configNode.SelectSingleNode("./p:ProductKeyType", nsmgr).InnerText.ToLower() == "true",
                            Algorithme = algorithme,
                            Plages = plagesclés,
                            ActivationId = refActId
                        };

                        Produits[refActId] = productConfig;
                    }
                }
            }

            loadedPkeyConfigs.Add(pkcFileId);
        }

        public ProductConfig MatchParams(int groupe, int série)
        {
            pour chaque (ProductConfig config dans Products.Values)
            {
                si (config.GroupId == groupe)
                {
                    pour chaque (KeyRange plage dans config.Ranges)
                    {
                        si (plage.Contiens(série))
                        {
                            renvoyer la configuration ;
                        }
                    }
                }
            }

            throw new FileNotFoundException("Impossible de trouver un produit correspondant aux paramètres de clé de produit fournis.");
        }

        public void ChargerToutesLesConfigurations(Guid appId)
        {
            pour chaque (Guid actId dans SLApi.GetActivationIds(appId))
            {
                essayer
                {
                    ChargerConfig(actId);
                }
                attraper (ArgumentException)
                {

                }
            }
        }
    }
}


// LibTSforge/SPP/ProductKey.cs
espace de noms LibTSforge.SPP
{
    en utilisant le système ;
    utilisation de System.IO ;
    utilisation de System.Linq ;
    utilisation de la cryptographie ;
    utilisation de PhysicalStore ;

    classe publique ProductKey
    {
        chaîne de caractères statique privée en lecture seule ALPHABET = "BCDFGHJKMPQRTVWXY2346789";

        privé en lecture seule ulong klow;
        privé en lecture seule ulong khigh;

        groupe public int;
        public int Serial;
        Sécurité publique Ulong;
        public bool Mise à niveau;
        Algorithme public PKeyAlgorithm ;
        public readonly string EulaType;
        public readonly string PartNumber;
        chaîne de caractères publique en lecture seule Édition ;
        public readonly string Channel;
        ID d'activation Guid public en lecture seule ;

        chaîne privée mpc;
        chaîne privée pid2;

        public byte[] KeyBytes
        {
            obtenir { retourner BitConverter.GetBytes(klow).Concat(BitConverter.GetBytes(khigh)).ToArray(); }
        }

        public ProductKey()
        {

        }

        public ProductKey(int serial, ulong security, bool upgrade, PKeyAlgorithm algorithm, ProductConfig config, KeyRange range)
        {
            Groupe = config.GroupId;
            Numéro de série = numéro de série ;
            Sécurité = sécurité ;
            Mise à niveau = mise à niveau ;
            Algorithme = algorithme ;
            TypeEula = plage.TypeEula;
            NuméroDePièce = plage.NuméroDePièce.Split(':', ';')[0];
            Édition = config.Édition ;
            Canal = config.Canal;
            ActivationId = config.ActivationId;

            klow = ((sécurité & 0x3fff) << 50 | ((ulong)série & 0x3ffffff) << 20 | ((ulong)Groupe & 0xfffff));
            khigh = ((mise à niveau ? (ulong)1 : 0) << 49 | ((sécurité >> 14) & 0x7fffffffff));

            somme de contrôle uint = Utils.CRC32(KeyBytes) & 0x3ff;

            khigh |= ((ulong)somme de contrôle << 39);
        }

        public string GetAlgoUri()
        {
            retourner "msft:rm/algorithm/pkey/" + (Algorithm == PKeyAlgorithm.PKEY2005 ? "2005" : (Algorithm == PKeyAlgorithm.PKEY2009 ? "2009" : "Inconnu"));
        }

        public Guid GetPkeyId()
        {
            VariableBag pkb = new VariableBag(PSVersion.WinModern);
            pkb.Blocks.AddRange(new[]
            {
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.STRING,
                    KeyAsStr = "SppPkeyBindingProductKey",
                    ValeurAsStr = ToString()
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.BINAIRE,
                    KeyAsStr = "SppPkeyBindingMiscData",
                    Valeur = nouveau tableau d'octets { }
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.STRING,
                    KeyAsStr = "SppPkeyBindingAlgorithm",
                    ValeurAsStr = GetAlgoUri()
                }
            });

            renvoie un nouveau Guid(CryptoUtils.SHA256Hash(pkb.Serialize()).Take(16).ToArray());
        }

        public string GetMPC()
        {
            si (mpc != null)
            {
                renvoyer mpc;
            }

            int build = Environment.OSVersion.Version.Build;

            mpc = build >= 10240 ? "03612" :
                    version >= 9600 ? "06401" :
                    version >= 9200 ? "05426" :
                    "55041";

            Le fichier setup.cfg n'existe pas sous Windows 8 et versions ultérieures.
            chaîne setupcfg = chaîne.Format(@"{0}\oobe\{1}", Environment.SystemDirectory, "setup.cfg");

            si (!Fichier.Exists(setupcfg) || Edition.Contains(";"))
            {
                renvoyer mpc;
            }

            chaîne mpcKey = chaîne.Format("{0}.{1}=", Utils.GetArchitecture(), Edition);
            chaîne localMPC = File.ReadAllLines(setupcfg).FirstOrDefault(line => line.Contains(mpcKey));
            si (localMPC != null)
            {
                mpc = localMPC.Split('=')[1].Trim();
            }

            renvoyer mpc;
        }

        public string GetPid2()
        {
            si (pid2 != null)
            {
                renvoyer pid2;
            }

            pid2 = "";

            si (Algorithme == PKeyAlgorithm.PKEY2005)
            {
                chaîne mpc = GetMPC();
                chaîne serialHigh;
                int serialLow;
                int dernièrePartie;

                si (EulaType == "OEM")
                {
                    serialHigh = "OEM";
                    numéro_série_faible = ((Groupe / 2) % 100) * 10000 + (Numéro_série / 100000);
                    dernièrePartie = Numéro de série % 100000 ;
                }
                autre
                {
                    numéro_série_haut = (Numéro_série / 1000000).ToString("D3");
                    numéro_série_bas = Numéro_série % 1000000 ;
                    dernièrePartie = ((Groupe / 2) % 100) * 1000 + new Random().Next(1000);
                }

                somme de contrôle entière = 0 ;

                pour chaque (caractère c dans serialLow.ToString())
                {
                    checksum += int.Parse(c.ToString());
                }
                somme de contrôle = 7 - (somme de contrôle % 7);

                pid2 = string.Format("{0}-{1}-{2:D6}{3}-{4:D5}", mpc, serialHigh, serialLow, checksum, lastPart);
            }

            renvoyer pid2;
        }

        public byte[] GetPid3()
        {
            BinaryWriter writer = new BinaryWriter(new MemoryStream());
            écrivain.Écrire(0xA4);
            écrivain.Écrire(0x3);
            écrivain.ÉcrireChaîneFixe(ObtenirPid2(), 24);
            écrivain.Écrire(Groupe);
            écrivain.ÉcrireChaîneFixe(NuméroPartie, 16);
            écrivain.WritePadding(0x6C);
            byte[] data = writer.GetBytes();
            byte[] crc = BitConverter.GetBytes(~Utils.CRC32(data.Reverse().ToArray())).Reverse().ToArray();
            écrivain.Écrire(crc);

            retourner writer.GetBytes();
        }

        public byte[] GetPid4()
        {
            BinaryWriter writer = new BinaryWriter(new MemoryStream());
            écrivain.Écrire(0x4F8);
            écrivain.Écrire(0x4);
            écrivain.WriteFixedString16(GetExtendedPid(), 0x80);
            écrivain.WriteFixedString16(ActivationId.ToString(), 0x80);
            écrivain.WritePadding(0x10);
            écrivain.WriteFixedString16(Édition, 0x208);
            écrivain.Écrire(Mise à niveau ? (ulong)1 : 0);
            écrivain.WritePadding(0x50);
            écrivain.WriteFixedString16(PartNumber, 0x80);
            écrivain.WriteFixedString16(Canal, 0x80);
            écrivain.WriteFixedString16(EulaType, 0x80);

            retourner writer.GetBytes();
        }

        public string GetExtendedPid()
        {
            chaîne mpc = GetMPC();
            int numéro_série_haut = Numéro_série / 1000000;
            int serialLow = Serial % 1000000;
            int type_licence;
            uint lcid = Utils.GetSystemDefaultLCID();
            int build = Environment.OSVersion.Version.Build;
            int jourDeLAnnée = DateTime.Now.JourDeLAnnée;
            int année = DateTime.Now.Année;

            commutateur (EulaType)
            {
                cas « OEM » :
                    type_de_licence = 2 ;
                    casser;

                cas « Volume » :
                    type_de_licence = 3 ;
                    casser;

                défaut:
                    type_de_licence = 0 ;
                    casser;
            }

            retourner chaîne.Format(
                "{0}-{1:D5}-{2:D3}-{3:D6}-{4:D2}-{5:D4}-{6:D4}.0000-{7:D3}{8:D4}",
                mpc,
                Groupe,
                sérieHigh,
                sérieLow,
                type de licence,
                lcid,
                construire,
                jourDeLAnnée,
                année
            );
        }

        public byte[] GetPhoneData(PSVersion version)
        {
            si (version == PSVersion.Win7)
            {
                ulong shortauth = ((ulong)Groupe << 41) | (Sécurité << 31) | ((ulong)Série << 1) | (Mise à niveau ? (ulong)1 : 0);
                renvoie BitConverter.GetBytes(shortauth);
            }

            int numéro_série_haut = Numéro_série / 1000000;
            int serialLow = Serial % 1000000;

            BinaryWriter writer = new BinaryWriter(new MemoryStream());
            chaîne algoId = Algorithm == PKeyAlgorithm.PKEY2005 ? "B8731595-A2F6-430B-A799-FBFFB81A8D73" : "660672EF-7809-4CFD-8D54-41B7FB738988";

            écrivain.Écrire(new Guid(algoId).ToByteArray());
            écrivain.Écrire(Groupe);
            écrivain.Écrire(sérieHigh);
            écrivain.Écrire(sérieLow);
            écrivain.Écrire(Mise à niveau ? 1 : 0);
            écrivain.Écrire(Sécurité);

            retourner writer.GetBytes();
        }

        public override string ToString()
        {
            chaîne keyStr = "";
            Random rnd = new Random(Groupe * 1000000000 + Numéro de série);

            si (Algorithme == PKeyAlgorithm.PKEY2005)
            {
                keyStr = "H4X3DH4X3DH4X3DH4X3D";

                pour (int i = 0; i < 5; i++)
                {
                    cléStr += ALPHABET[rnd.Next(24)];
                }
            }
            sinon si (Algorithme == PKeyAlgorithm.PKEY2009)
            {
                int dernier = 0;
                byte[] bKey = KeyBytes;

                pour (int i = 24; i >= 0; i--)
                {
                    entier courant = 0;

                    pour (int j = 14; j >= 0; j--)
                    {
                        courant *= 0x100 ;
                        courant += bKey[j];
                        bKey[j] = (octet)(courant / 24);
                        courant %= 24;
                        dernier = actuel ;
                    }

                    keyStr = ALPHABET[actuel] + keyStr;
                }

                cléStr = cléStr.Substring(1, dernier) + "N" + cléStr.Substring(dernier + 1, cléStr.Longueur - dernier - 1);
            }

            pour (int i = 5; i < keyStr.Length; i += 6)
            {
                keyStr = keyStr.Insert(i, "-");
            }

            renvoyer keyStr;
        }
    }
}


// LibTSforge/SPP/SLAPI.cs
espace de noms LibTSforge.SPP
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;
    utilisation de System.Linq ;
    utilisation de System.Runtime.InteropServices ;
    utiliser System.Text;

    classe statique publique SLApi
    {
        énumération privée SLIDTYPE
        {
            SL_ID_APPLICATION,
            SL_ID_PRODUIT_SKU,
            FICHIER_DE_LICENCE_SL_ID,
            SL_ID_LICENSE,
            SL_ID_PKEY,
            SL_ID_TOUTES_LES_LICENCES,
            SL_ID_TOUS_FICHIERS_DE_LICENCE,
            SL_ID_STORE_TOKEN,
            SL_ID_DERNIER
        }

        énumération privée SLDATATYPE
        {
            SL_DATA_NONE,
            SL_DATA_SZ,
            SL_DATA_DWORD,
            SL_DATA_BINAIRE,
            SL_DATA_MULTI_SZ,
            SOMME_DES_DONNÉES_SL
        }

        [StructLayout(LayoutKind.Sequential)]
        structure privée SL_LICENSING_STATUS
        {
            public Guid SkuId ;
            public uint eStatus;
            public uint dwGraceTime;
            public uint dwTotalGraceDays;
            public uint hrReason;
            public ulong qwValidityExpiration ;
        }

        public static readonly Guid WINDOWS_APP_ID = new Guid("55c92734-d682-4d71-983e-d6ec3f16059f");

        [DllImport("slc.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        private static extern void SLOpen(out IntPtr hSLC);

        [DllImport("slc.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        private static extern void SLClose(IntPtr hSLC);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLGetWindowsInformationDWORD(string ValueName, ref int Value);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLInstallProofOfPurchase(IntPtr hSLC, string pwszPKeyAlgorithm, string pwszPKeyString, uint cbPKeySpecificData, byte[] pbPKeySpecificData, ref Guid PKeyId);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLUninstallProofOfPurchase(IntPtr hSLC, ref Guid PKeyId);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLGetPKeyInformation(IntPtr hSLC, ref Guid pPKeyId, string pwszValueName, out SLDATATYPE peDataType, out uint pcbValue, out IntPtr ppbValue);

        [DllImport("slcext.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLActivateProduct(IntPtr hSLC, ref Guid pProductSkuId, byte[] cbAppSpecificData, byte[] pvAppSpecificData, byte[] pActivationInfo, string pwszProxyServer, ushort wProxyPort);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLGenerateOfflineInstallationId(IntPtr hSLC, ref Guid pProductSkuId, ref string ppwszInstallationId);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLDepositOfflineConfirmationId(IntPtr hSLC, ref Guid pProductSkuId, string pwszInstallationId, string pwszConfirmationId);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLGetSLIDList(IntPtr hSLC, SLIDTYPE eQueryIdType, ref Guid pQueryId, SLIDTYPE eReturnIdType, out uint pnReturnIds, out IntPtr ppReturnIds);

        [DllImport("slc.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        private static extern void SLGetLicensingStatusInformation(IntPtr hSLC, ref Guid pAppID, IntPtr pProductSkuId, string pwszRightName, out uint pnStatusCount, out IntPtr ppLicensingStatus);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLGetInstalledProductKeyIds(IntPtr hSLC, ref Guid pProductSkuId, out uint pnProductKeyIds, out IntPtr ppProductKeyIds);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLConsumeWindowsRight(uint inconnu);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLGetProductSkuInformation(IntPtr hSLC, ref Guid pProductSkuId, string pwszValueName, out SLDATATYPE peDataType, out uint pcbValue, out IntPtr ppbValue);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLGetLicense(IntPtr hSLC, ref Guid pLicenseFileId, out uint pcbLicenseFile, out IntPtr ppbLicenseFile);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLSetCurrentProductKey(IntPtr hSLC, ref Guid pProductSkuId, ref Guid pProductKeyId);

        [DllImport("slc.dll", CharSet = CharSet.Unicode)]
        private static extern uint SLFireEvent(IntPtr hSLC, string pwszEventId, ref Guid pApplicationId);

        classe privée SLContext : IDisposable
        {
            public readonly IntPtr Handle;

            public SLContext()
            {
                SLOpen(sortie Handle);
            }

            public void Dispose()
            {
                SLClose(Poignée);
                GC.SupprimerFinaliser(ceci);
            }

            ~SLContext()
            {
                Disposer();
            }
        }

        public static Guid GetDefaultActivatedID(Guid appId, bool includeActivated)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                nombre entier non signé ;
                IntPtr pLicStat;

                SLGetLicensingStatusInformation(sl.Handle, ref appId, IntPtr.Zero, null, out count, out pLicStat);

                dangereux
                {
                    SL_LICENSING_STATUS* licensingStatuses = (SL_LICENSING_STATUS*)pLicStat;
                    pour (int i = 0; i < count; i++)
                    {
                        SL_LICENSING_STATUS slStatus = licensingStatuses[i];

                        Guid actId = slStatus.SkuId;
                        si (GetInstalledPkeyID(actId) == Guid.Empty) continuer ;
                        si (IsAddon(actId)) continuer ;
                        si (!includeActivated && (slStatus.eStatus == 1)) continue ;

                        renvoyer actId ;
                    }
                }

                retourner Guid.Vide ;
            }
        }

        public static string GetInstallationID(Guid actId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                chaîne installationId = null;
                return SLGenerateOfflineInstallationId(sl.Handle, ref actId, ref installationId) == 0 ? installationId : null;
            }
        }

        public statique Guid GetInstalledPkeyID(Guid actId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                nombre entier non signé ;
                IntPtr pProductKeyIds;

                uint status = SLGetSLIDList(sl.Handle, SLIDTYPE.SL_ID_PRODUCT_SKU, ref actId, SLIDTYPE.SL_ID_PKEY, out count, out pProductKeyIds);

                si (statut != 0 || nombre == 0)
                {
                    retourner Guid.Vide ;
                }

                non sécurisé { retourner *(Guid*)pProductKeyIds; }
            }
        }

        public static uint DepositConfirmationID(Guid actId, string installationId, string confirmationId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                renvoie SLDepositOfflineConfirmationId(sl.Handle, ref actId, installationId, confirmationId);
            }
        }

        public static void RefreshLicenseStatus()
        {
            SLConsumeWindowsRight(0);
        }

        public static void RefreshTrustedTime(Guid actId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                SLDATATYPE type ;
                nombre entier non signé ;
                IntPtr ppbValue;

                SLGetProductSkuInformation(sl.Handle, ref actId, "TrustedTime", out type, out count, out ppbValue);
            }
        }

        public static void FireStateChangedEvent(Guid appId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                SLFireEvent(sl.Handle, "msft:rm/event/licensingstatechanged", ref appId);
            }
        }

        public statique Guid GetAppId(Guid actId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                nombre entier non signé ;
                IntPtr pAppIds;

                uint status = SLGetSLIDList(sl.Handle, SLIDTYPE.SL_ID_PRODUCT_SKU, ref actId, SLIDTYPE.SL_ID_APPLICATION, out count, out pAppIds);

                si (statut != 0 || nombre == 0)
                {
                    retourner Guid.Vide ;
                }

                non sécurisé { retourner *(Guid*)pAppIds; }
            }
        }

        public statique booléen IsAddon(Guid actId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                nombre entier non signé ;
                SLDATATYPE type ;
                IntPtr ppbValue;

                uint status = SLGetProductSkuInformation(sl.Handle, ref actId, "Dépend de", out type, out count, out ppbValue);
                retourner (int)status >= 0 && status != 0xC004F012;
            }
        }

        public static Guid GetLicenseFileId(Guid licId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                nombre entier non signé ;
                IntPtr ppReturnLics;

                uint status = SLGetSLIDList(sl.Handle, SLIDTYPE.SL_ID_LICENSE, ref licId, SLIDTYPE.SL_ID_LICENSE_FILE, out count, out ppReturnLics);

                si (statut != 0 || nombre == 0)
                {
                    retourner Guid.Vide ;
                }

                unsafe { return *(Guid*)ppReturnLics; }
            }
        }

        public statique Guid GetPkeyConfigFileId(Guid actId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                SLDATATYPE type ;
                longueur non entière;
                IntPtr ppReturnLics;

                uint status = SLGetProductSkuInformation(sl.Handle, ref actId, "pkeyConfigLicenseId", out type, out len, out ppReturnLics);

                si (statut != 0 || longueur == 0)
                {
                    retourner Guid.Vide ;
                }

                Guid pkcId = new Guid(Marshal.PtrToStringAuto(ppReturnLics));
                renvoie GetLicenseFileId(pkcId);
            }
        }

        public static string GetLicenseContents(Guid fileId)
        {
            if (fileId == Guid.Empty) throw new ArgumentException("Impossible de récupérer le contenu de la licence.");

            en utilisant (SLContext sl = nouveau SLContext())
            {
                longueur des données uint;
                IntPtr dataPtr;

                if (SLGetLicense(sl.Handle, ref fileId, out dataLen, out dataPtr) != 0)
                {
                    renvoyer null ;
                }

                octet[] data = nouvel octet[dataLen];
                Marshal.Copy(dataPtr, data, 0, (int)dataLen);

                data = data.Skip(Array.IndexOf(data, (byte)'<')).ToArray();
                renvoie Encoding.UTF8.GetString(données);
            }
        }

        public static bool IsPhoneActivatable(Guid actId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                nombre entier non signé ;
                SLDATATYPE type ;
                IntPtr ppbValue;

                uint status = SLGetProductSkuInformation(sl.Handle, ref actId, "msft:sl/EUL/PHONE/PUBLIC", out type, out count, out ppbValue);
                statut de retour != 0xC004F012 ;
            }
        }

        public static string GetPKeyChannel(Guid pkeyId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                SL DATATYPE type;
                longueur non entière;
                IntPtr ppbValue;

                uint status = SLGetPKeyInformation(sl.Handle, ref pkeyId, "Channel", out type, out len, out ppbValue);

                si (statut != 0 || longueur == 0)
                {
                    renvoyer null ;
                }

                renvoie Marshal.PtrToStringAuto(ppbValue);
            }
        }

        public static string GetMetaStr(Guid actId, valeur de chaîne)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                longueur non entière;
                SLDATATYPE type ;
                IntPtr ppbValue;

                uint status = SLGetProductSkuInformation(sl.Handle, ref actId, value, out type, out len, out ppbValue);

                si (statut != 0 || longueur == 0 || type != SLDATATYPE.SL_DATA_SZ)
                {
                    renvoyer null ;
                }

                renvoie Marshal.PtrToStringAuto(ppbValue);
            }
        }

        public static List<Guid> GetActivationIds(Guid appId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                nombre entier non signé ;
                IntPtr pLicStat;

                SLGetLicensingStatusInformation(sl.Handle, ref appId, IntPtr.Zero, null, out count, out pLicStat);

                List<Guid> résultat = nouvelle List<Guid>();

                dangereux
                {
                    SL_LICENSING_STATUS* licensingStatuses = (SL_LICENSING_STATUS*)pLicStat;
                    pour (int i = 0; i < count; i++)
                    {
                        résultat.Ajouter(licensingStatuses[i].SkuId);
                    }
                }

                renvoyer le résultat ;
            }
        }

        public static uint SetCurrentProductKey(Guid actId, Guid pkeyId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                renvoie SLSetCurrentProductKey(sl.Handle, ref actId, ref pkeyId);
            }
        }

        public static uint InstallProductKey(ProductKey pkey)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                Guid pkeyId = Guid.Vide ;
                renvoie SLInstallProofOfPurchase(sl.Handle, pkey.GetAlgoUri(), pkey.ToString(), 0, null, ref pkeyId);
            }
        }

        public static void DésinstallerProductKey(Guid pkeyId)
        {
            en utilisant (SLContext sl = nouveau SLContext())
            {
                SLUninstallProofOfPurchase(sl.Handle, ref pkeyId);
            }
        }

        public static void DésinstallerToutesLesClésDeProduit(Guid appId)
        {
            pour chaque (Guid actId dans GetActivationIds(appId))
            {
                Guid pkeyId = GetInstalledPkeyID(actId);
                si (pkeyId == Guid.Empty) continuer ;
                si (IsAddon(actId)) continuer ;
                DésinstallerProductKey(pkeyId);
            }
        }
    }
}


// LibTSforge/SPP/SPPUtils.cs
espace de noms LibTSforge.SPP
{
    utilisation de Microsoft.Win32 ;
    en utilisant le système ;
    utilisation de System.IO ;
    utilisation de System.Linq ;
    utilisation de System.ServiceProcess ;
    utilisation de la cryptographie ;
    utilisation de PhysicalStore ;
    utilisation de TokenStore ;

    classe statique publique SPPUtils
    {
        public static void KillSPP(PSVersion version)
        {
            Contrôleur de service sc;

            chaîne svcName = version == PSVersion.Vista ? "slsvc" : "sppsvc";

            essayer
            {
                sc = nouveau ServiceController(nom_du_service);

                si (sc.Status == ServiceControllerStatus.Stopped)
                    retour;
            }
            attraper (InvalidOperationException ex)
            {
                throw new InvalidOperationException(string.Format("Impossible d'accéder à {0} : ", svcName) + ex.Message);
            }

            Logger.WriteLine(string.Format("Arrêt de {0}...", svcName));

            booléen arrêté = faux;

            pour (int i = 0; arrêté == faux && i < 1080; i++)
            {
                essayer
                {
                    si (sc.Status != ServiceControllerStatus.StopPending)
                        sc.Stop();

                    sc.WaitForStatus(ServiceControllerStatus.Stopped, TimeSpan.FromMilliseconds(500));
                }
                attraper (System.ServiceProcess.TimeoutException)
                {
                    continuer;
                }
                attraper (InvalidOperationException ex)
                {
                    Logger.WriteLine("Avertissement : L’arrêt du service sppsvc a échoué, nouvelle tentative. Détails : " + ex.Message);
                    Système.Threading.Thread.Sleep(500);
                    continuer;
                }

                arrêté = vrai ;
            }

            si (!arrêté)
                throw new System.TimeoutException(string.Format("Échec de l'arrêt de {0}", svcName));

            Logger.WriteLine(string.Format("{0} arrêté avec succès.", svcName));

            si (version == PSVersion.Vista && SPSys.IsSpSysRunning())
            {
                Logger.WriteLine("Déchargement des spsys...");

                int statut = SPSys.ControlSpSys(false);

                si (statut < 0)
                {
                    throw new IOException("Échec du déchargement de spsys");
                }

                Logger.WriteLine("spsys déchargé avec succès.");
            }
        }

        public static void RestartSPP(PSVersion version)
        {
            si (version == PSVersion.Vista)
            {
                Contrôleur de service sc;

                essayer
                {
                    sc = nouveau ServiceController("slsvc");

                    si (sc.Status == ServiceControllerStatus.Running)
                        retour;
                }
                attraper (InvalidOperationException ex)
                {
                    throw new InvalidOperationException("Impossible d'accéder à slsvc : " + ex.Message);
                }

                Logger.WriteLine("Démarrage de slsvc...");

                booléen démarré = faux;

                pour (int i = 0; démarré == faux && i < 360; i++)
                {
                    essayer
                    {
                        si (sc.Status != ServiceControllerStatus.StartPending)
                            sc.Start();

                        sc.WaitForStatus(ServiceControllerStatus.Running, TimeSpan.FromMilliseconds(500));
                    }
                    attraper (System.ServiceProcess.TimeoutException)
                    {
                        continuer;
                    }
                    attraper (InvalidOperationException ex)
                    {
                        Logger.WriteLine("Avertissement : le démarrage de slsvc a échoué, nouvelle tentative. Détails : " + ex.Message);
                        Système.Threading.Thread.Sleep(500);
                        continuer;
                    }

                    démarré = vrai ;
                }

                si (!démarré)
                    throw new System.TimeoutException("Échec du démarrage de slsvc");

                Logger.WriteLine("slsvc a démarré avec succès.");
            }

            SLApi.RefreshLicenseStatus();
        }

        public statique bool DétecterCléActuelle()
        {
            SLApi.RefreshLicenseStatus();

            en utilisant (RegistryKey wpaKey = Registry.LocalMachine.OpenSubKey(@"SYSTEM\WPA"))
            {
                pour chaque (chaîne subKey dans wpaKey.GetSubKeyNames())
                {
                    si (subKey.StartsWith("8DEC0AF1"))
                    {
                        retourner subKey.Contains("P");
                    }
                }
            }

            throw new FileNotFoundException("Échec de la détection automatique du type de clé, spécifiez la clé du magasin physique avec les arguments /prod ou /test.");
        }

        public static string GetPSPath(PSVersion version)
        {
            commutateur (version)
            {
                cas PSVersion.Vista :
                cas PSVersion.Win7 :
                    retourner Directory.GetFiles(
                        Environnement.ObtenirCheminDuDossier(Environnement.DossierSpécial.Système),
                        "7B296FB0-376B-497e-B012-9C450E1B7327-*.C7483456-A289-439d-8115-601632D005A0")
                    .FirstOrDefault() ?? "";
                défaut:
                    chaîne psDir = Environment.ExpandEnvironmentVariables(
                        (chaîne)Registry.GetValue(
                            @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform",
                            "TokenStore",
                            ""
                        )
                    );
                    chaîne psPath = Path.Combine(psDir, "data.dat");

                    si (string.IsNullOrEmpty(psDir) || !File.Exists(psPath))
                    {
                        chaîne[] psDirs =
                        {
                            @"spp\store",
                            @"spp\store\2.0",
                            @"spp\store_test",
                            @"spp\store_test\2.0"
                        };

                        pour chaque (chaîne dir dans psDirs)
                        {
                            psPath = Path.Combine(
                                Chemin.Combiner(
                                    Environnement.ObtenirCheminDuDossier(Environnement.DossierSpécial.Système),
                                    dir
                                ),
                                "data.dat"
                            );

                            si (File.Exists(psPath)) retourner psPath;
                        }
                    }
                    autre
                    {
                        renvoyer psPath;
                    }

                    throw new FileNotFoundException("Impossible de localiser le magasin physique.");
            }
        }

        public static string GetTokensPath(PSVersion version)
        {
            commutateur (version)
            {
                cas PSVersion.Vista :
                    retourner Path.Combiner(
                        Environnement.ExpandEnvironmentVariables("%WINDIR%"),
                        @"ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareLicensing\tokens.dat"
                    );
                cas PSVersion.Win7 :
                    retourner Path.Combiner(
                        Environnement.ExpandEnvironmentVariables("%WINDIR%"),
                        @"ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\tokens.dat"
                    );
                défaut:
                    chaîne tokDir = Environment.ExpandEnvironmentVariables(
                        (chaîne)Registry.GetValue(
                            @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform",
                            "TokenStore",
                            ""
                        )
                    );
                    chaîne tokPath = Path.Combine(tokDir, "tokens.dat");

                    si (string.IsNullOrEmpty(tokDir) || !File.Exists(tokPath))
                    {
                        chaîne[] tokDirs =
                        {
                            @"spp\store",
                            @"spp\store\2.0",
                            @"spp\store_test",
                            @"spp\store_test\2.0"
                        };

                        pour chaque (chaîne dir dans tokDirs)
                        {
                            tokPath = Path.Combine(
                                Chemin.Combiner(
                                    Environnement.ObtenirCheminDuDossier(Environnement.DossierSpécial.Système),
                                    dir
                                ),
                                "tokens.dat"
                            );

                            si (Fichier.Existe(tokPath)) retourner tokPath ;
                        }
                    }
                    autre
                    {
                        retourner tokPath;
                    }

                    throw new FileNotFoundException("Impossible de localiser le magasin de jetons.");
            }
        }

        public statique IPhysicalStore GetStore(PSVersion version, bool production)
        {
            chaîne psPath = GetPSPath(version);

            commutateur (version)
            {
                cas PSVersion.Vista :
                    retourner un nouveau PhysicalStoreVista(psPath, production);
                cas PSVersion.Win7 :
                    retourner un nouveau PhysicalStoreWin7(psPath, production);
                défaut:
                    renvoie un nouveau PhysicalStoreModern(psPath, production, version);
            }
        }

        public statique ITokenStore GetTokenStore(PSVersion version)
        {
            chaîne tokPath = GetTokensPath(version);

            renvoie un nouveau TokenStoreModern(tokPath);
        }

        public static void DumpStore(PSVersion version, bool production, string filePath, string encrFilePath)
        {
            bool manageSpp = faux;

            si (encrFilePath == null)
            {
                encrFilePath = GetPSPath(version);
                gérerSpp = vrai ;
                TuerSPP(version);
            }

            si (string.IsNullOrEmpty(encrFilePath) || !File.Exists(encrFilePath))
            {
                throw new FileNotFoundException("Le magasin n'existe pas au chemin attendu '" + encrFilePath + "'.");
            }

            essayer
            {
                using (FileStream fs = File.Open(encrFilePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                {
                    byte[] encrData = fs.ReadAllBytes();
                    Fichier.WriteAllBytes(filePath, PhysStoreCrypto.DecryptPhysicalStore(encrData, production, version));
                }
                Logger.WriteLine("Vidage réussi vers '" + filePath + "'.");
            }
            enfin
            {
                si (gérerSpp)
                {
                    RedémarrerSPP(version);
                }
            }
        }

        public static void LoadStore(PSVersion version, bool production, string filePath)
        {
            si (string.IsNullOrEmpty(filePath) || !File.Exists(filePath))
            {
                throw new FileNotFoundException("Le fichier de stockage '" + filePath + "' n'existe pas.");
            }

            TuerSPP(version);

            en utilisant (IPhysicalStore store = GetStore(version, production))
            {
                magasin.WriteRaw(Fichier.ReadAllBytes(chemin_du_fichier));
            }

            RedémarrerSPP(version);

            Logger.WriteLine("Fichier de stockage chargé avec succès.");
        }
    }
}


// LibTSforge/SPP/SPSys.cs
espace de noms LibTSforge.SPP
{
    utilisation de Microsoft.Win32.SafeHandles ;
    en utilisant le système ;
    utilisation de System.Runtime.InteropServices ;

    classe publique SPsys
    {
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr CreateFile(string lpFileName, uint dwDesiredAccess, uint dwShareMode, IntPtr lpSecurityAttributes, uint dwCreationDisposition, uint dwFlagsAndAttributes, IntPtr hTemplateFile);
        private static SafeFileHandleCreateFileSafe(string device)
        {
            renvoie un nouveau SafeFileHandle(CreateFile(device, 0xC0000000, 0, IntPtr.Zero, 3, 0, IntPtr.Zero), true);
        }

        [retourne : MarshalAs(UnmanagedType.Bool)]
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern bool DeviceIoControl([In] SafeFileHandle hDevice, [In] uint dwIoControlCode, [In] IntPtr lpInBuffer, [In] int nInBufferSize, [Out] IntPtr lpOutBuffer, [In] int nOutBufferSize, out int lpBytesReturned, [In] IntPtr lpOverlapped);

        public statique bool IsSpSysRunning()
        {
            SafeFileHandle fichier = CreateFileSafe(@"\\.\SpDevice");
            Tampon IntPtr = Marshal.AllocHGlobal(1);
            int octetsRetournés;
            DeviceIoControl(fichier, 0x80006008, IntPtr.Zero, 0, tampon, 1, octets retournés, IntPtr.Zero);
            booléen running = Marshal.ReadByte(buffer) != 0;
            Marshal.FreeHGlobal(tampon);
            fichier.Fermer();
            retourner en cours d'exécution ;
        }

        public static int ControlSpSys(bool start)
        {
            SafeFileHandle fichier = CreateFileSafe(@"\\.\SpDevice");
            Tampon IntPtr = Marshal.AllocHGlobal(4);
            int octetsRetournés;
            DeviceIoControl(fichier, début ? 0x8000a000 : 0x8000a004, IntPtr.Zero, 0, tampon, 4, octets retournés, IntPtr.Zero);
            int résultat = Marshal.ReadInt32(buffer);
            Marshal.FreeHGlobal(tampon);
            fichier.Fermer();
            renvoyer le résultat ;
        }
    }
}


// LibTSforge/Crypto/CryptoUtils.cs
espace de noms LibTSforge.Crypto
{
    en utilisant le système ;
    utilisation de System.Linq ;
    utilisation de System.Security.Cryptography ;

    classe statique publique CryptoUtils
    {
        public static byte[] GénérerCléAléatoire(int len)
        {
            byte[] rand = nouveau byte[len];
            r aléatoire = nouveau Random();
            r.NextBytes(rand);

            renvoyer aléatoire;
        }

        public statique byte[] AESEncrypt(byte[] données, byte[] clé)
        {
            en utilisant (Aes aes = Aes.Create())
            {
                aes.Clé = clé;
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;

                ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, Enumerable.Repeat((byte)0, 16).ToArray());
                byte[] encryptedData = encryptor.TransformFinalBlock(data, 0, data.Length);
                renvoyer des données chiffrées ;
            }
        }

        public statique byte[] AESDecrypt(byte[] data, byte[] key)
        {
            en utilisant (Aes aes = Aes.Create())
            {
                aes.Clé = clé;
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;

                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, Enumerable.Repeat((byte)0, 16).ToArray());
                byte[] donnéesdécryptées = décrypteur.TransformFinalBlock(données, 0, données.Longueur);
                renvoyer les données déchiffrées ;
            }
        }

        public static byte[] RSADecrypt(byte[] rsaKey, byte[] data)
        {

            en utilisant (RSACryptoServiceProvider rsa = new RSACryptoServiceProvider())
            {
                rsa.ImportCspBlob(rsaKey);
                renvoie rsa.Decrypt(données, faux);
            }
        }

        public static byte[] RSAEncrypt(byte[] rsaKey, byte[] data)
        {
            en utilisant (RSACryptoServiceProvider rsa = new RSACryptoServiceProvider())
            {
                rsa.ImportCspBlob(rsaKey);
                renvoie rsa.Encrypt(données, faux);
            }
        }

        public static byte[] RSASign(byte[] rsaKey, byte[] data)
        {
            en utilisant (RSACryptoServiceProvider rsa = new RSACryptoServiceProvider())
            {
                rsa.ImportCspBlob(rsaKey);
                RSAPKCS1SignatureFormatter formatter = nouveau RSAPKCS1SignatureFormatter(rsa);
                formatter.SetHashAlgorithm("SHA1");

                hachage byte[] ;
                en utilisant (SHA1 sha1 = SHA1.Create())
                {
                    hash = sha1.ComputeHash(données);
                }

                retourner formatter.CreateSignature(hash);
            }
        }

        public static bool RSAVerifySignature(byte[] rsaKey, byte[] data, byte[] signature)
        {
            en utilisant (RSACryptoServiceProvider rsa = new RSACryptoServiceProvider())
            {
                rsa.ImportCspBlob(rsaKey);
                RSAPKCS1SignatureDeformatter deformatter = nouveau RSAPKCS1SignatureDeformatter(rsa);
                deformatter.SetHashAlgorithm("SHA1");

                hachage byte[] ;
                en utilisant (SHA1 sha1 = SHA1.Create())
                {
                    hash = sha1.ComputeHash(données);
                }

                retourner deformatter.VerifySignature(hash, signature);
            }
        }

        public statique byte[] HMACSign(byte[] clé, byte[] données)
        {
            HMACSHA1 hmac = nouveau HMACSHA1(clé);
            retourner hmac.ComputeHash(données);
        }

        public static bool HMACVerify(byte[] clé, byte[] données, byte[] signature)
        {
            renvoie Enumerable.SequenceEqual(signature, HMACSign(clé, données));
        }

        public statique byte[] SaltSHASum(byte[] sel, byte[] données)
        {
            SHA1 sha1 = SHA1.Créer();
            byte[] sha_data = salt.Concat(data).ToArray();
            renvoie sha1.ComputeHash(sha_data);
        }

        public static bool SaltSHAVerify(byte[] sel, byte[] données, byte[] somme de contrôle)
        {
            renvoie Enumerable.SequenceEqual(checksum, SaltSHASum(salt, data));
        }

        public statique byte[] SHA256Hash(byte[] données)
        {
            en utilisant (SHA256 sha256 = SHA256.Create())
            {
                renvoie sha256.ComputeHash(données);
            }
        }
    }
}


// LibTSforge/Crypto/Keys.cs
espace de noms LibTSforge.Crypto
{
    classe publique statique Keys
    {
        public statique readonly byte[] PRODUCTION = {
            0x07, 0x02, 0x00, 0x00, 0x00, 0xA4, 0x00, 0x00, 0x52, 0x53, 0x41, 0x32, 0x00, 0x04, 0x00, 0x00,
            0x01, 0x00, 0x01, 0x00, 0x29, 0x87, 0xBA, 0x3F, 0x52, 0x90, 0x57, 0xD8, 0x12, 0x26, 0x6B, 0x38,
            0xB2, 0x3B, 0xF9, 0x67, 0x08, 0x4F, 0xDD, 0x8B, 0xF5, 0xE3, 0x11, 0xB8, 0x61, 0x3A, 0x33, 0x42,
            0x51, 0x65, 0x05, 0x86, 0x1E, 0x00, 0x41, 0xDE, 0xC5, 0xDD, 0x44, 0x60, 0x56, 0x3D, 0x14, 0x39,
            0xB7, 0x43, 0x65, 0xE9, 0xF7, 0x2B, 0xA5, 0xF0, 0xA3, 0x65, 0x68, 0xE9, 0xE4, 0x8B, 0x5C, 0x03,
            0x2D, ​​0x36, 0xFE, 0x28, 0x4C, 0xD1, 0x3C, 0x3D, 0xC1, 0x90, 0x75, 0xF9, 0x6E, 0x02, 0xE0, 0x58,
            0x97, 0x6A, 0xCA, 0x80, 0x02, 0x42, 0x3F, 0x6C, 0x15, 0x85, 0x4D, 0x83, 0x23, 0x6A, 0x95, 0x9E,
            0x38, 0x52, 0x59, 0x38, 0x6A, 0x99, 0xF0, 0xB5, 0xCD, 0x53, 0x7E, 0x08, 0x7C, 0xB5, 0x51, 0xD3,
            0x8F, 0xA3, 0x0D, 0xA0, 0xFA, 0x8D, 0x87, 0x3C, 0xFC, 0x59, 0x21, 0xD8, 0x2E, 0xD9, 0x97, 0x8B,
            0x40, 0x60, 0xB1, 0xD7, 0x2B, 0x0A, 0x6E, 0x60, 0xB5, 0x50, 0xCC, 0x3C, 0xB1, 0x57, 0xE4, 0xB7,
            0xDC, 0x5A, 0x4D, 0xE1, 0x5C, 0xE0, 0x94, 0x4C, 0x5E, 0x28, 0xFF, 0xFA, 0x80, 0x6A, 0x13, 0x53,
            0x52, 0xDB, 0xF3, 0x04, 0x92, 0x43, 0x38, 0xB9, 0x1B, 0xD9, 0x85, 0x54, 0x7B, 0x14, 0xC7, 0x89,
            0x16, 0x8A, 0x4B, 0x82, 0xA1, 0x08, 0x02, 0x99, 0x23, 0x48, 0xDD, 0x75, 0x9C, 0xC8, 0xC1, 0xCE,
            0xB0, 0xD7, 0x1B, 0xD8, 0xFB, 0x2D, ​​0xA7, 0x2E, 0x47, 0xA7, 0x18, 0x4B, 0xF6, 0x29, 0x69, 0x44,
            0x30, 0x33, 0xBA, 0xA7, 0x1F, 0xCE, 0x96, 0x9E, 0x40, 0xE1, 0x43, 0xF0, 0xE0, 0x0D, 0x0A, 0x32,
            0xB4, 0xEE, 0xA1, 0xC3, 0x5E, 0x9B, 0xC7, 0x7F, 0xF5, 0x9D, 0xD8, 0xF2, 0x0F, 0xD9, 0x8F, 0xAD,
            0x75, 0x0A, 0x00, 0xD5, 0x25, 0x43, 0xF7, 0xAE, 0x51, 0x7F, 0xB7, 0xDE, 0xB7, 0xAD, 0xFB, 0xCE,
            0x83, 0xE1, 0x81, 0xFF, 0xDD, 0xA2, 0x77, 0xFE, 0xEB, 0x27, 0x1F, 0x10, 0xFA, 0x82, 0x37, 0xF4,
            0x7E, 0xCC, 0xE2, 0xA1, 0x58, 0xC8, 0xAF, 0x1D, 0x1A, 0x81, 0x31, 0x6E, 0xF4, 0x8B, 0x63, 0x34,
            0xF3, 0x05, 0x0F, 0xE1, 0xCC, 0x15, 0xDC, 0xA4, 0x28, 0x7A, 0x9E, 0xEB, 0x62, 0xD8, 0xD8, 0x8C,
            0x85, 0xD7, 0x07, 0x87, 0x90, 0x2F, 0xF7, 0x1C, 0x56, 0x85, 0x2F, 0xEF, 0x32, 0x37, 0x07, 0xAB,
            0xB0, 0xE6, 0xB5, 0x02, 0x19, 0x35, 0xAF, 0xDB, 0xD4, 0xA2, 0x9C, 0x36, 0x80, 0xC6, 0xDC, 0x82,
            0x08, 0xE0, 0xC0, 0x5F, 0x3C, 0x59, 0xAA, 0x4E, 0x26, 0x03, 0x29, 0xB3, 0x62, 0x58, 0x41, 0x59,
            0x3A, 0x37, 0x43, 0x35, 0xE3, 0x9F, 0x34, 0xE2, 0xA1, 0x04, 0x97, 0x12, 0x9D, 0x8C, 0xAD, 0xF7,
            0xFB, 0x8C, 0xA1, 0xA2, 0xE9, 0xE4, 0xEF, 0xD9, 0xC5, 0xE5, 0xDF, 0x0E, 0xBF, 0x4A, 0xE0, 0x7A,
            0x1E, 0x10, 0x50, 0x58, 0x63, 0x51, 0xE1, 0xD4, 0xFE, 0x57, 0xB0, 0x9E, 0xD7, 0xDA, 0x8C, 0xED,
            0x7D, 0x82, 0xAC, 0x2F, 0x25, 0x58, 0x0A, 0x58, 0xE6, 0xA4, 0xF4, 0x57, 0x4B, 0xA4, 0x1B, 0x65,
            0xB9, 0x4A, 0x87, 0x46, 0xEB, 0x8C, 0x0F, 0x9A, 0x48, 0x90, 0xF9, 0x9F, 0x76, 0x69, 0x03, 0x72,
            0x77, 0xEC, 0xC1, 0x42, 0x4C, 0x87, 0xDB, 0x0B, 0x3C, 0xD4, 0x74, 0xEF, 0xE5, 0x34, 0xE0, 0x32,
            0x45, 0xB0, 0xF8, 0xAB, 0xD5, 0x26, 0x21, 0xD7, 0xD2, 0x98, 0x54, 0x8F, 0x64, 0x88, 0x20, 0x2B,
            0x14, 0xE3, 0x82, 0xD5, 0x2A, 0x4B, 0x8F, 0x4E, 0x35, 0x20, 0x82, 0x7E, 0x1B, 0xFE, 0xFA, 0x2C,
            0x79, 0x6C, 0x6E, 0x66, 0x94, 0xBB, 0x0A, 0xEB, 0xBA, 0xD9, 0x70, 0x61, 0xE9, 0x47, 0xB5, 0x82,
            0xFC, 0x18, 0x3C, 0x66, 0x3A, 0x09, 0x2E, 0x1F, 0x61, 0x74, 0xCA, 0xCB, 0xF6, 0x7A, 0x52, 0x37,
            0x1D, 0xAC, 0x8D, 0x63, 0x69, 0x84, 0x8E, 0xC7, 0x70, 0x59, 0xDD, 0x2D, ​​0x91, 0x1E, 0xF7, 0xB1,
            0x56, 0xED, 0x7A, 0x06, 0x9D, 0x5B, 0x33, 0x15, 0xDD, 0x31, 0xD0, 0xE6, 0x16, 0x07, 0x9B, 0xA5,
            0x94, 0x06, 0x7D, 0xC1, 0xE9, 0xD6, 0xC8, 0xAF, 0xB4, 0x1E, 0x2D, ​​0x88, 0x06, 0xA7, 0x63, 0xB8,
            0xCF, 0xC8, 0xA2, 0x6E, 0x84, 0xB3, 0x8D, 0xE5, 0x47, 0xE6, 0x13, 0x63, 0x8E, 0xD1, 0x7F, 0xD4,
            0x81, 0x44, 0x38, 0xBF
        };

        public statique readonly byte[] TEST = {
            0x07, 0x02, 0x00, 0x00, 0x00, 0xA4, 0x00, 0x00, 0x52, 0x53, 0x41, 0x32, 0x00, 0x04, 0x00, 0x00,
            0x01, 0x00, 0x01, 0x00, 0x0F, 0xBE, 0x77, 0xB8, 0xDD, 0x54, 0x36, 0xDD, 0x67, 0xD4, 0x17, 0x66,
            0xC4, 0x13, 0xD1, 0x3F, 0x1E, 0x16, 0x0C, 0x16, 0x35, 0xAB, 0x6D, 0x3D, 0x34, 0x51, 0xED, 0x3F,
            0x57, 0x14, 0xB6, 0xB7, 0x08, 0xE9, 0xD9, 0x7A, 0x80, 0xB3, 0x5F, 0x9B, 0x3A, 0xFD, 0x9E, 0x37,
            0x3A, 0x53, 0x72, 0x67, 0x92, 0x60, 0xC3, 0xEF, 0xB5, 0x8E, 0x1E, 0xCF, 0x9D, 0x9C, 0xD3, 0x90,
            0xE5, 0xDD, 0xF4, 0xDB, 0xF3, 0xD6, 0x65, 0xB3, 0xC1, 0xBD, 0x69, 0xE1, 0x76, 0x95, 0xD9, 0x37,
            0xB8, 0x5E, 0xCA, 0x3D, 0x98, 0xFC, 0x50, 0x5C, 0x98, 0xAE, 0xE3, 0x7C, 0x4C, 0x27, 0xC3, 0xD0,
            0xCE, 0x78, 0x06, 0x51, 0x68, 0x23, 0xE6, 0x70, 0xF8, 0x7C, 0xAE, 0x36, 0xBE, 0x41, 0x57, 0xE2,
            0xC3, 0x2D, ​​0xAF, 0x21, 0xB1, 0xB3, 0x15, 0x81, 0x19, 0x26, 0x6B, 0x10, 0xB3, 0xE9, 0xD1, 0x45,
            0x21, 0x77, 0x9C, 0xF6, 0xE1, 0xDD, 0xB6, 0x78, 0x9D, 0x1D, 0x32, 0x61, 0xBC, 0x2B, 0xDB, 0x86,
            0xFB, 0x07, 0x24, 0x10, 0x19, 0x4F, 0x09, 0x6D, 0x03, 0x90, 0xD4, 0x5E, 0x30, 0x85, 0xC5, 0x58,
            0x7E, 0x5D, 0xAE, 0x9F, 0x64, 0x93, 0x04, 0x82, 0x09, 0x0E, 0x1C, 0x66, 0xA8, 0x95, 0x91, 0x51,
            0xB2, 0xED, 0x9A, 0x75, 0x04, 0x87, 0x50, 0xAC, 0xCC, 0x20, 0x06, 0x45, 0xB9, 0x7B, 0x42, 0x53,
            0x9A, 0xD1, 0x29, 0xFC, 0xEF, 0xB9, 0x47, 0x16, 0x75, 0x69, 0x05, 0x87, 0x2B, 0xCB, 0x54, 0x9C,
            0x21, 0x2D, ​​0x50, 0x8E, 0x12, 0xDE, 0xD3, 0x6B, 0xEC, 0x92, 0xA1, 0xB1, 0xE9, 0x4B, 0xBF, 0x6B,
            0x9A, 0x38, 0xC7, 0x13, 0xFA, 0x78, 0xA1, 0x3C, 0x1E, 0xBB, 0x38, 0x31, 0xBB, 0x0C, 0x9F, 0x70,
            0x1A, 0x31, 0x00, 0xD7, 0x5A, 0xA5, 0x84, 0x24, 0x89, 0x80, 0xF5, 0x88, 0xC2, 0x31, 0x18, 0xDC,
            0x53, 0x05, 0x5D, 0xFA, 0x81, 0xDC, 0xE1, 0xCE, 0xA4, 0xAA, 0xBA, 0x07, 0xDA, 0x28, 0x4F, 0x64,
            0x0E, 0x84, 0x9B, 0x06, 0xDE, 0xC8, 0x78, 0x66, 0x2F, 0x17, 0x25, 0xA8, 0x9C, 0x99, 0xFC, 0xBC,
            0x7D, 0x01, 0x42, 0xD7, 0x35, 0xBF, 0x19, 0xF6, 0x3F, 0x20, 0xD9, 0x98, 0x9B, 0x5D, 0xDD, 0x39,
            0xBE, 0x81, 0x00, 0x0B, 0xDE, 0x6F, 0x14, 0xCA, 0x7E, 0xF8, 0xC0, 0x26, 0xA8, 0x1D, 0xD1, 0x16,
            0x88, 0x64, 0x87, 0x36, 0x45, 0x37, 0x50, 0xDA, 0x6C, 0xEB, 0x85, 0xB5, 0x43, 0x29, 0x88, 0x6F,
            0x2F, 0xFE, 0x8D, 0x12, 0x8B, 0x72, 0xB7, 0x5A, 0xCB, 0x66, 0xC2, 0x2E, 0x1D, 0x7D, 0x42, 0xA6,
            0xF4, 0xFE, 0x26, 0x5D, 0x54, 0x9E, 0x77, 0x1D, 0x97, 0xC2, 0xF3, 0xFD, 0x60, 0xB3, 0x22, 0x88,
            0xCA, 0x27, 0x99, 0xDF, 0xC8, 0xB1, 0xD7, 0xC6, 0x54, 0xA6, 0x50, 0xB9, 0x54, 0xF5, 0xDE, 0xFE,
            0xE1, 0x81, 0xA2, 0xBE, 0x81, 0x9F, 0x48, 0xFF, 0x2F, 0xB8, 0xA4, 0xB3, 0x17, 0xD8, 0xC1, 0xB9,
            0x5D, 0x21, 0x3D, 0xA2, 0xED, 0x1C, 0x96, 0x66, 0xEE, 0x1F, 0x47, 0xCF, 0x62, 0xFA, 0xD6, 0xC1,
            0x87, 0x5B, 0xC4, 0xE5, 0xD9, 0x08, 0x38, 0x22, 0xFA, 0x21, 0xBD, 0xF2, 0x88, 0xDA, 0xE2, 0x24,
            0x25, 0x1F, 0xF1, 0x0B, 0x2D, ​​0xAE, 0x04, 0xBE, 0xA6, 0x7F, 0x75, 0x8C, 0xD9, 0x97, 0xE1, 0xCA,
            0x35, 0xB9, 0xFC, 0x6F, 0x01, 0x68, 0x11, 0xD3, 0x68, 0x32, 0xD0, 0xC1, 0x69, 0xA3, 0xCF, 0x9B,
            0x10, 0xE4, 0x69, 0xA7, 0xCF, 0xE1, 0xFE, 0x2A, 0x07, 0x9E, 0xC1, 0x37, 0x84, 0x68, 0xE5, 0xC5,
            0xAB, 0x25, 0xEC, 0x7D, 0x7D, 0x74, 0x6A, 0xD1, 0xD5, 0x4D, 0xD7, 0xE1, 0x7D, 0xDE, 0x30, 0x4B,
            0xE6, 0x5D, 0xCD, 0x91, 0x59, 0xF6, 0x80, 0xFD, 0xC6, 0x3C, 0xDD, 0x94, 0x7F, 0x15, 0x9D, 0xEF,
            0x2F, 0x00, 0x62, 0xD7, 0xDA, 0xB9, 0xB3, 0xD9, 0x8D, 0xE8, 0xD7, 0x3C, 0x96, 0x45, 0x5D, 0x1E,
            0x50, 0xFB, 0xAA, 0x43, 0xD3, 0x47, 0x77, 0x81, 0xE9, 0x67, 0xE4, 0xFE, 0xDF, 0x42, 0x79, 0xCB,
            0xA7, 0xAD, 0x5D, 0x48, 0xF5, 0xB7, 0x74, 0x96, 0x12, 0x23, 0x06, 0x70, 0x42, 0x68, 0x7A, 0x44,
            0xFC, 0xA0, 0x31, 0x7F, 0x68, 0xCA, 0xA2, 0x14, 0x5D, 0xA3, 0xCF, 0x42, 0x23, 0xAB, 0x47, 0xF6,
            0xB2, 0xFC, 0x6D, 0xF1
        };
    }
}


// LibTSforge/Crypto/PhysStoreCrypto.cs
espace de noms LibTSforge.Crypto
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;
    utilisation de System.IO ;
    utilisation de System.Linq ;
    utiliser System.Text;

    classe statique publique PhysStoreCrypto
    {
        public static byte[] DecryptPhysicalStore(byte[] data, bool production, PSVersion version)
        {
            byte[] rsaKey = production ? Keys.PRODUCTION : Keys.TEST;
            BinaryReader br = new BinaryReader(new MemoryStream(data));
            br.BaseStream.Seek(0x10, SeekOrigin.Begin);
            byte[] aesKeySig = br.ReadBytes(0x80);
            byte[] encAesKey = br.ReadBytes(0x80);

            si (!CryptoUtils.RSAVerifySignature(rsaKey, encAesKey, aesKeySig))
            {
                throw new Exception("Échec du décryptage du stockage physique.");
            }

            byte[] aesKey = CryptoUtils.RSADecrypt(rsaKey, encAesKey);
            byte[] decData = CryptoUtils.AESDecrypt(br.ReadBytes((int)br.BaseStream.Length - 0x110), aesKey);
            byte[] hmacKey = decData.Take(0x10).ToArray(); // Sel SHA-1 sur Vista
            byte[] hmacSig = decData.Skip(0x10).Take(0x14).ToArray(); // Hachage SHA-1 sur Vista
            octet[] psData = decData.Skip(0x28).ToArray();

            si (version != PSVersion.Vista)
            {
                si (!CryptoUtils.HMACVerify(hmacKey, psData, hmacSig))
                {
                    throw new InvalidDataException("Échec de la vérification HMAC. Le magasin physique est corrompu.");
                }
            }
            autre
            {
                si (!CryptoUtils.SaltSHAVerify(hmacKey, psData, hmacSig))
                {
                    throw new InvalidDataException("Échec de la vérification de la somme de contrôle. Le stockage physique est corrompu.");
                }
            }

            renvoyer psData;
        }

        public static byte[] EncryptPhysicalStore(byte[] data, bool production, PSVersion version)
        {
            Dictionnaire<PSVersion, int> versionTable = nouveau Dictionnaire<PSVersion, int>
            {
                {PSVersion.Vista, 2},
                {PSVersion.Win7, 5},
                {PSVersion.Win8, 1},
                {PSVersion.WinBlue, 2},
                {PSVersion.WinModern, 3}
            };

            byte[] rsaKey = production ? Keys.PRODUCTION : Keys.TEST;

            byte[] aesKey = Encoding.UTF8.GetBytes("massgrave.dev :3");
            byte[] hmacKey = CryptoUtils.GenerateRandomKey(0x10);

            byte[] encAesKey = CryptoUtils.RSAEncrypt(rsaKey, aesKey);
            byte[] aesKeySig = CryptoUtils.RSASign(rsaKey, encAesKey);
            byte[] hmacSig = version != PSVersion.Vista ? CryptoUtils.HMACSign(hmacKey, data) : CryptoUtils.SaltSHASum(hmacKey, data);

            byte[] decData = { };
            decData = decData.Concat(hmacKey).Concat(hmacSig).Concat(BitConverter.GetBytes(0)).Concat(data).ToArray();
            byte[] encData = CryptoUtils.AESEncrypt(decData, aesKey);

            BinaryWriter bw = new BinaryWriter(new MemoryStream());
            bw.Write(versionTable[version]);
            bw.Write(Encoding.UTF8.GetBytes("UNTRUSTSTORE"));
            bw.Write(aesKeySig);
            bw.Write(encAesKey);
            bw.Write(encData);

            renvoie bw.GetBytes();
        }
    }
}


// LibTSforge/Modifiers/GenPKeyInstall.cs
espace de noms LibTSforge.Modificateurs
{
    en utilisant le système ;
    utilisation de System.IO ;
    utilisation de Microsoft.Win32 ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;
    utilisation de TokenStore ;

    classe publique statique GenPKeyInstall
    {
        privée statique void WritePkey2005RegistryValues(PSVersion version, ProductKey pkey)
        {
            Logger.WriteLine("Écriture des données de registre pour la clé de produit Windows...");
            Registry.SetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductId", pkey.GetPid2());
            Registry.SetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductId", pkey.GetPid3());
            Registry.SetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductId4", pkey.GetPid4());

            si (Registry.GetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration", "ProductId", null) != null)
            {
                Registry.SetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration", "ProductId", pkey.GetPid2());
                Registry.SetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration", "DigitalProductId", pkey.GetPid3());
                Registry.SetValue(@"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration", "DigitalProductId4", pkey.GetPid4());
            }

            si (pkey.Channel == "Volume:CSVLK" && version != PSVersion.Win7)
            {
                Registry.SetValue(@"HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform", "KmsHostConfig", 1);
            }
        }

        public static void InstallGenPKey(PSVersion version, bool production, Guid actId)
        {
            if (version == PSVersion.Vista) throw new NotSupportedException("Cette fonctionnalité n'est pas prise en charge sur Windows Vista/Server 2008.");
            if (actId == Guid.Empty) throw new ArgumentException("L'identifiant d'activation doit être spécifié pour l'installation de la clé de produit générée.");

            PKeyConfig pkc = nouveau PKeyConfig();
            
            essayer
            {
                pkc.LoadConfig(actId);
            }
            attraper (ArgumentException)
            {
                pkc.LoadAllConfigs(SLApi.GetAppId(actId));
            }

            Configuration du produit ;
            pkc.Products.TryGetValue(actId, out config);

            if (config == null) throw new ArgumentException("L'ID d'activation " + actId + " n'a pas été trouvé dans PKeyConfig.");

            ProductKey pkey = config.GetRandomKey();

            Guid instPkeyId = SLApi.GetInstalledPkeyID(actId);
            si (instPkeyId != Guid.Empty) SLApi.UninstallProductKey(instPkeyId);

            si (pkey.Algorithm == PKeyAlgorithm.PKEY2009)
            {
                statut uint = SLApi.InstallProductKey(pkey);
                Logger.WriteLine(string.Format("Installation de la clé de produit générée {0} statut {1:X}", pkey, status));

                si ((int)status < 0)
                {
                    throw new ApplicationException("Échec de l'installation de la clé de produit générée.");
                }

                Logger.WriteLine("Clé de produit générée déposée avec succès.");
                retour;
            }

            Logger.WriteLine("La plage de clés est PKEY2005, création de données de clé factices...");

            if (pkey.Channel == "Volume:GVLK" && version == PSVersion.Win7) throw new NotSupportedException("La génération de faux GVLK n'est pas prise en charge sous Windows 7.");

            VariableBag pkb = nouveau VariableBag(version);
            pkb.Blocks.AddRange(new[]
            {
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.STRING,
                    KeyAsStr = "SppPkeyBindingProductKey",
                    ValeurAsStr = pkey.ToString()
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.STRING,
                    KeyAsStr = "SppPkeyBindingMPC",
                    ValeurAsStr = pkey.GetMPC()
                },
                nouveau CRCBlockModern {
                    Type de données = CRCBlockType.BINAIRE,
                    KeyAsStr = "SppPkeyBindingPid2",
                    ValeurAsStr = pkey.GetPid2()
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.BINAIRE,
                    KeyAsStr = "SppPkeyBindingPid3",
                    Valeur = pkey.GetPid3()
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.BINAIRE,
                    KeyAsStr = "SppPkeyBindingPid4",
                    Valeur = pkey.GetPid4()
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.STRING,
                    KeyAsStr = "SppPkeyChannelId",
                    ValeurAsStr = pkey.Channel
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.STRING,
                    KeyAsStr = "SppPkeyBindingEditionId",
                    ValeurAsStr = pkey.Édition
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.BINAIRE,
                    KeyAsStr = (version == PSVersion.Win7) ? "SppPkeyShortAuthenticator" : "SppPkeyPhoneActivationData",
                    Valeur = pkey.GetPhoneData(version)
                },
                nouveau CRCBlockModern
                {
                    Type de données = CRCBlockType.BINAIRE,
                    KeyAsStr = "SppPkeyBindingMiscData",
                    Valeur = nouveau tableau d'octets { }
                }
            });

            Guid appId = SLApi.GetAppId(actId);
            chaîne pkeyId = pkey.GetPkeyId().ToString();
            bool isAddon = SLApi.IsAddon(actId);
            chaîne currEdition = SLApi.GetMetaStr(actId, "Famille");

            si (appId == SLApi.WINDOWS_APP_ID && !isAddon)
            {
                SLApi.UninstallAllProductKeys(appId);
            }

            SPPUtils.KillSPP(version);

            en utilisant (IPhysicalStore ps = SPPUtils.GetStore(version, production))
            {
                en utilisant (ITokenStore tks = SPPUtils.GetTokenStore(version))
                {
                    Logger.WriteLine("Écriture dans le stockage physique et le stockage des jetons...");

                    suffixe de chaîne = (version == PSVersion.Win8 || version == PSVersion.WinBlue || version == PSVersion.WinModern) ? "_--" : "";
                    chaîne metSuffix = suffixe + "_met";

                    si (appId == SLApi.WINDOWS_APP_ID && !isAddon)
                    {
                        chaîne edTokName = "msft:spp/token/windows/productkeyid/" + currEdition;

                        TokenMeta edToken = tks.GetMetaEntry(edTokenName);
                        edToken.Data["windowsComponentEditionPkeyId"] = pkeyId;
                        edToken.Data["windowsComponentEditionSkuId"] = actId.ToString();
                        tks.SetEntry(edTokName, "xml", edToken.Serialize());

                        ÉcrirePkey2005RegistryValues(version, pkey);
                    }

                    chaîne uriMapName = "msft:spp/token/PKeyIdUriMapper" + metSuffix;
                    TokenMeta uriMap = tks.GetMetaEntry(uriMapName);
                    uriMap.Data[pkeyId] = pkey.GetAlgoUri();
                    tks.SetEntry(uriMapName, "xml", uriMap.Serialize());

                    chaîne skuMetaName = actId + metSuffix;
                    TokenMeta skuMeta = tks.GetMetaEntry(skuMetaName);

                    pour chaque (chaîne k dans skuMeta.Data.Keys)
                    {
                        si (k.StartsWith("pkeyId_"))
                        {
                            skuMeta.Data.Remove(k);
                            casser;
                        }
                    }

                    skuMeta.Data["pkeyId"] = pkeyId;
                    skuMeta.Data["pkeyIdList"] = pkeyId;
                    tks.SetEntry(skuMetaName, "xml", skuMeta.Serialize());

                    chaîne psKey = chaîne.Format("SPPSVC\\{0}\\{1}", appId, actId);
                    ps.SupprimerBloc(psKey, pkeyId);
                    ps.AjouterBlock(nouveau PSBlock)
                    {
                        Type = BlockType.NAMED,
                        Drapeaux = (version == PSVersion.WinModern) ? (uint)0x402 : 0x2,
                        CléAsStr = psKey,
                        ValeurAsStr = pkeyId,
                        Données = pkb.Sérialiser()
                    });

                    chaîne cachePath = SPPUtils.GetTokensPath(version).Replace("tokens.dat", @"cache\cache.dat");
                    if (File.Exists(cachePath)) File.Delete(cachePath);
                }
            }

            SLApi.RefreshTrustedTime(actId);
            Logger.WriteLine("Clé de produit factice déposée avec succès.");
        }
    }
}


// LibTSforge/Modifiers/GracePeriodReset.cs
espace de noms LibTSforge.Modificateurs
{
    utilisation de System.Collections.Generic ;
    utilisation de System.Linq ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;

    classe publique statique GracePeriodReset
    {
        public static void Reset(PSVersion version, bool production)
        {
            SPPUtils.KillSPP(version);
            Logger.WriteLine("Écriture des données TrustedStore...");

            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                valeur de chaîne = "msft:sl/timer";
                List<PSBlock> blocks = store.FindBlocks(value).ToList();

                pour chaque (PSBlock bloc dans blocs)
                {
                    magasin.SupprimerBloc(bloc.CléAsStr, bloc.ValeurAsStr);
                }
            }

            SPPUtils.RestartSPP(version);
            Logger.WriteLine("Réinitialisation réussie de tous les minuteurs de période de grâce et d'évaluation.");
        }
    }
}


// LibTSforge/Modifiers/KeyChangeLockDelete.cs
espace de noms LibTSforge.Modificateurs
{
    utilisation de System.Collections.Generic ;
    utilisation de System.Linq ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;
    en utilisant le système ;

    classe publique statique KeyChangeLockDelete
    {
        public static void Supprimer(PSVersion version, bool production)
        {
            if (version == PSVersion.Vista) throw new NotSupportedException("Cette fonctionnalité n'est pas prise en charge sur Windows Vista/Server 2008.");

            SPPUtils.KillSPP(version);
            Logger.WriteLine("Écriture des données TrustedStore...");
            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                List<string> valeurs = nouvelle List<string>
                {
                    "msft:spp/timebased/AB",
                    "msft:spp/timebased/CD"
                };
                List<PSBlock> blocks = new List<PSBlock>();
                pour chaque (valeur de chaîne dans valeurs)
                {
                    blocs.AjouterPlage(magasin.TrouverBlocs(valeur).ToList());
                }
                pour chaque (PSBlock bloc dans blocs)
                {
                    magasin.SupprimerBloc(bloc.CléAsStr, bloc.ValeurAsStr);
                }
            }
            Logger.WriteLine("Verrouillage du changement de clé supprimé avec succès.");
        }
    }
}


// LibTSforge/Modifiers/KMSHostCharge.cs
espace de noms LibTSforge.Modificateurs
{
    en utilisant le système ;
    utilisation de System.IO ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;

    classe statique publique KMSHostCharge
    {
        public static void Charge(PSVersion version, bool production, Guid actId)
        {
            si (actId == Guid.Empty)
            {
                actId = SLApi.GetDefaultActivationID(SLApi.WINDOWS_APP_ID, true);

                si (actId == Guid.Empty)
                {
                    throw new NotSupportedException("Aucun ID d'activation applicable trouvé.");
                }
            }

            if (SLApi.GetPKeyChannel(SLApi.GetInstalledPkeyID(actId)) != "Volume:CSVLK")
            {
                throw new NotSupportedException("Clé de produit non-volume : CSVLK installée.");
            }

            Guid appId = SLApi.GetAppId(actId);
            int totalClients = 50;
            int clients actuels = 25;
            byte[] hwidBlock = Constants.UniversalHWIDBlock;
            clé de chaîne = chaîne.Format("SPPSVC\\{0}", appId);
            long ldapTimestamp = DateTime.Now.ToFileTime();

            byte[] cmidGuids = { };
            byte[] reqCounts = { };
            byte[] kmsChargeData = { };

            BinaryWriter writer = new BinaryWriter(new MemoryStream());

            si (version == PSVersion.Vista)
            {
                écrivain.Écrire(nouvel octet[44]);
                écrivain.Seek(0, SeekOrigin.Begin);

                écrivain.Écrire(totalClients);
                écrivain.Écrire(43200);
                écrivain.Écrire(32);

                écrivain.Seek(20, SeekOrigin.Begin);
                écrivain.Écrire((octet)clientsactuels);

                écrivain.Seek(32, SeekOrigin.Begin);
                écrivain.Écrire((octet)clientsactuels);

                écrivain.Seek(0, SeekOrigin.End);

                pour (int i = 0; i < currClients; i++)
                {
                    écrivain.Écrire(Guid.NewGuid().ToByteArray());
                    écrivain.Écrire(ldapTimestamp - (10 * (i + 1)));
                }

                kmsChargeData = writer.GetBytes();
            }
            autre
            {
                pour (int i = 0; i < currClients; i++)
                {
                    écrivain.Écrire(ldapTimestamp - (10 * (i + 1)));
                    écrivain.Écrire(Guid.NewGuid().ToByteArray());
                }

                cmidGuids = writer.GetBytes();

                écrivain = nouveau BinaryWriter(new MemoryStream());

                écrivain.Écrire(nouvel octet[40]);

                écrivain.Seek(4, SeekOrigin.Begin);
                écrivain.Écrire((octet)clientsactuels);

                écrivain.Seek(24, SeekOrigin.Begin);
                écrivain.Écrire((octet)clientsactuels);

                reqCounts = writer.GetBytes();
            }

            SPPUtils.KillSPP(version);

            Logger.WriteLine("Écriture des données TrustedStore...");

            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                si (version != PSVersion.Vista)
                {
                    VariableBag kmsCountData = new VariableBag(version);
                    kmsCountData.Blocks.AddRange(new[]
                    {
                        nouveau CRCBlockModern
                        {
                            Type de données = CRCBlockType.BINAIRE,
                            KeyAsStr = "SppBindingLicenseData",
                            Valeur = hwidBlock
                        },
                        nouveau CRCBlockModern
                        {
                            Type de données = CRCBlockType.UINT,
                            Clé = nouveau tableau d'octets { },
                            ValeurEntier = (uint)totalClients
                        },
                        nouveau CRCBlockModern
                        {
                            Type de données = CRCBlockType.UINT,
                            Clé = nouveau tableau d'octets { },
                            ValeurEntier = 1051200000
                        },
                        nouveau CRCBlockModern
                        {
                            Type de données = CRCBlockType.UINT,
                            Clé = nouveau tableau d'octets { },
                            ValeurAsInt = (uint)currClients
                        },
                        nouveau CRCBlockModern
                        {
                            Type de données = CRCBlockType.BINAIRE,
                            Clé = nouveau tableau d'octets { },
                            Valeur = cmidGuids
                        },
                        nouveau CRCBlockModern
                        {
                            Type de données = CRCBlockType.BINAIRE,
                            Clé = nouveau tableau d'octets { },
                            Valeur = reqCounts
                        }
                    });

                    kmsChargeData = kmsCountData.Serialize();
                }

                string countVal = version == PSVersion.Vista ? "C8F6FFF1-79CE-404C-B150-F97991273DF1" : string.Format("msft:spp/kms/host/2.0/store/counters/{0}", appId);

                magasin.SupprimerBloc(clé, nombreVal);
                magasin.AjouterBlock(nouveau PSBlock
                {
                    Type = BlockType.NAMED,
                    Drapeaux = (version == PSVersion.WinModern) ? (uint)0x400 : 0,
                    CléAsStr = clé,
                    ValeurAsStr = countVal,
                    Données = kmsChargeData
                });

                Logger.WriteLine(string.Format("Nombre de frais défini sur {0} avec succès.", currClients));
            }

            SPPUtils.RestartSPP(version);
        }
    }
}


// LibTSforge/Modifiers/RearmReset.cs
espace de noms LibTSforge.Modificateurs
{
    utilisation de System.Collections.Generic ;
    utilisation de System.Linq ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;

    classe publique statique RearmReset
    {
        public static void Reset(PSVersion version, bool production)
        {
            SPPUtils.KillSPP(version);

            Logger.WriteLine("Écriture des données TrustedStore...");

            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                Lister les blocs<PSBlock> ;

                si (version == PSVersion.Vista)
                {
                    blocs = magasin.FindBlocks("740D70D8-6448-4b2f-9063-4A7A463600C5").ToList();
                }
                sinon si (version == PSVersion.Win7)
                {
                    blocs = magasin.FindBlocks(0xA0000).ToList();
                }
                autre
                {
                    blocs = magasin.FindBlocks("__##USERSEP-RESERVED##__$$REARM-COUNT$$").ToList();
                }

                pour chaque (PSBlock bloc dans blocs)
                {
                    si (version == PSVersion.Vista)
                    {
                        magasin.SupprimerBloc(bloc.CléAsStr, bloc.ValeurAsStr);
                    }
                    sinon si (version == PSVersion.Win7)
                    {
                        magasin.SetBlock(bloc.KeyAsStr, bloc.ValueAsInt, nouveau byte[8]);
                    }
                    autre
                    {
                        magasin.SetBlock(bloc.KeyAsStr, bloc.ValueAsStr, nouvel octet[8]);
                    }
                }

                Logger.WriteLine("Réinitialisation réussie de tous les compteurs de réarmement.");
            }
        }
    }
}


// LibTSforge/Modifiers/SetIIDParams.cs
espace de noms LibTSforge.Modificateurs
{
    utilisation de PhysicalStore ;
    utilisation de SPP ;
    utilisation de System.IO ;
    en utilisant le système ;

    classe publique statique SetIIDParams
    {
        public static void SetParams(PSVersion version, bool production, Guid actId, PKeyAlgorithm algorithm, int group, int serial, ulong security)
        {
            if (version == PSVersion.Vista) throw new NotSupportedException("Cette fonctionnalité n'est pas prise en charge sur Windows Vista/Server 2008.");

            Identifiant d'application Guid ;

            si (actId == Guid.Empty)
            {
                appId = SLApi.WINDOWS_APP_ID;
                actId = SLApi.GetDefaultActivationID(appId, true);

                si (actId == Guid.Empty)
                {
                    throw new Exception("Aucun ID d'activation applicable trouvé.");
                }
            }
            autre
            {
                appId = SLApi.GetAppId(actId);
            }

            Guid pkeyId = SLApi.GetInstalledPkeyID(actId);

            SPPUtils.KillSPP(version);

            Logger.WriteLine("Écriture des données TrustedStore...");

            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                chaîne clé = chaîne.Format("SPPSVC\\{0}\\{1}", appId, actId);
                PSBlock keyBlock = store.GetBlock(key, pkeyId.ToString());

                si (keyBlock == null)
                {
                    throw new InvalidDataException("Échec de la récupération des données de clé de produit pour l'ID d'activation " + actId + ".");
                }

                VariableBag pkb = new VariableBag(keyBlock.Data, version);

                ProductKey pkey = nouvelle ProductKey
                {
                    Groupe = groupe,
                    Série = série,
                    Sécurité = sécurité,
                    Algorithme = algorithme,
                    Mise à niveau = faux
                };

                chaîne blockName = version == PSVersion.Win7 ? "SppPkeyShortAuthenticator" : "SppPkeyPhoneActivationData";
                pkb.SetBlock(blockName, pkey.GetPhoneData(version));
                magasin.SetBlock(clé, pkeyId.ToString(), pkb.Serialize());
            }

            Logger.WriteLine("Paramètres IID définis avec succès.");
        }
    }
}


// LibTSforge/Modifiers/TamperedFlagsDelete.cs
espace de noms LibTSforge.Modificateurs
{
    utilisation de System.Linq ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;

    classe publique statique TamperedFlagsDelete
    {
        public static void DeleteTamperFlags(PSVersion version, bool production)
        {
            SPPUtils.KillSPP(version);

            Logger.WriteLine("Écriture des données TrustedStore...");

            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                si (version == PSVersion.Vista)
                {
                    SupprimerFlag(magasin, "6BE8425B-EC3CF-4e86-A6AF-5863E3DCB606");
                }
                sinon si (version == PSVersion.Win7)
                {
                    Définir l'indicateur(magasin, 0xA0001);
                }
                autre
                {
                    SupprimerFlag(magasin, "__##USERSEP-RESERVED##__$$RECREATED-FLAG$$");
                    SupprimerIndicateur(magasin, "__##USERSEP-RESERVED##__$$RECOVERED-FLAG$$");
                }

                Logger.WriteLine("L'état de falsification a été effacé avec succès.");
            }

            SPPUtils.RestartSPP(version);
        }

        privée statique void SupprimerFlag(IPhysicalStore store, chaîne flag)
        {
            store.FindBlocks(flag).ToList().ForEach(block => store.DeleteBlock(block.KeyAsStr, block.ValueAsStr));
        }

        méthode statique privée SetFlag(IPhysicalStore store, uint flag)
        {
            store.FindBlocks(flag).ToList().ForEach(block => store.SetBlock(block.KeyAsStr, block.ValueAsInt, new byte[8]));
        }
    }
}


// LibTSforge/Modifiers/UniqueIdDelete.cs
espace de noms LibTSforge.Modificateurs
{
    en utilisant le système ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;

    classe statique publique UniqueIdDelete
    {
        public static void DeleteUniqueId(PSVersion version, bool production, Guid actId)
        {
            if (version == PSVersion.Vista) throw new NotSupportedException("Cette fonctionnalité n'est pas prise en charge sur Windows Vista/Server 2008.");

            Identifiant d'application Guid ;

            si (actId == Guid.Empty)
            {
                appId = SLApi.WINDOWS_APP_ID;
                actId = SLApi.GetDefaultActivationID(appId, true);

                si (actId == Guid.Empty)
                {
                    throw new Exception("Aucun ID d'activation applicable trouvé.");
                }
            }
            autre
            {
                appId = SLApi.GetAppId(actId);
            }

            Guid pkeyId = SLApi.GetInstalledPkeyID(actId);

            SPPUtils.KillSPP(version);

            Logger.WriteLine("Écriture des données TrustedStore...");

            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                chaîne clé = chaîne.Format("SPPSVC\\{0}\\{1}", appId, actId);
                PSBlock keyBlock = store.GetBlock(key, pkeyId.ToString());

                si (keyBlock == null)
                {
                    lancer une nouvelle exception("Aucune clé de produit trouvée.");
                }

                VariableBag pkb = new VariableBag(keyBlock.Data, version);

                pkb.SupprimerBlock("SppPkeyUniqueIdToken");

                magasin.SetBlock(clé, pkeyId.ToString(), pkb.Serialize());
            }

            Logger.WriteLine("Suppression réussie de l'identifiant unique pour l'identifiant de clé de produit " + pkeyId);
        }
    }
}


// LibTSforge/Activators/KMS4K.cs
espace de noms LibTSforge.Activateurs
{
    en utilisant le système ;
    utilisation de System.IO ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;

    classe publique KMS4k
    {
        public static void Activate(PSVersion version, bool production, Guid actId)
        {
            Identifiant d'application Guid ;
            si (actId == Guid.Empty)
            {
                appId = SLApi.WINDOWS_APP_ID;
                actId = SLApi.GetDefaultActivationID(appId, true);

                si (actId == Guid.Empty)
                {
                    throw new NotSupportedException("Aucun ID d'activation applicable trouvé.");
                }
            }
            autre
            {
                appId = SLApi.GetAppId(actId);
            }

            if (SLApi.GetPKeyChannel(SLApi.GetInstalledPkeyID(actId)) != "Volume:GVLK")
            {
                throw new NotSupportedException("Clé de produit non-volume : GVLK installée.");
            }

            SPPUtils.KillSPP(version);

            Logger.WriteLine("Écriture des données TrustedStore...");

            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                chaîne clé = chaîne.Format("SPPSVC\\{0}\\{1}", appId, actId);

                ulong inconnu = 0;
                ulong temps1;
                ulong time2 = (ulong)DateTime.UtcNow.ToFileTime();
                ulong expiration = Constants.TimerMax;

                si (version == PSVersion.Vista || version == PSVersion.Win7)
                {
                    inconnu = 0x800000000 ;
                    temps1 = 0;
                }
                autre
                {
                    long creationTime = BitConverter.ToInt64(store.GetBlock("__##USERSEP##\\$$_RESERVED_$$\\NAMESPACE__", "__##USERSEP-RESERVED##__$$GLOBAL-CREATION-TIME$$").Data, 0);
                    long tickCount = BitConverter.ToInt64(store.GetBlock("__##USERSEP##\\$$_RESERVED_$$\\NAMESPACE__", "__##USERSEP-RESERVED##__$$GLOBAL-TICKCOUNT-UPTIME$$").Data, 0);
                    long deltaTime = BitConverter.ToInt64(store.GetBlock(key, "__##USERSEP-RESERVED##__$$UP-TIME-DELTA$$").Data, 0);

                    time1 = (ulong)(creationTime + tickCount + deltaTime);
                    temps2 /= 10000;
                    expiration /= 10000;
                }

                si (version == PSVersion.Vista)
                {
                    VistaTimer vistaTimer = nouveau VistaTimer
                    {
                        Temps = temps2,
                        Expiration = Constants.TimerMax
                    };

                    string vistaTimerName = string.Format("msft:sl/timer/VLExpiration/VOLUME/{0}/{1}", appId, actId);

                    store.DeleteBlock(clé, vistaTimerName);
                    magasin.SupprimerBloc(clé, actId.ToString());

                    BinaryWriter writer = new BinaryWriter(new MemoryStream());
                    écrivain.Écrire(Constants.KMSv4Response.Longueur);
                    écrivain.Écrire(Constantes.RéponseKMSv4);
                    écrivain.Écrire(Constants.UniversalHWIDBlock);
                    byte[] kmsData = writer.GetBytes();

                    magasin.AjouterBlocs(nouveau[]
                    {
                        nouveau PSBlock
                        {
                            Type = BlockType.TIMER,
                            Drapeaux = 0,
                            CléAsStr = clé,
                            ValeurAsStr = vistaTimerName,
                            Données = vistaTimer.CastToArray()
                        },
                        nouveau PSBlock
                        {
                            Type = BlockType.NAMED,
                            Drapeaux = 0,
                            CléAsStr = clé,
                            ValeurAsStr = actId.ToString(),
                            Données = kmsData
                        }
                    });
                }
                autre
                {
                    byte[] hwidBlock = Constants.UniversalHWIDBlock;
                    octet[] kmsResp;

                    commutateur (version)
                    {
                        cas PSVersion.Win7 :
                            kmsResp = Constants.KMSv4Response;
                            casser;
                        cas PSVersion.Win8 :
                            kmsResp = Constants.KMSv5Response;
                            casser;
                        cas PSVersion.WinBlue :
                        cas PSVersion.WinModern :
                            kmsResp = Constants.KMSv6Response;
                            casser;
                        défaut:
                            throw new NotSupportedException("Version PS non prise en charge.");
                    }

                    VariableBag kmsBinding = new VariableBag(version);

                    kmsBinding.Blocks.AddRange(new[]
                    {
                    nouveau CRCBlockModern
                    {
                        Type de données = CRCBlockType.BINAIRE,
                        Clé = nouveau tableau d'octets { },
                        Valeur = kmsResp
                    },
                    nouveau CRCBlockModern
                    {
                        Type de données = CRCBlockType.STRING,
                        Clé = nouveau tableau d'octets { },
                        ValeurAsStr = "msft:rm/algorithm/hwid/4.0"
                    },
                    nouveau CRCBlockModern
                    {
                        Type de données = CRCBlockType.BINAIRE,
                        KeyAsStr = "SppBindingLicenseData",
                        Valeur = hwidBlock
                    }
                    });

                    si (version == PSVersion.WinModern)
                    {
                        kmsBinding.Blocks.AddRange(new[]
                        {
                        nouveau CRCBlockModern
                        {
                            Type de données = CRCBlockType.STRING,
                            Clé = nouveau tableau d'octets { },
                            ValeurAsStr = "massgrave.dev"
                        },
                        nouveau CRCBlockModern
                        {
                            Type de données = CRCBlockType.STRING,
                            Clé = nouveau tableau d'octets { },
                            ValeurAsStr = "6969"
                        }
                        });
                    }

                    byte[] kmsBindingData = kmsBinding.Serialize();

                    Minuteur kmsTimer = nouveau Minuteur
                    {
                        Inconnu = inconnu,
                        Temps1 = temps1,
                        Temps2 = temps2,
                        Expiration = expiration
                    };

                    chaîne storeVal = chaîne.Format("msft:spp/kms/bind/2.0/store/{0}/{1}", appId, actId);
                    chaîne timerVal = chaîne.Format("msft:spp/kms/bind/2.0/timer/{0}/{1}", appId, actId);

                    magasin.SupprimerBloc(clé, valeurMagasin);
                    magasin.SupprimerBloc(clé, valeur_minuterie);

                    magasin.AjouterBlocs(nouveau[]
                    {
                    nouveau PSBlock
                    {
                        Type = BlockType.NAMED,
                        Drapeaux = (version == PSVersion.WinModern) ? (uint)0x400 : 0,
                        CléAsStr = clé,
                        ValeurAsStr = storeVal,
                        Données = kmsBindingData
                    },
                    nouveau PSBlock
                    {
                        Type = BlockType.TIMER,
                        Drapeaux = (version == PSVersion.Win7) ? (uint)0 : 0x4,
                        CléAsStr = clé,
                        ValeurAsStr = valeur_du_temps,
                        Données = kmsTimer.CastToArray()
                    }
                    });
                }
            }

            SPPUtils.RestartSPP(version);
            SLApi.FireStateChangedEvent(appId);
            Logger.WriteLine("Activation réussie via KMS4k.");
        }
    }
}


// LibTSforge/Activators/ZeroCID.cs
espace de noms LibTSforge.Activateurs
{
    en utilisant le système ;
    utilisation de System.IO ;
    utilisation de System.Linq ;
    utilisation de la cryptographie ;
    utilisation de PhysicalStore ;
    utilisation de SPP ;

    classe statique publique ZeroCID
    {
        privée statique void Dépôt(Guid actId, chaîne instId)
        {
            uint status = SLApi.DepositConfirmationID(actId, instId, Constants.ZeroCID);
            Logger.WriteLine(string.Format("Dépôt du faux statut CID {0:X}", status));

            si (statut != 0)
            {
                throw new InvalidOperationException("Échec du dépôt du faux CID.");
            }
        }

        public static void Activate(PSVersion version, bool production, Guid actId)
        {
            Identifiant d'application Guid ;

            si (actId == Guid.Empty)
            {
                appId = SLApi.WINDOWS_APP_ID;
                actId = SLApi.GetDefaultActivationID(appId, false);

                si (actId == Guid.Empty)
                {
                    throw new NotSupportedException("Aucun ID d'activation applicable trouvé.");
                }
            }
            autre
            {
                appId = SLApi.GetAppId(actId);
            }

            si (!SLApi.IsPhoneActivatable(actId))
            {
                throw new NotSupportedException("La licence téléphonique n'est pas disponible pour ce produit.");
            }

            chaîne instId = SLApi.GetInstallationID(actId);
            Guid pkeyId = SLApi.GetInstalledPkeyID(actId);

            si (version == PSVersion.Vista || version == PSVersion.Win7)
            {
                Dépôt(actId, instId);
            }

            SPPUtils.KillSPP(version);

            Logger.WriteLine("Écriture des données TrustedStore...");

            en utilisant (IPhysicalStore store = SPPUtils.GetStore(version, production))
            {
                byte[] hwidBlock = Constants.UniversalHWIDBlock;

                Logger.WriteLine("ID d'activation : " + actId);
                Logger.WriteLine("ID d'installation : " + instId);
                Logger.WriteLine("ID de clé de produit : " + pkeyId);

                byte[] iidHash;

                si (version == PSVersion.Vista)
                {
                    iidHash = CryptoUtils.SHA256Hash(Utils.EncodeString(instId)).Take(0x10).ToArray();
                }
                sinon si (version == PSVersion.Win7)
                {
                    iidHash = CryptoUtils.SHA256Hash(Utils.EncodeString(instId));
                }
                autre
                {
                    iidHash = CryptoUtils.SHA256Hash(Utils.EncodeString(instId + '\0' + Constants.ZeroCID));
                }

                chaîne clé = chaîne.Format("SPPSVC\\{0}\\{1}", appId, actId);
                PSBlock keyBlock = store.GetBlock(key, pkeyId.ToString());

                si (keyBlock == null)
                {
                    throw new InvalidDataException("Échec de la récupération des données de clé de produit pour l'ID d'activation " + actId + ".");
                }

                VariableBag pkb = new VariableBag(keyBlock.Data, version);

                octet[] pkeyData;

                si (version == PSVersion.Vista)
                {
                    pkeyData = pkb.GetBlock("PKeyBasicInfo").Value;
                    chaîne uniqueId = Utils.DecodeString(pkeyData.Skip(0x120).Take(0x80).ToArray());
                    chaîne extPid = Utils.DecodeString(pkeyData.Skip(0x1A0).Take(0x80).ToArray());

                    groupe uint ;
                    uint.TryParse(extPid.Split('-')[1], groupe de sortie);

                    si (groupe == 0)
                    {
                        throw new FormatException("Le PID étendu a un format invalide.");
                    }

                    ulong shortauth;

                    essayer
                    {
                        shortauth = BitConverter.ToUInt64(Convert.FromBase64String(uniqueId.Split('&')[1]), 0);
                    }
                    attraper
                    {
                        throw new FormatException("L'identifiant unique de la clé a un format invalide.");
                    }

                    shortauth |= (ulong)groupe << 41 ;
                    pkeyData = BitConverter.GetBytes(shortauth);
                }
                sinon si (version == PSVersion.Win7)
                {
                    pkeyData = pkb.GetBlock("SppPkeyShortAuthenticator").Value;
                }
                autre
                {
                    pkeyData = pkb.GetBlock("SppPkeyPhoneActivationData").Value;
                }

                pkb.SupprimerBloc("SppPkeyVirtual");
                magasin.SetBlock(clé, pkeyId.ToString(), pkb.Serialize());

                BinaryWriter writer = new BinaryWriter(new MemoryStream());
                écrivain.Écrire(iidHash.Longueur);
                écrivain.Écrire(iidHash);
                écrivain.Écrire(hwidBlock.Longueur);
                écrivain.Écrire(hwidBlock);
                byte[] tsHwidData = writer.GetBytes();

                écrivain = nouveau BinaryWriter(new MemoryStream());
                écrivain.Écrire(iidHash.Longueur);
                écrivain.Écrire(iidHash);
                écrivain.Écrire(pkeyData.Longueur);
                écrivain.Écrire(pkeyData);
                byte[] tsPkeyInfoData = writer.GetBytes();

                chaîne phoneVersion = version == PSVersion.Vista ? "6,0" : "7,0" ;
                Guid indexSlid = version == PSVersion.Vista ? actId : pkeyId;
                chaîne hwidBlockName = chaîne.Format("msft:Windows/{0}/Phone/Cached/HwidBlock/{1}", phoneVersion, indexSlid);
                chaîne pkeyInfoName = chaîne.Format("msft:Windows/{0}/Phone/Cached/PKeyInfo/{1}", phoneVersion, indexSlid);

                magasin.SupprimerBloc(clé, hwidBlockName);
                magasin.SupprimerBloc(clé, pkeyInfoName);

                magasin.AjouterBlocs(nouveau[] {
                    nouveau PSBlock
                    {
                        Type = BlockType.NAMED,
                        Drapeaux = 0,
                        CléAsStr = clé,
                        ValeurAsStr = hwidBlockName,
                        Données = tsHwidData
                    },
                    nouveau PSBlock
                    {
                        Type = BlockType.NAMED,
                        Drapeaux = 0,
                        CléAsStr = clé,
                        ValeurAsStr = pkeyInfoName,
                        Données = tsPkeyInfoData
                    }
                });
            }

            si (version != PSVersion.Vista && version != PSVersion.Win7)
            {
                Dépôt(actId, instId);
            }

            SPPUtils.RestartSPP(version);
            SLApi.FireStateChangedEvent(appId);
            Logger.WriteLine("Activation réussie à l'aide de ZeroCID.");
        }
    }
}


// LibTSforge/TokenStore/Common.cs
espace de noms LibTSforge.TokenStore
{
    utilisation de System.Collections.Generic ;
    utilisation de System.IO ;

    classe publique TokenEntry
    {
        public string Nom;
        public string Extension;
        données publiques byte[];
        public bool Peuplé;
    }

    classe publique TokenMeta
    {
        public string Nom;
        public readonly Dictionary<string, string> Data = new Dictionary<string, string>();

        public byte[] Serialize()
        {
            BinaryWriter writer = new BinaryWriter(new MemoryStream());
            écrivain.Écrire(1);
            byte[] nomBytes = Utils.EncodeString(Nom);
            écrivain.Écrire(nomOctets.Longueur);
            écrivain.Écrire(nomBytes);

            pour chaque (KeyValuePair<string, string> kv dans Data)
            {
                byte[] keyBytes = Utils.EncodeString(kv.Key);
                byte[] valueBytes = Utils.EncodeString(kv.Value);
                écrivain.Écrire(keyBytes.Longueur);
                écrivain.Écrire(valeurOctets.Longueur);
                écrivain.Écrire(keyBytes);
                écrivain.Écrire(valeurOctets);
            }

            retourner writer.GetBytes();
        }

        privée void Désérialiser(byte[] données)
        {
            BinaryReader lecteur = nouveau BinaryReader(nouveau MemoryStream(données));
            lecteur.ReadInt32();
            int nameLen = lecteur.ReadInt32();
            Nom = lecteur.ReadNullTerminéString(nomLen);

            tant que (reader.BaseStream.Position < data.Length - 0x8)
            {
                int keyLen = lecteur.ReadInt32();
                int valueLen = lecteur.ReadInt32();
                chaîne clé = lecteur.ReadNullTerminéString(cléLen);
                valeur de chaîne = lecteur.ReadNullTerminéString(longueur de la valeur);
                Données[clé] = valeur;
            }
        }

        public TokenMeta(byte[] données)
        {
            Désérialiser(données);
        }

        public TokenMeta()
        {

        }
    }
}


// LibTSforge/TokenStore/ITokenStore.cs
espace de noms LibTSforge.TokenStore
{
    en utilisant le système ;

    interface publique ITokenStore : IDisposable
    {
        void Désérialiser();
        void Serialize();
        void AddEntry(TokenEntry entrée);
        void AddEntries(TokenEntry[] entrées);
        void SupprimerEntrée(chaîne nom, chaîne ext);
        void SupprimerEntréeDépop(chaîne nom, chaîne ext);
        TokenEntry GetEntry(string name, string ext);
        TokenMeta GetMetaEntry(chaîne nom);
        void SetEntry(string nom, string ext, byte[] données);
    }
}


// LibTSforge/TokenStore/TokenStoreModern.cs
espace de noms LibTSforge.TokenStore
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;
    utilisation de System.IO ;
    utilisation de System.Linq ;
    utilisation de la cryptographie ;

    classe publique TokenStoreModern : ITokenStore
    {
        private static readonly uint VERSION = 3;
        private static readonly int ENTRY_SIZE = 0x9E;
        private static readonly int BLOCK_SIZE = 0x4020;
        private static readonly int ENTRIES_PER_BLOCK = BLOCK_SIZE / ENTRY_SIZE;
        private static readonly int BLOCK_PAD_SIZE = 0x66;

        private static readonly byte[] CONTS_HEADER = Enumerable.Repeat((byte)0x55, 0x20).ToArray();
        private static readonly byte[] CONTS_FOOTER = Enumerable.Repeat((byte)0xAA, 0x20).ToArray();

        privée List<TokenEntry> Entrées = nouvelle List<TokenEntry>();
        Fichier de jetons de flux de fichiers privé en lecture seule ;

        public void Désérialiser()
        {
            si (TokensFile.Length < BLOCK_SIZE) retourner;

            TokensFile.Seek(0x24, SeekOrigin.Begin);
            uint nextBlock;

            BinaryReader lecteur = nouveau BinaryReader(TokensFile);
            faire
            {
                lecteur.ReadUInt32();
                bloc suivant = lecteur.ReadUInt32();

                pour (int i = 0; i < ENTRIES_PER_BLOCK; i++)
                {
                    uint curOffset = lecteur.ReadUInt32();
                    booléen peuplé = lecteur.ReadUInt32() == 1;
                    uint contentOffset = lecteur.ReadUInt32();
                    uint contentLength = lecteur.ReadUInt32();
                    uint allocLength = lecteur.ReadUInt32();
                    byte[] contentData = { };

                    si (peuplé)
                    {
                        lecteur.BaseStream.Seek(contentOffset + 0x20, SeekOrigin.Begin);
                        uint dataLength = reader.ReadUInt32();

                        si (dataLength != contentLength)
                        {
                            throw new FormatException("La longueur des données dans le contenu des jetons est incohérente avec l'entrée.");
                        }

                        lecteur.ReadBytes(0x20);
                        contentData = lecteur.ReadBytes((int)contentLength);
                    }

                    lecteur.BaseStream.Seek(curOffset + 0x14, SeekOrigin.Begin);

                    Entrées.Ajouter(nouvelle entréeToken)
                    {
                        Nom = lecteur.ReadNullTerminéString(0x82),
                        Extension = lecteur.ReadNullTerminéString(0x8),
                        Données = contentData,
                        Peuplé = peuplé
                    });
                }

                lecteur.BaseStream.Seek(nextBlock, SeekOrigin.Begin);
            } tant que (nextBlock != 0);
        }

        public void Serialize()
        {
            MemoryStream tokens = new MemoryStream();

            en utilisant (BinaryWriter writer = new BinaryWriter(tokens))
            {
                écrivain.Écrire(VERSION);
                écrivain.Écrire(CONTS_HEADER);

                int curBlockOffset = (int)writer.BaseStream.Position;
                int curEntryOffset = curBlockOffset + 0x8;
                int curContsOffset = curBlockOffset + BLOCK_SIZE;

                pour (int eIndex = 0; eIndex < ((Entries.Count / ENTRIES_PER_BLOCK) + 1) * ENTRIES_PER_BLOCK; eIndex++)
                {
                    Entrée TokenEntry ;

                    si (eIndex < Entrées.Nombre)
                    {
                        entrée = Entrées[eIndex];
                    }
                    autre
                    {
                        entrée = nouvelle entrée de jeton
                        {
                            Nom = "",
                            Extension = "",
                            Peuplé = faux,
                            Données = nouveau tableau d'octets { }
                        };
                    }

                    écrivain.BaseStream.Seek(curBlockOffset, SeekOrigin.Begin);
                    écrivain.Écrire(décalageBlocCurrent);
                    écrivain.Écrire(0);

                    écrivain.BaseStream.Seek(curEntryOffset, SeekOrigin.Begin);
                    écrivain.Écrire(décalageEntréeActuelle);
                    écrivain.Écrire(entrée.Populée ? 1 : 0);
                    écrivain.Écrire(entrée.Populée ? décalageContentsActuel : 0);
                    écrivain.Écrire(entrée.Populée ? entrée.Données.Longueur : -1);
                    écrivain.Écrire(entrée.Populée ? entrée.Données.Longueur : -1);
                    écrivain.WriteFixedString16(entrée.Nom, 0x82);
                    écrivain.WriteFixedString16(entrée.Extension, 0x8);
                    curEntryOffset = (int)writer.BaseStream.Position;

                    si (entrée.Populée)
                    {
                        écrivain.BaseStream.Seek(curContsOffset, SeekOrigin.Begin);
                        écrivain.Écrire(CONTS_HEADER);
                        écrivain.Écrire(entrée.Données.Longueur);
                        écrivain.Écrire(CryptoUtils.SHA256Hash(entrée.Données));
                        écrivain.Écrire(entrée.Données);
                        écrivain.Écrire(CONTS_FOOTER);
                        curContsOffset = (int)writer.BaseStream.Position;
                    }

                    si ((eIndex + 1) % ENTRIES_PER_BLOCK == 0 && eIndex != 0)
                    {
                        si (eIndex < Entrées.Nombre)
                        {
                            écrivain.FluxDeBase.Rechercher(décalageBlocActuel + 0x4, OrigineRechercher.Début);
                            écrivain.Écrire(curContsOffset);
                        }

                        écrivain.BaseStream.Seek(curEntryOffset, SeekOrigin.Begin);
                        écrivain.WritePadding(BLOCK_PAD_SIZE);

                        écrivain.BaseStream.Seek(curBlockOffset, SeekOrigin.Begin);
                        byte[] blockData = new byte[BLOCK_SIZE - 0x20];

                        tokens.Read(blockData, 0, BLOCK_SIZE - 0x20);
                        byte[] blockHash = CryptoUtils.SHA256Hash(blockData);

                        écrivain.BaseStream.Seek(curBlockOffset + BLOCK_SIZE - 0x20, SeekOrigin.Begin);
                        écrivain.Écrire(blockHash);

                        curBlockOffset = curContsOffset;
                        curEntryOffset = curBlockOffset + 0x8 ;
                        curContsOffset = curBlockOffset + BLOCK_SIZE ;
                    }
                }

                jetons.SetLength(curBlockOffset);
            }

            byte[] tokensData = tokens.ToArray();
            byte[] tokensHash = CryptoUtils.SHA256Hash(tokensData.Take(0x4).Concat(tokensData.Skip(0x24)).ToArray());

            jetons = nouveau MemoryStream(donnéesjetons);

            BinaryWriter tokWriter = new BinaryWriter(TokensFile);
            en utilisant (BinaryReader lecteur = nouveau BinaryReader(tokens))
            {
                TokensFile.Seek(0, SeekOrigin.Begin);
                TokensFile.SetLength(tokens.Length);
                tokWriter.Write(reader.ReadBytes(0x4));
                lecteur.ReadBytes(0x20);
                tokWriter.Write(tokensHash);
                tokWriter.Write(reader.ReadBytes((int)reader.BaseStream.Length - 0x4));
            }
        }

        public void AddEntry(TokenEntry entrée)
        {
            Entrées.Ajouter(entrée);
        }

        public void AddEntries(TokenEntry[] entries)
        {
            Entrées.AddRange(entrées);
        }

        public void SupprimerEntrée(string nom, string ext)
        {
            pour chaque (TokenEntry entrée dans Entrées)
            {
                si (entry.Name == name && entry.Extension == ext)
                {
                    Entrées.Supprimer(entrée);
                    retour;
                }
            }
        }

        public void SupprimerEntréeDépop(chaîne nom, chaîne ext)
        {
            List<TokenEntry> delEntries = new List<TokenEntry>();
            pour chaque (TokenEntry entrée dans Entrées)
            {
                si (entry.Name == name && entry.Extension == ext && !entry.Populated)
                {
                    delEntries.Ajouter(entrée);
                }
            }

            Entrées = Entrées.Except(delEntries).ToList();
        }

        public TokenEntry GetEntry(string name, string ext)
        {
            pour chaque (TokenEntry entrée dans Entrées)
            {
                si (entry.Name == name && entry.Extension == ext)
                {
                    si (!entrée.Populée) continuer ;
                    retour de l'entrée ;
                }
            }

            renvoyer null ;
        }

        public TokenMeta GetMetaEntry(string nom)
        {
            SupprimerEntréeDépop(nom, "xml");
            TokenEntry entrée = GetEntry(nom, "xml");
            Méta TokenMeta ;

            si (entrée == nulle)
            {
                méta = nouveau TokenMeta
                {
                    Nom = nom
                };
            }
            autre
            {
                méta = nouveau TokenMeta(entrée.Données);
            }

            renvoyer les métadonnées ;
        }

        public void SetEntry(string name, string ext, byte[] data)
        {
            pour (int i = 0; i < Entrées.Count; i++)
            {
                TokenEntry entrée = Entrées[i];

                si (entry.Name == name && entry.Extension == ext && entry.Populated)
                {
                    entrée.Données = données;
                    Entrées[i] = entrée;
                    retour;
                }
            }

            Entrées.Ajouter(nouvelle entréeToken)
            {
                Peuplé = vrai,
                Nom = nom,
                Extension = ext,
                Données = données
            });
        }

        public TokenStoreModern(string tokensPath)
        {
            FichierTokens = Fichier.Ouvrir(cheminTokens, ModeFichier.OuvrirOuCréer, AccèsFichier.LectureÉcriture, PartageFichier.Aucun);
            Désérialiser();
        }

        public void Dispose()
        {
            Sérialiser();
            TokensFile.Close();
        }
    }
}


// LibTSforge/PhysicalStore/Common.cs
espace de noms LibTSforge.PhysicalStore
{
    utilisation de System.Runtime.InteropServices ;

    énumération publique BlockType : uint
    {
        AUCUN,
        NOMMÉ,
        ATTRIBUT,
        MINUTEUR
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    structure publique Timer
    {
        public ulong Inconnu;
        public ulong Time1;
        public ulong Time2;
        Expiration publique ulong;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    structure publique VistaTimer
    {
        public ulong Temps;
        Expiration publique ulong;
    }
}


// LibTSforge/PhysicalStore/IPhysicalStore.cs
espace de noms LibTSforge.PhysicalStore
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;

    classe publique PSBlock
    {
        Type de bloc public ;
        drapeaux publics uint;
        public uint Inconnu = 0;
        public byte[] Clé;
        chaîne publique KeyAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Key);
            }
            ensemble
            {
                Clé = Utils.EncodeString(valeur);
            }
        }
        public byte[] Valeur;
        public string ValueAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Valeur);
            }
            ensemble
            {
                Valeur = Utils.EncodeString(valeur);
            }
        }
        public uint ValueAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Valeur, 0);
            }
            ensemble
            {
                Valeur = BitConverter.GetBytes(valeur);
            }
        }
        données publiques byte[];
        public string DataAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Données);
            }
            ensemble
            {
                Données = Utils.EncodeString(valeur);
            }
        }
        public uint DataAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Data, 0);
            }
            ensemble
            {
                Données = BitConverter.GetBytes(valeur);
            }
        }
    }

    interface publique IPhysicalStore : IDisposable
    {
        PSBlock GetBlock(chaîne clé, chaîne valeur);
        PSBlock GetBlock(chaîne clé, entier non signé valeur);
        void AjouterBloc(PSBlock bloc);
        void AjouterBlocs(IEnumerable<PSBlock> blocs);
        void SetBlock(string clé, string valeur, byte[] données);
        void SetBlock(chaîne clé, chaîne valeur, chaîne données);
        void SetBlock(chaîne clé, chaîne valeur, entier non signé données);
        void SetBlock(string clé, uint valeur, byte[] données);
        void SetBlock(chaîne clé, entier non signé valeur, chaîne données);
        void SetBlock(string key, uint value, uint data);
        void SupprimerBloc(chaîne clé, chaîne valeur);
        void SupprimerBloc(chaîne clé, entier non signé valeur);
        byte[] Sérialiser();
        void Deserialize (données octet []);
        byte[] LireBrut();
        void WriteRaw(byte[] données);
        IEnumerable<PSBlock> FindBlocks(string valueSearch);
        IEnumerable<PSBlock> FindBlocks(uint valueSearch);
    }
}


// LibTSforge/PhysicalStore/PhysicalStoreModern.cs
espace de noms LibTSforge.PhysicalStore
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;
    utilisation de System.IO ;
    utilisation de la cryptographie ;

    classe publique ModernBlock
    {
        Type de bloc public ;
        drapeaux publics uint;
        public uint Inconnu;
        public byte[] Valeur;
        public string ValueAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Valeur);
            }
            ensemble
            {
                Valeur = Utils.EncodeString(valeur);
            }
        }
        public uint ValueAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Valeur, 0);
            }
            ensemble
            {
                Valeur = BitConverter.GetBytes(valeur);
            }
        }
        données publiques byte[];
        public string DataAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Données);
            }
            ensemble
            {
                Données = Utils.EncodeString(valeur);
            }
        }
        public uint DataAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Data, 0);
            }
            ensemble
            {
                Données = BitConverter.GetBytes(valeur);
            }
        }

        public void Encode(BinaryWriter writer)
        {
            écrivain.Écrire((uint)Type);
            écrivain.Écrire(Drapeaux);
            écrivain.Écrire((uint)Valeur.Longueur);
            écrivain.Écrire((uint)Données.Longueur);
            écrivain.Écrire(Inconnu);
            écrivain.Écrire(Valeur);
            écrivain.Écrire(Données);
        }

        public statique ModernBlock Décodage(BinaryReader lecteur)
        {
            uint type = lecteur.ReadUInt32();
            uint flags = reader.ReadUInt32();

            uint valueLen = reader.ReadUInt32();
            uint dataLen = reader.ReadUInt32();
            uint unk3 = lecteur.ReadUInt32();

            byte[] valeur = lecteur.ReadBytes((int)valeurLen);
            byte[] data = reader.ReadBytes((int)dataLen);

            renvoyer un nouveau ModernBlock
            {
                Type = (TypeBloc)type,
                Drapeaux = drapeaux,
                Inconnu = unk3,
                Valeur = valeur,
                Données = données,
            };
        }
    }

    classe publique scellée PhysicalStoreModern : IPhysicalStore
    {
        private byte[] PreHeaderBytes = { };
        privé en lecture seule Dictionary<string, List<ModernBlock>> Data = new Dictionary<string, List<ModernBlock>>();
        flux de fichiers privé en lecture seule TSFile;
        Version PSVersion privée en lecture seule ;
        privé en lecture seule booléen Production;

        public byte[] Serialize()
        {
            BinaryWriter writer = new BinaryWriter(new MemoryStream());
            écrivain.Écrire(Pré-En-têteOctets);
            écrivain.Écrire(Données.Clés.Nombre);

            pour chaque (chaîne clé dans Data.Keys)
            {
                Liste<ModernBlock> blocs = Données[clé];
                byte[] keyNameEnc = Utils.EncodeString(key);

                écrivain.Écrire(keyNameEnc.Longueur);
                écrivain.Écrire(keyNameEnc);
                écrivain.Écrire(blocs.Nombre);
                écrivain.Aligner(4);

                pour chaque bloc (ModernBlock dans blocks)
                {
                    bloc.Encoder(écrivain);
                    écrivain.Aligner(4);
                }
            }

            retourner writer.GetBytes();
        }

        public void Désérialiser (données octet [])
        {
            BinaryReader lecteur = nouveau BinaryReader(nouveau MemoryStream(données));
            Pré-en-têteOctets = lecteur.LireOctets(8);

            tant que (reader.BaseStream.Position < data.Length - 0x4)
            {
                uint numKeys = lecteur.ReadUInt32();

                pour (int i = 0; i < numKeys; i++)
                {
                    uint lenKeyName = lecteur.ReadUInt32();
                    chaîne keyName = Utils.DecodeString(reader.ReadBytes((int)lenKeyName)); uint numValues ​​= reader.ReadUInt32();

                    lecteur.Aligner(4);

                    Données[keyName] = nouvelle Liste<ModernBlock>();

                    pour (int j = 0; j < numValues; j++)
                    {
                        Données[keyName].Add(ModernBlock.Decode(reader));
                        lecteur.Aligner(4);
                    }
                }
            }
        }

        public void AjouterBloc(PSBlock bloc)
        {
            si (!Data.ContainsKey(block.KeyAsStr))
            {
                Données[block.KeyAsStr] = nouvelle List<ModernBlock>();
            }

            Data[block.KeyAsStr].Add(new ModernBlock
            {
                Type = bloc.Type,
                Drapeaux = bloc.Drapeaux,
                Inconnu = bloc.Inconnu,
                Valeur = bloc.Valeur,
                Données = bloc.Données
            });
        }

        public void AddBlocks(IEnumerable<PSBlock> blocks)
        {
            pour chaque (PSBlock bloc dans blocs)
            {
                AjouterBloc(bloc);
            }
        }

        public PSBlock GetBlock(chaîne clé, chaîne valeur)
        {
            Liste<ModernBlock> blocs = Données[clé];

            pour chaque bloc (ModernBlock dans blocks)
            {
                si (block.ValueAsStr == valeur)
                {
                    renvoyer un nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = Utils.EncodeString(clé),
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    };
                }
            }

            renvoyer null ;
        }

        public PSBlock GetBlock(string key, uint value)
        {
            Liste<ModernBlock> blocs = Données[clé];

            pour chaque bloc (ModernBlock dans blocks)
            {
                si (block.ValueAsInt == valeur)
                {
                    renvoyer un nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = Utils.EncodeString(clé),
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    };
                }
            }

            renvoyer null ;
        }

        public void SetBlock(string key, string value, byte[] data)
        {
            Liste<ModernBlock> blocs = Données[clé];

            pour (int i = 0; i < blocks.Count; i++)
            {
                Bloc Moderne bloc = blocs[i];

                si (block.ValueAsStr == valeur)
                {
                    bloc.Données = données;
                    blocs[i] = bloc;
                    casser;
                }
            }

            Données[clé] = blocs ;
        }

        public void SetBlock(string key, uint value, byte[] data)
        {
            Liste<ModernBlock> blocs = Données[clé];

            pour (int i = 0; i < blocks.Count; i++)
            {
                Bloc Moderne bloc = blocs[i];

                si (block.ValueAsInt == valeur)
                {
                    bloc.Données = données;
                    blocs[i] = bloc;
                    casser;
                }
            }

            Données[clé] = blocs ;
        }

        public void SetBlock(string clé, string valeur, string données)
        {
            DéfinirBloc(clé, valeur, Utils.EncodeString(données));
        }

        public void SetBlock(string key, string value, uint data)
        {
            DéfinirBloc(clé, valeur, BitConverter.GetBytes(données));
        }

        public void SetBlock(string key, uint value, string data)
        {
            DéfinirBloc(clé, valeur, Utils.EncodeString(données));
        }

        public void SetBlock(string key, uint value, uint data)
        {
            DéfinirBloc(clé, valeur, BitConverter.GetBytes(données));
        }

        public void SupprimerBloc(chaîne clé, chaîne valeur)
        {
            si (!Data.ContainsKey(key))
            {
                retour;
            }

            Liste<ModernBlock> blocs = Données[clé];

            pour chaque bloc (ModernBlock dans blocks)
            {
                si (block.ValueAsStr == valeur)
                {
                    blocs.Supprimer(bloc);
                    casser;
                }
            }

            Données[clé] = blocs ;
        }

        public void SupprimerBloc(string clé, uint valeur)
        {
            si (!Data.ContainsKey(key))
            {
                retour;
            }

            Liste<ModernBlock> blocs = Données[clé];

            pour chaque bloc (ModernBlock dans blocks)
            {
                si (block.ValueAsInt == valeur)
                {
                    blocs.Supprimer(bloc);
                    casser;
                }
            }

            Données[clé] = blocs ;
        }

        public PhysicalStoreModern(string tsPath, bool production, PSVersion version)
        {
            TSFile = File.Open(tsPath, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
            Désérialiser(PhysStoreCrypto.DecryptPhysicalStore(TSFile.ReadAllBytes(), production, version));
            TSFile.Seek(0, SeekOrigin.Begin);
            Version = version ;
            Production = production;
        }

        public void Dispose()
        {
            si (TSFile.CanWrite)
            {
                byte[] data = PhysStoreCrypto.EncryptPhysicalStore(Serialize(), Production, Version);
                TSFile.SetLength(data.LongLength);
                TSFile.Seek(0, SeekOrigin.Begin);
                TSFile.WriteAllBytes(données);
                TSFile.Fermer();
            }
        }

        public byte[] ReadRaw()
        {
            byte[] data = PhysStoreCrypto.DecryptPhysicalStore(TSFile.ReadAllBytes(), Production, Version);
            TSFile.Seek(0, SeekOrigin.Begin);
            renvoyer des données ;
        }

        public void WriteRaw(byte[] données)
        {
            byte[] encrData = PhysStoreCrypto.EncryptPhysicalStore(data, Production, Version);
            TSFile.SetLength(encrData.LongLength);
            TSFile.Seek(0, SeekOrigin.Begin);
            TSFile.WriteAllBytes(encrData);
            TSFile.Fermer();
        }

        public IEnumerable<PSBlock> FindBlocks(string valueSearch)
        {
            List<PSBlock> résultats = nouvelle List<PSBlock>();

            pour chaque (chaîne clé dans Data.Keys)
            {
                List<ModernBlock> valeurs = Data[clé];

                pour chaque (ModernBlock bloc dans valeurs)
                {
                    si (block.ValueAsStr.Contains(valueSearch))
                    {
                        résultats.Ajouter(nouveau PSBlock
                        {
                            Type = bloc.Type,
                            Drapeaux = bloc.Drapeaux,
                            CléAsStr = clé,
                            Valeur = bloc.Valeur,
                            Données = bloc.Données
                        });
                    }
                }
            }

            renvoyer les résultats ;
        }

        public IEnumerable<PSBlock> FindBlocks(uint valueSearch)
        {
            List<PSBlock> résultats = nouvelle List<PSBlock>();

            pour chaque (chaîne clé dans Data.Keys)
            {
                List<ModernBlock> valeurs = Data[clé];

                pour chaque (ModernBlock bloc dans valeurs)
                {
                    si (block.ValueAsInt == valueSearch)
                    {
                        résultats.Ajouter(nouveau PSBlock
                        {
                            Type = bloc.Type,
                            Drapeaux = bloc.Drapeaux,
                            CléAsStr = clé,
                            Valeur = bloc.Valeur,
                            Données = bloc.Données
                        });
                    }
                }
            }

            renvoyer les résultats ;
        }
    }
}


// LibTSforge/PhysicalStore/PhysicalStoreVista.cs
espace de noms LibTSforge.PhysicalStore
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;
    utilisation de System.IO ;
    utilisation de la cryptographie ;

    classe publique VistaBlock
    {
        Type de bloc public ;
        drapeaux publics uint;
        public byte[] Valeur;
        public string ValueAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Valeur);
            }
            ensemble
            {
                Valeur = Utils.EncodeString(valeur);
            }
        }
        public uint ValueAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Valeur, 0);
            }
            ensemble
            {
                Valeur = BitConverter.GetBytes(valeur);
            }
        }
        données publiques byte[];
        public string DataAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Données);
            }
            ensemble
            {
                Données = Utils.EncodeString(valeur);
            }
        }
        public uint DataAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Data, 0);
            }
            ensemble
            {
                Données = BitConverter.GetBytes(valeur);
            }
        }

        interne void Encode(BinaryWriter writer)
        {
            écrivain.Écrire((uint)Type);
            écrivain.Écrire(Drapeaux);
            écrivain.Écrire(Valeur.Longueur);
            écrivain.Écrire(Données.Longueur);
            écrivain.Écrire(Valeur);
            écrivain.Écrire(Données);
        }

        décodage VistaBlock statique interne (lecteur BinaryReader)
        {
            uint type = lecteur.ReadUInt32();
            uint flags = reader.ReadUInt32();

            int valueLen = lecteur.ReadInt32();
            int dataLen = lecteur.ReadInt32();

            byte[] valeur = lecteur.ReadBytes(valeurLen);
            byte[] data = reader.ReadBytes(dataLen);
            retour nouveau VistaBlock
            {
                Type = (TypeBloc)type,
                Drapeaux = drapeaux,
                Valeur = valeur,
                Données = données,
            };
        }
    }

    classe publique scellée PhysicalStoreVista : IPhysicalStore
    {
        private byte[] PreHeaderBytes = { };
        privée en lecture seule List<VistaBlock> Blocks = nouvelle List<VistaBlock>();
        flux de fichiers privé en lecture seule TSPrimary ;
        flux de fichiers privé en lecture seule TSSecondary ;
        privé en lecture seule booléen Production;

        public byte[] Serialize()
        {
            BinaryWriter writer = new BinaryWriter(new MemoryStream());
            écrivain.Écrire(Pré-En-têteOctets);

            pour chaque bloc VistaBlock dans Blocks
            {
                bloc.Encoder(écrivain);
                écrivain.Aligner(4);
            }

            retourner writer.GetBytes();
        }

        public void Désérialiser (données octet [])
        {
            int len ​​= data.Length;

            BinaryReader lecteur = nouveau BinaryReader(nouveau MemoryStream(données));
            Pré-en-têteOctets = lecteur.LireOctets(8);

            tant que (reader.BaseStream.Position < len - 0x14)
            {
                Blocks.Add(VistaBlock.Decode(reader));
                lecteur.Aligner(4);
            }
        }

        public void AjouterBloc(PSBlock bloc)
        {
            Blocks.Add(new VistaBlock
            {
                Type = bloc.Type,
                Drapeaux = bloc.Drapeaux,
                Valeur = bloc.Valeur,
                Données = bloc.Données
            });
        }

        public void AddBlocks(IEnumerable<PSBlock> blocks)
        {
            pour chaque (PSBlock bloc dans blocs)
            {
                AjouterBloc(bloc);
            }
        }

        public PSBlock GetBlock(chaîne clé, chaîne valeur)
        {
            pour chaque bloc VistaBlock dans Blocks
            {
                si (block.ValueAsStr == valeur)
                {
                    renvoyer un nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = nouvel octet[0],
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    };
                }
            }

            renvoyer null ;
        }

        public PSBlock GetBlock(string key, uint value)
        {
            pour chaque bloc VistaBlock dans Blocks
            {
                si (block.ValueAsInt == valeur)
                {
                    renvoyer un nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = nouvel octet[0],
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    };
                }
            }

            renvoyer null ;
        }

        public void SetBlock(string key, string value, byte[] data)
        {
            pour (int i = 0; i < Blocks.Count; i++)
            {
                VistaBlock bloc = Blocks[i];

                si (block.ValueAsStr == valeur)
                {
                    bloc.Données = données;
                    Blocs[i] = bloc ;
                    casser;
                }
            }
        }

        public void SetBlock(string key, uint value, byte[] data)
        {
            pour (int i = 0; i < Blocks.Count; i++)
            {
                VistaBlock bloc = Blocks[i];

                si (block.ValueAsInt == valeur)
                {
                    bloc.Données = données;
                    Blocs[i] = bloc ;
                    casser;
                }
            }
        }

        public void SetBlock(string clé, string valeur, string données)
        {
            DéfinirBloc(clé, valeur, Utils.EncodeString(données));
        }

        public void SetBlock(string key, string value, uint data)
        {
            DéfinirBloc(clé, valeur, BitConverter.GetBytes(données));
        }

        public void SetBlock(string key, uint value, string data)
        {
            DéfinirBloc(clé, valeur, Utils.EncodeString(données));
        }

        public void SetBlock(string key, uint value, uint data)
        {
            DéfinirBloc(clé, valeur, BitConverter.GetBytes(données));
        }

        public void SupprimerBloc(chaîne clé, chaîne valeur)
        {
            pour chaque bloc VistaBlock dans Blocks
            {
                si (block.ValueAsStr == valeur)
                {
                    Blocs.Supprimer(bloc);
                    retour;
                }
            }
        }

        public void SupprimerBloc(string clé, uint valeur)
        {
            pour chaque bloc VistaBlock dans Blocks
            {
                si (block.ValueAsInt == valeur)
                {
                    Blocs.Supprimer(bloc);
                    retour;
                }
            }
        }

        public PhysicalStoreVista(string primaryPath, bool production)
        {
            TSPrimary = File.Open(primaryPath, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
            TSSecondary = File.Open(primaryPath.Replace("-0.", "-1."), FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
            Production = production;

            Désérialiser(PhysStoreCrypto.DecryptPhysicalStore(TSPrimary.ReadAllBytes(), production, PSVersion.Vista));
            TSPrimary.Seek(0, SeekOrigin.Begin);
        }

        public void Dispose()
        {
            si (TSPrimary.CanWrite && TSEcondary.CanWrite)
            {
                byte[] data = PhysStoreCrypto.EncryptPhysicalStore(Serialize(), Production, PSVersion.Vista);

                TSPrimary.SetLength(data.LongLength);
                TSSecondary.SetLength(data.LongLength);

                TSPrimary.Seek(0, SeekOrigin.Begin);
                TSSecondary.Seek(0, SeekOrigin.Begin);

                TSPrimary.WriteAllBytes(données);
                TSSecondary.WriteAllBytes(données);

                TSPrimary.Fermer();
                TSSecondary.Fermer();
            }
        }

        public byte[] ReadRaw()
        {
            byte[] data = PhysStoreCrypto.DecryptPhysicalStore(TSPrimary.ReadAllBytes(), Production, PSVersion.Vista);
            TSPrimary.Seek(0, SeekOrigin.Begin);
            renvoyer des données ;
        }

        public void WriteRaw(byte[] données)
        {
            byte[] encrData = PhysStoreCrypto.EncryptPhysicalStore(data, Production, PSVersion.Vista);

            TSPrimary.SetLength(encrData.LongLength);
            TSSecondary.SetLength(encrData.LongLength);

            TSPrimary.Seek(0, SeekOrigin.Begin);
            TSSecondary.Seek(0, SeekOrigin.Begin);

            TSPrimary.WriteAllBytes(encrData);
            TSSecondary.WriteAllBytes(encrData);

            TSPrimary.Fermer();
            TSSecondary.Fermer();
        }

        public IEnumerable<PSBlock> FindBlocks(string valueSearch)
        {
            List<PSBlock> résultats = nouvelle List<PSBlock>();

            pour chaque bloc VistaBlock dans Blocks
            {
                si (block.ValueAsStr.Contains(valueSearch))
                {
                    résultats.Ajouter(nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = nouvel octet[0],
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    });
                }
            }

            renvoyer les résultats ;
        }

        public IEnumerable<PSBlock> FindBlocks(uint valueSearch)
        {
            List<PSBlock> résultats = nouvelle List<PSBlock>();

            pour chaque bloc VistaBlock dans Blocks
            {
                si (block.ValueAsInt == valueSearch)
                {
                    résultats.Ajouter(nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = nouvel octet[0],
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    });
                }
            }

            renvoyer les résultats ;
        }
    }
}


// LibTSforge/PhysicalStore/PhysicalStoreWin7.cs
espace de noms LibTSforge.PhysicalStore
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;
    utilisation de System.IO ;
    utilisation de la cryptographie ;

    classe publique Win7Block
    {
        Type de bloc public ;
        drapeaux publics uint;
        public byte[] Clé;
        chaîne publique KeyAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Key);
            }
            ensemble
            {
                Clé = Utils.EncodeString(valeur);
            }
        }
        public byte[] Valeur;
        public string ValueAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Valeur);
            }
            ensemble
            {
                Valeur = Utils.EncodeString(valeur);
            }
        }
        public uint ValueAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Valeur, 0);
            }
            ensemble
            {
                Valeur = BitConverter.GetBytes(valeur);
            }
        }
        données publiques byte[];
        public string DataAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Données);
            }
            ensemble
            {
                Données = Utils.EncodeString(valeur);
            }
        }
        public uint DataAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Data, 0);
            }
            ensemble
            {
                Données = BitConverter.GetBytes(valeur);
            }
        }

        interne void Encode(BinaryWriter writer)
        {
            écrivain.Écrire((uint)Type);
            écrivain.Écrire(Drapeaux);
            écrivain.Écrire(Clé.Longueur);
            écrivain.Écrire(Valeur.Longueur);
            écrivain.Écrire(Données.Longueur);
            écrivain.Écrire(Clé);
            écrivain.Écrire(Valeur);
            écrivain.Écrire(Données);
        }

        Décodage statique interne Win7Block (lecteur BinaryReader)
        {
            uint type = lecteur.ReadUInt32();
            uint flags = reader.ReadUInt32();

            int keyLen = lecteur.ReadInt32();
            int valueLen = lecteur.ReadInt32();
            int dataLen = lecteur.ReadInt32();

            byte[] clé = lecteur.ReadBytes(cléLen);
            byte[] valeur = lecteur.ReadBytes(valeurLen);
            byte[] data = reader.ReadBytes(dataLen);
            retour nouveau Win7Block
            {
                Type = (TypeBloc)type,
                Drapeaux = drapeaux,
                Clé = clé,
                Valeur = valeur,
                Données = données,
            };
        }
    }

    classe publique scellée PhysicalStoreWin7 : IPhysicalStore
    {
        private byte[] PreHeaderBytes = { };
        privée en lecture seule List<Win7Block> Blocks = nouvelle List<Win7Block>();
        flux de fichiers privé en lecture seule TSPrimary ;
        flux de fichiers privé en lecture seule TSSecondary ;
        privé en lecture seule booléen Production;

        public byte[] Serialize()
        {
            BinaryWriter writer = new BinaryWriter(new MemoryStream());
            écrivain.Écrire(Pré-En-têteOctets);

            pour chaque (bloc Win7Block dans Blocks)
            {
                bloc.Encoder(écrivain);
                écrivain.Aligner(4);
            }

            retourner writer.GetBytes();
        }

        public void Désérialiser (données octet [])
        {
            int len ​​= data.Length;

            BinaryReader lecteur = nouveau BinaryReader(nouveau MemoryStream(données));
            Pré-en-têteOctets = lecteur.LireOctets(8);

            tant que (reader.BaseStream.Position < len - 0x14)
            {
                Blocks.Add(Win7Block.Decode(reader));
                lecteur.Aligner(4);
            }
        }

        public void AjouterBloc(PSBlock bloc)
        {
            Blocks.Add(nouveau Win7Block
            {
                Type = bloc.Type,
                Drapeaux = bloc.Drapeaux,
                Clé = bloc.Clé,
                Valeur = bloc.Valeur,
                Données = bloc.Données
            });
        }

        public void AddBlocks(IEnumerable<PSBlock> blocks)
        {
            pour chaque (PSBlock bloc dans blocs)
            {
                AjouterBloc(bloc);
            }
        }

        public PSBlock GetBlock(chaîne clé, chaîne valeur)
        {
            pour chaque (bloc Win7Block dans Blocks)
            {
                si (block.KeyAsStr == clé && block.ValueAsStr == valeur)
                {
                    renvoyer un nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = bloc.Clé,
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    };
                }
            }

            renvoyer null ;
        }

        public PSBlock GetBlock(string key, uint value)
        {
            pour chaque (bloc Win7Block dans Blocks)
            {
                si (block.KeyAsStr == clé && block.ValueAsInt == valeur)
                {
                    renvoyer un nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = bloc.Clé,
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    };
                }
            }

            renvoyer null ;
        }

        public void SetBlock(string key, string value, byte[] data)
        {
            pour (int i = 0; i < Blocks.Count; i++)
            {
                Win7Block bloc = Blocs[i] ;

                si (block.KeyAsStr == clé && block.ValueAsStr == valeur)
                {
                    bloc.Données = données;
                    Blocs[i] = bloc ;
                    casser;
                }
            }
        }

        public void SetBlock(string key, uint value, byte[] data)
        {
            pour (int i = 0; i < Blocks.Count; i++)
            {
                Win7Block bloc = Blocs[i] ;

                si (block.KeyAsStr == clé && block.ValueAsInt == valeur)
                {
                    bloc.Données = données;
                    Blocs[i] = bloc ;
                    casser;
                }
            }
        }

        public void SetBlock(string clé, string valeur, string données)
        {
            DéfinirBloc(clé, valeur, Utils.EncodeString(données));
        }

        public void SetBlock(string key, string value, uint data)
        {
            DéfinirBloc(clé, valeur, BitConverter.GetBytes(données));
        }

        public void SetBlock(string key, uint value, string data)
        {
            DéfinirBloc(clé, valeur, Utils.EncodeString(données));
        }

        public void SetBlock(string key, uint value, uint data)
        {
            DéfinirBloc(clé, valeur, BitConverter.GetBytes(données));
        }

        public void SupprimerBloc(chaîne clé, chaîne valeur)
        {
            pour chaque (bloc Win7Block dans Blocks)
            {
                si (block.KeyAsStr == clé && block.ValueAsStr == valeur)
                {
                    Blocs.Supprimer(bloc);
                    retour;
                }
            }
        }

        public void SupprimerBloc(string clé, uint valeur)
        {
            pour chaque (bloc Win7Block dans Blocks)
            {
                si (block.KeyAsStr == clé && block.ValueAsInt == valeur)
                {
                    Blocs.Supprimer(bloc);
                    retour;
                }
            }
        }

        public PhysicalStoreWin7(chaîne cheminprimaire, booléen production)
        {
            TSPrimary = File.Open(primaryPath, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
            TSSecondary = File.Open(primaryPath.Replace("-0.", "-1."), FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
            Production = production;

            Désérialiser(PhysStoreCrypto.DecryptPhysicalStore(TSPrimary.ReadAllBytes(), production, PSVersion.Win7));
            TSPrimary.Seek(0, SeekOrigin.Begin);
        }

        public void Dispose()
        {
            si (TSPrimary.CanWrite && TSEcondary.CanWrite)
            {
                byte[] data = PhysStoreCrypto.EncryptPhysicalStore(Serialize(), Production, PSVersion.Win7);

                TSPrimary.SetLength(data.LongLength);
                TSSecondary.SetLength(data.LongLength);

                TSPrimary.Seek(0, SeekOrigin.Begin);
                TSSecondary.Seek(0, SeekOrigin.Begin);

                TSPrimary.WriteAllBytes(données);
                TSSecondary.WriteAllBytes(données);

                TSPrimary.Fermer();
                TSSecondary.Fermer();
            }
        }

        public byte[] ReadRaw()
        {
            byte[] data = PhysStoreCrypto.DecryptPhysicalStore(TSPrimary.ReadAllBytes(), Production, PSVersion.Win7);
            TSPrimary.Seek(0, SeekOrigin.Begin);
            renvoyer des données ;
        }

        public void WriteRaw(byte[] données)
        {
            byte[] encrData = PhysStoreCrypto.EncryptPhysicalStore(data, Production, PSVersion.Win7);

            TSPrimary.SetLength(encrData.LongLength);
            TSSecondary.SetLength(encrData.LongLength);

            TSPrimary.Seek(0, SeekOrigin.Begin);
            TSSecondary.Seek(0, SeekOrigin.Begin);

            TSPrimary.WriteAllBytes(encrData);
            TSSecondary.WriteAllBytes(encrData);

            TSPrimary.Fermer();
            TSSecondary.Fermer();
        }

        public IEnumerable<PSBlock> FindBlocks(string valueSearch)
        {
            List<PSBlock> résultats = nouvelle List<PSBlock>();

            pour chaque (bloc Win7Block dans Blocks)
            {
                si (block.ValueAsStr.Contains(valueSearch))
                {
                    résultats.Ajouter(nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = bloc.Clé,
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    });
                }
            }

            renvoyer les résultats ;
        }

        public IEnumerable<PSBlock> FindBlocks(uint valueSearch)
        {
            List<PSBlock> résultats = nouvelle List<PSBlock>();

            pour chaque (bloc Win7Block dans Blocks)
            {
                si (block.ValueAsInt == valueSearch)
                {
                    résultats.Ajouter(nouveau PSBlock
                    {
                        Type = bloc.Type,
                        Drapeaux = bloc.Drapeaux,
                        Clé = bloc.Clé,
                        Valeur = bloc.Valeur,
                        Données = bloc.Données
                    });
                }
            }

            renvoyer les résultats ;
        }
    }
}


// LibTSforge/PhysicalStore/VariableBag.cs
espace de noms LibTSforge.PhysicalStore
{
    en utilisant le système ;
    utilisation de System.Collections.Generic ;
    utilisation de System.IO ;

    énumération publique CRCBlockType : uint
    {
        UINT = 1 << 0,
        CHAÎNE = 1 << 1,
        BINAIRE = 1 << 2
    }

    classe abstraite publique CRCBlock
    {
        public CRCBlockType DataType;
        public byte[] Clé;
        chaîne publique KeyAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Key);
            }
            ensemble
            {
                Clé = Utils.EncodeString(valeur);
            }
        }
        public byte[] Valeur;
        public string ValueAsStr
        {
            obtenir
            {
                renvoie Utils.DecodeString(Valeur);
            }
            ensemble
            {
                Valeur = Utils.EncodeString(valeur);
            }
        }
        public uint ValueAsInt
        {
            obtenir
            {
                renvoie BitConverter.ToUInt32(Valeur, 0);
            }
            ensemble
            {
                Valeur = BitConverter.GetBytes(valeur);
            }
        }

        public abstrait void Encode(BinaryWriter writer);
        public abstrait void Décoder(BinaryReader lecteur);
        public abstract uint CRC();
    }

    classe publique CRCBlockVista : CRCBlock
    {
        public override void Encode(BinaryWriter writer)
        {
            uint crc = CRC();
            écrivain.Écrire((uint)DataType);
            écrivain.Écrire(0);
            écrivain.Écrire(Clé.Longueur);
            écrivain.Écrire(Valeur.Longueur);
            écrivain.Écrire(crc);

            écrivain.Écrire(Clé);

            écrivain.Écrire(Valeur);
        }

        public override void Decode(BinaryReader reader)
        {
            uint type = lecteur.ReadUInt32();
            lecteur.ReadUInt32();
            uint lenName = lecteur.ReadUInt32();
            uint lenVal = lecteur.ReadUInt32();
            uint crc = lecteur.ReadUInt32();

            byte[] clé = lecteur.ReadBytes((int)lenName);
            byte[] valeur = lecteur.ReadBytes((int)lenVal);

            Type de données = (CRCBlockType)type ;
            Clé = clé;
            Valeur = valeur;

            si (CRC() != crc)
            {
                throw new InvalidDataException("CRC invalide dans le sac de variables.");
            }
        }

        public surcharger uint CRC()
        {
            renvoie Utils.CRC32(Valeur);
        }
    }

    classe publique CRCBlockModern : CRCBlock
    {
        public override void Encode(BinaryWriter writer)
        {
            uint crc = CRC();
            écrivain.Écrire(crc);
            écrivain.Écrire((uint)DataType);
            écrivain.Écrire(Clé.Longueur);
            écrivain.Écrire(Valeur.Longueur);

            écrivain.Écrire(Clé);
            écrivain.Aligner(8);

            écrivain.Écrire(Valeur);
            écrivain.Aligner(8);
        }

        public override void Decode(BinaryReader reader)
        {
            uint crc = lecteur.ReadUInt32();
            uint type = lecteur.ReadUInt32();
            uint lenName = lecteur.ReadUInt32();
            uint lenVal = lecteur.ReadUInt32();

            byte[] clé = lecteur.ReadBytes((int)lenName);
            lecteur.Aligner(8);

            byte[] valeur = lecteur.ReadBytes((int)lenVal);
            lecteur.Aligner(8);

            Type de données = (CRCBlockType)type ;
            Clé = clé;
            Valeur = valeur;

            si (CRC() != crc)
            {
                throw new InvalidDataException("CRC invalide dans le sac de variables.");
            }
        }

        public surcharger uint CRC()
        {
            BinaryWriter wtemp = new BinaryWriter(new MemoryStream());
            wtemp.Write(0);
            wtemp.Write((uint)DataType);
            wtemp.Write(Key.Length);
            wtemp.Write(Valeur.Longueur);
            wtemp.Write(Key);
            wtemp.Write(Valeur);
            renvoie Utils.CRC32(wtemp.GetBytes());
        }
    }

    classe publique VariableBag
    {
        public List<CRCBlock> Blocks = new List<CRCBlock>();
        Version PSVersion privée en lecture seule ;

        privée void Désérialiser(byte[] données)
        {
            int len ​​= data.Length;

            BinaryReader lecteur = nouveau BinaryReader(nouveau MemoryStream(données));

            tant que (reader.BaseStream.Position < len - 0x10)
            {
                Bloc CRCBlock ;

                si (Version == PSVersion.Vista)
                {
                    bloc = nouveau CRCBlockVista();
                }
                autre
                {
                    bloc = nouveau CRCBlockModern();
                }

                bloc.Décoder(lecteur);
                Blocs.Ajouter(bloc);
            }
        }

        public byte[] Serialize()
        {
            BinaryWriter writer = new BinaryWriter(new MemoryStream());

            pour chaque (CRCBlock bloc dans Blocks)
            {
                si (Version == PSVersion.Vista)
                {
                    ((CRCBlockVista)block).Encode(writer);
                } autre
                {
                    ((CRCBlockModern)block).Encode(writer);
                }
            }

            retourner writer.GetBytes();
        }

        public CRCBlock GetBlock(chaîne clé)
        {
            pour chaque (CRCBlock bloc dans Blocks)
            {
                si (block.KeyAsStr == clé)
                {
                    bloc de retour ;
                }
            }

            renvoyer null ;
        }

        public void SetBlock(string clé, byte[] valeur)
        {
            pour (int i = 0; i < Blocks.Count; i++)
            {
                CRCBlock bloc = Blocs[i];

                si (block.KeyAsStr == clé)
                {
                    bloc.Valeur = valeur;
                    Blocs[i] = bloc ;
                    casser;
                }
            }
        }

        public void SupprimerBloc(chaîne clé)
        {
            pour chaque (CRCBlock bloc dans Blocks)
            {
                si (block.KeyAsStr == clé)
                {
                    Blocs.Supprimer(bloc);
                    retour;
                }
            }
        }

        public VariableBag(byte[] données, PSVersion version)
        {
            Version = version ;
            Désérialiser(données);
        }

        public VariableBag(PSVersion version)
        {
            Version = version ;
        }
    }
}
'@
$ErrorActionPreference = 'Arrêter'
$psMajorVer = (Get-Host).Version.Major
$build = [System.Environment]::OSVersion.Version.Build

$cp = [CodeDom.Compiler.CompilerParameters] [string[]]@("System.dll", "System.Core.dll", "System.ServiceProcess.dll", "System.Xml.dll", "System.Xml.Linq.dll")
Si ($psMajorVer -le 2) { $cp.CompilerOptions = "/define:POWERSHELL2 /unsafe" } sinon { $cp.CompilerOptions = "/unsafe" }
$lang = if ($psMajorVer -gt 2) { "CSharp" } else { "CSharpVersion3" }

$ctemp = "$env:SystemRoot\Temp\$([Guid]::NewGuid().Guid)\"
if (-Not (Test-Path -Path $ctemp)) { New-Item -Path $ctemp -ItemType Directory > $null }
$env:TMP = $ctemp
$env:TEMP = $ctemp

$cp.GenerateInMemory = $true
Ajouter-Type -Langue $lang -DéfinitionType $src -ParamètresCompilateur $cp

essayer {
    $cp.TempFiles.Dispose()
} attraper {
Les anciennes versions de .NET Framework ne disposent pas de cette méthode, mais elles ne créent pas non plus le dossier qu'elle supprime.
}
Supprimer-Élément -Chemin $ctemp

si ($env:_debug -eq '0') {
    [LibTSforge.Logger]::MasquerOutput = $true
}
[void][LibTSforge.Utils]::Wow64EnableWow64FsRedirection($false)
$ver = [LibTSforge.Utils]::DetectVersion()
$prod = [LibTSforge.SPP.SPPUtils]::DetectCurrentKey()
$tsactids = @($args)

fonction Get-WmiInfo {
    param ([string]$tsactid, [string]$property)
    
    $query = "SELECT ID, $property FROM SoftwareLicensingProduct WHERE ID='$tsactid'"
    $record = Get-WmiObject -Query $query
    si ($record) {
        renvoyer $record.$property
    }
}

fonction slGetSkuInfo($SkuId) {
    $t = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1).DefineDynamicModule(2, $False).DefineType(0)
    $t.DefinePInvokeMethod('SLOpen', 'slc.dll', 22, 1, [Int32], @([IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
    $t.DefinePInvokeMethod('SLClose', 'slc.dll', 22, 1, [IntPtr], @([IntPtr]), 1, 3).SetImplementationFlags(128)
    $t.DefinePInvokeMethod('SLGetProductSkuInformation', 'slc.dll', 22, 1, [Int32], @([IntPtr], [Guid].MakeByRefType(), [String], [UInt32].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
    $w = $t.CreateType()
    $hSLC = 0
    essayer {
        [void]$w::SLOpen([ref]$hSLC)
        $c = 0; $b = 0
        $r = $w::SLGetProductSkuInformation($hSLC, [ref][Guid]$SkuId, "msft:sl/EUL/PHONE/PUBLIC", [ref]$null, [ref]$c, [ref]$b)
        renvoyer ($r -eq 0)
    }
    enfin {
        [void]$w::SLClose($hSLC)
    }
}

si (-not $env:resetstuff) {
    pour chaque ($tsactid dans $tsactids) {
        essayer {
            $activated = $null
            $prodDes = Get-WmiInfo -tsactid $tsactid -property "Description"
            $prodName = Get-WmiInfo -tsactid $tsactid -property "Name"
            si ($prodName) {
                $nameParts = $prodName -split ',', 2
                $prodName = si ($nameParts.Count -gt 1) { ($nameParts[1].Trim() -split '[ ,]')[0] } sinon { $null }
            }
            si (-not $env:_vis -et -not $env:oldks) {
                [LibTSforge.Modifiers.GenPKeyInstall]::InstallGenPKey($ver, $prod, $tsactid)
            }
            si ($prodName correspond à 'Office' et $prodDes ne correspond pas à 'KMS' et n'est pas (slGetSkuInfo($tsactid))) {
                $licenseStatus = Get-WmiInfo -tsactid $tsactid -property "LicenseStatus"
                si ($licenseStatus -eq 1) {
                    Write-Host "[$prodName] est déjà activé de façon permanente." -ForegroundColor White -BackgroundColor DarkGreen
                    continuer
                }
            }
            si ($env:tsmethod -eq "StaticCID") {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $attempts = @(
                    @(100055, 1000043, 1338662172562478),
                    @(1345, 1003020, 6311608238084405)
                )
                pour chaque ($params dans $attempts) {
                    [LibTSforge.Modifiers.SetIIDParams]::SetParams($ver, $prod, $tsactid, [LibTSforge.SPP.PKeyAlgorithm]::PKEY2009, $params[0], $params[1], $params[2])
                    $instId = [LibTSforge.SPP.SLApi] ::GetInstallationID($tsactid)
                    $confId = [ActivationWs.ActivationHelper]::CallWebService(1, $instId, "31337-42069-123-456789-04-1337-2600.0000-2542001")
                    $resultat = [LibTSforge.SPP.SLApi]::DepositConfirmationID($tsactid, $instId, $confId)
                    si ($resultat -eq 0) { break }
                }
                [LibTSforge.SPP.SPPUtils]::RestartSPP($ver)
            }
            elseif ($env:tsmethod -eq "KMS4k") {
                [LibTSforge.Activators.KMS4k]::Activate($ver, $prod, $tsactid)
            }
            autre {
                [LibTSforge.Activators.ZeroCID ]::Activate($ver, $prod, $tsactid)
            }
            si ($env:tsmethod -eq "KMS4k") {
                $GracePeriodStatus = Get-WmiInfo -tsactid $tsactid -property "GracePeriodRemaining"
                si ($GracePeriodStatus -eq 259200 -or ([datetime]::Now.AddMinutes($GracePeriodStatus)).Year -gt 2038) {
                    si ((($build -ge 26100 -et $GracePeriodStatus -ge 259200) -ou
                            ($build -lt 26100 -et $GracePeriodStatus -gt 259200))) {
                        $activated = 1
                    }
                }
            }
            autre {
                $licenseStatus = Get-WmiInfo -tsactid $tsactid -property "LicenseStatus"
                si ($licenseStatus -eq 1) { $activated = 1 }
            }
            si ($activé) {
                si ($prodDes correspond à 'KMS' et $prodDes ne correspond pas à 'CLIENT') {
                    [LibTSforge.Modifiers.KMSHostCharge]::Charge($ver, $prod, $tsactid)
                    Write-Host "[$prodName] CSVLK est activé en permanence avec $env:tsmethod." -ForegroundColor White -BackgroundColor DarkGreen
                    Write-Host "[$prodName] CSVLK est facturé pour 25 clients pendant 30 jours." -ForegroundColor White -BackgroundColor DarkGreen
                }
                autre {
                    si ($env:tsmethod -eq "KMS4k") {
                        si ($build -ge 26100) {
                            Write-Host "[$prodName] est activé avec KMS4k depuis plus de 4 000 ans." -ForegroundColor White -BackgroundColor DarkGreen
                            Write-Host "À partir de la version 26100.7019, Windows affichera systématiquement une période d'activation restante de 180 jours dans les Paramètres." -ForegroundColor White -BackgroundColor Darkgray
                        }
                        autre {
                            Write-Host "[$prodName] est activé jusqu'à $([DateTime]::Now.AddMinutes($GracePeriodStatus).ToString('yyyy-MM-dd HH:mm:ss')) avec $env:tsmethod." -ForegroundColor White -BackgroundColor DarkGreen
                        }
                    }
                    autre {
                        Write-Host "[$prodName] est activé de façon permanente avec $env:tsmethod." -ForegroundColor White -BackgroundColor DarkGreen
                    }
                }
            }
            autre {
                Write-Host "L'activation de [$prodName] a échoué." -ForegroundColor White -BackgroundColor DarkRed
                $errcode = 3
            }
        }
        attraper {
            $errcode = 3
            Écrire-Hôte "$($_.Exception.Message)" -Couleur de premier plan Rouge -Couleur d'arrière-plan Noir
            Write-Host "L'activation de [$prodName] a échoué." -ForegroundColor White -BackgroundColor DarkRed
        }
    }
}

si ($env:resetstuff) {
    essayer {
        if (-not $env:_vis) { [LibTSforge.Modifiers.TamperedFlagsDelete]::DeleteTamperFlags($ver, $prod) }
        [LibTSforge.SPP.SLApi]::RefreshLicenseStatus()
        [LibTSforge.Modifiers.RearmReset]::Reset($ver, $prod)
        [LibTSforge.Modifiers.GracePeriodReset]::Reset($ver, $prod)
        if (-not $env:_vis) { [LibTSforge.Modifiers.KeyChangeLockDelete]::Delete($ver, $prod) }
    }
    attraper {
        $errcode = 3
        Écrire-Hôte "$($_.Exception.Message)" -Couleur de premier plan Rouge -Couleur d'arrière-plan Noir
    }
}

Sortie $errcode
:tsforge:

:=================================================================================================================================================

:: Obtenir l'identifiant d'activation Windows

:wintsid:
$SysPath = "$env:SystemRoot\System32"
si (Test-Path "$env:SystemRoot\Sysnative\reg.exe") {
    $SysPath = "$env:SystemRoot\Sysnative"
}

fonction Windows-ActID {
    param (
        [chaîne]$édition,
        [chaîne]$type de clé
    )
    
    $filePatterns = @(
        "$SysPath\spp\tokens\skus\$edition\$edition*.xrm-ms",
        "$SysPath\spp\tokens\skus\Security-SPP-Component-SKU-$edition\*-$edition-*.xrm-ms"
    )
    
    switch ($keytype) {
        "zéro" {
            $licenseTypes = @('OEM_DM', 'OEM_COA_SLP', 'OEM_COA_NSLP', 'MAK', 'RETAIL')
        }
        "ks" {
            $licenseTypes = @('KMSCLIENT')
        }
        "avma" {
            $licenseTypes = @('VIRTUAL_MACHINE')
        }
        "kmshost" {
            $licenseTypes = @('KMS_')
        }
    }
    
    $softwareLicensingProducts = Get-WmiObject -Query "SELECT ID, Description, LicenseFamily FROM SoftwareLicensingProduct WHERE ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f'" | Where-Object { $_.LicenseFamily -eq $edition }
    
    $licencescommandées = @()
    pour chaque ($type dans $licenseTypes) {
        $orderedLicenses += $softwareLicensingProducts | Where-Object { $_.Description -match $type } | Select-Object -ExpandProperty ID
    }
    
    $fileIds = @()
    $muiLockedIds = @()
    $kmsCountedIdCounts = @{}

    $t = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1).DefineDynamicModule(2, $False).DefineType(0)

    $méthodes = @(
        @{nom = 'SLOpen'; returnType = [Int32]; paramètres = @([IntPtr].MakeByRefType()) },
        @{name = 'SLClose'; returnType = [Int32]; parameters = @([IntPtr]) },
        @{name = 'SLGetProductSkuInformation'; returnType = [Int32]; parameters = @([IntPtr], [Guid].MakeByRefType(), [String], [UInt32].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()) },
        @{name = 'SLGetLicense'; returnType = [Int32]; parameters = @([IntPtr], [Guid].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()) }
    )
    
    pour chaque ($method dans $methods) {
        $t.DefinePInvokeMethod($method.name, 'slc.dll', 22, 1, $method.returnType, $method.parameters, 1, 3).SetImplementationFlags(128)
    }
    
    $w = $t.CreateType()
    $m = [Runtime.InteropServices.Marshal]

    fonction GetLicenseInfo($SkuId, $checkType) {
        $resultat = $false
        $c = 0; $b = 0
        
        [void]$w::SLGetProductSkuInformation($hSLC, [ref][Guid]$SkuId, "fileId", [ref]$null, [ref]$c, [ref]$b)
        $FileId = $m::PtrToStringUni($b)
        
        $c = 0; $b = 0
        [void]$w::SLGetLicense($hSLC, [ref][Guid]$FileId, [ref]$c, [ref]$b)
        $blob = New-Object byte[] $c; $m::Copy($b, $blob, 0, $c)
        $cont = [Text.Encoding]::UTF8.GetString($blob)
        $xml = [xml]$cont.SubString($cont.IndexOf('<r'))
        
        si ($checkType -eq 'MUI') {
            $xml.licenseGroup.license[0].grant | foreach {
                $_.allConditions.allConditions.productPolicies.policyStr | where { $_.name -eq 'Kernel-MUI-Language-Allowed' } | foreach {
                    if ($_.InnerText -ne 'EMPTY') { $result = $true }
                }
            }
        }
        sinon si ($checkType -eq 'KMS') {
            $xml.licenseGroup.license[0].grant | foreach {
                $_.allConditions.allConditions.productPolicies.policyStr | where { $_.name -eq 'Security-SPP-KmsCountedIdList' } | foreach {
                    $result = ($_.InnerText.Replace(' ', '').Replace("`n", '') -split ',').Count
                }
            }
        }
        
        renvoyer $result
    }

    $hSLC = 0; [void]$w::SLOpen([ref]$hSLC)

    pour chaque ($id dans $orderedLicenses) {
        si ($keytype -eq 'kmshost') {
            $kmsCount = GetLicenseInfo $id 'KMS'
            si ($kmsCount -gt 0) {
                $kmsCountedIdCounts[$id] = $kmsCount
            }
        }
        si ($edition -notcontains "CountrySpecific" -and (GetLicenseInfo $id 'MUI')) {
            $muiLockedIds += $id
        }
    }
    
    pour chaque ($filePattern dans $filePatterns) {
        $files = Get-ChildItem -Path $filePattern -Filter '*.xrm-ms' -ErrorAction SilentlyContinue
        pour chaque fichier ($file) dans $files {
            si ($null -ne $file.FullName) {
                $content = Get-Content -Path $file.FullName -ErrorAction SilentlyContinue | Out-String
                pour chaque ($id dans $orderedLicenses) {
                    si ($content -match "name=`"productSkuId`">\{$id\}" -and -not ($file.Name -match 'Beta|Test')) {
                        $fileIds += $id
                    }
                }
            }
        }
    }
    
    si ($kmsCountedIdCounts.Count -gt 0) {
        $idWithMostIds = $kmsCountedIdCounts.GetEnumerator() | Sort-Object Value -Descending
        $fileIds = $idWithMostIds | Select-Object -ExpandProperty Key
    }
    autre {
        si ($fileIds.Count -eq 0) {
            $fileIds = $orderedLicenses
        }
    
        $fileIds = $orderedLicenses | Where-Object { $fileIds -contains $_ -and $muiLockedIds -notcontains $_ } | Select-Object -Unique
    }
    
    [void]$w::SLClose($hSLC)
    
    $pkeyconfig = "$SysPath\spp\tokens\pkeyconfig\pkeyconfig.xrm-ms"
    si ($keytype -eq 'kmshost') {
        $csvlkPath = "$SysPath\spp\tokens\pkeyconfig\pkeyconfig-csvlk.xrm-ms"
        si (Test-Path $csvlkPath) {
            $pkeyconfig = $csvlkPath
        }
    }
    
    $data = [xml][Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(([xml](get-content $pkeyconfig)).licenseGroup.license.otherInfo.infoTables.infoList.infoBin.InnerText))
    
    $betaIds = @()
    $excludedIds = @()
    $checkedIds = @()
    
    pour chaque ($id dans $fileIds) {
        $actConfig = $data.ProductKeyConfiguration.Configurations.Configuration | Where-Object { $_.ActConfigId -eq "{$id}" }
        si ($actConfig) {
            $productDescription = $actConfig.ProductDescription
            $productEditionID = $actConfig.EditionID
            si ($productDescription -match 'MUI locked|Tencent|Qihoo|WAU') {
                $excludedIds += $id
                continuer
            }
    
            si ($productDescription -match 'Beta|RC |Next |Test|Pre-') {
                $betaIds += $id
                continuer
            }
    
            si ($keytype -ne 'kmshost' -et $productEditionID -eq '$edition') {
                $checkedIds += $id
                continuer
            }
    
            $refGroupId = $actConfig.RefGroupId
            $publicKey = $data.ProductKeyConfiguration.PublicKeys.PublicKey | Where-Object { $_.GroupId -eq $refGroupId -and $_.AlgorithmId -eq 'msft:rm/algorithm/pkey/2009' }
            si ($publicKey) {
                $keyRanges = $data.ProductKeyConfiguration.KeyRanges.KeyRange | Where-Object { $_.RefActConfigId -eq "{$id}" }
                pour chaque ($keyRange dans $keyRanges) {
                    si ($keyRange.EulaType -match 'WAU') {
                        $excludedIds += $id
                        casser
                    }
                }
            }
        }
    }
    
    $prefinalIds = @()
    $finalIds = @()
    
    $prefinalIds = $fileIds | Where-Object { $excludedIds -notcontains $_ } | Select-Object -Unique
    $finalIds = $prefinalIds | Where-Object { $betaIds -notcontains $_ } | Select-Object -Unique
    
    si ($finalIds.Count -eq 0) {
        $finalIds = $prefinalIds
    }
    
    si ($checkedIds.Count -gt 0) {
        $finalIds = $checkedIds + $finalIds
    }
    
    $firstId = $finalIds | Select-Object -First 1
    retourner $firstId.ToLower()
}

Windows-ActID -édition "$env:tsedition" -type de clé "$env:keytype"
:wintsid:

:=================================================================================================================================================

:: Obtenir l'identifiant d'activation d'Office

:offtsid:
fonction Office-ActID {
    param (
        [chaîne]$pkeypath,
        [chaîne]$édition,
        [chaîne]$type de clé
    )

    switch ($keytype) {
        "zéro" { $productKeyTypes = @("OEM:NONSLP","Volume:MAK","Retail") }
        "ks" { $productKeyTypes = @("Volume:GVLK") }
    }

    $data = [xml][Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(([xml](Get-Content $pkeypath)).licenseGroup.license.otherInfo.infoTables.infoList.infoBin.InnerText))
    $configurations = $data.ProductKeyConfiguration.Configurations.Configuration

    $filteredConfigs = @()
    pour chaque ($type dans $productKeyTypes) {
        $filteredConfigs += $configurations | Where-Object {
            $_.EditionId -eq $edition -et
            $_.ProductKeyType -eq $type -et
            $_.ProductDescription -notmatch 'demo|MSDN|PIN'
        }
    }

    $filterPreview = $filteredConfigs | Where-Object { $_.ProductDescription -notmatch 'preview|c2r' }

    si ($filterPreview.Count -ne 0) {
        $filteredConfigs = $filterPreview
    }

    $firstConfig = ($filteredConfigs | Select-Object -First 1).ActConfigID -replace '^\{|\}$', ''
    retourner $firstConfig.ToLower()
}

Office-ActID -pkeypath "$env:pkeypath" -edition "$env:_License" -keytype "$env:keytype"
:offtsid:

:=================================================================================================================================================

:: 1re colonne = Version Office
:: 2e colonne = Volume ou produit de détail gratuit
:: 3e colonne = Noms des produits de détail qui doivent être convertis en produits en volume mentionnés dans la 2e colonne
:: Séparateur = "_"

:tsksdata

définir f=
pour %%# dans (
:: Office 2013
15_Volume_AccessRetail-
15_AccessRuntimeRetail
15_ExcelVolume_-ExcelRetail-
15_GrooveVolume_-GrooveRetail-
15_InfoPathVolume_-InfoPathRetail-
15_LyncAcademicRetail
15_LyncEntryRetail
15_LyncVolume_-LyncRetail-
15_MondoRetail
15_MondoVolume_-O365BusinessRetail-O365HomePremRetail-O365ProPlusRetail-O365SmallBusPremRetail-
15_OneNoteFreeRetail
15_OneNoteVolume_-OneNoteRetail-
15_OutlookVolume_-OutlookRetail-
15_PowerPointVolume_-PowerPointRetail-
15_ProjectProVolume_-ProjectProRetail-
15_VolumeStandardProjet_-DétailStandardProjet-
15_ProPlusVolume_-ProPlusRetail-ProfessionalPipcRetail-ProfessionalRetail-
15_Volume_Éditeur-Vente au détail-
15_SPDRetail
15_StandardVolume_-StandardRetail-HomeBusinessPipcRetail-HomeBusinessRetail-HomeStudentARMRetail-HomeStudentPlusARMRetail-HomeStudentRetail-PersonalPipcRetail-PersonalRetail-
15_VisioProVolume_-VisioProRetail-
15_VisioStdVolume_-VisioStdRetail-
15_Volume_de_mots_-WordRetail-
:: Office 2016
16_AccessRuntimeRetail
16_AccessVolume_-AccessRetail-
16_ExcelVolume_-ExcelRetail-
16_MondoRetail
16_MondoVolume_-O365AppsBasicRetail-O365BusinessRetail-O365EduCloudRetail-O365HomePremRetail-O365ProPlusRetail-O365SmallBusPremRetail-
16_OneNoteFreeRetail
16_OneNoteVolume_-OneNoteRetail-OneNote2021Retail-
16_OutlookVolume_-OutlookRetail-
16_PowerPointVolume_-PowerPointRetail-
16_ProjectProVolume_-ProjectProRetail-
16_ProjectProXVolume
16_VolumeStandardProjet_-DétailStandardProjet-
16_ProjectStdXVolume
16_ProPlusVolume_-ProPlusRetail-ProfessionalPipcRetail-ProfessionalRetail-
16_Volume_Éditeur-Vente au détail-
16_SkypeServiceBypassRetail
16_SkypeforBusinessEntryRetail
16_SkypeForBusinessVolume_-SkypeForBusinessRetail-
16_StandardVolume_-StandardRetail-HomeBusinessPipcRetail-HomeBusinessRetail-HomeStudentARMRetail-HomeStudentPlusARMRetail-HomeStudentRetail-HomeStudentVNextRetail-PersonalPipcRetail-PersonalRetail-
16_VisioProVolume_-VisioProRetail-
16_VisioProXVolume
16_VisioStdVolume_-VisioStdRetail-
16_VisioStdXVolume
16_Volume_de_mots_-WordRetail-
:: Office 2019
16_AccessRuntime2019Commerce de détail
16_Access2019Volume_-Access2019Retail-
16_Excel2019Volume_-Excel2019Retail-
16_Outlook2019Volume_-Outlook2019Retail-
16_PowerPoint2019Volume_-PowerPoint2019Retail-
16_ProjectPro2019Volume_-ProjectPro2019Retail-
16_ProjectStd2019Volume_-ProjectStd2019Retail-
16_ProPlus2019Volume_-ProPlus2019Retail-Professional2019Retail-
16_Éditeur2019Volume_-Éditeur2019Détail-
16_SkypeForBusiness2019Volume_-SkypeForBusiness2019Retail-
16_SkypeforBusinessEntry2019Commerce de détail
16_Standard2019Volume_-Standard2019Commerce de détail-Domicile2019Commerce de détail-Étudiants2019Commerce de détail-ÉtudiantsPlus2019Commerce de détail-Étudiants2019Commerce de détail-Personnel2019Commerce de détail-
16_VisioPro2019Volume_-VisioPro2019Retail-
16_VisioStd2019Volume_-VisioStd2019Retail-
16_Word2019Volume_-Word2019Commerce de détail-
:: Office 2021
La licence KMS en volume OneNote 2021 n'est pas disponible.
16_AccessRuntime2021Commerce de détail
16_Access2021Volume_-Access2021Retail-
16_Excel2021Volume_-Excel2021Retail-
16_Outlook2021Volume_-Outlook2021Retail-
16_OneNoteFree2021Retail
16_PowerPoint2021Volume_-PowerPoint2021Retail-
16_ProjectPro2021Volume_-ProjectPro2021Retail-
16_ProjectStd2021Volume_-ProjectStd2021Retail-
16_ProPlus2021Volume_-ProPlus2021Retail-Professional2021Retail-
16_Éditeur2021Volume_-Éditeur2021Détail-
16_SkypeForBusiness2021Volume_-SkypeForBusiness2021Retail-
16_Standard2021Volume_-Standard2021Commerce de détail-DomicileEntreprise2021Commerce de détail-DomicileÉtudiant2021Commerce de détail-Personnel2021Commerce de détail-
16_VisioPro2021Volume_-VisioPro2021Retail-
16_VisioStd2021Volume_-VisioStd2021Retail-
16_Word2021Volume_-Word2021Commerce de détail-
:: Office 2024
16_Access2024Volume_-Access2024Retail-
16_Excel2024Volume_-Excel2024Retail-
16_Outlook2024Volume_-Outlook2024Retail-
16_PowerPoint2024Volume_-PowerPoint2024Retail-
16_ProjectPro2024Volume_-ProjectPro2024Retail-
16_ProjectStd2024Volume_-ProjectStd2024Retail-
16_ProPlus2024Volume_-ProPlus2024Retail-
16_Skype Entreprise 2024 Volume
16_Standard2024Volume_-Home2024Retail-HomeBusiness2024Retail-
16_VisioPro2024Volume_-VisioPro2024Retail-
16_VisioStd2024Volume_-VisioStd2024Retail-
16_Word2024Volume_-Word2024Commerce de détail-
) faire (
pour /f "tokens=1-3 delims=_" %%A dans ("%%#") faire (

si %1==chkprod si "%oVer%"=="%%A" si non défini foundprod (
si /i "%%B"="%2" définir foundprod=1
)

si %1==getinfo si "%oVer%"=="%%A" (
echo: %%C | find /i "-%2-" %nul% && (
définir _Licence=%%B
définir _altoffid=%%B
)
)

)
)
quitter /b

:=================================================================================================================================================

:ts_getedition

définir tsedition=
définir _wtarget=

si %_wmic% EQU 1 définir "chkedi=for /f "tokens=2 delims==" %%a dans ('"wmic path %spp% où (ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' ET LicenseDependsOn est NULL) obtenir LicenseFamily /VALUE" %nul6%')"
si %_wmic% EQU 0 définir "chkedi=for /f "tokens=2 delims==" %%a dans ('%psc% "(([WMISEARCHER]'SELECT LicenseFamily FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND LicenseDependsOn is NULL').Get()).LicenseFamily ^| %% {echo ('LicenseFamily='+$_)}" %nul6%')"
%chkedi% faire si le niveau d'erreur n'est pas 1 appeler définir "_wtarget= !_wtarget! %%a "

:: Base de données des références et des identifiants d'édition

pour %%# dans (
1:Ultime
2:AccueilBasique
3:HomePremium
4:Entreprise
5:HomeBasicN
6 : Entreprise
7:ServeurStandard
8 : Serveur Centre de données
9:ServeurSBSStandard
10:Serveur Entreprise
11:Débutant
12:ServeurCentreDeDonnéesCore
13:ServerStandardCore
14:ServeurEnterpriseCore
15:ServeurEntrepriseIA64
16:BusinessN
17:ServerWeb
18:ServeurHPC
19:ServeurDomicileStandard
20:ServerStorageExpress
21:ServerStockageStandard
22:Groupe de travail de stockage du serveur
23:ServeurStockageEntreprise
24:ServerWinSB
25:ServerSBSPreium
26:HomePremiumN
27:EnterpriseN
28:UltimateN
29:ServerWebCore
30:ServeurMoyen Gestion d'entreprise
31:ServeurMoyenEntrepriseSécurité
32:ServeurMediumMessagerieEntreprise
33:ServerWinFoundation
34:ServerHomePremium
35:ServerWinSBV
36:ServerStandardV
37:ServeurCentreDeDonnéesV
38:ServerEnterpriseV
39:ServeurCentreDeDonnéesVCor
40:ServerStandardVCore
41:ServerEnterpriseVCore
42:ServeurHyperCore
43:ServerStorageExpressCore
44:ServerStorageStandardCore
45:ServeurStockageGroupeDeTravailCore
46:ServerStockageEntrepriseCore
47:StarterN
48 : Professionnel
49:ProfessionnelN
50:ServerSolution
51:ServeurPourSBSolutions
52:ServerSolutionsPremium
53:ServerSolutionsPremiumCore
54:ServerSolutionEM
55:ServerForSBSolutionsEM
56:ServerEmbeddedSolution
57:ServerEmbeddedSolutionCore
58 : Professionnel intégré
59:Gestion essentielle du serveur
60 : Serveur essentiel supplémentaire
61:ServeurEssentialManagementSvc
62:ServeurEssentielServicesAdditionnels
63:ServerSBSPremiumCore
64:ServeurHPCV
65:Intégré
66:StarterE
67:HomeBasicE
68:HomePremiumE
69:ProfessionnelE
70:EntrepriseE
71:UltimateE
72:Évaluation d'entreprise
74 : Avant-première
76:ServeurMultiPointStandard
77:ServeurMultiPointPremium
79:ServerStandardEval
80 : Évaluation du serveur et du centre de données
81:PrereleaseARM
82:PréversionN
84:Évaluation d'entreprise
85:EmbeddedAutomotive
86:IntégréeIndustrieA
87:ThinPC
88:EmbeddedA
89:Intégrés Industrie
90:EmbeddedE
91:Intégré à l'industrieE
92:EmbeddedIndustryAE
93:ProfessionalPlus
95:Évaluation du groupe de travail ServerStorage
96:ServerStorageStandardEval
97:CoreARM
98:CoreN
99:Noyau spécifique
100:Langue unique de base
101 : Noyau
103 : WMC professionnel
104:MobileCore
105 : Évaluation de l'industrie embarquée
106 : Évaluation intégrée industrielle
107:EmbeddedEval
108:EmbeddedEEval
109:Serveur du système principal
110 : Serveur Cloud Storage
111:CoreConnected
112 : Étudiant professionnel
113:CoreConnectedN
114 : Étudiant professionnel N
115:Noyau connecté monolingue
116:Noyau connecté spécifique au pays
117 : Voiture connectée
118 : Appareil portable industriel
119:PPIPRO
120:ServeurARM64
121 : Éducation
122:ÉducationN
123:IoTUAP
124:ServerHI
125:EntrepriseS
126:EnterpriseSN
127:Professionnels
128 : Professionnel SN
129:Évaluation d'entreprise
130:Évaluation de l'entreprise
131:IoTUAPCommercial
133:MobileEnterprise
134 : AnalogOneCoreEnterprise
135:AnalogOneCore
136 : Holographique
138 : Langue unique professionnelle
139 : Professionnel spécifique au pays
140 : Abonnement Entreprise
141:EnterpriseSubscriptionN
143:ServeurCentreDeDonnéesNano
144:ServerStandardNano
145:ServeurCentreDeDonnéesACor
146:ServerStandardACor
147:ServerDatacenterCor
148:ServerStandardCor
149:UtilityVM
159:Évaluation du serveur et du centre de données
160:ServerStandardEvalCor
161 : Poste de travail professionnel
162 : Poste de travail professionnel N
163:ServeurAzure
164 : Formation professionnelle
165 : Formation professionnelle N
168:ServerAzureCor
169 : Serveur Azure Nano
171:EnterpriseG
172:EnterpriseGN
173 : Abonnement professionnel
174:BusinessSubscriptionN
175:ServerRdsh
178:Nuage
179:CloudN
180:HubOS
182:OneCoreUpdateOS
183:CloudE
184 : Andromède
185:IoTOS
186:CloudEN
187:IoTEdgeOS
188:IoTEnterprise
189:PC moderne
191:IoTEnterpriseS
192:Système d'exploitation
193:NativeOS
194:GameCoreXbox
195:GameOS
196:DurangoHostOS
197:ScarlettHostOS
198:Keystone
199:CloudHost
200:CloudMOS
201:CloudCore
202:CloudEditionN
203:Édition Cloud
204:WinVOS
205:IoTEnterpriseSK
206:IoTEnterpriseK
207:Évaluation d'entreprise IoT
208:AgentBridge
209:NanoHost
210:WNC
406 : Serveur Azure Stack HCICor
407:ServerTurbine
408:ServerTurbineCor

REM Certains noms d'anciennes éditions avec le même identifiant SKU

4:ProEnterprise
6:ProStandard
10:ProSBS
16:ProStandardN
18:Cluster de calcul serveur
19:ServeurAccueil
30:ServeurMidmarketStandard
31:ServeurMidmarketEdge
32:ServeurMidmarketPremium
33:ServeurSBSPrime
42:ServerHyper
64:ServerComputeClusterV
85:Iapetus intégré
86:Téthys enchâssée
88:IntégréeDione
89:Rhéa intégrée
90:Encelade intégré
109:ServerNano
124:Infrastructure ServeurCloudHost
133:MobileBusiness
134:HololensEnterprise
145:ServeurCentreDeDonnéesSCor
146:ServerStandardSCor
147:ServeurCentreDeDonnéesWSCor
148:ServerStandardWSCor
189:Lite
) faire (
pour /f "tokens=1-2 delims=:" %%A dans ("%%#") faire si "%osSKU%"=="%%A" si non défini tsedition (
echo "%_wtarget%" | find /i " %%B " %nul% && set tsedition=%%B
)
)

si la tsedition est définie, quitter /b

définir d1=%ref% [void]$TypeBuilder.DefinePInvokeMethod('GetEditionNameFromId', 'pkeyhelper.dll', 'Public, Static', 1, [int], @([int], [IntPtr].MakeByRefType()), 1, 3);
définir d1=%d1% $out = 0; [void]$TypeBuilder.CreateType()::GetEditionNameFromId(%osSKU%, [ref]$out);$s=[Runtime.InteropServices.Marshal]::PtrToStringUni($out); $s

pour %%# dans (pkeyhelper.dll) faire @si non "%%~$PATH:#"=="" (
pour /f %%a dans ('%psc% "%d1%"') faire si pas errorlevel 1 (
echo "%_wtarget%" | find /i " %%a " %nul% && set tsedition=%%a
)
)

quitter /b

:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:Activation KMS

Pour activer Windows avec l'activation KMS, exécutez le script avec le paramètre « /K-Windows » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actwin=0

Pour activer toutes les applications Office (y compris Project/Visio) avec l'activation KMS, exécutez le script avec le paramètre « /K-Office » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actoff=0

Pour activer uniquement Project/Visio avec l'activation KMS, exécutez le script avec le paramètre « /K-ProjectVisio » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actprojvis=0

Pour activer tous les logiciels Windows/Office avec l'activation KMS, exécutez le script avec le paramètre « /K-WindowsOffice » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _actwinoff=0

Pour désactiver le changement d'édition de Windows/Office si l'édition actuelle ne prend pas en charge l'activation KMS, exécutez le script avec le paramètre « /K-NoEditionChange » ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _NoEditionChange=0

Pour ne pas installer automatiquement la tâche de renouvellement lors de l'activation, exécutez le script avec le paramètre « /K-NoRenewalTask ​​» ou remplacez 0 par 1 dans la ligne ci-dessous.
définir _norentsk=0

Pour désinstaller KMS, exécutez le script avec le paramètre « /K-Uninstall » ou remplacez 0 par 1 dans la ligne ci-dessous. Ce paramètre sera prioritaire.
définir _uni=0

:: Options avancées :
:: N'utilisez pas l'option de tâche de renouvellement si vous prévoyez d'utiliser un nom de serveur spécifique au lieu des serveurs publics utilisés dans le script

Pour spécifier une adresse de serveur pour l'activation, exécutez le script avec le paramètre « /K-Server-VOTRE_NOM_DE_SERVEUR_KMS » ou ajoutez-le à la ligne ci-dessous après le signe =
définir _serveur=

Pour spécifier un port d'activation, exécutez le script avec le paramètre « /K-Port-VOTRENOMDEPORT » ou ajoutez-le à la ligne ci-dessous après le signe =.
définir _port=

:: Le script s'exécutera en mode sans surveillance si des paramètres sont utilisés OU si une valeur est modifiée dans les lignes ci-dessus POUR l'activation ou la désinstallation.

:=================================================================================================================================================

cls
couleur 07
définir KS=K%vide%MS
titre Activation en ligne %KS% %masver%

définir _args=
définir _elev=
définir _unattended=0

définir _args=%*
si _args est défini, définissez _args=%_args:"=%
si _args est défini pour %%A dans (%_args%) faire (
si /i "%%A"="-el" (définir _elev=1)
si /i "%%A"="/K-Windows" (définir _actwin=1)
si /i "%%A"="/K-Office" (définir _actoff=1)
si /i "%%A"=="/K-ProjectVisio" (définir _actprojvis=1)
si /i "%%A"="/K-WindowsOffice" (définir _actwinoff=1)
si /i "%%A"="/K-NoEditionChange" (définir _NoEditionChange=1)
si /i "%%A"="/K-NoRenewalTask" (définir _norentsk=1)
si /i "%%A"="/K-Uninstall" (définir _uni=1)
echo "%%A" | find /i "/K-Port-" >nul && (set "_port=%%A" & call set "_port=%%_port:~8%%")
echo "%%A" | find /i "/K-Server-" >nul && (set "_server=%%A" & call set "_server=%%_server:~10%%")
)

pour %%A dans (%_actwin% %_actoff% %_actprojvis% %_actwinoff% %_uni%) faire (si "%%A"=="1" définir _unattended=1)

:=================================================================================================================================================

si %_uni%==1 aller à :ks_uninstall

:ks_menu

si _server est défini, définir _norentsk=1
si non défini _serveur définir _port=

si %_unattended%==0 (
cls
si le mode terminal n'est pas défini, 76, 30
titre Activation en ligne %KS% %masver%

écho:
écho:
écho:
écho:
si le fichier "%ProgramFiles%\Activation-Renewal\Activation_task.cmd" existe (
trouver /i "Ver:2.7" "%ProgramFiles%\Activation-Renewal\Activation_task.cmd" %nul% || (
appel :dk_color %_Yellow% " Ancienne tâche de renouvellement détectée, exécutez l'activation pour la mettre à jour."
)
)
écho ______________________________________________________________
écho:
echo [1] Activer - Windows
écho [2] Activer - Office [Tous]
echo [3] Activer - Office [Project/Visio]
écho [4] Activer - Tout
écho _______________________________________________  
écho:
si %_norentsk%==0 (
echo [5] Tâche de renouvellement avec activation [Oui]
) autre (
appel :dk_color2 %_White% " [5] Tâche de renouvellement avec activation " %_Yellow% "[Non]"
)
si %_NoEditionChange%==0 (
echo [6] Changer d'édition si nécessaire [Oui]
) autre (
appel :dk_color2 %_Blanc% " [6] Changer d'édition si nécessaire " %_Jaune% "[Non]"
)
echo [7] Désinstaller en ligne %KS%
écho _______________________________________________       
écho:
si défini _serveur (
echo [8] Définir %KS% Serveur/Port [%_serveur%] [%_port%]
) autre (
echo [8] Définir le serveur/port %KS%
)
echo [9] Télécharger Office
echo [0] %_exitmsg%
écho ______________________________________________________________
écho:
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier [1,2,3,4,5,6,7,8,9,0]"
choix /C:1234567890 /N
définir _el=!errorlevel!

if !_el!==10 exit /b
if !_el!==9 start %mas%genuine-installation-media & goto :ks_menu
si !_el!==8 aller à :ks_ip
if !_el!==7 cls & call :ks_uninstall & cls & goto :ks_menu
si !_el!==6 (si %_NoEditionChange%==0 (définir _NoEditionChange=1) sinon (définir _NoEditionChange=0)) & aller à :ks_menu
si !_el!==5 (si %_norentsk%==0 (définir _norentsk=1) sinon (définir _norentsk=0)) & aller à :ks_menu
if !_el!==4 cls & setlocal & set "_actwin=1" & set "_actoff=1" & set "_actprojvis=0" & call :ks_start & endlocal & cls & goto :ks_menu
if !_el!==3 cls & setlocal & set "_actwin=0" & set "_actoff=0" & set "_actprojvis=1" & call :ks_start & endlocal & cls & goto :ks_menu
if !_el!==2 cls & setlocal & set "_actwin=0" & set "_actoff=1" & set "_actprojvis=0" & call :ks_start & endlocal & cls & goto :ks_menu
if !_el!==1 cls & setlocal & set "_actwin=1" & set "_actoff=0" & set "_actprojvis=0" & call :ks_start & endlocal & cls & goto :ks_menu
aller à :ks_menu
)

:=================================================================================================================================================

:ks_start

cls
si le terminal n'est pas défini (
mode 115, 32
si le chemin « %SysPath%\spp\store_test » existe, mode 135, 32
%psc% "&{$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=32;$B.Height=300;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}" %nul%
)
titre Activation en ligne %KS% %masver%

écho:
Initialisation en cours...
appel :dk_chkmal

si %SysPath%\%_slexe% n'existe pas (
%eline%
Le fichier [%SysPath%\%_slexe%] est manquant, arrêt...
écho:
si les résultats ne sont pas définis (
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez Dépannage et exécutez les options de restauration DISM et d'analyse SFC."
appel :dk_color %Blue% "Après cela, redémarrez le système et réessayez l'activation."
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Si l'erreur persiste, procédez comme suit : " %_Yellow% " %mas%in-place_repair_upgrade"
)
aller à dk_done
)

:=================================================================================================================================================

si %_actprojvis%==1 (définir "_actoff=1")
si %_actwinoff%==1 (définir "_actwin=1" et définir "_actoff=1")

définir spp=SoftwareLicensingProduct
définir sps=SoftwareLicensingService

appel :dk_ckeckwmic
appel :dk_checksku
appel :dk_product
appel :dk_sppissue

:=================================================================================================================================================

définir l'erreur=

cls
écho:
appel :dk_showosinfo

:: Vérifier la connexion Internet

définir _int=
pour %%a dans (l.root-servers.net resolver1.opendns.com download.windowsupdate.com google.com) faire si non défini _int (
for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%a') do (if not "%%#"=="" set _int=1)
)

si non défini _int (
%psc% "Si([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet){Exit 0}Else{Exit 1}"
if !errorlevel!==0 (set _int=1&set ping_f= Mais le ping a échoué)
)

si défini _int (
écho Vérification de la connexion Internet [Connecté%ping_f%]
) autre (
définir erreur=1
appel :dk_color %Red% "Vérification de la connexion Internet [Non connecté]"
appel :dk_color %Blue% "Internet requis pour l'activation en ligne %KS%."
)

:=================================================================================================================================================

écho Lancement des tests de diagnostic...

définir "_serv=%_slser% Winmgmt"

:: Protection logicielle
:: Instrumentation de gestion Windows

si %_actwin%==0 définir notwinact=1
appel :dk_errorcheck

:=================================================================================================================================================

appel :_taskclear-cache
appel :_tasksetserv

si %_actwin% n'est pas égal à 1, aller à :ks_office

:: Processus Windows
:: Vérifiez si le système est activé en permanence ou non

écho:
écho Traitement Windows...
appel :dk_checkperm
si défini _perm (
appel :dk_color %Gray% "Vérification de l'activation du système d'exploitation [Windows est déjà activé de façon permanente]"
aller à :ks_office
)

:: Vérifier la version d'évaluation

définir _eval=
définir _evalserv=

Si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-*EvalEdition~*.mum" existe, définissez _eval=1
Si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*EvalEdition~*.mum" existe, définissez _evalserv=1
Si le fichier « %SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*EvalCorEdition~*.mum » existe, définissez _eval=1 et _evalserv=1

si défini _eval (
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID %nul2% | find /i "Eval" %nul1% && (
appel :dk_color %Red% "Vérification de l'édition d'évaluation [Les éditions d'évaluation ne peuvent pas être activées en dehors de la période d'évaluation.]"

si défini _evalserv (
appel :dk_color %Blue% "Retournez au menu principal et utilisez l'option [Changer d'édition].
) autre (
appel :dk_color %Blue% "Utilisez l'option d'activation TSforge du menu principal pour réinitialiser la période d'évaluation."
définir les correctifs=%fixes% %mas%evaluation_editions
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%evaluation_editions"
)

aller à :ks_office
)
)

:=================================================================================================================================================

:: Vérifiez si GVLK est déjà installé ou non

appel :k_channel

:: Détecter la clé

définir la clé=
définir pkey=
définir la touche alternative=
définir changekey=
définir l'édition=

appel :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f
si défini allapps appel :ksdata winkey
si la clé n'est pas définie, appelez :k_gvlk %nul%
si défini, toutes les applications ; sinon, appel de clé :kmsfallback

si altkey est défini (set key=%altkey%&set changekey=1)

définir /a UBR=0
si %osSKU%==191 si altkey défini si altédition défini (
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR %nul6%') do if not errorlevel 1 set /a UBR=%%b
si %winbuild% LSS 22598 si !UBR! LSS 2788 (
appel :dk_color %Blue% "Windows doit être mis à jour vers la version 19044.2788 ou supérieure pour l'activation d'IotEnterpriseS %KS%."
)
)

si la clé n'est pas définie, si elle est définie, notfoundaltactID (
appel :dk_color %Red% "Vérification de l'édition alternative pour %KS% [ID d'activation %altedition% introuvable]"
)

si la clé n'est pas définie si _gvlk n'est pas défini (
echo [%winos% ^| %winbuild% ^| SKU:%osSKU%]

si %winbuild% GEQ 9200 si existe "%SysPath%\spp\tokens\skus\%osedition%\*GVLK*.xrm-ms", définir sppks=1
si %winbuild% LSS 9200 existe "%SysPath%\spp\tokens\skus\Security-SPP-Component-SKU-%osedition%\*VLKMS*.xrm-ms", définir sppks=1
si %winbuild% LSS 9200 existe "%SysPath%\spp\tokens\skus\Security-SPP-Component-SKU-%osedition%\*VL-BYPASS*.xrm-ms", définir sppks=1
si %winbuild% LSS 7600 existe "%SysPath%\licensing\skus\Security-Licensing-SLC-Component-SKU-%osedition%\*KMS*.xrm-ms", définir sppks=1
si %winbuild% LSS 7600 existe "%SysPath%\licensing\skus\Security-Licensing-SLC-Component-SKU-%osedition%\*VL-BYPASS*.xrm-ms", définir sppks=1

si défini skunotfound (
appel :dk_color %Red% "Fichiers de licence requis introuvables."
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)

si sppks est défini (
appel :dk_color %Red% "L'activation %KS% est prise en charge, mais la clé %KS% n'a pas pu être trouvée."
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)

si non défini skunotfound si non défini sppks (
appel :dk_color %Rouge% "Ce produit ne prend pas en charge l'activation %KS%."
appel :dk_color %Blue% "Utilisez l'option d'activation TSforge du menu principal."
)
écho:
aller à :ks_office
)

:=================================================================================================================================================

:: Clé d'installation

si la clé de changement est définie (
appel :dk_color %Blue% "La clé de produit de l'édition [%altedition%] sera utilisée pour activer %KS%."
écho:
)

si winsub est défini (
appel :dk_color %Blue% "Abonnement Windows [ID SKU-%slcSKU%] trouvé. Le script activera l'édition de base [ID SKU-%regSKU%].
écho:
)

définir _partiel=
si la clé n'est pas définie (
si %_wmic% EQU 1 pour /f "tokens=2 delims==" %%# dans ('wmic path %spp% where "ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' and PartialProductKey<>null AND LicenseDependsOn is NULL" Get PartialProductKey /value %nul6%') do set "_partial=%%#"
Si %_wmic% EQU 0 pour /f "tokens=2 delims==" %%# dans ('%psc% "(([WMISEARCHER]'SELECT PartialProductKey FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND PartialProductKey IS NOT NULL AND LicenseDependsOn is NULL').Get()).PartialProductKey | %% {echo ('PartialProductKey='+$_)}" %nul6%') do set "_partial=%%#"
appel echo Vérification de la clé de produit installée [Clé partielle - %%_partielle%%] [Volume:GVLK]
)

si la clé est définie (
définir generickey=1
appel :dk_inskey "[%key%]"
)

:=================================================================================================================================================

:ks_office

si %_actoff% n'est pas égal à 1, aller à :ks_activate

appel :oh_setspp

:: Vérifier l'installation d'ohook

définir ohook=
pour %%# dans (15 16) faire (
pour %%A dans ("%ProgramFiles%" "%ProgramW6432%" "%ProgramFiles(x86)%") faire (
si le fichier "%%~A\Microsoft Office\Office%%#\sppc*dll" existe, définissez ohook=1
)
)

pour %%# dans (System SystemX86) faire (
pour %%G dans ("Office 15" "Office") faire (
pour %%A dans ("%ProgramFiles%" "%ProgramW6432%" "%ProgramFiles(x86)%") faire (
si le fichier "%%~A\Microsoft %%~G\root\vfs\%%#\sppc*dll" existe, définissez ohook=1
)
)
)

si défini ohook (
écho:
appel :dk_color %Gray% "Vérification d'Ohook [L'activation d'Ohook est déjà installée pour Office]"
)

:: Vérifier les versions d'Office non prises en charge

définir o14c2r=
définir _68=HKLM\SOFTWARE\Microsoft\Office
définir _86=HKLM\SOFTWARE\Wow6432Node\Microsoft\Office
%nul% reg query %_68%\14.0\CVH /f Click2run /k && set o14c2r=Office 2010 C2R
%nul% reg query %_86%\14.0\CVH /f Click2run /k && set o14c2r=Office 2010 C2R

si ce n'est pas "%o14c2r%"="" (
écho:
appel :dk_color %Red% "Vérification de l'installation Office non prise en charge [ %o14c2r%]"
)

si %winbuild% GEQ 10240 %psc% "Get-AppxPackage -name "Microsoft.MicrosoftOfficeHub"" | find /i "Office" %nul1% && (
définir ohub=1
)

:=================================================================================================================================================

:: Vérifier les versions d'Office prises en charge

appel :oh_getpath

définir o16uwp=
définir o16uwp_path=

si %winbuild% GEQ 10240 (
for /f "delims=" %%a in ('%psc% "(Get-AppxPackage -name 'Microsoft.Office.Desktop' | Select-Object -ExpandProperty InstallLocation)" %nul6%') do (if exist "%%a\Integration\Integrator.exe" (set o16uwp=1&set "o16uwp_path=%%a"))
)

sc query ClickToRunSvc %nul%
définir error1=%errorlevel%

si défini o16c2r si %error1% EQU 1060 (
écho:
appel :dk_color %Red% "Vérification du service ClickToRun [Introuvable, fichiers Office 16.0 trouvés]"
définir o16c2r=
définir erreur=1
)

sc query OfficeSvc %nul%
définir error2=%errorlevel%

si défini o15c2r si %error1% EQU 1060 si %error2% EQU 1060 (
écho:
appel :dk_color %Red% "Vérification du service ClickToRun [Introuvable, fichiers Office 15.0 trouvés]"
définir o15c2r=
définir erreur=1
)

si "%o16uwp%%o16c2r%%o15c2r%%o16msi%%o15msi%%o14msi%"="" (
définir erreur=1
écho:
si ce n'est pas "%o14c2r%"="" (
appel :dk_color %Red% "Vérification de l'installation d'Office prise en charge [Introuvable]"
) autre (
appel :dk_color %Red% "Vérification d'Office installé [Introuvable]"
)

si ohub est défini (
écho:
Vous n'avez installé que l'application Office Dashboard ; vous devez installer la version complète d'Office.
)
appel :dk_color %Blue% "Téléchargez et installez Office à partir de l'URL ci-dessous, puis réessayez."
définir les correctifs=%fixes% %mas%genuine-installation-media
appel :dk_color %_Yellow% "%mas%genuine-installation-media"
aller à :ks_activate
)

définir multioffice=
si ce n'est pas "%o16uwp%%o16c2r%%o15c2r%%o16msi%%o15msi%%o14msi%"="1", définir multioffice=1
si ce n'est pas "%o14c2r%"="" définir multioffice=1

si défini multioffice (
écho:
appel :dk_color %Gray% "Vérification de plusieurs installations d'Office [Détectées. Il est recommandé d'installer une seule version]"
)

:=================================================================================================================================================

:: Process Office UWP

Si o16uwp n'est pas défini, aller à :ks_starto15c2r

appel :ks_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir oVer=16
définir "_oLPath=%o16uwp_path%\Licenses16"
for /f "delims=" %%a in ('%psc% "(Get-AppxPackage -name 'Microsoft.Office.Desktop' | Select-Object -ExpandProperty Dependencies) | Select-Object PackageFullName" %nul6%') do (set "o16uwpapplist=!o16uwpapplist! %%a")

echo "%o16uwpapplist%" | findstr /i "Access Excel OneNote Outlook PowerPoint Publisher SkypeForBusiness Word" %nul% && set "_oIds=O365HomePremRetail"

pour %%# dans (Projet Visio) faire (
echo "%o16uwpapplist%" | findstr /i "%%#" %nul% && (
définir _lat=
si le fichier "%_oLPath%\%%#Pro2024VL*.xrm-ms" existe, définissez "_oIds= !_oIds! %%#Pro2024Retail " et définissez _lat=1
Si la variable _lat n'est pas définie et que le fichier "%_oLPath%\%%#Pro2021VL*.xrm-ms" existe, alors définir "_oIds= !_oIds! %%#Pro2021Retail " et définir _lat=1
Si la variable _lat n'est pas définie et que le fichier "%_oLPath%\%%#Pro2019VL*.xrm-ms" existe, alors définir "_oIds= !_oIds! %%#Pro2019Retail " et définir _lat=1
si non défini _lat définir "_oIds= !_oIds! %%#ProRetail "
)
)

définir uwpinfo=%o16uwp_path:C:\Program Files\WindowsApps\Microsoft.Office.Desktop_=%

écho:
echo Bureau de traitement... [UWP ^| %uwpinfo%]

si non défini _oIds (
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
définir erreur=1
aller à :ks_starto15c2r
)

appel :ks_process

:=================================================================================================================================================

:ks_starto15c2r

:: Process Office 15.0 C2R

Si o15c2r n'est pas défini, aller à :ks_starto16c2r

appel :ks_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir oVer=15
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg% /v InstallPath" %nul6%') do (set "_oRoot=%%b\root")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v Platform" %nul6%') do (set "_oArch=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v VersionToReport" %nul6%') do (set "_version=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o15c2r_reg%\Configuration /v ProductReleaseIds" %nul6%') do (set "_prids=%o15c2r_reg%\Configuration /v ProductReleaseIds" & set "_config=%o15c2r_reg%\Configuration")
si _oArch n'est pas défini pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o15c2r_reg%\propertyBag /v Platform" %nul6%') faire (définir "_oArch=%%b")
si la version n'est pas définie pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o15c2r_reg%\propertyBag /v version" %nul6%') faire (définir "_version=%%b")
Si la variable `_prids` n'est pas définie pour `/f "skip=2 tokens=2*" %%a` dans `'"reg query %o15c2r_reg%\propertyBag /v ProductReleaseId" %nul6%'`, alors `(set "_prids=%o15c2r_reg%\propertyBag /v ProductReleaseId" & set "_config=%o15c2r_reg%\propertyBag")`

echo "%o15c2r_reg%" | find /i "Wow6432Node" %nul1% && (set _tok=10) || (set _tok=9)
pour /f "tokens=%_tok% delims=\" %%a dans ('reg query %o15c2r_reg%\ProductReleaseIDs\Active %nul6% ^| findstr /i "Retail Volume"') faire (
echo "!_oIds!" | find /i " %%a " %nul1% || (set "_oIds= !_oIds! %%a ")
)

définir "_oLPath=%_oRoot%\Licenses"
définir "_oIntegrator=%_oRoot%\integration\integrator.exe"

écho:
echo Traitement en cours... [C2R ^| %_version% ^| %_oArch%]

si non défini _oIds (
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
définir erreur=1
aller à :ks_starto16c2r
)

appel :oh_expiredpreview 2013
si "%_actprojvis%"=="0" appelez :oh_fixprids
appel :ks_process

:=================================================================================================================================================

:ks_starto16c2r

:: Process Office 16.0 C2R

Si o16c2r n'est pas défini, aller à :ks_startmsi

appel :ks_reset
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663

définir oVer=16
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg% /v InstallPath" %nul6%') do (set "_oRoot=%%b\root")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v Platform" %nul6%') do (set "_oArch=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v VersionToReport" %nul6%') do (set "_version=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v AudienceData" %nul6%') do (set "_AudienceData=^| %%b ")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v ProductReleaseIds" %nul6%') do (set "_prids=%o16c2r_reg%\Configuration /v ProductReleaseIds" & set "_config=%o16c2r_reg%\Configuration")

echo "%o16c2r_reg%" | find /i "Wow6432Node" %nul1% && (set _tok=9) || (set _tok=8)
pour /f "tokens=%_tok% delims=\" %%a dans ('reg query "%o16c2r_reg%\ProductReleaseIDs" /s /f ".16" /k %nul6% ^| findstr /i "Retail Volume"') faire (
echo "!_oIds!" | find /i " %%a " %nul1% || (set "_oIds= !_oIds! %%a ")
)
définir _oIds=%_oIds:.16=%
définir _o16c2rIds=%_oIds%

définir "_oLPath=%_oRoot%\Licenses16"
définir "_oIntegrator=%_oRoot%\integration\integrator.exe"

écho:
echo Traitement en cours... [C2R ^| %_version% %_AudienceData%^| %_oArch%]

si non défini _oIds (
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
définir erreur=1
aller à :ks_startmsi
)

appel :oh_expiredpreview 2016 2019 2021 2024
si "%_actprojvis%"=="0" appelez :oh_fixprids
appel :ks_process

:=================================================================================================================================================

:ks_startmsi

si défini o14msi appel :oh_setspp 14
si défini o14msi appel :ks_processmsi 14 %o14msi_reg%
appel :oh_setspp
si défini o15msi appel :ks_processmsi 15 %o15msi_reg%
si défini o16msi appel :ks_processmsi 16 %o16msi_reg%

:=================================================================================================================================================

écho:
appel :oh_clearblock
si "%o16msi%%o15msi%"="" si ce n'est pas "%o16uwp%%o16c2r%%o15c2r%"="" si "%keyerror%"="0" si %_NoEditionChange%==0 appeler :oh_uninstkey
appel :oh_licrefresh

:=================================================================================================================================================

:ks_activer

:: Désactiver l'envoi des données d'activation KMSclient à Microsoft
:: https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services#19-software-protection-platform

si %winbuild% GEQ 9600 (
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v NoGenTicket /t REG_DWORD /d 1 /f %nul%
Si %winbuild% est égal à 14393, ajoutez la clé de registre "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v NoAcquireGT /t REG_DWORD /d 1 /f %nul%
echo Désactivation de la validation AVS %KS% [Réussie]
)

définir "slp=SoftwareLicensingProduct"
définir "ospp=OfficeSoftwareProtectionProduct"

écho:
Activation des produits de volume echo...
si %_actwin%==1 appel :_taskgetids sppwid %slp% windows
si %_actoff%==1 appel :_taskgetids sppoid %slp% bureau
si %_actoff%==1 appel :_taskgetids osppid %ospp% bureau

si non défini sppwid si non défini sppoid si non défini osppid (
si la clé n'est pas définie (
Aucun produit Windows/Office installé sur le volume n'a été trouvé.
) autre (
appel :dk_color %Red% "Échec de l'installation des produits Windows/Office en volume."
)
appel :_taskgetserv
appel :_taskregserv
)

appel :_tâche
si non défini, afficher le correctif ; si défini, _tserror (appel :dk_color %Blue% "%_fixmsg%" & définir showfix=1)

:: Ne pas créer de tâche de renouvellement si les ID de volume Windows/Office sont introuvables, même si le script est configuré pour la créer par défaut.
Ne créez pas de tâche de renouvellement si seul l'ID de volume Windows est trouvé et qu'une erreur BIOS OEM est présente sous Windows 7, même si le script est configuré pour la créer par défaut.

définir _deltask=
si %_norentsk% n'est pas égal à 0, définir _deltask à 1
si non défini _deltask (
si %_actwin%==0 appel :_taskgetids sppwid %slp% windows
si %_actoff%==0 appel :_taskgetids sppoid %slp% bureau
si %_actoff%==0 appel :_taskgetids osppid %ospp% bureau
)

si non défini sppwid si non défini sppoid si non défini osppid (définir _deltask=1)
si défini oemerr si non défini sppoid si non défini osppid (définir _deltask=1)

si non défini _deltask (
appel :ks_renouvellement
) autre (
Si le fichier "%ProgramFiles%\Activation-Renewal\Activation_task.cmd" existe, appelez :dk_color %Gray% "Suppression de la tâche de renouvellement d'activation..."
appel :dk_color %Gray% "Ignorer la création de la tâche de renouvellement d'activation..."
appel :ks_clearstuff %nul%
si non défini _serveur (
si %winbuild% GEQ 9200 (
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" set "_C16R=1"
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun /v InstallPath /reg:32" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" set "_C16R=1"
si défini _C16R (
REM mass{}grave{dot}dev/office-license-is-not-genuine
définir _serveur=10.0.0.10
appel :_taskregserv
echo Conservation de l'adresse IP inexistante 10.0.0.10 comme serveur %KS%.
)
)
si non défini _C16R (
appel :_taskclear-cache
echo Serveur %KS% supprimé du registre.
)
)
)

:: https://learn.microsoft.com/en-us/azure/virtual-desktop/windows-10-multisession-faq

si %_actwin%==1 pour %%# dans (407) faire si %osSKU%==%%# (
appel :dk_color %Red% "%winos% ne prend pas en charge l'activation sur les plateformes non-Azure."
)

si %_actoff%==1 si défini sppoid si non défini _tserror si %_NoEditionChange%==0 si défini ohub (
écho:
Appel :dk_color %Gray% « Les applications Office telles que Word et Excel sont activées, utilisez-les directement. Ignorez le bouton « Acheter » dans l’application Tableau de bord Office. »
)

:: Déclencher une réévaluation des tâches planifiées de SPP

appel :dk_reeval %nul%
aller à :dk_done

:=================================================================================================================================================

:ks_ip

cls
définir _serveur=
écho:
echo Entrez/Collez l'adresse du serveur %KS%, ou appuyez simplement sur Entrée pour revenir :
écho:
définir /p _serveur=
Si le serveur n'est pas défini, allez à :ks_menu
définir "_serveur=%_serveur: =%"

écho:
Saisissez/collez l'adresse du port %KS%, ou appuyez simplement sur Entrée pour utiliser la valeur par défaut :
écho:
définir /p _port=
Si le port n'est pas défini, allez à :ks_menu
définir "_port=%_port: =%"

aller à :ks_menu

:=================================================================================================================================================

:ks_reset

définir la clé=
définir _oRoot=
définir _oArch=
définir _oIds=
définir _oLPath=
définir _actid=
définir _prod=
définir _lic=
définir _arr=
définir _prids=
définir _config=
définir _version=
définir _Licence=
définir _oMSI=
quitter /b

:=================================================================================================================================================

Après la conversion de la vente au détail en vente en volume, le nouvel identifiant produit nécessite la clé .OSPPReady dans le registre ; sinon, les informations produit risquent de ne pas s'afficher correctement.

:ks_osppready

if not defined _config exit /b

echo: %_config% | find /i "propertyBag" %nul1% && (
définir "_osppt=REG_DWORD"
définir "_osppready=%o15c2r_reg%"
) || (
définir "_osppt=REG_SZ"
définir "_osppready=%_config%"
)

reg add %_osppready% /f /v %_altoffid%.OSPPReady /t %_osppt% /d 1 %nul1%

Les versions d'Office antérieures à 16.0.10730.20102 nécessitent l'ID du produit de licence installé dans ProductReleaseIds ; sinon, les informations produit risquent de ne pas s'afficher correctement.

if exist "%_oLPath%\Word2019VL_KMS_Client_AE*.xrm-ms" exit /b

reg query %_prids% | findstr /I "%_altoffid%" %nul1%
si %errorlevel% NEQ 0 (
for /f "skip=2 tokens=2*" %%a in ('reg query %_prids%') do reg add %_prids% /t REG_SZ /d "%%b,%_altoffid%" /f %nul1%
)
quitter /b

:=================================================================================================================================================

:oh_setspp

définir isOspp=
si %winbuild% GEQ 9200 (
définir spp=SoftwareLicensingProduct
définir sps=SoftwareLicensingService
) autre (
définir isOspp=1
définir spp=Produit de protection des logiciels de bureau
définir sps=OfficeSoftwareProtectionService
)
si "%1"="14" (
définir isOspp=1
définir spp=Produit de protection des logiciels de bureau
définir sps=OfficeSoftwareProtectionService
)
quitter /b

:=================================================================================================================================================

:ks_process

pour %%# dans (%_oIds%) faire (

définir skipprocess=
si %_NoEditionChange%==1 si non défini _oMSI (
définir foundprod=
appel :ksdata chkprod %%#
si non défini foundprod (
définir skipprocess=1
appel :dk_color %Gray% "Ignoré car mode NoEditionChange [%%#]"
)
)


si "%_actprojvis%"=="1" si non défini skipprocess (
echo %%# | findstr /i "Project Visio" %nul% || (
définir skipprocess=1
appel :dk_color %Gray% "Ignoré car mode Projet/Visio [%%#]"
)
)

si "%_actprojvis%"=="0" si non défini skipprocess echo %_oIds% | findstr /i "O365" %nul% && (
echo %%# | findstr /i "Project Visio" %nul% && (
définir skipprocess=1
echo Ignoré car Mondo est disponible [%%#]
)
)

si non défini ignorer le processus (
définir la clé=
définir _actid=
définir _preview=
définir _Licence=%%#
définir _altoffid=

echo %%# | find /i "2024" %nul% && (
Si le fichier « !_oLPath!\ProPlus2024PreviewVL_*.xrm-ms » existe, sinon, définissez _preview=-Preview
)
définir _prod=%%#!_preview!

appel :ksdata getinfo !_prod!

si défini _altoffid (
définir _License=!_altoffid!
echo Conversion du commerce de détail en volume [!_prod! vers !_altoffid!]
echo %%# | find /i "O365" %nul% && (
si "%oVer%"=="15" (appel :dk_color %Gray% "Mondo 2013 est équivalent à O365 [version 15.0] en termes de fonctionnalités les plus récentes.")
si "%oVer%"=="16" (appel :dk_color %Gray% "Mondo 2016 est équivalent à O365 en termes de fonctionnalités les plus récentes.")
)
définir _prod=!_altoffid!
appel :ks_osppready
)

si ce n'est pas "!key!"="" (
echo "!allapps!" | trouver /i "!_actid!" %nul1% || appelle :oh_installlic
définir generickey=1
appel :dk_inskey "[!key!] [!_prod!]"
) autre (
si non défini _oMSI (
définir erreur=1
appel :dk_color %Red% "Vérification du produit dans le script [Office %oVer%.0 !_prod! introuvable dans le script]"
appel :dk_color %Blue% "Assurez-vous d'utiliser le script MAS le plus récent."
) autre (
appel :dk_color %Red% "Vérification du produit dans le script [!_prod! MSI Retail n'est pas pris en charge]"
Appel :dk_color %Blue% "Utilisez l'option Ohook pour l'activer. Pour l'activer avec %KS%, vous devez installer la version Volume d'Office."
)
définir les correctifs=%fixes% %mas%genuine-installation-media
appel :dk_color %_Yellow% "%mas%genuine-installation-media"
)
)
)

quitter /b

:=================================================================================================================================================

:ks_processmsi

:: Traitement de la version MSI d'Office

appel :ks_reset
définir _oMSI=1

si "%1"="14" (
appel :dk_actids 59a52881-a989-479d-af46-f275c6370663
) autre (
appel :dk_actids 0ff1ce15-a989-479d-af46-f275c6370663
)

définir oVer=%1
for /f "skip=2 tokens=2*" %%a in ('"reg query %2\Common\InstallRoot /v Path" %nul6%') do (set "_oRoot=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %2\Common\ProductVersion /v LastProduct" %nul6%') do (set "_version=%%b")
si "%_oRoot:~-1%"="\" définir "_oRoot=%_oRoot:~0,-1%"

echo "%2" | find /i "Wow6432Node" %nul1% && set _oArch=x86
Si la variable `_oArch` n'est pas définie, alors `_oArch` est définie sur `x64`.
si "%osarch%"="x86" définir _oArch=x86

appel :msiofficedata %2

écho:
echo Traitement Office... [MSI ^| %_version% ^| %_oArch%]

si non défini _oIds (
définir erreur=1
appel :dk_color %Red% "Vérification des produits installés [Identifiants de produits introuvables. Activation annulée...]"
quitter /b
)

appel :ks_process
quitter /b

:=================================================================================================================================================

:ks_désinstaller

cls
si le mode terminal n'est pas défini, 91, 30
titre En ligne %KS% Désinstallation complète de %masver%

définir "uline=__________________________________________________________________________________________"

définir "_C16R="
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun /v InstallPath" 2^>nul') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" set "_C16R=1"
for /f "skip=2 tokens=2*" %%a in ('"reg query HKLM\SOFTWARE\Microsoft\Office\ClickToRun /v InstallPath /reg:32" 2^>nul') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" set "_C16R=1"
si %winbuild% GEQ 9200 si défini _C16R (
écho:
appel :dk_color %Gray% "Avis-"
écho:
Pour éviter que les programmes Office n'affichent une bannière non authentique,
Veuillez exécuter l'option d'activation une seule fois, et ne désinstallez pas ensuite.
écho %uline%
)

écho:
définir erreur_=
appel :_taskclear-cache
appel :ks_clearstuff

:: vérifier le verrou KMS38

%nul% requête reg "HKLM\%SPPk%\%_wApp%" && (
définir erreur_=9
echo Échec de la suppression complète du cache %KS%.
reg query "HKLM\%SPPk%\%_wApp%" /s %nul2% | findstr /i "127.0.0.2" %nul1% && echo L'activation KMS38 est verrouillée.
appel :dk_color %Bleu% "%_fixmsg%"
écho:
) || (
echo Cache %KS% vidé avec succès.
)

si erreur_ définie (
si "%error_%"=="1" (
écho %uline%
%eline%
Réessayez / Redémarrez le système
écho %uline%
)
) autre (
écho %uline%
écho:
appel :dk_color %Green% "Le service %KS% en ligne a été désinstallé avec succès."
écho:
appel :dk_color %Gray% "Si vous souhaitez réinitialiser l'état d'activation,"
appel :dk_color %Bleu% "%_fixmsg%"
écho:
écho %uline%
)

aller à :dk_done

:ks_clearstuff

définir "clé=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\taskcache\tasks"

reg query "%key%" /f Chemin /s | find /i "\Activation-Renewal" %nul1% && (
écho Suppression de [Tâche] Activation-Renouvellement
schtasks /delete /tn Activation-Renewal /f %nul%
)

reg query "%key%" /f Path /s | find /i "\Activation-Run_Once" %nul1% && (
écho Suppression de [Tâche] Activation-Run_Once
schtasks /delete /tn Activation-Run_Once /f %nul%
)

Si le fichier "%ProgramFiles%\Activation-Renewal\" existe (
echo Suppression du dossier [Dossier] %ProgramFiles%\Activation-Renewal\
rmdir /s /q "%ProgramFiles%\Activation-Renewal\" %nul%
)

:: Éléments provenant d'anciennes versions MAS

schtasks /delete /tn Online_%KS%_Activation_Script-Renewal /f %nul%
schtasks /delete /tn Online_%KS%_Activation_Script-Run_Once /f %nul%
supprimer /f /q "%ProgramData%\Online_%KS%_Activation.cmd" %nul%
rmdir /s /q "%ProgramData%\Activation-Renewal\" %nul%
rmdir /s /q "%ProgramData%\Online_%KS%_Activation\" %nul%
rmdir /s /q "%windir%\Online_%KS%_Activation_Script\" %nul%
reg delete "HKCR\DesktopBackground\shell\Activate Windows - Office" /f %nul%

:: Vérifier si tout a été supprimé

reg query "%key%" /f Path /s | find /i "\Activation-Renewal" %nul1% && (set error_=1)
reg query "%key%" /f Path /s | find /i "\Activation-Run_Once" %nul1% && (set error_=1)
reg query "%key%" /f Path /s | find /i "\Online_%KS%_Activation_Script" %nul1% && (set error_=1)
Si le fichier "%windir%\Online_%KS%_Activation_Script\" existe (définir error_=1)
reg query "HKCR\DesktopBackground\shell\Activate Windows - Office" %nul% && (set error_=1)
si le fichier "%ProgramData%\Online_%KS%_Activation.cmd" existe (définir error_=1)
si le fichier "%ProgramData%\Online_%KS%_Activation\" existe (définir error_=1)
si le fichier "%ProgramData%\Activation-Renewal" existe (définir error_=1)
si le dossier "%ProgramFiles%\Activation-Renewal\" existe (définir error_=1)
quitter /b

:=================================================================================================================================================

:_extrairetâche:
@echo désactivé

:: Renouveler l'activation KMS auprès des serveurs en ligne via une tâche planifiée

:===============================================================================
::
:: Page d'accueil : m{}assgrave{dot}dev
::
:===============================================================================


si ce n'est pas "%~1"="Tâche" (
écho:
echo ====== Erreur ======
écho:
echo Ce fichier est censé être exécuté uniquement par la tâche planifiée.
écho:
Appuyez sur une touche pour quitter
pause >nul
quitter /b
)

Définissez les variables d'environnement ; cela peut être utile si elles sont mal configurées dans le système.

setlocal EnableExtensions
setlocal DésactiverExpansionDélai

définir "PathExt=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC"

définir "SysPath=%SystemRoot%\System32"
définir "Path=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\"
si le fichier "%SystemRoot%\Sysnative\reg.exe" existe (
définir "SysPath=%SystemRoot%\Sysnative"
définir "Path=%SystemRoot%\Sysnative;%SystemRoot%;%SystemRoot%\Sysnative\Wbem;%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\;%Path%"
)

définir "ComSpec=%SysPath%\cmd.exe"
définir "PSModulePath=%ProgramFiles%\WindowsPowerShell\Modules;%SysPath%\WindowsPowerShell\v1.0\Modules"

>nul fltmc || exit /b

:=================================================================================================================================================

définir _tserror=
définir winbuild=1
définir "nul=>nul 2>&1"
for /f "tokens=2 delims=[]" %%G in ('ver') do for /f "tokens=2,3,4 delims=. " %%H in ("%%~G") do set "winbuild=%%J"
définir psc=powershell.exe -nop -c

définir _slexe=sppsvc.exe& définir _slser=sppsvc
si %winbuild% LEQ 6300 (définir _slexe=SLsvc.exe& définir _slser=SLsvc)
si %winbuild% LSS 7600 si existe "%SysPath%\SLsvc.exe" (définir _slexe=SLsvc.exe& définir _slser=SLsvc)
si %_slexe%==SLsvc.exe définir _vis=1

définir run_once=
définir t_name=Tâche de renouvellement
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\taskcache\tasks" /f Path /s | find /i "\Activation-Run_Once" >nul && (
définir run_once=1
définir t_name=Tâche à exécuter une seule fois
)

définir _wmic=0
pour %%# dans (wmic.exe) faire @si non "%%~$PATH:#"=="" (
cmd /c "wmic path Win32_ComputerSystem get CreationClassName /value" 2>nul | find /i "computersystem" 1>nul && set _wmic=1
)
si %winbuild% LSS 9200 définir _wmic=1

setlocal EnableDelayedExpansion
si le fichier "%ProgramFiles%\Activation-Renewal\" existe, appelez :_taskstart>>"%ProgramFiles%\Activation-Renewal\Logs.txt"
sortie

:=================================================================================================================================================

:_taskstart

écho:
afficher %date%, %heure%

définir /a boucle=1
définir /a max_loop=4

appel :_tasksetserv

:_répéter

:: Vérifiez la connexion Internet. Fonctionne même si l'écho ICMP est désactivé.

pour %%a dans (%srvlist%) faire (
pour /f "delims=[] tokens=2" %%# dans ('ping -n 1 %%a') faire (
si ce n'est pas "%%#"="", aller à _taskIntConnected
)
)

nslookup dns.msftncsi.com 2>nul | trouver "131.107.255.255" 1>nul
si "%errorlevel%"=="0" aller à _taskIntConnected

si %loop%==%max_loop% (
définir _tserror=1
aller à _taskend
)

écho:
Erreur : Internet non connecté
écho Attente de 30 secondes

délai d'attente dépassé /t 30 >nul
définir /a boucle=%boucle%+1
aller à _intrepeat

:_tâcheIntConnecté

:=================================================================================================================================================

appel :_taskclear-cache

:: Vérifier les erreurs WMI et sppsvc

définir applist=
net start %_slser% /y %nul%
si %_wmic% EQU 1 définir "chkapp=for /f "tokens=2 delims==" %%a dans ('"wmic path %slp% où (ApplicationID='%_wApp%') obtenir ID /VALUE" 2^>nul')"
si %_wmic% EQU 0 définir "chkapp=for /f "tokens=2 delims==" %%a dans ('%psc% "(([WMISEARCHER]'SELECT ID FROM %slp% WHERE ApplicationID=''%_wApp%''').Get()).ID ^| %% {echo ('ID='+$_)}" 2^>nul')"
%chkapp% faire (si applist défini (appeler set "applist=!applist! %%a") sinon (appeler set "applist=%%a"))

si la liste des applications n'est pas définie (
définir _tserror=1
if %_wmic% EQU 1 wmic path Win32_ComputerSystem get CreationClassName /value 2>nul | find /i "computersystem" 1>nul
if %_wmic% EQU 0 %psc% "Get-CIMInstance -Class Win32_ComputerSystem | Select-Object -Property CreationClassName" 2>nul | find /i "computersystem" 1>nul
si !errorlevel! NEQ 0 (définissez e_wmispp=WMI, SPP) sinon (définissez e_wmispp=SPP)
écho:
echo Erreur : Ne répond pas - !e_wmispp!
écho:
)

:=================================================================================================================================================

:: Vérifier les ID d'activation des produits en volume installés

appel :_taskgetids sppwid %slp% windows
appel :_taskgetids sppoid %slp% bureau
appel :_taskgetids osppid %ospp% bureau

:=================================================================================================================================================

écho:
echo Renouvellement de l'activation KMS pour tous les produits Volume installés

si non défini sppwid si non défini sppoid si non défini osppid (
écho:
Aucun volume Windows/Office installé trouvé
écho:
écho Renouvellement du serveur KMS
appel :_taskgetserv
appel :_taskregserv
aller à :_skipact
)

:=================================================================================================================================================

appel :_tâche

:_skipact

:=================================================================================================================================================

si défini run_once (
écho:
écho Suppression de l'activation de la tâche planifiée - Exécution unique
schtasks /delete /tn Activation-Run_Once /f %nul%
)

:=================================================================================================================================================

:_tâche

écho:
écho Sortie
écho ______________________________________________________________________

si _tserror est défini (sortie /b 123456789) sinon (sortie /b 0)

:=================================================================================================================================================

:_acte

définir prodname=
si %_wmic% EQU 1 pour /f "tokens=2 delims==" %%# dans ('"wmic path !_path! where ID='!_actid!' get LicenseFamily /VALUE" 2^>nul') faire (appeler set "prodname=%%#")
si %_wmic% EQU 0 pour /f "tokens=2 delims==" %%# dans ('%psc% "(([WMISEARCHER]'SELECT LicenseFamily FROM !_path! WHERE ID=''!_actid!''').Get()).LicenseFamily | %% {echo ('LicenseFamily='+$_)}" 2^>nul') faire (appeler set "prodname=%%#")
pour /f "tokens=1 delims=-_" %%a dans ("%prodname%"), définissez "prodname=%%a"

définir _taskskip=
si "%_actprojvis%"=="1" (
echo: %prodname% | find /i "Office" %nul% && (
echo: %prodname% | findstr /i "Project Visio" %nul% || (set _taskskip=1& exit /b)
)
)

si t_name est défini Activation : %prodname%

définir le code d'erreur=12345
définir /a act_attempt=0

:_acte2

si %act_attempt% GTR 4 quitter /b

si ce n'est pas "%act_ok%"="1" (
si non défini, appelez _server :_taskgetserv
appel :_taskregserv
)

si non !server_num! GTR %max_servers% (

si "%1"=="act_win" si %_kms38% EQU 1 (
définir act_ok=1
quitter /b
)

si %_wmic% EQU 1 wmic path !_path! où ID='!_actid!' appel Activate %nul%
si %_wmic% EQU 0 %psc% "try {$null=(([WMISEARCHER]'SELECT ID FROM !_path! where ID=''!_actid!''').Get()).Activate(); exit 0} catch { exit $_.Exception.InnerException.HResult }"

appelez set errorcode=!errorlevel!

si !code d'erreur! EQU 0 (
définir act_ok=1
quitter /b
)
si "%1"="act_win" si !errorcode! EQU -1073418187 si %winbuild% LSS 9200 (
définir act_ok=1
quitter /b
)

définir act_ok=0
définir /a act_attempt+=1
Si _server n'est pas défini, aller à _act2
)
quitter /b

:=================================================================================================================================================

:_actinfo

si "%1"="act_win" si non défini t_name (définir prodname=%winos%)

si "%1"=="act_win" si %_kms38% EQU 1 (
si t_name est défini (
echo %prodname% est déjà activé avec KMS38.
) autre (
appel :dk_color %Green% "%prodname% est déjà activé avec KMS38."
)
quitter /b
)

si %errorcode% est égal à 12345 (
si t_name est défini (
L'activation de %prodname% a échoué en raison d'une connexion Internet restreinte ou inexistante.
) autre (
appel :dk_color %Red% "L'activation de %prodname% a échoué en raison d'une connexion Internet restreinte ou inexistante."
)
définir showfix=1
définir _tserror=1
quitter /b
)

si %errorcode% EQU -1073418187 si "%1"=="act_win" si %winbuild% LSS 9200 (
si t_name est défini (
echo %prodname% ne peut pas être activé KMS sur cet ordinateur en raison d'un BIOS OEM non qualifié [0xC004F035].
) autre (
appel :dk_color %Red% "%prodname% ne peut pas être activé KMS sur cet ordinateur en raison d'un BIOS OEM non qualifié [0xC004F035].
appel :dk_color %Blue% "Utilisez l'option d'activation TSforge du menu principal."
)
définir oemerr=1
définir showfix=1
quitter /b
)

si %errorcode% EQU -1073418124 (
si t_name est défini (
L'activation de %prodname% a échoué en raison d'un problème Internet [0xC004F074].
) autre (
appel :dk_color %Red% "%prodname% l'activation a échoué en raison d'un problème Internet [0xC004F074].
si non défini _tserror (
appel :dk_color %Blue% "Assurez-vous que les fichiers système ne sont pas bloqués par le pare-feu."
appel :dk_color %Blue% "Si le problème persiste, essayez une autre connexion Internet ou un VPN tel que https://1.1.1.1"
)
)
définir showfix=1
définir _tserror=1
quitter /b
)


définir gpr=0
définir gpr2=0
appel :_taskgetgrace
définir /a "gpr2=(%gpr%+1440-1)/1440"

si %errorcode% EQU 0 si %gpr% EQU 0 (
si t_name est défini (
L'activation de %prodname% a réussi, mais la période restante n'a pas pu être augmentée.
) autre (
appel :dk_color %Red% "L'activation de %prodname% a réussi, mais la période restante n'a pas pu être augmentée."
)
définir _tserror=1
quitter /b
)

définir _actpass=1
si %gpr% EQU 43200 si "%1"=="act_win" si %winbuild% GEQ 9200 définir _actpass=0
si %gpr% EQU 64800 définir _actpass=0
si %gpr% GTR 259200 si "%1"=="act_win" appel :_taskchkEnterpriseG _actpass
si %gpr% est égal à 259200, définir _actpass=0

si %errorcode% EQU 0 si %_actpass% EQU 0 (
si t_name est défini (
echo %prodname% est activé avec succès pour %gpr2% jours.
) autre (
appel :dk_color %Green% "%prodname% est activé avec succès pour %gpr2% jours."
)
quitter /b
)

cmd /c exit /b %code d'erreur%
si t_name est défini (
L'activation de %prodname% a échoué [0x!=ExitCode!]. Durée restante : %gpr2% jours [%gpr% minutes].
) autre (
appel :dk_color %Red% "%prodname% n'a pas pu être activé [0x!=ExitCode!]. Période restante : %gpr2% jours [%gpr% minutes].
)
définir _tserror=1
quitter /b

:=================================================================================================================================================

:_tâche

:: Vérifier l'activation KMS38

définir gpr=0
définir _kms38=0
si défini sppwid si %winbuild% GEQ 14393 (
définir _chemin=%slp%
définir _actid=%sppwid%
appel :_taskgetgrace
)

si %gpr% NEQ 0 si %gpr% GTR 259200 (
définir _kms38=1
appel :_taskchkEnterpriseG _kms38
)

:: Définissez l'hôte KMS spécifique sur Hôte local afin que l'adresse IP KMS globale ne puisse pas remplacer l'activation KMS38 mais puisse être utilisée avec Office et d'autres éditions de Windows.

si %_kms38% ÉGAL 1 (
%nul% reg ajoute "HKLM\%SPPk%\%_wApp%\%sppwid%" /f /v KeyManagementServiceName /t REG_SZ /d "127.0.0.2"
%nul% reg ajoute "HKLM\%SPPk%\%_wApp%\%sppwid%" /f /v KeyManagementServicePort /t REG_SZ /d "1688"
)

écho:
si défini sppwid (
définir _chemin=%slp%
définir _actid=%sppwid%
appel :_act act_win
appel :_actinfo act_win
) autre (
Si t_name est défini, afficher « Vérification : La version volume de Windows n'est pas installée »
)

si sppoïde défini (
définir _chemin=%slp%
pour %%# dans (%sppoid%) faire (
définir _actid=%%#
appel :_act
si non défini _taskskip appel :_actinfo
)
)

si osppid est défini (
définir _chemin=%ospp%
pour %%# dans (%osppid%) faire (
définir _actid=%%#
appel :_act
si non défini _taskskip appel :_actinfo
)
)

si non défini sppoid si non défini osppid si défini t_name (
écho:
vérification en cours : la version en volume d’Office n’est pas installée.
)

quitter /b

:=================================================================================================================================================

:_taskgetids

définir %1=
si %_wmic% EQU 1 définir "chkapp=for /f "tokens=2 delims==" %%a in ('"wmic path %2 where (Name like '%%%3%%' and Description like '%%KMSCLIENT%%' and PartialProductKey is not NULL AND LicenseDependsOn is NULL) get ID /VALUE" 2^>nul')"
si %_wmic% EQU 0 définir "chkapp=for /f "tokens=2 delims==" %%a dans ('%psc% "(([WMISEARCHER]'SELECT ID FROM %2 WHERE Name like ''%%%3%%'' and Description like ''%%KMSCLIENT%%'' and PartialProductKey is not NULL AND LicenseDependsOn is NULL').Get()).ID ^| %% {echo ('ID='+$_)}" 2^>nul')"
%chkapp% faire (si défini %1 (appeler set "%1=!%1! %%a") sinon (appeler set "%1=%%a"))
quitter /b

:_taskgetgrace

définir gpr=0
si %_wmic% EQU 1 pour /f "tokens=2 delims==" %%# dans ('"wmic path !_path! where ID='!_actid!' get GracePeriodRemaining /VALUE" 2^>nul') faire appel à set "gpr=%%#"
si %_wmic% EQU 0 pour /f "tokens=2 delims==" %%# dans ('%psc% "(([WMISEARCHER]'SELECT GracePeriodRemaining FROM !_path! where ID=''!_actid!''').Get()).GracePeriodRemaining | %% {echo ('GracePeriodRemaining='+$_)}" 2^>nul') faire appel à set "gpr=%%#"
quitter /b

:_taskchkEnterpriseG

pour %%# dans (e0b2d383-d112-413f-8a80-97f373a5820c e38454fb-41a4-4f59-a5dc-25080e354730) faire (si %sppwid%==%%# définir %1=0)
quitter /b

:=================================================================================================================================================

:: Nettoyer le cache KMS existant du registre

:_taskclear-cache

définir w=
pour %%# dans (SppE%w%xtComObj.exe sppsvc.exe SLsvc.exe) faire (
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Ima%w%ge File Execu%w%tion Options\%%#" /f %nul%
)

définir « OPPk=SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform »

si %winbuild% LSS 7600 (
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SL" %nul% && (
définir "SPPk=SOFTWARE\Microsoft\Windows NT\CurrentVersion\SL"
)
)
si SPPk n'est pas défini (
définir "SPPk=SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform"
)

définir "slp=SoftwareLicensingProduct"
définir "ospp=OfficeSoftwareProtectionProduct"

définir "_wApp=55c92734-d682-4d71-983e-d6ec3f16059f"
définir "_oApp=0ff1ce15-a989-479d-af46-f275c6370663"
définir "_oA14=59a52881-a989-479d-af46-f275c6370663"

%nul% reg delete "HKLM\%SPPk%" /f /v KeyManagementServiceName
%nul% reg delete "HKLM\%SPPk%" /f /v KeyManagementServiceName /reg:32
%nul% reg supprimer "HKLM\%SPPk%" /f /v KeyManagementServicePort
%nul% reg supprimer "HKLM\%SPPk%" /f /v KeyManagementServicePort /reg:32
%nul% reg delete "HKLM\%SPPk%" /f /v DisableDnsPublishing
%nul% reg delete "HKLM\%SPPk%" /f /v DisableKeyManagementServiceHostCaching
%nul% reg supprimer "HKLM\%SPPk%\%_wApp%" /f
si %winbuild% GEQ 9200 (
%nul% reg delete "HKLM\%SPPk%\%_oApp%" /f
%nul% reg supprimer "HKLM\%SPPk%\%_oApp%" /f /reg:32
)
si %winbuild% GEQ 9600 (
%nul% reg supprimer "HKU\S-1-5-20\%SPPk%\%_wApp%" /f
%nul% reg supprimer "HKU\S-1-5-20\%SPPk%\%_oApp%" /f
)
%nul% reg supprimer "HKLM\%OPPk%" /f /v KeyManagementServiceName
%nul% reg supprimer "HKLM\%OPPk%" /f /v KeyManagementServicePort
%nul% reg delete "HKLM\%OPPk%" /f /v DisableDnsPublishing
%nul% reg delete "HKLM\%OPPk%" /f /v DisableKeyManagementServiceHostCaching
%nul% reg supprimer "HKLM\%OPPk%\%_oA14%" /f
%nul% reg delete "HKLM\%OPPk%\%_oApp%" /f

quitter /b

:=================================================================================================================================================

:_taskregserv

si _serveur est défini (définir KMS_IP=%_serveur%)
si non défini, _port est défini sur _port=1688

%nul% reg add "HKLM\%SPPk%" /f /v KeyManagementServiceName /t REG_SZ /d "%KMS_IP%"
%nul% reg add "HKLM\%SPPk%" /f /v KeyManagementServiceName /t REG_SZ /d "%KMS_IP%" /reg:32
%nul% reg add "HKLM\%SPPk%" /f /v KeyManagementServicePort /t REG_SZ /d "%_port%"
%nul% reg add "HKLM\%SPPk%" /f /v KeyManagementServicePort /t REG_SZ /d "%_port%" /reg:32

%nul% reg add "HKLM\%OPPk%" /f /v KeyManagementServiceName /t REG_SZ /d "%KMS_IP%"
%nul% reg ajoute "HKLM\%OPPk%" /f /v KeyManagementServicePort /t REG_SZ /d "%_port%"

si %winbuild% GEQ 9200 (
%nul% reg add "HKLM\%SPPk%\%_oApp%" /f /v KeyManagementServiceName /t REG_SZ /d "%KMS_IP%"
%nul% reg add "HKLM\%SPPk%\%_oApp%" /f /v KeyManagementServiceName /t REG_SZ /d "%KMS_IP%" /reg:32
%nul% reg add "HKLM\%SPPk%\%_oApp%" /f /v KeyManagementServicePort /t REG_SZ /d "%_port%"
%nul% reg add "HKLM\%SPPk%\%_oApp%" /f /v KeyManagementServicePort /t REG_SZ /d "%_port%" /reg:32
)
quitter /b

:=================================================================================================================================================

:_tasksetserv

:: Intégration de plusieurs serveurs KMS et randomisation des serveurs

définir srvlist=
ensemble -=

définir "srvlist=kms.03%-%k.org kms-default.cangs%-%hui.net kms.six%-%yin.com kms.moe%-%club.org kms.cgt%-%soft.com"
définir "srvlist=%srvlist% kms.id%-%ina.cn kms.moe%-%yuuko.com xinch%-%eng213618.cn kms.lol%-%i.best kms.mc%-%06.net"
définir "srvlist=%srvlist% kms.0%-%t.net.cn win.k%-%ms.pub kms.wx%-%lost.com kms.moe%-%yuuko.top kms.gh%-%xi.com"

définir n=1
pour %%a dans (%srvlist%) faire (définir %%a=&définir serveur!n!=%%a&définir /a n+=1)
définir max_servers=15
définir /a server_num=0
quitter /b

:_taskgetserv

si %server_num% geq %max_servers% (set /a server_num+=1&set KMS_IP=222.184.9.98&exit /b)
définir /a rand=%Random%%%(15+1-1)+1
Si le serveur %rand% est défini, aller à :_taskgetserv
définir KMS_IP=!serveur%rand%!
définir !serveur%rand%!=1

:: Obtenir l'adresse IPv4 du serveur KMS à utiliser pour l'activation, fonctionne même si l'écho ICMP est désactivé.
:: Microsoft et les antivirus peuvent signaler le problème si le nom d'hôte public du serveur KMS est utilisé directement pour l'activation.

définir /a server_num+=1
(for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %KMS_IP% 2^>nul') do set "KMS_IP=%%a"
si "%KMS_IP%"=="!KMS_IP!" pour /f "delims=[] tokens=2" %%# dans ('pathping -4 -h 1 -n -p 1 -q 1 -w 1 %KMS_IP% 2^>nul') faire définir "KMS_IP=%%#"
if not "%KMS_IP%"=="!KMS_IP!" exit /b
aller à :_taskgetserv
)
::Ver:2.7
:_extrairetâche:

:=================================================================================================================================================

:ks_renouvellement

définir erreur_=
définir "_dest=%ProgramFiles%\Activation-Renewal"
définir "clé=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\taskcache\tasks"

appel :ks_clearstuff %nul%

si erreur_ définie (
définir erreur=1
appel :dk_color %Red% "Échec de la suppression de la tâche de renouvellement précédente. Redémarrez le système / Réessayez."
quitter /b
)

si "%_dest%\" n'existe pas md "%_dest%\" %nul%
pour /f %%G dans ('%psc% "[Guid]::NewGuid().Guid"') faire définir "randguid=%%G"
définir "_temp=%SystemRoot%\Temp\%Random%%randguid%"

définir nil=
si %winbuild% LSS 7600 (définir _vista=_vista)
si le répertoire "%_temp%\.*" existe, supprimez-le avec la commande /s /q "%_temp%\" %nul%
md "%_temp%\" %nul%
appel :ks_RenExport renouvellement%_vista% "%_temp%\Renewal.xml" Unicode
si non défini _int (appel :ks_RenExport run_once%_vista% "%_temp%\Run_Once.xml" Unicode)
s%nil%cht%nil%asks /cre%nil%ate /tn "Activation-Renewal" /ru "SYS%nil%TEM" /xml "%_temp%\Renewal.xml" %nul%
si non défini _int (s%nil%cht%nil%asks /cre%nil%ate /tn "Activation-Run_Once" /ru "SYS%nil%TEM" /xml "%_temp%\Run_Once.xml" %nul%)
si le répertoire "%_temp%\.*" existe, supprimez-le avec la commande /s /q "%_temp%\" %nul%

appel :ks_createInfo.txt
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split \":_extracttask\:.*`r`n\"; [io.file]::WriteAllText('%_dest%\Activation_task.cmd', '@::%randguid%' + [Environment]::NewLine + $f[1].Trim(), [System.Text.Encoding]::ASCII)"

:=================================================================================================================================================

reg query "%key%" /f Path /s | find /i "\Activation-Renewal" >nul || (set error_=1)
if not defined _int reg query "%key%" /f Path /s | find /i "\Activation-Run_Once" >nul || (set error_=1)

Si le fichier « %_dest%\Activation_task.cmd » n'existe pas (définir error_=1)
Si le fichier « %_dest%\Info.txt » n'existe pas (définir error_=1)

si erreur_ définie (
schtasks /delete /tn Activation-Renewal /f %nul%
schtasks /delete /tn Activation-Run_Once /f %nul%
rmdir /s /q "%_dest%\" %nul%
définir erreur=1
appel :dk_color %Red% "Échec de l'installation de la tâche de renouvellement. Redémarrez le système / Réessayez."
quitter /b
)

si "%keyerror%"=="0" si non défini _tserror (
appel :dk_color %Green% "La tâche de renouvellement pour l'activation à vie a été installée avec succès dans %_dest%"
quitter /b
)
echo La tâche de renouvellement pour l'activation à vie a été installée avec succès dans %_dest%
quitter /b

:: Extraire le texte d'un script batch sans problème d'encodage de caractères ou de fichiers

:ks_RenExport

%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split \":%~1\:.*`r`n\"; [io.file]::WriteAllText('%~2',$f[1].Trim(),[System.Text.Encoding]::%~3);"
quitter /b

:=================================================================================================================================================

:ks_createInfo.txt

(
echo Ce script sert à renouveler votre licence Windows/Office via KMS en ligne.
écho:
Si des tâches planifiées de renouvellement/activation ont été créées, les éléments suivants existeront :
écho:
écho - Tâches planifiées
Écho Activation-Renouvellement [Renouvellement / Hebdomadaire]
echo Activation-Run_Once [Tâche d'activation - se supprime automatiquement une fois activée]
Les tâches planifiées ne s'exécutent que si le système est connecté à Internet.
écho:
écho - Fichiers
echo C:\Program Files\Activation-Renewal\Activation_task.cmd
echo C:\Program Files\Activation-Renewal\Info.txt
echo C:\Program Files\Activation-Renewal\Logs.txt
écho ______________________________________________________________________________________________
écho:
echo Ce script fait partie du projet MAS.
écho:   
echo Page d'accueil : mass%w%grave%w%.dev
)>"%_dest%\Info.txt"
quitter /b

:=================================================================================================================================================

:renouvellement:
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Source>Microsoft Corporation</Source>
    <Date>1999-01-01T12:00:00.34375</Date>
    <Auteur>Accro à Windows</Auteur>
    <Version>1.0</Version>
    <Description>Activation et renouvellement du KMS en ligne - Tâche hebdomadaire</Description>
    <URI>\Activation-Renewal</URI>
    <SecurityDescriptor>D:P(A;;FA;;;SY)(A;;FA;;;BA)(A;;FRFX;;;LS)(A;;FRFW;;;S-1-5-80-12323 1216-2592883651-3715271367-3753151631-4175906628)(A;;FR;;;S-1-5-4)</SecurityDescriptor>
  </RegistrationInfo>
  <Déclencheurs>
    <CalendarTrigger>
      <StartBoundary>1999-01-01T12:00:00</StartBoundary>
      <Activé>true</Activé>
      <ScheduleByWeek>
        <JoursDeLaSemaine>
          <Dimanche />
        </JoursDeLaSemaine>
        <WeeksInterval>1</WeeksInterval>
      </ScheduleByWeek>
    </CalendarTrigger>
  </Triggers>
  <Directeurs>
    <Principal id="LocalSystem">
      <UserId>S-1-5-18</UserId>
      <RunLevel>Le plus haut disponible</RunLevel>
    </Principal>
  </Principaux>
  <Paramètres>
    <MultipleInstancesPolicy>IgnorerNouveau</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>true</RunOnlyIfNetworkAvailable>
    <Paramètres d'inactivité>
      <StopOnIdleEnd>faux</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Activé>true</Activé>
    <Caché>vrai</Caché>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>
    <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT10M</ExecutionTimeLimit>
    <Priorité>7</Priorité>
    <RedémarrerEnÉchec>
      <Interval>PT2M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Paramètres>
  <Actions Context="LocalSystem">
    <Exec>
      <Command>%ProgramFiles%\Activation-Renewal\Activation_task.cmd</Command>
    <Arguments>Tâche</Arguments>
    </Exec>
  </Actions>
</Tâche>
:renouvellement:

:run_once:
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Source>Microsoft Corporation</Source>
    <Date>1999-01-01T12:00:00.34375</Date>
    <Auteur>Accro à Windows</Auteur>
    <Version>1.0</Version>
    <Description>Activation KMS en ligne : exécution unique – s’exécute et se supprime automatiquement lors de la première connexion Internet</Description>
    <URI>\Activation-Run_Once</URI>
    <SecurityDescriptor>D:P(A;;FA;;;SY)(A;;FA;;;BA)(A;;FRFX;;;LS)(A;;FRFW;;;S-1-5-80-12323 1216-2592883651-3715271367-3753151631-4175906628)(A;;FR;;;S-1-5-4)</SecurityDescriptor>
  </RegistrationInfo>
  <Déclencheurs>
    <Déclencheur de connexion>
      <Activé>true</Activé>
    </LogonTrigger>
  </Triggers>
  <Directeurs>
    <Principal id="LocalSystem">
      <UserId>S-1-5-18</UserId>
      <RunLevel>Le plus haut disponible</RunLevel>
    </Principal>
  </Principaux>
  <Paramètres>
    <MultipleInstancesPolicy>IgnorerNouveau</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>true</RunOnlyIfNetworkAvailable>
    <Paramètres d'inactivité>
      <StopOnIdleEnd>faux</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Activé>true</Activé>
    <Caché>vrai</Caché>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>
    <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT10M</ExecutionTimeLimit>
    <Priorité>7</Priorité>
    <RedémarrerEnÉchec>
      <Interval>PT2M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Paramètres>
  <Actions Context="LocalSystem">
    <Exec>
      <Command>%ProgramFiles%\Activation-Renewal\Activation_task.cmd</Command>
    <Arguments>Tâche</Arguments>
    </Exec>
  </Actions>
</Tâche>
:run_once:

:renewal_vista:
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>1999-01-01T12:00:00.34375</Date>
    <Auteur>Accro à Windows</Auteur>
    <Description>Activation et renouvellement du KMS en ligne - Tâche hebdomadaire</Description>
  </RegistrationInfo>
  <Déclencheurs>
    <CalendarTrigger>
      <StartBoundary>1999-01-01T12:00:00.34375</StartBoundary>
      <Activé>true</Activé>
      <ScheduleByWeek>
        <JoursDeLaSemaine>
          <Dimanche />
        </JoursDeLaSemaine>
        <WeeksInterval>1</WeeksInterval>
      </ScheduleByWeek>
    </CalendarTrigger>
  </Triggers>
  <Directeurs>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>Le plus haut disponible</RunLevel>
    </Principal>
  </Principaux>
  <Paramètres>
    <Paramètres d'inactivité>
      <Durée>PT10M</Durée>
      <WaitTimeout>PT1H</WaitTimeout>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <MultipleInstancesPolicy>IgnorerNouveau</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>true</RunOnlyIfNetworkAvailable>
    <NetworkSettings />
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Activé>true</Activé>
    <Caché>false</Caché>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT10M</ExecutionTimeLimit>
    <Priorité>7</Priorité>
    <RedémarrerEnÉchec>
      <Interval>PT5M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Paramètres>
  <Actions Context="Auteur">
    <Exec>
      <Command>%ProgramFiles%\Activation-Renewal\Activation_task.cmd</Command>
      <Arguments>Tâche</Arguments>
    </Exec>
  </Actions>
</Tâche>
:renewal_vista:

:run_once_vista:
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>1999-01-01T12:00:00.34375</Date>
    <Auteur>Accro à Windows</Auteur>
    <Description>Activation KMS en ligne : exécution unique – s’exécute et se supprime automatiquement lors de la première connexion Internet</Description>
  </RegistrationInfo>
  <Déclencheurs>
    <Déclencheur de connexion>
      <Activé>true</Activé>
    </LogonTrigger>
  </Triggers>
  <Directeurs>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>Le plus haut disponible</RunLevel>
    </Principal>
  </Principaux>
  <Paramètres>
    <Paramètres d'inactivité>
      <Durée>PT10M</Durée>
      <WaitTimeout>PT1H</WaitTimeout>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <MultipleInstancesPolicy>IgnorerNouveau</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>true</RunOnlyIfNetworkAvailable>
    <NetworkSettings />
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Activé>true</Activé>
    <Caché>false</Caché>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT10M</ExecutionTimeLimit>
    <Priorité>7</Priorité>
    <RedémarrerEnÉchec>
      <Interval>PT5M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Paramètres>
  <Actions Context="Auteur">
    <Exec>
      <Command>%ProgramFiles%\Activation-Renewal\Activation_task.cmd</Command>
      <Arguments>Tâche</Arguments>
    </Exec>
  </Actions>
</Tâche>
:run_once_vista:

:=================================================================================================================================================

:: Obtenir le canal de clé d'installation Windows

:k_channel

définir _gvlk=
si %_wmic% EQU 1 pour /f "tokens=2 delims==" %%# dans ('wmic path %spp% where "ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' and PartialProductKey IS NOT NULL AND LicenseDependsOn is NULL and Description like '%%KMSCLIENT%%'" Get Name /value %nul6%') faire (echo %%# findstr /i "Windows" %nul1% && set _gvlk=1)
si %_wmic% EQU 0 pour /f "tokens=2 delims==" %%# dans ('%psc% "(([WMISEARCHER]'SELECT Name FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND PartialProductKey IS NOT NULL AND LicenseDependsOn is NULL and Description like ''%%KMSCLIENT%%''').Get()).Name | %% {echo ('Name='+$_)}" %nul6%') faire (echo %%# findstr /i "Windows" %nul1% && set _gvlk=1)
quitter /b


:=================================================================================================================================================

:: Obtenez la clé de produit à partir de pkeyhelper.dll pour les futures nouvelles éditions
:: Il fonctionne sur Windows 10 1803 (17134) et versions ultérieures.

:k_pkey

appel :dk_reflection

définir d1=%ref% [void]$TypeBuilder.DefinePInvokeMethod('SkuGetProductKeyForEdition', 'pkeyhelper.dll', 'Public, Static', 1, [int], @([int], [String], [String].MakeByRefType(), [String].MakeByRefType()), 1, 3);
définir d1=%d1% $out = ''; [void]$TypeBuilder.CreateType()::SkuGetProductKeyForEdition(%1, %2, [ref]$out, [ref]$null); $out

définir pkey=
pour /f %%a dans ('%psc% "%d1%"') faire si non errorlevel 1 (définir pkey=%%a)
quitter /b

:: Obtenir le nom du canal pour la clé extraite de pkeyhelper.dll

:k_pkeychannel

définir k=%1
définir m=[Runtime.InteropServices.Marshal]
définir p=%SysPath%\spp\tokens\pkeyconfig\pkeyconfig.xrm-ms

définir d1=%ref% [void]$TypeBuilder.DefinePInvokeMethod('PidGenX', 'pidgenx.dll', 'Public, Static', 1, [int], @([String], [String], [String], [int], [IntPtr], [IntPtr], [IntPtr]), 1, 3);
définir d1=%d1% $r = [byte[]]::new(0x04F8); $r[0] = 0xF8; $r[1] = 0x04; $f = %m%::AllocHGlobal(0x04F8); %m%::Copy($r, 0, $f, 0x04F8);
définir d1=%d1% [void]$TypeBuilder.CreateType()::PidGenX('%k%', '%p%', '00000', 0, 0, 0, $f); %m%::Copy($f, $r, 0, 0x04F8); %m%::FreeHGlobal($f); [Text.Encoding]::Unicode.GetString($r, 1016, 128)

définir pkeychannel=
pour /f %%a dans ('%psc% "%d1%"') faire si ce n'est pas errorlevel 1 (définir pkeychannel=%%a)
quitter /b

:k_gvlk

for %%# in (pkeyhelper.dll) do @if "%%~$PATH:#"=="" exit /b
pour %%# dans (Volume:GVLK) faire (
appel :k_pkey %osSKU% '%%#'
si pkey est défini, appelez :k_pkeychannel !pkey!
si /i "!pkeychannel!"=="%%#" (
définir la clé=!pkey!
quitter /b
)
)
quitter /b

:=================================================================================================================================================

:: 1ère colonne = Numéro de version d'Office
:: 2e colonne = ID d'activation
:: 3e colonne = ID du produit dans branding.xml
:: 4e colonne = Édition
:: 5e colonne = Identifiants des autres éditions si elles font partie du même produit principal (À titre indicatif uniquement)
:: Séparateur = "_"

:msiofficedata

pour %%# dans (
14_4d463c2c-0505-4626-8cdb-a4da82e2d8ed_0015_AccessR
14_745fb377-0a59-4ca9-b9a9-c359557a2c4e_001C_AccessRuntimeR
14_95ab3ec8-4106-4f9d-b632-03c019d1d23f_0015_AccessVL
14_4eaff0d0-c6cb-4187-94f3-c7656d49a0aa_0016_ExcelR_[HSExcelR]
14_71dc86ff-f056-40d0-8ffb-9592705c9b76_0016_ExcelVL
14_7004b7f0-6407-4f45-8eac-966e5f868bde_00BA_GrooveR
14_fdad0dfa-417d-4b4f-93e4-64ea8867b7fd_00BA_GrooveVL
14_7b7d1f17-fdcb-4820-9789-9bec6e377821_0013_HomeBusinessR_[HomeBusinessDemoR]
14_19316117-30a8-4773-8fd9-7f7231f4e060_011E_HomeBusinessSubR
14_09e2d37e-474b-4121-8626-58ad9be5776f_002F_HomeStudentR_[HomeStudentDemoR]
14_ef1da464-01c8-43a6-91af-e4e5713744f9_0044_InfoPathR
14_85e22450-b741-430c-a172-a37962c938af_0044_InfoPathVL
14_14f5946a-debc-4716-babc-7e2c240fec08_000F_MondoR
14_533b656a-4425-480b-8e30-1a2358898350_000F_MondoVL
14_c1ceda8b-c578-4d5d-a4aa-23626be4e234_003D_ProfessionalR_[OEM-SingleImage]Exception
14_3f7aa693-9a7e-44fc-9309-bb3d8e604925_00A1_OneNoteR_[HSOneNoteR]
14_6860b31f-6a67-48b8-84b9-e312b3485c4b_00A1_OneNoteVL
14_fbf4ac36-31c8-4340-8666-79873129cf40_001A_OutlookR
14_a9aeabd8-63b8-4079-a28e-f531807fd6b8_001A_OutlookVL
14_acb51361-c0db-4895-9497-1831c41f31a6_0033_PersonalR_[PersonalDemoR,PersonalPrepaidR]
14_133c8359-4e93-4241-8118-30bb18737ea0_0018_PowerPointR_[HSPowerPointR]
14_38252940-718c-4aa6-81a4-135398e53851_0018_PowerPointVL
14_8b559c37-0117-413e-921b-b853aeb6e210_0014_ProfessionalR_[ProfessionalAcadR,ProfessionalDemoR]
14_725714d7-d58f-4d12-9fa8-35873c6f7215_003B_ProjectProR_[ProjectProMSDNR]
14_4d06f72e-fd50-4bc2-a24b-d448d7f17ef2_011F_ProjectProSubR
14_1cf57a59-c532-4e56-9a7d-ffa2fe94b474_003B_ProjectProVL
14_688f6589-2bd9-424e-a152-b13f36aa6de1_003A_ProjectStdR
14_11b39439-6b93-4642-9570-f2eb81be2238_003A_ProjectStdVL
14_71af7e84-93e6-4363-9b69-699e04e74071_0011_ProPlusR_[ProPlusAcadR,ProPlusMSDNR,Sub4R]
14_e98ef0c0-71c4-42ce-8305-287d8721e26c_011D_ProPlusSubR
14_fdf3ecb9-b56f-43b2-a9b8-1b48b6bae1a7_0011_ProPlusVL_[ProPlusAcadVL]
14_98677603-a668-4fa4-9980-3f1f05f78f69_0019_ÉditeurR
14_3d014759-b128-4466-9018-e80f6320d9d0_0019_PublisherVL
14_dbe3aee0-5183-4ff7-8142-66050173cb01_008B_SmallBusBasicsR_[SmallBusBasicsMSDNR]
14_8090771e-d41a-4482-929e-de87f1f47e46_008B_SmallBusBasicsVL
14_b78df69e-0966-40b1-ae85-30a5134dedd0_0017_SPDR
14_d3422cfb-8d8b-4ead-99f9-eab0ccd990d7_0012_StandardR
14_1f76e346-e0be-49bc-9954-70ec53a4fcfe_0012_StandardVL_[StandardAcadVL]
14_2745e581-565a-4670-ae90-6bf7c57ffe43_0066_StarterR
14_66cad568-c2dc-459d-93ec-2f3cb967ee34_0057_VisioSIR_Prem[Pro,Std]Exception
14_36756cb8-8e69-4d11-9522-68899507cd6a_0057_VisioSIVL_Prem[Pro,Std]Exception
14_db3bbc9c-ce52-41d1-a46f-1a1d68059119_001B_WordR_[HSWordR]
14_98d4050e-9c98-49bf-9be1-85e12eb3ab13_001B_WordVL
:: Office 2013
15_ab4d047b-97cf-4126-a69f-34df08e2f254_0015_AccessRetail
15_259de5be-492b-44b3-9d78-9645f848f7b0_001C_AccessRuntimeRetail
15_4374022d-56b8-48c1-9bb7-d8f2fc726343_0015_AccessVolume
15_1b1d9bd5-12ea-4063-964c-16e7e87d6e08_0016_ExcelRetail
15_ac1ae7fd-b949-4e04-a330-849bc40638cf_0016_ExcelVolume
15_cfaf5356-49e3-48a8-ab3c-e729ab791250_00BA_GrooveRetail
15_4825ac28-ce41-45a7-9e6e-1fed74057601_00BA_GrooveVolume
15_c02fb62e-1cd5-4e18-ba25-e0480467ffaa_00E7_HomeBusinessPipcRetail
15_cd256150-a898-441f-aac0-9f8f33390e45_0013_Commerce à domicile
15_1fdfb4e4-f9c9-41c4-b055-c80daf00697d_00CE_HomeStudentARMRetail
15_ebef9f05-5273-404a-9253-c5e252f50555_00DA_HomeStudentPlusARMRetail
15_98685d21-78bd-4c62-bc4f-653344a63035_002F_HomeStudentRetail
15_44984381-406e-4a35-b1c3-e54f499556e2_0044_InfoPathRetail
15_9e016989-4007-42a6-8051-64eb97110cf2_0044_InfoPathVolume
15_9103f3ce-1084-447a-827e-d6097f68c895_00EA_LyncAcademicRetail
15_ff693bf4-0276-4ddb-bb42-74ef1a0c9f4d_012D_LyncEntryRetail
15_fada6658-bfc6-4c4e-825a-59a89822cda8_012C_LyncRetail
15_e1264e10-afaf-4439-a98b-256df8bb156f_012C_LyncVolume
15_3169c8df-f659-4f95-9cc6-3115e6596e83_000F_MondoRetail
15_f33485a0-310b-4b72-9a0e-b1d605510dbd_000F_MondoVolume
15_3391e125-f6e4-4b1e-899c-a25e6092d40d_00A1_OneNoteFreeRetail
15_8b524bcc-67ea-4876-a509-45e46f6347e8_00A1_OneNoteRetail
15_b067e965-7521-455b-b9f7-c740204578a2_00A1_OneNoteVolume
15_12004b48-e6c8-4ffa-ad5a-ac8d4467765a_001A_OutlookRetail
15_8d577c50-ae5e-47fd-a240-24986f73d503_001A_OutlookVolume
15_5aab8561-1686-43f7-9ff5-2c861da58d17_00E6_PersonalPipcRetail
15_17e9df2d-ed91-4382-904b-4fed6a12caf0_0033_PersonalRetail
15_31743b82-bfbc-44b6-aa12-85d42e644d5b_0018_PowerPointRetail
15_e40dcb44-1d5c-4085-8e8f-943f33c4f004_0018_PowerPointVolume
15_4e26cac1-e15a-4467-9069-cb47b67fe191_00E8_ProfessionalPipcRetail
15_44bc70e2-fb83-4b09-9082-e5557e0c2ede_0014_Commerce de détail professionnel
15_f2435de4-5fc0-4e5b-ac97-34f515ec5ee7_003B_ProjectProRetail
15_ed34dc89-1c27-4ecd-8b2f-63d0f4cedc32_003B_ProjectProVolume
15_5517e6a2-739b-4822-946f-7f0f1c5934b1_003A_ProjectStdRetail
15_2b9e4a37-6230-4b42-bee2-e25ce86c8c7a_003A_VolumeStandardDuProjet
15_064383fa-1538-491c-859b-0ecab169a0ab_0011_ProPlusRetail
15_2b88c4f2-ea8f-43cd-805e-4d41346e18a7_0011_ProPlusVolume
15_c3a0814a-70a4-471f-af37-2313a6331111_0019_PublisherRetail
15_38ea49f6-ad1d-43f1-9888-99a35d7c9409_0019_ÉditeurVolume
15_ba3e3833-6a7e-445a-89d0-7802a9a68588_0017_SPDRetail
15_32255c0a-16b4-4ce2-b388-8a4267e219eb_0012_StandardRetail
15_a24cca51-3d54-4c41-8a76-4031f5338cb2_0012_StandardVolume
15_15d12ad4-622d-4257-976c-5eb3282fb93d_0051_VisioProRetail
15_3e4294dd-a765-49bc-8dbd-cf8b62a4bd3d_0051_VisioProVolume
15_dae597ce-5823-4c77-9580-7268b93a4b23_0053_VisioStdRetail
15_44a1f6ff-0876-4edb-9169-dbb43101ee89_0053_VisioStdVolume
15_191509f2-6977-456f-ab30-cf0492b1e93a_001B_WordRetail
15_9cedef15-be37-4ff0-a08a-13a045540641_001B_VolumeDeMots
:: Office 365 - Version 15.0
15_befee371-a2f5-4648-85db-a2c55fdf324c_00E9_O365CommerceDeDétail
15_537ea5b5-7d50-4876-bd38-a53a77caca32_00D6_O365HomePremRetail
15_149dbce7-a48e-44db-8364-a53386cd4580_00D4_O365ProPlusRetail
15_bacd4614-5bef-4a5e-bafc-de4c788037a2_00D5_O365SmallBusPremRetail
:: Office 365 - Version 16.0
16_6337137e-7c07-4197-8986-bece6a76fc33_00E9_O365BusinessRetail
16_2f5c71b4-5b7a-4005-bb68-f9fac26f2ea3_00D6_O365EduCloudRetail
16_537ea5b5-7d50-4876-bd38-a53a77caca32_00D6_O365HomePremRetail
16_149dbce7-a48e-44db-8364-a53386cd4580_00D4_O365ProPlusRetail
16_bacd4614-5bef-4a5e-bafc-de4c788037a2_00D5_O365SmallBusPremRetail
:: Office 2016
16_bfa358b0-98f1-4125-842e-585fa13032e6_0015_AccessRetail
16_9d9faf9e-d345-4b49-afce-68cb0a539c7c_001C_AccessRuntimeRetail
16_3b2fa33f-cd5a-43a5-bd95-f49 f3f546b0b_0015_AccessVolume
16_424d52ff-7ad2-4bc7-8ac6-748d767b455d_0016_ExcelRetail
16_685062a7-6024-42e7-8c5f-6bb9e63e697f_0016_ExcelVolume
16_c02fb62e-1cd5-4e18-ba25-e0480467ffaa_00E7_HomeBusinessPipcRetail
16_86834d00-7896-4a38-8fae-32f20b86fa2b_0013_Commerce à domicile
16_090896a0-ea98-48ac-b545-ba5da0eb0c9c_00CE_HomeStudentARMRetail
16_6bbe2077-01a4-4269-bf15-5bf4d8efc0b2_00DA_HomeStudentPlusARMRetail
16_c28acdb8-d8b3-4199-baa4-024d09e97c99_002F_HomeStudentRetail
16_e2127526-b60c-43e0-bed1-3c9dc3d5a468_002F_HomeStudentVNextRetail
16_b21367df-9545-4f02-9f24-240691da0e58_000F_MondoRetail
16_2cd0ea7e-749f-4288-a05e-567c573b2a6c_000F_MondoVolume
16_436366de-5579-4f24-96db-3893e4400030_00A3_OneNoteFreeRetail
16_83ac4dd9-1b93-40ed-aa55-ede25bb6af38_00A1_OneNoteRetail
16_23b672da-a456-4860-a8f3-e062a501d7e8_00A1_OneNoteVolume
16_5a670809-0983-4c2d-8aad-d3c2c5b7d5d1_001A_OutlookRetail
16_50059979-ac6f-4458-9e79-710bcb41721a_001A_OutlookVolume
16_5aab8561-1686-43f7-9ff5-2c861da58d17_00E6_PersonalPipcRetail
16_a9f645a1-0d6a-4978-926a-abcb363b72a6_0033_PersonalRetail
16_f32d1284-0792-49da-9ac6-deb2bc9c80b6_0018_PowerPointRetail
16_9b4060c9-a7f5-4a66-b732-faf248b7240f_0018_PowerPointVolume
16_4e26cac1-e15a-4467-9069-cb47b67fe191_00E8_ProfessionalPipcRetail
16_d64edc00-7453-4301-8428-197343fafb16_0014_ProfessionalRetail
16_0f42f316-00b1-48c5-ada4-2f52b5720ad0_003B_ProjectProRetail
16_82f502b5-b0b0-4349-bd2c-c560df85b248_003B_ProjectProVolume
16_16728639-a9ab-4994-b6d8-f81051e69833_003B_ProjectProXVolume
16_e9f0b3fc-962f-4944-ad06-05c10b6bcd5e_003A_ProjectStdRetail
16_82e6b314-2a62-4e51-9220-61358dd230e6_003A_VolumeStandardDuProjet
16_431058f0-c059-44c5-b9e7-ed2dd46b6789_003A_ProjectStdXVolume
16_de52bd50-9564-4adc-8fcb-a345c17f84f9_0011_ProPlusRetail
16_c47456e3-265d-47b6-8ca0-c30abbd0ca36_0011_ProPlusVolume
16_6e0c1d99-c72e-4968-bcb7-ab79e03e201e_0019_PublisherRetail
16_fcc1757b-5d5f-486a-87cf-c4d6dedb6032_0019_ÉditeurVolume
16_971cd368-f2e1-49c1-aedd-330909ce18b6_012D_SkypeforBusinessEntryRetail
16_418d2b9f-b491-4d7f-84f1-49e27cc66597_012C_SkypeforBusinessRetail
16_03ca3b9a-0869-4749-8988-3cbc9d9f51bb_012C_VolumeSkypeForBusiness
16_9103f3ce-1084-447a-827e-d6097f68c895_012C_SkypeServiceBypassRetail
16_4a31c291-3a12-4c64-b8ab-cd79212be45e_0012_StandardRetail
16_0ed94aac-2234-4309-ba29-74bdbb887083_0012_StandardVolume
16_2dfe2075-2d04-4e43-816a-eb60bbb77574_0051_VisioProRetail
16_295b2c03-4b1c-4221-b292-1411f468bd02_0051_VisioProVolume
16_0594dc12-8444-4912-936a-747ca742dbdb_0051_VisioProXVolume
16_c76dbcbc-d71b-4f45-b5b3-b7494cb4e23e_0053_VisioStdRetail
16_44151c2d-c398-471f-946f-7660542e3369_0053_VisioStdVolume
16_1d1c6879-39a3-47a5-9a6d-aceefa6a289d_0053_VisioStdXVolume
16_cacaa1bf-da53-4c3b-9700-11738ef1c2a5_001B_WordRetail
16_c3000759-551f-4f4a-bcac-a4b42cbf1de2_001B_VolumeDeMots
) faire (
pour /f "tokens=1-5 delims=_" %%A dans ("%%#") faire (

si "%oVer%"="%%A" (
reg query "%1\Registration\{%%B}" /v ProductCode %nul2% | find /i "-%%C-" %nul% && (
reg query "%1\Common\InstalledPackages" %nul2% | find /i "-%%C-" %nul% && (
si _oIds est défini (définir _oIds=!_oIds! %%D) sinon (définir _oIds=%%D)
si /i 003D==%%C définir SingleImage=1
)
)
)

)
)
quitter /b

:=================================================================================================================================================

:: 1ère colonne = ID d'activation
:: 2e colonne = Clés d'activation GVLK / Produits Office gratuits
:: 3e colonne = Dans le cas de Windows, son identifiant SKU. Dans le cas d'Office, sa version d'Office
:: 4e colonne = ID de l'édition
:: 5e colonne = Dans le cas de Windows, nom de la branche de compilation si le même ID d'édition est utilisé dans différentes versions du système d'exploitation avec des clés différentes (à titre indicatif uniquement)
Dans le cas d'Office, il s'agit soit d'un type de clé s'il s'agit d'un produit Office gratuit, soit du nom du produit commercial qui doit être converti en l'identifiant d'édition mentionné dans la 4e colonne.
Dans Office 2010, seule l'édition VL la plus élevée de chaque ID de produit principal est sélectionnée. C'est pourquoi la clé Visio Premium est mentionnée, mais pas pour Visio Pro ni Standard.
:: Séparateur = "_"

:ksdata

définir f=
pour %%# dans (
:: Windows 10/11
73111121-5638-40f6-bc11-f1d7b0d64300_NPPR9-FWDCX-D2C8J-H872K-2Y%f%T43___4_Entreprise
e272e3e2-732f-4c65-a8f0-484747d0d947_DPH2V-TTNVB-4X9Q3-TJR4H-KH%f%JW4__27_EnterpriseN
2de67392-b7a7-462a-b1ca-108dd189f588_W269N-WFGWX-YVC9B-4J6C9-T8%f%3GX__48_Professionnel
a80b5abf-76ad-428b-b05d-a47d2dffeebf_MH37W-N47XK-V7XM9-C7227-GC%f%QG9__49_ProfessionalN
7b9e1751-a8da-4f75-9560-5fadfe3d8e38_3KHY7-WNT83-DGQKR-F7HPR-84%f%4BM__98_CoreN
a9107544-f4a0-4053-a96a-1479abdef912_PVMJN-6DFY6-9CCP6-7BKTT-D3%f%WVR__99_CoreCountrySpecific
cd918a57-a41b-4c82-8dce-1a538e221a83_7HNRX-D7KGG-3K4RQ-4WPJ4-YT%f%DFH_100_CoreSingleLanguage
58e97c99-f377-4ef1-81d5-4ad5522b5fd8_TX9XD-98N7V-6WMQ6-BX7FG-H8%f%Q99_101_Core
e0c42288-980c-4788-a014-c080d2e1926e_NW6C2-QMPVW-D7KKK-3GKT6-VC%f%FB2_121_Éducation
3c102355-d027-42c6-ad23-2e7ef8a02585_2WH4N-8QGBV-H22JP-CT43Q-MD%f%WWJ_122_ÉducationN
32d2fab3-e4a8-42c2-923b-4bf4fd13e6ee_M7XTQ-FN8P6-TTKYV-9D4CC-J4%f%62D_125_EnterpriseS_RS5,VB,Ge
2d5a5a60-3040-48bf-beb0-fcd770c20ce0_DCPHK-NFMTC-H88MJ-PFHPY-QJ%f%4BJ_125_EnterpriseS_RS1
7b51a46c-0c04-4e8f-9af4-8496cca90d5e_WNMTR-4C88C-JK8YV-HQ7T2-76%f%DF9_125_EnterpriseS_TH1
7103a333-b8c8-49cc-93ce-d37c09687f92_92NFX-8DJQP-P6BBQ-THF9C-7C%f%G2H_126_EnterpriseSN_RS5,VB,Ge
9f776d83-7156-45b2-8a5c-359b9c9f22a3_QFFDN-GRT3P-VKWWX-X7T3R-8B%f%639_126_EnterpriseSN_RS1
87b838b7-41b6-4590-8318-5797951d8529_2F77B-TNFGY-69QQF-B8YKP-D6%f%9TJ_126_EnterpriseSN_TH1
82bbc092-bc50-4e16-8e18-b74fc486aec3_NRG8B-VKK3Q-CXVCJ-9G2XF-6Q%f%84J_161_Poste de travail professionnel
4b1571d3-bafb-4b40-8087-a961be2caf65_9FNHH-K3HBT-3W4TD-6383H-6X%f%YWF_162_ProfessionalWorkstationN
3f1afc82-f8ac-4f6c-8005-1d233e606eee_6TP4R-GNPTD-KYYHQ-7B7DP-J4%f%47Y_164_FormationProfessionnelle
5300b18c-2e33-4dc2-8291-47ffcec746dd_YVWGF-BXNMC-HTQYQ-CPQ99-66%f%QFC_165_ProfessionalEducationN
e0b2d383-d112-413f-8a80-97f373a5820c_YYVX9-NTFWV-6MDM3-9PT4T-4M%f%68B_171_EnterpriseG
e38454fb-41a4-4f59-a5dc-25080e354730_44RPN-FTY23-9VTTB-MP9BX-T8%f%4FV_172_EnterpriseGN
ec868e65-fadf-4759-b23e-93fe37f2cc29_CPWHC-NT2C7-VYW78-DHDB2-PG%f%3GK_175_ServerRdsh_RS5
e4db50ea-bda1-4566-b047-0ca50abc6f07_7NBT4-WGBQX-MP4H7-QXFF8-YP%f%3KX_175_ServerRdsh_RS3
0df4f814-3f57-4b8b-9a9d-fddadcd69fac_NBTWJ-3DR69-3C4V8-C26MC-GQ%f%9M6_183_CloudE
59eb965c-9150-42b7-a0ec-22151b9897c5_KBN8V-HFGQ4-MGXVD-347P6-PD%f%QGT_191_IoTEnterpriseS_VB,NI
d30136fc-cb4b-416e-a23d-87207abc44a9_6XN7V-PCBDC-BDBRH-8DQY7-G6%f%R44_202_CloudEditionN
ca7df2e3-5ea0-47b8-9ac1-b1be4d8edd69_37D7F-N49CB-WQR8W-TBJ73-FM%f%8RX_203_CloudEdition
:: Windows 2016/19/22/25 LTSC/SAC
7dc26449-db21-4e09-ba37-28f2958506a6_TVRH6-WHNXV-R9WG3-9XRFY-MY%f%832___7_ServerStandard_Ge
9bd77860-9b31-4b7b-96ad-2564017315bf_VDYBN-27WPP-V4HQT-9VMD4-VM%f%K7H___7_ServerStandard_FE
de32eafd-aaee-4662-9444-c1befb41bde2_N69G4-B89J2-4G8F4-WWYCC-J4%f%64C___7_ServerStandard_RS5
8c1c5410-9f39-4805-8c9d-63a07706358f_WC2BQ-8NRM3-FDDYY-2BFGV-KH%f%KQY___7_ServerStandard_RS1
c052f164-cdf6-409a-a0cb-853ba0f0f55a_D764K-2NDRG-47T6Q-P8T8W-YP%f%6DF___8_ServerDatacenter_Ge
ef6cfc9f-8c5d-44ac-9aad-de6a2ea0ae03_WX4NM-KYWYW-QJJR4-XV3QB-6V%f%M33___8_ServerDatacenter_FE
34e1ae55-27f8-4950-8877-7a03be5fb181_WMDGN-G9PQG-XVVXX-R3X43-63%f%DFG___8_ServerDatacenter_RS5
21c56779-b449-4d20-adfc-eece0e1ad74b_CB7KF-BWN84-R7R2Y-793K2-8X%f%DDG___8_ServerDatacenter_RS1
034d3cbb-5d4b-4245-b3f8-f84571314078_WVDHN-86M7X-466P6-VHXV7-YY%f%726__50_ServerSolution_RS5
2b5a1b0f-a5ab-4c54-ac2f-a6d94824a283_JCKRF-N37P4-C2D82-9YXRT-4M%f%63B__50_ServerSolution_RS1
7b4433f4-b1e7-4788-895a-c45378d38253_QN4C6-GBJD2-FB422-GHWJK-GJ%f%G2R_110_ServerCloudStorage
8de8eb62-bbe0-40ac-ac17-f75595071ea3_GRFBW-QNDC4-6QBHG-CCK3B-2P%f%R88_120_ServerARM64_RS5
43d9af6e-5e86-4be8-a797-d072a046896c_K9FYF-G6NCK-73M32-XMVPY-F9%f%DRR_120_ServerARM64_RS4
39e69c41-42b4-4a0a-abad-8e3c10a797cc_QFND9-D3Y9C-J3KKY-6RPVP-2D%f%PYV_145_ServerDatacenterACor_FE
90c362e5-0da1-4bfd-b53b-b87d309ade43_6NMRW-2C8FM-D24W7-TQWMY-CW%f%H2D_145_ServerDatacenterACor_RS5
e49c08e7-da82-42f8-bde2-b570fbcae76c_2HXDN-KRXHB-GPYC7-YCKFJ-7F%f%VDG_145_ServerDatacenterACor_RS3
f5e9429c-f50b-4b98-b15c-ef92eb5cff39_67KN8-4FYJW-2487Q-MQ2J7-4C%f%4RG_146_ServerStandardACor_FE
73e3957c-fc0c-400d-9184-5f7b6f2eb409_N2KJX-J94YW-TQVFB-DG9YT-72%f%4CC_146_ServerStandardACor_RS5
61c5ef22-f14f-4553-a824-c4b31e84b100_PTXN8-JFHJM-4WC78-MPCBR-9W%f%4KR_146_ServerStandardACor_RS3
45b5aff2-60a0-42f2-bc4b-ec6e5f7b527e_FCNV3-279Q9-BQB46-FTKXX-9H%f%PRH_168_ServerAzureCor_Ge
8c8f0ad3-9a43-4e05-b840-93b8d1475cbc_6N379-GGTMK-23C6M-XVVTC-CK%f%FRQ_168_ServerAzureCor_FE
a99cc1f0-7719-4306-9645-294102fbff95_FDNH6-VW9RW-BXPJ7-4XTYG-23%f%9TB_168_ServerAzureCor_RS5
3dbf341b-5f6c-4fa7-b936-699dce9e263f_VP34G-4NPPG-79JTQ-864T4-R3%f%MQX_168_ServerAzureCor_RS1
c2e946d1-cfa2-4523-8c87-30bc696ee584_XGN3F-F394H-FD2MY-PP6FD-8M%f%CRC_407_ServerTurbine_Ge
19b5e0fb-4431-46bc-bac1-2f1873e4ae73_NTBV8-9K7Q8-V27C6-M2BTV-KH%f%MXV_407_ServerTurbine_RS5
:: Windows 8.1
81671aaf-79d1-4eb1-b004-8cbbe173afea_MHF9N-XY6XB-WVXMC-BTDCT-MK%f%KG7___4_Enterprise
113e705c-fa49-48a4-beea-7dd879b46b14_TT4HM-HN7YT-62K67-RGRQJ-JF%f%FXW__27_EnterpriseN
c06b6981-d7fd-4a35-b7b4-054742b7af67_GCRJD-8NW9H-F2CDX-CCM8D-9D%f%6T9__48_Professionnel
7476d79f-8e48-49b4-ab63-4d0b813a16e4_HMCNV-VVBFX-7HMBH-CTY9B-B4%f%FXY__49_ProfessionalN
f7e88590-dfc7-4c78-bccb-6f3865b99d1a_VHXM3-NR6FT-RY6RT-CK882-KW%f%2CJ__86_EmbeddedIndustryA
0ab82d54-47f4-4acb-818c-cc5bf0ecb649_NMMPB-38DD4-R2823-62W8D-VX%f%KJB__89_EmbeddedIndustry
cd4e2d9f-5059-4a50-a92d-05d5bb1267c7_FNFKF-PWTVT-9RC8H-32HB2-JB%f%34X__91_EmbeddedIndustryE
ffee456a-cd87-4390-8e07-16146c672fd0_XYTND-K6QKT-K2MRH-66RTM-43%f%JKP__97_CoreARM
78558a64-dc19-43fe-a0d0-8075b2a370a3_7B9N3-D94CG-YTVHR-QBPX3-RJ%f%P64__98_CoreN
db78b74f-ef1c-4892-abfe-1e66b8231df6_NCTT7-2RGK8-WMHRF-RY7YQ-JT%f%XG3__99_CoreCountrySpecific
c72c6a1d-f252-4e7e-bdd1-3fca342acb35_BB6NG-PQ82V-VRDPW-8XVD2-V8%f%P66_100_CoreSingleLanguage
fe1c3238-432a-43a1-8e25-97e7d1ef10f3_M9Q9P-WNJJT-6PXPY-DWX8H-6X%f%WKK_101_Core
096ce63d-4fac-48a9-82a9-61ae9e800e5f_789NJ-TQK6T-6XTH8-J39CJ-J8%f%D3P_103_ProfessionalWMC
e9942b32-2e55-4197-b0bd-5ff58cba8860_3PY8R-QHNP9-W7XQD-G6DPH-3J%f%2C9_111_CoreConnected
c6ddecd6-2354-4c19-909b-306a3058484e_Q6HTR-N24GM-PMJFP-69CD8-2G%f%XKR_113_CoreConnectedN
b8f5e3a3-ed33-4608-81e1-37d6c9dcfd9c_KF37N-VDV38-GRRTV-XH8X6-6F%f%3BB_115_CoreConnectedSingleLanguage
ba998212-460a-44db-bfb5-71bf09d1c68b_R962J-37N87-9VVK2-WJ74P-XT%f%MHR_116_CoreConnectedCountrySpecific
e58d87b5-8126-4580-80fb-861b22f79296_MX3RK-9HNGX-K3QKC-6PJ3F-W8%f%D7B_112_ÉtudiantProfessionnel
cab491c7-a918-4f60-b502-dab75e334f40_TNFGH-2R6PB-8XM3K-QYHX2-J4%f%296_114_ProfessionalStudentN
:: Windows Server 2012 R2
b3ca044e-a358-4d68-9883-aaa2941aca99_D2N9P-3P6X9-2R39C-7RTCD-MD%f%VJX___7_ServerStandard
00091344-1ea4-4f37-b789-01750ba6988c_W3GGN-FT8W3-Y4M27-J84CP-Q3%f%VJ9___8_ServeurCentreDeDonnées
21db6ba4-9a7b-4a14-9e29-64a60c59301d_KNC87-3J2TX-XB4WP-VCPJV-M4%f%FWM__50_ServerSolution
b743a2be-68d4-4dd3-af32-92425b7bb623_3NPTF-33KPT-GGBPR-YX76B-39%f%KDD_110_ServerCloudStorage
:: Windows 8
458e1bec-837a-45f6-b9d5-925ed5d299de_32JNW-9KQ84-P47T8-D8GGY-CW%f%CK7___4_Enterprise
e14997e7-800a-4cf7-ad10-de4b45b578db_JMNMF-RHW7P-DMY6X-RF3DR-X2%f%BQT__27_EnterpriseN
a98bcd6d-5343-4603-8afe-5908e4611112_NG4HW-VH26C-733KW-K6F98-J8%f%CK4__48_Professionnel
ebf245c1-29a8-4daf-9cb1-38dfc608a8c8_XCVCF-2NXM9-723PB-MHCB7-2R%f%YQQ__49_ProfessionalN
10018baf-ce21-4060-80bd-47fe74ed4dab_RYXVT-BNQG7-VD29F-DBMRY-HT%f%73M__89_EmbeddedIndustry
18db1848-12e0-4167-b9d7-da7fcda507db_NKB3R-R2F8T-3XCDP-7Q2KW-XW%f%YQ2__91_EmbeddedIndustryE
af35d7b7-5035-4b63-8972-f0b747b9f4dc_DXHJF-N9KQX-MFPVR-GHGQK-Y7%f%RKV__97_CoreARM
197390a0-65f6-4a95-bdc4-55d58a3b0253_8N2M2-HWPGY-7PGT9-HGDD8-GV%f%GGY__98_CoreN
9d5584a2-2d85-419a-982c-a00888bb9ddf_4K36P-JN4VD-GDC6V-KDT89-DY%f%FKP__99_CoreCountrySpecific
8860fcd4-a77b-4a20-9045-a150ff11d609_2WN2H-YGCQR-KFX6K-CD6TF-84%f%YXQ_100_CoreSingleLanguage
c04ed6bf-55c8-4b47-9f8e-5a1f31ceee60_BN3D2-R7TKB-3YPBD-8DRP2-27%f%GG4_101_Core
a00018a3-f20f-4632-bf7c-8daa5351c914_GNBB8-YVD74-QJHX6-27H4K-8Q%f%HDG_103_ProfessionalWMC
:: Windows Server 2012
f0f5ec41-0d55-4732-af02-440a44a3cf0f_XC9B7-NBPP2-83J2H-RHMBY-92%f%BT4___7_ServerStandard
d3643d60-0c42-412d-a7d6-52e6635327f6_48HP8-DN98B-MYWDG-T2DCC-8W%f%83P___8_ServeurCentreDeDonnées
8f365ba6-c1b9-4223-98fc-282a0756a3ed_HTDQM-NBMMG-KGYDT-2DTKT-J2%f%MPV__50_ServerSolution
7d5486c7-e120-4771-b7f1-7b56c6d3170c_HM7DN-YVMH3-46JC3-XYTG7-CY%f%QJJ__76_ServerMultiPointStandard
95fd1c83-7df5-494a-be8b-1300e1c9d1cd_XNH6W-2V9GX-RGJ4K-Y8X6F-QG%f%J2G__77_ServerMultiPointPremium
:: Windows 7
ae2ee509-1b34-41c0-acb7-6d4650168915_33PXH-7Y6KF-2VJC9-XBBR8-HV%f%THH___4_Enterprise
1cb6d605-11b3-4e14-bb30-da91c8e3983a_YDRBP-3D83W-TY26F-D46B2-XC%f%KRJ__27_EnterpriseN
b92e9980-b9d5-4821-9c94-140f632f6312_FJ82H-XT6CR-J8D7P-XQJJ2-GP%f%DD4__48_Professionnel
54a09a0d-d57b-4c10-8b69-a842d6590ad5_MRPKT-YTG23-K7D7T-X2JMM-QY%f%7MG__49_ProfessionnelN
db537896-376f-48ae-a492-53d0547773d0_YBYF6-BHCR3-JPKRB-CDW7B-F9%f%BK4__65_Embedded_POSReady
aa6dd3aa-c2b4-40e2-a544-a6bbb3f5c395_73KQT-CD9G6-K7TQG-66MRP-CQ%f%22C__65_Embedded_ThinPC
5a041529-fef8-4d07-b06f-b59b573b32d2_W82YF-2Q76Y-63HXB-FGJG9-GF%f%7QX__69_ProfessionalE
46bbed08-9c7b-48fc-a614-95250573f4ea_C29WB-22CC8-VJ326-GHFJW-H9%f%DH4__70_EnterpriseE
:: Windows Server 2008 R2
68531fb9-5511-4989-97be-d11a0f55633f_YC6KT-GKW9T-YTKYR-T4X34-R7%f%VHC___7_ServerStandard
7482e61b-c589-4b7f-8ecc-46d455ac3b87_74YFP-3QFB3-KQT8W-PMXWJ-7M%f%648___8_ServerDatacenter
620e2b3d-09e7-42fd-802a-17a13652fe7a_489J6-VHDMP-X63PK-3K798-CP%f%X3Y__10_ServerEnterprise
7482e61b-c589-4b7f-8ecc-46d455ac3b87_74YFP-3QFB3-KQT8W-PMXWJ-7M%f%648__12_ServerDatacenterCore
68531fb9-5511-4989-97be-d11a0f55633f_YC6KT-GKW9T-YTKYR-T4X34-R7%f%VHC__13_ServerStandardCore
620e2b3d-09e7-42fd-802a-17a13652fe7a_489J6-VHDMP-X63PK-3K798-CP%f%X3Y__14_ServerEnterpriseCore
8a26851c-1c7e-48d3-a687-fbca9b9ac16b_GT63C-RJFQ3-4GMB6-BRFB9-CB%f%83V__15_ServerEnterpriseIA64
a78b8bd9-8017-4df5-b86a-09f756affa7c_6TPJF-RBVHG-WBW2R-86QPH-6R%f%TM4__17_ServerWeb
cda18cf3-c196-46ad-b289-60c072869994_TT8MH-CG224-D3D7Q-498W2-9Q%f%CTX__18_ServerHPC
a78b8bd9-8017-4df5-b86a-09f756affa7c_6TPJF-RBVHG-WBW2R-86QPH-6R%f%TM4__29_ServerWebCore
f772515c-0e87-48d5-a676-e6962c3e1195_736RG-XDKJK-V34PF-BHK87-J6%f%X3K__56_ServerEmbeddedSolution
:: Windows Vista
cfd8ff08-c0d7-452b-9f60-ef5c70c32094_VKK3X-68KWM-X2YGT-QR4M6-4B%f%WMV___4_Enterprise
4f3d1606-3fea-4c01-be3c-8d671c401e3b_YFKBB-PQJJV-G996G-VWGXY-2V%f%3X8___6_Business
2c682dc2-8b68-4f63-a165-ae291d4cf138_HMBQG-8H2RH-C77VX-27R82-VM%f%QBT__16_BusinessN
d4f54950-26f2-4fb4-ba21-ffab16afcade_VTC42-BM838-43QHV-84HX6-XJ%f%XKV__27_EnterpriseN
:: Windows Server 2008
ad2542d4-9154-4c6d-8a44-30f11ee96989_TM24T-X9RMF-VWXK6-X8JC9-BF%f%GM2___7_ServerStandard
68b6e220-cf09-466b-92d3-45cd964b9509_7M67G-PC374-GR742-YH8V4-TC%f%BY3___8_ServerDatacenter
c1af4d90-d1bc-44ca-85d4-003ba33db3b9_YQGMW-MPWTJ-34KDK-48M3W-X4%f%Q6V__10_ServerEnterprise
01ef176b-3e0d-422a-b4f8-4ea880035e8f_4DWFP-JF3DJ-B7DTH-78FJB-PD%f%RHK__15_ServerEnterpriseIA64
ddfa9f7c-f09e-40b9-8c1a-be877a9a7f4b_WYR28-R7TFJ-3X2YQ-YCY4H-M2%f%49D__17_ServerWeb
7afb1156-2c1d-40fc-b260-aab7442b62fe_RCTX3-KWVHP-BR6TB-RB6DM-6X%f%7HP__18_ServerComputeCluster
2401e3d0-c50a-4b58-87b2-7e794b7d2607_W7VD6-7JFBR-RX26B-YKQ3Y-6F%f%FFJ__36_ServerStandardV
fd09ef77-5647-4eff-809c-af2b64659a45_22XQ2-VRXRG-P8D42-K34TD-G3%f%QQC__37_ServerDatacenterV
8198490a-add0-47b2-b3ba-316b12d647b4_39BXF-X8Q23-P2WWT-38T2F-G3%f%FPG__38_ServerEnterpriseV
:=======================================================================================================================================
:: Office 2010
8ce7e872-188c-4b98-9d90-f8f90b7aad02_V7Y44-9T38C-R2VJK-666HK-T7%f%DDX__14_AccessVL
cee5d470-6e3b-4fcc-8c2b-d17428568a9f_H62QG-HXVKF-PP4HP-66KMR-CW%f%9BM__14_ExcelVL
8947d0b8-c33b-43e1-8c56-9b674c052832_QYYW6-QP4CB-MBV6G-HYMCJ-4T%f%3J4__14_GrooveVL
ca6b6639-4ad6-40ae-a575-14dee07f6430_K96W8-67RPQ-62T9Y-J8FQJ-BT%f%37T__14_InfoPathVL
09ed9640-f020-400a-acd8-d7d867dfd9c2_YBJTT-JG6MD-V9Q7P-DBKXJ-38%f%W9R__14_MondoVL
ab586f5c-5256-4632-962f-fefd8b49e6f4_Q4Y4M-RHWJM-PY37F-MTKWH-D3%f%XHX__14_OneNoteVL
ecb7c192-73ab-4ded-acf4-2399b095d0cc_7YDC2-CWM8M-RRTJC-8MDVC-X3%f%DWQ__14_OutlookVL
45593b1d-dfb1-4e91-bbfb-2d5d0ce2227a_RC8FX-88JRY-3PF7C-X8P67-P4%f%VTT__14_PowerPointVL
df133ff7-bf14-4f95-afe3-7b48e7e331ef_YGX6F-PGV49-PGW3J-9BTGG-VH%f%KC6__14_ProjectProVL
5dc7bf61-5ec9-4996-9ccb-df806a2d0efe_4HP3K-88W3F-W2K3D-6677X-F9%f%PGB__14_ProjectStdVL
6f327760-8c5c-417c-9b61-836a98287e0c_VYBBJ-TRJPB-QFQRF-QFT4D-H3%f%GVB__14_ProPlusVL
b50c4f75-599b-43e8-8dcd-1081a7967241_BFK7F-9MYHM-V68C7-DRQ66-83%f%YTP__14_PublisherVL
ea509e87-07a1-4a45-9edc-eba5a39f36af_D6QFG-VBYP2-XQHM7-J97RH-VV%f%RCK__14_SmallBusBasicsVL
9da2a678-fb6b-4e67-ab84-60dd6a9c819a_V7QKV-4XVVR-XYV4D-F7DFM-8R%f%6BM__14_StandardVL
92236105-bb67-494f-94c7-7f7a607929bd_D9DWC-HPYVV-JGF4P-BTWQB-WX%f%8BJ__14_VisioSIVL
2d0882e7-a4e7-423b-8ccc-70d91e0158b1_HVHB3-C6FV7-KQX9W-YQG79-CR%f%Y7T__14_WordVL
:: Office 2013
6ee7622c-18d8-4005-9fb7-92db644a279b_NG2JY-H4JBT-HQXYP-78QH9-4J%f%M2D__15_AccessVolume_-AccessRetail-
259de5be-492b-44b3-9d78-9645f848f7b0_X3XNB-HJB7K-66THH-8DWQ3-XH%f%GJP__15_AccessRuntimeRetail_[Bypass]
f7461d52-7c2b-43b2-8744-ea958e0bd09a_VGPNG-Y7HQW-9RHP7-TKPV3-BG%f%7GB__15_ExcelVolume_-ExcelRetail-
fb4875ec-0c6b-450f-b82b-ab57d8d1677f_H7R7V-WPNXQ-WCYYC-76BGV-VT%f%7GH__15_GrooveVolume_-GrooveRetail-
a30b8040-d68a-423f-b0b5-9ce292ea5a8f_DKT8B-N7VXH-D963P-Q4PHY-F8%f%894__15_InfoPathVolume_-InfoPathRetail-
9103f3ce-1084-447a-827e-d6097f68c895_6MDN4-WF3FV-4WH3Q-W699V-RG%f%CMY__15_LyncAcademicRetail_[PrepidBypass]
ff693bf4-0276-4ddb-bb42-74ef1a0c9f4d_N42BF-CBY9F-W2C7R-X397X-DY%f%FQW__15_LyncEntryRetail_[PrepidBypass]
1b9f11e3-c85c-4e1b-bb29-879ad2c909e3_2MG3G-3BNTT-3MFW9-KDQW3-TC%f%K7R__15_LyncVolume_-LyncRetail-
1dc00701-03af-4680-b2af-007ffc758a1f_CWH2Y-NPYJW-3C7HD-BJQWB-G2%f%8JJ__15_MondoRetail
dc981c6b-fc8e-420f-aa43-f8f33e5c0923_42QTK-RN8M7-J3C4G-BBGYM-88%f%CYV__15_MondoVolume_-O365BusinessRetail-O365HomePremRetail-O365ProPlusRetail-O365SmallBusPremRetail-
3391e125-f6e4-4b1e-899c-a25e6092d40d_4TGWV-6N9P6-G2H8Y-2HWKB-B4%f%FF4__15_OneNoteFreeRetail_[Bypass]
efe1f3e6-aea2-4144-a208-32aa872b6545_TGN6P-8MMBC-37P2F-XHXXK-P3%f%4VW__15_OneNoteVolume_-OneNoteRetail-
771c3afa-50c5-443f-b151-ff2546d863a0_QPN8Q-BJBTJ-334K3-93TGY-2P%f%MBT__15_OutlookVolume_-OutlookRetail-
8c762649-97d1-4953-ad27-b7e2c25b972e_4NT99-8RJFH-Q2VDH-KYG2C-4R%f%D4F__15_PowerPointVolume_-PowerPointRetail-
4a5d124a-e620-44ba-b6ff-658961b33b9a_FN8TT-7WMH6-2D4X9-M337T-23%f%42K__15_ProjectProVolume_-ProjectProRetail-
427a28d1-d17c-4abf-b717-32c780ba6f07_6NTH3-CW976-3G3Y2-JK3TX-8Q%f%HTT__15_ProjectStdVolume_-ProjectStdRetail-
b322da9c-a2e2-4058-9e4e-f59a6970bd69_YC7DK-G2NP3-2QQC3-J6H88-GV%f%GXT__15_ProPlusVolume_-ProPlusRetail-ProfessionalPipcRetail-ProfessionalRetail-
00c79ff1-6850-443d-bf61-71cde0de305f_PN2WF-29XG2-T9HJ7-JQPJR-FC%f%XK4__15_PublisherVolume_-PublisherRetail-
ba3e3833-6a7e-445a-89d0-7802a9a68588_3NY6J-WHT3F-47BDV-JHF36-23%f%43W__15_SPDRetail_[PrepidBypass]
b13afb38-cd79-4ae5-9f7f-eed058d750ca_KBKQT-2NMXY-JJWGP-M62JB-92%f%CD4__15_StandardVolume_-StandardRetail-HomeBusinessPipcRetail-HomeBusinessRetail-HomeStudentARMRetail-HomeStudentPlusARMRetail-HomeStudentRetail-PersonalPipcRetail-PersonalRetail-
e13ac10e-75d0-4aff-a0cd-764982cf541c_C2FG9-N6J68-H8BTJ-BW3QX-RM%f%3B3__15_VisioProVolume_-VisioProRetail-
ac4efaf0-f81f-4f61-bdf7-ea32b02ab117_J484Y-4NKBF-W2HMG-DBMJC-PG%f%WR7__15_VisioStdVolume_-VisioStdRetail-
d9f5b1c6-5386-495a-88f9-9ad6b41ac9b3_6Q7VD-NX8JD-WJ2VH-88V73-4G%f%BJ7__15_WordVolume_-WordRetail-
:: Office 2016
9d9faf9e-d345-4b49-afce-68cb0a539c7c_RNB7V-P48F4-3FYY6-2P3R3-63%f%BQV__16_AccessRuntimeRetail_[PrepidBypass]
67c0fc0c-deba-401b-bf8b-9c8ad8395804_GNH9Y-D2J4T-FJHGG-QRVH7-QP%f%FDW__16_AccessVolume_-AccessRetail-
c3e65d36-141f-4d2f-a303-a842ee756a29_9C2PK-NWTVB-JMPW8-BFT28-7F%f%TBF__16_ExcelVolume_-ExcelRetail-
e914ea6e-a5fa-4439-a394-a9bb3293ca09_DMTCJ-KNRKX-26982-JYCKT-P7%f%KB6__16_MondoRetail
9caabccb-61b1-4b4b-8bec-d10a3c3ac2ce_HFTND-W9MK4-8B7MJ-B6C4G-XQ%f%BR2__16_MondoVolume_-O365AppsBasicRe queue-O365BusinessRetail-O365EduCloudRetail-O365HomePremRetail-O365ProPlusRetail-O365SmallBusPremRetail-
436366de-5579-4f24-96db-3893e4400030_XYNTG-R96FY-369HX-YFPHY-F9%f%CPM__16_OneNoteFreeRetail_[Bypass]
d8cace59-33d2-4ac7-9b1b-9b72339c51c8_DR92N-9HTF2-97XKM-XW2WJ-XW%f%3J6__16_OneNoteVolume_-OneNoteRetail-OneNote2021Retail-
ec9d9265-9d1e-4ed0-838a-cdc20f2551a1_R69KK-NTPKF-7M3Q4-QYBHW-6M%f%T9B__16_OutlookVolume_-OutlookRetail-
d70b1bba-b893-4544-96e2-b7a318091c33_J7MQP-HNJ4Y-WJ7YM-PFYGF-BY%f%6C6__16_PowerPointVolume_-PowerPointRetail-
4f414197-0fc2-4c01-b68a-86cbb9ac254c_YG9NW-3K39V-2T3HJ-93F3Q-G8%f%3KT__16_ProjectProVolume_-ProjectProRetail-
829b8110-0e6f-4349-bca4-42803577788d_WGT24-HCNMF-FQ7XH-6M8K7-DR%f%TW9__16_ProjectProXVolume
da7ddabc-3fbe-4447-9e01-6ab7440b4cd4_GNFHQ-F6YQM-KQDGJ-327XX-KQ%f%BVC__16_ProjectStdVolume_-ProjectStdRetail-
cbbaca45-556a-4416-ad03-bda598eaa7c8_D8NRQ-JTYM3-7J2DX-646CT-68%f%36M__16_ProjectStdXVolume
d450596f-894d-49e0-966a-fd39ed4c4c64_XQNVK-8JYDB-WJ9W3-YJ8YR-WF%f%G99__16_ProPlusVolume_-ProPlusRetail-ProfessionalPipcRetail-ProfessionalRetail-
041a06cb-c5b8-4772-809f-416d03d16654_F47MM-N3XJP-TQXJ9-BP99D-8K%f%837__16_PublisherVolume_-PublisherRetail-
9103f3ce-1084-447a-827e-d6097f68c895_6MDN4-WF3FV-4WH3Q-W699V-RG%f%CMY__16_SkypeServiceBypassRetail_[PrepidBypass]
971cd368-f2e1-49c1-aedd-330909ce18b6_4N4D8-3J7Y3-YYW7C-73HD2-V8%f%RHY__16_SkypeforBusinessEntryRetail_[PrepidBypass]
83e04ee1-fa8d-436d-8994-d31a862cab77_869NQ-FJ69K-466HW-QYCP2-DD%f%BV6__16_SkypeforBusinessVolume_-SkypeforBusinessRetail-
dedfa23d-6ed1-45a6-85dc-63cae0546de6_JNRGM-WHDWX-FJJG3-K47QV-DR%f%TFM__16_StandardVolume_-StandardRetail-HomeBusinessPipcRetail-HomeBusinessRetail-HomeStudentARMRetail-HomeStudentPlusARMRetail-HomeStudentRetail-HomeStudentVNextRetail-PersonalPipcRetail-PersonalRetail-
6bf301c1-b94a-43e9-ba31-d494598c47fb_PD3PC-RHNGV-FXJ29-8JK7D-RJ%f%RJK__16_VisioProVolume_-VisioProRetail-
b234abe3-0857-4f9c-b05a-4dc314f85557_69WXN-MBYV6-22PQG-3WGHK-RM%f%6XC__16_VisioProXVolume
aa2a7821-1827-4c2c-8f1d-4513a34dda97_7WHWN-4T7MP-G96JF-G33KR-W8%f%GF4__16_VisioStdVolume_-VisioStdRetail-
361fe620-64f4-41b5-ba77-84f8e079b1f7_NY48V-PPYYH-3F4PX-XJRKJ-W4%f%423__16_VisioStdXVolume
bb11badf-d8aa-470e-9311-20eaf80fe5cc_WXY84-JN2Q9-RBCCQ-3Q3J3-3P%f%FJ6__16_WordVolume_-WordRetail-
:: Office 2019
22e6b96c-1011-4cd5-8b35-3c8fb6366b86_FGQNJ-JWJCG-7Q8MG-RMRGJ-9T%f%QVF__16_AccessRuntime2019Retail_[PrepidBypass]
9e9bceeb-e736-4f26-88de-763f87dcc485_9N9PT-27V4Y-VJ2PD-YXFMF-YT%f%FQT__16_Access2019Volume_-Access2019Retail-
237854e9-79fc-4497-a0c1-a70969691c6b_TMJWT-YYNMB-3BKTF-644FC-RV%f%XBD__16_Excel2019Volume_-Excel2019Retail-
c8f8a301-19f5-4132-96ce-2de9d4adbd33_7HD7K-N4PVK-BHBCQ-YWQRW-XW%f%4VK__16_Outlook2019Volume_-Outlook2019Retail-
3131fd61-5e4f-4308-8d6d-62be1987c92c_RRNCX-C64HY-W2MM7-MCH9G-TJ%f%HMQ__16_PowerPoint2019Volume_-PowerPoint2019Retail-
2ca2bf3f-949e-446a-82c7-e25a15ec78c4_B4NPR-3FKK7-T2MBV-FRQ4W-PK%f%D2B__16_ProjectPro2019Volume_-ProjectPro2019Retail-
1777f0e3-7392-4198-97ea-8ae4de6f6381_C4F7P-NCP8C-6CQPT-MQHV9-JX%f%D2M__16_ProjectStd2019Volume_-ProjectStd2019Retail-
85dd8b5f-eaa4-4af3-a628-cce9e77c9a03_NMMKJ-6RK4F-KMJVX-8D9MJ-6M%f%WKP__16_ProPlus2019Volume_-ProPlus2019Retail-Professional2019Retail-
9d3e4cca-e172-46f1-a2f4-1d2107051444_G2KWX-3NW6P-PY93R-JXK2T-C9%f%Y9V__16_Éditeur2019Volume_-Éditeur2019Détail-
734c6c6e-b0ba-4298-a891-671772b2bd1b_NCJ33-JHBBY-HTK98-MYCV8-HM%f%KHJ__16_SkypeforBusiness2019Volume_-SkypeforBusiness2019Retail-
f88cfdec-94ce-4463-a969-037be92bc0e7_N9722-BV9H6-WTJTT-FPB93-97%f%8MK__16_SkypeforBusinessEntry2019Retail_[PrepidBypass]
6912a74b-a5fb-401a-bfdb-2e3ab46f4b02_6NWWJ-YQWMR-QKGCB-6TMB3-9D%f%9HK__16_Standard2019Volume_-Standard2019Retail-HomeBusiness2019Retail-HomeStudentARM2019Retail-HomeStudentPlusARM2019Retail-HomeStudent2019Retail-Personal2019Retail-
5b5cf08f-b81a-431d-b080-3450d8620565_9BGNQ-K37YR-RQHF2-38RQ3-7V%f%CBB__16_VisioPro2019Volume_-VisioPro2019Retail-
e06d7df3-aad0-419d-8dfb-0ac37e2bdf39_7TQNQ-K3YQQ-3PFH7-CCPPM-X4%f%VQ2__16_VisioStd2019Volume_-VisioStd2019Retail-
059834fe-a8ea-4bff-b67b-4d006b5447d3_PBX3G-NWMT6-Q7XBW-PYJGG-WX%f%D33__16_Word2019Volume_-Word2019Retail-
:: Office 2021
La licence KMS en volume OneNote 2021 n'est pas disponible.
844c36cb-851c-49e7-9079-12e62a049e2a_MNX9D-PB834-VCGY2-K2RW2-2D%f%P3D__16_AccessRuntime2021Retail_[Bypass]
1fe429d8-3fa7-4a39-b6f0-03dded42fe14_WM8YG-YNGDD-4JHDC-PG3F4-FC%f%4T4__16_Access2021Volume_-Access2021Retail-
ea71effc-69f1-4925-9991-2f5e319bbc24_NWG3X-87C9K-TC7YY-BC2G7-G6%f%RVC__16_Excel2021Volume_-Excel2021Retail-
a5799e4c-f83c-4c6e-9516-dfe9b696150b_C9FM6-3N72F-HFJXB-TM3V9-T8%f%6R9__16_Outlook2021Volume_-Outlook2021Retail-
778ccb9a-2f6a-44e5-853c-eb22b7609643_CNM3W-V94GB-QJQHH-BDQ3J-33%f%Y8H__16_OneNoteFree2021Retail_[Bypass]
6e166cc3-495d-438a-89e7-d7c9e6fd4dea_TY7XF-NFRBR-KJ44C-G83KF-GX%f%27K__16_PowerPoint2021Volume_-PowerPoint2021Retail-
76881159-155c-43e0-9db7-2d70a9a3a4ca_FTNWT-C6WBT-8HMGF-K9PRX-QV%f%9H8__16_ProjectPro2021Volume_-ProjectPro2021Retail-
6dd72704-f752-4b71-94c7-11cec6bfc355_J2JDC-NJCYY-9RGQ4-YXWMH-T3%f%D4T__16_ProjectStd2021Volume_-ProjectStd2021Retail-
fbdb3e18-a8ef-4fb3-9183-dffd60bd0984_FXYTK-NJJ8C-GB6DW-3DYQT-6F%f%7TH__16_ProPlus2021Volume_-ProPlus2021Retail-Professional2021Retail-
aa66521f-2370-4ad8-a2bb-c095e3e4338f_2MW9D-N4BXM-9VBPG-Q7W6M-KF%f%BGQ__16_Éditeur2021Volume_-Éditeur2021Détail-
1f32a9af-1274-48bd-ba1e-1ab7508a23e8_HWCXN-K3WBT-WJBKY-R8BD9-XK%f%29P__16_SkypeforBusiness2021Volume_-SkypeforBusiness2021Retail-
080a45c5-9f9f-49eb-b4b0-c3c610a5ebd3_KDX7X-BNVR8-TXXGX-4Q7Y8-78%f%VT3__16_Standard2021Volume_-Standard2021Retail-HomeBusiness2021Retail-HomeStudent2021Retail-Personal2021Retail-
fb61ac9a-1688-45d2-8f6b-0674dbffa33c_KNH8D-FGHT4-T8RK3-CTDYJ-K2%f%HT4__16_VisioPro2021Volume_-VisioPro2021Retail-
72fce797-1884-48dd-a860-b2f6a5efd3ca_MJVNY-BYWPY-CWV6J-2RKRT-4M%f%8QG__16_VisioStd2021Volume_-VisioStd2021Retail-
abe28aea-625a-43b1-8e30-225eb8fbd9e5_TN8H9-M34D3-Y64V9-TR72V-X7%f%9KV__16_Word2021Volume_-Word2021Retail-
:: Office 2024
fceda083-1203-402a-8ec4-3d7ed9f3648c_2TDPW-NDQ7G-FMG99-DXQ7M-TX%f%3T2__16_ProPlus2024Volume-Preview
aaea0dc8-78e1-4343-9f25-b69b83dd1bce_D9GTG-NP7DV-T6JP3-B6B62-JB%f%89R__16_ProjectPro2024Volume-Preview
4ab4d849-aabc-43fb-87ee-3aed02518891_YW66X-NH62M-G6YFP-B7KCT-WX%f%GKQ__16_VisioPro2024Volume-Preview
72e9faa7-ead1-4f3d-9f6e-3abc090a81d7_82FTR-NCHR7-W3944-MGRHM-JM%f%CWD__16_Access2024Volume_-Access2024Retail-
cbbba2c3-0ff5-4558-846a-043ef9d78559_F4DYN-89BP2-WQTWJ-GR8YC-CK%f%GJG__16_Excel2024Volume_-Excel2024Retail-
bef3152a-8a04-40f2-a065-340c3f23516d_D2F8D-N3Q3B-J28PV-X27HD-RJ%f%WB9__16_Outlook2024Volume_-Outlook2024Retail-
b63626a4-5f05-4ced-9639-31ba730a127e_CW94N-K6GJH-9CTXY-MG2VC-FY%f%CWP__16_PowerPoint2024Volume_-PowerPoint2024Retail-
f510af75-8ab7-4426-a236-1bfb95c34ff8_FQQ23-N4YCY-73HQ3-FM9WC-76%f%HF4__16_ProjectPro2024Volume_-ProjectPro2024Retail-
9f144f27-2ac5-40b9-899d-898c2b8b4f81_PD3TT-NTHQQ-VC7CY-MFXK3-G8%f%7F8__16_ProjectStd2024Volume_-ProjectStd2024Retail-
8d368fc1-9470-4be2-8d66-90e836cbb051_XJ2XN-FW8RK-P4HMP-DKDBV-GC%f%VGB__16_ProPlus2024Volume_-ProPlus2024Retail-
0002290a-2091-4324-9e53-3cfe28884cde_4NKHF-9HBQF-Q3B6C-7YV34-F6%f%4P3__16_SkypeforBusiness2024Volume
bbac904f-6a7e-418a-bb4b-24c85da06187_V28N4-JG22K-W66P8-VTMGK-H6%f%HGR__16_Standard2024Volume_-Home2024Retail-HomeBusiness2024Retail-
fa187091-8246-47b1-964f-80a0b1e5d69a_B7TN8-FJ8V3-7QYCP-HQPMV-YY%f%89G__16_VisioPro2024Volume_-VisioPro2024Retail-
923fa470-aa71-4b8b-b35c-36b79bf9f44b_JMMVY-XFNQC-KK4HK-9H7R3-WQ%f%QTV__16_VisioStd2024Volume_-VisioStd2024Retail-
d0eded01-0881-4b37-9738-190400095098_MQ84N-7VYDM-FXV7C-6K7CC-VF%f%W9J__16_Word2024Volume_-Word2024Retail-
) faire (
pour /f "tokens=1-5 delims=_" %%A dans ("%%#") faire (

si %1==winkey si %osSKU%==%%C si la clé n'est pas définie (
echo "!allapps!" | find /i "%%A" %nul1% && set key=%%B
)

si %1==chkprod si "%oVer%"=="%%C" si non défini foundprod (
echo "%%D" | findstr /I "\<%2.*" %nul% && set foundprod=1
)

si %1==getinfo si la clé n'est pas définie si "%oVer%"=="%%C" (
si /i "%2"="%%D" (
définir la clé=%%B
définir _actid=%%A
définir _allactid=!_allactid! %%A
) sinon si non défini _oMSI si %_NoEditionChange%==0 (
echo: %%E | find /i "-%2-" %nul% && (
définir la clé=%%B
définir _altoffid=%%D
définir _actid=%%A
définir _allactid=!_allactid! %%A
)
)
)

)
)
quitter /b

:=================================================================================================================================================

Le code ci-dessous permet d'obtenir le nom et la clé d'une autre édition si l'édition actuelle ne prend pas en charge l'activation KMS.

:: 1ère colonne = ID SKU actuel
:: 2e colonne = Nom de l'édition actuelle
:: 3e colonne = ID d'activation de l'édition actuelle
:: 4e colonne = ID d'activation de l'édition alternative
:: 5e colonne = Édition alternative GVLK
:: 6e colonne = Nom de l'édition alternative
:: Séparateur = _


:kmsfallback

définir notfoundaltactID=
si %_NoEditionChange%==1 quitter /b

pour %%# dans (
205_IoTEnterpriseSK________________d4f9b41f-205c-405e-8e08-3d16e88e02be_59eb965c-9150-42b7-a0ec-22151b9897c5_KBN8V-HFGQ4-MGXVD-347P6-PD%f%QGT_IoTEnterpriseS
138_ProfessionnelMonolingue_____a48938aa-62fa-4966-9d44-9f04da3f72f2_2de67392-b7a7-462a-b1ca-108dd189f588_W269N-WFGWX-YVC9B-4J6C9-T8%f%3GX_Professionnel
139_ProfessionnelPaysSpécifique____f7af7d09-40e4-419c-a49b-eae366689ebd_2de67392-b7a7-462a-b1ca-108dd189f588_W269N-WFGWX-YVC9B-4J6C9-T8%f%3GX_Professionnel
139_ProfessionnelPaysSpécifique-Zn_01eb852c-424d-4060-94b8-c10d799d7364_2de67392-b7a7-462a-b1ca-108dd189f588_W269N-WFGWX-YVC9B-4J6C9-T8%f%3GX_Professionnel
) faire (
pour /f "tokens=1-6 delims=_" %%A dans ("%%#") faire si %osSKU%==%%A (
echo "!allapps!" | trouver /i "%%C" %nul1% && (
echo "!allapps!" | trouver /i "%%D" %nul1% && (
définir altkey=%%E
définir l'édition=%%F
) || (
définir l'édition=%%F
définir notfoundaltactID=1
)
)
)
)
quitter /b

:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:vérifier_statut

cls
si le terminal n'est pas défini (
mode 100, 36
%psc% "&{$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=35;$B.Height=300;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}" %nul%
)

%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':sppmgr\:.*';. ([scriptblock]::Create($f[1]))"
aller à dk_done

:sppmgr:
param (
    [Paramètre()]
    [changer]
    Tous,
    [Paramètre()]
    [changer]
    $Dlv,
    [Paramètre()]
    [changer]
    $IID,
    [Paramètre()]
    [changer]
    $Pass
)

fonction CONOUT($strObj)
{
	Sortie-Hôte -Entrée $strObj
}

fonction ExitScript($ExitCode = 0)
{
	Sortie $CodeDeSortie
}

si (-Non $PSVersionTable) {
	"==== ERREUR ====`r`n"
	« Ce script ne prend pas en charge Windows PowerShell 1.0. »
	ExitScript 1
}

si ($ExecutionContext.SessionState.LanguageMode.value__ -NE 0) {
	"==== ERREUR ====`r`n"
	"Windows PowerShell ne s'exécute pas en mode multilingue complet."
	ExitScript 1
}

$winbuild = 1
essayer {
	$winbuild = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$env:SystemRoot\System32\kernel32.dll").FileBuildPart
} attraper {
	$winbuild = [int]([wmi]'Win32_OperatingSystem=@').BuildNumber
}

si ($winbuild -EQ 1) {
	"==== ERREUR ====`r`n"
	«Impossible de détecter la version de Windows.»
	ExitScript 1
}

si ($winbuild -LT 2600) {
	"==== ERREUR ====`r`n"
	«Cette version de Windows n'est pas prise en charge par ce script.»
	ExitScript 1
}

si ($All.IsPresent)
{
	$isAll = {CONOUT "`r"}
	$noAll = {$null}
}
autre
{
	$isAll = {$null}
	$noAll = {CONOUT "`r"}
}
$Dlv = $Dlv.IsPresent
$IID = $IID.IsPresent -Ou $Dlv.IsPresent

$NT6 = $winbuild -GE 6000
$NT7 = $winbuild -GE 7600
$NT8 = $winbuild -GE 9200
$NT9 = $winbuild -GE 9600

$Admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$line2 = "============================================================"
$ligne3 = "__________________________________________________________________________"

fonction echoWindows
{
	CONOUT "$line2"
	CONOUT "=== État de Windows ==="
	CONOUT "$line2"
	& $noAll
}

fonction echoOffice
{
	si ($doMSG -EQ 0) {
		retour
	}

	& $isAll
	CONOUT "$line2"
	CONOUT "=== Statut du bureau ==="
	CONOUT "$line2"
	& $noAll

	$script:doMSG = 0
}

fonction strGetRegistry($strKey, $strName)
{
	essayer {
		retourner [Microsoft.Win32.Registry]::GetValue($strKey, $strName, $null)
	} attraper {
		renvoyer $null
	}
}

fonction CheckOhook
{
	$ohook = 0
	$paths = "${env:ProgramFiles}", "${env:ProgramW6432}", "${env:ProgramFiles(x86)}"

	15, 16 | pour chaque `
	{
		$A = $_; $paths | foreach `
		{
			if (Test-Path "$($_)$('\Microsoft Office\Office')$($A)$('\sppc*dll')") {$ohook = 1}
		}
	}

	"Système", "SystèmeX86" | pour chaque `
	{
		$A = $_; "Office 15", "Office" | foreach `
		{
			$B = $_; $paths | foreach `
			{
				if (Test-Path "$($_)$('\Microsoft ')$($B)$('\root\vfs\')$($A)$('\sppc*dll')") {$ohook = 1}
			}
		}
	}

	si ($ohook -EQ 0) {
		retour
	}

	& $isAll
	CONOUT "$line2"
	CONOUT "=== Statut du crochet de bureau ==="
	CONOUT "$line2"
	$host.UI.WriteLine('Jaune', 'Noir', "`r`nOhook pour l'activation permanente d'Office est installé.`r`nVous pouvez ignorer l'état d'activation d'Office mentionné ci-dessous.")
	& $noAll
}

#région SSSS
fonction BoolToWStr($bVal) {
	("VRAI", "FAUX")[!$bVal]
}

fonction InitializePInvoke($LaDll, $bOffice) {
	$LaName = [IO.Path]::GetFileNameWithoutExtension($LaDll)
	$SLApp = $NT7 -Ou $bOffice -Ou ($LaName -EQ 'sppc' -Et [Diagnostics.FileVersionInfo]::GetVersionInfo("$SysPath\sppc.dll").FilePrivatePart -GE 16501)
	$Win32 = $null

	$Marshal = [System.Runtime.InteropServices.Marshal]
	$Module = [AppDomain]::CurrentDomain.DefineDynamicAssembly(($LaName+"_Assembly"), 'Run').DefineDynamicModule(($LaName+"_Module"), $False)
	$Class = $Module.DefineType(($LaName+"_Methods"), 'Public, Abstract, Sealed, BeforeFieldInit', [Object], 0)

	$Class.DefinePInvokeMethod('SLClose', $LaDll, 22, 1, [Int32], @([IntPtr]), 1, 3).SetImplementationFlags(128)
	$Class.DefinePInvokeMethod('SLOpen', $LaDll, 22, 1, [Int32], @([IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
	$Class.DefinePInvokeMethod('SLGenerateOfflineInstallationId', $LaDll, 22, 1, [Int32], @([IntPtr], [Guid].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
	$Class.DefinePInvokeMethod('SLGetSLIDList', $LaDll, 22, 1, [Int32], @([IntPtr], [UInt32], [Guid].MakeByRefType(), [UInt32], [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
	$Class.DefinePInvokeMethod('SLGetLicensingStatusInformation', $LaDll, 22, 1, [Int32], @([IntPtr], [Guid].MakeByRefType(), [Guid].MakeByRefType(), [IntPtr], [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
	$Class.DefinePInvokeMethod('SLGetPKeyInformation', $LaDll, 22, 1, [Int32], @([IntPtr], [Guid].MakeByRefType(), [String], [UInt32].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
	$Class.DefinePInvokeMethod('SLGetProductSkuInformation', $LaDll, 22, 1, [Int32], @([IntPtr], [Guid].MakeByRefType(), [String], [UInt32].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
	$Class.DefinePInvokeMethod('SLGetServiceInformation', $LaDll, 22, 1, [Int32], @([IntPtr], [String], [UInt32].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
	si ($SLApp) {
		$Class.DefinePInvokeMethod('SLGetApplicationInformation', $LaDll, 22, 1, [Int32], @([IntPtr], [Guid].MakeByRefType(), [String], [UInt32].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
	}
	si ($bOffice) {
		$Win32 = $Class.CreateType()
		retour
	}
	si ($NT6) {
		$Class.DefinePInvokeMethod('SLGetWindowsInformation', 'slc.dll', 22, 1, [Int32], @([String], [UInt32].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
		$Class.DefinePInvokeMethod('SLGetWindowsInformationDWORD', 'slc.dll', 22, 1, [Int32], @([String], [UInt32].MakeByRefType()), 1, 3).SetImplementationFlags(128)
		$Class.DefinePInvokeMethod('SLIsGenuineLocal', 'slwga.dll', 22, 1, [Int32], @([Guid].MakeByRefType(), [UInt32].MakeByRefType(), [IntPtr]), 1, 3).SetImplementationFlags(128)
	}
	si ($NT7) {
		$Class.DefinePInvokeMethod('SLIsWindowsGenuineLocal', 'slc.dll', 'Public, Static', 'Standard', [Int32], @([UInt32].MakeByRefType()), 'Winapi', 'Unicode').SetImplementationFlags('PreserveSig')
	}

	si ($DllSubscription) {
		$Class.DefinePInvokeMethod('ClipGetSubscriptionStatus', 'Clipc.dll', 22, 1, [Int32], @([IntPtr].MakeByRefType()), 1, 3).SetImplementationFlags(128)
		$Struct = $Class.DefineNestedType('SubStatus', 'NestedPublic, SequentialLayout, Sealed, BeforeFieldInit', [ValueType], 0)
		[void]$Struct.DefineField('dwEnabled', [UInt32], 'Public')
		[void]$Struct.DefineField('dwSku', [UInt32], 6)
		[void]$Struct.DefineField('dwState', [UInt32], 6)
		$SubStatus = $Struct.CreateType()
	}

	$Win32 = $Class.CreateType()
}

fonction SlGetInfoIID($SkuId)
{
	$bData = 0

	si ($Win32::SLGenerateOfflineInstallationId(
		$hSLC,
		[ref][Guid]$SkuId,
		[ref]$bData
	))
	{
		renvoyer $null
	}
	autre
	{
		renvoie $Marshal::PtrToStringUni($bData)
	}
}

fonction SlReturnData($hrRet, $tData, $cData, $bData) {
	si ($hrRet -NE 0 -Ou $cData -EQ 0)
	{
		renvoyer $null
	}
	si ($tData -EQ 1)
	{
		renvoie $Marshal::PtrToStringUni($bData)
	}
	sinon si ($tData -EQ 4)
	{
		renvoie $Marshal::ReadInt32($bData)
	}
	sinon si ($tData -EQ 3 -Et $cData -EQ 8)
	{
		renvoie $Marshal::ReadInt64($bData)
	}
	autre
	{
		renvoyer $null
	}
}

fonction SlGetInfoPKey($PkeyId, $Value)
{
	$tData = 0
	$cData = 0
	$bData = 0

	$hrRet = $Win32::SLGetPKeyInformation(
		$hSLC,
		[ref][Guid]$PkeyId,
		$Valeur,
		[ref]$tData,
		[ref]$cData,
		[ref]$bData
	)

	renvoyer SlReturnData $hrRet $tData $cData $bData
}

fonction SlGetInfoSku($SkuId, $Value)
{
	$tData = 0
	$cData = 0
	$bData = 0

	$hrRet = $Win32::SLGetProductSkuInformation(
		$hSLC,
		[ref][Guid]$SkuId,
		$Valeur,
		[ref]$tData,
		[ref]$cData,
		[ref]$bData
	)

	renvoyer SlReturnData $hrRet $tData $cData $bData
}

fonction SlGetInfoApp($AppId, $Value)
{
	$tData = 0
	$cData = 0
	$bData = 0

	$hrRet = $Win32::SLGetApplicationInformation(
		$hSLC,
		[ref][Guid]$AppId,
		$Valeur,
		[ref]$tData,
		[ref]$cData,
		[ref]$bData
	)

	renvoyer SlReturnData $hrRet $tData $cData $bData
}

fonction SlGetInfoService($Value)
{
	$tData = 0
	$cData = 0
	$bData = 0

	$hrRet = $Win32::SLGetServiceInformation(
		$hSLC,
		$Valeur,
		[ref]$tData,
		[ref]$cData,
		[ref]$bData
	)

	renvoyer SlReturnData $hrRet $tData $cData $bData
}

fonction SlGetInfoSvcApp($strApp, $Value)
{
	si ($SLApp)
	{
		retourner SlGetInfoApp $strApp $Value
	}
	autre
	{
		renvoyer SlGetInfoService $Value
	}
}

fonction SlGetInfoLicensing($AppId, $SkuId)
{
	$dwStatus = 0
	$dwGrace = 0
	$hrReason = 0
	$qwValidity = 0

	$cStatus = 0
	$pStatus = 0

	$hrRet = $Win32::SLGetLicensingStatusInformation(
		$hSLC,
		[ref][Guid]$AppId,
		[ref][Guid]$SkuId,
		0,
		[ref]$cStatut,
		[ref]$pStatut
	)

	si ($hrRet -NE 0 -Ou $cStatus -EQ 0)
	{
		retour
	}

	[IntPtr]$ppStatus = [Int64]$pStatus + [Int64]40 * ($cStatus - 1)
	$dwStatus = $Marshal::ReadInt32($ppStatus, 16)
	$dwGrace = $Marshal::ReadInt32($ppStatus, 20)
	$hrReason = $Marshal::ReadInt32($ppStatus, 28)
	$qwValidity = $Marshal::ReadInt64($ppStatus, 32)

	si ($dwStatus -EQ 3)
	{
		$dwStatus = 5
	}
	si ($dwStatus -EQ 2)
	{
		si ($hrReason -EQ 0x4004F00D)
		{
			$dwStatus = 3
		}
		sinon si ($hrReason -EQ 0x4004F065)
		{
			$dwStatus = 4
		}
		sinon si ($hrReason -EQ 0x4004FC06)
		{
			$dwStatus = 6
		}
	}

	retour
}

fonction SlGetInfoSLID($AppId)
{
	$cReturnIds = 0
	$pReturnIds = 0

	$hrRet = $Win32::SLGetSLIDList(
		$hSLC,
		0,
		[ref][Guid]$AppId,
		1,
		[ref]$cReturnIds,
		[ref]$pReturnIds
	)

	si ($hrRet -NE 0 -Ou $cReturnIds -EQ 0)
	{
		retour
	}

	$a1List = @()
	$a2List = @()
	$a3List = @()
	$a4List = @()

	pour chaque ($i dans 0..($cReturnIds - 1))
	{
		$bytes = New-Object byte[] 16
		$Marshal::Copy([Int64]$pReturnIds + [Int64]16 * $i, $bytes, 0, 16)
		$actid = ([Guid]$bytes).Guid
		$gPPK = SlGetInfoSku $actid "pkeyId"
		$gAdd = SlGetInfoSku $actid "Dépend de"
		si ($All.IsPresent) {
			if ($null -EQ $gPPK -And $null -NE $gAdd) { $a1List += @{id = $actid; pk = $null; ex = $true} }
			if ($null -EQ $gPPK -And $null -EQ $gAdd) { $a2List += @{id = $actid; pk = $null; ex = $false} }
		}
		if ($null -NE $gPPK -And $null -NE $gAdd) { $a3List += @{id = $actid; pk = $gPPK; ex = $true} }
		if ($null -NE $gPPK -And $null -EQ $gAdd) { $a4List += @{id = $actid; pk = $gPPK; ex = $false} }
	}

	retourner ($a1List + $a2List + $a3List + $a4List)
}

fonction DétecterAbonnement {
	essayer
	{
		$objSvc = New-Object PSObject
		$wmiSvc = [wmisearcher]"SELECT SubscriptionType, SubscriptionStatus, SubscriptionEdition, SubscriptionExpiry FROM SoftwareLicensingService"
		$wmiSvc.Options.Rewindable = $false
		$wmiSvc.Get() | select -Expand Properties -EA 0 | foreach { $objSvc | Add-Member 8 $_.Name $_.Value }
		$wmiSvc.Dispose()
	}
	attraper
	{
		retour
	}

	si ($null -EQ $objSvc.SubscriptionType -Or $objSvc.SubscriptionType -EQ 120) {
		retour
	}

	si ($objSvc.SubscriptionType -EQ 1) {
		$SubMsgType = "Basé sur l'appareil"
	} autre {
		$SubMsgType = "Basé sur l'utilisateur"
	}

	si ($objSvc.SubscriptionStatus -EQ 120) {
		$SubMsgStatus = "Expiré"
	} elseif ($objSvc.SubscriptionStatus -EQ 100) {
		$SubMsgStatus = "Désactivé"
	} elseif ($objSvc.SubscriptionStatus -EQ 1) {
		$SubMsgStatus = "Actif"
	} autre {
		$SubMsgStatus = "Non actif"
	}

	$SubMsgExpiry = "Inconnu"
	si ($objSvc.SubscriptionExpiry) {
		if ($objSvc.SubscriptionExpiry.Contains("unspecified") -EQ $false) {$SubMsgExpiry = $objSvc.SubscriptionExpiry}
	}

	$SubMsgEdition = "Inconnu"
	si ($objSvc.SubscriptionEdition) {
		if ($objSvc.SubscriptionEdition.Contains("UNKNOWN") -EQ $false) {$SubMsgEdition = $objSvc.SubscriptionEdition}
	}

	CONOUT "`nInformations d'abonnement :"
	CONOUT " Type : $SubMsgType"
	CONOUT " Statut : $SubMsgStatus"
	CONOUT " Édition : $SubMsgEdition"
	CONOUT " Expiration : $SubMsgExpiry"
}

fonction DetectAdbaClient
{
	$propADBA | foreach {set $_ (SlGetInfoSku $licID $_) }
	Détecter le type d'acte
	CONOUT "`Informations client d'activation nAD :"
	CONOUT " Nom de l'objet : $ADActivationObjectName"
	CONOUT " Nom de domaine : $ADActivationObjectDN"
	CONOUT " PID étendu CSVLK : $ADActivationCsvlkPID"
	CONOUT "ID d'activation CSVLK : $ADActivationCsvlkSkuID"
}

fonction DetectAvmClient
{
	$propAVMA | foreach { set $_ (SlGetInfoSku $licID $_) }
	CONOUT "`nInformations client d'activation automatique de la machine virtuelle :"
	si (-Not [String]::IsNullOrEmpty($InheritedActivationId)) {
		CONOUT " IAID invité : $InheritedActivationId »
	} autre {
		CONOUT " ID invité : Non disponible"
	}
	si (-Not [String]::IsNullOrEmpty($InheritedActivationHostMachineName)) {
		CONOUT " Nom de la machine hôte : $InheritedActivationHostMachineName"
	} autre {
		CONOUT " Nom de la machine hôte : Non disponible"
	}
	si (-Not [String]::IsNullOrEmpty($InheritedActivationHostDigitalPid2)) {
		CONOUT " Host Digital PID2 : $InheritedActivationHostDigitalPid2"
	} autre {
		CONOUT "Hôte numérique PID2 : Non disponible"
	}
	si ($InheritedActivationActivationTime) {
		$IAAT = [DateTime]::FromFileTime($InheritedActivationActivationTime).ToString('yyyy-MM-dd hh:mm:ss tt')
		CONOUT " Heure d'activation : $IAAT"
	} autre {
		CONOUT "Heure d'activation : Non disponible"
	}
}

fonction DetectKmsHost
{
	$IsKeyManagementService = SlGetInfoSvcApp $strApp 'IsKeyManagementService'
	si (-Non $IsKeyManagementService) {
		retour
	}

	si ($Vista -Ou $NT5) {
		$regk = $SLKeyPath
	} elseif ($strSLP -EQ $oslp) {
		$regk = $OPKeyPath
	} autre {
		$regk = $SPKeyPath
	}
	$KMSListening = strGetRegistry $regk "KeyManagementServiceListeningPort"
	$KMSPublishing = strGetRegistry $regk "DisableDnsPublishing"
	$KMSPriority = strGetRegistry $regk "EnableKmsLowPriority"

	si (-Non $KMSListening) {$KMSListening = 1688}
	si (-Non $KMSPublishing) {$KMSPublishing = "TRUE"} sinon {$KMSPublishing = BoolToWStr (!$KMSPublishing)}
	if (-Not $KMSPriority) {$KMSPriority = "FALSE"} else {$KMSPriority = BoolToWStr $KMSPriority}

	si ($KMSPublishing -EQ "TRUE") {$KMSPublishing = "Activé"} sinon {$KMSPublishing = "Désactivé"}
	si ($KMSPriority -EQ "TRUE") {$KMSPriority = "Faible"} sinon {$KMSPriority = "Normal"}

	si ($SLApp)
	{
		$propKMSServeur | foreach {set $_ (SlGetInfoApp $strApp $_) }
	}
	autre
	{
		$propKMSServer | foreach { set $_ (SlGetInfoService $_) }
	}

	$KMSRequests = $KeyManagementServiceTotalRequests
	$NoRequests = ($null -EQ $KMSRequests) -Ou ($KMSRequests -EQ -1) -Ou ($KMSRequests -EQ 4294967295)

	CONOUT "`nKey Management Service host information:"
	CONOUT " Nombre actuel : $KeyManagementServiceCurrentCount"
	CONOUT " Écoute sur le port : $KMSListening"
	CONOUT " Publication DNS : $KMSPublishing"
	CONOUT " Priorité KMS : $KMSPriority"
	si ($NoRequests) {
		retour
	}
	CONOUT "`nKey Management Service requêtes cumulatives reçues des clients :"
	CONOUT " Total : $KeyManagementServiceTotalRequests"
	CONOUT " Échec : $KeyManagementServiceFailedRequests "
	CONOUT " Non autorisé : $KeyManagementServiceUnlicensedRequests"
	CONOUT " Licence : $KeyManagementServiceLicensedRequests"
	CONOUT " Période de grâce initiale : $KeyManagementServiceOOBGraceRequests"
	CONOUT " Expiré ou matériel hors tolérance : $KeyManagementServiceOOTGraceRequests"
	CONOUT " Période de grâce non authentique : $KeyManagementServiceNonGenuineGraceRequests"
	if ($null -NE $KeyManagementServiceNotificationRequests) {CONOUT " Notification: $KeyManagementServiceNotificationRequests"}
}

fonction DetectActType
{
	$VLType = strGetRegistry ($SPKeyPath + '\' + $strApp + '\' + $licID) "VLActivationType"
	if ($null -EQ $VLType) {$VLType = strGetRegistry ($SPKeyPath + '\' + $strApp) "VLActivationType"}
	si ($null -EQ $VLType) {$VLType = strGetRegistry ($SPKeyPath) "VLActivationType"}
	si ($null -EQ $VLType -Or $VLType -GT 3) {$VLType = 0}
	if ($null -NE $VLType) {CONOUT "Type d'activation configuré : $($VLActTypes[$VLType])"}
}

fonction DetectKmsClient
{
	si ($win8) {DetectActType}
	CONOUT "`r"
	si ($LicenseStatus -NE 1) {
		CONOUT "Veuillez activer le produit afin de mettre à jour les valeurs des informations client KMS."
		retour
	}

	si ($NT7 -Ou $strSLP -EQ $oslp) {
		$propKMSClient | foreach { set $_ (SlGetInfoSku $licID $_) }
		si ($strSLP -EQ $oslp) {$regk = $OPKeyPath} sinon {$regk = $SPKeyPath}
		$KMSCaching = strGetRegistry $regk "DisableKeyManagementServiceHostCaching"
		si (-Non $KMSCaching) {$KMSCaching = "TRUE"} sinon {$KMSCaching = BoolToWStr (!$KMSCaching)}
	}

	"IDMachineClient" | pour chaque { définir $_ (SlGetInfoService $_) }

	si ($Vista) {
		$propKMSVista | foreach { set $_ (SlGetInfoService $_) }
		$KeyManagementServicePort = strGetRegistry $SLKeyPath "KeyManagementServicePort"
		$DiscoveredKeyManagementServiceName = strGetRegistry $NSKeyPath "DiscoveredKeyManagementServiceName"
		$DiscoveredKeyManagementServicePort = strGetRegistry $NSKeyPath "DiscoveredKeyManagementServicePort"
	}

	si ([String]::IsNullOrEmpty($KeyManagementServiceName)) {
		$KmsReg = $null
	} autre {
		si (-Non $KeyManagementServicePort) {$KeyManagementServicePort = 1688}
		$KmsReg = "Nom de la machine KMS enregistrée : ${KeyManagementServiceName}:${KeyManagementServicePort}"
	}

	si ([String]::IsNullOrEmpty($DiscoveredKeyManagementServiceName)) {
		$KmsDns = "Découverte automatique DNS : nom KMS non disponible"
		if ($Vista -And -Not $Admin) {$KmsDns = "Découverte automatique DNS : Exécutez le script en tant qu'administrateur pour récupérer les informations"}
	} autre {
		si (-Non $DiscoveredKeyManagementServicePort) {$DiscoveredKeyManagementServicePort = 1688}
		$KmsDns = "Nom de la machine KMS provenant du DNS : ${DiscoveredKeyManagementServiceName}:${DiscoveredKeyManagementServicePort}"
	}

	si ($null -NE $KMSCaching) {
		si ($KMSCaching -EQ "TRUE") {$KMSCaching = "Activé"} sinon {$KMSCaching = "Désactivé"}
	}

	si ($strSLP -EQ $wslp -Et $NT9) {
		si ([String]::IsNullOrEmpty($DiscoveredKeyManagementServiceIpAddress)) {
			$DiscoveredKeyManagementServiceIpAddress = "non disponible"
		}
	}

	CONOUT "Informations client du service de gestion des clés :"
	CONOUT " ID de la machine cliente (CMID) : $ClientMachineID"
	si ($null -EQ $KmsReg) {
		CONOUT " $KmsDns"
		CONOUT " Nom de la machine KMS enregistrée : nom KMS non disponible"
	} autre {
		CONOUT " $KmsReg"
	}
	if ($null -NE $DiscoveredKeyManagementServiceIpAddress) {CONOUT " Adresse IP de la machine KMS : $DiscoveredKeyManagementServiceIpAddress"}
	CONOUT " PID étendu de la machine KMS : $CustomerPID"
	CONOUT " Intervalle d'activation : $VLActivationInterval minutes"
	CONOUT " Intervalle de renouvellement : $VLRenewalInterval minutes"
	if ($null -NE $KMSCaching) {CONOUT " Cache hôte KMS : $KMSCaching"}
	if (-Not [String]::IsNullOrEmpty($KeyManagementServiceLookupDomain)) {CONOUT " Domaine de recherche d'enregistrement SRV KMS : $KeyManagementServiceLookupDomain"}
}

fonction GetResult($strSLP, $strApp, $entry)
{
	$licID = $entry.id
	$propPrd | foreach { set $_ (SlGetInfoSku $licID $_) }
	. SlGetInfoLicensing $strApp $licID
	$LicenseStatus = $dwStatus
	$LicReason = $hrReason
	$EvaluationEndDate = $qwValidity
	$gprMnt = $dwGrace

	$pkid = $entry.pk
	$isPPK = $null -NE $pkid

	$add_on = $Name.IndexOf("module complémentaire pour", 5)
	si ($add_on -NE -1) {
		$Nom = $Nom.Substring(0, $add_on + 7)
	}

	$licPHN = "vide"
	si ($Dlv -Ou $All.IsPresent) {
		$licPHN = SlGetInfoSku $licID "msft:sl/EUL/PHONE/PUBLIC"
	}

	si ($LicenseStatus -EQ 0 -Et !$isPPK) {
		& $isAll
		CONOUT "Nom : $Name"
		CONOUT "Description : $Description"
		CONOUT "ID d'activation : $licID"
		CONOUT "Statut de licence : Non autorisé"
		si ($licPHN -NE "vide") {
			$gPHN = [String]::IsNullOrEmpty($licPHN) -NE $true
			CONOUT "Téléphone activable : $($gPHN.ToString())"
		}
		retour
	}

	$winID = ($strApp -EQ $winApp)
	$winPR = ($winID -Et -Pas $entry.ex)
	$Vista = ($winID -Et $NT6 -Et -Pas $NT7)
	$NT5 = ($strSLP -EQ $wslp -Et $winbuild -LT 6001)
	$win8 = ($strSLP -EQ $wslp -Et $NT8)
	$reapp = ("Windows", "Application")[!$winID]
	$prmnt = ("machine", "produit")[!$winPR]

	if ($Description.Contains("VOLUME_KMSCLIENT")) {$cKmsClient = 1; $actTag = "Volume"}
	if ($Description.Contains("TIMEBASED_")) {$cTblClient = 1; $actTag = "Timebased"}
	if ($Description.Contains("VIRTUAL_MACHINE_ACTIVATION")) {$cAvmClient = 1; $actTag = "VM automatique"}
	si ($null -EQ $cKmsClient -Et $Description.Contains("VOLUME_KMS")) {$cKmsServer = 1}

	$gprDay = [Math]::Round($gprMnt/1440)
	$_xpr = ""
	$inGrace = $false
	si ($gprMnt -GT 0) {
		$_xpr = [DateTime]::Now.AddMinutes($gprMnt).ToString('yyyy-MM-dd hh:mm:ss tt')
		$inGrace = $true
	}

	$LicenseMsg = "Temps restant : $gprMnt minute(s) ($gprDay jour(s))"
	si ($LicenseStatus -EQ 0) {
		$LicenseInf = "Sans licence"
		$LicenseMsg = $null
	}
	si ($LicenseStatus -EQ 1) {
		$LicenseInf = "Sous licence"
		si ($gprMnt -EQ 0) {
			$LicenseMsg = $null
			$ExpireMsg = "Le $prmnt est activé de façon permanente."
		} autre {
			$LicenseMsg = "Expiration de l'activation de $actTag : $gprMnt minute(s) ($gprDay jour(s))"
			if ($inGrace) {$ExpireMsg = "L'activation de $actTag expirera le $_xpr"}
		}
	}
	si ($LicenseStatus -EQ 2) {
		$LicenseInf = "Période de grâce initiale"
		if ($inGrace) {$ExpireMsg = "$LicenseInf se termine $_xpr"}
	}
	si ($LicenseStatus -EQ 3) {
		$LicenseInf = "Période de grâce supplémentaire (licence KMS expirée ou matériel hors tolérance)"
		if ($inGrace) {$ExpireMsg = "La période de grâce supplémentaire se termine le $_xpr"}
	}
	si ($LicenseStatus -EQ 4) {
		$LicenseInf = "Période de grâce non authentique"
		if ($inGrace) {$ExpireMsg = "$LicenseInf se termine $_xpr"}
	}
	si ($LicenseStatus -EQ 5 -Et -Pas $NT5) {
		$LicenseReason = '0x{0:X}' -f $LicReason
		$LicenseInf = "Notification"
		$LicenseMsg = "Motif de la notification : $LicenseReason"
		if ($LicenseReason -EQ "0xC004F00F") {if ($null -NE $cKmsClient) {$LicenseMsg = $LicenseMsg + " (Licence KMS expirée)."} else {$LicenseMsg = $LicenseMsg + " (Matériel hors tolérance)."}}
		if ($LicenseReason -EQ "0xC004F200") {$LicenseMsg = $LicenseMsg + " (non authentique)."}
		if ($LicenseReason -EQ "0xC004F009" -Or $LicenseReason -EQ "0xC004F064") {$LicenseMsg = $LicenseMsg + " (délai de grâce expiré)."}
	}
	si ($LicenseStatus -GT 5 -Ou ($LicenseStatus -GT 4 -Et $NT5)) {
		$LicenseInf = "Inconnu"
		$LicenseMsg = $null
	}
	si ($LicenseStatus -EQ 6 -Et -Pas $Vista -Et -Pas $NT5) {
		$LicenseInf = "Période de grâce prolongée"
		if ($inGrace) {$ExpireMsg = "$LicenseInf se termine $_xpr"}
	}

	si ($isPPK) {
		$propPkey | foreach { set $_ (SlGetInfoPKey $pkid $_) }
	}

	si ($winPR -Et $isPPK -Et -Pas $NT8) {
		$uxd = SlGetInfoSku $licID 'UXDifferentiator'
		$script:primaire += @{
			aide = $licID;
			ppk = $PartialProductKey;
			chn = $Channel;
			lst = $LicenseStatus;
			lcr = $LicReason;
			ged = $gprMnt;
			evl = $EvaluationEndDate;
			dff = $uxd
		}
	}

	si ($IID -Et $isPPK) {
		$OfflineInstallationId = SlGetInfoIID $licID
	}

	si ($Dlv) {
		si ($win8)
		{
			$RemainingSkuRearmCount = SlGetInfoSku $licID 'RemainingRearmCount'
			$RemainingAppReArmCount = SlGetInfoApp $strApp 'RemainingRearmCount'
		}
		autre
		{
			si (($winID -Et $NT7) -Ou $strSLP -Égal à $oslp)
			{
				$RemainingSLReArmCount = SlGetInfoApp $strApp 'RemainingRearmCount'
			}
			autre
			{
				$RemainingSLReArmCount = SlGetInfoService 'RearmCount'
			}
		}
		si ($null -EQ $TrustedTime)
		{
			$TrustedTime = SlGetInfoSvcApp $strApp 'TrustedTime'
		}
	}

	& $isAll
	CONOUT "Nom : $Name"
	CONOUT "Description : $Description"
	CONOUT "ID d'activation : $licID"
	if ($null -NE $DigitalPID) {CONOUT "PID étendu : $DigitalPID"}
	if ($null -NE $DigitalPID2 -And $Dlv) {CONOUT "ID produit : $DigitalPID2"}
	if ($null -NE $OfflineInstallationId -And $IID) {CONOUT "ID d'installation : $OfflineInstallationId"}
	if ($null -NE $Channel) {CONOUT "Product Key Channel: $Channel"}
	if ($null -NE $PartialProductKey) {CONOUT "Clé de produit partielle : $PartialProductKey"}
	CONOUT "Statut de la licence : $LicenseInf"
	if ($null -NE $LicenseMsg) {CONOUT "$LicenseMsg"}
	if ($LicenseStatus -NE 0 -And $EvaluationEndDate) {
		$EED = [DateTime]::FromFileTimeUtc($EvaluationEndDate).ToString('yyyy-MM-dd hh:mm:ss tt')
		CONOUT "Date de fin d'évaluation : $EED UTC"
	}
	si ($LicenseStatus -NE 1 -Et $licPHN -NE "vide") {
		$gPHN = [String]::IsNullOrEmpty($licPHN) -NE $true
		CONOUT "Téléphone activable : $($gPHN.ToString())"
	}
	si ($Dlv) {
		si ($null -NE $RemainingSLReArmCount) {
			CONOUT "Nombre de réarmements restants : $RemainingSLReArmCount"
		}
		si ($null -NE $RemainingSkuReArmCount) {
			CONOUT "Nombre de réarmements restants : $RemainingAppReArmCount"
			CONOUT "Nombre de réarmements SKU restants : $RemainingSkuReArmCount"
		}
		si ($LicenseStatus -NE 0 -Et $TrustedTime) {
			$TTD = [DateTime]::FromFileTime($TrustedTime).ToString('yyyy-MM-dd hh:mm:ss tt')
			CONOUT "Heure de confiance : $TTD"
		}
	}
	si (!$isPPK) {
		retour
	}

	si ($win8 -Et $VLActivationType -EQ 1) {
		DétecterAdbaClient
		$cKmsClient = $null
	}

	si ($winID -Et $null -NE $cAvmClient) {
		DétecterAvmClient
	}

	$chkSub = ($winPR -Et $isSub)

	$chkSLS = ($null -NE $cKmsClient -Ou $null -NE $cKmsServer -Ou $chkSub)

	si (!$chkSLS) {
		if ($null -NE $ExpireMsg) {CONOUT "`n $ExpireMsg"}
		retour
	}

	si ($null -NE $cKmsClient) {
		DétecterKmsClient
	}

	si ($null -NE $cKmsServer) {
		if ($null -NE $ExpireMsg) {CONOUT "`n $ExpireMsg"}
		DetectKmsHost
	} autre {
		if ($null -NE $ExpireMsg) {CONOUT "`n $ExpireMsg"}
	}

	si ($chkSub) {
		DetectSubscription
	}

}

fonction ParseList($strSLP, $strApp, $arrList)
{
	pour chaque ($entry dans $arrList)
	{
		GetResult $strSLP $strApp $entrée
		CONOUT "$line3"
		& $noAll
	}
}
#endregion

#région vNextDiag
si ($PSVersionTable.PSVersion.Major -Lt 3)
{
	fonction ConvertFrom-Json
	{
		[CmdletBinding()]
		Param(
			[Paramètre(ValeurDePipeline=$true)][Objet]$item
		)
		[void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
		$psjs = New-Object System.Web.Script.Serialization.JavaScriptSerializer
		Retour,$psjs.DeserializeObject($item)
	}
	fonction ConvertTo-Json
	{
		[CmdletBinding()]
		Param(
			[Paramètre(ValeurDePipeline=$true)][Objet]$item
		)
		[void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
		$psjs = New-Object System.Web.Script.Serialization.JavaScriptSerializer
		Retourne $psjs.Serialize($item)
	}
}

fonction PrintModePerPridFromRegistry
{
	$vNextRegkey = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\Licensing\LicensingNext"
	$vNextPrids = Get-Item -Path $vNextRegkey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'property' -ErrorAction SilentlyContinue | Where-Object -FilterScript {$_.ToLower() -like "*retail" -or $_.ToLower() -like "*volume"}
	Si ($null -Eq $vNextPrids)
	{
		CONOUT "`nAucune clé de registre trouvée."
		Retour
	}
	CONOUT "`r"
	$vNextPrids | PourChaque `
	{
		$mode = (Get-ItemProperty -Path $vNextRegkey -Name $_).$_
		Commutateur ($mode)
		{
			2 { $mode = "vNext"; Break }
			3 { $mode = "Device"; Break }
			Par défaut { $mode = "Legacy"; Break }
		}
		CONOUT "$_ = $mode"
	}
}

fonction PrintSharedComputerLicensing
{
	$scaRegKey = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
	$scaValue = Get-ItemProperty -Path $scaRegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "SharedComputerLicensing" -ErrorAction SilentlyContinue
	$scaRegKey2 = "HKLM:\SOFTWARE\Microsoft\Office\16.0\Common\Licensing"
	$scaValue2 = Get-ItemProperty -Path $scaRegKey2 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "SharedComputerLicensing" -ErrorAction SilentlyContinue
	$scaPolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Licensing"
	$scaPolicyValue = Get-ItemProperty -Path $scaPolicyKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "SharedComputerLicensing" -ErrorAction SilentlyContinue
	Si ($null -Eq $scaValue -Et $null -Eq $scaValue2 -Et $null -Eq $scaPolicyValue)
	{
		CONOUT "`nAucune clé de registre trouvée."
		Retour
	}
	$scaModeValue = $scaValue -Ou $scaValue2 -Ou $scaPolicyValue
	Si ($scaModeValue -Eq 0)
	{
		$scaMode = "Désactivé"
	}
	Si ($scaModeValue -Eq 1)
	{
		$scaMode = "Activé"
	}
	CONOUT "`nStatus: $scaMode"
	CONOUT "`r"
	$tokenFiles = $null
	$tokenPath = "${env:LOCALAPPDATA}\Microsoft\Office\16.0\Licensing"
	Si (Test-Path $tokenPath)
	{
		$tokenFiles = Get-ChildItem -Path $tokenPath -Filter "*authString*" -Recurse | Where-Object { !$_.PSIsContainer }
	}
	Si ($null -Eq $tokenFiles -Or $tokenFiles.Length -Eq 0)
	{
		CONOUT "Aucun jeton trouvé."
		Retour
	}
	$tokenFiles | PourChaque `
	{
		$tokenParts = (Get-Content -Encoding Unicode -Path $_.FullName).Split('_')
		$output = New-Object PSObject
		$output | Add-Member 8 'ACID' $tokenParts[0];
		$output | Add-Member 8 'User' $tokenParts[3];
		$output | Add-Member 8 'NotBefore' $tokenParts[4];
		$output | Add-Member 8 'NotAfter' $tokenParts[5];
		Écrire-Sortie $sortie
	}
}

fonction PrintLicensesInformation
{
	Param(
		[ValidateSet("NUL", "Device")]
		[Chaîne]$mode
	)
	Si ($mode -Eq "NUL")
	{
		$licensePath = "${env:LOCALAPPDATA}\Microsoft\Office\Licenses"
	}
	Sinon, si ($mode -Eq "Device")
	{
		$licensePath = "${env:PROGRAMDATA}\Microsoft\Office\Licenses"
	}
	$fichiers_licence = $null
	Si (Test-Path $licensePath)
	{
		$licenseFiles = Get-ChildItem -Path $licensePath -Recurse | Where-Object { !$_.PSIsContainer }
	}
	Si ($null -Eq $licenseFiles -Or $licenseFiles.Length -Eq 0)
	{
		CONOUT "`nAucune licence trouvée."
		Retour
	}
	$fichiers_de_licence | Pour chaque `
	{
		$license = (Get-Content -Encoding Unicode $_.FullName | ConvertFrom-Json).License
		$license décodée = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($license)) | ConvertFrom-Json
		$licenseType = $decodedLicense.LicenseType
		Si ($null -Ne $decodedLicense.ExpiresOn)
		{
			$expirey = [System.DateTime]::Parse($decodedLicense.ExpiresOn, $null, 'AdjustToUniversal')
		}
		Autre
		{
			$expiration = New-Object System.DateTime
		}
		$licenseState = "Grace"
		Si ((Get-Date) -Gt (Get-Date $decodedLicense.Metadata.NotAfter))
		{
			$licenseState = "RFM"
		}
		SinonSi ((Obtenir-Date) -Lt (Obtenir-Date $expiration))
		{
			$licenseState = "Licencié"
		}
		$output = New-Object PSObject
		$output | Add-Member 8 'Fichier' $_.PSChildName;
		$output | Add-Member 8 'Version' $_.Directory.Name;
		$output | Add-Member 8 'Type' "User|${licenseType}";
		$output | Add-Member 8 'Product' $decodedLicense.ProductReleaseId;
		$output | Add-Member 8 'Acid' $decodedLicense.Acid;
		Si ($mode -Eq "Device") { $output | Add-Member 8 'DeviceId' $decodedLicense.Metadata.DeviceId; }
		$output | Add-Member 8 'LicenseState' $licenseState;
		$output | Add-Member 8 'EntitlementStatus' $decodedLicense.Status;
		$output | Add-Member 8 'EntitlementExpiration' ("N/A", $decodedLicense.ExpiresOn)[!($null -eq $decodedLicense.ExpiresOn)];
		$output | Add-Member 8 'ReasonCode' ("N/A", $decodedLicense.ReasonCode)[!($null -eq $decodedLicense.ReasonCode)];
		$output | Add-Member 8 'NotBefore' $decodedLicense.Metadata.NotBefore;
		$output | Add-Member 8 'NotAfter' $decodedLicense.Metadata.NotAfter;
		$output | Add-Member 8 'NextRenewal' $decodedLicense.Metadata.RenewAfter;
		$output | Add-Member 8 'TenantId' ("N/A", $decodedLicense.Metadata.TenantId)[!($null -eq $decodedLicense.Metadata.TenantId)];
		#$output.PSObject.Properties | foreach { $ht = @{} } { $ht[$_.Name] = $_.Value } { $output = $ht | ConvertTo-Json }
		Écrire-Sortie $sortie
	}
}

fonction vNextDiagRun
{
	$fNUL = ([IO.Directory]::Exists("${env:LOCALAPPDATA}\Microsoft\Office\Licenses")) -and ([IO.Directory]::GetFiles("${env:LOCALAPPDATA}\Microsoft\Office\Licenses", "*", 1).Length -GT 0)
	$fDev = ([IO.Directory]::Exists("${env:PROGRAMDATA}\Microsoft\Office\Licenses")) -and ([IO.Directory]::GetFiles("${env:PROGRAMDATA}\Microsoft\Office\Licenses", "*", 1).Length -GT 0)
	$rPID = $null -NE (GP "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\Licensing\LicensingNext" -EA 0 | select -Expand 'property' -EA 0 | where -Filter {$_.ToLower() -like "*retail" -or $_.ToLower() -like "*volume"})
	$rSCA = $null -NE (GP "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -EA 0 | select -Expand "SharedComputerLicensing" -EA 0)
	$rSCL = $null -NE (GP "HKLM:\SOFTWARE\Microsoft\Office\16.0\Common\Licensing" -EA 0 | select -Expand "SharedComputerLicensing" -EA 0)

	si (($fNUL -Ou $fDev -Ou $rPID -Ou $rSCA -Ou $rSCL) -EQ $false) {
		Retour
	}

	& $isAll
	CONOUT "$line2"
	CONOUT "=== Statut Office vNext ==="
	CONOUT "$line2"
	CONOUT "`n========== Mode par ProductReleaseId =========="
	Mode d'impression par identifiant à partir du registre
	CONOUT "`n========== Licence d'ordinateur partagé =========="
	Licence d'ordinateur partagé d'impression
	CONOUT "`n========== vNext licences ==========="
	PrintLicensesInformation -Mode "NUL"
	CONOUT "`n========== Licences d'appareil =========="
	PrintLicensesInformation -Mode "Périphérique"
	CONOUT "$line3"
	CONOUT "`r"
}
#endregion

#région clic

<#
;;; Source : https://github.com/asdcorp/clic
;;; Port PowerShell : abbodi1406

Copyright 2023 asdcorp

L'autorisation est accordée par la présente, à titre gratuit, à toute personne obtenant une copie de
ce logiciel et les fichiers de documentation associés (le « Logiciel »), pour traiter de
le Logiciel sans restriction, y compris, sans limitation, les droits à
utiliser, copier, modifier, fusionner, publier, distribuer, concéder en sous-licence et/ou vendre des copies de
le Logiciel, et de permettre aux personnes auxquelles le Logiciel est fourni de le faire,
sous réserve des conditions suivantes :

La mention de droit d'auteur ci-dessus et la présente mention d'autorisation doivent être incluses dans tous les documents.
copies ou parties substantielles du Logiciel.

LE LOGICIEL EST FOURNI « TEL QUEL », SANS GARANTIE D'AUCUNE SORTE, EXPRESSE OU IMPLICITE.
LES GARANTIES IMPLICITES, Y COMPRIS, MAIS SANS S'Y LIMITER, LES GARANTIES DE QUALITÉ MARCHANDE ET D'ADÉQUATION À UN USAGE PARTICULIER
POUR UN USAGE PARTICULIER ET SANS CONTREFAÇON. EN AUCUN CAS LES AUTEURS OU
LES TITULAIRES DE DROITS D'AUTEUR NE SERONT PAS RESPONSABLES DE TOUTE RÉCLAMATION, DE TOUT DOMMAGE OU DE TOUTE AUTRE RESPONSABILITÉ, QU'ELLE SOIT
DANS UNE ACTION CONTRACTUELLE, DÉLICTUELLE OU AUTRE, DÉCOULANT DE, OU DANS
LIEN AVEC LE LOGICIEL OU SON UTILISATION OU AUTRES TRANSACTIONS RELATIVES AU LOGICIEL.
#>

fonction InitializeDigitalLicenseCheck {
	$CAB = [System.Reflection.Emit.CustomAttributeBuilder]

	$ICom = $Module.DefineType('EUM.IEUM', 'Public, Interface, Abstract, Import')
	$ICom.SetCustomAttribute($CAB::new([System.Runtime.InteropServices.ComImportAttribute].GetConstructor(@()), @()))
	$ICom.SetCustomAttribute($CAB::new([System.Runtime.InteropServices.GuidAttribute].GetConstructor(@([String])), @('F2DCB80D-0670-44BC-9002-CD18688730AF')))
	$ICom.SetCustomAttribute($CAB::new([System.Runtime.InteropServices.InterfaceTypeAttribute].GetConstructor(@([Int16])), @([Int16]1)))

	1..4 | % { [void]$ICom.DefineMethod('VF'+$_, 'Public, Virtual, HideBySig, NewSlot, Abstract', 'Standard, HasThis', [Void], @()) }
	[void]$ICom.DefineMethod('AcquireModernLicenseForWindows', 1478, 33, [Int32], @([Int32], [Int32].MakeByRefType()))

	$IEUM = $ICom.CreateType()
}

fonction PrintStateData {
	$pwszStateData = 0
	$cbSize = 0

	si ($Win32::SLGetWindowsInformation(
		"Security-SPP-Action-StateData",
		[ref]$null,
		[ref]$cbSize,
		[ref]$pwszStateData
	)) {
		renvoyer $FAUX
	}

	[string[]]$pwszStateString = $Marshal::PtrToStringUni($pwszStateData) -replace ";", "`n "
	CONOUT (" $pwszStateString")

	$Marshal::FreeHGlobal($pwszStateData)
	renvoyer $TRUE
}

fonction PrintLastActivationHResult {
	$pdwLastHResult = 0
	$cbSize = 0

	si ($Win32::SLGetWindowsInforma tion(
		"Security-SPP-LastWindowsActivationHResult",
		[ref]$null,
		[ref]$cbSize,
		[ref]$pdwDernierRésultatHR
	)) {
		renvoyer $FAUX
	}

	CONOUT (" LastActivationHResult=0x{0:x8}" -f $Marshal::ReadInt32($pdwLastHResult))

	$Marshal::FreeHGlobal($pdwLastHResult)
	renvoyer $TRUE
}

fonction PrintLastActivationTime {
	$pqwDernièreHeure = 0
	$cbSize = 0

	si ($Win32::SLGetWindowsInformation(
		"Security-SPP-LastWindowsActivationTime",
		[ref]$null,
		[ref]$cbSize,
		[ref]$pqwDernièreFois
	)) {
		renvoyer $FAUX
	}

	$actTime = $Marshal::ReadInt64($pqwLastTime)
	si ($actTime -ne 0) {
		CONOUT (" LastActivationTime={0}" -f [DateTime]::FromFileTimeUtc($actTime).ToString("yyyy/MM/dd:HH:mm:ss"))
	}

	$Marshal::FreeHGlobal($pqwLastTime)
	renvoyer $TRUE
}

fonction PrintIsWindowsGenuine {
	$dwGenuine = 0

	si ($Win32::SLIsWindowsGenuineLocal([ref]$dwGenuine)) {
		renvoyer $FAUX
	}

	si ($dwGenuine -lt 5) {
		CONOUT (" IsWindowsGenuine={0}" -f $ppwszGenuineStates[$dwGenuine])
	} autre {
		CONOUT (" IsWindowsGenuine={0}" -f $dwGenuine)
	}

	renvoyer $TRUE
}

fonction PrintDigitalLicenseStatus {
	essayer {
		Initialiser la vérification de la licence numérique
		$ComObj = New-Object -Com EditionUpgradeManagerObj.EditionUpgradeManager
	} attraper {
		renvoyer $FAUX
	}

	$paramètres = 1, $null

	si ([EUM.IEUM].GetMethod("AcquireModernLicenseForWindows").Invoke($ComObj, $parameters)) {
		renvoyer $FAUX
	}

	$dwReturnCode = $parameters[1]
	[bool]$bDigitalLicense = $FALSE

	$bDigitalLicense = (($dwReturnCode -ge 0) -et ($dwReturnCode -ne 1))
	CONOUT (" IsDigitalLicense={0}" -f (BoolToWStr $bDigitalLicense))

	renvoyer $TRUE
}

fonction PrintSubscriptionStatus {
	$dwSupported = 0

	si ($winbuild -ge 15063) {
		$pwszPolicy = "ConsumeAddonPolicySet"
	} autre {
		$pwszPolicy = "Autoriser-WindowsSubscription"
	}

	si ($Win32::SLGetWindowsInformationDWORD($pwszPolicy, [ref]$dwSupported)) {
		renvoyer $FAUX
	}

	CONOUT (" SubscriptionSupportedEdition={0}" -f (BoolToWStr $dwSupported))

	$pStatus = $Marshal::AllocHGlobal($Marshal::SizeOf([Type]$SubStatus))
	si ($Win32::ClipGetSubscriptionStatus([ref]$pStatus)) {
		renvoyer $FAUX
	}

	$sStatus = [Activator]::CreateInstance($SubStatus)
	$sStatus = $Marshal::PtrToStructure($pStatus, [Type]$SubStatus)
	$Marshal::FreeHGlobal($pStatus)

	CONOUT (" SubscriptionEnabled={0}" -f (BoolToWStr $sStatus.dwEnabled))

	si ($sStatus.dwEnabled -eq 0) {
		renvoyer $TRUE
	}

	CONOUT (" SubscriptionSku={0}" -f $sStatus.dwSku)
	CONOUT (" SubscriptionState={0}" -f $sStatus.dwState)

	renvoyer $TRUE
}

fonction ClicRun
{
	& $isAll
	CONOUT "Informations de vérification des licences client :"

	$null = PrintStateData
	$null = PrintLastActivationHResult
	$null = PrintLastActivationTime
	$null = PrintIsWindowsGenuine

	si ($DllDigital) {
		$null = PrintDigitalLicenseStatus
	}

	si ($DllSubscription) {
		$null = PrintSubscriptionStatus
	}

	CONOUT "$line3"
	& $noAll
}
#endregion

#région clc
fonction clcGetExpireKrn
{
	$tData = 0
	$cData = 0
	$bData = 0

	$hrRet = $Win32::SLGetWindowsInformation(
		"Noyau-ExpirationDate",
		[ref]$tData,
		[ref]$cData,
		[ref]$bData
	)

	si ($hrRet -Ou !$cData -Ou $tData -NE 3)
	{
		renvoyer $null
	}

	$année = $Marshal::ReadInt16($bData, 0)
	si ($année -EQ 0 -Ou $année -EQ 1601)
	{
		$rData = $null
	}
	autre
	{
		$rData = '{0}/{1}/{2}:{3}:{4}:{5}' -f $year, $Marshal::ReadInt16($bData, 2), $Marshal::ReadInt16($bData, 4), $Marshal::ReadInt16($bData, 6), $Marshal::ReadInt16($bData, 8), $Marshal::ReadInt16($bData, 10)
	}

	#$Marshal::FreeHGlobal($bData)
	renvoyer $rData
}

fonction clcGetExpireSys
{
	$kuser = $Marshal::ReadInt64((New-Object IntPtr(0x7FFE02C8)))

	si ($kuser -EQ 0)
	{
		renvoyer $null
	}

	$rData = [DateTime]::FromFileTimeUtc($kuser).ToString('yyyy/MM/dd:HH:mm:ss')
	renvoyer $rData
}

fonction clcGetLicensingState($dwState)
{
	si ($dwState -EQ 5) {
		$dwState = 3
	} elseif ($dwState -EQ 3 -Ou $dwState -EQ 4 -Ou $dwState -EQ 6) {
		$dwState = 2
	} elseif ($dwState -GT 6) {
		$dwState = 4
	}

	$rData = '{0}' -f $ppwszLicensingStates[$dwState]
	renvoyer $rData
}

fonction clcGetGenuineState($AppId)
{
	$dwGenuine = 0

	si ($NT7) {
		$hrRet = $Win32::SLIsWindowsGenuineLocal([ref]$dwGenuine)
	} autre {
		$hrRet = $Win32::SLIsGenuineLocal([ref][Guid]$AppId, [ref]$dwGenuine, 0)
	}

	si ($hrRet)
	{
		$dwGenuine = 4
	}

	si ($dwGenuine -LT 5) {
		$rData = '{0}' -f $ppwszGenuineStates[$dwGenuine]
	} autre {
		$rData = $dwGenuine
	}
	renvoyer $rData
}

fonction ClcRun
{
	$prs = $script:primary[0]
	si ($null -EQ $prs) {
		retour
	}

	$lState = clcGetLicensingState $prs.lst
	$uState = clcGetGenuineState $winApp
	$TbbKrn = clcGetExpireKrn
	$TbbSys = clcGetExpireSys
	si ($null -NE $TbbKrn) {
		$ked = $TbbKrn
	} elseif ($null -NE $TbbSys) {
		$ked = $TbbSys
	}

	& $isAll
	CONOUT "Informations de vérification des licences client :"

	CONOUT (" AppId={0}" -f $winApp)
	if ($prs.ged) { CONOUT (" GraceEndDate={0}" -f ([DateTime]::UtcNow.AddMinutes($prs.ged).ToString('yyyy/MM/dd:HH:mm:ss'))) }
	if ($null -NE $ked) { CONOUT (" KernelTimebombDate={0}" -f $ked) }
	CONOUT (" LastConsumptionReason=0x{0:x8}" -f $prs.lcr)
	if ($prs.evl) { CONOUT (" LicenseExpirationDate={0}" -f ([DateTime]::FromFileTimeUtc($prs.evl).ToString('yyyy/MM/dd:HH:mm:ss'))) }
	CONOUT (" LicenseState={0}" -f $lState)
	CONOUT (" PartialProductKey={0}" -f $prs.ppk)
	CONOUT (" ProductKeyType={0}" -f $prs.chn)
	CONOUT (" SkuId={0}" -f $prs.aid)
	CONOUT (" uxDifferentiator={0}" -f $prs.dff)
	CONOUT (" IsWindowsGenuine={0}" -f $uState)

	CONOUT "$line3"
	& $noAll
}
#endregion

$Host.UI.RawUI.WindowTitle = "Vérifier l'état d'activation"
si ($All.IsPresent) {
	$B=$Host.UI.RawUI.BufferSize;$B.Height=3000;$Host.UI.RawUI.BufferSize=$B;
	si (!$Pass.IsPresent) {effacer;}
}

$SysPath = "$env:SystemRoot\System32"
si (Test-Path "$env:SystemRoot\Sysnative\reg.exe") {
	$SysPath = "$env:SystemRoot\Sysnative"
}

$wslp = "SoftwareLicensingProduct"
$wsls = "SoftwareLicensingService"
$oslp = "Produit de protection des logiciels Office"
$osls = "Service de protection des logiciels Office"
$winApp = "55c92734-d682-4d71-983e-d6ec3f16059f"
$o14App = "59a52881-a989-479d-af46-f275c6370663"
$o15App = "0ff1ce15-a989-479d-af46-f275c6370663"
$isSub = ($winbuild -GE 26000) -And (Select-String -Path "$SysPath\wbem\sppwmi.mof" -Encoding unicode -Pattern "SubscriptionType")
$DllDigital = ($winbuild -GE 14393) -And (Test-Path "$SysPath\EditionUpgradeManagerObj.dll")
$DllSubscription = ($winbuild -GE 14393) -And (Test-Path "$SysPath\Clipc.dll")
$VLActTypes = @("Tous", "AD", "KMS", "Jeton")
$OPKeyPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform"
$SPKeyPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform"
$SLKeyPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SL"
$NSKeyPath = "HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SL"
$propPrd = 'Nom', 'Description', 'TrustedTime', 'VLActivationType'
$propPkey = 'PartialProductKey', 'Channel', 'DigitalPID', 'DigitalPID2'
$propKMSServer = 'KeyManagementServiceCurrentCount', 'KeyManagementServiceTotalRequests', 'KeyManagementServiceFailedRequests', 'KeyManagementServiceUnlicensedRequests', 'KeyManagementServiceLicensedRequests', 'KeyManagementServiceOOBGraceRequests', 'KeyManagementServiceOOTGraceRequests', 'KeyManagementServiceNonGenuineGraceRequests', 'KeyManagementServiceNotificationRequests'
$propKMSClient = 'CustomerPID', 'KeyManagementServiceName', 'KeyManagementServicePort', 'DiscoveredKeyManagementServiceName', 'DiscoveredKeyManagementServicePort', 'DiscoveredKeyManagementServiceIpAddress', 'VLActivationInterval', 'VLRenewalInterval', 'KeyManagementServiceLookupDomain'
$propKMSVista = 'CustomerPID', 'KeyManagementServiceName', 'VLActivationInterval', 'VLRenewalInterval'
$propADBA = 'ADActivationObjectName', 'ADActivationObjectDN', 'ADActivationCsvlkPID', 'ADActivationCsvlkSkuID'
$propAVMA = 'InheritedActivationId', 'InheritedActivationHostMachineName', 'InheritedActivationHostDigitalPid2', 'InheritedActivationActivationTime'
$primaire = @()
$ppwszGenuineStates = @(
	"SL_GEN_STATE_IS_GENUINE",
	"SL_GEN_STATE_INVALID_LICENSE",
	"SL_GEN_STATE_TAMPERED",
	"SL_GEN_STATE_OFFLINE",
	"SL_GEN_STATE_LAST"
)
$ppwszLicensingStates = @(
	"SL_LICENSING_STATUS_SANS_LICENCE",
	"SL_LICENSING_STATUS_LICENSED",
	"SL_LICENSING_STATUS_IN_GRACE_PERIOD",
	"SL_LICENSING_STATUS_NOTIFICATION",
	"SL_LICENSING_STATUS_LAST"
)

'cW1nd0ws', 'c0ff1ce15', 'c0ff1ce14', 'ospp14', 'ospp15' | foreach {set $_ @()}

$offsvc = "osppsvc"
si ($NT7 -Ou -Non $NT6) {$winsvc = "sppsvc"} sinon {$winsvc = "slsvc"}

try {gsv $winsvc -EA 1 | Out-Null; $WsppHook = 1} catch {$WsppHook = 0}
try {gsv $offsvc -EA 1 | Out-Null; $OsppHook = 1} catch {$OsppHook = 0}

si (Test-Path "$SysPath\sppc.dll") {
	$SLdll = 'sppc.dll'
} elseif (Test-Path "$SysPath\slc.dll") {
	$SLdll = 'slc.dll'
} autre {
	$WsppHook = 0
}

si ($OsppHook -NE 0) {
	$OLdll = (strGetRegistry $OPKeyPath "Chemin") + 'osppc.dll'
	if (!(Test-Path "$OLdll")) {$OsppHook = 0}
}

si ($WsppHook -NE 0) {
	si ($NT6 -Et -Pas $NT7 -Et -Pas $Admin) {
		if ($null -EQ [Diagnostics.Process]::GetProcessesByName("$winsvc" )[0].ProcessName) {$WsppHook = 0; CONOUT "`nErreur : échec du démarrage du service $winsvc.`n"}
	} autre {
		try {sasv $winsvc -EA 1} catch {$WsppHook = 0; CONOUT "`nErreur : échec du démarrage du service $winsvc.`n"}
	}
}

si ($WsppHook -NE 0) {
	InitialiserPInvoke $SLdll $false
	$hSLC = 0
	[void]$Win32::SLOpen([ref]$hSLC)

	$cW1nd0ws = SlGetInfoSLID $winApp
	$c0ff1ce15 = SlGetInfoSLID $o15App
	$c0ff1ce14 = SlGetInfoSLID $o14App
}

si ($cW1nd0ws.Count -GT 0)
{
	echoWindows
	Analyser la liste $wslp $winApp $cW1nd0ws
}
sinon si ($NT6)
{
	echoWindows
	CONOUT "Erreur : clé de produit introuvable.`n"
}

si ($NT6 -Et -Pas $NT8) {
	ClcRun
}

si ($NT8) {
	ClicRun
}

$doMSG = 1

si ($c0ff1ce15.Count -GT 0)
{
	CheckOhook
	echoOffice
	ParseList $wslp $o15App $c0ff1ce15
}

si ($c0ff1ce14.Count -GT 0)
{
	echoOffice
	ParseList $wslp $o14App $c0ff1ce14
}

si ($hSLC) {
	[void]$Win32::SLClose($hSLC)
}

si ($OsppHook -NE 0) {
	try {sasv $offsvc -EA 1} catch {$OsppHook = 0; CONOUT "`nErreur : échec du démarrage du service $offsvc.`n"}
}

si ($OsppHook -NE 0) {
	InitialiserPInvoke "$OLdll" $true
	$hSLC = 0
	[void]$Win32::SLOpen([ref]$hSLC)

	$ospp15 = SlGetInfoSLID $o15App
	$ospp14 = SlGetInfoSLID $o14App
}

si ($ospp15.Count -GT 0)
{
	echoOffice
	ParseList $oslp $o15App $ospp15
}

si ($ospp14.Count -GT 0)
{
	echoOffice
	ParseList $oslp $o14App $ospp14
}

si ($hSLC) {
	[void]$Win32::SLClose($hSLC)
}

si ($NT7) {
	vNextDiagRun
}

ExitScript 0
:sppmgr:

:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:dépannage

définir "ligne=_________________________________________________________________________________________________"

:au_menu

cls
titre Dépannage %masver%
si le mode terminal n'est pas défini, 77, 30

écho:
écho:
écho:
écho:
écho : _______________________________________________________________
écho:                                                   
appel :dk_color2 %_White% " [1] " %_Green% "Aide"
écho : ___________________________________________________
écho:                                                                      
écho : [2] Dism RestoreHealth
écho : [3] SFC Scannow
écho:                                                                      
echo : [4] Correction WMI
echo : [5] Correction de la licence
echo : [6] Correction du registre WPA
écho : ___________________________________________________
écho:
echo: [0] %_exitmsg%
écho : _______________________________________________________________
écho:          
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier :"
choix /C:1234560 /N
définir _erl=%errorlevel%

si %_erl%==7 quitter /b
si %_erl%==6 démarrer %mas%fix-wpa-registry &goto at_menu
si %_erl%==5 aller à:retokens
si %_erl%==4 aller à:fixwmi
si %_erl%==3 aller à:sfcscan
si %_erl%==2 aller à:dism_rest
si %_erl%==1 (démarrer %selfgit% & démarrer %github% & démarrer %mas%troubleshoot & aller à at_menu)
aller à :at_menu

:=================================================================================================================================================

:dism_rest

cls
si le mode terminal n'est pas défini, 98, 30
titre Dism /Anglais /En ligne /Nettoyage-Image /Restauration de la santé

si %winbuild% LSS 9200 (
%eline%
echo Version du système d'exploitation non prise en charge détectée.
echo Cette commande fonctionne uniquement sur Windows 8/8.1/10/11 et leurs équivalents serveur.
aller à :retour
)

définir _int=
pour %%a dans (l.root-servers.net resolver1.opendns.com download.windowsupdate.com google.com) faire si non défini _int (
for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%a') do (if not "%%#"=="" set _int=1)
)

écho:
si défini _int (
écho Vérification de la connexion Internet [Connecté]
) autre (
appel :dk_color2 %_White% " " %Red% "Vérification de la connexion Internet [Non connecté]"
)

écho %ligne%
écho:
echo DISM utilise Windows Update pour fournir les fichiers de remplacement nécessaires à la réparation des fichiers corrompus.
echo Cela prendra 5 à 15 minutes, voire plus...
écho %ligne%
écho:
Notes d'écho :
écho:
appel :dk_color2 %_White% " - " %Gray% "Assurez-vous que la connexion Internet est établie."
appel :dk_color2 %_White% " - " %Gray% "Assurez-vous que la mise à jour Windows fonctionne correctement."
écho:
écho %ligne%
écho:
choix /C:09 /N /M "> [9] Continuer [0] Retour : "
si %errorlevel%==1 aller au menu

cls
si le mode terminal n'est pas défini, 110, 30

pour chaque /f %%a dans ('%psc% "(Get-Date).ToString('yyyyMMdd-HHmmssfff')"') faire définir _time=%%a

%psc% Arrêter le service TrustedInstaller -force %nul%

copier /y /b "%SystemRoot%\logs\cbs\cbs.log" "%SystemRoot%\logs\cbs\backup_cbs_%_time%.log" %nul%
copier /y /b "%SystemRoot%\logs\DISM\dism.log" "%SystemRoot%\logs\DISM\backup_dism_%_time%.log" %nul%
supprimer /f /q "%SystemRoot%\logs\cbs\cbs.log" %nul%
supprimer /f /q "%SystemRoot%\logs\DISM\dism.log" %nul%

écho:
echo Application de la commande...
echo dism /anglais /en ligne /nettoyer-image /restaurer la santé
dism /anglais /en ligne /nettoyer-image /restaurer la santé

délai d'attente dépassé /t 5 %nul1%
copier /y /b "%SystemRoot%\logs\cbs\cbs.log" "%SystemRoot%\logs\cbs\cbs_%_time%.log" %nul%
copier /y /b "%SystemRoot%\logs\DISM\dism.log" "%SystemRoot%\logs\DISM\dism_%_time%.log" %nul%

si le fichier "!desktop!\AT_Logs\" n'existe pas, le fichier "!desktop!\AT_Logs\" est remplacé par %nul%
appel :compresslog cbs\cbs_%_time%.log AT_Logs\RHealth_CBS %nul%
appel :compresslog DISM\dism_%_time%.log AT_Logs\RHealth_DISM %nul%

si le fichier "!desktop!\AT_Logs\RHealth_CBS_%_time%.cab" n'existe pas (
copier /y /b "%SystemRoot%\logs\cbs\cbs.log" "!desktop!\AT_Logs\RHealth_CBS_%_time%.log" %nul%
)

si le fichier "!desktop!\AT_Logs\RHealth_DISM_%_time%.cab" n'existe pas (
copier /y /b "%SystemRoot%\logs\DISM\dism.log" "!desktop!\AT_Logs\RHealth_DISM_%_time%.log" %nul%
)

écho:
appel :dk_color %Gray% "Les journaux CBS et DISM sont copiés dans le dossier AT_Logs sur votre bureau."
aller à :retour

:=================================================================================================================================================

:sfcscan

cls
si le mode terminal n'est pas défini, 98, 30
titre sfc /scannow

écho:
écho %ligne%
écho:    
La commande echo SFC réparera les fichiers système manquants ou corrompus.
Il est recommandé d'exécuter d'abord l'option DISM avant celle-ci.
echo Cela prendra 10 à 15 minutes, voire plus...
écho:
Si SFC n'a pas pu résoudre un problème, exécutez à nouveau la commande pour voir s'il peut le résoudre.
Répétez l'opération. Il peut parfois être nécessaire d'exécuter la commande sfc /scannow trois fois.
L'utilisateur redémarre le PC après chaque intervention afin de corriger complètement tous les problèmes rencontrés.
écho:   
écho %ligne%
écho:
choix /C:09 /N /M "> [9] Continuer [0] Retour : "
si %errorlevel%==1 aller au menu

cls
pour chaque /f %%a dans ('%psc% "(Get-Date).ToString('yyyyMMdd-HHmmssfff')"') faire définir _time=%%a

%psc% Arrêter le service TrustedInstaller -force %nul%

copier /y /b "%SystemRoot%\logs\cbs\cbs.log" "%SystemRoot%\logs\cbs\backup_cbs_%_time%.log" %nul%
supprimer /f /q "%SystemRoot%\logs\cbs\cbs.log" %nul%

écho:
echo Application de la commande...
echo sfc /scannow
sfc /scannow

délai d'attente dépassé /t 5 %nul1%
copier /y /b "%SystemRoot%\logs\cbs\cbs.log" "%SystemRoot%\logs\cbs\cbs_%_time%.log" %nul%

si le fichier "!desktop!\AT_Logs\" n'existe pas, le fichier "!desktop!\AT_Logs\" est remplacé par %nul%
appel :compresslog cbs\cbs_%_time%.log AT_Logs\SFC_CBS %nul%

si le fichier "!desktop!\AT_Logs\SFC_CBS_%_time%.cab" n'existe pas (
copier /y /b "%SystemRoot%\logs\cbs\cbs.log" "!desktop!\AT_Logs\SFC_CBS_%_time%.log" %nul%
)

écho:
appel :dk_color %Gray% "Le journal CBS a été copié dans le dossier AT_Logs sur votre Bureau."
aller à :retour

:=================================================================================================================================================

:retokens

cls
si le terminal n'est pas défini (
mode 125, 32
%psc% "&{$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=31;$B.Height=200;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}" %nul%
)
Correction de licence du titre ^(ClipSVC ^+ SPP ^+ OSPP^)

si %winbuild% EQU 6001 (
%eline%
Cette option n'est pas prise en charge sous Windows Vista SP1.
Mise à jour vers Windows Vista SP2.
aller à :retour
)

écho:
écho %ligne%
écho:   
Notes d'écho :
écho:
echo - Cette option permet de résoudre les problèmes d'activation.
écho:
echo - Cette option permettra de :
echo - Désactivez Windows et Office, vous devrez peut-être les réactiver.
Si Windows est activé avec la carte mère / OEM / Licence numérique
Windows se réactivera ensuite.
écho:
echo - Effacer les licences ClipSVC, SPP et OSPP.
echo - Corriger les permissions du dossier des jetons SPP et des registres.
echo - Déclencher l'option de réparation pour Office.
écho:
appel :dk_color2 %_White% " - " %Blue% "Appliquez cette option uniquement lorsque cela est nécessaire."
écho:
écho %ligne%
écho:
choix /C:09 /N /M "> [9] Continuer [0] Retour : "
si %errorlevel%==1 aller au menu

:=================================================================================================================================================

:: Reconstruire les licences ClipSVC

cls
:licence propre

écho:
écho %ligne%
écho:
appel :dk_color %Blue% "Reconstruction des licences ClipSVC..."
écho:

si %winbuild% LSS 10240 (
La reconstruction de la licence ClipSVC n'est prise en charge que sous Windows 10/11.
Écho Saut...
aller à :rebuildspptok
)

%psc% "(([WMISEARCHER]'SELECT Name FROM SoftwareLicensingProduct WHERE LicenseStatus=1 AND GracePeriodRemaining=0 AND PartialProductKey IS NOT NULL AND LicenseDependsOn is NULL').Get()).Name" %nul2% | findstr /i "Windows" %nul1% && (
Windows est activé de façon permanente.
Écho Saut...
aller à :rebuildspptok
)

définir _partiel=
définir _keymatch=
for /f "tokens=2 delims==" %%# in ('%psc% "(([WMISEARCHER]'SELECT PartialProductKey FROM SoftwareLicensingProduct WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND PartialProductKey IS NOT NULL AND LicenseDependsOn is NULL').Get()).PartialProductKey | %% {echo ('PartialProductKey='+$_)}" %nul6%') do set "_partial=%%#"
pour %%# dans (8HV2C QPFCT 3V66T PKCKT WXCHW 8TYMD 6F4BT 8HVX7 KD72Y 7CFBY DRR8H P39PB DYJWX MDWWW 9HKR4 M7V2X 2YV77 WT2RQ MHBPB QPF8P 2YV66 VMJ2C DJ4F6 CKKFD YY74H J8JXD BHDCD T6R4W D32MH RRK69 3PJBP) faire si /i "%_partial%"=="%%#" définir _keymatch=1

si non défini _keymatch (
La clé d'activation HWID n'est pas installée.
Écho Saut...
aller à :rebuildspptok
)

%psc% "Si([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet){Exit 0}Else{Exit 1}"
si niveau d'erreur 1 (
La connexion Internet n'est pas établie.
Écho Saut...
aller à :rebuildspptok
)

définir resfail=
pour %%# dans (
licensing.mp.microsoft.com/v7.0/licenses/content
login.live.com/ppsecure/deviceaddcredential.srf
achat.mp.microsoft.com/v7.0/users/me/orders
) faire si non défini resfail (
%psc% "try { [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://%%# -Method POST } catch { if ($_.Exception.Response -eq $null) { Write-Host """"[%%#] $($_.Exception.Message)"""" -ForegroundColor Red -BackgroundColor Black; exit 3 } }"
si !errorlevel!==3 définir resfail=1
)

si défini resfail (
Échec de la connexion aux serveurs de licences.
Écho Saut...
aller à :rebuildspptok
)

écho Arrêt du service ClipSVC...
%psc% Arrêter le service ClipSVC -force %nul%
délai d'attente dépassé /t 2 %nul%

écho:
echo Application de la commande de nettoyage des licences ClipSVC...
echo rundll32 clipc.dll,ClipCleanUpState

rundll32 clipc.dll, ClipCleanUpState

si %winbuild% LEQ 10240 (
écho [Réussi]
) autre (
si le fichier "%ProgramData%\Microsoft\Windows\ClipSVC\tokens.dat" existe (
appel :dk_color %Red% "[Échec]"
) autre (
écho [Réussi]
)
)

:: La clé de registre ci-dessous (volatile et protégée) est créée après la commande de nettoyage de la licence ClipSVC, puis supprimée automatiquement.
:: redémarrage du système. Il faut le supprimer pour activer le système sans redémarrage.

définir "RegKey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ClipSVC\Volatile\PersistedSystemState"
définir "_ident=HKU\S-1-5-19\SOFTWARE\Microsoft\IdentityCRL"

requête reg "%RegKey%" %nul% && %nul% appel :regownstart
reg delete "%RegKey%" /f %nul%

écho:
Suppression d'une clé de registre volatile protégée ^&...
echo [%RegKey%]
requête reg "%RegKey%" %nul% && (
appel :dk_color %Red% "[Échec]"
Redémarrez votre machine en utilisant l'option de redémarrage ; cela supprimera automatiquement cette clé de registre.
) || (
écho [Réussi]
)

:: Effacer le registre relatif au jeton HWID pour corriger l'activation en cas de corruption

écho:
echo Suppression de la clé de registre IdentityCRL...
écho [%_ident%]
reg delete "%_ident%" /f %nul%
requête reg "%_ident%" %nul% && (
appel :dk_color %Red% "[Échec]"
) || (
écho [Réussi]
)

%psc% Arrêter le service ClipSVC -force %nul%

:: Reconstruisez le dossier ClipSVC pour corriger les problèmes d'autorisation

écho:
si %winbuild% GTR 10240 (
echo Suppression du dossier %ProgramData%\Microsoft\Windows\ClipSVC\
rmdir /s /q "C:\ProgramData\Microsoft\Windows\ClipSvc" %nul%

si le fichier "%ProgramData%\Microsoft\Windows\ClipSVC\" existe (
appel :dk_color %Red% "[Échec]"
) autre (
écho [Réussi]
)

écho:
echo Reconstruction du dossier %ProgramData%\Microsoft\Windows\ClipSVC\...
%psc% Démarrage du service ClipSVC %nul%
délai d'attente dépassé /t 3 %nul%
si le fichier "%ProgramData%\Microsoft\Windows\ClipSVC\" n'existe pas, délai d'attente de 5 secondes %nul%
si le fichier "%ProgramData%\Microsoft\Windows\ClipSVC\" n'existe pas (
appel :dk_color %Red% "[Échec]"
) autre (
écho [Réussi]
)
)

écho:
echo Redémarrage des services wlidsvc ^& LicenseManager...
for %%# in (wlidsvc LicenseManager) do (%psc% "Start-Job { Restart-Service %%# } | Wait-Job -Timeout 20 | Out-Null")

:=================================================================================================================================================

:: Reconstruire les jetons SPP

:rebuildspptok

écho:
écho %ligne%
écho:
appel :dk_color %Blue% "Reconstruction des jetons de licence SPP..."
écho:

Effacement du cache KMS...
écho:
appel :_taskclear-cache

%nul% requête reg "HKLM\%SPPk%\%_wApp%" && (
écho Suppression de la protection KMS38...
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':regdel\:.*';. ([scriptblock]::Create($f[1]))"
%nul% reg supprimer "HKLM\%SPPk%\%_wApp%" /f
%nul% requête reg "HKLM\%SPPk%\%_wApp%" && (
appel :dk_color %Red% "Échec de la suppression de la protection KMS38."
) || (
echo Protection KMS38 supprimée avec succès.
écho Cache KMS vidé avec succès.
)
) || (
écho Cache KMS vidé avec succès.
)
écho:

appel : vérification de scandale

si le jeton n'est pas défini (
appel :dk_color %Red% "fichier tokens.dat introuvable."
) autre (
fichier tokens.dat : [%token%]
)

définir tokenstore=
définir badregistry=
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v TokenStore %nul6%') do call set "tokenstore=%%b"
si %winbuild% GEQ 9200 si /i n'est pas "%tokenstore%"=="%SysPath%\spp\store" si /i n'est pas "%tokenstore%"=="%SysPath%\spp\store\2.0" si /i n'est pas "%tokenstore%"=="%SysPath%\spp\store_test\2.0" (
définir badregistry=1
écho:
appel :dk_color %Red% "Chemin correct introuvable dans le registre TokenStore [%tokenstore%]"
)

:: Vérifiez les autorisations sppsvc et appliquez les correctifs

si %winbuild% GEQ 9200 si non défini badregistry (
écho:
écho Vérification des problèmes liés aux autorisations SPP...
appel :checkperms
si permerror défini (
appel :dk_color %Rouge% "[!permerror!]"
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':fixsppperms\:.*';. ([scriptblock]::Create($f[1]))" %nul%
appel :checkperms
si permerror défini (
appel :dk_color %Red% "[!permerror!] [Échec de la réparation]"
) autre (
appel :dk_color %Green% "[Résolu avec succès]"
)
) autre (
echo [Aucune erreur trouvée]
)
)

écho:
echo Arrêt du service %_slser%...
%psc% Arrêter-Service %_slser% -forcer %nul%

définir w=
définir _sppint=
pour %%# dans (SppEx%w%tComObj.exe %_slexe%) faire (reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Ima%w%ge File Execu%w%tion Options\%%#" %nul% && (set _sppint=1))
si défini _sppint (
écho:
écho Suppression des clés de registre SPP IFEO...
pour %%# dans (SppE%w%xtComObj.exe %_slexe%) faire (reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Ima%w%ge File Execu%w%tion Options\%%#" /f %nul%)
)

si %winbuild% LSS 9200 si non défini _vis (
REM Correction des problèmes causés par la mise à jour KB971033 sous Windows 7
REM https://support.microsoft.com/en-us/help/4487266
écho:
écho Vérification de la mise à jour KB971033...
%psc% "if (Get-Hotfix -Id KB971033 -ErrorAction SilentlyContinue) {Exit 3}" %nul%
si !errorlevel!==3 (
echo Trouvé, désinstallation en cours...
wusa /désinstaller /quiet /norestart /kb:971033
) autre (
écho [Introuvable]
)
%psc% Arrêter-Service sppuinotify -forcer %nul%
sc config sppuinotify start= désactivé
del /f /q %SysPath%\7B296FB0-376B-497e-B012-9C450E1B7327-*.C7483456-A289-439d-8115-601632D005A0 /ah
)

:: Supprimer les clés de registre qui ne sont pas supprimées par les scripts d'activation

si non défini _vis (
écho:
Nettoyage de certaines clés de registre liées aux licences...
%nul% reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "ServiceSessionId" /f
%nul% reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "LicStatusArray" /f
%nul% reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "PolicyValuesArray" /f
%nul% reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "actionlist" /f
%nul% reg delete "HKLM\SOFTWARE\Microsoft\OfficeSoftwareProtectionPlatform\data" /f
)

écho:
appel :scandat supprimer
appel : vérification de scandale

si jeton défini (
écho:
appel :dk_color %Red% "Échec de la suppression des fichiers .dat."
écho:
)

si défini _vis (
%psc% Démarrer-Service %_slser% %nul%
)

écho:
echo Réinstallation des licences système...
%psc% "$sls = Get-WmiObject SoftwareLicensingService; $f=[IO.File]::ReadAllText('!_batp!') -split ':xrm\:.*';. ([scriptblock]::Create($f[1])); ReinstallLicenses" %nul%
if %errorlevel% NEQ 0 %psc% "$sls = Get-WmiObject SoftwareLicensingService; $f=[IO.File]::ReadAllText('!_batp!') -split ':xrm\:.*';. ([scriptblock]::Create($f[1])); ReinstallLicenses" %nul%
si %errorlevel% EQU 0 (
écho [Réussi]
) autre (
appel :dk_color %Red% "[Échec]"
)

appel : vérification de scandale

écho:
si le jeton n'est pas défini (
appel :dk_color %Red% "Échec de la reconstruction du fichier tokens.dat."
) autre (
Le fichier tokens.dat a été reconstruit avec succès.
)

si %winbuild% LSS 9200 si non défini _vis (
sc config sppuinotify start= demande
)

:=================================================================================================================================================

:: Reconstruire les jetons OSPP

écho:
écho %ligne%
écho:
appel :dk_color %Blue% "Reconstruction des jetons de licence OSPP..."
écho:

sc qc osppsvc %nul% || (
La suite Office basée sur OSPP n'est pas installée.
écho Ignorer la reconstruction des jetons OSPP...
aller à :repairoffice
)

appel :scandatospp vérification

si le jeton n'est pas défini (
appel :dk_color %Red% "fichier tokens.dat introuvable."
) autre (
fichier tokens.dat : [%token%]
)

écho:
écho Arrêt du service osppsvc...
%psc% Arrêter-Service osppsvc -forcer %nul%

écho:
appel :scandatospp supprimer
appel :scandatospp vérification

si jeton défini (
écho:
appel :dk_color %Red% "Échec de la suppression des fichiers .dat."
écho:
)

écho:
echo Démarrage du service osppsvc pour générer tokens.dat...
%psc% Démarrer-Service osppsvc %nul%
appel :scandatospp vérification
si le jeton n'est pas défini (
%psc% Arrêter-Service osppsvc -forcer %nul%
%psc% Démarrer-Service osppsvc %nul%
délai d'attente dépassé /t 3 %nul%
)

appel :scandatospp vérification

écho:
si le jeton n'est pas défini (
appel :dk_color %Red% "Échec de la reconstruction du fichier tokens.dat."
) autre (
Le fichier tokens.dat a été reconstruit avec succès.
)

:=================================================================================================================================================

:bureau de réparation

écho:
écho %ligne%
écho:
appel :dk_color %Blue% "Réparation des licences Office..."
écho:

pour %%# dans (68 86) faire (
pour %%A dans (msi14 msi15 msi16 c2r14 c2r15 c2r16) faire (définir %%A_%%#=&définir %%Arepair%%#=)
)

définir _68=HKLM\SOFTWARE\Microsoft\Office
définir _86=HKLM\SOFTWARE\Wow6432Node\Microsoft\Office

reg query %_68%\14.0\CVH /f Click2run /k %nul% && (set "c2r14_68=Office 14.0 C2R x86/x64" & set "c2r14repair68=")
reg query %_86%\14.0\CVH /f Click2run /k %nul% && (set "c2r14_86=Office 14.0 C2R x86" & set "c2r14repair86=")

for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\14.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set "msi14_86=Office 14.0 MSI x86" & call :getrepairsetup msi14repair86 14)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\14.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set "msi14_68=Office 14.0 MSI x86/x64" & call :getrepairsetup msi14repair68 14)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\15.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set "msi15_86=Office 15.0 MSI x86" & call :getrepairsetup msi15repair86 15)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\15.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set "msi15_68=Office 15.0 MSI x86/x64" & call :getrepairsetup msi15repair68 15)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\16.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set "msi16_86=Office 16.0 MSI x86" & call :getrepairsetup msi16repair86 16)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\16.0\Common\InstallRoot /v Path" %nul6%') do if exist "%%b\*Picker.dll" (set "msi16_68=Office 16.0 MSI x86/x64" & call :getrepairsetup msi16repair68 16)

for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\15.0\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses\ProPlus*.xrm-ms" (set "c2r15_86=Office 15.0 C2R x86" & call :getc2rrepair c2r15repair86 integratedoffice.exe)
pour /f "skip=2 tokens=2*" %%a dans (""requête reg %_68%\15.0\ClickToRun /v InstallPath" %nul6%') faites s'il existe "%%b\root\Licenses\ProPlus*.xrm-ms" (définissez "c2r15_68=Office 15.0 C2R x86/x64" et appelez :getc2rrepair c2r15repair68 intégréoffice.exe)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" (set "c2r16_86=Office 16.0 C2R x86" & call :getc2r16repair c2r16repair86 OfficeClickToRun.exe)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" (set "c2r16_68=Office 16.0 C2R x86/x64" & call :getc2r16repair c2r16repair68 OfficeClickToRun.exe)

définir uwp16=
si %winbuild% GEQ 10240 (
%psc% "Get-AppxPackage -name "Microsoft.Office.Desktop"" | find /i "Office" %nul1% && set uwp16=Office 16.0 UWP
)

définir /un compteur=0
vérification des versions d'Office installées...
écho:

pour %%# dans (
"%msi14_68%"
"%msi14_86%"
"%msi15_68%"
"%msi15_86%"
"%msi16_68%"
"%msi16_86%"
"%c2r14_68%"
"%c2r14_86%"
"%c2r15_68%"
"%c2r15_86%"
"%c2r16_68%"
"%c2r16_86%"
"%uwp16%"
) faire (
si ce n'est pas "%%#"="""" (
définir insoff=%%#
définir insoff=!insoff:"=!
écho [!insoff!]
définir /un compteur+=1
)
)

si %compteur% GTR 1 (
%eline%
echo Plusieurs versions d'Office détectées.
Il est recommandé de n'installer qu'une seule version d'Office.
écho ________________________________________________________________
écho:
)

écho:
si %compteur% EQU 0 (
echo Office ^(2010 et versions ultérieures^) n'est pas installé.
aller à :réparer
) sinon si non défini c2r16_68 si non défini c2r16_86 (
appel :dk_color %_Yellow% "Une nouvelle fenêtre apparaîtra, dans cette fenêtre vous devez sélectionner l'option [Réparation rapide].
si terminal défini (
appel :dk_color %_Yellow% "Appuyez sur [0] pour continuer..."
choix /c 0 /n
) autre (
appel :dk_color %_Yellow% "Appuyez sur une touche pour continuer..."
pause %nul1%
)
)

si défini uwp16 (
écho:
Réparation ignorée pour Office 16.0 UWP...
écho:
)

définir c2r14=
si c2r14_68 est défini, définir c2r14=1
si c2r14_86 est défini, définissez c2r14=1

si défini c2r14 (
écho:
écho Réparation ignorée pour Office 14.0 C2R...
écho:
)

Si msi14_68 est défini et que "%msi14repair68%" existe, afficher « Exécution de "%msi14repair68% et "%msi14repair68% ».
Si msi14_86 est défini et que "%msi14repair86%" existe, afficher « Exécution - "%msi14repair86%" & "%msi14repair86%" ».
Si msi15_68 est défini et que "%msi15repair68%" existe, afficher « Exécution - "%msi15repair68%" & "%msi15repair68%" ».
Si msi15_86 est défini et que "%msi15repair86%" existe, afficher « Exécution - "%msi15repair86%" & "%msi15repair86%" ».
Si msi16_68 est défini et que "%msi16repair68%" existe, afficher « Exécution - "%msi16repair68%" & "%msi16repair68%" ».
Si msi16_86 est défini et que "%msi16repair86%" existe, afficher « Exécution - "%msi16repair86%" & "%msi16repair86%" ».
si c2r15_68 est défini et si "%c2r15repair68%" existe, afficher « Exécution - "%c2r15repair68%" REPAIRUI RERUNMODE & "%c2r15repair68%" REPAIRUI RERUNMODE »
si c2r15_86 est défini et si "%c2r15repair86%" existe, afficher « Exécution - "%c2r15repair86%" REPAIRUI RERUNMODE & "%c2r15repair86%" REPAIRUI RERUNMODE »
Si c2r16_68 est défini et que "%c2r16repair68%" existe, afficher « Exécution - "%c2r16repair68%" Scénario=Réparation Type de réparation=Réparation rapide & "%c2r16repair68%" Scénario=Réparation Type de réparation=Réparation rapide
Si c2r16_86 est défini et que "%c2r16repair86%" existe, afficher « Exécution - "%c2r16repair86%" Scénario=Réparation Type de réparation=Réparation rapide & "%c2r16repair86%" Scénario=Réparation Type de réparation=Réparation rapide

:réparer

écho:
écho %ligne%
écho:
écho:
appel :dk_color %Green% "Terminé"
aller à :retour

:getc2rrepair

pour %%# dans (X86 X64) faire (
si le fichier "%systemdrive%\Program Files\Microsoft Office 15\Client%%#\%2" existe (
définir "%1=%systemdrive%\Program Files\Microsoft Office 15\Client%%#\%2"
)
)
quitter /b

:getc2r16repair

pour %%# dans (%_68% %_86%) faire (
for /f "skip=2 tokens=2*" %%a in ('"reg query %%#\ClickToRun\Configuration /v ClientFolder" %nul6%') do if exist "%%b\%2" (set "%1=%%b\%2")
)
quitter /b

:getrepairsetup

définir "_common86=%systemdrive%\Program Files (x86)\Common Files\Microsoft Shared\OFFICE%2\Office Setup Controller\setup.exe"
définir "_common68=%systemdrive%\Program Files\Common Files\Microsoft Shared\OFFICE%2\Office Setup Controller\setup.exe"

si "%_common86%" existe, définissez "%1=%_common86%"
si "%_common68%" existe, définissez "%1=%_common68%"
quitter /b

:=================================================================================================================================================

:fixwmi

cls
si le mode terminal n'est pas défini, 98, 34
Correction du WMI

:: https://techcommunity.microsoft.com/t5/ask-the-performance-team/wmi-repository-corruption-or-not/ba-p/375484

si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum" existe (
%eline%
La reconstruction de WMI n'est pas recommandée sur Windows Server, opération annulée...
aller à :retour
)

écho:
vérification de WMI
appel :checkwmi

Appliquez d'abord la correction de base et vérifiez.

si une erreur est définie (
%psc% Arrêter-Service Winmgmt -forcer %nul%
winmgmt /salvagerepository %nul%
appel :checkwmi
)

erreur si non définie (
écho [En cours]
echo Inutile d'appliquer cette option, annulation...
aller à :retour
)

appel :dk_color %Red% "[Ne répond pas]"

définir _corrompu=
sc démarrer Winmgmt %nul%
si %errorlevel% est égal à 1060, définir _corrupt=1
sc query Winmgmt %nul% || set _corrupt=1
pour %%G dans (DependOnService Description DisplayName ErrorControl ImagePath ObjectName Start Type) faire si non défini _corrupt (reg query HKLM\SYSTEM\CurrentControlSet\Services\Winmgmt /v %%G %nul% || set _corrupt=1)

écho:
si défini _corrupt (
%eline%
Le service Winmgmt est corrompu, arrêt en cours...
aller à :retour
)

écho Désactivation du service Winmgmt
sc config Winmgmt start= désactivé %nul%
si %errorlevel% EQU 0 (
écho [Réussi]
) autre (
appel :dk_color %Red% "[Échec] Abandon..."
sc config Winmgmt start= auto %nul%
aller à :retour
)

écho:
écho Arrêt du service Winmgmt
%psc% Arrêter-Service Winmgmt -forcer %nul%
%psc% Arrêter-Service Winmgmt -forcer %nul%
%psc% Arrêter-Service Winmgmt -forcer %nul%
sc query Winmgmt | find /i "STOPPED" %nul% && (
écho [Réussi]
) || (
appel :dk_color %Red% "[Échec]"
appel :dk_color %Blue% "Il est recommandé de sélectionner l'option [Redémarrer] puis d'appliquer à nouveau l'option Fix WMI."
écho %ligne%
écho:
choix /C:21 /N /M "> [1] Redémarrer [2] Annuler les modifications :"
if !errorlevel!==1 (sc config Winmgmt start= auto %nul%&goto :at_back)
écho:
écho Redémarrage...
arrêt -t 5 -r
sortie
)

écho:
écho Suppression du dépôt WMI
rmdir /s /q "%SysPath%\wbem\repository\" %nul%
si existe "%SysPath%\wbem\repository\" (
appel :dk_color %Red% "[Échec]"
) autre (
écho [Réussi]
)

écho:
Activation du service Winmgmt
sc config Winmgmt start= auto %nul%
si %errorlevel% EQU 0 (
écho [Réussi]
) autre (
appel :dk_color %Red% "[Échec]"
)

appel :checkwmi
erreur si non définie (
écho:
vérification de WMI
appel :dk_color %Green% "[En cours]"
aller à :retour
)

écho:
echo Enregistrement des fichiers .dll et compilation des fichiers .mof et .mfl
appel :registerobj %nul%

écho:
vérification de WMI
appel :checkwmi
si une erreur est définie (
appel :dk_color %Red% "[Ne répond pas]"
écho:
Exécutez les options [Dism RestoreHealth] et [SFC Scannow] et assurez-vous qu'il n'y a pas d'erreurs.
) autre (
appel :dk_color %Green% "[En cours]"
)

aller à :retour

:registerobj

:: https://eskonr.com/2012/01/how-to-fix-wmi-issues-automatically/

%psc% Arrêter-Service Winmgmt -forcer %nul%
cd /d %SysPath%\wbem\
regsvr32 /s %SysPath%\scecli.dll
regsvr32 /s %SysPath%\userenv.dll
mofcomp cimwin32.mof
mofcomp cimwin32.mfl
mofcomp rsop.mof
mofcomp rsop.mfl
for /f %%s in ('dir /b /s *.dll') do regsvr32 /s %%s
for /f %%s in ('dir /b *.mof') do mofcomp %%s
for /f %%s in ('dir /b *.mfl') do mofcomp %%s

winmgmt /salvagerepository
winmgmt /resetrepository
quitter /b

:checkwmi

:: https://learn.microsoft.com/en-us/windows/win32/wmisdk/wmi-error-constants

définir l'erreur=
%psc% "Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property CreationClassName" %nul2% | find /i "computersystem" %nul1%
si %errorlevel% NEQ 0 (définir l'erreur=1& quitter /b)
winmgmt /verifyrepository %nul%
si %errorlevel% NEQ 0 (définir l'erreur=1& quitter /b)

%psc% "try { $null=([WMISEARCHER]'SELECT * FROM SoftwareLicensingService').Get().Version; exit 0 } catch { exit $_.Exception.InnerException.HResult }" %nul%
cmd /c exit /b %errorlevel%
echo "0x%=CodeDeSortie%" | findstr /i "0x800410 0x800440 0x80131501" %nul1%
si %errorlevel% est égal à 0, définir error=1
quitter /b

:=================================================================================================================================================

:à_arrière

écho:
écho %ligne%
écho:
si terminal défini (
appel :dk_color %_Yellow% "Appuyez sur la touche [0] pour %_exitmsg%..."
choix /c 0 /n
) autre (
appel :dk_color %_Yellow% "Appuyez sur n'importe quelle touche pour %_exitmsg%..."
pause %nul1%
)
aller à :at_menu

:=================================================================================================================================================

:compresslog

:: https://stackoverflow.com/a/46268232

pour /f %%G dans ('%psc% "[Guid]::NewGuid().Guid"') faire définir "randguid=%%G"
définir "ddf="%SystemRoot%\Temp\%Random%%randguid%""
echo/.Nouveau Cabinet>%ddf%
echo/.set Cabinet=ON>>%ddf%
echo/.set CabinetFileCountThreshold=0;>>%ddf%
echo/.set Compress=ON>>%ddf%
echo/.set CompressionType=LZX>>%ddf%
echo/.set CompressionLevel=7;>>%ddf%
echo/.set CompressionMemory=21;>>%ddf%
echo/.set FolderFileCountThreshold=0;>>%ddf%
echo/.set FolderSizeThreshold=0;>>%ddf%
echo/.set GenerateInf=OFF>>%ddf%
echo/.set InfFileName=nul>>%ddf%
echo/.set MaxCabinetSize=0;>>%ddf%
echo/.set MaxDiskFileCount=0;>>%ddf%
echo/.set MaxDiskSize=0;>>%ddf%
echo/.set MaxErrors=1;>>%ddf%
echo/.set RptFileName=nul>>%ddf%
echo/.set UniqueFiles=ON>>%ddf%
pour /f "tokens=* delims=" %%D dans ('dir /a:-D/b/s "%SystemRoot%\logs\%1"') faire (
 echo/"%%~fD" /inf=non;>>%ddf%
)
makecab /F %ddf% /D DiskDirectory1="" /D CabinetNameTemplate="!desktop!\%2_%_time%.cab"
quitter /b

:=================================================================================================================================================

:checkperms

Ce code vérifie si SPP dispose des autorisations d'accès au dossier des jetons et aux clés de registre requises. Des autorisations incorrectes sont souvent définies par des tricheurs dans les jeux vidéo.

définir permerror=
Si le répertoire "%tokenstore%" n'existe pas, définissez "permerror=Erreur trouvée dans le dossier des jetons".

si ps32onArm est défini, quitter /b

pour %%# dans (
"%tokenstore%+FullControl"
"HKLM:\SYSTEM\WPA+QueryValues, EnumerateSubKeys, WriteKey"
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform+SetValue"
) faire pour /f "tokens=1,2 delims=+" %%A dans (%%#) faire si non défini permerror (
%psc% "$acl = (Get-Acl '%%A' | fl | Out-String); if (-not ($acl -match 'NT SERVICE\\sppsvc Allow %%B') -or ($acl -match 'NT SERVICE\\sppsvc Deny')) {Exit 2}" %nul%
si !errorlevel!==2 (
si "%%A"="%tokenstore%" (
définir "permerror=Erreur trouvée dans le dossier des jetons"
) autre (
définir "permerror=Erreur trouvée dans les registres SPP"
)
)
)

REM https://learn.microsoft.com/en-us/office/troubleshoot/activation/license-issue-when-start-office-application

si non défini permerror (
reg query "HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion" %nul% && (
définir "pol=HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\Policies"
reg query "!pol!" %nul% || reg add "!pol!" %nul%
%psc% "$netServ = (New-Object Security.Principal.SecurityIdentifier('S-1-5-20')).Translate([Security.Principal.NTAccount]).Value; $aclString = Get-Acl 'Registry::!pol!' | Format-List | Out-String; if (-not ($aclString.Contains($netServ + ' Allow FullControl') -or $aclString.Contains('NT SERVICE\sppsvc Allow FullControl')) -or ($aclString.Contains('Deny'))) {Exit 3}" %nul%
si !errorlevel!==3 définir "permerror=Erreur trouvée dans S-1-5-20 SPP"
)
)
quitter /b

:=================================================================================================================================================

:: Correction des permissions de registre et de dossiers liées à SPP

:fixsppperms:
# Correction des permissions pour le dossier des jetons

if ($env:permerror -eq 'Erreur trouvée dans le dossier des jetons') {
    New-Item -Path $env:tokenstore -ItemType Directory -Force
    $sddl = 'O:BAG:BAD:PAI(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICIIO;GR;;;BU)(A;;FR;;;BU) (A;OICI;FA;;;S-1-5-80-123231216-2592883651-3715271367-3753151631-4175906628)'
    $AclObject = New-Object System.Security.AccessControl.DirectorySecurity
    $AclObject.SetSecurityDescriptorSddlForm($sddl)
    Définir-Acl -Chemin $env:tokenstore -AclObject $AclObject
    sortie
}

# Correction des permissions pour les registres SPP

if ($env:permerror -eq 'Erreur détectée dans les registres SPP') {
    $acl = Get-Acl 'HKLM:\SYSTEM\WPA'
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule ('NT Service\sppsvc', 'QueryValues, EnumerateSubKeys, WriteKey', 'ContainerInherit, ObjectInherit', 'None', 'Allow')
    $acl.ResetAccessRule($rule)
    $acl.SetAccessRule($rule)
    Définir-Acl -Chemin 'HKLM:\SYSTEM\WPA' -AclObject $acl
	
    $acl = Get-Acl 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform'
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule ('NT Service\sppsvc', 'SetValue', 'ContainerInherit, ObjectInherit', 'None', 'Allow')
    $acl.ResetAccessRule($rule)
    $acl.SetAccessRule($rule)
    Définir-Acl -Chemin 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform' -AclObject $acl
    sortie
}

# Correction des permissions pour SPP dans HKU\S-1-5-20
# https://learn.microsoft.com/en-us/office/troubleshoot/activation/license-issue-when-start-office-application

if ($env:permerror -ne 'Erreur trouvée dans S-1-5-20 SPP') {
    sortie
}
si (-not (Test-Path 'Registry::HKU\S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform')) {
    sortie
}

# https://stackoverflow.com/a/35843420

fonction Prendre-Permissions {
    param($rootKey, $key, [System.Security.Principal.SecurityIdentifier]$sid = 'S-1-5-32-545', $recurse = $true)
    
    switch -regex ($rootKey) {
        'HKCU|HKEY_CURRENT_USER' { $rootKey = 'CurrentUser' }
        'HKLM|HKEY_LOCAL_MACHINE' { $rootKey = 'LocalMachine' }
        'HKCR|HKEY_CLASSES_ROOT' { $rootKey = 'ClassesRoot' }
        'HKCC|HKEY_CURRENT_CONFIG' { $rootKey = 'CurrentConfig' }
        'HKU|HKEY_USERS' { $rootKey = 'Users' }
    }

    ### Étape 1 - Élever les privilèges du processus actuel
    # Obtenez les privilèges SeTakeOwnership, SeBackup et SeRestore avant d'exécuter les lignes suivantes ; le script nécessite des privilèges d'administrateur.
    $AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1)
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule(2, $False)
    $TypeBuilder = $ModuleBuilder.DefineType(0)
    $TypeBuilder.DefinePInvokeMethod('RtlAdjustPrivilege', 'ntdll.dll', 'Public, Static', 1, [int], @([int], [bool], [bool], [bool].MakeByRefType()), 1, 3) | Out-Null
    9, 17, 18 | ForEach-Object { $TypeBuilder.CreateType()::RtlAdjustPrivilege($_, $true, $false, [ref]$false) | Out-Null }

    fonction Take-KeyPermissions {
        param($rootKey, $key, $sid, $recurse, $recurseLevel = 0)

        ### Étape 2 - Obtenir la propriété de la clé - fonctionne uniquement pour la clé actuelle
        $regKey = [Microsoft.Win32.Registry]::$rootKey.OpenSubKey($key, 'ReadWriteSubTree', 'TakeOwnership')
        $acl = New-Object System.Security.AccessControl.RegistrySecurity
        $acl.SetOwner($sid)
        $regKey.SetAccessControl($acl)

        ### Étape 3 - Activer l'héritage des permissions (et non de la propriété) pour la clé actuelle à partir de la clé parente
        $acl.SetAccessRuleProtection($false, $false)
        $regKey.SetAccessControl($acl)

        ### Étape 4 - uniquement pour la clé de niveau supérieur, modifiez les autorisations de la clé actuelle et propagez-les aux sous-clés
        # Pour activer la propagation des sous-clés, il faut exécuter les étapes 2 et 3 pour chaque sous-clé (étape 5).
        si ($recurseLevel -eq 0) {
            $regKey = $regKey.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
            $rule = New-Object System.Security.AccessControl.RegistryAccessRule($sid, 'FullControl', 'ContainerInherit', 'None', 'Allow')
            $acl.ResetAccessRule($rule)
            $regKey.SetAccessControl($acl)
        }

        ### Étape 5 - Répétez récursivement les étapes 2 à 5 pour les sous-clés
        si ($recurse) {
            foreach ($subKey in $regKey.OpenSubKey('').GetSubKeyNames()) {
                Take-KeyPermissions $rootKey ($key + '\' + $subKey) $sid $recurse ($recurseLevel + 1)
            }
        }
    }

    Take-KeyPermissions $rootKey $key $sid $recurse
}

Autorisations Take-Permissions "Utilisateurs" "S-1-5-20\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" "S-1-5-20"
:fixsppperms:

:=================================================================================================================================================

:scandat

définir le jeton=
pour %%# dans (
%SysPath%\spp\store_test\2.0\
%SysPath%\spp\store\
%SysPath%\spp\store\2.0\
%Systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\
%Systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareLicensing\
) faire (

si %1==vérifier (
Si le fichier %%#tokens.dat existe, définissez token=%%#tokens.dat
)

si %1==supprimer (
si existe %%# (
%nul% dir /ad /s "%%#*.dat" && (
attrib -r -s -h "%%#*.dat" /S
supprimer /S /F /Q "%%#*.dat"
)
)
)
)
quitter /b

:scandatospp

définir le jeton=
pour %%# dans (
%ProgramData%\Microsoft\OfficeSoftwareProtectionPlatform\
) faire (

si %1==vérifier (
Si le fichier %%#tokens.dat existe, définissez token=%%#tokens.dat
)

si %1==supprimer (
si existe %%# (
%nul% dir /ad /s "%%#*.dat" && (
attrib -r -s -h "%%#*.dat" /S
supprimer /S /F /Q "%%#*.dat"
)
)
)
)
quitter /b

:=================================================================================================================================================

:regownstart

%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':regown\:.*';. ([scriptblock]::Create($f[1]));"
quitter /b

Le code ci-dessous prend possession d'une clé de registre volatile et la supprime.
:: HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ClipSVC\Volatile\PersistedSystemState

:regown:
$AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1)
$ModuleBuilder = $AssemblyBuilder.DefineDynamicModule(2, $False)
$TypeBuilder = $ModuleBuilder.DefineType(0)

$TypeBuilder.DefinePInvokeMethod('RtlAdjustPrivilege', 'ntdll.dll', 'Public, Static', 1, [int], @([int], [bool], [bool], [bool].MakeByRefType()), 1, 3) | Out-Null
$TypeBuilder.CreateType()::RtlAdjustPrivilege(9, $true, $false, [ref]$false) | Out-Null

$SID = New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')
$IDN = ($SID.Translate([System.Security.Principal.NTAccount])).Valeur
$Admin = New-Object System.Security.Principal.NTAccount($IDN)

$path = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\ClipSVC\Volatile\PersistedSystemState'
$key = [Microsoft.Win32.RegistryKey]::OpenBaseKey('LocalMachine', 'Registry64').OpenSubKey($path, 'ReadWriteSubTree', 'takeownership')

$acl = $key.GetAccessControl()
$acl.SetOwner($Admin)
$key.SetAccessControl($acl)

$rule = New-Object System.Security.AccessControl.RegistryAccessRule($Admin,"FullControl","Allow")
$acl.SetAccessRule($rule)
$key.SetAccessControl($acl)
:regown:

:=================================================================================================================================================

Ce code s'exécute pour annuler la protection de la clé de registre KMS38 ci-dessous.
:: HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\55c92734-d682-4d71-983e-d6ec3f16059f

:: Cette option n'est plus utilisée dans KMS38, elle est présente uniquement pour supprimer la protection des versions précédentes.

:regdel:
param (
    [switch]$protect
)

$SID = New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')
$Admin = ($SID.Translate([System.Security.Principal.NTAccount])).Value

si($protect) {
$ruleArgs = @("$Admin", "Supprimer, DéfinirValeur", "HéritageConteneur", "Aucun", "Refuser")
} autre {
$ruleArgs = @("$Admin", "FullControl", "Autoriser")
}

$path = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\55c92734-d682-4d71-983e-d6ec3f16059f'
$key = [Microsoft.Win32.RegistryKey]::OpenBaseKey('LocalMachine', 'Registry64').OpenSubKey($path, 'ReadWriteSubTree', 'ChangePermissions')
$acl = $key.GetAccessControl()

$rule = [System.Security.AccessControl.RegistryAccessRule]::new.Invoke($ruleArgs)
$acl.ResetAccessRule($rule)
$key.SetAccessControl($acl)
:regdel:

:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:change_winedition

:: Pour mettre en place l'édition actuelle lors d'un changement d'édition avec la méthode de mise à niveau CBS, remplacez 0 par 1 dans la ligne ci-dessous
définir _stg=0

définir "ligne=écho ___________________________________________________________________________________________"

cls
si le mode terminal n'est pas défini, 98, 30
Titre : Changer l’édition Windows %masver%

si %winbuild% LSS 7600 (
%eline%
echo Version du système d'exploitation non prise en charge détectée [%winbuild%].
Cette option est prise en charge uniquement pour Windows 7/8/8.1/10/11 et leurs équivalents serveur.
aller à dk_done
)

écho:
Initialisation en cours...
écho:

pour %%# dans (
sppsvc.exe
dism.exe
) faire (
si %SysPath%\%%# n'existe pas (
%eline%
Le fichier [%SysPath%\%%#] est manquant, arrêt...
appel :dk_color %Blue% "Retournez au menu principal, sélectionnez Dépannage et exécutez les options de restauration DISM et d'analyse SFC."
appel :dk_color %Blue% "Après cela, redémarrez le système et réessayez l'activation."
définir les correctifs=%fixes% %mas%mise_à_jour_réparation_sur_place
appel :dk_color2 %Blue% "Si l'erreur persiste, procédez comme suit : " %_Yellow% " %mas%in-place_repair_upgrade"
aller à dk_done
)
)

:=================================================================================================================================================

définir spp=SoftwareLicensingProduct
définir sps=SoftwareLicensingService

appel :dk_reflection
appel :dk_ckeckwmic
appel :dk_sppissue

pour /f "tokens=6-7 delims=[]. " %%i dans ('ver') faire si non "%%j"=="" (
définir fullbuild=%%i.%%j
) autre (
for /f "tokens=3" %%G in ('"reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR" %nul6%') do if not errorlevel 1 set /a "UBR=%%G"
pour /f "skip=2 tokens=3,4 delims=. " %%G dans ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v BuildLabEx') faire (
si UBR est défini (définir "fullbuild=%%G.!UBR!") sinon (définir "fullbuild=%%G.%%H")
)
)

:=================================================================================================================================================

:: Vérifier les identifiants d'activation

appel :dk_actids 55c92734-d682-4d71-983e-d6ec3f16059f
si non défini allapps (
%eline%
Échec de la recherche des identifiants d'activation. Abandon...
appel :dk_color %Blue% "Pour résoudre ce problème, activez Windows à partir du menu principal."
aller à dk_done
)

:=================================================================================================================================================

:: Vérifier l'édition Windows et la branche

définir osedition=
définir dismnotworking=

for /f "tokens=3 delims=: " %%a in ('DISM /English /Online /Get-CurrentEdition %nul6% ^| find /i "Current Edition :"') do set "osedition=%%a"
si la fonction osedition n'est pas définie, définissez dismnotworking=1

si %_wmic% EQU 1 définir "chkedi=for /f "tokens=2 delims==" %%a dans ('"wmic path %spp% où (ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' ET LicenseDependsOn est NULL ET PartialProductKey N'EST PAS NULL) obtenir LicenseFamily /VALUE" %nul6%')"
if %_wmic% EQU 0 set "chkedi=for /f "tokens=2 delims==" %%a in ('%psc% "(([WMISEARCHER]'SELECT LicenseFamily FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND LicenseDependsOn is NULL AND PartialProductKey IS NOT NULL').Get()).LicenseFamily ^| %% {echo ('LicenseFamily='+$_)}" %nul6%')"
si osedition %chkedi% n'est pas défini, faire si le niveau d'erreur n'est pas 1 (appeler set "osedition=%%a")

si non défini osedition (
%eline%
Échec de la détection de la version du système d'exploitation, abandon...
appel :dk_color %Blue% "Pour résoudre ce problème, activez Windows à partir du menu principal."
aller à dk_done
)

for /f "skip=2 tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID %nul6%') do set "regedition=%%a"
si /i n'est pas "%osedition%"="%regedition%" (
définir "showeditionerror=appel :dk_color %_Yellow% "[%osedition%] [Reg-%regedition%]."
)

définir la branche=
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v BuildBranch %nul6%') do set "branch=%%b"

:=================================================================================================================================================

:: Obtenir la liste des éditions cibles

définir _target=
définir _dtarget=
définir _ptarget=
définir _ntarget=
définir _wtarget=

si %winbuild% GEQ 10240 pour /f "tokens=4" %%a dans ('dism /online /english /Get-TargetEditions ^| findstr /i /c:"Target Edition : "') faire (si _dtarget est défini (définir "_dtarget= !_dtarget! %%a ") sinon (définir "_dtarget= %%a "))
if %winbuild% LSS 10240 for /f "tokens=4" %%a in ('%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':cbsxml\:.*';. ([scriptblock]::Create($f[1])) -GetTargetEditions;" ^| findstr /i /c:"Target Edition : "') do (if defined _ptarget (set "_ptarget= !_ptarget! %%a ") else (set "_ptarget= %%a "))

si %winbuild% GEQ 10240 si n'existe pas "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum" (
si %winbuild% GEQ 17063 appel :ced_edilist
si /i "%osedition:~0,4%"=="Core" définir _pro=Professional
si /i "%osedition%"="CoreN" définir _pro=ProfessionalN
définir "_dtarget= %_dtarget% !_wtarget! !_pro! "
)

:=================================================================================================================================================

pour %%# dans (CloudEdition CloudEditionN ServerRdsh) faire si /i %osedition%==%%# (
cls
écho:
appel :dk_color %Rouge% "==== Note ===="
écho:
echo [EditionID:%osedition% ^| %fullbuild%]
écho:
echo Changer cette édition ne supprimera peut-être pas les fonctionnalités spécifiques à "%osedition%".
écho:
appel :dk_color %_Yellow% "Appuyez sur [7] pour continuer quand même..."
choix /c 7 /n
cls
)

pour %%# dans ( %_dtarget% %_ptarget% ) faire si /i n'est pas "%%#"=="%osedition%" (
echo "!_target!" | find /i " %%# " %nul1% || set "_target= !_target! %%# "
)

si _target est défini (
pour %%# dans (%_target%) faire (
echo %%# | findstr /i "CountrySpecific CloudEdition" %nul% || (set "_ntarget=!_ntarget! %%#")
)
)

si non défini _ntarget (
%doubler%
écho:
Si la fonction dismnotworking est définie, appelez :dk_color %Red% "DISM.exe ne fonctionne pas."
appel :dk_color %Gray% "Éditions cibles introuvables."
echo L'édition actuelle [%osedition% ^| %winbuild%] ne peut pas être modifiée en une autre édition.
%doubler%
aller à dk_done
)

:=================================================================================================================================================

:cedmenu2

cls
si le mode terminal n'est pas défini, 98, 30
définir inpt=
définir le compteur à 0
définir vérifié=0
définir la cible=

%doubler%
écho:
appel :dk_color %Gray% "Vous pouvez changer l'édition [%osedition%] [%fullbuild%] en l'une des suivantes."
%erreur d'édition affichée%
si défini dismnotworking (
appel :dk_color %_Yellow% "Remarque - DISM.exe ne fonctionne pas."
if /i "%osedition:~0,4%"=="Core" call :dk_color %_Yellow% " - Vous verrez plus d'options d'édition à choisir une fois qu'il sera passé à Pro."
)
%doubler%
écho:

pour %%A dans (%_ntarget%) faire (
définir /un compteur+=1
si /i %%A==IoTEnterprise (
écho [!compteur!] %%A [GAC, pas LTSC]
) autre (
écho [!compteur!] %%A
)
définir la cible!compteur!=%%A
)

%doubler%
écho:
echo [0] %_exitmsg%
écho:
appel :dk_color %_Green% "Entrez un numéro d'option à l'aide de votre clavier et appuyez sur Entrée pour confirmer :"
définir /p inpt=
si "%inpt%"="" aller à cedmenu2
si "%inpt%"=="0" exit /b
pour /l %%i dans (1,1,%counter%) faire (si "%inpt%"=="%%i" définir verified=1)
définir la cible=!targetedition%inpt%!
si %verified%==0 aller à cedmenu2

:=================================================================================================================================================

si %winbuild% LSS 10240 aller à :cbsmethod
Si le fichier « %SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum » existe, allez à :ced_change_server

cls
si non défini, mode terminal con cols=105 lignes=32

si /i "%targetedition%"="ServerRdsh" (
écho:
appel :dk_color %Rouge% "==== Note ===="
écho:
echo Une fois l'édition modifiée en "%targetedition%",
Le système risque de ne pas pouvoir modifier correctement l'édition ultérieurement.
écho:
echo [1] Continuer quand même
echo [0] Retour
écho:
appel :dk_color %_Green% "Choisissez une option de menu à l'aide de votre clavier [1,0] :"
choix /C:10 /N
Si !errorlevel!==2, aller à cedmenu2
si !errorlevel!==1 rem
)

cls
définir la clé=
définir _chan=
définir _dismapi=0

:: Vérifiez si l'API DISM ou slmgr.vbs est requis pour la mise à niveau de l'édition

si le fichier "%SysPath%\spp\tokens\skus\%targetedition%\%targetedition%*.xrm-ms" n'existe pas (
echo %_wtarget% | find /i " %targetedition% " || (
définir _dismapi=1
)
)

définir "keyflow=Retail OEM:NONSLP OEM:DM Volume:MAK Volume:GVLK PGS:TB Retail:TB:Eval"

appel :ced_targetSKU %targetedition%
Si la référence cible est définie, appelez :ced_windowskey
si la clé est définie, si le canal pkeychannel est défini, définir _chan=%pkeychannel%
si la clé n'est pas définie, appelez :changeeditiondata
si la clé n'est pas définie si %_dismapi%==1 si /i "%targetedition%"=="Professional" (
définir la clé=VK7JG-NPHTM-C97JM-9MPGT-3V66T
définir _chan=Retail
)

si la clé n'est pas définie (
%eline%
echo [%targetedition% ^| %winbuild%]
Échec de la récupération de la clé de produit à partir de pkeyhelper.dll.
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)

:=================================================================================================================================================

:: Le passage d'une version Core à une version non Core et le changement d'édition dans une version de Windows antérieure à 17134 nécessitent la commande « changepk /productkey » ou l'API DISM, puis un redémarrage.
:: Dans d'autres cas, les éditions peuvent être modifiées instantanément avec "slmgr /ipk"

si %_dismapi%==1 (
si non défini mode terminal con cols=105 lignes=40
appel :ced_rebootflag
si rebootreq est défini, aller à dk_done
)

cls
%doubler%
écho:
%erreur d'édition affichée%
Si la fonction dismnotworking est définie, appelez :dk_color %_Yellow% "DISM.exe ne fonctionne pas."
echo Changement de l'édition actuelle [%osedition%] %fullbuild% vers [%targetedition%]...
écho:

si %_dismapi%==1 (
appel :dk_color %Green% "Notes -"
écho:
echo - Enregistrez votre travail avant de continuer, le système redémarrera automatiquement.
écho:
echo - Vous devrez activer l'option HWID une fois l'édition modifiée.
%doubler%
écho:
choix /C:21 /N /M "[1] Continuer [2] %_exitmsg% : "
if !errorlevel!==1 exit /b
)

:=================================================================================================================================================

si %_dismapi%==0 (
echo Installation de la clé %_chan% [%key%]
écho:
si %_wmic% EQU 1 wmic path %sps% où __CLASS='%sps%' appel InstallProductKey ProductKey="%key%" %nul%
if %_wmic% EQU 0 %psc% "try { $null=(([WMISEARCHER]'SELECT Version FROM %sps%').Get()).InstallProductKey('%key%'); exit 0 } catch { exit $_.Exception.InnerException.HResult }" %nul%
définir keyerror=!errorlevel!
cmd /c exit /b !keyerror!
si !keyerror! NEQ 0 définir "keyerror=[0x!=ExitCode!]"

si !keyerror! EQU 0 (
appel :dk_refresh
appel :dk_color %Green% "[Réussi]"
écho:
appel :dk_color %Gray% "Un redémarrage est nécessaire pour changer complètement l'édition."
) autre (
appel :dk_color %Red% "[Échec] [Code d'erreur : !keyerror!]"
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)
)

si %_dismapi%==1 (
écho:
Application de la méthode API DISM avec la clé %_chan% %key%. Veuillez patienter...
écho:

appel :ced_prep
si preperror est défini, aller à dk_done

%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':dismapi\:.*';. ([scriptblock]::Create($f[1])) %targetedition% %key%"
appel :ced_postprep
)
%doubler%

aller à dk_done

:=================================================================================================================================================

:cbsmethod

cls
si le terminal n'est pas défini (
mode con cols=105 lignes=32
%psc% "&{$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=31;$B.Height=200;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}" %nul%
)

appel :ced_rebootflag
si rebootreq est défini, aller à dk_done

écho:
%erreur d'édition affichée%
if defined dismnotworking call :dk_color %_Yellow% "Remarque - DISM.exe ne fonctionne pas."
echo Changement de l'édition actuelle [%osedition%] %fullbuild% vers [%targetedition%]...
écho:
appel :dk_color %Blue% "Important - Enregistrez votre travail avant de continuer, le système redémarrera automatiquement."
écho:
choix /C:01 /N /M "[1] Continuer [0] %_exitmsg% : "
si %errorlevel%==1 quitter /b

écho:
Initialisation en cours...
écho:

appel :ced_prep
si preperror est défini, aller à dk_done

si %_stg%==0 (définir l'étape=) sinon (définir l'étape=-ÉtapeActuelle)
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':cbsxml\:.*';. ([scriptblock]::Create($f[1])) -SetEdition %targetedition% %stage%"
appel :ced_postprep
%doubler%

aller à dk_done

:=================================================================================================================================================

:ced_change_server

cls
si le terminal n'est pas défini (
mode con cols=105 lignes=32
%psc% "&{$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=31;$B.Height=200;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}" %nul%
)

définir la clé=
définir _chan=
définir "keyflow=Volume:GVLK Retail Volume:MAK OEM:NONSLP OEM:DM PGS:TB Retail:TB:Eval"

appel :ced_targetSKU %targetedition%
Si la référence cible est définie, appelez :ced_windowskey
si la clé est définie, si le canal pkeychannel est défini, définir _chan=%pkeychannel%
si la clé n'est pas définie, appelez :changeeditiondata

si la clé n'est pas définie (
%eline%
echo [%targetedition% ^| %winbuild%]
Échec de la récupération de la clé de produit à partir de pkeyhelper.dll.
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)

appel :ced_rebootflag
si rebootreq est défini, aller à dk_done

cls
écho:
%erreur d'édition affichée%
if defined dismnotworking call :dk_color %_Yellow% "Remarque - DISM.exe ne fonctionne pas."
echo Changement de l'édition actuelle [%osedition%] %fullbuild% vers [%targetedition%]...
écho:

appel :ced_prep
si preperror est défini, aller à dk_done

echo Application de la commande avec la touche %_chan%...
echo DISM /online /Set-Edition:%targetedition% /ProductKey:%key% /AcceptEula
DISM /online /Set-Edition:%targetedition% /ProductKey:%key% /AcceptEULA

appel :ced_postprep
%doubler%

aller à dk_done

:=================================================================================================================================================

:ced_prep

définir _time=
définir preperror=

pour chaque /f %%a dans ('%psc% "(Get-Date).ToString('yyyyMMdd-HHmmssfff')"') faire définir _time=%%a

%psc% Arrêter le service TrustedInstaller -force %nul%

sc query TrustedInstaller | find /i "RUNNING" %nul% && (
%eline%
Échec de l'arrêt du service TrustedInstaller.
Veuillez redémarrer votre machine en utilisant l'option de redémarrage et réessayer.
définir preperror=1
quitter /b
)

copier /y /b "%SystemRoot%\logs\cbs\cbs.log" "%SystemRoot%\logs\cbs\backup_cbs_%_time%.log" %nul%
copier /y /b "%SystemRoot%\logs\DISM\dism.log" "%SystemRoot%\logs\DISM\backup_dism_%_time%.log" %nul%

supprimer /f /q "%SystemRoot%\logs\cbs\cbs.log" %nul%
supprimer /f /q "%SystemRoot%\logs\DISM\dism.log" %nul%

:: Initialiser ceci pour apparaître dans les nouveaux journaux

dism /online /english /Get-CurrentEdition %nul%
dism /online /english /Get-TargetEditions %nul%
quitter /b

:=================================================================================================================================================

:ced_postprep

délai d'attente dépassé /t 5 %nul1%
copier /y /b "%SystemRoot%\logs\cbs\cbs.log" "%SystemRoot%\logs\cbs\cbs_%_time%.log" %nul%
copier /y /b "%SystemRoot%\logs\DISM\dism.log" "%SystemRoot%\logs\DISM\dism_%_time%.log" %nul%

si le fichier "!desktop!\ChangeEdition_Logs\" n'existe pas, le modifier en "!desktop!\ChangeEdition_Logs\" %nul%
appel :compresslog cbs\cbs_%_time%.log ChangeEdition_Logs\CBS %nul%
appel :compresslog DISM\dism_%_time%.log ChangeEdition_Logs\DISM %nul%

écho:
if %winbuild% GEQ 9200 %psc% "if ((Get-WindowsOptionalFeature -Online -FeatureName NetFx3).State -eq 'Enabled') {Write-Host 'Vérification de l'état de .NET Framework 3.5 - Activé'}"
Les fichiers journaux sont copiés dans le dossier ChangeEdition_Logs sur votre bureau.
écho:
appel :dk_color %Blue% "En cas d'erreur, vous devez redémarrer le système avant de réessayer."
écho:
définir les correctifs=%fixes% %mas%change_edition_issues
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%change_edition_issues"
quitter /b

:=================================================================================================================================================

:: Obtenir la liste des éditions

:ced_edilist

si %_wmic% EQU 1 définir "chkedi=for /f "tokens=2 delims==" %%a dans ('"wmic path %spp% où (ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' ET LicenseDependsOn est NULL) obtenir LicenseFamily /VALUE" %nul6%')"
si %_wmic% EQU 0 définir "chkedi=for /f "tokens=2 delims==" %%a dans ('%psc% "(([WMISEARCHER]'SELECT LicenseFamily FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND LicenseDependsOn is NULL').Get()).LicenseFamily ^| %% {echo ('LicenseFamily='+$_)}" %nul6%')"
%chkedi% faire appel set "_wtarget= !_wtarget! %%a "
quitter /b

:=================================================================================================================================================

:: Vérifier les indicateurs de redémarrage en attente

:ced_rebootflag

définir rebootreq=
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" %nul% && set rebootreq=1
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" %nul% && set rebootreq=1

si défini rebootreq (
%eline%
echo Indicateurs de redémarrage en attente trouvés.
écho:
Veuillez vous assurer que Windows est entièrement à jour, redémarrez le système et réessayez.
)
quitter /b

:=================================================================================================================================================

:ced_windowskey

for %%# in (pkeyhelper.dll) do @if "%%~$PATH:#"=="" exit /b
pour %%# dans (%keyflow%) faire (
appel :k_pkey %targetSKU% '%%#'
si pkey est défini, appelez :k_pkeychannel !pkey!
si /i "!pkeychannel!"=="%%#" (
définir la clé=!pkey!
quitter /b
)
)
quitter /b

:=================================================================================================================================================

:ced_targetSKU

définir k=%1
définir targetSKU=
for %%# in (pkeyhelper.dll) do @if "%%~$PATH:#"=="" exit /b

appel :dk_reflection

définir d1=%ref% [void]$TypeBuilder.DefinePInvokeMethod('GetEditionIdFromName', 'pkeyhelper.dll', 'Public, Static', 1, [int], @([String], [int].MakeByRefType()), 1, 3);
définir d1=%d1% $out = 0; [void]$TypeBuilder.CreateType()::GetEditionIdFromName('%k%', [ref]$out); $out

pour /f %%a dans ('%psc% "%d1%"') faire si non errorlevel 1 (définir targetSKU=%%a)
si "%targetSKU%"="0" définir targetSKU=
quitter /b

:=================================================================================================================================================

:: https://github.com/asdcorp/Set-WindowsCbsEdition

:cbsxml:[
param (
    [Paramètre()]
    [Chaîne]$SetEdition,

    [Paramètre()]
    [Switch]$GetTargetEditions,

    [Paramètre()]
    [Switch]$StageCurrent
)

fonction Get-AssemblyIdentity {
    param (
        [Chaîne]$NomDuPackage
    )

    $PackageName = [String]$PackageName
    $packageData = ($PackageName -split '~')

    si ($packageData[3] -eq '') {
        $packageData[3] = 'neutre'
    }

    return "<assemblyIdentity name=`"$($packageData[0])`" version=`"$($packageData[4])`" processorArchitecture=`"$($packageData[2])`" publicKeyToken=`"$($packageData[1])`" language=`"$($packageData[3])`" />"
}

fonction Get-SxsName {
    param (
        [Chaîne]$NomDuPackage
    )

    $name = ($PackageName -replace '[^A-z0-9\-\._]', '')

    si ($name.Length -gt 40) {
        $name = ($name[0..18] -join '') + '\.\.' + ($name[-19..-1] -join '')
    }

    retourner $name.ToLower()
}

fonction Find-EditionXmlInSxs {
    param (
        [Chaîne]$Édition
    )

    $candidats = @($Édition, 'Client', 'Serveur')
    $winSxs = $Env:SystemRoot + '\WinSxS'
    $allInSxs = Get-ChildItem -Path $winSxs | select Name

    pour chaque candidat dans $candidats {
        $name = Get-SxsName -PackageName "Microsoft-Windows-Editions-$candidate"
        $packages = $allInSxs | where name -Match ('^.*_'+$name+'_31bf3856ad364e35')

        si ($packages.Length -eq 0) {
            continuer
        }

        $package = $packages[-1].Nom
        $testPath = $winSxs + "\$package\" + $Edition + 'Edition.xml'

        si(Test-Path -Path $testPath -PathType Feuille) {
            renvoyer $testPath
        }
    }

    renvoyer $null
}

fonction Find-EditionXml {
    param (
        [Chaîne]$Édition
    )

    $servicingEditions = $Env:SystemRoot + '\servicing\Editions'
    $editionXml = $Edition + 'Edition.xml'

    $editionXmlInServicing = $servicingEditions + '\' + $editionXml

    si (Test-Path -Path $editionXmlInServicing -PathType Leaf) {
        renvoyer $editionXmlInServicing
    }

    retourner Find-EditionXmlInSxs -Edition $Edition
}

fonction Write-UpgradeCandidates {
    param (
        [HashTable]$InstallCandidates
    )

    $editionCount = 0
    Write-Host 'Éditions pouvant être mises à niveau vers :'
    foreach($candidate in $InstallCandidates.Keys) {
        Write-Host "Édition cible : $candidate"
        $editionCount++
    }

    si ($editionCount -eq 0) {
        Write-Host '(aucune édition n'est disponible)'
    }
}

fonction Write-UpgradeXml {
    param (
        [Tableau]$CandidatsÀRetrait,
        [Tableau]$InstallCandidates,
        [Booléen]$Stage
    )

    $removeAction = 'supprimer'
    si($Stage) {
        $removeAction = 'stage'
    }

    Write-Output '<?xml version="1.0"?>'
    Write-Output '<unattend xmlns="urn:schemas-microsoft-com:unattend">'
    Write-Output '<servicing>'

    foreach($package in $InstallCandidates) {
        Write-Output '<package action="install">'
        Écrire-Sortie (Obtenir-IdentitéAssemblage -NomPackage $package)
        Écrire-Sortie '</package>'
    }

    foreach($package in $RemovalCandidates) {
        Write-Output "<package action=`"$removeAction`">"
        Écrire-Sortie (Obtenir-IdentitéAssemblage -NomPackage $package)
        Écrire-Sortie '</package>'
    }

    Write-Output '</servicing>'
    Write-Output '</unattend>'
}

fonction Write-Usage {
    Obtenir-Aide $script:MyInvocation.MyCommand.Path -détaillé
}

$version = '1.0'
$getTargetsParam = $GetTargetEditions.IsPresent
$stageCurrentParam = $StageCurrent.IsPresent

si ($SetEdition -eq '' -et ($false -eq $getTargetsParam)) {
    Utilisation de l'écriture
    Sortie 1
}

$candidatsàlaretraite = @();
$installCandidates = @{};

$packages = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages' | select Name | where { $_.name -match '^.*\\Microsoft-Windows-.*Edition~' }
foreach($package dans $packages) {
    $state = (Get-ItemProperty -Path "Registry::$($package.Name)").CurrentState
    $packageName = ($package.Name -split '\\')[-1]
    $packageEdition = (($packageName -split 'Edition~')[0] -split 'Microsoft-Windows-')[-1]

    si ($state -eq 0x40) {
        si ($null -eq $installCandidates[$packageEdition]) {
            $installCandidates[$packageEdition] = @()
        }

        si ($false -eq ($installCandidates[$packageEdition] -contains $packageName)) {
            $installCandidates[$packageEdition] = $installCandidates[$packageEdition] + @($packageName)
        }
    }

    si ((($state -eq 0x50) -ou ($state -eq 0x70)) -et ($false -eq ($removalCandidates -contains $packageName))) {
        $removalCandidates = $removalCandidates + @($packageName)
    }
}

si($getTargetsParam) {
    Écrire-MiseÀNiveauCandidats -InstallerCandidats $installerCandidats
    Sortie
}

si ($false -eq ($installCandidates.Keys -contains $SetEdition)) {
    Write-Error "Le système ne peut pas être mis à niveau vers `"$SetEdition`""
    Sortie 1
}

$xmlPath = $Env:SystemRoot + '\Temp' + "\$([Guid]::NewGuid().Guid)CbsUpgrade.xml"

Write-UpgradeXml -RemovalCandidates $removalCandidates `
    -InstallerCandidats $installerCandidats[$SetEdition] `
    -Étape $stageCurrentParam >$xmlPath

$editionXml = Find-EditionXml -Edition $SetEdition
si ($null -eq $editionXml) {
    Avertissement : « Impossible de trouver le fichier XML de configuration spécifique à l’édition. Poursuite du processus sans ce fichier… »
}

Write-Host 'Démarrage du processus de mise à niveau. Cela peut prendre un certain temps...'

DISM.EXE /Anglais /SansRedémarrage /EnLigne /Appliquer-SansAttendre:$xmlPath
$dismError = $LASTEXITCODE

Supprimer-Élément -Chemin $xmlPath -Forcer

si (($dismError -ne 0) -et ($dismError -ne 3010)) {
    Write-Error 'Échec de la mise à niveau vers l'édition cible'
    Sortie $dismError
}

si ($null -ne $editionXml) {
    $destination = $Env:SystemRoot + '\' + $SetEdition + '.xml'
    Copier-Élément -Chemin $editionXml -Destination $destination

    DISM.EXE /Anglais /SansRedémarrage /EnLigne /Appliquer-SansAttendre:$editionXml
    $dismError = $LASTEXITCODE

    si (($dismError -ne 0) -et ($dismError -ne 3010)) {
        Write-Error 'Échec de l'application des paramètres spécifiques à l'édition'
        Sortie $dismError
    }
}

Redémarrer l'ordinateur
:cbsxml:]

:=================================================================================================================================================

:: Changer d'édition à l'aide de l'API DISM
:: Merci à Alex (alias may, ave9858)

:dismapi:[
param (
    [Paramètre()]
    [Chaîne]$TargetEdition,

    [Paramètre()]
    [Chaîne]$Clé
)

$AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1)
$ModuleBuilder = $AssemblyBuilder.DefineDynamicModule(2, $False)
$TB = $ModuleBuilder.DefineType(0)

[void]$TB.DefinePInvokeMethod('DismInitialize', 'DismApi.dll', 22, 1, [int], @([int], [IntPtr], [IntPtr]), 1, 3)
[void]$TB.DefinePInvokeMethod('DismOpenSession', 'DismApi.dll', 22, 1, [int], @([String], [IntPtr], [IntPtr], [UInt32].MakeByRefType()), 1, 3)
[void]$TB.DefinePInvokeMethod('_DismSetEdition', 'DismApi.dll', 22, 1, [int], @([UInt32], [String], [String], [IntPtr], [IntPtr], [IntPtr]), 1, 3)
$Dism = $TB.CreateType()

[void]$Dism::DismInitialize(2, 0, 0)
$Session = 0
[void]$Dism::DismOpenSession('DISM_{53BFAE52-B167-4E2F-A258-0A37B57FF845}', 0, 0, [ref]$Session)
if (!$Dism::_DismSetEdition($Session, "$TargetEdition", "$Key", 0, 0, 0)) {
    Redémarrer l'ordinateur
}
:dismapi:]

:=================================================================================================================================================

:: 1ère colonne = Clé générique de vente au détail/OEM/MAK/GVLK
:: 2e colonne = Type de clé
:: 3e colonne = ID de l'édition WMI
:: 4e colonne = Nom de la version au cas où le même ID d'édition serait utilisé dans différentes versions du système d'exploitation avec des clés différentes
:: Séparateur = _

:: Pour les éditions Windows 10/11, la clé HWID est indiquée chaque fois que cela est possible ; dans les versions serveur, la clé KMS est indiquée chaque fois que cela est possible.
Pour Windows, les clés génériques sont mentionnées jusqu'à 22000 et pour Server, jusqu'à 17763 ; les suivantes sont extraites de la bibliothèque pkeyhelper.dll.

:données d'édition modifiées

si le fichier "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum" existe (
si %winbuild% GTR 17763 quitter /b
) autre (
if %winbuild% GEQ 22000 exit /b
)
si le fichier « %SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*CorEdition~*.mum » existe (définir Cor=Cor) sinon (définir Cor=)

définir w=
pour %%# dans (
XGVPP-NMH47-7TTHJ-W3FW7-8HV%w%2C__OEM:NONSLP_Entreprise
D6RD9-D4N8T-RT9QX-YW6YT-FCW%w%WJ______Démarrage_de_vente
3V6Q6-NQXCX-V8YXR-9QCYV-QPF%w%CT__Volume:MAK_EnterpriseN
3NFXW-2T27M-2BDW6-4GHRV-68X%w%RX______Retail_StarterN
VK7JG-NPHTM-C97JM-9MPGT-3V6%w%6T______Professionnel_de_la_vente
2B87N-8KFHP-DKV6R-Y2C8J-PKC%w%KT______Retail_ProfessionalN
4CPRK-NM3K3-X6XXQ-RXX86-WXC%w%HW______Retail_CoreN
N2434-X9D7W-8PF6X-8DV9T-8TY%w%MD______Retail_CoreCountrySpecific
BT79Q-G7N6G-PGBYW-4YWX6-6F4%w%BT______Retail_CoreSingleLanguage
YTMG3-N6DKC-DKB77-7M9GH-8HV%w%X7______Core_de_vente
XKCNC-J26Q9-KFHD2-FKTHY-KD7%w%2Y__OEM:NONSLP_PPIPro
YNMGQ-8RYV3-4PGQ3-C8XTP-7CF%w%BY______Commerce_de_détail_Éducation
84NGF-MHBT6-FXBX8-QWJK7-DRR%w%8H______Commerce_de_détail_ÉducationN
KCNVH-YKWX8-GJJB9-H9FDT-6F7%w%W2__Volume:MAK_EnterpriseS_VB
43TBQ-NH92J-XKTM7-KT3KK-P39%w%PB__OEM:NONSLP_EnterpriseS_RS5
NK96Y-D9CD8-W44CQ-R8YTK-DYJ%w%WX__OEM:NONSLP_EnterpriseS_RS1
FWN7H-PF93Q-4GGP8-M8RF3-MDW%w%WW__OEM:NONSLP_EnterpriseS_TH
RQFNW-9TPM3-JQ73T-QV4VQ-DV9%w%PT__Volume:MAK_EnterpriseSN_VB
M33WV-NHY3C-R7FPM-BQGPT-239%w%PG__Volume:MAK_EnterpriseSN_RS5
2DBW3-N2PJG-MVHW3-G7TDK-9HK%w%R4__Volume:MAK_EnterpriseSN_RS1
NTX6B-BRYC2-K6786-F6MVQ-M7V%w%2X__Volume:MAK_EnterpriseSN_TH
G3KNM-CHG6T-R36X3-9QDG6-8M8%w%K9______Commerce_ProfessionnelMonolingue
HNGCC-Y38KG-QVK8D-WMWRK-X86%w%VK______Commerce_ProfessionnelPaysSpécifique
DXG7C-N36C4-C4HTG-X4T3X-2YV%w%77______Station de travail professionnelle pour le commerce de détail
WYPNQ-8C467-V2W6J-TX4WX-WT2%w%RQ______Poste de travail professionnel pour le commerce de détailN
8PTT6-RNW4C-6V7J2-C2D3X-MHB%w%PB______Formation_Professionnelle_Commerce_de_Détail
GJTYN-HDMQY-FRR76-HVGC7-QPF%w%8P______Formation_Professionnelle_Commerce_de_DétailN
C4NTJ-CX6Q2-VXDMR-XVKGM-F9D%w%JC__Volume:MAK_EnterpriseG
46PN6-R9BK9-CVHKB-HWQ9V-MBJ%w%Y8__Volume:MAK_EnterpriseGN
NJCF7-PW8QT-3324D-688JX-2YV%w%66______Retail_ServerRdsh
XQQYW-NFFMW-XJPBH-K8732-CKF%w%FD______OEM:DM_IoTEnterprise
QPM6N-7J2WJ-P88HH-P3YRH-YY7%w%4H__OEM:NONSLP_IoTEnterpriseS
K9VKN-3BGWV-Y624W-MCRMQ-BHD%w%CD______Retail_CloudEditionN
KY7PN-VR6RX-83W6Y-6DDYQ-T6R%w%4W______Édition Cloud Vente au détail
V3WVW-N2PV2-CGWC3-34QGF-VMJ%w%2C______Retail_Cloud
NH9J3-68WK7-6FB93-4K3DF-DJ4%w%F6______Retail_CloudN
2HN6V-HGTM8-6C97C-RK67V-JQP%w%FD______Retail_CloudE
WC2BQ-8NRM3-FDDYY-2BFGV-KHK%w%QY_Volume:GVLK_ServerStandard%Cor%_RS1
CB7KF-BWN84-R7R2Y-793K2-8XD%w%DG_Volume:GVLK_ServerDatacenter%Cor%_RS1
JCKRF-N37P4-C2D82-9YXRT-4M6%w%3B_Volume:GVLK_ServerSolution_RS1
QN4C6-GBJD2-FB422-GHWJK-GJG%w%2R_Volume:GVLK_ServerCloudStorage_RS1
VP34G-4NPPG-79JTQ-864T4-R3M%w%QX_Volume:GVLK_ServerAzureCor_RS1
9JQNQ-V8HQ6-PKB8H-GGHRY-R62%w%H6______Retail_ServerAzureNano_RS1
VN8D3-PR82H-DB6BJ-J9P4M-92F%w%6J______Retail_ServerStorageStandard_RS1
48TQX-NVK3R-D8QR3-GTHHM-8FH%w%XC______Retail_ServerStorageWorkgroup_RS1
2HXDN-KRXHB-GPYC7-YCKFJ-7FV%w%DG_Volume:GVLK_ServerDatacenterACor_RS3
PTXN8-JFHJM-4WC78-MPCBR-9W4%w%KR_Volume:GVLK_ServerStandardACor_RS3
) faire (
pour /f "tokens=1-4 delims=_" %%A dans ("%%#") faire si /i %targetedition%==%%C (

si la clé n'est pas définie (
4ème ensemble=%%D
si non défini 4ème (
définir "key=%%A" et définir "_chan=%%B"
) autre (
echo "%branch%" | find /i "%%D" %nul1% && (set "key=%%A" & set "_chan=%%B")
)
)
)
)
quitter /b

:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:change_offedition

définir "ligne=écho ___________________________________________________________________________________________"

cls
si le mode terminal n'est pas défini, 98, 30
Titre : Changer l’édition Office %masver%

si %winbuild% LSS 7600 (
%eline%
echo Version du système d'exploitation non prise en charge détectée [%winbuild%].
Cette option est prise en charge uniquement pour Windows 7/8/8.1/10/11 et leurs équivalents serveur.
aller à dk_done
)

écho:
Initialisation en cours...
écho:

:=================================================================================================================================================

définir spp=SoftwareLicensingProduct
définir sps=SoftwareLicensingService

appel :dk_reflection
appel :dk_ckeckwmic
appel :dk_sppissue

pour /f "tokens=6-7 delims=[]. " %%i dans ('ver') faire si non "%%j"=="" (
définir fullbuild=%%i.%%j
) autre (
for /f "tokens=3" %%G in ('"reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR" %nul6%') do if not errorlevel 1 set /a "UBR=%%G"
pour /f "skip=2 tokens=3,4 delims=. " %%G dans ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v BuildLabEx') faire (
si UBR est défini (définir "fullbuild=%%G.!UBR!") sinon (définir "fullbuild=%%G.%%H")
)
)

:=================================================================================================================================================

:: Vérifier l'édition Windows
:: Ceci sert simplement à garantir le bon fonctionnement de SPP/WMI.

cls
définir osedition=0
si %_wmic% EQU 1 définir "chkedi=for /f "tokens=2 delims==" %%a dans ('"wmic path %spp% où (ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' ET LicenseDependsOn est NULL ET PartialProductKey N'EST PAS NULL) obtenir LicenseFamily /VALUE" %nul6%')"
if %_wmic% EQU 0 set "chkedi=for /f "tokens=2 delims==" %%a in ('%psc% "(([WMISEARCHER]'SELECT LicenseFamily FROM %spp% WHERE ApplicationID=''55c92734-d682-4d71-983e-d6ec3f16059f'' AND LicenseDependsOn is NULL AND PartialProductKey IS NOT NULL').Get()).LicenseFamily ^| %% {echo ('LicenseFamily='+$_)}" %nul6%')"
%chkedi% faire si le niveau d'erreur n'est pas 1 (appeler set "osedition=%%a")

si %osedition%==0 (
%eline%
Échec de la détection de la version du système d'exploitation. Abandon...
appel :dk_color %Blue% "Pour résoudre ce problème, activez Windows à partir du menu principal."
aller à dk_done
)

:=================================================================================================================================================

:: Vérifier si Office 16.0 C2R est installé

définir o16c2r=
définir _68=HKLM\SOFTWARE\Microsoft\Office
définir _86=HKLM\SOFTWARE\Wow6432Node\Microsoft\Office

for /f "skip=2 tokens=2*" %%a in ('"reg query %_86%\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" (set o16c2r=1&set o16c2r_reg=%_86%\ClickToRun)
for /f "skip=2 tokens=2*" %%a in ('"reg query %_68%\ClickToRun /v InstallPath" %nul6%') do if exist "%%b\root\Licenses16\ProPlus*.xrm-ms" (set o16c2r=1&set o16c2r_reg=%_68%\ClickToRun)

si non défini o16c2r_reg (
%eline%
echo Office C2R 2016 ou une version ultérieure n'est pas installé, or ce script est requis.
Téléchargez et installez Office à partir de l'URL ci-dessous, puis réessayez.
définir les correctifs=%fixes% %mas%genuine-installation-media
appel :dk_color %_Yellow% "%mas%genuine-installation-media"
aller à dk_done
)

appel :ch_getinfo

:=================================================================================================================================================

:: Vérifier les détails minimums requis

si %verchk% LSS 9029 (
%eline%
echo La version d'Office installée est %_version%.
La version minimale requise est la 16.0.9029.2167.
écho Abandon...
appel :dk_color %Blue% "Téléchargez et installez la dernière version d'Office à partir de l'URL ci-dessous et réessayez."
définir les correctifs=%fixes% %mas%genuine-installation-media
appel :dk_color %_Yellow% "%mas%genuine-installation-media"
aller à dk_done
)

pour %%A dans (
_oArch
_updch
_lang
_clversion
_version
_Données d'audience
_oIds
_c2rXml
_c2rExe
_c2rCexe
_masterxml
) faire (
si non défini %%A (
%eline%
Échec de la recherche de %%A. Abandon...
appel :dk_color %Blue% "Téléchargez et installez Office à partir de l'URL ci-dessous et réessayez."
définir les correctifs=%fixes% %mas%genuine-installation-media
appel :dk_color %_Yellow% "%mas%genuine-installation-media"
aller à dk_done
)
)

si %winbuild% LSS 10240 si défini ltscfound (
%eline%
echo Office installé semble provenir du canal de volume %ltsc19%%ltsc21%%ltsc24%,
echo qui n'est pas officiellement pris en charge par votre version de build Windows %winbuild%.
écho Abandon...
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)

définir unsupbuild=
si %winbuild% LSS 10240 si %winbuild% GEQ 9200 si %verchk% GTR 16026 définir unsupbuild=1
si %winbuild% LSS 9200 si %verchk% GTR 12527 définir unsupbuild=1

si défini unsupbuild (
%eline%
echo Office %verchk% n'est pas pris en charge sur votre version de build Windows %winbuild%.
écho Abandon...
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)

définir "o_randguid="
for /f %%G in ('%psc% "[Guid]::NewGuid().Guid" ^| findstr /r "^[0123456789abcdef]*-[0123456789abcdef]*-[0123456789abcdef]*-[0123456789abcdef]*-[0123456789abcdef]*$"') do set "o_randguid=%%G"
si non défini o_randguid (
%eline%
Impossible de générer un GUID avec PowerShell.
écho Abandon...
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à dk_done
)
md "%SystemRoot%\Temp\%o_randguid%\"

:=================================================================================================================================================

:oemenu

cls
définir les correctifs=
si le mode terminal n'est pas défini, 76, 25
Titre : Changer l’édition Office %masver%
écho:
écho:
écho:
écho:
écho ____________________________________________________________
écho:
echo [1] Modifier toutes les éditions
écho [2] Ajouter une édition
écho [3] Supprimer l'édition
écho:
echo [4] Ajouter/Supprimer des applications
écho ____________________________________________
écho:
echo [5] Changer le canal de mise à jour Office
echo [0] %_exitmsg%
écho ____________________________________________________________
écho:
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier [1,2,3,4,5,0]"
choix /C:123450 /N
définir _el=!errorlevel!
if !_el!==6 exit /b
si !_el!==5 aller à :oe_changeupdchnl
si !_el!==4 allez à :oe_editedition
if !_el!==3 goto :oe_removeedition
si !_el!==2 définir change=0& aller à :oe_edition
si !_el!==1 définir change=1& aller à :oe_edition
aller à :oemenu

:=================================================================================================================================================

:oe_edition

cls
appel :oe_chkinternet
si non défini _int (
aller à :oe_goback
)

cls
si le mode terminal n'est pas défini, 76, 25
si %change%==1 (
titre Modifier toutes les éditions %masver%
) autre (
titre Ajouter l'édition %masver%
)

écho:
écho:
écho:
écho:
Les éditions Echo O365/Mondo intègrent les fonctionnalités les plus récentes.     
écho ____________________________________________________________
écho:
echo [1] Suites de bureaux - Commerce de détail
echo [2] Suites bureautiques - Volume
echo [3] Office SingleApps - Retail
echo [4] Office SingleApps - Volume
écho ____________________________________________
écho:
echo [0] Retour
écho ____________________________________________________________
écho:
appel :dk_color2 %_White% " " %_Green% "Choisissez une option de menu à l'aide de votre clavier [1,2,3,4,0]"
choix /C:12340 /N
définir _el=!errorlevel!
if !_el!==5 goto :oemenu
if !_el!==4 set list=SingleApps_Volume&goto :oe_editionchangepre
if !_el!==3 set list=SingleApps_Retail&goto :oe_editionchangepre
if !_el!==2 set list=Suites_Volume&goto :oe_editionchangepre
if !_el!==1 set list=Suites_Retail&goto :oe_editionchangepre
aller à :oe_edition

:=================================================================================================================================================

:oe_editionchangepre

cls
définir editedition=
appel :ch_getinfo
appel :oe_tempcleanup
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':getlist\:.*';. ([scriptblock]::Create($f[1]))"

:oe_editionchange

cls
si le terminal n'est pas défini (
mode 98, 45
%psc% "&{$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=44;$B.Height=100;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}" %nul%
)

si le fichier %SystemRoot%\Temp\%o_randguid%\%list%.txt n'existe pas (
%eline%
Échec de la génération de la liste des éditions disponibles.
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à :oe_goback
)

définir inpt=
définir le compteur à 0
définir vérifié=0
définir _notfound=
définir la cible=

%doubler%
écho:
appel :dk_color %Gray% "Éditions Office installées : %_oIds%"
appel :dk_color %Gray% "Vous pouvez sélectionner l'une des éditions Office suivantes."
si %winbuild% LSS 10240 (
Les produits non pris en charge, tels que les versions 2019/2021/2024, sont exclus de cette liste.
) autre (
pour %%# dans (2019 2021 2024) faire (
trouver /i "%%#" "%SystemRoot%\Temp\%o_randguid%\%list%.txt" %nul1% || (
si _notfound est défini (définir _notfound=%%#, !_notfound!) sinon (définir _notfound=%%#)
)
)
si défini _notfound appel :dk_color %Gray% "Office !_notfound! n'est pas dans cette liste car une ancienne version [%_version%] d'Office est installée."
)
%doubler%
écho:

pour /f "usebackq delims=" %%A dans (%SystemRoot%\Temp\%o_randguid%\%list%.txt) faire (
définir /un compteur+=1
si !compteur! LSS 10 (
écho [!compteur!] %%A
) autre (
écho [!compteur!] %%A
)
définir la cible!compteur!=%%A
)

%doubler%
écho:
echo [0] Retour
écho:
appel :dk_color %_Green% "Entrez un numéro d'option à l'aide de votre clavier et appuyez sur Entrée pour confirmer :"
définir /p inpt=
si "%inpt%"="" aller à :oe_editionchange
si "%inpt%"=="0" (appelez :oe_tempcleanup & allez à :oe_edition)
pour /l %%i dans (1,1,%counter%) faire (si "%inpt%"=="%%i" définir verified=1)
définir la cible=!targetedition%inpt%!
si %verified%==0 aller à :oe_editionchange

:=================================================================================================================================================

:: Définir les exclusions d'applications

:oe_excludeappspre

cls
suites d'ensembles=
echo %list% | find /i "Suites" %nul1% && (
définir suites=1
%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':getappnames\:.*';. ([scriptblock]::Create($f[1]))"
si le fichier %SystemRoot%\Temp\%o_randguid%\getAppIds.txt n'existe pas (
%eline%
Échec de la génération de la liste des applications disponibles.
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à :oe_goback
)
)

pour %%# dans (
Accéder
Exceller
Lync
OneNote
Perspectives
PowerPoint
Projet
Éditeur
Visio
Mot
) faire (
si des suites définies (
trouver /i "%%#" "%SystemRoot%\Temp\%o_randguid%\getAppIds.txt" %nul1% && (set %%#_st=On) || (set %%#_st=)
) autre (
définir %%#_st=
)
)

Si Lync_st est défini, définissez Lync_st=Désactivé
définir OneDrive_st=Désactivé
si des suites sont définies (définir Teams_st=Off) sinon (définir Teams_st=)

définir OutlookForWindows_st=
si %winbuild% GEQ 19041 si Outlook_st est défini echo %targetedition% | find /i "O365" %nul1% && (
définir OutlookForWindows_st=Désactivé
)

:oe_excludeapps

cls
si le mode terminal n'est pas défini, 98, 32

%doubler%
écho:
appel :dk_color %Gray% "Édition cible : %targetedition%"
appel :dk_color %Gray% "Pour exclure les applications listées ci-dessous de l'installation, basculez-les de On à Off."
if defined editedition call :dk_color %Gray% "Remarque : l’état Marche/Arrêt ci-dessous ne reflète pas l’état actuel des applications installées."
%doubler%
si les suites définies affichent :
si Access_st est défini echo [A] Accès : %Access_st%
si Excel_st est défini, afficher [E] Excel : %Excel_st%
si OneNote_st est défini, afficher [N] OneNote : %OneNote_st%
si Outlook_st est défini echo [O] Outlook ^(Classique^) : %Outlook_st%
si PowerPoint_st est défini echo [P] PowerPoint : %PowerPoint_st%
si Project_st est défini echo [J] Projet : %Project_st%
si Publisher_st est défini echo [R] Éditeur : %Publisher_st%
si Visio_st est défini echo [V] Visio : %Visio_st%
si Word_st est défini, afficher [W] Mot : %Word_st%
écho:
si Lync_st est défini, afficher [L] Skype Entreprise : %Lync_st%
si OutlookForWindows_st est défini, afficher [K] Outlook ^(Nouveau^) : %OutlookForWindows_st%
si OneDrive_st est défini, afficher [D] OneDrive : %OneDrive_st%
si Teams_st est défini, afficher [T] Équipes : %Teams_st%
%doubler%
écho:
écho [1] Continuer
echo [0] Retour
%doubler%
écho:
appel :dk_color %_Green% "Choisissez une option de menu à l'aide de votre clavier :"
choix /C:AENOPJRVWLKDT10 /N
définir _el=!errorlevel!
if !_el!==15 goto :oemenu
if !_el!==14 call :excludelist & goto :oe_editionchangefinal
si !_el!==13 si Teams_st est défini (si "%Teams_st%"=="Off" (définir Teams_st=ON) sinon (définir Teams_st=Off))
si !_el!==12 si OneDrive_st est défini (si "%OneDrive_st%"=="Off" (définir OneDrive_st=ON) sinon (définir OneDrive_st=Off))
si !_el!==11 si OutlookForWindows_st est défini (si "%OutlookForWindows_st%"=="Off" (définir OutlookForWindows_st=ON) sinon (définir OutlookForWindows_st=Off))
si !_el!==10 si Lync_st est défini (si "%Lync_st%"=="Off" (définir Lync_st=ON) sinon (définir Lync_st=Off))
si !_el!==9 si Word_st est défini (si "%Word_st%"=="Off" (définir Word_st=ON) sinon (définir Word_st=Off))
si !_el!==8 si Visio_st est défini (si "%Visio_st%"=="Off" (définir Visio_st=ON) sinon (définir Visio_st=Off))
si !_el!==7 si Publisher_st est défini (si "%Publisher_st%"=="Off" (définir Publisher_st=ON) sinon (définir Publisher_st=Off))
si !_el!==6 si Project_st est défini (si "%Project_st%"=="Off" (définir Project_st=ON) sinon (définir Project_st=Off))
si !_el!==5 si PowerPoint_st est défini (si "%PowerPoint_st%"=="Off" (définir PowerPoint_st=ON) sinon (définir PowerPoint_st=Off))
si !_el!==4 si Outlook_st est défini (si "%Outlook_st%"=="Off" (définir Outlook_st=ON) sinon (définir Outlook_st=Off))
si !_el!==3 si OneNote_st est défini (si "%OneNote_st%"=="Off" (définir OneNote_st=ON) sinon (définir OneNote_st=Off))
si !_el!==2 si Excel_st est défini (si "%Excel_st%"=="Off" (définir Excel_st=ON) sinon (définir Excel_st=Off))
si !_el!==1 si Access_st est défini (si "%Access_st%"=="Off" (définir Access_st=ON) sinon (définir Access_st=Off))
aller à :oe_excludeapps

:liste d'exclusion

définir la liste d'exclusion=
pour %%# dans (
accéder
exceller
OneNote
perspectives
PowerPoint
projet
éditeur
vision
mot
Lync
Outlook pour Windows
OneDrive
équipes
) faire (
si /i "!%%#_st!"=="Off" si la liste d'exclusion est définie (définir la liste d'exclusion=!excludelist!,%%#) sinon (définir la liste d'exclusion=,%%#)
)
quitter /b

:=================================================================================================================================================

:: Commande finale pour modifier/ajouter une édition

:oe_editionchangefinal

cls
si le mode terminal n'est pas défini, 105, 32

:: Vérifier la présence de Project et Visio avec une langue non prise en charge

définir projvis=
définir langmatched=
echo: %Project_st% %Visio_st% | find /i "ON" %nul% && set projvis=1
echo: %targetedition% | findstr /i "Project Visio" %nul% && set projvis=1

si défini projvis (
pour %%# dans (
ar-sa
cs-cz
da-dk
de-de
el-gr
en-us
es-es
fi-fi
fr-fr
he-il
hu-hu
ça-ça
ja-jp
ko-kr
nb-non
nl-nl
pl-pl
pt-br
pt-pt
roulier
ru-ru
sk-sk
sl-si
sv-se
tr-tr
Royaume-Uni-UA
zh-cn
zh-tw
) faire (
si /i "%_lang%"="%%#" définir langmatched=1
)
si non défini langmatched (
%eline%
La langue %_lang% n'est pas disponible pour les applications Project/Visio.
appel :dk_color %Blue% "Installer Office dans la langue prise en charge pour Project/Visio à partir de l'URL ci-dessous."
définir les correctifs=%fixes% %mas%genuine-installation-media
appel :dk_color %_Yellow% "%mas%genuine-installation-media"
aller à :oe_goback
)
)

:: Merci à @abbodi1406 d'avoir découvert en premier les utilisations d'OfficeClickToRun.exe
:: Merci à @may pour la suggestion de l'utiliser pour changer d'édition avec un CDN comme source
:: OfficeClickToRun.exe avec la méthode productstoadd est utilisé ici pour ajouter des éditions.
:: Il utilise des mises à jour delta, ce qui signifie que, puisqu'il utilise la même version installée, il consommera très peu de données Internet.

appel :oe_getlangs

définir "c2rcommand="%_c2rExe%" platform=%_oArch% culture=%_lang% productstoadd=%targetedition%.16_%_allLangs% cdnbaseurl.16=http://officecdn.microsoft.com/pr/%_updch% baseurl.16=http://officecdn.microsoft.com/pr/%_updch% version.16=%_version% mediatype.16=CDN sourcetype.16=CDN deliverymechanism=%_updch% %targetedition%.excludedapps.16=groove%excludelist% flt.useteamsaddon=disabled flt.usebingaddononinstall=disabled flt.usebingaddononupdate=disabled"

si %change%==1 (
définir "c2rcommand=!c2rcommand! productstoremove=TousLesProduits"
)

écho:
Exécution de la commande ci-dessous, veuillez patienter...
écho:
écho %c2rcommand%
%c2rcommand%
définir le code d'erreur=%niveau d'erreur%
délai d'attente dépassé /t 10 %nul%

écho:
définir suggestchannel=

si %errorcode% EQU 0 (
si %change%==1 (
echo %targetedition% | find /i "2019Volume" %nul% && (
Si ltsc19 n'est pas défini, définissez suggestchannel=Production::LTSC
si /i n'est pas %_AudienceData%==Production::LTSC définir suggestchannel=Production::LTSC
if /i not %_updch%==F2E724C1-748F-4B47-8FB8-8E0D210E9208 set suggestchannel=Production::LTSC
)

echo %targetedition% | find /i "2021Volume" %nul% && (
Si ltsc21 n'est pas défini, définissez suggestchannel=Production::LTSC2021
if /i not %_AudienceData%==Production::LTSC2021 set suggestchannel=Production::LTSC2021
if /i not %_updch%==5030841D-C919-4594-8D2D-84AE4F96E58E set suggestchannel=Production::LTSC2021
)

echo %targetedition% | find /i "2024Volume" %nul% && (
Si ltsc24 n'est pas défini, définissez suggestchannel=Production::LTSC2024
if /i not %_AudienceData%==Production::LTSC2024 set suggestchannel=Production::LTSC2024
if /i not %_updch%==7983BAC0-E531-40CF-BE00-FD24FE66619C set suggestchannel=Production::LTSC2024
)

echo %targetedition% | findstr /R "20.*Volume" %nul% || (
Si ltscfound est défini, suggérer le canal Production::CC
echo %_AudienceData% | find /i "LTSC" %nul% && set suggestchannel=Production::CC
)

si défini suggestchannel (
appel :dk_color %Gray% "Incompatibilité détectée entre le canal de mise à jour et le produit installé."
appel :dk_color %Blue% "Il est recommandé de changer le canal de mise à jour en [!suggestchannel!] à partir du menu précédent."
)
écho:
)
appel :dk_color %Gray% "Pour activer Office, exécutez l'option d'activation depuis le menu principal."
) autre (
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)

appel :oe_tempcleanup
aller à :oe_goback

:=================================================================================================================================================

:: Édition Office

:oe_editedition

cls
Titre : Ajouter/Supprimer des applications %masver%

appel :oe_chkinternet
si non défini _int (
aller à :oe_goback
)

définir change=0
définir editedition=1
appel :ch_getinfo
cls

si le terminal n'est pas défini (
mode 98, 35
)

définir inpt=
définir le compteur à 0
définir vérifié=0
définir la cible=

%doubler%
écho:
appel :dk_color %Gray% "Vous pouvez modifier [ajouter/supprimer des applications] l'une des éditions Office suivantes."
%doubler%
écho:

pour %%A dans (%_oIds%) faire (
définir /un compteur+=1
écho [!compteur!] %%A
définir la cible!compteur!=%%A
)

%doubler%
écho:
echo [0] Retour
écho:
appel :dk_color %_Green% "Entrez un numéro d'option à l'aide de votre clavier et appuyez sur Entrée pour confirmer :"
définir /p inpt=
si "%inpt%"="" aller à :oe_editedition
si "%inpt%"=="0" aller à :oemenu
pour /l %%i dans (1,1,%counter%) faire (si "%inpt%"=="%%i" définir verified=1)
définir la cible=!targetedition%inpt%!
si %verified%==0 aller à :oe_editedition

::===============

cls
si le mode terminal n'est pas défini, 98, 32

echo %targetedition% | findstr /i "Access Excel OneNote Outlook PowerPoint Project Publisher Skype Visio Word" %nul% && (set list=SingleApps) || (set list=Suites)
aller à :oe_excludeappspre

:=================================================================================================================================================

:: Supprimer les éditions Office

:oe_supprimer

Supprimer les éditions Office %masver%

appel :ch_getinfo

cls
si le terminal n'est pas défini (
mode 98, 35
)

définir le compteur à 0
pour %%A dans (%_oIds%) faire (définir /a compteur+=1)

si !compteur! LEQ 1 (
écho:
echo Seul le produit "%_oIds%" est installé.
Cette option n'est disponible que lorsque plusieurs produits sont installés.
aller à :oe_goback
)

::===============

définir inpt=
définir le compteur à 0
définir vérifié=0
définir la cible=

%doubler%
écho:
appel :dk_color %Gray% "Vous pouvez désinstaller l'une des éditions Office suivantes."
%doubler%
écho:

pour %%A dans (%_oIds%) faire (
définir /un compteur+=1
écho [!compteur!] %%A
définir la cible!compteur!=%%A
)

%doubler%
écho:
echo [0] Retour
écho:
appel :dk_color %_Green% "Entrez un numéro d'option à l'aide de votre clavier et appuyez sur Entrée pour confirmer :"
définir /p inpt=
si "%inpt%"="" aller à :oe_removeedition
si "%inpt%"=="0" aller à :oemenu
pour /l %%i dans (1,1,%counter%) faire (si "%inpt%"=="%%i" définir verified=1)
définir la cible=!targetedition%inpt%!
Si %verified%==0, aller à :oe_removeedition

::===============

cls
si le mode terminal n'est pas défini, 105, 32

appel :oe_getlangs %targetedition%
définir "c2rcommand="%_c2rExe%" platform=%_oArch% productstoremove=%targetedition%.16_%_allLangs%"

écho:
Exécution de la commande ci-dessous, veuillez patienter...
écho:
écho %c2rcommand%
%c2rcommand%

si %errorlevel% NEQ 0 (
écho:
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)

aller à :oe_goback

:=================================================================================================================================================

:: Changer le canal de mise à jour d'Office

:oe_changeupdchnl

Titre Changer le canal de mise à jour du bureau %masver%
appel :ch_getinfo

cls
si le terminal n'est pas défini (
mode 98, 33
)

appel :oe_chkinternet
si non défini _int (
aller à :oe_goback
)

si %winbuild% LSS 10240 (
echo %_oIds% | findstr "2019 2021 2024" %nul% && (
%eline%
echo Éditions Office installées : %_oIds%
echo Une édition d'Office non prise en charge est installée sur votre version de build Windows %winbuild%.
aller à :oe_goback
)
si défini ltscfound (
%eline%
echo Canal de mise à jour Office installé : %ltsc19%%ltsc21%%ltsc24%
echo Un canal de mise à jour Office non pris en charge est installé sur votre version de build Windows %winbuild%.
aller à :oe_goback
)
)

::===============

définir inpt=
définir le compteur à 0
définir vérifié=0
définir targetFFN=
définir bypassFFN=
définir targetchannel=

%doubler%
écho:
appel :dk_color %Gray% "Canal de mise à jour installé : %_AudienceData%, %_version%, Client : %_clversion%"
appel :dk_color %Gray% "Éditions Office installées : %_oIds%"
%doubler%
écho:

pour %%# dans (
"5440fd1f-7ecb-4221-8110-145efaa6372f_Beta / Insider Fast - Insiders::DevMain -"
"64256afe-f5d9-4f86-8936-8840a6a4f5be_Current / Aperçu mensuel - Insiders::CC -"
"492350f6-3a01-4f97-b9c0-c7c6ddf67d60_Actuel / Mensuel - Production::CC -"
"55336b82-a18d-4dd6-b5f6-9e5095c314a6_Entreprise mensuelle - Production::MEC -"
"7ffbc6bf-bc32-4f92-8982-f9dd17fd3114_Entreprise semi-annuelle - Production::DC -"
"ea4a4090-de26-49d7-93c1-91bff9e53fc3_DevMain Channel - Dogfood::DevMain -"
"b61285dd-d9f7-41f2-9757-8f61cba4e9c8_Microsoft Elite - Microsoft::DevMain -"
"f2e724c1-748f-4b47-8fb8-8e0d210e9208_Perpetual2019 VL - Production::LTSC -"
"1d2d2ea6-1680-4c56-ac58-a441c8c24ff9_Microsoft2019 VL - Microsoft::LTSC -"
"5030841d-c919-4594-8d2d-84ae4f96e58e_Perpetual2021 VL - Production::LTSC2021 -"
"86752282-5841-4120-ac80-db03ae6b5fdb_Microsoft2021 VL - Microsoft::LTSC2021 -"
"7983bac0-e531-40cf-be00-fd24fe66619c_Perpetual2024 VL - Production::LTSC2024 -"
"c02d8fe6-5242-4da8-972f-82ee55e00671_Microsoft2024 VL - Microsoft::LTSC2024 -"
) faire (
pour /f "tokens=1-2 delims=_" %%A dans ("%%~#") faire (
définir bypass=
ensemble pris en charge=
si %winbuild% LSS 10240 (echo %%B | findstr /i "LTSC DevMain" %nul% || set supported=1) sinon (set supported=1)
si %winbuild% GEQ 10240 (
si ltsc19 est défini, afficher %%B | trouver /i "2019 VL" %nul% || définir bypass=1
si ltsc21 est défini echo %%B | find /i "2021 VL" %nul% || set bypass=1
si ltsc24 est défini echo %%B | find /i "2024 VL" %nul% || set bypass=1
Si LTSC n'est pas défini, afficher %%B | rechercher /i "LTSC" %nul% et définir bypass=1
)
si défini pris en charge (
définir /un compteur+=1
si !compteur! LSS 10 (
si bypass défini (echo [!counter!] %%B Une méthode de changement non officielle sera utilisée) sinon (echo [!counter!] %%B)
) autre (
si bypass défini (echo [!counter!] %%B Une méthode de changement non officielle sera utilisée) sinon (echo [!counter!] %%B)
)
définir targetFFN!counter!=%%A
définir targetchannel!counter!=%%B
Si la fonction bypass est définie, définissez bypassFFN=!bypassFFN!%%A
)
)
)

%doubler%
écho:
echo [R] En savoir plus sur les canaux de mise à jour
echo [0] Retour
écho:
appel :dk_color %_Green% "Entrez un numéro d'option à l'aide de votre clavier et appuyez sur Entrée pour confirmer :"
définir /p inpt=
si "%inpt%"="" aller à :oe_changeupdchnl
si "%inpt%"=="0" aller à :oemenu
si /i "%inpt%"=="R" démarrez https://learn.microsoft.com/en-us/microsoft-365-apps/updates/overview-update-channels & allez à :oe_changeupdchnl
pour /l %%i dans (1,1,%counter%) faire (si "%inpt%"=="%%i" définir verified=1)
définir targetFFN=!targetFFN%inpt%!
définir targetchannel=!targetchannel%inpt%!
si %verified%==0 aller à :oe_changeupdchnl

::=======================

cls
si le mode terminal n'est pas défini, 105, 32

:: Obtenir le numéro de build du FFN cible. L'utilisation de ce numéro de build avec la commande OfficeC2RClient.exe pour déclencher les mises à jour fournit des résultats précis.

définir la construction=
for /f "delims=" %%a in ('%psc% "$f=[IO.File]::ReadAllText('!_batp!') -split ':getbuild\:.*';. ([scriptblock]::Create($f[1]))" %nul6%') do (set build=%%a)
echo "%build%" | find /i "16." %nul% || set build=

écho:
for /f "tokens=1 delims=-" %%A in ("%targetchannel%") do (echo Target update channel: %%A)
echo Numéro de build cible : %build%
echo: %bypassFFN% | find /i "%targetFFN%" %nul% && goto :oe_changeunoff

appel :oe_cleanupreg

si non défini construire (
if %winbuild% GEQ 9200 call :dk_color %Gray% "Échec de la détection du numéro de build pour la cible FFN."
définir "updcommand="%_c2rCexe%" /mise à jour de l'utilisateur"
) autre (
définir "updcommand="%_c2rCexe%" /update user updatetoversion=%build%"
)
echo Exécution de la commande ci-dessous pour déclencher les mises à jour...
écho:
echo %updcommand%
%updcommand%
écho:
echo Consultez cette page Web pour obtenir de l'aide - %mas%troubleshoot
aller à :oe_goback

::=======================

:: Méthode non officielle pour changer de chaîne

:oe_changeunoff

définir abortchange=
echo %targetchannel% | find /i "2019 VL" %nul% && (for %%A in (%_oIds%) do (echo %%A | find /i "2019Volume" %nul% || set abortchange=1))
echo %targetchannel% | find /i "2021 VL" %nul% && (for %%A in (%_oIds%) do (echo %%A | find /i "2021Volume" %nul% || set abortchange=1))
echo %targetchannel% | find /i "2024 VL" %nul% && (for %%A in (%_oIds%) do (echo %%A | find /i "2024Volume" %nul% || set abortchange=1))

si défini annuler le changement (
%eline%
Incompatibilité détectée entre les produits Office installés et le canal de mise à jour cible. Annulation…
Les produits Office non perpétuels ne sont pas pris en charge par les canaux de mise à jour des licences en volume perpétuelles.
aller à :oe_goback
)

si non défini construire (
%eline%
appel :dk_color %Red% "Échec de la détection du numéro de build pour la cible FFN."
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à :oe_goback
)

définir buildchk=0
for /f "tokens=3 delims=." %%a in ("%build%") do set "buildchk=%%a"

appel :oe_getlangs %_firstoId%

echo %targetchannel% | find /i "2019 VL" %nul% && (
pour %%A dans (en-gb es-mx fr-ca) faire (
echo %_allLangs% | find /i "%%A" %nul% && (
%eline%
La langue [%%A] n'est pas prise en charge sur le canal de mise à jour de la licence en volume perpétuelle d'Office 2019. Abandon…
aller à :oe_goback
)
)
)

définir "c2rcommand="%_c2rExe%" platform=%_oArch% culture=%_lang% productstoadd=%_firstoId%.16_%_allLangs% cdnbaseurl.16=http://officecdn.microsoft.com/pr/%targetFFN% baseurl.16=http://officecdn.microsoft.com/pr/%targetFFN% version.16=%build% mediatype.16=CDN sourcetype.16=CDN deliverymechanism=%targetFFN% %_firstoId%.excludedapps.16=%_firstoIdExcludelist% flt.useteamsaddon=disabled flt.usebingaddononinstall=disabled flt.usebingaddononupdate=disabled"
définir "c2rclientupdate=!c2rcommand! scenario=CLIENTUPDATE"

si %clverchk% LSS %buildchk% (
écho:
appel :dk_color %Blue% "Ne pas interrompre l'opération avant qu'elle ne soit terminée..."
écho:
Mise à jour du client Office C2R avec la commande ci-dessous, veuillez patienter…
écho:
écho %c2rclientupdate%
%c2rclientupdate%
pour /l %%i dans (1,1,30) faire (si !clverchk! LSS %buildchk% (appeler :ch_getinfo&timeout /t 10 %nul%))
)

si %clverchk% LSS %buildchk% (
écho:
appel :dk_color %Red% "Échec de la mise à jour du client Office C2R. Abandon..."
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
aller à :oe_goback
)

appel :oe_cleanupreg

Exécution de la commande ci-dessous pour changer le canal de mise à jour, veuillez patienter...
écho:
écho %c2rcommand%
%c2rcommand%
définir le code d'erreur=%niveau d'erreur%
délai d'attente dépassé /t 10 %nul%

écho:
si %errorcode% EQU 0 (
appel :dk_color %Gray% "Maintenant, exécutez l'option d'activation d'Office depuis le menu principal."
) autre (
définir les correctifs=%fixes% %mas%dépannage
appel :dk_color2 %Blue% "Consultez cette page Web pour obtenir de l'aide - " %_Yellow% " %mas%troubleshoot"
)

:=================================================================================================================================================

:oe_retour

appel :oe_tempcleanup

écho:
si des correctifs définis (
appel :dk_color %White% "Suivez TOUTES les lignes bleues CI-DESSUS."
appel :dk_color2 %Bleu% "Appuyez sur [1] pour ouvrir la page Web d'assistance " %Gris% "Appuyez sur [0] pour ignorer"
choix /C:10 /N
Si !errorlevel!==2, allez à :oemenu
si !errorlevel!==1 (démarrer %selfgit% & démarrer %github% & pour %%# dans (%fixes%) faire (démarrer %%#))
)

si terminal défini (
appel :dk_color %_Yellow% "Appuyez sur la touche [0] pour revenir en arrière..."
choix /c 0 /n
) autre (
appel :dk_color %_Yellow% "Appuyez sur une touche pour revenir en arrière..."
pause %nul1%
)
aller à :oemenu

:=================================================================================================================================================

:oe_cleanupreg

:: Nettoyage des entrées de registre liées aux mises à jour d'Office, grâce à @abbodi1406
:: https://techcommunity.microsoft.com/t5/office-365-blog/how-to-manage-office-365-proplus-channels-for-it-pros/ba-p/795813
:: https://learn.microsoft.com/en-us/microsoft-365-apps/updates/change-update-channels#considerations-when-changing-channels

écho:
Mise à jour des clés de registre de l'écho Cleaning Office...
ajout d'un nouveau canal de mise à jour aux clés de registre...
écho:

%nul% reg add %o16c2r_reg%\Configuration /v CDNBaseUrl /t REG_SZ /d "https://officecdn.microsoft.com/pr/%targetFFN%" /f
%nul% reg add %o16c2r_reg%\Configuration /v UpdateChannel /t REG_SZ /d "https://officecdn.microsoft.com/pr/%targetFFN%" /f
%nul% reg add %o16c2r_reg%\Configuration /v UpdateChannelChanged /t REG_SZ /d "True" /f
%nul% reg supprimer %o16c2r_reg%\Configuration /v UnmanagedUpdateURL /f
%nul% reg supprimer %o16c2r_reg%\Configuration /v UpdateUrl /f
%nul% reg supprimer %o16c2r_reg%\Configuration /v UpdatePath /f
%nul% reg delete %o16c2r_reg%\Configuration /v UpdateToVersion /f
%nul% reg delete %o16c2r_reg%\Updates /v UpdateToVersion /f
%nul% reg delete HKLM\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate /f
%nul% reg delete HKLM\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate /f /reg:32
%nul% reg delete HKCU\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate /f
%nul% reg delete HKLM\SOFTWARE\Policies\Microsoft\cloud\office\16.0\Common\officeupdate /f
%nul% reg delete HKLM\SOFTWARE\Policies\Microsoft\cloud\office\16.0\Common\officeupdate /f /reg:32
%nul% reg delete HKCU\Software\Policies\Microsoft\cloud\office\16.0\Common\officeupdate /f

quitter /b

:=================================================================================================================================================

:oe_nettoyage_temp

supprimer %SystemRoot%\Temp\%o_randguid%\SingleApps_Volume.txt %nul%
supprimer %SystemRoot%\Temp\%o_randguid%\SingleApps_Retail.txt %nul%
supprimer %SystemRoot%\Temp\%o_randguid%\Suites_Volume.txt %nul%
supprimer %SystemRoot%\Temp\%o_randguid%\Suites_Retail.txt %nul%
del %SystemRoot%\Temp\%o_randguid%\getAppIds.txt %nul%
quitter /b

:=================================================================================================================================================

:: Récupérer les informations requises

:ch_getinfo

définir _oRoot=
définir _oArch=
définir _updch=
définir _oIds=
définir _firstoId=
définir _lang=
définir _cfolder=
définir _version=
définir _clversion=
définir _AudienceData=
définir _actconfig=
définir _c2rXml=
définir _c2rExe=
définir _c2rCexe=
définir _masterxml=
définir ltsc19=
définir ltsc21=
définir ltsc24=
définir ltscfound=

for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg% /v InstallPath" %nul6%') do (set "_oRoot=%%b\root")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v Platform" %nul6%') do (set "_oArch=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v ClientFolder" %nul6%') do (set "_cfolder=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v AudienceId" %nul6%') do (set "_updch=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v ClientCulture" %nul6%') do (set "_lang=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v ClientVersionToReport" %nul6%') do (set "_clversion=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v VersionToReport" %nul6%') do (set "_version=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v AudienceData" %nul6%') do (set "_AudienceData=%%b")
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\ProductReleaseIDs /v ActiveConfiguration" %nul6%') do (set "_actconfig=%%b")

echo "%o16c2r_reg%" | find /i "Wow6432Node" %nul1% && (set _tok=9) || (set _tok=8)
pour /f "tokens=%_tok% delims=\" %%a dans ('reg query "%o16c2r_reg%\ProductReleaseIDs\%_actconfig%" /f ".16" /k %nul6% ^| findstr /i "Retail Volume"') faire (
si _oIds est défini (définir "_oIds=!_oIds! %%a") sinon (définir "_oIds=%%a")
)
définir _oIds=%_oIds:.16=%
pour /f "tokens=1" %%A dans ("%_oIds%") faire définir _firstoId=%%A
for /f "skip=2 tokens=2*" %%a in ('"reg query %o16c2r_reg%\Configuration /v %_firstoId%.ExcludedApps" %nul6%') do (set "_firstoIdExcludelist=%%b")

définir verchk=0
définir clverchk=0
for /f "tokens=3 delims=." %%a in ("%_version%") do set "verchk=%%a"
for /f "tokens=3 delims=." %%a in ("%_clversion%") do set "clverchk=%%a"

Si le fichier "%_oRoot%\Licenses16\c2rpridslicensefiles_auto.xml" existe, définissez "_c2rXml=%_oRoot%\Licenses16\c2rpridslicensefiles_auto.xml"

si le fichier "%ProgramData%\Microsoft\ClickToRun\ProductReleases\%_actconfig%\x-none.16\MasterDescriptor.x-none.xml" existe (
définir "_masterxml=%ProgramData%\Microsoft\ClickToRun\ProductReleases\%_actconfig%\x-none.16\MasterDescriptor.x-none.xml"
)

si le fichier "%_cfolder%\OfficeClickToRun.exe" existe (
définir "_c2rExe=%_cfolder%\OfficeClickToRun.exe"
)

si le fichier "%_cfolder%\OfficeC2RClient.exe" existe (
définir "_c2rCexe=%_cfolder%\OfficeC2RClient.exe"
)

:: Vérifier les fichiers de version LTSC

pour /f "skip=2 tokens=2*" %%a dans ('"reg query %o16c2r_reg%\ProductReleaseIDs\%_actconfig%" /s %nul6%') faire (
echo "%%b" %nul2% | findstr "16.0.103 16.0.104 16.0.105" %nul% && set ltsc19=LTSC
echo "%%b" %nul2% | findstr "16.0.14332" %nul% && set ltsc21=LTSC2021
echo "%%b" %nul2% | findstr "16.0.17932" %nul% && set ltsc24=LTSC2024
)

si ce n'est pas "%ltsc19%%ltsc21%%ltsc24%"="" définir ltscfound=1

quitter /b

:=================================================================================================================================================

:: Vérifier toutes les langues installées

:oe_getlangs

si "%1"="" (
définir langreg=culture
) autre (
définir langreg=%1.16
)

définir _allLangs=
echo "%o16c2r_reg%" | find /i "Wow6432Node" %nul1% && (set _tok=10) || (set _tok=9)
pour /f "tokens=%_tok% delims=\" %%a dans ('reg query "%o16c2r_reg%\ProductReleaseIDs\%_actconfig%\%langreg%" /f "-" /k ^| findstr /i "%langreg%\\.*-.*"') faire (
si défini _allLangs (set "_allLangs=!_allLangs!_%%a") sinon (set "_allLangs=%%a")
)

définir _allLangs=%_allLangs:.16=%
quitter /b

:=================================================================================================================================================

:: Vérifier la connexion Internet

:oe_chkinternet

définir _int=
pour %%a dans (l.root-servers.net resolver1.opendns.com download.windowsupdate.com google.com) faire si non défini _int (
for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%a') do (if not "%%#"=="" set _int=1)
)

si non défini _int (
%psc% "Si([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet){Exit 0}Else{Exit 1}"
si !errorlevel!==0 (définir _int=1)
)

si non défini _int (
%eline%
appel :dk_color %Red% "Internet non connecté."
appel :dk_color %Blue% "Internet est requis pour cette opération."
)
quitter /b

:=================================================================================================================================================

:: Obtenir le numéro de build disponible pour un FFN

:getbuild:
$Tls12 = [Enum]::ToObject([System.Net.SecurityProtocolType], 3072)
[System.Net.ServicePointManager]::SecurityProtocol = $Tls12

$FFN = $env:targetFFN
$windowsBuild = [System.Environment]::OSVersion.Version.Build

$baseUrl = "https://mrodevicemgr.officeapps.live.com/mrodevicemgrsvc/api/v2/C2RReleaseData?audienceFFN=$FFN"
$url = if ($windowsBuild -lt 9200) { "$baseUrl&osver=Client|6.1" } elseif ($windowsBuild -lt 10240) { "$baseUrl&osver=Client|6.3" } else { $baseUrl }

$response = if ($windowsBuild -ge 9200) { irm -Uri $url -Method Get } else { (New-Object System.Net.WebClient).DownloadString($url) }

si ($windowsBuild -lt 9200) {
    if ($response -match '"AvailableBuild"\s*:\s*"([^"]+)"') { Write-Host $matches[1] }
} autre {
    Écrire-Hôte $response.AvailableBuild
}
:getbuild:

:=================================================================================================================================================

:: Récupérer la liste des éditions disponibles à partir de c2rpridslicensefiles_auto.xml
:: et filtrez la liste à l'aide de MasterDescriptor.x-none.xml
:: et exclure les produits non pris en charge sous Windows 7/8/8.1

:getlist:
$xmlPath1 = $env:_c2rXml
$xmlPath2 = $env:_masterxml
$outputDir = $env:SystemRoot + "\Temp\$env:o_randguid\"
$buildNumber = [System.Environment]::OSVersion.Version.Build
$excludedKeywords = @("2019", "2021", "2024")
$productReleaseIds = @()

si (Test-Path $xmlPath1) {
    $xml1 = New-Object -TypeName System.Xml.XmlDocument
    $xml1.Charger($xmlPath1)
    foreach ($node in $xml1.SelectNodes("//ProductReleaseId")) {
        $id = $node.GetAttribute("id")
        $exclude = $false
        si ($buildNumber -lt 10240) {
            pour chaque ($keyword dans $excludedKeywords) {
                si ($id -match $keyword) { $exclude = $true; break }
            }
        }
        si ($id -ne "CommonLicenseFiles" -et -not $exclude) { $productReleaseIds += $id }
    }
}

$catégories = @{
    "Suites_Retail" = @(); "Suites_Volume" = @()
    "SingleApps_Retail" = @(); "SingleApps_Volume" = @()
}

pour chaque ($id dans $productReleaseIds) {
    $category = if ($id -match "Retail") { "Retail" } else { "Volume" }
    $categories["SingleApps_$category"] += $id
}

si (Test-Path $xmlPath2) {
    $xml2 = New-Object -TypeName System.Xml.XmlDocument
    $xml2.Charger($xmlPath2)
    foreach ($sku in $xml2.SelectNodes("//SKU")) {
        $skuId = $sku.GetAttribute("ID")
        si ($productReleaseIds -contient $skuId) {
            $appIds = $sku.SelectNodes("Apps/App") | ForEach-Object { $_.GetAttribute("id") }
            si ($appIds contient "Excel" et $appIds contient "Word") {
                $category = if ($skuId -match "Retail") { "Retail" } else { "Volume" }
                $categories["Suites_$category"] += $skuId
                $categories["SingleApps_$category"] = $categories["SingleApps_$category"] | Where-Object { $_ -ne $skuId }
            }
        }
    }
}

foreach ($section in $categories.Keys) {
    $filePath = Join-Path -Path $outputDir -ChildPath "$section.txt"
    $ids = $categories[$section]
    si ($ids.Count -gt 0) { $ids | Out-File -FilePath $filePath -Encoding ASCII }
}
:getlist:

:=================================================================================================================================================

:: Obtenir la liste des applications pour un ID de produit spécifique à l'aide du fichier MasterDescriptor.x-none.xml

:getappnames:
$xmlPath = $env:_masterxml
$targetSkuId = $env:targetedition
$outputDir = $env:SystemRoot + "\Temp\$env:o_randguid\"
$outputFile = Join-Path -Path $outputDir -ChildPath "getAppIds.txt"
$excludeIds = @("shared", "PowerPivot", "PowerView", "MondoOnly", "OSM", "OSMUX", "Groove", "DCF")

$xml = New-Object -TypeName System.Xml.XmlDocument
$xml.Charger($xmlPath)

$appIdsList = @()
$skuNodes = $xml.SelectNodes("//SKU[@ID='$targetSkuId']")

pour chaque ($skuNode dans $skuNodes) {
    foreach ($app in $skuNode.SelectNodes("Apps/App")) {
        $appId = $app.GetAttribute("id")
        si ($excludeIds -ne contient pas $appId) {
            $appIdsList += $appId
        }
    }
}

si ($appIdsList.Count -gt 0) {
    $appIdsList | Out-File -FilePath $outputFile -Encoding ASCII
}
:getappnames:

:=================================================================================================================================================
::
:: Laissez une ligne vide ci-dessous
