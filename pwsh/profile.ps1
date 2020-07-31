#Used for all Powershell hosts
Write-Host "Loading profile.ps1"

#Import-Module PowerTab
. (Join-Path $PSScriptRoot "Setup-PoshGit.ps1")

# . $PSScriptRoot/Set-Aliases.ps1
. (Join-Path $PSScriptRoot "Set-GitAliases.ps1")

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

Import-Module ZLocation
