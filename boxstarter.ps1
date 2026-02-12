<#Install Boxstarter:
http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/main/boxstarter.ps1
#>

# Ensure git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing git..."
    winget install --id Git.Git -e --silent
    refreshenv
    
    # Verify git is now available
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Warning "Git installation failed or not in PATH. Please install Git manually and re-run."
        exit 1
    }
}

# Clone dotfiles
Write-Host "Cloning dotfiles repository..."
$reposPath = "C:\repos"
$dotfilesPath = Join-Path $reposPath "dotfiles"

New-Item $reposPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

if (Test-Path $dotfilesPath) {
    Write-Host "Dotfiles directory already exists at $dotfilesPath"
    Set-Location $dotfilesPath
} else {
    Set-Location $reposPath
    git clone https://github.com/MisinformedDNA/dotfiles/
    
    if (-not (Test-Path $dotfilesPath)) {
        Write-Warning "Failed to clone dotfiles repository. Please check your internet connection and try again."
        exit 1
    }
    
    Set-Location $dotfilesPath
}

. (Join-Path $dotfilesPath scripts/Initialize-Windows.ps1)
. (Join-Path $dotfilesPath scripts/Install-Apps.ps1)

Write-Host "Calling powershell setup"
$pwshSetupPath = Join-Path $dotfilesPath "Setup.ps1"
pwsh -File $pwshSetupPath
