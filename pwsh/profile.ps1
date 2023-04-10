#Used for all Powershell hosts
Write-Host "Loading profile.ps1"

#Import-Module PowerTab
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression

[System.Environment]::SetEnvironmentVariable("POWERSHELL_UPDATECHECK", "Off", "User")

# . $PSScriptRoot/Set-Aliases.ps1
. (Join-Path $PSScriptRoot "Set-GitAliases.ps1")
. (Join-Path $PSScriptRoot "Set-Shortcuts.ps1")
. (Join-Path $PSScriptRoot "Initialize-Pulumi.ps1")

Import-Module posh-git

function c {
	code
}

function cleanbin {
	Get-ChildItem .\ -Include bin,obj -Recurse `
		| ?{ -not $_.FullName.Contains('CMSModules') } `
		| %{ Remove-Item $_.FullName -Force -Recurse }
}

function w {
	wyam
}

function wb {
	wyam build
}

function wp {
	wyam -p -w
}
