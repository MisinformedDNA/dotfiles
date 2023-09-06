Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
choco feature enable -n=useRememberedArgumentsForUpgrades

New-Item -Type Directory -Path C:\ -Name temp -ErrorAction SilentlyContinue
choco config set cacheLocation c:\temp

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All

# Terminals
choco upgrade powershell-core
choco upgrade microsoft-windows-terminal

winget install JanDeDobbeleer.OhMyPosh -s winget
oh-my-posh font install CascadiaCode

. (Join-Path $PSScriptRoot ../apps/WindowsTerminal/setup.ps1)


# Source control
# Already installed: git
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true
git config --global alias.cp cherry-pick

# Set LOL git config
if ($env:UserDomain -eq "ENT") {
    $customConfigPath = Join-Path $env:UserProfile ".lol.gitconfig"
    New-Item $customConfigPath -ItemType File -ErrorAction SilentlyContinue
    git config --file=$customConfigPath user.email "[Email]"

    git config --global includeIf.gitdir:C:/repos/lol/.path $customConfigPath
}

choco upgrade tortoisegit

# Editors
#choco upgrade visualstudio2022enterprise
#. (Join-Path $PSScriptRoot Install-VisualStudio.ps1)
choco upgrade notepadplusplus
choco upgrade vscode --params="'/NoDesktopIcon /NoQuicklaunchIcon'"

# CLIs
choco upgrade azure-cli
choco upgrade nodejs-lts
#choco upgrade pulumi

# Tools
choco upgrade azure-cosmosdb-emulator
choco upgrade dotpeek
choco upgrade fiddler
choco upgrade microsoftazurestorageexplorer
choco upgrade postman
choco upgrade azure-data-studio
choco upgrade sysinternals

choco upgrade winmerge
$env:path += ";C:\Program Files\WinMerge"

iex "& { $(irm https://aka.ms/install-artifacts-credprovider.ps1) } -AddNetfx -Force"

# Other
choco upgrade adobereader
#choco upgrade microsoft-edge
#choco upgrade microsoft-teams
#choco upgrade onenote --ignore-checksum
choco upgrade powertoys
#choco upgrade slack
choco upgrade spotify
