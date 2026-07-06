# =========================================================================
# ASSISTANT DE MISE À JOUR PC (VERSION 100% CLI - ÉTAPES AVEC DESCRIPTIONS)
# =========================================================================

# Changement de la table des caractères de la console Windows en UTF-8 (chcp 65001)
$null = & chcp.com 65001
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Caractères spéciaux calculés dynamiquement pour contourner l'interprétation du fichier texte
$e_aigu  = "$([char]233)" # é
$e_grave = "$([char]232)" # è
$a_grave = "$([char]224)" # à
$c_cedille = "$([char]231)" # ç
$maj_e_aigu = "$([char]201)" # É
$maj_a_grave = "$([char]192)" # À

# Forçage des protocoles réseau
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocolType::Tls12 -bor 12288

# Chemin du fichier de log persistant
$GlobalLogFile = Join-Path $env:TEMP "assistant_maj_complet.log"
"--- Nouveau démarrage de l'assistant (Full Menu CLI) ---" | Set-Content -Path $GlobalLogFile -Encoding UTF8

function Log ($Msg, $Color = "White") {
    Write-Host $Msg -ForegroundColor $Color
    try { $Msg | Add-Content -Path $GlobalLogFile -ErrorAction SilentlyContinue } catch {}
}

function Log-Separation {
    Write-Host "`n__________________________________________________________`n" -ForegroundColor DarkGray
}

# -------------------------------------------------------------------------
# AUTO-ÉLÉVATION ADMINISTRATEUR
# -------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    if ($PSCommandPath) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    } else {
        Log "[ERREUR] Le script doit être exécuté en tant qu'Administrateur." "Red"
    }
    Exit
}

# Cacher le curseur d'écriture pour l'interface des menus
$saveCursorVisibility = [Console]::CursorVisible
[Console]::CursorVisible = $false

# -------------------------------------------------------------------------
# MENU 1 : SÉLECTION DE LA LANGUE (Bouton Radio)
# -------------------------------------------------------------------------
Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         ASSISTANT DE MISE $maj_a_grave JOUR PC (CLI)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$langItems = @(
    @{ Text = "Fran${c_cedille}ais (FR)" ; Value = "FR" ; Selected = $true },
    @{ Text = "English (EN)"  ; Value = "EN" ; Selected = $false }
)
$langIndex = 0
$langRunning = $true

while ($langRunning) {
    [Console]::SetCursorPosition(0, 4)
    Write-Host " [Navigate: Arrow Keys | Select: Spacebar | Validate: Enter]`n" -ForegroundColor Gray
    
    for ($i = 0; $i -lt $langItems.Count; $i++) {
        $radioSign = if ($langItems[$i].Selected) { "(*)" } else { "( )" }
        if ($i -eq $langIndex) {
            Write-Host "  > $radioSign $($langItems[$i].Text)  " -BackgroundColor Cyan -ForegroundColor Black
        } else {
            Write-Host "    $radioSign $($langItems[$i].Text)  " -ForegroundColor White
        }
    }
    
    $key = [Console]::ReadKey($true)
    switch ($key.Key) {
        "UpArrow"   { $langIndex = if ($langIndex -gt 0) { $langIndex - 1 } else { $langItems.Count - 1 } }
        "DownArrow" { $langIndex = if ($langIndex -lt $langItems.Count - 1) { $langIndex + 1 } else { 0 } }
        "Spacebar"  { 
            for ($j = 0; $j -lt $langItems.Count; $j++) { $langItems[$j].Selected = $false }
            $langItems[$langIndex].Selected = $true
        }
        "Enter"     { $langRunning = $false }
    }
}
$lang = ($langItems | Where-Object { $_.Selected }).Value

# -------------------------------------------------------------------------
# MENU 2 : SÉLECTION DES COMPOSANTS (Noms + Descriptions directes)
# -------------------------------------------------------------------------
$menuItems = @(
    @{ 
        TextFR = "Windows Update : Recherche, t${e_aigu}l${e_aigu}chargement et installation des mises $a_grave jour OS & pilotes"
        TextEN = "Windows Update : Scan, download, and install OS updates & drivers"
        Checked = $true 
    },
    @{ 
        TextFR = "Winget : D${e_aigu}tection des applications, menu de s${e_aigu}lection et d${e_aigu}ploiement des MAJ"
        TextEN = "Winget : App detection, custom selection menu, and update deployment"
        Checked = $true 
    },
    @{ 
        TextFR = "NVIDIA : V${e_aigu}rification du GPU, installation / mise $a_grave jour automatique du pilote graphique"
        TextEN = "NVIDIA : GPU hardware check, automated graphics driver install / update"
        Checked = $true 
    },
    @{ 
        TextFR = "Office 365 : Diagnostic de licence, mise $a_grave jour forc${e_aigu}e, installation / activation KMS"
        TextEN = "Office 365 : License diagnosis, forced app update, install / KMS activation"
        Checked = $true 
    }
)
$compIndex = 0
$compRunning = $true

[Console]::SetCursorPosition(0, 4)
Write-Host "                                                                                "
Write-Host "                                                                                "
Write-Host "                                                                                "

while ($compRunning) {
    [Console]::SetCursorPosition(0, 4)
    $helpText = if ($lang -eq "EN") { " [Navigate: Arrow Keys | Check: Spacebar | Validate: Enter]`n" } else { " [Navigation : Fl${e_grave}ches | Cocher : Espace | Valider : Entr${e_aigu}e]`n" }
    Write-Host $helpText -ForegroundColor Gray
    
    for ($i = 0; $i -lt $menuItems.Count; $i++) {
        $text = if ($lang -eq "EN") { $menuItems[$i].TextEN } else { $menuItems[$i].TextFR }
        $checkSign = if ($menuItems[$i].Checked) { "[X]" } else { "[ ]" }
        
        if ($i -eq $compIndex) {
            Write-Host "  > $checkSign $text  " -BackgroundColor Cyan -ForegroundColor Black
        } else {
            Write-Host "    $checkSign $text  " -ForegroundColor White
        }
    }
    
    $key = [Console]::ReadKey($true)
    switch ($key.Key) {
        "UpArrow"   { $compIndex = if ($compIndex -gt 0) { $compIndex - 1 } else { $menuItems.Count - 1 } }
        "DownArrow" { $compIndex = if ($compIndex -lt $menuItems.Count - 1) { $compIndex + 1 } else { 0 } }
        "Spacebar"  { $menuItems[$compIndex].Checked = -not $menuItems[$compIndex].Checked }
        "Enter"     { 
            $anyChecked = $false
            foreach ($item in $menuItems) { if ($item.Checked) { $anyChecked = $true } }
            if ($anyChecked) { $compRunning = $false }
        }
    }
}

[Console]::CursorVisible = $saveCursorVisibility

$runWU     = $menuItems[0].Checked
$runWinget = $menuItems[1].Checked
$runNvidia = $menuItems[2].Checked
$runOffice = $menuItems[3].Checked

Write-Host "`n"
Log "[!] Processus lanc${e_aigu}. Pr${e_aigu}paration de l'environnement..." "Cyan"

# -------------------------------------------------------------------------
# LIBÉRATION GPO
# -------------------------------------------------------------------------
Log-Separation
Log "[*] GPO : Lib${e_aigu}ration du syst${e_grave}me et suppression temporaire des restrictions..." "Cyan"
$gpoPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
if (-not (Test-Path $gpoPath)) { New-Item -Path $gpoPath -Force | Out-Null }
Set-ItemProperty -Path $gpoPath -Name "DenyUnspecified" -Value 0 -Type DWord -ErrorAction SilentlyContinue
gpupdate /force | Out-Null

# -------------------------------------------------------------------------
# COMPOSANT : WINDOWS UPDATE
# -------------------------------------------------------------------------
if ($runWU) {
    Log-Separation
    Log "[*] Windows Update : Recherche, t${e_aigu}l${e_aigu}chargement et installation..." "Cyan"
    Get-Service -Name wuauserv, bits, cryptsvc -ErrorAction SilentlyContinue | Start-Service -ErrorAction SilentlyContinue
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Log " -> Installation du module PSWindowsUpdate..." "Gray"
        Install-Module -Name PSWindowsUpdate -Force -Repository PSGallery -Scope CurrentUser -AllowClobber -ErrorAction SilentlyContinue | Out-Null
    }
    Import-Module PSWindowsUpdate -Force
    try { 
        $WUOutput = Get-WindowsUpdate -MicrosoftUpdate -Install -AcceptAll -IgnoreReboot -ErrorAction SilentlyContinue | Out-String
        if ($WUOutput) { Log $WUOutput "Gray" } 
    } catch {}
}

# -------------------------------------------------------------------------
# COMPOSANT : WINGET
# -------------------------------------------------------------------------
if ($runWinget) {
    Log-Separation
    Log "[*] Winget : D${e_aigu}tection des applications et menu de s${e_aigu}lection..." "Cyan"
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        & winget source update | Out-Null
        $tempFile = Join-Path $env:TEMP "winget_cli.txt"
        
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell.exe"
        $psi.Arguments = "-NoProfile -Command `"& winget source reset --force; echo Y | winget upgrade --include-unknown`""
        $psi.RedirectStandardOutput = $true
        $psi.UseShellExecute = $false
        $psi.CreateNoWindow = $true
        
        $proc = [System.Diagnostics.Process]::Start($psi)
        $output = $proc.StandardOutput.ReadToEnd()
        $proc.WaitForExit()
        $proc.Close()
        
        Set-Content -Path $tempFile -Value $output

        $apps = @()
        if (Test-Path $tempFile) {
            $upgradeOutput = Get-Content $tempFile | Select-String -Pattern '-' -NotMatch
            Remove-Item $tempFile -Force
            foreach ($line in $upgradeOutput) {
                $stringLine = $line.ToString()
                if ($stringLine -match '\s+(winget|msstore)\s*$') {
                    $elements = $stringLine -split '\s{2,}' | Where-Object { $_.Trim() -ne '' }
                    if ($elements.Count -ge 3) { $apps += @{ Name = $elements[0].Trim(); Id = $elements[1].Trim(); Checked = $true } }
                }
            }
        }

        if ($apps.Count -eq 0) { 
            Log " -> Tout est $a_grave jour !" "Green"
        } else {
            if ($lang -eq "EN") {
                Log "[Action Required] Select the apps to update from the interactive menu below." "Yellow"
            } else {
                Log "[Action Requise] S${e_aigu}lectionnez les applications ${a_grave} mettre ${a_grave} jour dans le menu interactif." "Yellow"
            }
            Write-Host ""

            $wingetIndex = 0
            $wingetRunning = $true
            [Console]::CursorVisible = $false
            
            $startTop = [Console]::CursorTop

            while ($wingetRunning) {
                [Console]::SetCursorPosition(0, $startTop)
                $wHelp = if ($lang -eq "EN") { " [Navigate: Arrow Keys | Check: Spacebar | Validate: Enter]`n" } else { " [Navigation : Fl${e_grave}ches | Cocher : Espace | Valider : Entr${e_aigu}e]`n" }
                Write-Host $wHelp -ForegroundColor Gray

                for ($i = 0; $i -lt $apps.Count; $i++) {
                    $wCheckSign = if ($apps[$i].Checked) { "[X]" } else { "[ ]" }
                    $lineText = "$wCheckSign $($apps[$i].Name) ($($apps[$i].Id))"
                    
                    if ($lineText.Length -gt ([Console]::BufferWidth - 8)) { $lineText = $lineText.Substring(0, [Console]::BufferWidth - 11) + "..." }

                    if ($i -eq $wingetIndex) {
                        Write-Host "  > $lineText  " -BackgroundColor Cyan -ForegroundColor Black
                    } else {
                        Write-Host "    $lineText  " -ForegroundColor White
                    }
                }
                
                $cancelText = if ($lang -eq "EN") { "[SKIP ALL UPDATES AND CONTINUE]" } else { "[IGNORER TOUTES LES MISES A JOUR ET CONTINUER]" }
                if ($wingetIndex -eq $apps.Count) {
                    Write-Host "  > $cancelText  " -BackgroundColor Red -ForegroundColor White
                } else {
                    Write-Host "    $cancelText  " -ForegroundColor DarkRed
                }

                $key = [Console]::ReadKey($true)
                switch ($key.Key) {
                    "UpArrow"   { $wingetIndex = if ($wingetIndex -gt 0) { $wingetIndex - 1 } else { $apps.Count } }
                    "DownArrow" { $wingetIndex = if ($wingetIndex -lt $apps.Count) { $wingetIndex + 1 } else { 0 } }
                    "Spacebar"  { if ($wingetIndex -lt $apps.Count) { $apps[$wingetIndex].Checked = -not $apps[$wingetIndex].Checked } }
                    "Enter"     { 
                        if ($wingetIndex -eq $apps.Count) {
                            foreach ($app in $apps) { $app.Checked = $false }
                        }
                        $wingetRunning = $false 
                    }
                }
            }
            [Console]::CursorVisible = $saveCursorVisibility
            Write-Host "`n"

            $selectedApps = $apps | Where-Object { $_.Checked -eq $true }

            if ($selectedApps) {
                foreach ($app in $selectedApps) { 
                    Log "   -> MAJ : $($app.Id)" "Gray"
                    $psiApps = New-Object System.Diagnostics.ProcessStartInfo
                    $psiApps.FileName = "powershell.exe"
                    $psiApps.Arguments = "-NoProfile -Command `"echo Y | winget upgrade --id $($app.Id) --accept-package-agreements --accept-source-agreements`""
                    $psiApps.UseShellExecute = $false
                    $psiApps.CreateNoWindow = $true
                    $procApps = [System.Diagnostics.Process]::Start($psiApps)
                    $procApps.WaitForExit()
                    $procApps.Close()
                }
            } else {
                Log " -> S${e_aigu}lection annul${e_aigu}ee, aucune application mise $a_grave jour." "Green"
            }
        }
    }
}

# -------------------------------------------------------------------------
# COMPOSANT : NVIDIA
# -------------------------------------------------------------------------
if ($runNvidia) {
    Log-Separation
    Log "[*] NVIDIA : Analyse matériel, installation / MAJ automatique du pilote..." "Cyan"
    if (Get-CimInstance Win32_VideoController | Where-Object { $_.DriverProvider -like "*NVIDIA*" -or $_.Name -match "NVIDIA" }) {
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { $chocoScript = "iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex"; Invoke-Expression $chocoScript 6>$null 2>$null | Out-Null }
        $chocoLog = Join-Path $env:TEMP "choco_temp.log"
        Start-Process choco -ArgumentList "upgrade nvidia-display-driver -y --no-progress -r" -RedirectStandardOutput $chocoLog -NoNewWindow -Wait
        if (Test-Path $chocoLog) { Get-Content $chocoLog | ForEach-Object { Log "   [Choco] $_" "Gray" }; Remove-Item $chocoLog -Force }
    } else {
        Log " -> Aucun matériel NVIDIA détecté." "Gray"
    }
}

# -------------------------------------------------------------------------
# COMPOSANT : MICROSOFT OFFICE 365
# -------------------------------------------------------------------------
if ($runOffice) {
    Log-Separation
    Log "[*] Office 365 : Diagnostic licence, mise $a_grave jour, installation / activation..." "Cyan"
    
    $isOfficeInstalled = $null -ne (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe" -ErrorAction SilentlyContinue)
    $isOfficeActivated = $false

    if ($isOfficeInstalled) {
        $vbsPaths = @(
            "C:\Program Files\Microsoft Office\Office16\ospp.vbs",
            "C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs",
            "C:\Program Files\Microsoft Office\Office15\ospp.vbs"
        )
        $targetVbs = $null
        foreach ($path in $vbsPaths) { if (Test-Path $path) { $targetVbs = $path; break } }
        if (-not $targetVbs) {
            $targetVbs = Get-ChildItem -Path "C:\Program Files\Microsoft Office", "C:\Program Files (x86)\Microsoft Office" -Filter "ospp.vbs" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
        }

        if ($targetVbs -and (Test-Path $targetVbs)) {
            $licenceStatus = cscript.exe //NoLogo "$targetVbs" /dstatus 2>$null | Out-String
            if ($licenceStatus -match "LICENSED" -or $licenceStatus -match "O365HomePrem" -or $licenceStatus -match "O365ProPlus" -or $licenceStatus -match "Subscription") {
                $isOfficeActivated = $true
            }
        } else {
            if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "ProductReleaseIds" -ErrorAction SilentlyContinue) { $isOfficeActivated = $true }
        }
    }

    function Run-ConsoleActivationScript {
        Log " -> R${e_aigu}cup${e_aigu}ration des scripts d'activation depuis GitHub..." "Gray"
        $urlActivation = "https://raw.githubusercontent.com/Albambinou/automaj-pc/main/Activer_Office.cmd"
        $tempPathActivation = "$env:TEMP\Activer_Office.cmd"
        try {
            Start-Process -FilePath "curl.exe" -ArgumentList "-L", "-s", $urlActivation, "-o", $tempPathActivation -Wait -NoNewWindow
            if (Test-Path $tempPathActivation) {
                Log " -> Exécution du script d'activation en arrière-plan..." "Gray"
                Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "`"$tempPathActivation`"" -Wait -NoNewWindow
                Log " -> Processus d'activation terminé." "Green"
            }
        } catch { Log " -> [Attention] Impossible de joindre GitHub." "Red" }
        finally { if (Test-Path $tempPathActivation) { Remove-Item -Path $tempPathActivation -Force -ErrorAction SilentlyContinue } }
    }

    if (-not $isOfficeInstalled) {
        Log " -> [!] Microsoft 365 n'est pas install${e_aigu} sur ce PC." "Red"
        $promptInstallOffice = if ($lang -eq "EN") { "Do you want to install Microsoft Office 365 Pro Suite? (Y/N)" } else { "Voulez-vous installer la suite Microsoft Office 365 Pro ? (Y/N)" }
        if ((Read-Host $promptInstallOffice) -match "^[yYoO]$") {
            Log " -> T${e_aigu}l${e_aigu}chargement de l'installateur..." "Gray"
            $urlOffice = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365AppsBasicRetail&platform=x64&language=fr-fr&version=O16GA"
            $tempPathOffice = "$env:TEMP\Office365_setup.exe"
            try {
                Start-Process -FilePath "curl.exe" -ArgumentList "-L", "-s", $urlOffice, "-o", $tempPathOffice -Wait -NoNewWindow
                Log " -> Lancement de l'installation d'Office 365 (Patientez)..." "Gray"
                Start-Process -FilePath $tempPathOffice -ArgumentList "SETLANG=fr-fr" -NoNewWindow
                Start-Sleep -Seconds 15
                while (Get-Process -Name "OfficeC2RClient" -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 5 }
                Remove-Item -Path $tempPathOffice -Force -ErrorAction SilentlyContinue
                Log " -> Installation d'Office 365 terminée." "Green"
                
                $promptAct = if ($lang -eq "EN") { "Do you want to activate Office now? (Y/N)" } else { "Voulez-vous lancer l'activation d'Office maintenant ? (Y/N)" }
                if ((Read-Host $promptAct) -match "^[yYoO]$") { Run-ConsoleActivationScript }
            } catch { Log " [ERREUR] Traitement Office impossible : $_" "Red" }
        }
    } else {
        Log " -> Microsoft Office 365 est d${e_aigu}j$a_grave install${e_aigu} sur ce PC." "Green"
        if (-not $isOfficeActivated) {
            Log " -> [Attention] Microsoft Office est présent mais non activé !" "Red"
            $promptAct = if ($lang -eq "EN") { "Do you want to run the activation script? (Y/N)" } else { "Voulez-vous lancer le script d'activation d'Office ? (Y/N)" }
            if ((Read-Host $promptAct) -match "^[yYoO]$") { Run-ConsoleActivationScript }
        } else {
            Log " -> Licence Microsoft Office valide et activ${e_aigu}e." "Green"
            Log " -> Application des mises $a_grave jour Office..." "Gray"
            $pathC2R = "C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe"
            if (Test-Path $pathC2R) {
                Start-Process -FilePath $pathC2R -ArgumentList "/update userenforce=true" -Wait -NoNewWindow
                Start-Process -FilePath $pathC2R -ArgumentList "/update user displaylevel=false forceappshutdown=true" -Wait -NoNewWindow
                Log " -> Mises $a_grave jour Office trait${e_aigu}es." "Green"
            }
        }
    }
}

# -------------------------------------------------------------------------
# CLÔTURE & PERSISTANCE DE LA FENÊTRE
# -------------------------------------------------------------------------
Log-Separation
Log "   TOUTES LES MISES $maj_a_grave JOUR SONT TERMIN${maj_e_aigu}ES !" "Green"
Log "==========================================================" "Green"

$promptExit = if ($lang -eq "EN") { "Press ENTER to close the window..." } else { "Appuyez sur ENTR${e_aigu}E pour fermer la fen${e_grave}tre..." }
Read-Host "`n$promptExit"
