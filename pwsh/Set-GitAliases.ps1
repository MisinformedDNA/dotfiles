Write-Host "  Setting up Git aliases..."

Remove-Alias gcm -Force -ErrorAction SilentlyContinue
Remove-Alias gl -Force -ErrorAction SilentlyContinue
Remove-Alias gp -Force -ErrorAction SilentlyContinue

$nothingToCommit = "nothing to commit"

function anythingStaged {
    $numberStaged = (git diff --cached --numstat | Measure-Object -Line).Lines
    return $numberStaged -gt 0
}

function g { git @args }

function ga { git add @args }

function gac([string]$message) { gau; gcmm $message }

function gacp([string]$message) { gac; gp }

function gap { git add -p @args }

function gau { git add -u @args }

function gb { git branch $args }

function gbd { git branch -d $args }

function gcm {
    if (anythingStaged) {
        git commit @args
    }
    else {
        Write-Host $nothingToCommit
        exit
    }
}

function gcma { git commit --amend --no-edit }

function gcmm([string]$message) {
    if (-not (anythingStaged)) {
        Write-Host $nothingToCommit
        exit
    }

    if ([string]::IsNullOrEmpty($message)) {
        $message = Read-Host -Prompt "Commit message"
    }

    gcm -m $message
}

function gco { git checkout @args }

function gcob { git checkout -b @args }

function gcp([string]$message) { gcmm $message; gp }

function gd { git diff @args }

function gds { git diff --staged @args }

function gl { git log @args }

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
