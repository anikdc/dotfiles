# bootstrap.ps1
# Automates the setup of Alacritty configuration on Windows.

$ErrorActionPreference = "Stop"

Write-Host "==> Starting Alacritty bootstrap script..." -ForegroundColor Cyan

# Resolve paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir
$AlacrittyConfigDir = Join-Path $env:APPDATA "alacritty"

$DestConfigFile = Join-Path $AlacrittyConfigDir "alacritty.toml"
$SourceConfigFile = Join-Path $RepoDir "alacritty\alacritty.toml"

$DestThemesDir = Join-Path $AlacrittyConfigDir "themes"
$SourceThemesDir = Join-Path $RepoDir "alacritty\themes"

# 1. Ensure the destination directory exists
if (-not (Test-Path $AlacrittyConfigDir)) {
    Write-Host "--> Creating Alacritty config directory..." -ForegroundColor Gray
    New-Item -Path $AlacrittyConfigDir -ItemType Directory | Out-Null
}

# Helper function to create a link with fallback
function Create-Link {
    param (
        [string]$LinkPath,
        [string]$TargetPath,
        [string]$LinkType # 'SymbolicLink' or 'Junction' or 'HardLink'
    )

    if (Test-Path $LinkPath) {
        $item = Get-Item $LinkPath
        if ($item.Attributes -match "ReparsePoint" -or $item.LinkType) {
            Write-Host "--> Removing existing link at $LinkPath" -ForegroundColor Gray
            Remove-Item $LinkPath -Force
        } else {
            $BackupPath = "$LinkPath.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Host "--> Backing up existing physical item from $LinkPath to $BackupPath" -ForegroundColor Yellow
            Rename-Item -Path $LinkPath -NewName (Split-Path $BackupPath -Leaf)
        }
    }

    Write-Host "--> Creating link: $LinkPath -> $TargetPath" -ForegroundColor Gray
    
    # Try to create the link
    $null = New-Item -ItemType $LinkType -Path $LinkPath -Value $TargetPath -ErrorAction SilentlyContinue

    if (Test-Path $LinkPath) {
        Write-Host "[OK] Successfully linked $LinkPath using $LinkType" -ForegroundColor Green
        return
    }

    Write-Warning "Failed to create $LinkType. Trying fallback..."

    if ($LinkType -eq "SymbolicLink") {
        # Fallback 1: HardLink
        Write-Host "--> Trying HardLink fallback..." -ForegroundColor Gray
        $null = New-Item -ItemType HardLink -Path $LinkPath -Value $TargetPath -ErrorAction SilentlyContinue
        if (Test-Path $LinkPath) {
            Write-Host "[OK] Successfully linked using HardLink" -ForegroundColor Green
            return
        }

        # Fallback 2: Copy file
        Write-Host "--> Falling back to copying file..." -ForegroundColor Gray
        Copy-Item -Path $TargetPath -Destination $LinkPath -Force
        Write-Host "[OK] Copied file to $LinkPath (Warning: updates will not auto-sync)" -ForegroundColor Yellow
    } elseif ($LinkType -eq "Junction") {
        # Fallback: Copy folder
        Write-Host "--> Falling back to copying folder..." -ForegroundColor Gray
        Copy-Item -Path $TargetPath -Destination $LinkPath -Recurse -Force
        if (Test-Path $LinkPath) {
            Write-Host "[OK] Copied folder to $LinkPath (Warning: updates will not auto-sync)" -ForegroundColor Yellow
        } else {
            Write-Error "Failed to copy folder to $LinkPath"
        }
    }
}

# 2. Link the Alacritty configuration file
Create-Link -LinkPath $DestConfigFile -TargetPath $SourceConfigFile -LinkType "SymbolicLink"

# 3. Link the Themes directory
# Note: Using Junction for directories on Windows as it doesn't require administrator privileges.
Create-Link -LinkPath $DestThemesDir -TargetPath $SourceThemesDir -LinkType "Junction"

Write-Host "==> Setup completed successfully!" -ForegroundColor Green
