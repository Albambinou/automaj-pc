# Forçage global des protocoles de sécurité réseau (TLS 1.2 et TLS 1.3 sécurisé)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor 12288

# Raccourcis universels pour les caractères accentués (Infaillible)
$e_aigu = "$([char]233)" # é
$a_grave = "$([char]224)" # à
$e_grave = "$([char]232)" # è
$u_grave = "$([char]249)" # ù
$a_circo = "$([char]226)" # â
$e_circo = "$([char]234)" # ê
$o_circo = "$([char]244)" # ô

# -------------------------------------------------------------------------
# AUTO-ÉLÉVATION HYBRIDE SÉCURISÉE (GÈRE LE LOCAL ET L'EXÉCUTION EN MÉMOIRE)
# -------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Demande des droits administrateur en cours..." -ForegroundColor Yellow
    
    if ($PSCommandPath) {
        # Cas 1 : Le script est exécuté depuis un fichier .ps1 local
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    } else {
        # Cas 2 : Le script est lancé directement en mémoire (ex: via irm | iex depuis GitHub)
        $ScriptContent = $MyInvocation.MyCommand.ScriptBlock.ToString()
        if ($ScriptContent) {
            $TempFile = Join-Path $env:TEMP "update_system_temp.ps1"
            Set-Content -Path $TempFile -Value $ScriptContent -Encoding UTF8
            
            # On lance le fichier temporaire élevé et on attend sa fermeture pour le supprimer
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempFile`"" -Verb RunAs -Wait
            Remove-Item -Path $TempFile -Force -ErrorAction SilentlyContinue
        } else {
            Clear-Host
            Write-Host "[ERREUR FATALE] Impossible de r${e_aigu}cup${e_aigu}rer le code en m${e_aigu}moire pour l'${e_aigu}l${e_aigu}vation." -ForegroundColor Red
            Read-Host "Appuyez sur Entr${e_aigu}e pour quitter..."
        }
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
Write-Host " Ce script va v${e_aigu}rifier et installer toutes vos mises $a_grave jour."
Write-Host " Ne fermez pas cette fen${e_circo}tre tant que ce n'est pas fini."
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------------------
# ÉTAPE 1 : WINDOWS UPDATE INTÉGRAL
# -------------------------------------------------------------------------
Write-Host "[1/3] Recherche globale de TOUTES les mises $a_grave jour Windows Update..." -ForegroundColor Magenta

if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host " -> Pr${e_aigu}paration de l'environnement PSWindowsUpdate..." -ForegroundColor DarkGray
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue | Out-Null
    Install-Module -Name PSWindowsUpdate -Force -Repository PSGallery -Scope CurrentUser -AllowClobber -ErrorAction SilentlyContinue | Out-Null
}

Import-Module PSWindowsUpdate

try {
    Add-WUServiceManager -ServiceID "7971f2d8-260a-4a17-a31f-f6e3e361242d" -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
    Write-Host " -> Analyse en cours (Windows, Pilotes, S${e_aigu}curit${e_aigu}, Logiciels Microsoft)..." -ForegroundColor Cyan
    
    $updates = Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot:$false -ErrorAction Stop
    
    if ($updates) {
        Write-Host " -> Toutes les mises $a_grave jour ont ${e_aigu}t${e_aigu} t${e_aigu}l${e_aigu}charg${e_aigu}es et install${e_aigu}es avec succ${e_grave}s !" -ForegroundColor Green
    } else {
        Write-Host " -> Votre syst${e_grave}me et vos p${e_aigu}riph${e_aigu}riques sont d${e_aigu}j$a_grave 100% $a_grave jour !" -ForegroundColor Green
    }
} catch {
    Write-Host " [Information] Windows Update est temporairement occup${e_aigu} ou inaccessible : $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "----------------------------------------------------------"
Write-Host ""

# -------------------------------------------------------------------------
# ÉTAPE 2 : PILOTE GRAPHIQUE NVIDIA (VIA CHOCOLATEY AUTOMATIQUE)
# -------------------------------------------------------------------------
Write-Host "[2/3] V${e_aigu}rification et mise $a_grave jour automatique du pilote NVIDIA..." -ForegroundColor Magenta

$hasNvidiaGPU = (Get-CimInstance Win32_VideoController | Where-Object { $_.DriverProvider -like "*NVIDIA*" -or $_.Name -match "NVIDIA" })

if ($hasNvidiaGPU) {
    Write-Host " -> Carte graphique d${e_aigu}tect${e_aigu}e : $($hasNvidiaGPU.Name)" -ForegroundColor Green
    
    try {
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-Host " -> Configuration du gestionnaire de pilotes s${e_aigu}curis${e_aigu}..." -ForegroundColor Cyan
            $chocoScript = "iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex"
            Invoke-Expression $chocoScript 6>$null 2>$null 4>$null | Out-Null
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        }

        Write-Host " -> Analyse et mise $a_grave jour du pilote Game Ready officiel..." -ForegroundColor Cyan
        Write-Host " -> Votre ${e_aigu}cran peut clignoter, c'est tout $a_grave fait normal." -ForegroundColor DarkGray

        choco upgrade nvidia-display-driver -y --no-progress -r 2>$null | Out-Null

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
# ÉTAPE 3 : SUITE MICROSOFT OFFICE 365 (DÉTECTION D'ACTIVATION SÉCURISÉE)
# -------------------------------------------------------------------------
Write-Host "[3/3] V${e_aigu}rification de Microsoft Office 365..." -ForegroundColor Magenta

$isOfficeInstalled = $null -ne (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe" -ErrorAction SilentlyContinue)

$isOfficeActivated = $false
if ($isOfficeInstalled) {
    $vbsPaths = @(
        "C:\Program Files\Microsoft Office\Office16\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs",
        "C:\Program Files\Microsoft Office\Office15\ospp.vbs"
    )
    
    $targetVbs = $null
    foreach ($path in $vbsPaths) {
        if (Test-Path $path) { $targetVbs = $path; break }
    }

    if (-not $targetVbs) {
        $targetVbs = Get-ChildItem -Path "C:\Program Files\Microsoft Office", "C:\Program Files (x86)\Microsoft Office" -Filter "ospp.vbs" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
    }

    if ($targetVbs -and (Test-Path $targetVbs)) {
        $licenceStatus = cscript.exe //NoLogo "$targetVbs" /dstatus 2>$null | Out-String
        
        # CORRECTIF DÉTECTION : On regarde si la licence est active OU si un jeton d'abonnement 365 valide est présent
        if ($licenceStatus -match "LICENSED" -or $licenceStatus -match "O365HomePrem" -or $licenceStatus -match "O365ProPlus" -or $licenceStatus -match "Subscription") {
            $isOfficeActivated = $true
        }
    } else {
        # Si ospp.vbs est introuvable, on vérifie la présence de clés de registre d'activation Office 365 standards
        $regCheck = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "ProductReleaseIds" -ErrorAction SilentlyContinue
        if ($regCheck) { $isOfficeActivated = $true }
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
        
        if (Test-Path $tempPathActivation) {
            Write-Host " -> Ouverture de l'activation dans une nouvelle fen${e_circo}tre..." -ForegroundColor Cyan
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "`"$tempPathActivation`"" -Wait
            Write-Host " -> Activation termin${e_aigu}e. Retour au script principal." -ForegroundColor Green
        } else {
            Write-Host " -> [Attention] Fichier d'activation introuvable après téléchargement." -ForegroundColor Yellow
        }
    } catch {
        Write-Host " -> [Attention] Impossible de joindre GitHub pour l'activation." -ForegroundColor Yellow
    } finally {
        if (Test-Path $tempPathActivation) { Remove-Item -Path $tempPathActivation -Force }
        if (Test-Path $tempPathMasAio) { Remove-Item -Path $tempPathMasAio -Force }
    }
}

if (-not $isOfficeInstalled) {
    Write-Host " -> [!] Microsoft 365 n'est pas install${e_aigu} sur ce PC." -ForegroundColor Yellow
    $confirmationOffice = Read-Host "Voulez-vous installer la suite Microsoft Office 365 Pro ? (Y/N)"
    if ($confirmationOffice -match "^[yYoO]$") {
        Write-Host " -> T${e_aigu}l${e_aigu}chargement de l'installateur officiel Office..." -ForegroundColor Cyan
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
            Start-Process -FilePath $pathC2R -ArgumentList "/update userenforce=true" -Wait -NoNewWindow
            Start-Process -FilePath $pathC2R -ArgumentList "/update user displaylevel=false forceappshutdown=true" -Wait -NoNewWindow
            Write-Host " -> Mises $a_grave jour Office trait${e_aigu}es avec succ${e_grave}s." -ForegroundColor Green
        } else {
            Write-Host " -> [Attention] L'ex${e_aigu}cutable de mise $a_grave jour Office ClickToRun est introuvable." -ForegroundColor Yellow
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
