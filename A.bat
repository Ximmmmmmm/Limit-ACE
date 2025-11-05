@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0ACE.ps1"
pause
