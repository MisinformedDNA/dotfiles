Write-Output "Installing Powershell modules..."

$modules = @(
    "posh-git",
    "ZLocation"
)

Install-Module $modules -Scope CurrentUser -Force