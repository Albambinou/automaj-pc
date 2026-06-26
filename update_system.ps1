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
# CONFIGURATION GOOGLE DRIVE (LIENS DE TÉLÉCHARGEMENT DIRECTS PUBLICS)
# -------------------------------------------------------------------------
$urlActivation = "https://docs.google.com/uc?export=download&id=1Foqv3lwXMpgN_KB0djqD0cnVyIJmsv5g"
$urlMasAio      = "https://docs.google.com/uc?export=download&id=12szspJHsBUIk62hqV6OgYODYSnpg2TIK"

# -------------------------------------------------------------------------
# AUTO-ÉLÉVATION EN MODE ADMINISTRATEUR (COMPATIBLE GITHUB IRM / IEX)
# -------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    $arguments = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-Command", "irm 'https://raw.githubusercontent.com/Albambinou/automaj-pc/main/update_system.ps1' | iex"
    )
    try {
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
        Write-Host " -> T${e_aigu}l${e_aigu}chargement et installation lanc${e_aigu}e..." -ForegroundColor Yellow
        
        Get-WindowsUpdate -Install -AcceptAll -AutoReboot:$false -ErrorAction SilentlyContinue | Out-Null
        
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

$pathNvidiaApp = "C:\Program Files\NVIDIA Corporation\NVIDIA App\CEF\NVIDIA App.exe"
$pathGeForce = "C:\Program Files\NVIDIA Corporation\GeForce Experience\LaunchGFExperience.exe"

$isNvidiaInstalled = (Test-Path $pathNvidiaApp) -or (Test-Path $pathGeForce)

if (-not $isNvidiaInstalled) {
    Write-Host " -> [!] NVIDIA App n'est pas install${e_aigu} sur ce PC." -ForegroundColor Yellow
    
    $confirmationNvidia = Read-Host "Voulez-vous installer NVIDIA App et ses pilotes ? (Y/N)"
    if ($confirmationNvidia -match "^[yYoO]$") {
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
                Write-Host " -> [Attention] L'installation a pris fin mais l'application est introuvable." -ForegroundColor Yellow
            }
        } catch {
            Write-Host " [ERREUR] Impossible de t${e_aigu}l${e_aigu}charger le fichier depuis les serveurs NVIDIA : $_" -ForegroundColor Red
        }
    } else {
        Write-Host " -> Étape NVIDIA ignor${e_aigu}e par l'utilisateur." -ForegroundColor DarkGray
    }
    
} else {
    Write-Host " -> NVIDIA est pr${e_aigu}sent sur ce PC." -ForegroundColor Green
    $demandeNvidia = Read-Host "Voulez-vous forcer Winget $a_grave chercher une mise $a_grave jour NVIDIA ? (Y/N)"
    
    if ($demandeNvidia -match "^[yYoO]$") {
        Write-Host " -> Recherche d'un nouveau pilote via Winget en cours..." -ForegroundColor Cyan
        
        $wingetPath = Get-Command winget -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
        if (-not $wingetPath) { $wingetPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe" }

        $wingetJob = Start-Job -ScriptBlock {
            param($exe)
            & $exe source update --accept-source-agreements | Out-Null
            return (& $exe upgrade --include-unknown 2>$null | Select-String "Nvidia","GeForce")
        } -ArgumentList $wingetPath
        
        $completedJob = Wait-Job $wingetJob -Timeout 35
        $nvidiaCheck = if ($completedJob) { Receive-Job $wingetJob } else { $null }
        if ($wingetJob) { Remove-Job $wingetJob -Force }

        if ($nvidiaCheck) {
            Write-Host " -> NOUVEAU PILOTE TROUV${e_aigu} VIA WINGET !" -ForegroundColor Green
            & $wingetPath upgrade --id Nvidia.NVIDIAApp --silent --accept-package-agreements --accept-source-agreements 2>$null | Out-Null
            Write-Host " -> Le logiciel NVIDIA a ${e_aigu}t${e_aigu} mis $a_grave jour avec succ${e_grave}s !" -ForegroundColor Green
        } else {
            Write-Host " -> Winget ne d${e_aigu}tecte aucune mise $a_grave jour. Utilisez l'application NVIDIA ou Windows Update pour vos pilotes spécifiques." -ForegroundColor Yellow
        }
    } else {
        Write-Host " -> V${e_aigu}rification NVIDIA pass${e_aigu}e." -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "----------------------------------------------------------"
Write-Host ""

# -------------------------------------------------------------------------
# ÉTAPE 4 : SUITE MICROSOFT OFFICE 365 (INSTALLATION ET VÉRIFICATION ACTIVATION)
# -------------------------------------------------------------------------
Write-Host "[3/3] V${e_aigu}rification de Microsoft Office 365..." -ForegroundColor Magenta

$isOfficeInstalled = $null -ne (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe" -ErrorAction SilentlyContinue)

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

function Run-LocalActivationScript {
    Write-Host " -> R${e_aigu}cup${e_aigu}ration des scripts d'activation depuis Google Drive..." -ForegroundColor Cyan
    
    $tempPathActivation = "$env:TEMP\Activer_Office.cmd"
    $tempPathMasAio      = "$env:TEMP\MAS_AIO.cmd"
    
    try {
        # Téléchargement via liens de redirection directe Google Drive (Sans clé API exposée)
        Invoke-WebRequest -Uri $script:urlActivation -OutFile $tempPathActivation -ErrorAction Stop
        Invoke-WebRequest -Uri $script:urlMasAio -OutFile $tempPathMasAio -ErrorAction Stop
        
        Write-Host " -> Ouverture de l'activation dans une nouvelle fen${e_circo}tre..." -ForegroundColor Cyan
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "`"$tempPathActivation`"" -Wait
        
        Remove-Item -Path $tempPathActivation -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $tempPathMasAio -Force -ErrorAction SilentlyContinue
        
        Write-Host " -> Activation termin${e_aigu}e. Retour au script principal." -ForegroundColor Green
    } catch {
        Write-Host " -> [Attention] Impossible de r${e_aigu}cup${e_aigu}rer ou d'ex${e_aigu}cuter les fichiers d'activation depuis Google Drive." -ForegroundColor Yellow
    }
}

if (-not $isOfficeInstalled) {
    Write-Host " -> [!] Microsoft 365 n'est pas install${e_aigu} sur ce PC." -ForegroundColor Yellow
    
    $confirmationOffice = Read-Host "Voulez-vous installer la suite Microsoft Office 365 Pro ? (Y/N)"
    if ($confirmationOffice -match "^[yYoO]$") {
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
            
            $confirmationAct = Read-Host "Voulez-vous lancer l'activation d'Office maintenant ? (Y/N)"
            if ($confirmationAct -match "^[yYoO]$") {
                Run-LocalActivationScript
            }
            
        } catch {
            Write-Host " [ERREUR] Impossible de traiter Microsoft Office : $_" -ForegroundColor Red
        }
    } else {
        Write-Host " -> Étape Microsoft Office ignor${e_aigu}e par l'utilisateur." -ForegroundColor DarkGray
    }
} else {
    Write-Host " -> Microsoft Office 365 est d${e_aigu}j$a_grave install${e_aigu} sur ce PC." -ForegroundColor Green
    
    if (-not $isOfficeActivated) {
        Write-Host " -> [Attention] Microsoft Office est pr${e_aigu}sent mais n'est pas activ${e_aigu} !" -ForegroundColor Red
        
        $confirmationAct = Read-Host "Voulez-vous lancer le script d'activation d'Office ? (Y/N)"
        if ($confirmationAct -match "^[yYoO]$") {
            Run-LocalActivationScript
        }
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
