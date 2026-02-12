# Enable Hyper-V if supported (requires Windows Pro/Enterprise/Education)
$hyperv = Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart -ErrorAction SilentlyContinue
if (-not $hyperv) {
    Write-Warning "Hyper-V not available (requires Windows Pro/Enterprise/Education)"
}

# Install all apps from winget configuration file
Write-Host "Installing applications from winget-packages.json..."
$wingetPackagesPath = Join-Path (Split-Path $PSScriptRoot -Parent) "winget-packages.json"
winget import -i $wingetPackagesPath --accept-package-agreements --accept-source-agreements --ignore-versions

# Install CascadiaCode font
oh-my-posh font install CascadiaCode

# Setup Windows Terminal
. (Join-Path $PSScriptRoot ../apps/WindowsTerminal/setup.ps1)

# Configure Git
. (Join-Path $PSScriptRoot Configure-Git.ps1)



