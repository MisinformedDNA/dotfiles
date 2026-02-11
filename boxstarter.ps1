<#Install Boxstarter:

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/MisinformedDNA/dotfiles/main/boxstarter.ps1
#http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/main/boxstarter.ps1

#> 

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
choco feature enable -n=useRememberedArgumentsForUpgrades

New-Item -Type Directory -Path C:\ -Name temp -ErrorAction SilentlyContinue
choco config set cacheLocation c:\temp

choco upgrade git --params="'/NoShellIntegration /NoGitLfs'"
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
. (Join-Path $dotfilesPath scripts/Install-PowershellModules.ps1)

Write-Host "Calling powershell setup"
$pwshSetupPath = Join-Path $dotfilesPath "/scripts/Setup-PowerShell.ps1"
pwsh -File $pwshSetupPath
