Write-Output "Setting up Powershell..."

Install-Module posh-git -Force
Install-Module ZLocation -Force

$source = Join-Path $PSScriptRoot "../pwsh/*"
$destDir = Split-Path -Parent $PROFILE
Write-Output "Copying files from $source to $destDir"
Copy-Item $source $destDir -Recurse
