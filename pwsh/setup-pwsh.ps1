Write-Output "Setting up Powershell..."

Install-Module posh-git
Install-Module ZLocation  

$source = Join-Path $PSScriptRoot *
$destDir = Split-Path -Parent $PROFILE
Copy-Item $source $destDir -Recurse -ErrorAction SilentlyContinue
