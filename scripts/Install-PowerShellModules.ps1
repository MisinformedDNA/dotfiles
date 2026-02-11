Write-Output "Installing PowerShell modules..."

$modules = @(
    "posh-git",
    "PSReadLine",
    "ZLocation"
)

Install-Module $modules -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
