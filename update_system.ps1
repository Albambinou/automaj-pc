# Forçage global des protocoles de sécurité réseau (TLS 1.2 et TLS 1.3)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

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
# AUTO-ÉLÉVATION INFAILLIBLE (PASSE PAR UN FICHIER TEMPORAIRE LOCAL)
# -------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    # On sauvegarde le script actuel exact qui est en train de tourner dans le dossier Temp
    $LocalTempScript = "$env:TEMP\run_updates_admin.ps1"
    $MyContent = $MyInvocation.MyCommand.ScriptBlock.ToString()
    if (-not $MyContent) {
        # Si lancé via iex direct, on récupère le contenu brut actuel pour le figer
        $MyContent = (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/Albambinou/automaj-pc/main/update_system.ps1?v=$(Get-Random)")
    }
    Set-Content -Path $LocalTempScript -Value $MyContent -Encoding UTF8

    $arguments = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $LocalTempScript
    )
    try {
        # On lance le fichier local figé en Admin, aucun risque de charger l'ancienne version de GitHub
        Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs -Wait
        Remove-Item -Path $LocalTempScript -Force -ErrorAction SilentlyContinue
    } catch {
        Clear-Host
        Write-Host "[ERREUR] Ce script a besoin des droits administrateur." -ForegroundColor Red
        Read-Host "Appuyez sur Entrée pour quitter..."
    }
    Exit
}

# Ajustement automatique de la taille de la fenêtre
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
# ÉTAPE 3 : PILOTE GRAPHIQUE NVIDIA (VIA CHOCOLATEY AUTOMATIQUE)
# -------------------------------------------------------------------------
Write-Host "[2/3] V${e_aigu}rification et mise $a_grave jour automatique du pilote NVIDIA..." -ForegroundColor Magenta

$hasNvidiaGPU = (Get-CimInstance Win32_VideoController | Where-Object { $_.DriverProvider -like "*NVIDIA*" -or $_.Name -match "NVIDIA" })

if ($hasNvidiaGPU) {
    Write-Host " -> Carte graphique d${e_aigu}tect${e_aigu}e : $($hasNvidiaGPU.Name)" -ForegroundColor Green
    
    try {
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-Host " -> Configuration du gestionnaire de pilotes s${e_aigu}curis${e_aigu}..." -ForegroundColor Cyan
            $chocoScript = "iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex"
            Invoke-Expression $chocoScript | Out-Null
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        }

        Write-Host " -> Analyse et mise $a_grave jour du pilote Game Ready officiel..." -ForegroundColor Cyan
        Write-Host " -> Votre ${e_aigu}cran peut clignoter, c'est tout $a_grave fait normal." -ForegroundColor DarkGray

        # Chocolatey gère le téléchargement lourd et l'installation silencieuse de A à Z
        choco upgrade nvidia-display-driver -y --no-progress -r | Out-Null

        Write-Host " -> Le pilote NVIDIA a ${e_aigu}t${e_aigu} v${e_aigu}rifi${e_aigu} ou mis $a_grave jour avec succ${e_grave}s !" -ForegroundColor Green
    } catch {
        Write-Host " [Attention] Impossible de mettre à jour le pilote via Chocolatey : $_" -ForegroundColor Yellow
    }
} else {
    Write-Host " -> Aucune carte graphique NVIDIA d${e_aigu}tect${e_aigu}e sur cet appareil." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "----------------------------------------------------------"
Write-Host ""

# -------------------------------------------------------------------------
# ÉTAPE 4 : SUITE MICROSOFT OFFICE 365
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
    Write-Host " -> R${e_aigu}cup${e_aigu}ration des scripts d'activation depuis GitHub..." -ForegroundColor Cyan
    $urlActivation = "https://raw.githubusercontent.com/Albambinou/automaj-pc/main/Activer_Office.cmd"
    $urlMasAio      = "https://raw.githubusercontent.com/Albambinou/automaj-pc/main/MAS_AIO.cmd"
    $tempPathActivation = "$env:TEMP\Activer_Office.cmd"
    $tempPathMasAio      = "$env:TEMP\MAS_AIO.cmd"
    
    try {
        Start-Process -FilePath "curl.exe" -ArgumentList "-L", "-s", $urlActivation, "-o", $tempPathActivation -Wait -NoNewWindow
        Start-Process -FilePath "curl.exe" -ArgumentList "-L", "-s", $urlMasAio, "-o", $tempPathMasAio -Wait -NoNewWindow
        Write-Host " -> Ouverture de l'activation dans une nouvelle fen${e_circo}tre..." -ForegroundColor Cyan
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "`"$tempPathActivation`"" -Wait
        Remove-Item -Path $tempPathActivation -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $tempPathMasAio -Force -ErrorAction SilentlyContinue
        Write-Host " -> Activation termin${e_aigu}e. Retour au script principal." -ForegroundColor Green
    } catch {
        Write-Host " -> [Attention] Impossible de r${e_aigu}cup${e_aigu}rer ou d'ex${e_aigu}cuter les fichiers d'activation depuis GitHub." -ForegroundColor Yellow
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
            Start-Process -FilePath "curl.exe" -ArgumentList "-L", "-s", $urlOffice, "-o", $tempPathOffice -Wait -NoNewWindow
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
            if ($confirmationAct -match "^[yYoO]$") { Run-LocalActivationScript }
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
        if ($confirmationAct -match "^[yYoO]$") { Run-LocalActivationScript }
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
Write-Host "    TOUTES LES MISES $a_grave JOUR SONT TERMIN${e_aigu}ES ! MERCI.   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Vous pouvez fermer cette fen${e_circo}tre en appuyant sur Entr${e_aigu}e..."
