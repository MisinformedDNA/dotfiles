<#Install Boxstarter:
http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/main/boxstarter.ps1
#>

# Ensure git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing git..."
    winget install --id Git.Git -e --silent
    refreshenv
}

# # Clone dotfiles
Write-Host "Clone dotfiles"
$reposPath = "/repos"
$dotfilesPath = Join-Path $reposPath dotfiles
New-Item $reposPath -ItemType Directory -Force | Out-Null
Set-Location $reposPath
git clone https://github.com/MisinformedDNA/dotfiles/

Set-Location $dotfilesPath

. (Join-Path $dotfilesPath scripts/Initialize-Windows.ps1)
. (Join-Path $dotfilesPath scripts/Install-Apps.ps1)

Write-Host "Calling powershell setup"
$pwshSetupPath = Join-Path $dotfilesPath "Setup.ps1"
pwsh -File $pwshSetupPath
