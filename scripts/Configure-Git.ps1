#!/usr/bin/env pwsh
# Shared Git configuration for both Windows and Linux/Codespaces environments

param(
    [string]$UserName = "MisinformedDNA",
    [string]$UserEmail = "1784452+MisinformedDNA@users.noreply.github.com"
)

Write-Host "Configuring Git..." -ForegroundColor Cyan

# Core settings
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true

# User identity
git config --global user.name $UserName
git config --global user.email $UserEmail

# Aliases
Write-Host "  Setting Git aliases..." -ForegroundColor Gray
git config --global alias.cp cherry-pick
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'

# Set LOL git config
if ($env:UserDomain -eq "ENT") {
    Write-Host "Configuring git credentials for c:/repos/lol/ and c:/repos/lolgh/ directories"
    Write-Host "Run this manually:" -ForegroundColor Yellow
    Write-Host "git config --file=$lolConfigPath user.name """
    Write-Host "git config --file=$lolConfigPath user.email """
    $lolConfigPath = "c:/Users/$env:USERNAME/.lol.gitconfig"
    if (-not (Test-Path $lolConfigPath)) {
        New-Item $lolConfigPath -ItemType File -ErrorAction SilentlyContinue
        git config --file=$lolConfigPath user.name ""
        git config --file=$lolConfigPath user.email ""

        git config --global includeIf."gitdir:c:/repos/lol/".path $lolConfigPath
        git config --global includeIf."gitdir:c:/repos/lolgh/".path $lolConfigPath

    }
}

Write-Host "  Git configured successfully" -ForegroundColor Green
