<#Install Boxstarter:

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/MisinformedDNA/dotfiles/boxstarter/boxstarter.ps1
#http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/boxstarter/boxstarter.ps1

#> 

$VerbosePreference = 'Continue'
Set-PSDebug -Trace 2

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
choco feature enable -n=useRememberedArgumentsForUpgrades

New-Item -Type Directory -Path C:\ -Name temp -ErrorAction SilentlyContinue
choco config set cacheLocation c:\temp

# Windows
Install-WindowsUpdate -acceptEula
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
powershell -File (Join-Path $PSScriptRoot scripts/FileExplorerSettings.ps1)


# Source control
choco upgrade git --params "/NoShellIntegration /NoGitLfs"
choco upgrade tortoisegit

# Editors
choco upgrade visualstudio2019enterprise --params "--add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetCoreTools
--add Microsoft.VisualStudio.Workload.VisualStudioExtension"
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
choco install microsoft-teams
choco upgrade onenote
choco upgrade powertoys
choco upgrade slack
choco upgrade spotify

# Terminals
choco upgrade powershell-core
choco upgrade microsoft-windows-terminal

refreshenv

# VS Code Extensions
Write-Host "Install VS Code extensions"
code --install-extension ms-dotnettools.csharp
code --install-extension ms-vscode.powershell
code --install-extension eamodio.gitlens
code --install-extension davidanson.vscode-markdownlint

# # Switch to PowerShell Core
# #refreshenv; pwsh

# # Clone dotfiles
Write-Host "Clone dotfiles"
$reposPath = "/repos"
$dotfilesPath = Join-Path $reposPath dotfiles
New-Item $reposPath -ItemType Directory
Set-Location $reposPath
git clone https://github.com/MisinformedDNA/dotfiles/

Set-Location $dotfilesPath
git checkout boxstarter
git pull

# Powershell Modules
Write-Host "Install NuGet"
Install-PackageProvider NuGet -Force
Write-Host "Install PowerShellGet"
Install-Module PowerShellGet -Force; Import-Module PowerShellGet
Write-Host "Install Az"
Install-Module Az -AllowClobber -Scope CurrentUser -Force
Write-Host "Install ZLocation"
Install-Module ZLocation -Scope CurrentUser -Force
Write-Host "Install posh-git"
powershell -Command { Install-Module posh-git -Scope CurrentUser -Force -AllowPrerelease }

Write-Host "Calling powershell setup"
$pwshSetupPath = Join-Path $dotfilesPath "/scripts/setup-pwsh.ps1"
pwsh -File $pwshSetupPath

Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=2076587 -OutFile azuredevops_inttooloffice2019_enu.exe
azuredevops_inttooloffice2019_enu.exe /quiet
