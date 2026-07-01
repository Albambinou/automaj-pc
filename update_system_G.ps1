# Forçage des protocoles réseau
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocolType::Tls12 -bor 12288

# Caractères accentués
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
# API NATIVES WINDOWS POUR LE MODE COMPOSITE (LAYERED) ET L'ACRYLIQUE
# -------------------------------------------------------------------------
$AcrylicSource = @"
using System;
using System.Runtime.InteropServices;

public class AcrylicBlur {
    [DllImport("user32.dll")]
    public static extern int SetWindowCompositionAttribute(IntPtr hwnd, ref WindowCompositionAttributeData data);

    [DllImport("user32.dll")]
    public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

    [DllImport("user32.dll")]
    public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

    public const int GWL_EXSTYLE = -20;
    public const int WS_EX_LAYERED = 0x80000;

    [StructLayout(LayoutKind.Sequential)]
    public struct WindowCompositionAttributeData {
        public WindowCompositionAttribute Attribute;
        public IntPtr Data;
        public int SizeOfData;
    }

    public enum WindowCompositionAttribute {
        WCA_ACCENT_POLICY = 19
    }

    public enum AccentState {
        ACCENT_DISABLED = 0,
        ACCENT_ENABLE_BLURBEHIND = 3,
        ACCENT_ENABLE_ACRYLICBLURBEHIND = 4
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct AccentPolicy {
        public AccentState AccentState;
        public int AccentFlags;
        public int GradientColor;
        public int AnimationId;
    }

    public static void EnableBlur(IntPtr hwnd) {
        int exStyle = GetWindowLong(hwnd, GWL_EXSTYLE);
        SetWindowLong(hwnd, GWL_EXSTYLE, exStyle | WS_EX_LAYERED);

        var policy = new AccentPolicy {
            AccentState = AccentState.ACCENT_ENABLE_ACRYLICBLURBEHIND,
            GradientColor = (45 << 24) | (10 & 0xFFFFFF)
        };

        var policySize = Marshal.SizeOf(policy);
        var policyPtr = Marshal.AllocHGlobal(policySize);
        Marshal.StructureToPtr(policy, policyPtr, false);

        var data = new WindowCompositionAttributeData {
            Attribute = WindowCompositionAttribute.WCA_ACCENT_POLICY,
            Data = policyPtr,
            SizeOfData = policySize
        };

        SetWindowCompositionAttribute(hwnd, ref data);
        Marshal.FreeHGlobal(policyPtr);
    }
}
"@
Add-Type -TypeDefinition $AcrylicSource

# Curseur moderne
$CursorSource = @"
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class ModernCursor {
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr LoadCursor(IntPtr hInstance, int lpCursorName);
    public static Cursor GetModernHand() {
        try { return new Cursor(LoadCursor(IntPtr.Zero, 32649)); } catch { return Cursors.Hand; }
    }
}
"@
Add-Type -TypeDefinition $CursorSource -ReferencedAssemblies "System.Windows.Forms.dll", "System.Drawing.dll"
$ModernHandCursor = [ModernCursor]::GetModernHand()

# -------------------------------------------------------------------------
# DESSIN AVANCÉ POUR BOUTONS ARRONDIS SANS INTERFÉRENCE SANS BUGS
# -------------------------------------------------------------------------
function Apply-ModernRoundedStyle ($Button, $HoverColor, $Radius = 12) {
    $Button.FlatStyle = "Flat"
    $Button.FlatAppearance.BorderSize = 0
    $Button.FlatAppearance.CheckedBackColor = [System.Drawing.Color]::Transparent
    $Button.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::Transparent
    $Button.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::Transparent
    $Button.BackColor = [System.Drawing.Color]::Transparent
    
    $btnText = $Button.Text
    if ($btnText.Trim() -ne "") { $Button.Text = " " }
    
    $Button | Add-Member -MemberType NoteProperty -Name "BtnText" -Value $btnText -Force
    $Button | Add-Member -MemberType NoteProperty -Name "IsHovered" -Value $false -Force
    $Button | Add-Member -MemberType NoteProperty -Name "DefaultColor" -Value [System.Drawing.Color]::FromArgb(40, 25, 25, 25) -Force
    $Button | Add-Member -MemberType NoteProperty -Name "HoverColor" -Value $HoverColor -Force

    $Button.Add_MouseEnter({ $this.IsHovered = $true; $this.Invalidate() })
    $Button.Add_MouseLeave({ $this.IsHovered = $false; $this.Invalidate() })

    $Button.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        
        $rect = New-Object System.Drawing.RectangleF(1, 1, ($sender.Width - 3), ($sender.Height - 3))
        $path = New-Object System.Drawing.Drawing2D.GraphicsPath
        $d = $Radius * 2
        
        $path.AddArc($rect.X, $rect.Y, $d, $d, 180, 90)
        $path.AddArc(($rect.Right - $d), $rect.Y, $d, $d, 270, 90)
        $path.AddArc(($rect.Right - $d), ($rect.Bottom - $d), $d, $d, 0, 90)
        $path.AddArc($rect.X, ($rect.Bottom - $d), $d, $d, 90, 90)
        $path.CloseFigure()

        $bgAlphaColor = if ($sender.IsHovered) { $sender.HoverColor } else { $sender.DefaultColor }
        if (-not $sender.Enabled) { $bgAlphaColor = [System.Drawing.Color]::FromArgb(15, 70, 70, 70) }
        
        $brush = New-Object System.Drawing.SolidBrush($bgAlphaColor)
        $g.FillPath($brush, $path)
        
        $borderColor = if ($sender.IsHovered) { $sender.HoverColor } else { [System.Drawing.Color]::FromArgb(70, 255, 255, 255) }
        if (-not $sender.Enabled) { $borderColor = [System.Drawing.Color]::FromArgb(30, 255, 255, 255) }
        $pen = New-Object System.Drawing.Pen($borderColor, 1.5)
        $g.DrawPath($pen, $path)
        
        $flags = [System.Windows.Forms.TextFormatFlags]::HorizontalCenter -bor [System.Windows.Forms.TextFormatFlags]::VerticalCenter
        $textColor = if ($sender.Enabled) { $sender.ForeColor } else { [System.Drawing.Color]::FromArgb(100, 255, 255, 255) }
        [System.Windows.Forms.TextRenderer]::DrawText($g, $sender.BtnText, $sender.Font, [System.Drawing.Rectangle]::Ceiling($rect), $textColor, $flags)
    })
}

# -------------------------------------------------------------------------
# FENÊTRE PRINCIPALE
# -------------------------------------------------------------------------
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Assistant de mise $a_grave jour PC"
$Form.Size = New-Object System.Drawing.Size(650, 615)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.BackColor = [System.Drawing.Color]::Black 

$Form.Add_HandleCreated({
    [AcrylicBlur]::EnableBlur($this.Handle)
})

# Titre principal
$TitleLabel = New-Object System.Windows.Forms.Label
$TitleLabel.Text = "ASSISTANT DE MISE $maj_a_grave JOUR PC"
$TitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$TitleLabel.Size = New-Object System.Drawing.Size(400, 40)
$TitleLabel.Location = New-Object System.Drawing.Point(20, 15)
$TitleLabel.BackColor = [System.Drawing.Color]::Transparent
$TitleLabel.ForeColor = [System.Drawing.Color]::DeepSkyBlue
$Form.Controls.Add($TitleLabel)

# Sélection de la Langue
$LangLabel = New-Object System.Windows.Forms.Label
$LangLabel.Text = "Langue / Language :"
$LangLabel.Location = New-Object System.Drawing.Point(430, 18)
$LangLabel.Size = New-Object System.Drawing.Size(110, 20)
$LangLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
$LangLabel.BackColor = [System.Drawing.Color]::Transparent
$LangLabel.ForeColor = [System.Drawing.Color]::LightGray
$Form.Controls.Add($LangLabel)

$LangCombo = New-Object System.Windows.Forms.ComboBox
$LangCombo.Location = New-Object System.Drawing.Point(540, 15)
$LangCombo.Size = New-Object System.Drawing.Size(70, 25)
$LangCombo.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$LangCombo.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$LangCombo.ForeColor = [System.Drawing.Color]::White
$null = $LangCombo.Items.Add("FR")
$null = $LangCombo.Items.Add("EN")
$LangCombo.SelectedIndex = 0
$Form.Controls.Add($LangCombo)

# Groupe de Checkboxes
$GroupBox = New-Object System.Windows.Forms.GroupBox
$GroupBox.Text = " S${e_aigu}lectionnez les composants ${a_grave} traiter "
$GroupBox.Size = New-Object System.Drawing.Size(590, 150)
$GroupBox.Location = New-Object System.Drawing.Point(20, 65)
$GroupBox.BackColor = [System.Drawing.Color]::Transparent
$GroupBox.ForeColor = [System.Drawing.Color]::LightGray
$Form.Controls.Add($GroupBox)

$chkWU = New-Object System.Windows.Forms.CheckBox
$chkWU.Text = "${maj_e_aigu}tape 1 : Windows Update & Pilotes OS"
$chkWU.Location = New-Object System.Drawing.Point(20, 30)
$chkWU.Size = New-Object System.Drawing.Size(540, 25)
$chkWU.BackColor = [System.Drawing.Color]::Transparent
$chkWU.ForeColor = [System.Drawing.Color]::White
$chkWU.Checked = $true
$GroupBox.Controls.Add($chkWU)

$chkWinget = New-Object System.Windows.Forms.CheckBox
$chkWinget.Text = "${maj_e_aigu}tape 2 : S${e_aigu}lection manuelle des MAJ Applications (Winget)"
$chkWinget.Location = New-Object System.Drawing.Point(20, 60)
$chkWinget.Size = New-Object System.Drawing.Size(540, 25)
$chkWinget.BackColor = [System.Drawing.Color]::Transparent
$chkWinget.ForeColor = [System.Drawing.Color]::White
$chkWinget.Checked = $true
$GroupBox.Controls.Add($chkWinget)

$chkNvidia = New-Object System.Windows.Forms.CheckBox
$chkNvidia.Text = "${maj_e_aigu}tape 3 : Pilote Graphique NVIDIA (Automatique si pr${e_aigu}sent)"
$chkNvidia.Location = New-Object System.Drawing.Point(20, 90)
$chkNvidia.Size = New-Object System.Drawing.Size(540, 25)
$chkNvidia.BackColor = [System.Drawing.Color]::Transparent
$chkNvidia.ForeColor = [System.Drawing.Color]::White
$chkNvidia.Checked = $true
$GroupBox.Controls.Add($chkNvidia)

$chkOffice = New-Object System.Windows.Forms.CheckBox
$chkOffice.Text = "${maj_e_aigu}tape 4 : Microsoft Office 365 (MAJ / Installation + Activation)"
$chkOffice.Location = New-Object System.Drawing.Point(20, 120)
$chkOffice.Size = New-Object System.Drawing.Size(540, 25)
$chkOffice.BackColor = [System.Drawing.Color]::Transparent
$chkOffice.ForeColor = [System.Drawing.Color]::White
$chkOffice.Checked = $true
$GroupBox.Controls.Add($chkOffice)

# Barre de progression
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = New-Object System.Drawing.Point(20, 230)
$ProgressBar.Size = New-Object System.Drawing.Size(210, 30)
$ProgressBar.Style = "Continuous"
$Form.Controls.Add($ProgressBar)

# Bouton Voir les Logs
$LogBtn = New-Object System.Windows.Forms.Button
$LogBtn.Text = "Voir les Logs"
$LogBtn.Location = New-Object System.Drawing.Point(245, 230)
$LogBtn.Size = New-Object System.Drawing.Size(115, 30)
$LogBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$LogBtn.ForeColor = [System.Drawing.Color]::White
$LogBtn.Cursor = $ModernHandCursor
Apply-ModernRoundedStyle $LogBtn ([System.Drawing.Color]::FromArgb(150, 30, 144, 255)) 
$Form.Controls.Add($LogBtn)

# Bouton Lancer
$StartBtn = New-Object System.Windows.Forms.Button
$StartBtn.Text = "Lancer"
$StartBtn.Location = New-Object System.Drawing.Point(370, 230)
$StartBtn.Size = New-Object System.Drawing.Size(115, 30)
$StartBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$StartBtn.ForeColor = [System.Drawing.Color]::White
$StartBtn.Cursor = $ModernHandCursor
Apply-ModernRoundedStyle $StartBtn ([System.Drawing.Color]::FromArgb(150, 46, 139, 87)) 
$Form.Controls.Add($StartBtn)

# Bouton Arrêter
$StopBtn = New-Object System.Windows.Forms.Button
$StopBtn.Text = "Arr${e_grave}ter"
$StopBtn.Location = New-Object System.Drawing.Point(495, 230)
$StopBtn.Size = New-Object System.Drawing.Size(115, 30)
$StopBtn.ForeColor = [System.Drawing.Color]::White
$StopBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$StopBtn.Cursor = $ModernHandCursor
$StopBtn.Enabled = $false
Apply-ModernRoundedStyle $StopBtn ([System.Drawing.Color]::FromArgb(150, 178, 34, 34)) 
$Form.Controls.Add($StopBtn)

# ZONE DE LOGS
$LogTextBox = New-Object System.Windows.Forms.RichTextBox
$LogTextBox.Size = New-Object System.Drawing.Size(590, 240)
$LogTextBox.Location = New-Object System.Drawing.Point(20, 275)
$LogTextBox.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
$LogTextBox.ForeColor = [System.Drawing.Color]::White
$LogTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$LogTextBox.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$LogTextBox.ReadOnly = $true
$LogTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
$Form.Controls.Add($LogTextBox)

# Encadrement fin décoratif pour le log style Fluent
$LogPanel = New-Object System.Windows.Forms.Panel
$LogPanel.Size = New-Object System.Drawing.Size(594, 244)
$LogPanel.Location = New-Object System.Drawing.Point(18, 273)
$LogPanel.BackColor = [System.Drawing.Color]::FromArgb(60, 255, 255, 255)
$Form.Controls.Add($LogPanel)
$LogPanel.Controls.Add($LogTextBox)
$LogTextBox.Location = New-Object System.Drawing.Point(2, 2)
$LogTextBox.Size = New-Object System.Drawing.Size(590, 240)

# Bouton Discord
$DiscordBtn = New-Object System.Windows.Forms.Button
$DiscordBtn.Size = New-Object System.Drawing.Size(220, 36)
$DiscordBtn.Location = New-Object System.Drawing.Point(205, 528)
$DiscordBtn.ForeColor = [System.Drawing.Color]::White
$DiscordBtn.Text = "      Rejoins-nous sur Discord"
$DiscordBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$DiscordBtn.Cursor = $ModernHandCursor
Apply-ModernRoundedStyle $DiscordBtn ([System.Drawing.Color]::FromArgb(150, 88, 101, 242))

$DiscordBtn.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics; $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $xOff = 15; $yOff = 10
    $points = @(
        (New-Object System.Drawing.PointF($xOff + 3.9, $yOff + 1.2)),(New-Object System.Drawing.PointF($xOff + 5.1, $yOff + 3.1)),
        (New-Object System.Drawing.PointF($xOff + 7.8, $yOff + 2.5)),(New-Object System.Drawing.PointF($xOff + 8.4, $yOff + 1.7)),
        (New-Object System.Drawing.PointF($xOff + 11.1, $yOff + 1.7)),(New-Object System.Drawing.PointF($xOff + 11.7, $yOff + 2.5)),
        (New-Object System.Drawing.PointF($xOff + 14.4, $yOff + 3.1)),(New-Object System.Drawing.PointF($xOff + 15.6, $yOff + 1.2)),
        (New-Object System.Drawing.PointF($xOff + 17.5, $yOff + 4.2)),(New-Object System.Drawing.PointF($xOff + 19.5, $yOff + 11.0)),
        (New-Object System.Drawing.PointF($xOff + 16.5, $yOff + 14.5)),(New-Object System.Drawing.PointF($xOff + 14.8, $yOff + 12.5)),
        (New-Object System.Drawing.PointF($xOff + 16.3, $yOff + 11.2)),(New-Object System.Drawing.PointF($xOff + 15.1, $yOff + 10.3)),
        (New-Object System.Drawing.PointF($xOff + 11.5, $yOff + 11.5)),(New-Object System.Drawing.PointF($xOff + 8.0, $yOff + 11.5)),
        (New-Object System.Drawing.PointF($xOff + 4.4, $yOff + 10.3)),(New-Object System.Drawing.PointF($xOff + 3.2, $yOff + 11.2)),
        (New-Object System.Drawing.PointF($xOff + 4.7, $yOff + 12.5)),(New-Object System.Drawing.PointF($xOff + 3.0, $yOff + 14.5)),
        (New-Object System.Drawing.PointF($xOff + 0.0, $yOff + 11.0)),(New-Object System.Drawing.PointF($xOff + 2.0, $yOff + 4.2))
    )
    $g.FillPolygon($brush, $points)
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 20, 20, 20))
    $g.FillEllipse($bgBrush, ($xOff + 5.5), ($yOff + 6.0), 2.5, 2.5)
    $g.FillEllipse($bgBrush, ($xOff + 11.5), ($yOff + 6.0), 2.5, 2.5)
})
$DiscordBtn.Add_Click({ Start-Process "https://discord.gg/QEKNGfqdpu" })
$Form.Controls.Add($DiscordBtn)

# -------------------------------------------------------------------------
# GESTION DES TRADUCTIONS GUI
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
        $LogBtn.BtnText = "View Logs"
        $StartBtn.BtnText = "Start"
        $StopBtn.BtnText = "Stop"
        $DiscordBtn.BtnText = "      Join us on Discord"
    } else {
        $Form.Text = "Assistant de mise $a_grave jour PC"
        $TitleLabel.Text = "ASSISTANT DE MISE $maj_a_grave JOUR PC"
        $GroupBox.Text = " S${e_aigu}lectionnez les composants ${a_grave} traiter "
        $chkWU.Text = "${maj_e_aigu}tape 1 : Windows Update & Pilotes OS"
        $chkWinget.Text = "${maj_e_aigu}tape 2 : S${e_aigu}lection manuelle des MAJ Applications (Winget)"
        $chkNvidia.Text = "${maj_e_aigu}tape 3 : Pilote Graphique NVIDIA (Automatique si pr${e_aigu}sent)"
        $chkOffice.Text = "${maj_e_aigu}tape 4 : Microsoft Office 365 (MAJ / Installation + Activation)"
        $LogBtn.BtnText = "Voir les Logs"
        $StartBtn.BtnText = "Lancer"
        $StopBtn.BtnText = "Arr${e_grave}ter"
        $DiscordBtn.BtnText = "      Rejoins-nous sur Discord"
    }
    $Form.Invalidate()
})

# -------------------------------------------------------------------------
# COULEURS DES LOGS ET INTERFACES DIVERSES
# -------------------------------------------------------------------------
function Append-ColoredLog ($TextBox, $Text) {
    $Color = [System.Drawing.Color]::White 
    if ($Text -match '^\[\*\]' -or $Text -match '^\[\d\]') { $Color = [System.Drawing.Color]::DeepSkyBlue }
    elseif ($Text -match '^ -> Succ' -or $Text -match '^ -> .*nettoy' -or $Text -match 'TERMIN' -or $Text -match '===' -or $Text -match 'pass' -or $Text -match 'annul' -or $Text -match 'activ') { $Color = [System.Drawing.Color]::LimeGreen }
    elseif ($Text -match '^ ->' -or $Text -match '^   ->' -or $Text -match '^ \[Pause\]') { $Color = [System.Drawing.Color]::LightGray }
    elseif ($Text -match '\[ERREUR\]' -or $Text -match '\[Attention\]' -or $Text -match '^ \! ' -or $Text -match 'STOP') { $Color = [System.Drawing.Color]::OrangeRed }

    $TextBox.SelectionStart = $TextBox.TextLength
    $TextBox.SelectionLength = 0
    $TextBox.SelectionColor = $Color
    $TextBox.AppendText($Text + "`r`n")
    $TextBox.SelectionColor = $TextBox.ForeColor 
    $TextBox.SelectionStart = $TextBox.TextLength
    $TextBox.ScrollToCaret()
}

$LogBtn.Add_Click({
    if (Test-Path $GlobalLogFile) { Start-Process notepad.exe -ArgumentList "`"$GlobalLogFile`"" } 
    else {
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
    $SubForm.BackColor = [System.Drawing.Color]::Black
    
    $SubForm.Add_HandleCreated({ [AcrylicBlur]::EnableBlur($this.Handle) })

    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = if ($LangCombo.SelectedItem -eq "EN") { "Check apps to update:" } else { "Cochez les applications ${a_grave} mettre ${a_grave} jour :" }
    $Label.Location = New-Object System.Drawing.Point(15, 15); $Label.Size = New-Object System.Drawing.Size(450, 20); $Label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $Label.BackColor = [System.Drawing.Color]::Transparent
    $Label.ForeColor = [System.Drawing.Color]::White
    $SubForm.Controls.Add($Label)

    $Panel = New-Object System.Windows.Forms.Panel
    $Panel.Location = New-Object System.Drawing.Point(15, 45); $Panel.Size = New-Object System.Drawing.Size(450, 280); $Panel.AutoScroll = $true; $Panel.BorderStyle = "FixedSingle"
    $Panel.BackColor = [System.Drawing.Color]::Transparent
    $SubForm.Controls.Add($Panel)

    $chkBoxes = @()
    $yPos = 10
    foreach ($app in $AppList) {
        $chk = New-Object System.Windows.Forms.CheckBox; $chk.Text = $app.Name; $chk.Tag = $app.Id; $chk.Location = New-Object System.Drawing.Point(10, $yPos); $chk.Size = New-Object System.Drawing.Size(400, 25); $chk.Checked = $true
        $chk.BackColor = [System.Drawing.Color]::Transparent; $chk.ForeColor = [System.Drawing.Color]::White
        $Panel.Controls.Add($chk); $chkBoxes += $chk; $yPos += 30
    }

    # --- BOUTON VALIDER ---
    $UpdateBtn = New-Object System.Windows.Forms.Button
    $UpdateBtn.Location = New-Object System.Drawing.Point(15, 350); $UpdateBtn.Size = New-Object System.Drawing.Size(210, 35); $UpdateBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold); $UpdateBtn.Cursor = $ModernHandCursor
    $UpdateBtn.ForeColor = [System.Drawing.Color]::White
    $UpdateBtn.Text = if ($LangCombo.SelectedItem -eq "EN") { "Update Selection" } else { "Mettre ${a_grave} jour la s${e_aigu}lection" }
    Apply-ModernRoundedStyle $UpdateBtn ([System.Drawing.Color]::FromArgb(150, 46, 139, 87))
    $SubForm.Controls.Add($UpdateBtn)

    # --- BOUTON ANNULER ---
    $CancelBtn = New-Object System.Windows.Forms.Button
    $CancelBtn.Location = New-Object System.Drawing.Point(255, 350); $CancelBtn.Size = New-Object System.Drawing.Size(210, 35); $CancelBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold); $CancelBtn.Cursor = $ModernHandCursor
    $CancelBtn.ForeColor = [System.Drawing.Color]::White
    $CancelBtn.Text = if ($LangCombo.SelectedItem -eq "EN") { "Skip updates" } else { "Ne rien mettre ${a_grave} jour" }
    Apply-ModernRoundedStyle $CancelBtn ([System.Drawing.Color]::FromArgb(150, 178, 34, 34))
    $SubForm.Controls.Add($CancelBtn)

    # --- ACTIONS CLICS ---
    $UpdateBtn.Add_Click({ 
        $SelectedIds = New-Object System.Collections.ArrayList
        foreach ($cb in $chkBoxes) { if ($cb.Checked) { $null = $SelectedIds.Add($cb.Tag) } }
        $SharedData.WingetSelectionResult = $SelectedIds
        $SharedData.PromptResponse = "update"
        $SubForm.Close() 
    })
    
    $CancelBtn.Add_Click({ 
        $SharedData.PromptResponse = "cancel"
        $SubForm.Close() 
    })
    
    $SubForm.ShowDialog() | Out-Null
}

# -------------------------------------------------------------------------
# THREAD RUNSPACE (SCRIPT DE TRAITEMENT PRINCIPAL COMPLETÉ)
# -------------------------------------------------------------------------
$SharedData = [hashtable]::Synchronized(@{ Logs = [System.Collections.ArrayList]::new(); Progress = 0; Status = "Ready"; WingetApps = $null; WingetSelectionResult = $null; PromptResponse = "" })

$ScriptBlock = {
    param($SharedData, $Config, $Accents, $GlobalLogFile)
    function Log ($Msg) {
        $null = $SharedData.Logs.Add($Msg)
        try { $Msg | Add-Content -Path $GlobalLogFile -ErrorAction SilentlyContinue } catch {}
    }
    function Ask-Confirmation ($Title) {
        $SharedData.PromptResponse = ""; $SharedData.Status = $Title
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

        # --- GPO UNLOCK ---
        $currentStep++
        $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
        Log "[*] Lib$($Accents.e_aigu)ration du syst$($Accents.e_grave)me des restrictions GPO..."
        $gpoPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
        if (-not (Test-Path $gpoPath)) { New-Item -Path $gpoPath -Force | Out-Null }
        Set-ItemProperty -Path $gpoPath -Name "DenyUnspecified" -Value 0 -Type DWord -ErrorAction SilentlyContinue
        gpupdate /force | Out-Null

        # --- WINDOWS UPDATE ---
        if ($Config.WU) {
            $currentStep++
            $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
            Log "[1] Recherche et installation Windows Update..."
            Get-Service -Name wuauserv, bits, cryptsvc -ErrorAction SilentlyContinue | Start-Service -ErrorAction SilentlyContinue
            if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
                Install-Module -Name PSWindowsUpdate -Force -Repository PSGallery -Scope CurrentUser -AllowClobber -ErrorAction SilentlyContinue | Out-Null
            }
            Import-Module PSWindowsUpdate -Force
            try { $WUOutput = Get-WindowsUpdate -MicrosoftUpdate -Install -AcceptAll -IgnoreReboot -ErrorAction SilentlyContinue | Out-String; if ($WUOutput) { Log $WUOutput } } catch {}
        }

        # --- WINGET ---
        if ($Config.Winget) {
            $currentStep++
            $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
            Log "[2] Analyse des applications (Winget)..."
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                & winget source update | Out-Null
                $tempFile = Join-Path $env:TEMP "winget_runspace.txt"
                
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
                    $retry = 0
                    while ($retry -lt 10) {
                        try {
                            $fileStream = [System.IO.File]::Open($tempFile, 'Open', 'Read', 'None')
                            $fileStream.Close()
                            break
                        } catch {
                            Start-Sleep -Milliseconds 200
                            $retry++
                        }
                    }

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
                if ($apps.Count -eq 0) { Log " -> Tout est $($Accents.a_grave) jour !" }
                else {
                    $SharedData.WingetApps = $apps; $SharedData.Status = "WingetPrompt"
                    while ($SharedData.Status -eq "WingetPrompt") { Start-Sleep -Milliseconds 200 }
                    
                    $Action = $SharedData.PromptResponse
                    $SelectedIds = $SharedData.WingetSelectionResult
                    
                    if ($Action -eq "update" -and $SelectedIds -and $SelectedIds.Count -gt 0) {
                        foreach ($id in $SelectedIds) { 
                            Log "   -> MAJ : $id"
                            $psiApps = New-Object System.Diagnostics.ProcessStartInfo
                            $psiApps.FileName = "powershell.exe"
                            $psiApps.Arguments = "-NoProfile -Command `"echo Y | winget upgrade --id $id --accept-package-agreements --accept-source-agreements`""
                            $psiApps.UseShellExecute = $false
                            $psiApps.CreateNoWindow = $true
                            $procApps = [System.Diagnostics.Process]::Start($psiApps)
                            $procApps.WaitForExit()
                            $procApps.Close()
                        }
                    } else {
                        Log " -> S$($Accents.e_aigu)lection annul$($Accents.e_aigu)ee, aucune application mise $($Accents.a_grave) jour."
                    }
                }
            }
        }

        # --- NVIDIA ---
        if ($Config.Nvidia) {
            $currentStep++
            $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
            Log "[3] V$($Accents.e_aigu)rification pilote NVIDIA..."
            if (Get-CimInstance Win32_VideoController | Where-Object { $_.DriverProvider -like "*NVIDIA*" -or $_.Name -match "NVIDIA" }) {
                if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { $chocoScript = "iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex"; Invoke-Expression $chocoScript 6>$null 2>$null | Out-Null }
                $chocoLog = Join-Path $env:TEMP "choco_temp.log"
                Start-Process choco -ArgumentList "upgrade nvidia-display-driver -y --no-progress -r" -RedirectStandardOutput $chocoLog -NoNewWindow -Wait
                if (Test-Path $chocoLog) { Get-Content $chocoLog | ForEach-Object { Log "   [Choco] $_" }; Remove-Item $chocoLog -Force }
            }
        }

        # --- OFFICE 365 BIEN DÉTECTÉ (REGISTRE) + ACTIVATION PAR DSTATUS ---
        if ($Config.Office) {
            $currentStep++
            $SharedData.Progress = [math]::Round(($currentStep / $totalSteps) * 100)
            Log "[4] V$($Accents.e_aigu)rification de Microsoft Office..."
            
            # DÉTECTION ROBUSTE : On vérifie si Word est enregistré dans le système
            $isOfficeInstalled = $null -ne (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\winword.exe" -ErrorAction SilentlyContinue)
            
            # On cherche quand même le chemin pour l'activation KMS au cas où
            $officePath = "C:\Program Files\Microsoft Office\Office16"
            if (-not (Test-Path $officePath)) { $officePath = "C:\Program Files (x86)\Microsoft Office\Office16" }

            if (-not $isOfficeInstalled) {
                # --- CAS 1 : OFFICE N'EST PAS INSTALLÉ ---
                $ReponseInstall = Ask-Confirmation -Title "PromptOfficeInstall"
                if ($ReponseInstall -eq "Yes") {
                    $urlOffice = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365AppsBasicRetail&platform=x64&language=fr-fr&version=O16GA"
                    $tempPathOffice = "$env:TEMP\Office365_setup.exe"
                    Start-Process -FilePath "curl.exe" -ArgumentList "-L", "-s", $urlOffice, "-o", $tempPathOffice -Wait -NoNewWindow
                    Start-Process -FilePath $tempPathOffice -ArgumentList "SETLANG=fr-fr" -NoNewWindow; Start-Sleep -Seconds 15
                    while (Get-Process -Name "OfficeC2RClient" -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 5 }
                    Remove-Item -Path $tempPathOffice -Force -ErrorAction SilentlyContinue
                    
                    # On recalcule le chemin après la nouvelle installation
                    if (-not (Test-Path $officePath)) { $officePath = "C:\Program Files (x86)\Microsoft Office\Office16" }
                    
                    $ReponseAct = Ask-Confirmation -Title "PromptOfficeActivate"
                    if ($ReponseAct -eq "Yes" -and (Test-Path "$officePath\ospp.vbs")) {
                        Log "   -> Activation d'Office en cours..."
                        $cmds = @(
                            "cscript //nologo `"$officePath\ospp.vbs`" /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99",
                            "cscript //nologo `"$officePath\ospp.vbs`" /sethst:kms8.msguides.com",
                            "cscript //nologo `"$officePath\ospp.vbs`" /act"
                        )
                        foreach ($cmd in $cmds) { Start-Process cmd.exe -ArgumentList "/c $cmd" -Wait -NoNewWindow }
                        Log "   -> Activation termin$($Accents.e_aigu)e."
                    }
                }
            } else {
                # --- CAS 2 : OFFICE EST BIEN INSTALLÉ -> ON VÉRIFIE L'ACTIVATION ---
                Log "   -> Office pr$($Accents.e_aigu)sent sur la machine. V$($Accents.e_aigu)rification de la licence..."
                
                if (Test-Path "$officePath\ospp.vbs") {
                    $statusOutput = cscript //nologo "$officePath\ospp.vbs" /dstatus 2>&1 | Out-String
                    
                    if ($statusOutput -notmatch "LICENSE STATUS:\s+--- LICENSED ---" -or $statusOutput -match "LICENSE STATUS:\s+--- OOB_GRACE ---|--- NOTIFICATION ---|--- UNLICENSED ---") {
                        Log " -> [Attention] Office est install$($Accents.e_aigu) mais n'est PAS activ$($Accents.e_aigu) !"
                        Log "   -> Lancement automatique de l'activation KMS..."
                        $cmds = @(
                            "cscript //nologo `"$officePath\ospp.vbs`" /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99",
                            "cscript //nologo `"$officePath\ospp.vbs`" /sethst:kms8.msguides.com",
                            "cscript //nologo `"$officePath\ospp.vbs`" /act"
                        )
                        foreach ($cmd in $cmds) { Start-Process cmd.exe -ArgumentList "/c $cmd" -Wait -NoNewWindow }
                        Log " -> Succ$($Accents.e_grave)s : Activation forc$($Accents.e_aigu)e termin$($Accents.e_aigu)e."
                    } else {
                        Log " -> Succ$($Accents.e_grave)s : Office est d$($Accents.e_aigu)j$($Accents.a_grave) activ$($Accents.e_aigu)."
                    }
                } else {
                    Log "   -> [Info] Impossible de tester la licence (ospp.vbs absent), recherche des mises $($Accents.a_grave) jour..."
                }

                # Recherche classique des mises à jour d'Office
                $pathC2R = "C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe"
                if (Test-Path $pathC2R) { Start-Process -FilePath $pathC2R -ArgumentList "/update userenforce=true" -NoNewWindow }
            }
        }

        $SharedData.Progress = 100
        Log "`r`n=========================================================="
        Log "   TOUTES LES MISES $($Accents.maj_a_grave) JOUR SONT TERMIN$($Accents.maj_e_aigu)ES !"
        Log "=========================================================="
        $SharedData.Status = "Finished"
    } catch { 
        Log "[ERREUR] : $_"
        $SharedData.Status = "Finished" 
    }
}

# -------------------------------------------------------------------------
# HORLOGE SURVEILLANCE UI (RAFRAÎCHISSEMENT ET POP-UPS)
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
        Show-WingetSelectionForm -AppList $AppObjects
        $SharedData.Status = "Running"; $Timer.Start()
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
        
        # Restauration interface
        $StartBtn.Enabled = $true; $GroupBox.Enabled = $true; $StopBtn.Enabled = $false
        $Form.Invalidate()
        if ($script:PowerShellInstance) { $script:PowerShellInstance.EndInvoke($script:AsyncResult); $script:PowerShellInstance.Dispose(); $script:Runspace.Close(); $script:Runspace.Dispose() }
    }
})

# -------------------------------------------------------------------------
# LOGIQUE DES BOUTONS (LANCER ET ARRÊTER)
# -------------------------------------------------------------------------
$StartBtn.Add_Click({
    $StartBtn.Enabled = $false; $GroupBox.Enabled = $false; $StopBtn.Enabled = $true; $LogTextBox.Clear(); $ProgressBar.Value = 0
    $Form.Invalidate()
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

$StopBtn.Add_Click({
    $Timer.Stop()
    $msgStop = if ($LangCombo.SelectedItem -eq "EN") { "[STOP] Process forcefully interrupted by user." } else { "[STOP] Processus interrompu de force par l'utilisateur." }
    Append-ColoredLog -TextBox $LogTextBox -Text "`r`n$msgStop"
    
    if ($script:PowerShellInstance) {
        try {
            $script:PowerShellInstance.Stop()
            $script:PowerShellInstance.Dispose()
            $script:Runspace.Close()
            $script:Runspace.Dispose()
        } catch {}
    }
    
    $StartBtn.Enabled = $true
    $GroupBox.Enabled = $true
    $StopBtn.Enabled = $false
    $ProgressBar.Value = 0
    $Form.Invalidate()
})

# Lancement de l'application
$Form.ShowDialog() | Out-Null
