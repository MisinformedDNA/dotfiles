Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
choco feature enable -n=useRememberedArgumentsForUpgrades

New-Item -Type Directory -Path C:\ -Name temp -ErrorAction SilentlyContinue
choco config set cacheLocation c:\temp

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All

# Source control
choco upgrade git --params "/NoShellIntegration /NoGitLfs"
choco upgrade tortoisegit

# Editors
. (Join-Path $PSScriptRoot Install-VisualStudio.ps1)
choco upgrade notepadplusplus
choco upgrade vscode --params "/NoDesktopIcon /NoQuicklaunchIcon"

# CLIs
choco upgrade azure-cli
choco upgrade nodejs-lts
choco upgrade pulumi

# Tools
choco upgrade azure-cosmosdb-emulator
choco upgrade dotpeek
choco upgrade fiddler
choco upgrade microsoftazurestorageexplorer
choco upgrade postman
choco upgrade sql-server-management-studio
choco upgrade sysinternals
choco upgrade winmerge

# Other
choco upgrade adobereader
choco upgrade microsoft-edge
choco upgrade microsoft-teams
choco upgrade onenote --ignore-checksum
choco upgrade powertoys
choco upgrade slack
choco upgrade spotify

# Terminals
choco upgrade powershell-core
choco upgrade microsoft-windows-terminal

Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=2076587 -OutFile azuredevops_inttooloffice2019_enu.exe
./azuredevops_inttooloffice2019_enu.exe /quiet
