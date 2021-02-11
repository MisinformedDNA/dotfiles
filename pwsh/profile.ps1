#Used for all Powershell hosts
Write-Host "Loading profile.ps1"

#Import-Module PowerTab
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
Import-Module posh-git
Import-Module ZLocation


# . $PSScriptRoot/Set-Aliases.ps1
. (Join-Path $PSScriptRoot "Set-GitAliases.ps1")
. (Join-Path $PSScriptRoot "Set-Shortcuts.ps1")

function c {
	code
}
function cleanbin {
	Get-ChildItem .\ -Include bin,obj -Recurse `
		| ?{ -not $_.FullName.Contains('CMSModules') } `
		| %{ Remove-Item $_.FullName -Force -Recurse }
}

$dotnet = "D:\Repos\corefxlab\dotnetcli\dotnet.exe"
	
function dn {
	Invoke-Expression $dotnet
}

function pollingtest(
		[string]$Configuration = "Debug",
		[string]$testFile = "D:\Repos\corefxlab\tests\System.IO.FileSystem.Watcher.Polling.Tests\System.IO.FileSystem.Watcher.Polling.Tests.csproj") {
	Invoke-Expression "$dotnet test $testFile -c $Configuration --no-build -- -notrait category=DerivedTests" #-notrait category=performance -notrait category=outerloop  
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
