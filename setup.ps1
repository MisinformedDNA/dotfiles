Write-Output "Running setup..."

$command = Join-Path $PSScriptRoot scripts/setup-pwsh.ps1
pwsh -File $command

Write-Output "Setup completed."
