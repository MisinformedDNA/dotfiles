# Install all apps from winget configuration file
Write-Host "Installing applications from winget-packages.json..."
$wingetPackagesPath = Join-Path (Split-Path $PSScriptRoot -Parent) "winget-packages.json"

if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget import -i $wingetPackagesPath --accept-package-agreements --accept-source-agreements --ignore-versions
}
else {
    Write-Warning "winget is not installed or not in PATH; skipping application import."
}

# Install CascadiaCode font
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh font install CascadiaCode
}
else {
    Write-Warning "oh-my-posh not found; skipping font installation."
}

# Setup Windows Terminal
. (Join-Path $PSScriptRoot ../apps/WindowsTerminal/setup.ps1)

# Configure Git
. (Join-Path $PSScriptRoot Configure-Git.ps1)



