# Forçage des protocoles réseau
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocolType::Tls12 -bor 12288

# Caractères accentués (pour le stockage)
$e_aigu      = "$([char]233)" # é
$a_grave     = "$([char]224)" # à
$e_grave     = "$([char]232)" # è
$u_grave     = "$([char]249)" # ù
$maj_a_grave = "$([char]192)" # À
$maj_e_aigu  = "$([char]201)" # É

# Chemin du fichier de log persistant
$GlobalLogFile = Join-Path $env:TEMP "assistant_maj_complet.log"
"--- Nouveau démarrage de l'assistant ---" | Set-Content -Path $GlobalLogFile -Encoding UTF8

# -------------------------------------------------------------------------
# AUTO-ÉLÉVATION ADMINISTRATEUR
# -------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    if ($PSCommandPath) {
        Start-Process powershell.exe -ArgumentList "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    } else {
        $ScriptContent = $MyInvocation.MyCommand.ScriptBlock.ToString()
        if ($ScriptContent) {
            $TempFile = Join-Path $env:TEMP "update_system_temp.ps1"
            Set-Content -Path $TempFile -Value $ScriptContent -Encoding UTF8
            Start-Process powershell.exe -ArgumentList "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$TempFile`"" -Verb RunAs
        } else {
            Exit
        }
    }
    Stop-Process -Id $PID -Force
}

# Chargement du moteur graphique Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# -------------------------------------------------------------------------
# SCRIPT POUR LE CURSEUR MODERNE (Correction du vieux curseur)
# -------------------------------------------------------------------------
$CursorSource = @"
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class ModernCursor {
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr LoadCursor(IntPtr hInstance, int lpCursorName);

    private const int IDC_HAND = 32649;

    public static Cursor GetModernHand() {
        try {
            IntPtr handle = LoadCursor(IntPtr.Zero, IDC_HAND);
            return new Cursor(handle);
        } catch {
            return Cursors.Hand;
        }
    }
}
"@
Add-Type -TypeDefinition $CursorSource -ReferencedAssemblies "System.Windows.Forms.dll", "System.Drawing.dll"
$ModernHandCursor = [ModernCursor]::GetModernHand()

# -------------------------------------------------------------------------
# FENÊTRE PRINCIPALE
# -------------------------------------------------------------------------
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Assistant de mise $a_grave jour PC"
$Form.Size = New-Object System.Drawing.Size(650, 615)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$Form.ForeColor = [System.Drawing.Color]::White

# Titre principal
$TitleLabel = New-Object System.Windows.Forms.Label
$TitleLabel.Text = "ASSISTANT DE MISE $maj_a_grave JOUR PC"
$TitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$TitleLabel.Size = New-Object System.Drawing.Size(400, 40)
$TitleLabel.Location = New-Object System.Drawing.Point(20, 15)
$TitleLabel.ForeColor = [System.Drawing.Color]::DeepSkyBlue
$Form.Controls.Add($TitleLabel)

# -------------------------------------------------------------------------
# SÉLECTION DE LA LANGUE (Dropdown combobox)
# -------------------------------------------------------------------------
$LangLabel = New-Object System.Windows.Forms.Label
$LangLabel.Text = "Langue / Language :"
$LangLabel.Location = New-Object System.Drawing.Point(430, 18)
$LangLabel.Size = New-Object System.Drawing.Size(110, 20)
$LangLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
$LangLabel.ForeColor = [System.Drawing.Color]::LightGray
$Form.Controls.Add($LangLabel)

$LangCombo = New-Object System.Windows.Forms.ComboBox
$LangCombo.Location = New-Object System.Drawing.Point(540, 15)
$LangCombo.Size = New-Object System.Drawing.Size(70, 25)
$LangCombo.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$LangCombo.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$LangCombo.ForeColor = [System.Drawing.Color]::White
$null = $LangCombo.Items.Add("FR")
$null = $LangCombo.Items.Add("EN")
$LangCombo.SelectedIndex = 0 # Par défaut en Français
$Form.Controls.Add($LangCombo)

# Groupe de Checkboxes
$GroupBox = New-Object System.Windows.Forms.GroupBox
$GroupBox.Text = " S${e_aigu}lectionnez les composants ${a_grave} traiter "
$GroupBox.Size = New-Object System.Drawing.Size(590, 150)
$GroupBox.Location = New-Object System.Drawing.Point(20, 65)
$GroupBox.ForeColor = [System.Drawing.Color]::LightGray
$Form.Controls.Add($GroupBox)

$chkWU = New-Object System.Windows.Forms.CheckBox
$chkWU.Text = "${maj_e_aigu}tape 1 : Windows Update & Pilotes OS"
$chkWU.Location = New-Object System.Drawing.Point(20, 30)
$chkWU.Size = New-Object System.Drawing.Size(540, 25)
$chkWU.Checked = $true
$GroupBox.Controls.Add($chkWU)

$chkWinget = New-Object System.Windows.Forms.CheckBox
$chkWinget.Text = "${maj_e_aigu}tape 2 : S${e_aigu}lection manuelle des MAJ Applications (Winget)"
$chkWinget.Location = New-Object System.Drawing.Point(20, 60)
$chkWinget.Size = New-Object System.Drawing.Size(540, 25)
$chkWinget.Checked = $true
$GroupBox.Controls.Add($chkWinget)

$chkNvidia = New-Object System.Windows.Forms.CheckBox
$chkNvidia.Text = "${maj_e_aigu}tape 3 : Pilote Graphique NVIDIA (Automatique si pr${e_aigu}sent)"
$chkNvidia.Location = New-Object System.Drawing.Point(20, 90)
$chkNvidia.Size = New-Object System.Drawing.Size(540, 25)
$chkNvidia.Checked = $true
$GroupBox.Controls.Add($chkNvidia)

$chkOffice = New-Object System.Windows.Forms.CheckBox
$chkOffice.Text = "${maj_e_aigu}tape 4 : Microsoft Office 365 (MAJ / Installation + Activation)"
$chkOffice.Location = New-Object System.Drawing.Point(20, 120)
$chkOffice.Size = New-Object System.Drawing.Size(540, 25)
$chkOffice.Checked = $true
$GroupBox.Controls.Add($chkOffice)

# Barre de progression
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = New-Object System.Drawing.Point(20, 230)
$ProgressBar.Size = New-Object System.Drawing.Size(320, 30)
$ProgressBar.Style = "Continuous"
$Form.Controls.Add($ProgressBar)

# Bouton Voir les Logs
$LogBtn = New-Object System.Windows.Forms.Button
$LogBtn.Text = "Voir les Logs"
$LogBtn.Location = New-Object System.Drawing.Point(355, 230)
$LogBtn.Size = New-Object System.Drawing.Size(120, 30)
$LogBtn.BackColor = [System.Drawing.Color]::DodgerBlue
$LogBtn.FlatStyle = "Flat"
$LogBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$LogBtn.Cursor = $ModernHandCursor
$Form.Controls.Add($LogBtn)

# Bouton Lancer
$StartBtn = New-Object System.Windows.Forms.Button
$StartBtn.Text = "Lancer"
$StartBtn.Location = New-Object System.Drawing.Point(490, 230)
$StartBtn.Size = New-Object System.Drawing.Size(120, 30)
$StartBtn.BackColor = [System.Drawing.Color]::SeaGreen
$StartBtn.FlatStyle = "Flat"
$StartBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$StartBtn.Cursor = $ModernHandCursor
$Form.Controls.Add($StartBtn)

# ZONE DE LOGS
$LogTextBox = New-Object System.Windows.Forms.RichTextBox
$LogTextBox.Size = New-Object System.Drawing.Size(590, 240)
$LogTextBox.Location = New-Object System.Drawing.Point(20, 275)
$LogTextBox.BackColor = [System.Drawing.Color]::Black
$LogTextBox.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$LogTextBox.ReadOnly = $true
$LogTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
$Form.Controls.Add($LogTextBox)

# -------------------------------------------------------------------------
# BOUTON DISCORD MODIFIÉ (Nouveau texte + Curseur Moderne Fixé)
# -------------------------------------------------------------------------
$DiscordBtn = New-Object System.Windows.Forms.Button
$DiscordBtn.Size = New-Object System.Drawing.Size(220, 36)
$DiscordBtn.Location = New-Object System.Drawing.Point(205, 528) # Centré à l'écran
$DiscordBtn.BackColor = [System.Drawing.Color]::FromArgb(88, 101, 242)
$DiscordBtn.ForeColor = [System.Drawing.Color]::White
$DiscordBtn.FlatStyle = "Flat"
$DiscordBtn.FlatAppearance.BorderSize = 0
$DiscordBtn.Text = "    Rejoins-nous sur Discord"
$DiscordBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$DiscordBtn.Cursor = $ModernHandCursor # Utilise maintenant le vrai curseur système moderne !

# Dessin de l'icône Discord
$DiscordBtn.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $xOff = 12
    $yOff = 10
    $points = @(
        (New-Object System.Drawing.PointF($xOff + 3.9, $yOff + 1.2)),
        (New-Object System.Drawing.PointF($xOff + 5.1, $yOff + 3.1)),
        (New-Object System.Drawing.PointF($xOff + 7.8, $yOff + 2.5)),
        (New-Object System.Drawing.PointF($xOff + 8.4, $yOff + 1.7)),
        (New-Object System.Drawing.PointF($xOff + 11.1, $yOff + 1.7)),
        (New-Object System.Drawing.PointF($xOff + 11.7, $yOff + 2.5)),
        (New-Object System.Drawing.PointF($xOff + 14.4, $yOff + 3.1)),
        (New-Object System.Drawing.PointF($xOff + 15.6, $yOff + 1.2)),
        (New-Object System.Drawing.PointF($xOff + 17.5, $yOff + 4.2)),
        (New-Object System.Drawing.PointF($xOff + 19.5, $yOff + 11.0)),
        (New-Object System.Drawing.PointF($xOff + 16.5, $yOff + 14.5)),
        (New-Object System.Drawing.PointF($xOff + 14.8, $yOff + 12.5)),
        (New-Object System.Drawing.PointF($xOff + 16.3, $yOff + 11.2)),
        (New-Object System.Drawing.PointF($xOff + 15.1, $yOff + 10.3)),
        (New-Object System.Drawing.PointF($xOff + 11.5, $yOff + 11.5)),
        (New-Object System.Drawing.PointF($xOff + 8.0, $yOff + 11.5)),
        (New-Object System.Drawing.PointF($xOff + 4.4, $yOff + 10.3)),
        (New-Object System.Drawing.PointF($xOff + 3.2, $yOff + 11.2)),
        (New-Object System.Drawing.PointF($xOff + 4.7, $yOff + 12.5)),
        (New-Object System.Drawing.PointF($xOff + 3.0, $yOff + 14.5)),
        (New-Object System.Drawing.PointF($xOff + 0.0, $yOff + 11.0)),
        (New-Object System.Drawing.PointF($xOff + 2.0, $yOff + 4.2))
    )
    $g.FillPolygon($brush, $points)
    $bgBrush = New-Object System.Drawing.SolidBrush($sender.BackColor)
    $g.FillEllipse($bgBrush, ($xOff + 5.5), ($yOff + 6.0), 2.5, 2.5)
    $g.FillEllipse($bgBrush, ($xOff + 11.5), ($yOff + 6.0), 2.5, 2.5)
})

$DiscordBtn.Add_MouseEnter({ $DiscordBtn.BackColor = [System.Drawing.Color]::FromArgb(71, 82, 196) })
$DiscordBtn.Add_MouseLeave({ $DiscordBtn.BackColor = [System.Drawing.Color]::FromArgb(88, 101, 242) })
$DiscordBtn.Add_Click({ Start-Process "https://discord.gg/QEKNGfqdpu" })
$Form.Controls.Add($DiscordBtn)

# -------------------------------------------------------------------------
# GESTION DU CHANGEMENT DE LANGUE (TRADUCTION DE L'INTERFACE GUI)
# -------------------------------------------------------------------------
$LangCombo.Add_SelectedIndexChanged({
    if ($LangCombo.SelectedItem -eq "EN") {
        $Form.Text = "PC Update Assistant"
        $TitleLabel.Text = "PC UPDATE ASSISTANT"
        $GroupBox.Text = " Select components to process "
        $chkWU.Text = "Step 1: Windows Update & OS Drivers"
        $chkWinget.Text = "Step 2: Manual Selection of App Updates (Winget)"
        $chkNvidia.Text = "Step 3: NVIDIA Graphics Driver (Auto-detect)"
        $chkOffice.Text = "Step 4: Microsoft Office 365 (Update / Install + Activation)"
        $LogBtn.Text = "View Logs"
        $StartBtn.Text = "Start"
        $DiscordBtn.Text = "    Join us on Discord"
    } else {
        $Form.Text = "Assistant de mise $a_grave jour PC"
        $TitleLabel.Text = "ASSISTANT DE MISE $maj_a_grave JOUR PC"
        $GroupBox.Text = " S${e_aigu}lectionnez les composants ${a_grave} traiter "
        $chkWU.Text = "${maj_e_aigu}tape 1 : Windows Update & Pilotes OS"
        $chkWinget.Text = "${maj_e_aigu}tape 2 : S${e_aigu}lection manuelle des MAJ Applications (Winget)"
        $chkNvidia.Text = "${maj_e_aigu}tape 3 : Pilote Graphique NVIDIA (Automatique si pr${e_aigu}sent)"
        $chkOffice.Text = "${maj_e_aigu}tape 4 : Microsoft Office 365 (MAJ / Installation + Activation)"
        $LogBtn.Text = "Voir les Logs"
        $StartBtn.Text = "Lancer"
        $DiscordBtn.Text = "    Rejoins-nous sur Discord"
    }
})

# -------------------------------------------------------------------------
# FONCTION LOGS ET FENÊTRE SECONDAIRE WINGET
# -------------------------------------------------------------------------
function Append-ColoredLog ($TextBox, $Text) {
    $Color = [System.Drawing.Color]::White 
    if ($Text -match '^\[\*\]' -or $Text -match '^\[\d\]') { $Color = [System.Drawing.Color]::DeepSkyBlue }
    elseif ($Text -match '^ -> Succ' -or $Text -match '^ -> .*nettoy' -or $Text -match 'TERMIN' -or $Text -match '===' -or $Text -match 'pass' -or $Text -match 'annul' -or $Text -match 'activ') { $Color = [System.Drawing.Color]::LimeGreen }
    elseif ($Text -match '^ ->' -or $Text -match '^   ->' -or $Text -match '^ \[Pause\]') { $Color = [System.Drawing.Color]::LightGray }
    elseif ($Text -match '\[ERREUR\]' -or $Text -match '\[Attention\]' -or $Text -match '^ \! ') { $Color = [System.Drawing.Color]::OrangeRed }
    elseif ($Text -match '^   \[Choco\]') { $Color = [System.Drawing.Color]::Violet }

    $TextBox.SelectionStart = $TextBox.TextLength
    $TextBox.SelectionLength = 0
    $TextBox.SelectionColor = $Color
    $TextBox.AppendText($Text + "`r`n")
    $TextBox.SelectionColor = $TextBox.ForeColor 
    $TextBox.SelectionStart = $TextBox.TextLength
    $TextBox.ScrollToCaret()
}

$LogBtn.Add_Click({
    if (Test-Path $GlobalLogFile) {
        Start-Process notepad.exe -ArgumentList "`"$GlobalLogFile`""
    } else {
        $msg = if ($LangCombo.SelectedItem -eq "EN") { "No logs available yet." } else { "Aucun log disponible pour le moment." }
        [System.Windows.Forms.MessageBox]::Show($Form, $msg, "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

function Show-WingetSelectionForm ($AppList) {
    $SubForm = New-Object System.Windows.Forms.Form
    $SubForm.Text = if ($LangCombo.SelectedItem -eq "EN") { "Available Application Updates" } else { "Applications disponibles pour mise ${a_grave} jour" }
    $SubForm.Size = New-Object System.Drawing.Size(500, 450)
    $SubForm.StartPosition = "CenterParent"
    $SubForm.FormBorderStyle = "FixedDialog"
    $SubForm.MaximizeBox = $false
    $SubForm.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
    $SubForm.ForeColor = [System.Drawing.Color]::White

    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = if ($LangCombo.SelectedItem -eq "EN") { "Check apps to update:" } else { "Cochez les applications ${a_grave} mettre ${a_grave} jour :" }
    $Label.Location = New-Object System.Drawing.Point(15, 15)
    $Label.Size = New-Object System.Drawing.Size(450, 20)
    $Label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $SubForm.Controls.Add($Label)

    $Panel = New-Object System.Windows.Forms.Panel
    $Panel.Location = New-Object System.Drawing.Point(15, 45)
    $Panel.Size = New-Object System.Drawing.Size(450, 280)
    $Panel.AutoScroll = $true
    $Panel.BorderStyle = "FixedSingle"
    $SubForm.Controls.Add($Panel)

    $chkBoxes = @()
    $yPos = 10
    foreach ($app in $AppList) {
        $chk = New-Object System.Windows.Forms.CheckBox
        $chk.Text = $app.Name
        $chk.Tag = $app.Id
        $chk.Location = New-Object System.Drawing.Point(10, $yPos)
        $chk.Size = New-Object System.Drawing.Size(400, 25)
        $chk.Checked = $true
        $Panel.Controls.Add($chk)
        $chkBoxes += $chk
        $yPos += 30
    }

    $UpdateBtn = New-Object System.Windows.Forms.Button
    $UpdateBtn.Text = if ($LangCombo.SelectedItem -eq "EN") { "Update Selection" } else { "Mettre ${a_grave} jour la s${e_aigu}lection" }
    $UpdateBtn.Location = New-Object System.Drawing.Point(15, 350)
    $UpdateBtn.Size = New-Object System.Drawing.Size(210, 35)
    $UpdateBtn.BackColor = [System.Drawing.Color]::SeaGreen
    $UpdateBtn.FlatStyle = "Flat"
    $UpdateBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $UpdateBtn.Cursor = $ModernHandCursor
    $SubForm.Controls.Add($UpdateBtn)

    $CancelBtn = New-Object System.Windows.Forms.Button
    $CancelBtn.Text = if ($LangCombo.SelectedItem -eq "EN") { "Skip updates" } else { "Ne rien mettre ${a_grave} jour" }
    $CancelBtn.Location = New-Object System.Drawing.Point(255, 350)
    $CancelBtn.Size = New-Object System.Drawing.Size(210, 35)
    $CancelBtn.BackColor = [System.Drawing.Color]::Firebrick
    $CancelBtn.FlatStyle = "Flat"
    $CancelBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $CancelBtn.Cursor = $ModernHandCursor
    $SubForm.Controls.Add($CancelBtn)

    $SelectedIds = @()
    $script:actionChosen = "none"

    $UpdateBtn.Add_Click({
        foreach ($cb in $chkBoxes) { if ($cb.Checked) { $SelectedIds += $cb.Tag } }
        $script:actionChosen = "update"; $SubForm.Close()
    })
    $CancelBtn.Add_Click({ $script:actionChosen = "cancel"; $SubForm.Close() })

    $SubForm.ShowDialog() | Out-Null
    return @{ Action = $script:actionChosen; Ids = $SelectedIds }
}

# -------------------------------------------------------------------------
# THREAD ET LOGIQUE D'ARRIÈRE-PLAN
# -------------------------------------------------------------------------
$SharedData = [hashtable]::Synchronized(@{ Logs = [System.Collections.ArrayList]::new(); Progress = 0; Status = "Ready"; WingetApps = $null; WingetSelectionResult = $null; PromptResponse = "" })

$ScriptBlock = {
    param($SharedData, $Config, $Accents, $GlobalLogFile)
    function Log ($Msg) {
        $null = $SharedData.Logs.Add($Msg)
        try { $Msg | Add-Content -Path $GlobalLogFile -ErrorAction SilentlyContinue } catch {}
    }
    function Ask-Confirmation ($Title) {
        $SharedData.PromptResponse = "" ; $SharedData.Status = $Title
        while ($SharedData.Status -eq $Title) { Start-Sleep -Milliseconds 200 }
        return $SharedData.PromptResponse
    }

    try {
        $totalSteps = 1
        if ($Config.WU) { $totalSteps++ }
        if ($Config.Winget) { $totalSteps++ }
        if ($Config.Nvidia) { $totalSteps++ }
        if ($Config.Office) { $totalSteps++ }
        $currentStep = 0

        # --- LIBÉRATION SYSTEME GPO ---
        $currentStep++
        $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
        Log "[*] Lib$($Accents.e_aigu)ration syst$($Accents.e_grave)me des restrictions GPO pilotes..."
        $gpoPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
        if (-not (Test-Path $gpoPath)) { New-Item -Path $gpoPath -Force | Out-Null }
        Set-ItemProperty -Path $gpoPath -Name "DenyUnspecified" -Value 0 -Type DWord -ErrorAction SilentlyContinue
        gpupdate /force | Out-Null
        Log " -> Restrictions GPO nettoy$($Accents.e_aigu)es."

        # --- WINDOWS UPDATE ---
        if ($Config.WU) {
            $currentStep++
            $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
            Log "[1] Recherche et installation des mises $($Accents.a_grave) jour Windows Update..."
            Get-Service -Name wuauserv, bits, cryptsvc -ErrorAction SilentlyContinue | Start-Service -ErrorAction SilentlyContinue
            if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
                Install-Module -Name PSWindowsUpdate -Force -Repository PSGallery -Scope CurrentUser -AllowClobber -ErrorAction SilentlyContinue | Out-Null
            }
            Log " -> Analyse Windows Update lanc$($Accents.e_aigu)e (Patientez)..."
            Import-Module PSWindowsUpdate -Force
            try { $WUOutput = Get-WindowsUpdate -MicrosoftUpdate -Install -AcceptAll -IgnoreReboot -ErrorAction SilentlyContinue | Out-String; if ($WUOutput) { Log $WUOutput } } catch {}
            Log " -> Fin de l'analyse Windows Update."
        }

        # --- WINGET ---
        if ($Config.Winget) {
            $currentStep++
            $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
            Log "[2] Analyse des logiciels install$($Accents.e_aigu)s (Winget)..."
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                & winget source update | Out-Null
                $tempFile = Join-Path $env:TEMP "winget_runspace.txt"
                Start-Process winget -ArgumentList "upgrade" -RedirectStandardOutput $tempFile -NoNewWindow -Wait
                $apps = @()
                if (Test-Path $tempFile) {
                    $upgradeOutput = Get-Content $tempFile | Select-String -Pattern '-' -NotMatch
                    Remove-Item $tempFile -Force
                    foreach ($line in $upgradeOutput) {
                        $stringLine = $line.ToString()
                        if ($stringLine -match '\s+(winget|msstore)\s*$') {
                            $elements = $stringLine -split '\s{2,}' | Where-Object { $_.Trim() -ne '' }
                            if ($elements.Count -ge 3) { $apps += @{ Name = $elements[0].Trim(); Id = $elements[1].Trim() } }
                        }
                    }
                }
                if ($apps.Count -eq 0) { Log " -> Toutes les applications sont d$($Accents.e_aigu)j$($Accents.a_grave) $($Accents.a_grave) jour !" }
                else {
                    $SharedData.WingetApps = $apps; $SharedData.Status = "WingetPrompt"
                    while ($SharedData.Status -eq "WingetPrompt") { Start-Sleep -Milliseconds 200 }
                    $Result = $SharedData.WingetSelectionResult
                    if ($Result -and $Result.Action -eq "update" -and $Result.Ids.Count -gt 0) {
                        foreach ($id in $Result.Ids) { Log "   -> Mise $($Accents.a_grave) jour de : $id"; Start-Process winget -ArgumentList "upgrade --id $id --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait }
                    } else { Log " -> Aucune mise $($Accents.a_grave) jour applicative appliqu$($Accents.e_aigu)e." }
                }
            } else { Log " -> [Attention] L'outil 'winget' est introuvable." }
        }

        # --- NVIDIA ---
        if ($Config.Nvidia) {
            $currentStep++
            $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
            Log "[3] V$($Accents.e_aigu)rification du pilote graphique NVIDIA..."
            if (Get-CimInstance Win32_VideoController | Where-Object { $_.DriverProvider -like "*NVIDIA*" -or $_.Name -match "NVIDIA" }) {
                if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { $chocoScript = "iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex"; Invoke-Expression $chocoScript 6>$null 2>$null | Out-Null }
                $chocoLog = Join-Path $env:TEMP "choco_temp.log"
                Start-Process choco -ArgumentList "upgrade nvidia-display-driver -y --no-progress -r" -RedirectStandardOutput $chocoLog -NoNewWindow -Wait
                if (Test-Path $chocoLog) { Get-Content $chocoLog | ForEach-Object { Log "   [Choco] $_" }; Remove-Item $chocoLog -Force }
                Log " -> Traitement du pilote NVIDIA termin$($Accents.e_aigu)."
            } else { Log " -> Aucune carte graphique NVIDIA d$($Accents.e_aigu)tect$($Accents.e_aigu)e." }
        }

        # --- OFFICE 365 ---
        if ($Config.Office) {
            $currentStep++
            $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
            Log "[4] V$($Accents.e_aigu)rification de Microsoft Office 365..."
            $isOfficeInstalled = $null -ne (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe" -ErrorAction SilentlyContinue)
            if (-not $isOfficeInstalled) {
                Log " ! Microsoft 365 n'est pas install$($Accents.e_aigu) sur ce PC."
                $ReponseInstall = Ask-Confirmation -Title "PromptOfficeInstall"
                if ($ReponseInstall -eq "Yes") {
                    $urlOffice = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365AppsBasicRetail&platform=x64&language=fr-fr&version=O16GA"
                    $tempPathOffice = "$env:TEMP\Office365_setup.exe"
                    Start-Process -FilePath "curl.exe" -ArgumentList "-L", "-s", $urlOffice, "-o", $tempPathOffice -Wait -NoNewWindow
                    Start-Process -FilePath $tempPathOffice -ArgumentList "SETLANG=fr-fr" -NoNewWindow; Start-Sleep -Seconds 15
                    while (Get-Process -Name "OfficeC2RClient" -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 5 }
                    Remove-Item -Path $tempPathOffice -Force -ErrorAction SilentlyContinue
                    Log " -> L'installation de Microsoft Office 365 est termin$($Accents.e_aigu) !"
                    $ReponseAct = Ask-Confirmation -Title "PromptOfficeActivate"
                    if ($ReponseAct -eq "Yes") {
                        $tempPathActivation = "$env:TEMP\Activer_Office.cmd"
                        Start-Process -FilePath "curl.exe" -ArgumentList "-L", "-s", "https://raw.githubusercontent.com/Albambinou/automaj-pc/main/Activer_Office.cmd", "-o", $tempPathActivation -Wait -NoNewWindow
                        if (Test-Path $tempPathActivation) { Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "`"$tempPathActivation`"" -Wait; Remove-Item $tempPathActivation -Force }
                    }
                }
            } else {
                Log " -> Microsoft Office 365 est d$($Accents.e_aigu)j$($Accents.a_grave) install$($Accents.e_aigu) sur ce PC."
                $pathC2R = "C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe"
                if (Test-Path $pathC2R) { Start-Process -FilePath $pathC2R -ArgumentList "/update userenforce=true" -NoNewWindow; Log " -> Mises $($Accents.a_grave) jour Office trait$($Accents.e_aigu)es." }
            }
        }

        $SharedData.Progress = 100
        Log "`r`n=========================================================="
        Log "   TOUTES LES MISES $($Accents.maj_a_grave) JOUR SONT TERMIN$($Accents.maj_e_aigu)ES !"
        Log "=========================================================="
        $SharedData.Status = "Finished"
    } catch { Log "[ERREUR] : $_" ; $SharedData.Status = "Finished" }
}

# -------------------------------------------------------------------------
# HORLOGE SURVEILLANCE UI
# -------------------------------------------------------------------------
$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 100
$Timer.Add_Tick({
    if ($SharedData.Logs.Count -gt 0) {
        $LogsCopy = [System.Collections.ArrayList]::Adapter($SharedData.Logs.Clone()); $SharedData.Logs.Clear()
        foreach ($line in $LogsCopy) { Append-ColoredLog -TextBox $LogTextBox -Text $line }
    }
    $ProgressBar.Value = $SharedData.Progress

    if ($SharedData.Status -eq "WingetPrompt") {
        $Timer.Stop(); $AppObjects = @()
        foreach ($h in $SharedData.WingetApps) { $AppObjects += [PSCustomObject]$h }
        $Choice = Show-WingetSelectionForm -AppList $AppObjects
        $SharedData.WingetSelectionResult = $Choice; $SharedData.Status = "Running"; $Timer.Start()
    }
    if ($SharedData.Status -eq "PromptOfficeInstall") {
        $Timer.Stop()
        $msg = if ($LangCombo.SelectedItem -eq "EN") { "Microsoft Office 365 was not detected.`n`nDo you want to install Microsoft Office 365 Pro Suite?" } else { "Microsoft Office 365 n'est pas détecté sur cette machine.`n`nVoulez-vous installer la suite Microsoft Office 365 Pro ?" }
        $title = if ($LangCombo.SelectedItem -eq "EN") { "Office 365 Missing" } else { "Office 365 Introuvable" }
        $Rep = [System.Windows.Forms.MessageBox]::Show($Form, $msg, $title, [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
        $SharedData.PromptResponse = $Rep.ToString(); $SharedData.Status = "Running"; $Timer.Start()
    }
    if ($SharedData.Status -eq "PromptOfficeActivate") {
        $Timer.Stop()
        $msg = if ($LangCombo.SelectedItem -eq "EN") { "Installation complete.`n`nDo you want to run the activation script now?" } else { "L'installation est terminée.`n`nVoulez-vous lancer le script d'activation d'Office maintenant ?" }
        $Rep = [System.Windows.Forms.MessageBox]::Show($Form, $msg, "Activation", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
        $SharedData.PromptResponse = $Rep.ToString(); $SharedData.Status = "Running"; $Timer.Start()
    }
    if ($SharedData.Status -eq "Finished") {
        $Timer.Stop()
        $msg = if ($LangCombo.SelectedItem -eq "EN") { "Process complete." } else { "Le processus est termin${e_aigu}." }
        $title = if ($LangCombo.SelectedItem -eq "EN") { "Success" } else { "Succ${e_grave}s" }
        [System.Windows.Forms.MessageBox]::Show($Form, $msg, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $StartBtn.Enabled = $true; $GroupBox.Enabled = $true
        if ($script:PowerShellInstance) { $script:PowerShellInstance.EndInvoke($script:AsyncResult); $script:PowerShellInstance.Dispose(); $script:Runspace.Close(); $script:Runspace.Dispose() }
    }
})

# BOUTON LANCER
$StartBtn.Add_Click({
    $StartBtn.Enabled = $false; $GroupBox.Enabled = $false; $LogTextBox.Clear(); $ProgressBar.Value = 0
    $Config = @{ WU = $chkWU.Checked; Winget = $chkWinget.Checked; Nvidia = $chkNvidia.Checked; Office = $chkOffice.Checked }
    $Accents = @{ e_aigu = $e_aigu; a_grave = $a_grave; e_grave = $e_grave; u_grave = $u_grave; maj_e_aigu = $maj_e_aigu; maj_a_grave = $maj_a_grave }
    $SharedData.Progress = 0; $SharedData.Logs.Clear(); $SharedData.Status = "Running"

    $script:Runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
    $script:Runspace.Open()
    $script:PowerShellInstance = [System.Management.Automation.PowerShell]::Create()
    $script:PowerShellInstance.Runspace = $script:Runspace
    $script:PowerShellInstance.AddScript($ScriptBlock).AddArgument($SharedData).AddArgument($Config).AddArgument($Accents).AddArgument($GlobalLogFile) | Out-Null
    $script:AsyncResult = $script:PowerShellInstance.BeginInvoke()
    $Timer.Start()
    $msgLaunch = if ($LangCombo.SelectedItem -eq "EN") { "[!] Process started. Preparing environment..." } else { "[!] Processus lanc${e_aigu}. Pr${e_aigu}paration de l'environnement..." }
    Append-ColoredLog -TextBox $LogTextBox -Text $msgLaunch
})

# Lancement de la GUI
$Form.ShowDialog() | Out-Null