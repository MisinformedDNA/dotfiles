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
$symlink = New-Item -ItemType SymbolicLink -Path $wtSettingsPath -Target $repoSettingsPath -Force -ErrorAction SilentlyContinue

if ($symlink) {
    Write-Host "Created symlink: Windows Terminal settings -> $repoSettingsPath" -ForegroundColor Green
} else {
    Write-Warning "Failed to create symlink. This requires either:"
    Write-Warning "  1. Running as Administrator, OR"
    Write-Warning "  2. Enabling Developer Mode (Settings > Privacy & Security > For developers > Developer Mode)"
    Write-Host "`nFalling back to copy..." -ForegroundColor Yellow
    Copy-Item $repoSettingsPath $wtSettingsPath -Force
    Write-Host "Settings copied. Note: Changes to the repo won't auto-sync. Re-run this script to update." -ForegroundColor Cyan
}