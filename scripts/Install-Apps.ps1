# Enable Hyper-V if supported (requires Windows Pro/Enterprise/Education)
try { 
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart -ErrorAction Stop 
} catch { 
    Write-Warning "Hyper-V not available (requires Windows Pro/Enterprise/Education)" 
}

# Terminals
winget install --id Microsoft.PowerShell --exact --accept-package-agreements --accept-source-agreements
winget install --id JanDeDobbeleer.OhMyPosh --exact --accept-package-agreements --accept-source-agreements
oh-my-posh font install CascadiaCode

. (Join-Path $PSScriptRoot ../apps/WindowsTerminal/setup.ps1)

# Source control
winget install --id Git.Git --exact --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.GitCredentialManager --exact --accept-package-agreements --accept-source-agreements
. (Join-Path $PSScriptRoot Configure-Git.ps1)

# Set LOL git config
if ($env:UserDomain -eq "ENT") {
    $lolConfigPath = "c:/Users/$env:USERNAME/.lol.gitconfig"
    if (-not (Test-Path $lolConfigPath)) {
        New-Item $lolConfigPath -ItemType File -ErrorAction SilentlyContinue
        git config --file=$lolConfigPath user.name ""
        git config --file=$lolConfigPath user.email ""

        git config --global includeIf."gitdir:c:/repos/lol/".path $lolConfigPath
        git config --global includeIf."gitdir:c:/repos/lolgh/".path $lolConfigPath
        Write-Host "Configured git credentials for c:/repos/lol/ and c:/repos/lolgh/ directories"
    }
}

winget install --id TortoiseGit.TortoiseGit --exact --accept-package-agreements --accept-source-agreements

# Editors
winget install --id Microsoft.VisualStudioCode --exact --accept-package-agreements --accept-source-agreements --override '/VERYSILENT /NORESTART /MERGETASKS=!runcode,!desktopicon,!quicklaunchicon'

# Tools
winget install --id WinMerge.WinMerge --exact --accept-package-agreements --accept-source-agreements

# Other
winget install --id Microsoft.PowerToys --exact --accept-package-agreements --accept-source-agreements
winget install --id Spotify.Spotify --exact --accept-package-agreements --accept-source-agreements
