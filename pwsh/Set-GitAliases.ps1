Write-Host "  Setting up Git aliases..."

Remove-Alias gc -Force -ErrorAction SilentlyContinue
Remove-Alias gcm -Force -ErrorAction SilentlyContinue
Remove-Alias gl -Force -ErrorAction SilentlyContinue
Remove-Alias gp -Force -ErrorAction SilentlyContinue

$nothingToCommit = "nothing to commit"

function anythingStaged {
    $numberStaged = (git diff --cached --numstat | Measure-Object -Line).Lines
    return $numberStaged -gt 0
}

Set-Alias -Name g -Value git

function ga { git add @args }

function gac([string]$message) { gau; gcmm $message }

function gacp([string]$message) { gac $message; gp }

function gap { git add -p @args }

function gau { git add -u @args }

function gb { git branch $args }
$scriptBlock = {
    param($wordToComplete, $commandAst, $cursorPosition)

    Expand-GitCommand "git branch $wordToComplete"
}
Register-ArgumentCompleter -Native -CommandName gb -ScriptBlock $scriptBlock

function gbd { git branch -d $args }

function gcma { git commit --amend --no-edit }

function gc { git commit @args }

function gcmm([string]$message) {
    if (-not (anythingStaged)) {
        Write-Host $nothingToCommit
        return
    }

    if ([string]::IsNullOrEmpty($message)) {
        $message = Read-Host -Prompt "Commit message"
    }

    git commit -m $message
}

function gco { git checkout @args }
$scriptBlock = {
    param($wordToComplete, $commandAst, $cursorPosition)

    Expand-GitCommand "git checkout $wordToComplete"
}
Register-ArgumentCompleter -Native -CommandName gco -ScriptBlock $scriptBlock

function gcob { git checkout -b @args }
$scriptBlock = {
    param($wordToComplete, $commandAst, $cursorPosition)

    Expand-GitCommand "git checkout -b $wordToComplete"
}
Register-ArgumentCompleter -Native -CommandName gcob -ScriptBlock $scriptBlock

function gcp([string]$message) { gcmm $message; gp }

function gd { git diff @args }

function gds { git diff --staged @args }

function gl { git log @args }
$scriptBlock = {
    param($wordToComplete, $commandAst, $cursorPosition)

    Expand-GitCommand "git log $wordToComplete"
}
Register-ArgumentCompleter -Native -CommandName gl -ScriptBlock $scriptBlock

function gopen { $url = git remote get-url origin; Start-Process $url }

function gp { git push @args }

function gpl { git pull @args }

function gpn { git push --set-upstream origin HEAD }

function gs { git status @args }

function gwt {
    [CmdletBinding()]
    param(
        # Git-style: -b new-branch
        [Parameter(Position=0)]
        [switch]$b,

        # Branch name (tab-completes)
        [Parameter(Mandatory=$true, Position=1)]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete)

            git for-each-ref --format='%(refname:short)' refs/heads |
                Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string]$BranchName,

        # Optional worktree name (tab-completes)
        [Parameter(Position=2)]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete)

            git worktree list --porcelain |
                Select-String '^worktree ' |
                ForEach-Object { Split-Path ($_.ToString().Substring(9)) -Leaf } |
                Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string]$WorktreeName
    )

    # Find the actual git root
    $gitRoot = git rev-parse --show-toplevel 2>$null
    if (-not $gitRoot) {
        Write-Error "Not inside a Git repository."
        return
    }

    $gitRoot = (Resolve-Path $gitRoot).Path
    $repoName = Split-Path $gitRoot -Leaf
    $parentDir = Split-Path $gitRoot -Parent

    # Default worktree name if not provided
    if (-not $WorktreeName) {
        $WorktreeName = "$repoName-$BranchName"
    }

    $newWorktreePath = Join-Path $parentDir $WorktreeName

    # Build git worktree add command safely
    $gitArgs = @("worktree", "add", $newWorktreePath)

    if ($b) {
        # Git-correct: path first, then -b <branch>
        $gitArgs += "-b"
        $gitArgs += $BranchName
    }
    else {
        # Existing branch
        $gitArgs += $BranchName
    }

    Write-Host "Creating worktree at: $newWorktreePath"
    git @gitArgs
}


function fixauthor { git commit --amend --reset-author -C HEAD }

function gcl([string] $url, [string] $directory = '') {
    git clone $url $directory
    $email = git config --get user.email
    Write-Host "git config --get user.email is set to '$email'"
}

function main {
    git checkout main
}

function replaceorigin([string] $url) {
    git remote rename origin upstream
    git remote add origin $url
}

function updatemain {
    git fetch upstream
    git checkout main
    if ($lastexitcode -ne 0) {
        "break"
        break
    }
    git merge upstream/main
}

function pipeline() {
    gau
    gcmm "Updated pipeline"
    gp
}


function fixauthorall {
    $CORRECT_NAME = git config user.name
    $CORRECT_EMAIL = git config user.email
	
    git filter-branch -f --env-filter `
        "GIT_AUTHOR_NAME='$CORRECT_NAME'; GIT_AUTHOR_EMAIL='$CORRECT_EMAIL';" `
        --tag-name-filter cat -- --branches --tags
}

Set-Alias faa fixauthorall

function gprune { 
    git branch --merged | 
        ForEach-Object{ $_.Substring(2) } | 
        Where-Object{ $_ -ne "master" } | 
        Where-Object{ $_ -ne "main" } | 
        ForEach-Object{ git branch -d $_ }
}

function Remove-GitRemoteGoneBranches {
    git fetch --prune
    git branch -vv | Select-String -Pattern ": gone]" | ForEach-Object { $_.toString().Trim().Split(" ")[0] } | ForEach-Object { git branch -D $_ }
}
