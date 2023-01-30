Write-Output "Running setup..."

pwsh -NoProfile -File (Join-Path $PSScriptRoot scripts/setup-pwsh.ps1)

Write-Output "Setup completed."
