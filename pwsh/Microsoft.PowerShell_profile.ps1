#Used for Microsoft's PowerShell console/host
Write-Host "Loading Microsoft.PowerShell_profile.ps1"
Remove-Item alias:r -Force

function repos
{
    Set-Location C:\Repos
}

Set-Alias r repos

function home {
	Set-Location $env:userprofile
}

function vs {
	Set-Location "$env:userprofile\Documents\Visual Studio 2017\Projects\"
}

function gcir {
	Get-ChildItem . -Recurse -Filter $args[0]
}

Set-Alias fs gcir	# file search


function finds([string]$value, [string]$path)
{
    findstr /spi /c:$value $path
}


function tg { TortoiseGitProc.exe /command:$args }

function tgc { tg commit }

# Chocolatey profile
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }
