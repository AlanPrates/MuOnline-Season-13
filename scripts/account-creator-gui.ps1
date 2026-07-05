#Requires -Version 5.1
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$md5hashExe = Join-Path $ScriptDir "..\Tools\md5hash\md5hash.exe"
$dbServer = ".\SQLEXPRESS"; $dbName = "MuOnline"
$color = @{ bg = "#0D0D1A"; panel = "#12122A"; input = "#1A1A2E"; border = "#2D2D50"
            fg = "#E0E0F0"; label = "#AAAACC"; dim = "#8888AA"; title = "#9B59B6"
            accent = "#6C3483"; success = "#27AE60"; warn = "#E67E22"; hover = "#3D3D70" }

function Get-MD5Hash { param([string]$Account, [string]$Password)
    $r = & "$md5hashExe" $Account $Password 2>&1
    if ($LASTEXITCODE -ne 0 -or -not $r) { throw "md5hash.exe failed: $r" }
    return $r.Trim() }

function Test-AccountExists { param([string]$AccountId)
    $r = sqlcmd -S $dbServer -E -d $dbName -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM MEMB_INFO WHERE memb___id='$(Escape $AccountId)'" -h -1 2>$null
    return ([int]$r.Trim() -gt 0) }

function Test-CharacterExists { param([string]$CharName)
    $r = sqlcmd -S $dbServer -E -d $dbName -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM Character WHERE Name='$(Escape $CharName)'" -h -1 2>$null
    return ([int]$r.Trim() -gt 0) }

function Get-NextSnoNumber {
    $r = sqlcmd -S $dbServer -E -d $dbName -Q "SET NOCOUNT ON; SELECT ISNULL(MAX(CAST(sno__numb AS INT)),0)+1 FROM MEMB_INFO WHERE sno__numb LIKE '[0-9]%'" -h -1 2>$null
    return ([int]$r.Trim()).ToString().PadLeft(7,'0') }

function Get-DefaultStats { param([string]$ClassName)
    switch ($ClassName) {
        "Dark Wizard"   { return @{Str=28;Agi=20;Vit=25;Ene=15} }
        "Dark Knight"   { return @{Str=30;Agi=20;Vit=25;Ene=15} }
        "Fairy Elf"     { return @{Str=22;Agi=25;Vit=20;Ene=15} }
        "Magic Gladiator" { return @{Str=26;Agi=20;Vit=25;Ene=15} }
        "Dark Lord"     { return @{Str=26;Agi=20;Vit=25;Ene=15} }
        "Summoner"      { return @{Str=21;Agi=20;Vit=20;Ene=25} }
        default         { return @{Str=28;Agi=20;Vit=25;Ene=15} } }
}

function Get-WZClass { param([string]$ClassName)
    switch ($ClassName) {
        "Dark Wizard"   { return 0 }; "Dark Knight"   { return 16 }
        "Fairy Elf"     { return 32 }; "Magic Gladiator" { return 48 }
        "Dark Lord"     { return 64 }; "Summoner"      { return 80 }
        default         { return 0 } }
}

function Escape { param([string]$V) ; return $V.Replace("'","''") }

function New-Label([string]$text, $size=12) {
    $l = New-Object System.Windows.Controls.TextBlock; $l.Text = $text
    $l.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.label)
    $l.FontSize = $size; $l.Margin = [System.Windows.Thickness]::new(0,0,0,4); return $l }

function New-TextBox([string]$default, [int]$maxlen) {
    $t = New-Object System.Windows.Controls.TextBox; $t.Text = $default; $t.MaxLength = $maxlen
    $t.Height = 32; $t.FontSize = 13
    $t.Padding = [System.Windows.Thickness]::new(8,4,8,4)
    $t.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.input)
    $t.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.fg)
    $t.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.border)
    $t.BorderThickness = [System.Windows.Thickness]::new(1); return $t }

function New-PasswordBox([int]$maxlen) {
    $p = New-Object System.Windows.Controls.PasswordBox; $p.MaxLength = $maxlen
    $p.Height = 32; $p.FontSize = 13
    $p.Padding = [System.Windows.Thickness]::new(8,4,8,4)
    $p.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.input)
    $p.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.fg)
    $p.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.border)
    $p.BorderThickness = [System.Windows.Thickness]::new(1); return $p }

function New-Section([string]$title) {
    $border = New-Object System.Windows.Controls.Border
    $border.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.panel)
    $border.CornerRadius = [System.Windows.CornerRadius]::new(8)
    $border.Padding = [System.Windows.Thickness]::new(16)
    $border.Margin = [System.Windows.Thickness]::new(0,0,0,12)
    $sp = New-Object System.Windows.Controls.StackPanel
    $lbl = New-Object System.Windows.Controls.TextBlock
    $lbl.Text = $title; $lbl.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.dim)
    $lbl.FontSize = 11; $lbl.FontWeight = "SemiBold"
    $lbl.Margin = [System.Windows.Thickness]::new(0,0,0,6)
    $sp.Children.Add($lbl) | Out-Null; $border.Child = $sp; return @{ Border = $border; Stack = $sp } }

function New-Button([string]$text, [string]$bg, $handler) {
    $b = New-Object System.Windows.Controls.Button
    $b.Content = $text; $b.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($bg)
    $b.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("White")
    $b.BorderThickness = [System.Windows.Thickness]::new(0); $b.Height = 36
    $b.FontSize = 13; $b.FontWeight = "SemiBold"; $b.Cursor = "Hand"
    $b.Padding = [System.Windows.Thickness]::new(16,0,16,0)
    $b.Tag = $handler
    $b.Add_Click({ try { &$this.Tag } catch { [System.Windows.MessageBox]::Show($_.Exception.Message,"Error","OK","Error") } })
    return $b }

function New-ComboDark([string[]]$items, [int]$sel=0) {
    $c = New-Object System.Windows.Controls.ComboBox; $c.Height = 32; $c.FontSize = 13
    $c.Padding = [System.Windows.Thickness]::new(8,4,8,4)
    $c.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.input)
    $c.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.fg)
    $c.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.border)
    $c.BorderThickness = [System.Windows.Thickness]::new(1)
    # Custom template com fundo escuro no popup dropdown
    $reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new(@"
<ControlTemplate xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                 xmlns:x='http://schemas.microsoft.com/winfx/2006/xaml'
                 TargetType='ComboBox'>
    <Grid>
        <Border x:Name='Bd' Background='$($color.input)' BorderBrush='$($color.border)' BorderThickness='1' CornerRadius='4'>
            <Grid>
                <ToggleButton IsChecked='{Binding IsDropDownOpen,Mode=TwoWay,RelativeSource={RelativeSource TemplatedParent}}'
                              Focusable='False' ClickMode='Press' Background='Transparent' BorderThickness='0'/>
                <ContentPresenter IsHitTestVisible='False' Content='{TemplateBinding SelectionBoxItem}'
                                  Margin='{TemplateBinding Padding}' HorizontalAlignment='Left' VerticalAlignment='Center'/>
            </Grid>
        </Border>
        <Popup IsOpen='{TemplateBinding IsDropDownOpen}' Placement='Bottom'
               AllowsTransparency='True' Focusable='False' PopupAnimation='Slide'>
            <Border Background='$($color.input)' BorderBrush='$($color.border)' BorderThickness='1' CornerRadius='4' Padding='4'>
                <ScrollViewer MaxHeight='{TemplateBinding MaxDropDownHeight}'>
                    <ItemsPresenter/>
                </ScrollViewer>
            </Border>
        </Popup>
    </Grid>
</ControlTemplate>
"@))
    $c.Template = [System.Windows.Markup.XamlReader]::Load($reader)
    $items | ForEach-Object { $item = New-Object System.Windows.Controls.ComboBoxItem; $item.Content = $_; $c.Items.Add($item) | Out-Null }
    $c.SelectedIndex = $sel; return $c }

# ==================== DATABASE FUNCTIONS ====================
function Load-AccountData {
    param([string]$AccountId)
    $safe = Escape $AccountId
    $acct = sqlcmd -S $dbServer -E -d $dbName -Q "SET NOCOUNT ON; SELECT memb___id, memb__pwd, sno__numb, AccountLevel FROM MEMB_INFO WHERE memb___id='$safe'" -h -1 2>$null
    if (-not $acct -or $acct.Trim() -eq "") { throw "Account not found: $AccountId" }
    $parts = ($acct -split '\s+') | Where-Object { $_ -ne "" }
    $charsRaw = sqlcmd -S $dbServer -E -d $dbName -Q "SET NOCOUNT ON; SELECT Name, cLevel, Class, Strength, Dexterity, Vitality, Energy, Leadership, Money, Ruud, ResetCount, MasterResetCount, MapNumber FROM Character WHERE AccountID='$safe' ORDER BY Name" -h -1 2>$null
    $chars = @()
    foreach ($c in @($charsRaw)) { if ($c.Trim() -ne "") { $chars += $c.Trim() } }
    return @{ Login = $parts[0]; Pin = if ($parts.Count -gt 2) { $parts[2] } else { "" }; AccountLevel = if ($parts.Count -gt 3) { [int]$parts[3] } else { 0 }; Characters = $chars }
}

function Update-AccountSql {
    param([string]$AccountId, [string]$Password, [string]$Pin, [int]$AccountLevel)
    $safe = Escape $AccountId
    if ($Pin -eq "" -or $Pin.Length -lt 4) { $Pin = Get-NextSnoNumber }
    $sno = $Pin.PadRight(7,'0').Substring(0,7)
    if ($Password -ne "") {
        $md5 = Get-MD5Hash $AccountId $Password
        $sql = "UPDATE MEMB_INFO SET memb__pwd='$md5', sno__numb='$sno', AccountLevel=$AccountLevel WHERE memb___id='$safe'"
    } else {
        $sql = "UPDATE MEMB_INFO SET sno__numb='$sno', AccountLevel=$AccountLevel WHERE memb___id='$safe'"
    }
    $result = sqlcmd -S $dbServer -E -d $dbName -Q $sql 2>&1
    if ($LASTEXITCODE -ne 0) { throw "sqlcmd error ($LASTEXITCODE): $result" }
    return $LASTEXITCODE
}

function Create-AccountSql {
    param([string]$AccountId, [string]$Password, [string]$Pin, [string]$CharacterName,
          [string]$ClassName, [int]$Level, [int]$Str, [int]$Agi, [int]$Vit, [int]$Ene,
          [int]$Lea, [int]$Resets, [int]$MasterLevel, [int]$Zen, [int]$Ruud)

    $md5pwd = Get-MD5Hash $AccountId $Password
    if ($Pin -eq "" -or $Pin.Length -lt 4) { $Pin = Get-NextSnoNumber }
    $sno = $Pin.PadRight(7,'0').Substring(0,7)
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $wzClass = Get-WZClass $ClassName
    $mapNum = 0; if ($ClassName -eq "Magic Gladiator") { $mapNum = 3 }
    $a = Escape $AccountId; $n = Escape $CharacterName

    $sql = @"
SET NOCOUNT ON; BEGIN TRANSACTION;
IF NOT EXISTS (SELECT 1 FROM MEMB_INFO WHERE memb___id='$a')
    INSERT INTO MEMB_INFO (memb___id, memb__pwd, memb_name, sno__numb, appl_days, bloc_code, ctl1_code, AccountLevel, AccountExpireDate)
    VALUES ('$a','$md5pwd','','$sno','$now','0','0',0,'1900-01-01')
ELSE
    UPDATE MEMB_INFO SET memb__pwd='$md5pwd' WHERE memb___id='$a'
IF NOT EXISTS (SELECT 1 FROM AccountCharacter WHERE Id='$a')
    INSERT INTO AccountCharacter (Id,GameID1,GameID2,GameID3,GameID4,GameID5,GameID6,GameID7,GameID8,GameIDC,MoveCnt,ExtClass,ExtWarehouse)
    VALUES ('$a','$n','','','','','','','','$n',0,0,1)
ELSE
    UPDATE AccountCharacter SET GameID1='$n',GameIDC='$n' WHERE Id='$a'
EXEC WZ_CreateCharacter '$a','$n',$wzClass
UPDATE Character SET cLevel=$Level,LevelUpPoint=0,Strength=$Str,Dexterity=$Agi,Vitality=$Vit,Energy=$Ene,Leadership=$Lea,
    Money=$Zen,Ruud=$Ruud,MapNumber=$mapNum,MapPosX=145,MapPosY=140,MapDir=0,PkCount=0,PkLevel=0,PkTime=0,CtlCode=0,DbVersion=17,
    ResetCount=$Resets,MasterResetCount=$MasterLevel,AutoDt0=20,AutoDt1=20,AutoDt2=20,AutoDt3=20,AutoDt4=20,ExtInventory=1
WHERE AccountID='$a' AND Name='$n'
IF NOT EXISTS (SELECT 1 FROM MasterSkillTree WHERE Name='$n') INSERT INTO MasterSkillTree (Name,MasterLevel) VALUES ('$n',$MasterLevel)
ELSE UPDATE MasterSkillTree SET MasterLevel=$MasterLevel WHERE Name='$n'
COMMIT TRANSACTION;
"@
    sqlcmd -S $dbServer -E -d $dbName -Q $sql 2>&1 | Out-Null
    return $LASTEXITCODE
}

# ==================== BUILD UI ====================
$window = New-Object System.Windows.Window
$window.Title = "MuOnline Account Manager"
$window.Width = 520; $window.Height = 740
$window.WindowStartupLocation = "CenterScreen"
$window.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.bg)
$window.ResizeMode = "CanResizeWithGrip"; $window.FontFamily = "Segoe UI"

$scroll = New-Object System.Windows.Controls.ScrollViewer
$scroll.VerticalScrollBarVisibility = "Auto"; $scroll.HorizontalScrollBarVisibility = "Disabled"

$root = New-Object System.Windows.Controls.StackPanel
$root.Margin = [System.Windows.Thickness]::new(24,20,24,20)
$scroll.Content = $root; $window.Content = $scroll

# ===== TITLE =====
$t1 = New-Object System.Windows.Controls.TextBlock; $t1.Text = "MuOnline"
$t1.FontSize = 28; $t1.FontWeight = "Bold"
$t1.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.title)
$root.Children.Add($t1) | Out-Null

$t2 = New-Object System.Windows.Controls.TextBlock; $t2.Text = "Account Manager"
$t2.FontSize = 14; $t2.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#6666AA")
$t2.Margin = [System.Windows.Thickness]::new(0,-4,0,12)
$root.Children.Add($t2) | Out-Null

# ===== MODE TOGGLE =====
$modeWrap = New-Object System.Windows.Controls.WrapPanel
$modeWrap.Margin = [System.Windows.Thickness]::new(0,0,0,12)
$btnModeCreate = New-Button "CRIAR CONTA" $color.accent { }
$btnModeEdit = New-Button "EDITAR CONTA" "#2D2D50" { }
$btnModeEdit.Margin = [System.Windows.Thickness]::new(8,0,0,0)
$modeWrap.Children.Add($btnModeCreate) | Out-Null
$modeWrap.Children.Add($btnModeEdit) | Out-Null
$root.Children.Add($modeWrap) | Out-Null

$contentPanel = New-Object System.Windows.Controls.StackPanel
$root.Children.Add($contentPanel) | Out-Null

# ===== STATUS =====
$txtStatus = New-Object System.Windows.Controls.TextBlock
$txtStatus.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#6666AA")
$txtStatus.FontSize = 11; $txtStatus.Margin = [System.Windows.Thickness]::new(0,6,0,0)
$txtStatus.TextWrapping = "Wrap"; $root.Children.Add($txtStatus) | Out-Null

# ==========================================================
# CREATE MODE PANEL
# ==========================================================
$createPanel = New-Object System.Windows.Controls.StackPanel

# ACCOUNT
$s1 = New-Section "ACCOUNT"
$txtLogin_C = New-TextBox "" 10; $txtPass_C = New-PasswordBox 20
$txtPin_C = New-TextBox "" 7; $txtPin_C.MaxLength = 7
$txtPin_C.ToolTip = "PIN de seguran�a. Deixe vazio para auto-gerar."
$s1.Stack.Children.Add((New-Label "Login")) | Out-Null
$s1.Stack.Children.Add($txtLogin_C) | Out-Null
$s1.Stack.Children.Add((New-Label "Password")) | Out-Null
$s1.Stack.Children.Add($txtPass_C) | Out-Null
$s1.Stack.Children.Add((New-Label "PIN (7 digits)")) | Out-Null
$s1.Stack.Children.Add($txtPin_C) | Out-Null
$createPanel.Children.Add($s1.Border) | Out-Null

# CHARACTER
$s2 = New-Section "CHARACTER"
$txtCharName = New-TextBox "" 10
$cboClass = New-ComboDark @("Dark Wizard","Dark Knight","Fairy Elf","Magic Gladiator","Dark Lord","Summoner")
$s2.Stack.Children.Add((New-Label "Name")) | Out-Null
$s2.Stack.Children.Add($txtCharName) | Out-Null
$s2.Stack.Children.Add((New-Label "Class")) | Out-Null
$s2.Stack.Children.Add($cboClass) | Out-Null
$createPanel.Children.Add($s2.Border) | Out-Null

# STATS
$s3 = New-Section "STATS"
$txtLevel = New-TextBox "400" 4; $txtStr = New-TextBox "32000" 5
$txtAgi = New-TextBox "32000" 5; $txtVit = New-TextBox "32000" 5
$txtEne = New-TextBox "32000" 5; $txtLea = New-TextBox "0" 5
$txtResets = New-TextBox "0" 4; $txtMasterLvl = New-TextBox "0" 4
$txtZen = New-TextBox "2000000000" 10; $txtRuud = New-TextBox "1000000" 7

$statsGrid = New-Object System.Windows.Controls.Grid
$null = $statsGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
$statsGrid.ColumnDefinitions[0].Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
$null = $statsGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
$statsGrid.ColumnDefinitions[1].Width = [System.Windows.GridLength]::new(16)
$null = $statsGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
$statsGrid.ColumnDefinitions[2].Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)

$left = New-Object System.Windows.Controls.StackPanel
foreach ($pair in @(@("Level",$txtLevel),@("Strength",$txtStr),@("Agility",$txtAgi),@("Vitality",$txtVit),@("Energy",$txtEne))) {
    $left.Children.Add((New-Label $pair[0])) | Out-Null; $pair[1].Margin = [System.Windows.Thickness]::new(0,0,0,10); $left.Children.Add($pair[1]) | Out-Null }
$right = New-Object System.Windows.Controls.StackPanel
foreach ($pair in @(@("Leadership",$txtLea),@("Resets",$txtResets),@("Master Level",$txtMasterLvl),@("Zen",$txtZen),@("Ruud",$txtRuud))) {
    $right.Children.Add((New-Label $pair[0])) | Out-Null; $pair[1].Margin = [System.Windows.Thickness]::new(0,0,0,10); $right.Children.Add($pair[1]) | Out-Null }
[System.Windows.Controls.Grid]::SetColumn($left,0); [System.Windows.Controls.Grid]::SetColumn($right,2)
$statsGrid.Children.Add($left) | Out-Null; $statsGrid.Children.Add($right) | Out-Null
$s3.Stack.Children.Add($statsGrid) | Out-Null
$createPanel.Children.Add($s3.Border) | Out-Null

# PRESETS
$s4 = New-Section "PRESETS"
$wrapP = New-Object System.Windows.Controls.WrapPanel
$btnFull = New-Button "FULL (Lvl 400 + 32k)" "#2D2D50" {
    $txtLevel.Text="400"; $txtStr.Text="32000"; $txtAgi.Text="32000"; $txtVit.Text="32000"
    $txtEne.Text="32000"; $txtLea.Text="0"; $txtResets.Text="0"; $txtMasterLvl.Text="0"
    $txtZen.Text="2000000000"; $txtRuud.Text="1000000" }
$btnReset100 = New-Button "Reset 100 (Lvl 400)" "#2D2D50" {
    $txtLevel.Text="400"; $txtStr.Text="32000"; $txtAgi.Text="32000"; $txtVit.Text="32000"
    $txtEne.Text="32000"; $txtLea.Text="0"; $txtResets.Text="100"; $txtMasterLvl.Text="0"
    $txtZen.Text="2000000000"; $txtRuud.Text="5000000" }
$btnDefault = New-Button "Default (Lvl 1)" "#2D2D50" {
    $cls = ($cboClass.SelectedItem).Content; $st = Get-DefaultStats $cls
    $txtLevel.Text="1"; $txtStr.Text=$st.Str; $txtAgi.Text=$st.Agi; $txtVit.Text=$st.Vit
    $txtEne.Text=$st.Ene; $txtLea.Text="0"; $txtResets.Text="0"; $txtMasterLvl.Text="0"
    $txtZen.Text="0"; $txtRuud.Text="0" }
$btnFull.Margin = [System.Windows.Thickness]::new(0,0,8,6)
$btnReset100.Margin = [System.Windows.Thickness]::new(0,0,8,6)
$wrapP.Children.Add($btnFull) | Out-Null; $wrapP.Children.Add($btnReset100) | Out-Null; $wrapP.Children.Add($btnDefault) | Out-Null
$s4.Stack.Children.Add($wrapP) | Out-Null
$createPanel.Children.Add($s4.Border) | Out-Null

# CREATE BUTTON
$btnCreate = New-Button "CREATE ACCOUNT" $color.accent {
    $login = $txtLogin_C.Text.Trim(); $pass = $txtPass_C.Password.Trim(); $charName = $txtCharName.Text.Trim()
    if ($login -eq "" -or $pass -eq "" -or $charName -eq "") { [System.Windows.MessageBox]::Show("Fill all fields!","Error","OK","Error"); return }
    if ($login.Length -lt 4) { [System.Windows.MessageBox]::Show("Login min 4 chars!","Error","OK","Error"); return }
    if ($charName.Length -lt 4) { [System.Windows.MessageBox]::Show("Name min 4 chars!","Error","OK","Error"); return }
    if (Test-CharacterExists $charName) { [System.Windows.MessageBox]::Show("Character '$charName' already exists!","Error","OK","Error"); return }
    $cls = ($cboClass.SelectedItem).Content; $pin = $txtPin_C.Text.Trim()
    $btnCreate.IsEnabled = $false; $btnCreate.Content = "CREATING..."; $txtStatus.Text = "Creating account..."
    try {
        $r = Create-AccountSql -AccountId $login -Password $pass -Pin $pin -CharacterName $charName -ClassName $cls `
            -Level ([int]$txtLevel.Text) -Str ([int]$txtStr.Text) -Agi ([int]$txtAgi.Text) -Vit ([int]$txtVit.Text) `
            -Ene ([int]$txtEne.Text) -Lea ([int]$txtLea.Text) -Resets ([int]$txtResets.Text) -MasterLevel ([int]$txtMasterLvl.Text) `
            -Zen ([int]$txtZen.Text) -Ruud ([int]$txtRuud.Text)
        if ($r -eq 0) { $s="$($txtStr.Text)/$($txtAgi.Text)/$($txtVit.Text)/$($txtEne.Text)"
            [System.Windows.MessageBox]::Show("Account created!`nLogin: $login`nChar: $charName`nClass: $cls`nLevel: $($txtLevel.Text)`nStats: $s","Success","OK","Information")
            $txtStatus.Text = "Account '$login' created!" } else {
            $txtStatus.Text = "SQL Error ($r)."; [System.Windows.MessageBox]::Show("SQL Error ($r)!","Error","OK","Error") }
    } catch { $txtStatus.Text = "Error: $($_.Exception.Message)"
        [System.Windows.MessageBox]::Show("Error: $($_.Exception.Message)","Error","OK","Error") }
    $btnCreate.IsEnabled = $true; $btnCreate.Content = "CREATE ACCOUNT"
}
$createPanel.Children.Add($btnCreate) | Out-Null

# ==========================================================
# EDIT MODE PANEL
# ==========================================================
$editPanel = New-Object System.Windows.Controls.StackPanel

# SEARCH
$sSearch = New-Section "SEARCH"
$txtSearch = New-TextBox "" 10
$btnSearch = New-Button "BUSCAR" $color.accent {
    $acct = $txtSearch.Text.Trim()
    if ($acct -eq "") { $txtEditStatus.Text = "Enter login to search."; return }
    $txtEditStatus.Text = "Searching for '$acct'..."
    try {
        if (-not (Test-AccountExists $acct)) { $txtEditStatus.Text = "Account '$acct' not found!"; return }
        $data = Load-AccountData $acct
        $txtEditLogin.Text = $data.Login; $txtEditPin.Text = $data.Pin
        $cboAccountLevel.SelectedIndex = $data.AccountLevel
        if ($data.AccountLevel -gt 3) { $cboAccountLevel.SelectedIndex = 0 }
        $txtEditPass.Password = ""; $txtEditNewChar.Text = ""
        $charsListBox.Items.Clear()
        foreach ($c in $data.Characters) {
            $parts = ($c -split '\s+') | Where-Object { $_ -ne "" }
            $itemStr = if ($parts.Count -ge 3) { "$($parts[0]) (Lv $($parts[1]), Class $($parts[2]))" } else { $c }
            $charsListBox.Items.Add($itemStr) | Out-Null }
        $txtEditStatus.Text = "Account '$acct' loaded. $($data.Characters.Count) character(s)."
        $editAccountLoaded = $true
    } catch { $txtEditStatus.Text = "Error: $($_.Exception.Message)"
        [System.Windows.MessageBox]::Show($_.Exception.Message,"Error","OK","Error") }
}
$sSearch.Stack.Children.Add((New-Label "Account Login")) | Out-Null
$searchRow = New-Object System.Windows.Controls.WrapPanel
$txtSearch.MinWidth = 250; $txtSearch.Margin = [System.Windows.Thickness]::new(0,0,8,0)
$txtSearch.Add_KeyDown({ if ($_.Key -eq "Return") { $btnSearch.RaiseEvent((New-Object System.Windows.RoutedEventArgs ([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent))) } })
$searchRow.Children.Add($txtSearch) | Out-Null
$searchRow.Children.Add($btnSearch) | Out-Null
$sSearch.Stack.Children.Add($searchRow) | Out-Null
$editPanel.Children.Add($sSearch.Border) | Out-Null

$editAccountLoaded = $false

# EDIT ACCOUNT
$sEditAcct = New-Section "EDIT ACCOUNT"
$txtEditLogin = New-TextBox "" 10; $txtEditLogin.IsReadOnly = $true
$txtEditLogin.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#0D0D1A")
$txtEditPass = New-PasswordBox 20
$txtEditPin = New-TextBox "" 7; $txtEditPin.MaxLength = 7
$txtEditPin.ToolTip = "PIN de seguran�a. Deixe vazio para manter o atual."
$cboAccountLevel = New-ComboDark @("Free (0)", "VIP (1)", "VIP+ (2)", "VIP++ (3)")

$lvlLabel = New-Label "Account Level"
$sEditAcct.Stack.Children.Add((New-Label "Login")) | Out-Null
$sEditAcct.Stack.Children.Add($txtEditLogin) | Out-Null
$sEditAcct.Stack.Children.Add((New-Label "New Password (empty = no change)")) | Out-Null
$sEditAcct.Stack.Children.Add($txtEditPass) | Out-Null
$sEditAcct.Stack.Children.Add((New-Label "PIN (empty = keep current)")) | Out-Null
$sEditAcct.Stack.Children.Add($txtEditPin) | Out-Null
$sEditAcct.Stack.Children.Add($lvlLabel) | Out-Null
$sEditAcct.Stack.Children.Add($cboAccountLevel) | Out-Null
$editPanel.Children.Add($sEditAcct.Border) | Out-Null

# EXISTING CHARACTERS
$sChars = New-Section "CHARACTERS"
$charsListBox = New-Object System.Windows.Controls.ListBox
$charsListBox.Height = 80; $charsListBox.FontSize = 12
$charsListBox.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.input)
$charsListBox.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.fg)
$charsListBox.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.border)
$charsListBox.BorderThickness = [System.Windows.Thickness]::new(1)
$sChars.Stack.Children.Add((New-Label "Existing Characters")) | Out-Null
$sChars.Stack.Children.Add($charsListBox) | Out-Null

# NEW CHARACTER SECTION
$sChars.Stack.Children.Add((New-Label "Add New Character (optional)")) | Out-Null
$txtEditNewChar = New-TextBox "" 10
$cboEditClass = New-ComboDark @("Dark Wizard","Dark Knight","Fairy Elf","Magic Gladiator","Dark Lord","Summoner")
$sChars.Stack.Children.Add($txtEditNewChar) | Out-Null
$sChars.Stack.Children.Add((New-Label "Class")) | Out-Null
$sChars.Stack.Children.Add($cboEditClass) | Out-Null
$editPanel.Children.Add($sChars.Border) | Out-Null

# SAVE BUTTON
$btnSaveEdit = New-Button "SALVAR ALTERACOES" $color.accent {
    $acct = $txtEditLogin.Text.Trim()
    if ($acct -eq "") { [System.Windows.MessageBox]::Show("Search and load an account first.","Error","OK","Error"); return }
    $pass = $txtEditPass.Password.Trim(); $pin = $txtEditPin.Text.Trim()
    $alvl = $cboAccountLevel.SelectedIndex
    $newCharName = $txtEditNewChar.Text.Trim()
    $btnSaveEdit.IsEnabled = $false; $btnSaveEdit.Content = "SAVING..."; $txtEditStatus.Text = "Saving..."

    try {
        Update-AccountSql -AccountId $acct -Password $pass -Pin $pin -AccountLevel $alvl

        # Create character if new name provided
        if ($newCharName -ne "") {
            if (-not (Test-CharacterExists $newCharName)) {
                $cls = ($cboEditClass.SelectedItem).Content
                Create-AccountSql -AccountId $acct -Password "x" -Pin "" -CharacterName $newCharName -ClassName $cls `
                    -Level 1 -Str 28 -Agi 20 -Vit 25 -Ene 15 -Lea 0 -Resets 0 -MasterLevel 0 -Zen 0 -Ruud 0
            } else {
                [System.Windows.MessageBox]::Show("Character '$newCharName' already exists!","Warning","OK","Warning")
            }
        }

        $txtEditStatus.Text = "Account '$acct' updated!"; [System.Windows.MessageBox]::Show("Account updated!","Success","OK","Information")
    } catch { $txtEditStatus.Text = "Error: $($_.Exception.Message)"
        [System.Windows.MessageBox]::Show("Error: $($_.Exception.Message)","Error","OK","Error") }

    # Reload
    try { $data = Load-AccountData $acct; $txtEditPin.Text = $data.Pin
        $charsListBox.Items.Clear()
        foreach ($c in $data.Characters) { $charsListBox.Items.Add($c) | Out-Null } }
    catch { }

    $btnSaveEdit.IsEnabled = $true; $btnSaveEdit.Content = "SALVAR ALTERACOES"
}
$editPanel.Children.Add($btnSaveEdit) | Out-Null

$txtEditStatus = New-Object System.Windows.Controls.TextBlock
$txtEditStatus.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#6666AA")
$txtEditStatus.FontSize = 11; $txtEditStatus.Margin = [System.Windows.Thickness]::new(0,6,0,0)
$txtEditStatus.TextWrapping = "Wrap"
$editPanel.Children.Add($txtEditStatus) | Out-Null

# ===== MODE SWITCHING =====
function Switch-Mode([string]$mode) {
    if ($mode -eq "create") {
        $btnModeCreate.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.accent)
        $btnModeEdit.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#2D2D50")
        $contentPanel.Children.Clear(); $contentPanel.Children.Add($createPanel)
        $window.Title = "MuOnline Account Manager - Criar Conta"
    } else {
        $btnModeEdit.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color.accent)
        $btnModeCreate.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#2D2D50")
        $contentPanel.Children.Clear(); $contentPanel.Children.Add($editPanel)
        $window.Title = "MuOnline Account Manager - Editar Conta"
    }
}

$btnModeCreate.Add_Click({ Switch-Mode "create" })
$btnModeEdit.Add_Click({ Switch-Mode "edit" })

# ===== STARTUP =====
Switch-Mode "create"
$null = $window.ShowDialog()
