# Forçage strict de l'encodage de la console en UTF-8
[console]::InputEncoding = [System.Text.Encoding]::UTF8
[console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Raccourcis universels pour les caractères accentués
$e_aigu = "$([char]233)" # é
$a_grave = "$([char]224)" # à
$e_grave = "$([char]232)" # è
$u_grave = "$([char]249)" # ù
$a_circo = "$([char]226)" # â
$e_circo = "$([char]234)" # ê
$o_circo = "$([char]244)" # ô

# -------------------------------------------------------------------------
# AUTO-ÉLÉVATION EN MODE ADMINISTRATEUR (COMPATIBLE GITHUB IRM / IEX)
# -------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    # On utilise des arguments séparés par des virgules pour éviter les conflits de guillemets
    $arguments = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-Command", "irm 'https://raw.githubusercontent.com/Albambinou/automaj-pc/main/update_system.ps1' | iex"
    )
    try {
        # Lance le nouveau processus PowerShell en tant qu'admin avec la structure propre
        Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs -ErrorAction Stop
    } catch {
        Clear-Host
        Write-Host "[ERREUR] Ce script a absolument besoin des droits administrateur pour fonctionner." -ForegroundColor Red
        Read-Host "Appuyez sur Entrée pour quitter..."
    }
    Exit
}

# Ajustement automatique de la taille de la fenêtre (Largeur: 85, Hauteur: 35)
$size = New-Object System.Management.Automation.Host.Size(85, 35)
$host.UI.RawUI.WindowSize = $size
$host.UI.RawUI.BufferSize = $size

# -------------------------------------------------------------------------
# DÉBUT DU SCRIPT PRINCIPAL
# -------------------------------------------------------------------------
Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    ASSISTANT DE MISE $a_grave JOUR AUTOMATIQUE DE VOTRE PC    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Ce script va v${e_aigu}rifier et installer vos mises $a_grave jour."
Write-Host " Ne fermez pas cette fen${e_circo}tre tant que ce n'est pas fini."
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# Détermination du dossier local où se trouve ce script
$ScriptDir = If ($PSScriptRoot) { $PSScriptRoot } Else { Get-Location }

# -------------------------------------------------------------------------
# ÉTAPE 2 : WINDOWS UPDATE
# -------------------------------------------------------------------------
Write-Host "[1/3] Recherche de mises $a_grave jour Windows Update en cours..." -ForegroundColor Magenta

if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host " -> Pr${e_aigu}paration de l'environnement (${e_aigu}tape unique)..." -ForegroundColor DarkGray
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue | Out-Null
    Install-Module -Name PSWindowsUpdate -Force -Repository PSGallery -Scope CurrentUser -AllowClobber -ErrorAction SilentlyContinue | Out-Null
}

try {
    $updates = Get-WindowsUpdate -ErrorAction Stop
    if ($updates) {
        Write-Host " -> MISE $a_grave JOUR TROUV${e_aigu}E !" -ForegroundColor Green
        Write-Host " -> T${e_aigu}l${e_aigu}chargement et installation lanc${e_aigu}e (cela peut prendre du temps)..." -ForegroundColor Yellow
        Install-WindowsUpdate -AcceptAll -Install -AutoReboot:$false -ErrorAction SilentlyContinue | Out-Null
        Write-Host " -> Mises $a_grave jour Windows install${e_aigu}es avec succ${e_grave}s !" -ForegroundColor Green
    } else {
        Write-Host " -> Votre Windows est d${e_aigu}j$a_grave $a_grave jour !" -ForegroundColor Green
    }
} catch {
    Write-Host " [Information] Windows Update est temporairement indisponible ou d${e_aigu}j$a_grave occup${e_aigu}." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "----------------------------------------------------------"
Write-Host ""

# -------------------------------------------------------------------------
# ÉTAPE 3 : PILOTE GRAPHIQUE ET APPLICATION NVIDIA
# -------------------------------------------------------------------------
Write-Host "[2/3] V${e_aigu}rification des pilotes graphique..." -ForegroundColor Magenta

# DÉTECTION PAR FICHIER
$pathNvidiaApp = "C:\Program Files\NVIDIA Corporation\NVIDIA App\CEF\NVIDIA App.exe"
$pathGeForce = "C:\Program Files\NVIDIA Corporation\GeForce Experience\LaunchGFExperience.exe"

$isNvidiaInstalled = (Test-Path $pathNvidiaApp) -or (Test-Path $pathGeForce)

if (-not $isNvidiaInstalled) {
    Write-Host " -> NVIDIA App n'est pas install${e_aigu} sur ce PC." -ForegroundColor Yellow
    Write-Host " -> T${e_aigu}l${e_aigu}chargement de l'installateur officiel NVIDIA en cours..." -ForegroundColor Cyan
    
    $urlNvidia = "https://us.download.nvidia.com/nvapp/client/11.0.7.247/NVIDIA_app_v11.0.7.247.exe"
    $tempPathNvidia = "$env:TEMP\NVIDIA_app_setup.exe"
    
    try {
        Invoke-WebRequest -Uri $urlNvidia -OutFile $tempPathNvidia -ErrorAction Stop
        
        Write-Host " -> Lancement de l'installation silencieuse..." -ForegroundColor Cyan
        Write-Host " -> Votre ${e_aigu}cran peut clignoter, c'est tout $a_grave fait normal." -ForegroundColor DarkGray
        
        Start-Process -FilePath $tempPathNvidia -ArgumentList "/s" -Wait -NoNewWindow
        Remove-Item -Path $tempPathNvidia -Force -ErrorAction SilentlyContinue
        
        if (Test-Path $pathNvidiaApp) {
            Write-Host " -> NVIDIA App et le pilote graphique ont ${e_aigu}t${e_aigu} install${e_aigu}s avec succ${e_grave}s !" -ForegroundColor Green
        } else {
            Write-Host " -> [Attention] L'installation a pris fin mais l'application est introuvable. Un red${e_aigu}marrage est peut-${e_circo}tre requis." -ForegroundColor Yellow
        }
    } catch {
        Write-Host " [ERREUR] Impossible de t${e_aigu}l${e_aigu}charger le fichier depuis les serveurs NVIDIA : $_" -ForegroundColor Red
    }
    
} else {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host " -> NVIDIA est pr${e_aigu}sent mais l'outil winget est manquant pour v${e_aigu}rifier les mises $a_grave jour du pilote." -ForegroundColor Yellow
    } else {
        Write-Host " -> NVIDIA APP est d${e_aigu}tect${e_aigu}. Recherche d'un nouveau pilote ou d'une mise $a_grave jour..." -ForegroundColor Cyan
        
        # SÉCURITÉ TIMEOUT : On lance la détection winget dans un Job en arrière-plan
        $wingetJob = Start-Job -ScriptBlock {
            winget source update --accept-source-agreements | Out-Null
            return (winget upgrade --include-unknown 2>$null | Select-String "Nvidia")
        }
        
        # On attend la fin du job pendant 30 secondes MAXIMUM
        $completedJob = Wait-Job $wingetJob -Timeout 30
        
        if ($null -eq $completedJob) {
            # Si le temps est dépassé (bloqué), on détruit le job et on passe la variable à $null
            Remove-Job $wingetJob -Force
            Write-Host " -> [Information] Recherche Winget trop longue (Serveurs Microsoft occup${e_aigu}s). Passage $a_grave la suite." -ForegroundColor Yellow
            $nvidiaCheck = $null
        } else {
            # Si le job a fini à temps, on récupère son résultat
            $nvidiaCheck = Receive-Job $wingetJob
            Remove-Job $wingetJob
        }

        if ($nvidiaCheck) {
            Write-Host " -> NOUVEAU PILOTE TROUV${e_aigu} !" -ForegroundColor Green
            Write-Host " -> T${e_aigu}l${e_aigu}chargement et mise $a_grave jour en cours..." -ForegroundColor Yellow
            Write-Host " -> Votre ${e_aigu}cran peut clignoter une ou deux fois." -ForegroundColor DarkGray
            
            # On applique également une sécurité de 2 minutes max pour l'installation silencieuse
            $installJob = Start-Job -ScriptBlock {
                winget upgrade --id Nvidia.NVIDIAApp --silent --accept-package-agreements --accept-source-agreements 2>$null | Out-Null
                winget upgrade --id Nvidia.GeForceExperience --silent --accept-package-agreements --accept-source-agreements 2>$null | Out-Null
            }
            $completedInstall = Wait-Job $installJob -Timeout 120
            Remove-Job $installJob -Force

            Write-Host " -> Le pilote NVIDIA a ${e_aigu}t${e_aigu} mis $a_grave jour ou v${e_aigu}rifi${e_aigu} avec succ${e_grave}s !" -ForegroundColor Green
        } else {
            # Si la recherche a dit "pas de mise à jour" OU si le timeout a sauté l'étape
            if ($null -ne $completedJob) {
                Write-Host " -> Votre carte graphique et vos logiciels NVIDIA sont d${e_aigu}j$a_grave $a_grave jour." -ForegroundColor Green
            }
        }
    }
}

Write-Host ""
Write-Host "----------------------------------------------------------"
Write-Host ""

# -------------------------------------------------------------------------
# ÉTAPE 4 : SUITE MICROSOFT OFFICE 365 (INSTALLATION, ATTENTE ET VÉRIFICATION ACTIVATION)
# -------------------------------------------------------------------------
Write-Host "[3/3] V${e_aigu}rification de Microsoft Office 365..." -ForegroundColor Magenta

# 1. Détection de la présence physique d'Office via le registre
$isOfficeInstalled = $null -ne (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe" -ErrorAction SilentlyContinue)

# 2. Détection robuste de l'état d'activation
$isOfficeActivated = $false
if ($isOfficeInstalled) {
    $vbsPath64 = "C:\Program Files\Microsoft Office\Office16\ospp.vbs"
    $vbsPath32 = "C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs"
    $targetVbs = if (Test-Path $vbsPath64) { $vbsPath64 } else { $vbsPath32 }

    if (Test-Path $targetVbs) {
        $licenceStatus = cscript.exe //NoLogo "$targetVbs" /dstatus 2>$null
        if ($licenceStatus -match "LICENSE STATUS:\s+---LICENSED---") {
            $isOfficeActivated = $true
        }
    } else {
        $isOfficeActivated = $true
    }
}

# Fonction pour télécharger et lancer le script d'activation depuis GitHub
function Run-LocalActivationScript {
    Write-Host " -> R${e_aigu}cup${e_aigu}ration du script d'activation depuis GitHub..." -ForegroundColor Cyan
    
    $urlActivation = "https://raw.githubusercontent.com/Albambinou/automaj-pc/refs/heads/main/Activer_Office.cmd"
    $tempPathActivation = "$env:TEMP\Activer_Office.cmd"
    
    try {
        # Téléchargement transparent du fichier .cmd de GitHub dans les fichiers temporaires du PC
        Invoke-WebRequest -Uri $urlActivation -OutFile $tempPathActivation -ErrorAction Stop
        
        Write-Host " -> Ouverture de l'activation dans une nouvelle fen${e_circo}tre..." -ForegroundColor Cyan
        
        # Lance la nouvelle fenêtre CMD, exécute le code temporaire et attend sa fermeture
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "`"$tempPathActivation`"" -Wait
        
        # Nettoyage du fichier temporaire après fermeture
        Remove-Item -Path $tempPathActivation -Force -ErrorAction SilentlyContinue
        Write-Host " -> Activation termin${e_aigu}e. Retour au script principal." -ForegroundColor Green
    } catch {
        Write-Host " -> [Attention] Impossible de t${e_aigu}l${e_aigu}charger ou d'ex${e_aigu}cuter le script d'activation depuis GitHub." -ForegroundColor Yellow
    }
}

# ACTION LOGIQUE DU SCRIPT
if (-not $isOfficeInstalled) {
    Write-Host " -> Microsoft 365 n'est pas install${e_aigu} sur ce PC." -ForegroundColor Yellow
    Write-Host " -> T${e_aigu}l${e_aigu}chargement de l'installateur officiel Office en cours..." -ForegroundColor Cyan
    
    $urlOffice = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365AppsBasicRetail&platform=x64&language=fr-fr&version=O16GA"
    $tempPathOffice = "$env:TEMP\Office365_setup.exe"
    
    try {
        Invoke-WebRequest -Uri $urlOffice -OutFile $tempPathOffice -ErrorAction Stop
        
        Write-Host " -> Lancement de l'installation d'Office 365..." -ForegroundColor Cyan
        Write-Host " -> Suivez la progression dans la fen${e_circo}tre d'installation Orange." -ForegroundColor Cyan
        
        Start-Process -FilePath $tempPathOffice -ArgumentList "SETLANG=fr-fr" -NoNewWindow
        Start-Sleep -Seconds 15
        
        while (Get-Process -Name "OfficeC2RClient" -ErrorAction SilentlyContinue) {
            Write-Host "." -NoNewline -ForegroundColor Yellow
            Start-Sleep -Seconds 10
        }
        Write-Host ""
        
        Start-Sleep -Seconds 5
        Remove-Item -Path $tempPathOffice -Force -ErrorAction SilentlyContinue
        Write-Host " -> L'installation de Microsoft Office 365 est termin${e_aigu}e !" -ForegroundColor Green
        
        Run-LocalActivationScript
        
    } catch {
        Write-Host " [ERREUR] Impossible de traiter Microsoft Office : $_" -ForegroundColor Red
    }
} else {
    Write-Host " -> Microsoft Office 365 est d${e_aigu}j$a_grave install${e_aigu} sur ce PC." -ForegroundColor Green
    
    if (-not $isOfficeActivated) {
        Write-Host " -> [Attention] Microsoft Office est pr${e_aigu}sent mais n'est pas activ${e_aigu} !" -ForegroundColor Red
        Run-LocalActivationScript
    } else {
        Write-Host " -> Licence Microsoft Office valide et activ${e_aigu}e." -ForegroundColor Green
        Write-Host " -> Recherche et application des mises $a_grave jour Office en cours..." -ForegroundColor Cyan
        $pathC2R = "C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe"
        if (Test-Path $pathC2R) {
            Start-Process -FilePath $pathC2R -ArgumentList "/update user updatetoversion=16.0 displaylevel=false forceappshutdown=false" -Wait -NoNewWindow
            Write-Host " -> Mises $a_grave jour Office trait${e_aigu}es avec succ${e_grave}s." -ForegroundColor Green
        }
    }
}

# -------------------------------------------------------------------------
# FIN DU SCRIPT
# -------------------------------------------------------------------------
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   TOUTES LES MISES $a_grave JOUR SONT TERMIN${e_aigu}ES ! MERCI.   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Vous pouvez fermer cette fen${e_circo}tre en appuyant sur Entr${e_aigu}e..."
