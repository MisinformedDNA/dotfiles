# Install Boxstarter: `. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force`
# Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/MisinformedDNA/dotfiles/boxstarter/boxstarter.ps1
# http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/boxstarter/boxstarter.ps1

choco feature enable -n=useRememberedArgumentsForUpgrades

Install-WindowsUpdate -acceptEula

# Source control
choco upgrade git --params "/NoShellIntegration /NoGitLfs"
choco upgrade tortoisegit

# Editors
choco upgrade visualstudio2019enterprise --params "--add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetCoreTools
--add Microsoft.VisualStudio.Workload.VisualStudioExtension"
choco upgrade notepadplusplus
choco upgrade vscode --params "/NoDesktopIcon /NoQuicklaunchIcon"

# VS Code Extensions
choco upgrade vscode-csharp
choco upgrade vscode-powershell
choco upgrade vscode-gitlens
choco upgrade vscode-markdownlint

# Terminals
choco upgrade powershell-core
choco upgrade microsoft-windows-terminal

# Switch to PowerShell Core
refreshenv; pwsh

Write-Host "Pwsh started"
# Powershell Modules

Write-Host "NuGet"
Install-PackageProvider NuGet -Force
Write-Host "AZ"
Install-Module Az -AllowClobber -Scope CurrentUser -Force
Write-Host "ZLocation"
Install-Module ZLocation -Scope CurrentUser -Force; Import-Module ZLocation; Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserAllHosts
Write-Host "posh-git"
Install-Module posh-git -Scope CurrentUser -Force -AllowPrerelease; Add-PoshGitToProfile -AllHosts

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
choco upgrade onenote
choco upgrade powertoys
choco upgrade slack
choco upgrade spotify
