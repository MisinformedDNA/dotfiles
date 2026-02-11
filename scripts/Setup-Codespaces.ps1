#!/usr/bin/env pwsh
# Codespaces/Linux setup script for PowerShell modules and git configuration

Write-Host "Setting up PowerShell environment for Codespaces..." -ForegroundColor Green

# Install PowerShell modules
. (Join-Path $PSScriptRoot Install-PowerShellModules.ps1)

# Install Oh My Posh (Linux version)
Write-Host "Installing Oh My Posh..." -ForegroundColor Cyan
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Invoke-WebRequest -Uri "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64" -OutFile /usr/local/bin/oh-my-posh
    chmod +x /usr/local/bin/oh-my-posh
}

# Set up Git configuration
. (Join-Path $PSScriptRoot Configure-Git.ps1)

# Set up PowerShell profile
Write-Host "Setting up PowerShell profile..." -ForegroundColor Cyan
$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir = Split-Path $profilePath -Parent

if (-not (Test-Path $profileDir)) {
    New-Item -Type Directory -Path $profileDir -Force | Out-Null
}

# Copy profile and git aliases from repo
$repoRoot = Split-Path $PSScriptRoot -Parent
$sourceProfile = Join-Path $repoRoot "pwsh/profile.ps1"
$sourceGitAliases = Join-Path $repoRoot "pwsh/Set-GitAliases.ps1"

if (Test-Path $sourceProfile) {
    Copy-Item $sourceProfile $profilePath -Force
    Write-Host "  Profile copied to $profilePath" -ForegroundColor Green
    
    # Copy Set-GitAliases.ps1 to the same directory as profile so it can be sourced
    $gitAliasesDestination = Join-Path $profileDir "Set-GitAliases.ps1"
    if (Test-Path $sourceGitAliases) {
        Copy-Item $sourceGitAliases $gitAliasesDestination -Force
        Write-Host "  Git aliases copied to $gitAliasesDestination" -ForegroundColor Green
    }
} else {
    Write-Warning "Source profile not found at $sourceProfile"
}

Write-Host "`nSetup complete! Restart your PowerShell session or run: . `$PROFILE" -ForegroundColor Green
Write-Host "Git function aliases available: ga, gac, gacp, gb, gc, gcmm, gco, gcob, gd, gl, gp, gpl, gs, and more" -ForegroundColor Cyan
