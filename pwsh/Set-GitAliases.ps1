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

function gacp([string]$message) { gac; gp }

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

function fixauthor { git commit --amend --reset-author -C HEAD }

function gcl([string] $url, [string] $directory = '') {
    git clone $url $directory
    $email = git config --get user.email
    Write-Host "git config --get user.email is set to '$email'"
}

function master {
    git checkout master
}

function replaceorigin([string] $url) {
    git remote rename origin upstream
    git remote add origin $url
}

function updatemaster {
    git fetch upstream
    git checkout master
    if ($lastexitcode -ne 0) {
        "break"
        break
    }
    git merge upstream/master
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
