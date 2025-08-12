#Used for all Powershell hosts
Write-Host "Loading profile.ps1"

# Load essential functions first
. (Join-Path $PSScriptRoot "Set-GitAliases.ps1")

# Load oh-my-posh (usually the fastest prompt option)
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
}

# Load posh-git for git aliases and tab completion only (disable its prompt)
Import-Module posh-git -ErrorAction SilentlyContinue
if (Get-Module posh-git -ErrorAction SilentlyContinue) {
    $GitPromptSettings.EnablePromptStatus = $false  # Disable posh-git prompt entirely
}

function c {
	code
}

function repos {
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        Set-Location C:\Repos
    } else {
        Set-Location ~/repos
    }
}

Set-Alias r repos -Force

function cleanbin {
	Get-ChildItem .\ -Include bin,obj -Recurse | ForEach-Object { Remove-Item $_.FullName -Force -Recurse }
}
