# WayneWolf Windows Build Script
# This script downloads LibreWolf Windows and applies WayneWolf branding

param(
    [string]$Version = "141.0-1",
    [switch]$SkipDownload = $false
)

$ErrorActionPreference = "Stop"

Write-Host "================================" -ForegroundColor Green
Write-Host "WayneWolf Windows Builder" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "Version: $Version"
Write-Host "Package: WayneWolf Browser"
Write-Host ""

# Create directories
$BuildDir = "$PSScriptRoot\build"
$DistDir = "$PSScriptRoot\..\..\dist\windows"
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
New-Item -ItemType Directory -Force -Path $DistDir | Out-Null

# Download LibreWolf Windows if needed
if (-not $SkipDownload) {
    Write-Host "Downloading LibreWolf for Windows..." -ForegroundColor Yellow

    $LibreWolfUrl = "https://gitlab.com/api/v4/projects/32320088/packages/generic/librewolf/$Version/librewolf-$Version-windows-x86_64-portable.zip"
    $LibreWolfZip = "$BuildDir\librewolf-$Version.zip"

    try {
        Invoke-WebRequest -Uri $LibreWolfUrl -OutFile $LibreWolfZip -UseBasicParsing
        Write-Host "✓ Download complete" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to download LibreWolf" -ForegroundColor Red
        Write-Host "URL: $LibreWolfUrl"
        Write-Host "Error: $_"
        exit 1
    }

    # Extract
    Write-Host ""
    Write-Host "Extracting LibreWolf..." -ForegroundColor Yellow
    $ExtractPath = "$BuildDir\librewolf"
    if (Test-Path $ExtractPath) {
        Remove-Item -Path $ExtractPath -Recurse -Force
    }
    Expand-Archive -Path $LibreWolfZip -DestinationPath $ExtractPath -Force
    Write-Host "✓ Extraction complete" -ForegroundColor Green
}

# Apply WayneWolf branding
Write-Host ""
Write-Host "Applying WayneWolf branding..." -ForegroundColor Yellow

$LibreWolfDir = Get-ChildItem -Path "$BuildDir\librewolf" -Directory | Select-Object -First 1

if (-not $LibreWolfDir) {
    Write-Host "ERROR: LibreWolf directory not found" -ForegroundColor Red
    exit 1
}

Write-Host "  LibreWolf directory: $($LibreWolfDir.FullName)"

# Rename executable
$OldExe = "$($LibreWolfDir.FullName)\librewolf.exe"
$NewExe = "$($LibreWolfDir.FullName)\waynewolf.exe"

if (Test-Path $OldExe) {
    Rename-Item -Path $OldExe -NewName "waynewolf.exe"
    Write-Host "  ✓ Renamed executable to waynewolf.exe"
}

# Update application.ini
$AppIni = "$($LibreWolfDir.FullName)\application.ini"
if (Test-Path $AppIni) {
    $content = Get-Content -Path $AppIni -Raw
    $content = $content -replace "Name=LibreWolf", "Name=WayneWolf"
    $content = $content -replace "RemotingName=librewolf", "RemotingName=waynewolf"
    $content = $content -replace "CodeName=librewolf", "CodeName=waynewolf"
    $content | Set-Content -Path $AppIni -NoNewline
    Write-Host "  ✓ Updated application.ini"
}

# Update defaults/pref/local-settings.js
$LocalSettings = "$($LibreWolfDir.FullName)\defaults\pref\local-settings.js"
if (Test-Path $LocalSettings) {
    $content = Get-Content -Path $LocalSettings -Raw
    $content = $content -replace "librewolf", "waynewolf"
    $content = $content -replace "LibreWolf", "WayneWolf"
    $content | Set-Content -Path $LocalSettings -NoNewline
    Write-Host "  ✓ Updated local-settings.js"
}

# Copy WayneWolf icon if available
$IconSource = "$PSScriptRoot\..\..\waynewolf.ico"
if (Test-Path $IconSource) {
    Copy-Item -Path $IconSource -Destination "$($LibreWolfDir.FullName)\waynewolf.ico" -Force
    Write-Host "  ✓ Copied WayneWolf icon"
}

# Create redistribution package
Write-Host ""
Write-Host "Creating WayneWolf package..." -ForegroundColor Yellow

# Rename directory
$WayneWolfDir = "$BuildDir\WayneWolf"
if (Test-Path $WayneWolfDir) {
    Remove-Item -Path $WayneWolfDir -Recurse -Force
}
Rename-Item -Path $LibreWolfDir.FullName -NewName "WayneWolf"

# Create ZIP
$OutputZip = "$DistDir\waynewolf-$Version-windows-x86_64.zip"
if (Test-Path $OutputZip) {
    Remove-Item -Path $OutputZip -Force
}

Write-Host "  Creating ZIP archive..."
Compress-Archive -Path "$WayneWolfDir\*" -DestinationPath $OutputZip -CompressionLevel Optimal

# Generate SHA256 checksum
Write-Host "  Generating SHA256 checksum..."
$hash = Get-FileHash -Path $OutputZip -Algorithm SHA256
"$($hash.Hash)  waynewolf-$Version-windows-x86_64.zip" | Out-File -FilePath "$OutputZip.sha256" -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "Package: $OutputZip"
Write-Host "Size: $([math]::Round((Get-Item $OutputZip).Length / 1MB, 2)) MB"
Write-Host "SHA256: $($hash.Hash)"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Extract ZIP to desired location"
Write-Host "2. Run waynewolf.exe"
Write-Host ""
