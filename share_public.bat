@echo off
TITLE SHAN-MART - Public Link Generator
COLOR 0A
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0share_public.ps1"
if %ERRORLEVEL% neq 0 (
    echo.
    echo Running fallback SSH tunnel with Terminal QR code...
    ssh -p 443 -R0:localhost:8080 qr@a.pinggy.io
)
pause
