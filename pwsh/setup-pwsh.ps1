Write-Output "Setting up Powershell..."

$destDir = Split-Path -Parent $PROFILE
$scriptName = $MyInvocation.MyCommand.Name
write-output "Command name: $($MyInvocation.MyCommand.Name)"

Get-ChildItem $PSScriptRoot | `
  Where-Object { $_.NameString -ne $scriptName } | `
  ForEach-Object { Write-Host "  Copying $($_.NameString)"; Copy-Item $_ $destDir }