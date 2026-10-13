@echo off
title Launching OmniReverse OSINT Pro...
cd /d "%~dp0"
start "" powershell.exe -ExecutionPolicy Bypass -NoProfile -STA -WindowStyle Hidden -File "%~dp0OmniReverse.ps1"
exit
