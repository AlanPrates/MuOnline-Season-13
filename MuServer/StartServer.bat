@echo off
setlocal
cd /d "%~dp0"

start "ConnectServer" /d "%~dp0ConnectServer" "ConnectServer.exe"
timeout /t 2 /nobreak >nul

start "DataServer" /d "%~dp0DataServer" "DataServer.exe"
timeout /t 2 /nobreak >nul

start "JoinServer" /d "%~dp0JoinServer" "JoinServer.exe"
timeout /t 2 /nobreak >nul

start "GameServer" /d "%~dp0GameServer" "GameServer.exe"
timeout /t 2 /nobreak >nul

if exist "%~dp0GameServerCS\GameServer.exe" (
  start "GameServerCS" /d "%~dp0GameServerCS" "GameServer.exe"
)

endlocal
