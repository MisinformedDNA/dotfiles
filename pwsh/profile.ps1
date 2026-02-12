#Used for all Powershell hosts
Write-Host "Loading profile.ps1"

# Load essential functions first
. (Join-Path $PSScriptRoot "Set-GitAliases.ps1")

# Load oh-my-posh (usually the fastest prompt option)
if (-not $IsWindows) {
    $addPaths = @('/usr/local/bin','/usr/local/sbin')
    foreach ($p in $addPaths) {
        $split = $env:PATH -split ':'
        if (-not ($split -contains $p)) {
            $env:PATH = "$env:PATH:$p"
        }
    }
}

# Load oh-my-posh (usually the fastest prompt option)
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    if ($env:POSH_THEMES_PATH) {
        $themePath = Join-Path $env:POSH_THEMES_PATH 'paradox.omp.json'
    } else {
        $themePath = 'paradox'
    }
    oh-my-posh init pwsh --config $themePath | Invoke-Expression
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

# Windows-only TortoiseGit integration
if ($IsWindows -or $env:OS -eq "Windows_NT") {
	function tg { TortoiseGitProc.exe /command:$args }
	function tgc { tg commit }
}
