# Forçage global des protocoles de sécurité réseau
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor 12288

# Raccourcis universels pour les caractères accentués
$e_aigu = "$([char]233)" # é
$a_grave = "$([char]224)" # à
$e_grave = "$([char]232)" # è
$u_grave = "$([char]249)" # ù
$a_circo = "$([char]226)" # â
$e_circo = "$([char]234)" # ê
$o_circo = "$([char]244)" # ô
$c_cedi = "$([char]231)" # ç

# -------------------------------------------------------------------------
# AUTO-ÉLÉVATION HYBRIDE SÉCURISÉE
# -------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Demande des droits administrateur en cours..." -ForegroundColor Yellow
    if ($PSCommandPath) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    } else {
        $ScriptContent = $MyInvocation.MyCommand.ScriptBlock.ToString()
        if ($ScriptContent) {
            $TempFile = Join-Path $env:TEMP "update_system_temp.ps1"
            Set-Content -Path $TempFile -Value $ScriptContent -Encoding UTF8
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempFile`"" -Verb RunAs -Wait
            Remove-Item -Path $TempFile -Force -ErrorAction SilentlyContinue
        } else {
            Clear-Host
            Write-Host "[ERREUR FATALE] Impossible de s'auto-${e_aigu}lever." -ForegroundColor Red
            Read-Host "Appuyez sur Entr${e_aigu}e pour quitter..."
        }
    }
    Exit
}

$size = New-Object System.Management.Automation.Host.Size(85, 35)
$host.UI.RawUI.WindowSize = $size
$host.UI.RawUI.BufferSize = $size

# -------------------------------------------------------------------------
# DÉBUT DU SCRIPT PRINCIPAL
# -------------------------------------------------------------------------
Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    ASSISTANT DE MISE $a_grave JOUR EXTR${e_circo}ME DE VOTRE PC    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Ce script va forcer l'installation de TOUT ce qui est"
Write-Host " disponible (Standard, Pilotes, Pr${e_aigu}versions)."
Write-Host " Ne fermez pas cette fen${e_circo}tre tant que ce n'est pas fini."
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------------------
# ÉTAPE 1 : WINDOWS UPDATE (SANS CRASH API)
# -------------------------------------------------------------------------
Write-Host "[1/3] Traque et installation de TOUTES les mises $a_grave jour..." -ForegroundColor Magenta

# 1. Option "Continuous Innovation" (Recevoir les MAJ dès que possible, préversions incluses)
Write-Host " -> For$($c_cedi)age de l'option 'Recevoir les derni${e_grave}res MAJ d${e_grave}s qu'elles sont disponibles'..." -ForegroundColor DarkGray
$regPathUX = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
if (-not (Test-Path $regPathUX)) { New-Item -Path $regPathUX -Force | Out-Null }
Set-ItemProperty -Path $regPathUX -Name "IsContinuousInnovationOptedIn" -Value 1 -Type DWord -ErrorAction SilentlyContinue

# 2. Réveil des services critiques
Get-Service -Name wuauserv, bits, cryptsvc -ErrorAction SilentlyContinue | Set-Service -StartupType Manual -ErrorAction SilentlyContinue
Get-Service -Name wuauserv, bits, cryptsvc -ErrorAction SilentlyContinue | Start-Service -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

# 3. Moteur PSWindowsUpdate pour le gros oeuvre (sécurisé)
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host " -> Chargement du moteur de mise $a_grave jour s${e_aigu}curis${e_aigu}..." -ForegroundColor DarkGray
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue | Out-Null
    Install-Module -Name PSWindowsUpdate -Force -Repository PSGallery -Scope CurrentUser -AllowClobber -ErrorAction SilentlyContinue | Out-Null
}
Import-Module PSWindowsUpdate -Force

try {
    Write-Host " -> Analyse et traitement des MAJ standards et pilotes..." -ForegroundColor Cyan
    Get-WindowsUpdate -MicrosoftUpdate -Install -AcceptAll -IgnoreReboot -ErrorAction Stop | Out-Null
    Write-Host " -> Mises $a_grave jour standards appliqu${e_aigu}es avec succ${e_grave}s !" -ForegroundColor Green
} catch {
    Write-Host " -> [Information] L'installation standard est g${e_aigu}r${e_aigu}e par l'OS en arri${e_grave}re-plan." -ForegroundColor DarkGray
}

# 4. Forçage des préversions via l'Orchestrateur natif (Imparable)
Write-Host " -> D${e_aigu}clenchement de l'Orchestrateur USO pour aspirer les pr${e_aigu}versions..." -ForegroundColor Yellow
Start-Process -FilePath "usoclient.exe" -ArgumentList "StartInteractiveScan" -NoNewWindow
Write-Host " -> Le syst${e_grave}me a re$($c_cedi)u l'ordre d'absorber toutes les pr${e_aigu}versions !" -ForegroundColor Green

Write-Host ""
Write-Host "----------------------------------------------------------"
Write-Host ""

# -------------------------------------------------------------------------
# ÉTAPE 2 : PILOTE GRAPHIQUE NVIDIA
# -------------------------------------------------------------------------
Write-Host "[2/3] V${e_aigu}rification et mise $a_grave jour automatique du pilote NVIDIA..." -ForegroundColor Magenta

$hasNvidiaGPU = (Get-CimInstance Win32_VideoController | Where-Object { $_.DriverProvider -like "*NVIDIA*" -or $_.Name -match "NVIDIA" })

if ($hasNvidiaGPU) {
    Write-Host " -> Carte graphique d${e_aigu}tect${e_aigu}e : $($hasNvidiaGPU.Name)" -ForegroundColor Green
    
    try {
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-Host " -> Configuration de Chocolatey..." -ForegroundColor Cyan
            $chocoScript = "iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex"
            Invoke-Expression $chocoScript 6>$null 2>$null 4>$null | Out-Null
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        }

        Write-Host " -> Analyse et mise $a_grave jour du pilote Game Ready officiel..." -ForegroundColor Cyan
        choco upgrade nvidia-display-driver -y --no-progress -r 2>$null | Out-Null
        Write-Host " -> Le pilote NVIDIA est parfaitement $a_grave jour !" -ForegroundColor Green
    } catch {
        Write-Host " [Attention] Impossible de mettre $a_grave jour le pilote via Chocolatey : $_" -ForegroundColor Yellow
    }
} else {
    Write-Host " -> Aucune carte graphique NVIDIA d${e_aigu}tect${e_aigu}e." -ForegroundColor DarkGray
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
