Write-Output "Setting up Powershell..."

$source = Join-Path $PSScriptRoot "../pwsh/*"
$destDir = Split-Path -Parent $PROFILE
Copy-Item $source $destDir -Recurse -ErrorAction SilentlyContinue

& "$PSScriptRoot/Install-Modules.ps1"
