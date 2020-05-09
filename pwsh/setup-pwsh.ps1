Write-Output "Setting up Powershell..."

Copy-Item $PSScriptRoot/profile.ps1 $profile.CurrentUserAllHosts

# todo: use exact path to avoid if statement
if ($profile.CurrentUserCurrentHost.EndsWith("Microsoft.PowerShell_profile.ps1")) {
  Copy-Item $PSScriptRoot/Microsoft.PowerShell_profile.ps1 $profile.CurrentUserCurrentHost
}