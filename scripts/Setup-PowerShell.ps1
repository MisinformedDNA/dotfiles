Write-Output "Setting up PowerShell..."

$source = Join-Path $PSScriptRoot "../pwsh/*"
$destDir = Split-Path -Parent $PROFILE
Copy-Item $source $destDir -Recurse -ErrorAction SilentlyContinue

& "$PSScriptRoot/Install-PowerShellModules.ps1"
