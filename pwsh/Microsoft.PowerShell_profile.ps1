#Used for Microsoft's PowerShell console/host
Write-Host "Loading Microsoft.PowerShell_profile.ps1"

# Cross-platform text search using PowerShell
function fstr([string]$value, [string]$path) {
	Get-ChildItem $path -Recurse -File | Select-String -Pattern $value -CaseSensitive:$false
}

# Windows-only TortoiseGit integration
if ($IsWindows -or $env:OS -eq "Windows_NT") {
	function tg { TortoiseGitProc.exe /command:$args }
	function tgc { tg commit }
}
