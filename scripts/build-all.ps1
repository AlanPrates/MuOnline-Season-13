<#
.SYNOPSIS
  Compila todos os projetos do MuOnline Season 13 em sequencia.
.DESCRIPTION
  Executa a sequencia completa de build do README.md:
    ConnectServer, DataServer, JoinServer,
    Crypto++ (servidor, Release+Debug),
    GameServer (Debug), GameServerCS (Debug_CS),
    Crypto++ (cliente), Main (cliente).
  Para no primeiro erro e mostra os passos executados.
.PARAMETER MsBuild
  Caminho do MSBuild.exe.
.PARAMETER Toolset
  PlatformToolset. Padrao: v145
.PARAMETER SdkVersion
  WindowsTargetPlatformVersion. Padrao: 10.0
.PARAMETER SkipCopy
  Nao copiar executaveis para as pastas de destino.
.EXAMPLE
  .\scripts\build-all.ps1
.EXAMPLE
  .\scripts\build-all.ps1 -Toolset v143 -SdkVersion 10.0.22621.0
#>
[CmdletBinding()]
param(
    [string]$MsBuild    = 'C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe',
    [string]$Toolset    = 'v145',
    [string]$SdkVersion = '10.0',
    [switch]$SkipCopy
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path -LiteralPath $MsBuild)) {
    Write-Error "MSBuild nao encontrado em: $MsBuild"
    exit 1
}

$MuServer = Join-Path $root 'MuServer'

$steps = @(
    @{Name='ConnectServer';              Sln='ConnectServer\ConnectServer.sln';        Config='Release';     Platform='Win32'; VcxDir='ConnectServer\ConnectServer';  OutDirRel='Release';              Dst='ConnectServer'}
    @{Name='DataServer';                 Sln='DataServer\DataServer.sln';              Config='Release';     Platform='Win32'; VcxDir='DataServer\DataServer';        OutDirRel='Release';              Dst='DataServer'}
    @{Name='JoinServer';                 Sln='JoinServer\JoinServer.sln';              Config='Release';     Platform='Win32'; VcxDir='JoinServer\JoinServer';        OutDirRel='Release';              Dst='JoinServer'}
    @{Name='cryptopp (servidor Release)';Sln='Util\cryptopp\cryptlib.vcxproj';         Config='Release';     Platform='Win32'; VcxDir='Util\cryptopp';               OutDirRel=$null;                  Dst=$null}
    @{Name='cryptopp (servidor Debug)';  Sln='Util\cryptopp\cryptlib.vcxproj';         Config='Debug';       Platform='Win32'; VcxDir='Util\cryptopp';               OutDirRel=$null;                  Dst=$null}
    @{Name='GameServer (Debug)';         Sln='GameServer\GameServer.sln';              Config='Debug';       Platform='Win32'; VcxDir='GameServer\GameServer';        OutDirRel='..\..\MuServer\GameServer'; Dst='GameServer'}
    @{Name='GameServerCS (Debug CS)';     Sln='GameServer\GameServer.sln';              Config='Debug_CS';    Platform='Win32'; VcxDir='GameServer\GameServer';        OutDirRel='..\..\MuServer\GameServerCS'; Dst='GameServerCS'; ExeName='GameServer.exe'}
    @{Name='GameServerCS (Release CS)';   Sln='GameServer\GameServer.sln';              Config='Release_CS';  Platform='Win32'; VcxDir='GameServer\GameServer';        OutDirRel='..\..\MuServer\GameServerCS'; Dst='GameServerCS'; ExeName='GameServer.exe'}
    @{Name='GameServerVIP (Release)';     Sln='GameServer\GameServer.sln';              Config='Release';     Platform='Win32'; VcxDir='GameServer\GameServer';        OutDirRel='..\..\MuServer\GameServerVIP'; Dst='GameServerVIP'}
    @{Name='cryptopp (cliente)';         Sln='Main\Util\cryptopp\cryptlib.vcxproj';    Config='Release';     Platform='Win32'; VcxDir='Main\Util\cryptopp';          OutDirRel=$null;                  Dst=$null}
    @{Name='Main.dll (cliente)';         Sln='Main\Main.sln';                          Config='Release';     Platform='Win32'; VcxDir='Main\Main';                   OutDirRel='Release';              Dst='Client'; ExeName='main.dll'}
)

$executed = @()
$failed = $false

function Invoke-MSBuild($step) {
    Write-Host "`n>>> $($step.Name) <<<" -ForegroundColor Cyan
    $args = @(
        $step.Sln
        '/m'
        '/t:Build'
        "/p:Configuration=$($step.Config)"
        "/p:Platform=$($step.Platform)"
        "/p:PlatformToolset=$Toolset"
        "/p:WindowsTargetPlatformVersion=$SdkVersion"
    )
    if ($step.OutDirRel) {
        $args += "/p:OutDir=$($step.OutDirRel)\"
    }

    & $MsBuild $args 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO: $($step.Name) falhou (exit code $LASTEXITCODE)" -ForegroundColor Red
        return $false
    }
    Write-Host "$($step.Name) OK" -ForegroundColor Green

    if (-not $SkipCopy -and $step.Dst) {
        Copy-Step $step
    }
    return $true
}

function Copy-Step($step) {
    $srcRel = $step.OutDirRel
    if (-not $srcRel) { return }

    $exeName = $step.ExeName
    if (-not $exeName) {
        $exeName = ($step.Name -replace ' \(.*', '') + '.exe'
    }

    $vcxDir = Join-Path $root $step.VcxDir
    $outDirAbs = [System.IO.Path]::GetFullPath((Join-Path $vcxDir $srcRel))
    $srcFile = Join-Path $outDirAbs $exeName

    $dstFile = Join-Path $MuServer "$($step.Dst)\$exeName"

    if (Test-Path -LiteralPath $srcFile) {
        $srcFull = [System.IO.Path]::GetFullPath($srcFile)
        $dstFull = [System.IO.Path]::GetFullPath($dstFile)
        if ($srcFull -eq $dstFull) {
            Write-Host "  Ja no destino: $srcFile" -ForegroundColor DarkYellow
            return
        }
        $dstParent = Split-Path -Parent $dstFile
        if (-not (Test-Path -LiteralPath $dstParent)) { New-Item -ItemType Directory -Path $dstParent -Force | Out-Null }
        Copy-Item -LiteralPath $srcFile -Destination $dstFile -Force
        Write-Host "  Copiado: $srcFile -> $dstFile" -ForegroundColor Yellow
        if (Test-Path "$srcFile.pdb") {
            Copy-Item -LiteralPath "$srcFile.pdb" -Destination $dstParent -Force
        }
    } else {
        Write-Warning "  Saida esperada nao encontrada: $srcFile"
    }
}

Write-Host "=== INICIANDO BUILD ALL ===" -ForegroundColor Cyan
Write-Host "MSBuild: $MsBuild"
Write-Host "Toolset: $Toolset"
Write-Host "SDK Win: $SdkVersion"
Write-Host "SkipCopy: $SkipCopy`n"

foreach ($step in $steps) {
    $ok = Invoke-MSBuild $step
    $executed += "$($step.Name): $(if ($ok) { 'OK' } else { 'FALHOU' })"
    if (-not $ok) {
        $failed = $true
        break
    }
}

Write-Host "`n===================================" -ForegroundColor Cyan
Write-Host "RESUMO:" -ForegroundColor Yellow
$executed | ForEach-Object { Write-Host "  $_" }

if ($failed) {
    Write-Host "Build interrompido por erro." -ForegroundColor Red
    exit 1
}
Write-Host "Build completo com sucesso!" -ForegroundColor Green
