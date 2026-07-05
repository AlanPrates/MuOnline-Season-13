<#
.SYNOPSIS
  Health-check do MuOnline Season 13 (checklist do README.md).
.DESCRIPTION
  Valida SQL Server, banco MuOnline, DSN ODBC, portas do servidor,
  arquivos de configuracao e coerencia do ServerCode entre ConnectServer,
  MapServerInfo e GameServerInfo.
.PARAMETER SqlInstance
  Instancia SQL Server. Padrao: .\SQLEXPRESS
.PARAMETER Database
  Nome do banco. Padrao: MuOnline
.PARAMETER DsnName
  Nome do DSN ODBC 32-bit. Padrao: MuOnline
.PARAMETER ExpectedIp
  IP esperado nos arquivos de config. Padrao: 192.168.1.3
.EXAMPLE
  .\scripts\health-check.ps1
.EXAMPLE
  .\scripts\health-check.ps1 -ExpectedIp 10.0.0.5
#>
[CmdletBinding()]
param(
    [string]$SqlInstance = '.\SQLEXPRESS',
    [string]$Database     = 'MuOnline',
    [string]$DsnName      = 'MuOnline',
    [string]$ExpectedIp   = '192.168.1.3'
)

$ErrorActionPreference = 'Continue'
$root = Split-Path -Parent $PSScriptRoot

# Load IP from Common.ini if available; fallback to -ExpectedIp
$commonIni = Join-Path $root 'MuServer\StartUp\Common.ini'
if (Test-Path -LiteralPath $commonIni) {
    $commonIp = (Get-Content -LiteralPath $commonIni | Where-Object { $_ -match '^\s*ConnectServerIP\s*=' }) -replace '.*=\s*', '' -replace '\s*$', ''
    if ($commonIp) { $ExpectedIp = $commonIp }
}

$results = New-Object System.Collections.Generic.List[object]
function Add-Check($name, $ok, $detail) {
    $results.Add([pscustomobject]@{
        Check  = $name
        Status = if ($ok) { 'OK' } else { 'FAIL' }
        Detail = $detail
    })
}

function Test-Port($port, $proto) {
    try {
        if ($proto -eq 'UDP') {
            $u = New-Object Net.Sockets.UdpClient
            $u.Client.Bind((New-Object Net.IPEndPoint([Net.IPAddress]::Any, 0)))
            $u.Connect('127.0.0.1', $port)
            $ok = $u.Client.Connected
            $u.Close()
            return $ok
        }
        $l = New-Object Net.Sockets.TcpListener([Net.IPAddress]::Any, $port)
        $l.Stop()
        return $false
    } catch {
        return $true
    }
}

Write-Host ":: Verificando SQL Server e banco" -ForegroundColor Cyan
try {
    $q = sqlcmd -S $SqlInstance -E -d $Database -Q "SELECT 1" -h -1 2>$null
    if ($LASTEXITCODE -eq 0) {
        Add-Check "SQL Server + banco '$Database'" $true "Conectou em '$SqlInstance'"
    } else {
        Add-Check "SQL Server + banco '$Database'" $false "sqlcmd falhou em '$SqlInstance'"
    }
} catch {
    Add-Check "SQL Server + banco '$Database'" $false $_.Exception.Message
}

Write-Host ":: Verificando DSN ODBC 32-bit '$DsnName'" -ForegroundColor Cyan
$dsnKey = 'HKLM:\SOFTWARE\WOW6432Node\ODBC\ODBC.INI\' + $DsnName
if (Test-Path $dsnKey) {
    Add-Check "DSN ODBC '$DsnName' (32-bit)" $true "Encontrado em WOW6432Node"
} else {
    $dsnKey64 = 'HKLM:\SOFTWARE\ODBC\ODBC.INI\' + $DsnName
    if (Test-Path $dsnKey64) {
        Add-Check "DSN ODBC '$DsnName' (32-bit)" $false "Existe apenas como 64-bit - games 32-bit nao usara"
    } else {
        Add-Check "DSN ODBC '$DsnName' (32-bit)" $false "DSN ausente - abra C:\Windows\SysWOW64\odbcad32.exe"
    }
}

Write-Host ":: Verificando portas do servidor" -ForegroundColor Cyan
$ports = @(
    @{P=44405; T='TCP'; D='Cliente -> ConnectServer'},
    @{P=55557; T='UDP'; D='Servidores -> ConnectServer'},
    @{P=55960; T='TCP'; D='DataServer'},
    @{P=55970; T='TCP'; D='JoinServer'},
    @{P=55901; T='TCP'; D='GameServer'},
    @{P=55919; T='TCP'; D='GameServerCS'},
    @{P=55921; T='TCP'; D='GameServerVIP'}
)
foreach ($pt in $ports) {
    $inUse = Test-Port $pt.P $pt.T
    if ($inUse) {
        Add-Check ("Porta {0} {1} ({2})" -f $pt.P, $pt.T, $pt.D) $false "Porta em uso - interrompa o processo que a ocupa"
    } else {
        Add-Check ("Porta {0} {1} ({2})" -f $pt.P, $pt.T, $pt.D) $true "Livre antes do start"
    }
}

Write-Host ":: Verificando arquivos deconfiguracao essenciais" -ForegroundColor Cyan
$files = @(
    'MuServer\StartUp\Common.ini',
    'MuServer\ConnectServer\ServerList.dat',
    'MuServer\Data\MapServerInfo.dat',
    'MuServer\GameServer\Data\GameServerInfo - Common.dat',
    'MuServer\GameServerCS\Data\GameServerInfo - Common.dat',
    'MuServer\GameServerVIP\Data\GameServerInfo - Common.dat',
    'MuServer\GameServerVIP\Data\GameServerInfo - Event.dat',
    'MuServer\GameServerVIP\GameServer.exe',
    'MuServer\JoinServer\JoinServer.ini',
    'MuServer\DataServer\DataServer.ini',
    'MuServer\StartServer.bat',
    'Client\Config.ini'
)
foreach ($f in $files) {
    $full = Join-Path $root $f
    if (Test-Path -LiteralPath $full) {
        Add-Check "Arquivo $f" $true "Presente"
    } else {
        Add-Check "Arquivo $f" $false "Ausente"
    }
}

Write-Host ":: Coerencia do IP '$ExpectedIp' nos configs" -ForegroundColor Cyan
$ipFiles = @(
    'MuServer\ConnectServer\ServerList.dat',
    'MuServer\Data\MapServerInfo.dat',
    'MuServer\GameServer\Data\GameServerInfo - Common.dat',
    'MuServer\GameServerCS\Data\GameServerInfo - Common.dat',
    'MuServer\GameServerVIP\Data\GameServerInfo - Common.dat',
    'MuServer\JoinServer\JoinServer.ini',
    'Client\Config.ini'
)
foreach ($f in $ipFiles) {
    $full = Join-Path $root $f
    if (-not (Test-Path -LiteralPath $full)) { continue }
    $txt = Get-Content -LiteralPath $full -Raw
    if ($txt -match [regex]::Escape($ExpectedIp)) {
        Add-Check "IP '$ExpectedIp' em $f" $true "Referenciado"
    } else {
        Add-Check "IP '$ExpectedIp' em $f" $false "IP nao encontrado - pode divergir"
    }
}

Write-Host ":: Coerencia do ServerCode (40 / 19 / 41)" -ForegroundColor Cyan
function Get-ServerCodes($file, $pattern) {
    $full = Join-Path $root $file
    if (-not (Test-Path -LiteralPath $full)) { return @{} }
    $codes = @{}
    foreach ($line in Get-Content -LiteralPath $full) {
        if ($line -match $pattern) {
            $key = $matches[1]
            if (-not $codes.ContainsKey($key)) { $codes[$key] = 0 }
            $codes[$key]++
        }
    }
    return $codes
}

$sl = Get-ServerCodes 'MuServer\ConnectServer\ServerList.dat' '^\s*(\d+)\s+'
$ms = Get-ServerCodes 'MuServer\Data\MapServerInfo.dat' '^\s*(\d+)\s+\d+\s+\d+\s+S'
$gs = Get-ServerCodes 'MuServer\GameServer\Data\GameServerInfo - Common.dat' '(?i)ServerCode\s*=\s*(\d+)'
$cs = Get-ServerCodes 'MuServer\GameServerCS\Data\GameServerInfo - Common.dat' '(?i)ServerCode\s*=\s*(\d+)'
$vip = Get-ServerCodes 'MuServer\GameServerVIP\Data\GameServerInfo - Common.dat' '(?i)ServerCode\s*=\s*(\d+)'

$slOk = $sl.ContainsKey('40')
$msOk = $ms.ContainsKey('40')
$gsOk = $gs.ContainsKey('40')
Add-Check "ServerCode 40 (GS normal) em ServerList/MapServerInfo/Common" ($slOk -and $msOk -and $gsOk) ("ServerList={0}; Map={1}; Common={2}" -f $slOk, $msOk, $gsOk)

$msCs = $ms.ContainsKey('19')
$csOk = $cs.ContainsKey('19')
Add-Check "ServerCode 19 (GS CS) em MapServerInfo/Common CS" ($msCs -and $csOk) ("Map={0}; CommonCS={1}" -f $msCs, $csOk)

$slVip = $sl.ContainsKey('41')
$msVip = $ms.ContainsKey('41')
$vipOk = $vip.ContainsKey('41')
Add-Check "ServerCode 41 (GS VIP) em ServerList/MapServerInfo/Common VIP" ($slVip -and $msVip -and $vipOk) ("ServerList={0}; Map={1}; CommonVIP={2}" -f $slVip, $msVip, $vipOk)

Write-Host ""
Write-Host "================ RESUMO ================" -ForegroundColor Yellow
$results | Format-Table -AutoSize
$fail = ($results | Where-Object Status -eq 'FAIL').Count
if ($fail -eq 0) {
    Write-Host "Tudo OK. Pronto para start." -ForegroundColor Green
    exit 0
} else {
    Write-Host "$fail verificacao(oes) falharam. Corrija antes de subir o servidor." -ForegroundColor Red
    exit 1
}
