<#
.SYNOPSIS
  Sincroniza o IP do servidor a partir de StartUp\Common.ini para todos os configs.
.DESCRIPTION
  Le o IP de MuServer\StartUp\Common.ini e atualiza:
    - MuServer\ConnectServer\ServerList.dat
    - MuServer\Data\MapServerInfo.dat
    - MuServer\GameServer\Data\GameServerInfo - Common.dat
    - MuServer\GameServerCS\Data\GameServerInfo - Common.dat
    - MuServer\JoinServer\JoinServer.ini
    - Client\Config.ini
.EXAMPLE
  .\scripts\sync-ip.ps1
#>

$root = Split-Path -Parent $PSScriptRoot
$commonIni = Join-Path $root 'MuServer\StartUp\Common.ini'
$muServer = Join-Path $root 'MuServer'

if (-not (Test-Path -LiteralPath $commonIni)) {
    Write-Error "Common.ini nao encontrado em: $commonIni"
    exit 1
}

$ip = (Get-Content -LiteralPath $commonIni | Where-Object { $_ -match '^\s*ConnectServerIP\s*=' }) -replace '.*=\s*', '' -replace '\s*$', ''
if (-not $ip) {
    Write-Error "ConnectServerIP nao encontrado em Common.ini"
    exit 1
}

Write-Host "IP: $ip" -ForegroundColor Cyan

$ipPattern = '\d+\.\d+\.\d+\.\d+'

$files = @(
    @{Path='ConnectServer\ServerList.dat';                OldPattern="`"$ipPattern`"";     NewPattern="`"$ip`""}
    @{Path='Data\MapServerInfo.dat';                      OldPattern="S$ipPattern";        NewPattern="S$ip"}
    @{Path='GameServer\Data\GameServerInfo - Common.dat'; OldPattern="(?<=DataServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='GameServer\Data\GameServerInfo - Common.dat'; OldPattern="(?<=JoinServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='GameServer\Data\GameServerInfo - Common.dat'; OldPattern="(?<=ConnectServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='GameServerCS\Data\GameServerInfo - Common.dat'; OldPattern="(?<=DataServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='GameServerCS\Data\GameServerInfo - Common.dat'; OldPattern="(?<=JoinServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='GameServerCS\Data\GameServerInfo - Common.dat'; OldPattern="(?<=ConnectServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='GameServerVIP\Data\GameServerInfo - Common.dat'; OldPattern="(?<=DataServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='GameServerVIP\Data\GameServerInfo - Common.dat'; OldPattern="(?<=JoinServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='GameServerVIP\Data\GameServerInfo - Common.dat'; OldPattern="(?<=ConnectServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='JoinServer\JoinServer.ini';                     OldPattern="(?<=ConnectServerAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
    @{Path='..\Client\Config.ini';                          OldPattern="(?<=IpAddress\s*=\s*)$ipPattern"; NewPattern="$ip"}
)

$updated = 0
foreach ($f in $files) {
    $fullPath = Join-Path $muServer $f.Path
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Write-Warning "Arquivo nao encontrado: $fullPath"
        continue
    }
    $content = Get-Content -LiteralPath $fullPath -Raw
    if ($content -match $f.OldPattern) {
        $newContent = $content -replace $f.OldPattern, $f.NewPattern
        Set-Content -LiteralPath $fullPath -Value $newContent -NoNewline
        Write-Host "  Atualizado: $($f.Path)" -ForegroundColor Green
        $updated++
    } else {
        Write-Warning "  Padrao nao encontrado em: $($f.Path)"
    }
}

Write-Host "`n$updated arquivo(s) atualizado(s) para IP=$ip" -ForegroundColor Yellow
