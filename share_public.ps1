# Shan-Mart Worldwide Public Access Generator
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "SHAN-MART - Public Mobile & Multi-Device Tunnel"

Clear-Host
Write-Host "====================================================================" -ForegroundColor Cyan
Write-Host "              SHAN-MART PUBLIC LINK GENERATOR                      " -ForegroundColor Yellow
Write-Host "====================================================================" -ForegroundColor Cyan
Write-Host ""

$conn = Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue
if (-not $conn) {
    Write-Host "[!] Note: Shan-Mart on port 8080 is not currently active." -ForegroundColor Yellow
    Write-Host "    Make sure you have run start_shan_mart.bat first!" -ForegroundColor Yellow
    Write-Host ""
}

$cfPath = $null
$candidates = @(
    "C:\Program Files (x86)\cloudflared\cloudflared.exe",
    "C:\Program Files\cloudflared\cloudflared.exe",
    "$env:LOCALAPPDATA\Microsoft\WinGet\Links\cloudflared.exe"
)

foreach ($c in $candidates) {
    if (Test-Path $c) {
        $cfPath = $c
        break
    }
}

if (-not $cfPath) {
    $cmd = Get-Command cloudflared -ErrorAction SilentlyContinue
    if ($cmd) {
        $cfPath = $cmd.Source
    }
}

if ($cfPath) {
    Write-Host "[1/2] Connecting to Cloudflare Global Edge Network..." -ForegroundColor Green
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $cfPath
    $pinfo.Arguments = "tunnel --url http://localhost:8080"
    $pinfo.RedirectStandardError = $true
    $pinfo.UseShellExecute = $false
    $pinfo.CreateNoWindow = $true
    
    $proc = [System.Diagnostics.Process]::Start($pinfo)
    $foundUrl = $null
    
    while (-not $proc.HasExited -and -not $foundUrl) {
        $line = $proc.StandardError.ReadLine()
        if ($line -match "https://[a-zA-Z0-9-]+\.trycloudflare\.com") {
            $foundUrl = $Matches[0]
            break
        }
    }
    
    if ($foundUrl) {
        $appUrl = "$foundUrl/shanjays-mart/"
        
        try {
            Set-Clipboard -Value $appUrl
        } catch {
        }
        
        Write-Host ""
        Write-Host "====================================================================" -ForegroundColor Green
        Write-Host "       SUCCESS! YOUR PUBLIC WEBSITE LINK IS READY:                  " -ForegroundColor Yellow
        Write-Host "====================================================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "   URL:  $appUrl" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "====================================================================" -ForegroundColor Green
        Write-Host "   [+] COPIED TO CLIPBOARD: Ready to paste into WhatsApp / Email!" -ForegroundColor White
        Write-Host "   [+] COMPATIBILITY: Works on Android, iPhone, iPad, and Laptops!" -ForegroundColor White
        Write-Host "   [+] ACCESSIBLE ON: Mobile Data (4G/5G) and any Wi-Fi worldwide!" -ForegroundColor White
        Write-Host "====================================================================" -ForegroundColor Green
        Write-Host ""
        
        $encoded = [System.Uri]::EscapeDataString($appUrl)
        $qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=350x350" + [char]38 + "data=" + $encoded
        try {
            Start-Process $qrUrl
            Write-Host "[*] QR code opened in browser! Scan it with your phone camera." -ForegroundColor Magenta
        } catch {
        }
        
        Write-Host ""
        Write-Host "Keep this window open while testing. Press Ctrl+C to stop sharing." -ForegroundColor DarkGray
        
        $proc.WaitForExit()
    } else {
        Write-Host "[!] Cloudflare Tunnel timed out. Starting SSH Pinggy fallback..." -ForegroundColor Yellow
        ssh -p 443 -R0:localhost:8080 qr@a.pinggy.io
    }
} else {
    Write-Host "[!] Cloudflare not found. Starting SSH Pinggy fallback..." -ForegroundColor Yellow
    ssh -p 443 -R0:localhost:8080 qr@a.pinggy.io
}
