@echo off
title MuOnline Account Creator
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "account-creator-gui.ps1"
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to launch GUI.
    echo Make sure PowerShell 5.1+ is installed.
    pause
)
