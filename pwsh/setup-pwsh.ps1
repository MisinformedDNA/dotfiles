Write-Output "Setting up Powershell..."

$source = Join-Path $PSScriptRoot *
$destDir = Split-Path -Parent $PROFILE
Copy-Item $source $destDir -Recurse -ErrorAction SilentlyContinue
