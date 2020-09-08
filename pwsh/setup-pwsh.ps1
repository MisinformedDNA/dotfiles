Write-Output "Setting up Powershell..."

Install-Module posh-git -Force
Install-Module ZLocation -Force

$source = Join-Path $PSScriptRoot *
$destDir = Split-Path -Parent $PROFILE
Copy-Item $source $destDir -Recurse -ErrorAction SilentlyContinue
