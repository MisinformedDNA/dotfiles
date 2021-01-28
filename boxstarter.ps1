# Install Boxstarter: `. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force`
# Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/MisinformedDNA/dotfiles/boxstarter/boxstarter.ps1
# http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/boxstarter/boxstarter.ps1

choco feature enable -n=useRememberedArgumentsForUpgrades

# Source control
choco install git --params "/NoShellIntegration /NoGitLfs"
choco install tortoisegit

# Editors
choco install visualstudio2019enterprise --params "--add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetCoreTools
--add Microsoft.VisualStudio.Workload.VisualStudioExtension"

choco install notepadplusplus

choco install vscode --params "/NoDesktopIcon /NoQuicklaunchIcon"
choco install vscode-csharp
choco install vscode-powershell
choco install vscode-gitlens
choco install vscode-markdownlint

# Terminals
choco install powershell-core
choco install microsoft-windows-terminal

# Switch to PowerShell Core
refreshenv; pwsh

# Powershell Modules

Install-PackageProvider NuGet -Force
Install-Module Az -AllowClobber -Scope CurrentUser
Install-Module ZLocation -Scope CurrentUser -Force; Import-Module ZLocation; Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserAllHosts
Install-Module posh-git -Scope CurrentUser -Force -AllowPrerelease; Add-PoshGitToProfile -AllHosts

# CLIs
choco install azure-cli
choco install nodejs-lts
choco install pulumi

# Tools
choco install azure-cosmosdb-emulator
choco install dotpeek
choco install fiddler
choco install microsoftazurestorageexplorer
choco install postman
choco install sql-server-management-studio
choco install sysinternals
choco install winmerge

# Other
choco install adobereader
choco install microsoft-edge
choco install onenote
choco install powertoys
choco install slack
choco install spotify
