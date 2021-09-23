Write-Output "Installing Powershell modules..."


$modules = @(
    "oh-my-posh",
    "posh-git", 
    "ZLocation"
)

$modules | ForEach-Object { Install-Module $modules -Scope CurrentUser }