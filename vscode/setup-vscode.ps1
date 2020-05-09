Write-Output "Setting up VS Code..."

if ($PSVersionTable.Platform -eq 'Win32NT') {
  $userDir = "$env:APPDATA\Code\User"
}
else {
  $userDir = "$HOME/.config/Code/User"
}

Copy-Item $PSScriptRoot/settings.json $userDir
