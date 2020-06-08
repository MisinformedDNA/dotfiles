$apps = @(
  "git",
  "powershell-core",
  "git-credential-manager",
  "tortoisegit",
  "azure-storage-explorer",
  "visual-studio-code",
  "visual-studio-2019-enterprise",
  "notepad-plus-plus",
  "spotify"
)
  
$apps | ForEach-Object { appget install $_ }
