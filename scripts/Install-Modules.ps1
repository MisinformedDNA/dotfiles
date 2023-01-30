Write-Output "Installing Powershell modules..."

$modules = @(
    "posh-git",
    "PSReadLine", 
    "ZLocation"
)

Install-Module $modules -Scope CurrentUser -Force