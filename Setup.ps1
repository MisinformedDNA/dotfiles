#!/usr/bin/env pwsh
# Shared PowerShell environment setup for Windows and Codespaces/Linux

Write-Host "Setting up PowerShell environment..." -ForegroundColor Green

$isWindowsPlatform = $env:OS -eq "Windows_NT"

# Install PowerShell modules
. (Join-Path $PSScriptRoot scripts/Install-PowerShellModules.ps1)

# Install Oh My Posh
Write-Host "Installing Oh My Posh..." -ForegroundColor Cyan
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    if ($isWindowsPlatform) {
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id JanDeDobbeleer.OhMyPosh -e --silent
            if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
                Write-Warning "Oh My Posh installation failed. Please install manually from https://ohmyposh.dev"
            }
        } else {
            Write-Warning "No winget found; please install Oh My Posh manually on Windows."
        }
    } else {
        $downloadUrl = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64"
        $tempPath = "/tmp/oh-my-posh"
        $targetPath = "/usr/local/bin/oh-my-posh"
        
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath -ErrorAction SilentlyContinue
        
        if (Test-Path $tempPath) {
            Move-Item -Path $tempPath -Destination $targetPath -Force -ErrorAction SilentlyContinue
            
            if (-not (Test-Path $targetPath)) {
                Write-Host "Permission required to move to $targetPath; trying with sudo..." -ForegroundColor Yellow
                sudo mv $tempPath $targetPath
            }
            
            if (Test-Path $targetPath) {
                & chmod +x $targetPath
            } else {
                Write-Warning "Failed to install Oh My Posh to $targetPath"
            }
        } else {
            Write-Warning "Failed to download Oh My Posh from $downloadUrl"
        }
    }
}

# Ensure POSH_THEMES_PATH and download paradox theme locally (Linux/Codespaces only)
# On Windows, oh-my-posh installation sets POSH_THEMES_PATH and includes all themes
if (-not $isWindowsPlatform) {
    if (-not $env:POSH_THEMES_PATH) {
        $homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
        $themesDir = Join-Path $homePath ".poshthemes"
        if (-not (Test-Path $themesDir)) { New-Item -ItemType Directory -Path $themesDir -Force | Out-Null }
        $env:POSH_THEMES_PATH = $themesDir
    }
    $paradoxPath = Join-Path $env:POSH_THEMES_PATH "paradox.omp.json"
    if (-not (Test-Path $paradoxPath)) {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/paradox.omp.json" -OutFile $paradoxPath -ErrorAction SilentlyContinue
        if (-not (Test-Path $paradoxPath)) {
            Write-Warning "Could not download paradox theme. Will use built-in theme."
        }
    }
}

# Set up Git configuration
. (Join-Path $PSScriptRoot scripts/Configure-Git.ps1)

# Set up PowerShell profile
Write-Host "Setting up PowerShell profile..." -ForegroundColor Cyan
$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir = Split-Path $profilePath -Parent
if (-not (Test-Path $profileDir)) { New-Item -Type Directory -Path $profileDir -Force | Out-Null }

$repoRoot = $PSScriptRoot
$sourceProfile = Join-Path $repoRoot "pwsh/profile.ps1"
$sourceGitAliases = Join-Path $repoRoot "pwsh/Set-GitAliases.ps1"

if (Test-Path $sourceProfile) {
    Copy-Item $sourceProfile $profilePath -Force
    Write-Host "  Profile copied to $profilePath" -ForegroundColor Green
    $gitAliasesDestination = Join-Path $profileDir "Set-GitAliases.ps1"
    if (Test-Path $sourceGitAliases) { Copy-Item $sourceGitAliases $gitAliasesDestination -Force; Write-Host "  Git aliases copied to $gitAliasesDestination" -ForegroundColor Green }
} else {
    Write-Warning "Source profile not found at $sourceProfile"
}

Write-Host "`nSetup complete! Restart your PowerShell session or run: . `$PROFILE" -ForegroundColor Green
Write-Host "Git function aliases available: ga, gac, gacp, gb, gc, gcmm, gco, gcob, gd, gl, gp, gpl, gs, and more" -ForegroundColor Cyan
