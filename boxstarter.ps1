<#Install Boxstarter:

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/MisinformedDNA/dotfiles/main/boxstarter.ps1
#http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/main/boxstarter.ps1

#> 

#TODO Install MS Todo
#Install GitHub Codespaces for VS Code
#Install artifacts credential manager

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
choco feature enable -n=useRememberedArgumentsForUpgrades

New-Item -Type Directory -Path C:\ -Name temp -ErrorAction SilentlyContinue
choco config set cacheLocation c:\temp

# Windows
#Install-WindowsUpdate -acceptEula

choco upgrade git --params "'/NoShellIntegration /NoGitLfs'"
refreshenv

# # Clone dotfiles
Write-Host "Clone dotfiles"
$reposPath = "/repos"
$dotfilesPath = Join-Path $reposPath dotfiles
New-Item $reposPath -ItemType Directory
Set-Location $reposPath
git clone https://github.com/MisinformedDNA/dotfiles/

Set-Location $dotfilesPath
git checkout main
git pull

. (Join-Path $dotfilesPath scripts/Initialize-Windows.ps1)
. (Join-Path $dotfilesPath scripts/Install-Apps.ps1)

# VS Code Extensions
#Write-Host "Install VS Code extensions"
#code --install-extension ms-dotnettools.csharp
#code --install-extension ms-vscode.powershell
#code --install-extension eamodio.gitlens
#code --install-extension davidanson.vscode-markdownlint

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
