#Used for all Powershell hosts
Write-Host "Loading profile.ps1"

# Load essential functions first
. (Join-Path $PSScriptRoot "Set-GitAliases.ps1")

# Load oh-my-posh paths into PATH on Linux/Codespaces to ensure it's available for the prompt
if (-not $IsWindows) {
    $addPaths = @('/usr/local/bin','/usr/local/sbin')
    foreach ($p in $addPaths) {
        $split = $env:PATH -split ':'
        if (-not ($split -contains $p)) {
            $env:PATH = "$env:PATH:$p"
        }
    }
}

# Configure oh-my-posh
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
    $GitPromptSettings.EnablePromptStatus = $false  # Disable posh-git prompt entirely (using oh-my-posh instead)
}

# Load ZLocation for fast directory navigation
Import-Module ZLocation -ErrorAction SilentlyContinue

# Configure PSReadLine for enhanced command-line editing
if (Get-Module PSReadLine -ErrorAction SilentlyContinue) {
    # Enable predictive IntelliSense
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue
    Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue
    
    # History search with up/down arrows
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    
    # Bash-style tab completion
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    
    # Useful editing shortcuts
    Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
    Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardDeleteWord
    
    # Syntax highlighting colors
    Set-PSReadLineOption -Colors @{
        Command   = 'Green'
        Parameter = 'Gray'
        String    = 'Yellow'
        Operator  = 'Magenta'
        Variable  = 'Cyan'
        Comment   = 'DarkGray'
    }
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
