$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$repoSettingsPath = Join-Path $PSScriptRoot "settings.json"

# Ensure parent directory exists
$parentDir = Split-Path $wtSettingsPath -Parent
if (-not (Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
}

# Backup existing settings if present and not already a symlink
if (Test-Path $wtSettingsPath) {
    $item = Get-Item $wtSettingsPath
    if ($item.LinkType -ne "SymbolicLink") {
        $backupPath = "$wtSettingsPath.backup"
        Copy-Item $wtSettingsPath $backupPath -Force
        Write-Host "Backed up existing settings to $backupPath"
    }
    Remove-Item $wtSettingsPath -Force
}

# Create symlink to repo settings
try {
    New-Item -ItemType SymbolicLink -Path $wtSettingsPath -Target $repoSettingsPath -Force | Out-Null
    Write-Host "Created symlink: Windows Terminal settings -> $repoSettingsPath"
} catch {
    Write-Warning "Failed to create symlink (requires admin or Developer Mode): $_"
    Write-Host "Falling back to copy..."
    Copy-Item $repoSettingsPath $wtSettingsPath -Force
}