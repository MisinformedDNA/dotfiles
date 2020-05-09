#Used for Microsoft's PowerShell console/host
Write-Host "Loading Microsoft.PowerShell_profile.ps1"
Remove-Item alias:gcm -Force
Remove-Item alias:gl -Force
Remove-Item alias:gp -Force
Remove-Item alias:r -Force

function repos
{
    Set-Location C:\Repos
}

# Set-Alias r repos

function home {
	Set-Location $env:userprofile
}

function vs {
	Set-Location "$env:userprofile\Documents\Visual Studio 2017\Projects\"
}

function gcir {
	Get-ChildItem . -Recurse -Filter $args[0]
}

Set-Alias fs gcir	# file search

function fixauthor
{
    git commit --amend --reset-author -C HEAD
}

function gamend
{
    git commit --amend --no-edit
}

function fixauthorall {
	$CORRECT_NAME = git config user.name
	$CORRECT_EMAIL = git config user.email
	
	git filter-branch -f --env-filter `
		"GIT_AUTHOR_NAME='$CORRECT_NAME'; GIT_AUTHOR_EMAIL='$CORRECT_EMAIL';" `
		--tag-name-filter cat -- --branches --tags
}

Set-Alias faa fixauthorall

function finds([string]$value, [string]$path)
{
    findstr /spi /c:$value $path
}

function gcl([string] $url, [string] $directory = '')
{
	git clone $url $directory
	$email = git config --get user.email
	Write-Host "git config --get user.email is set to '$email'"
}

function master
{
	git checkout master
}

function replaceorigin([string] $url)
{
    git remote rename origin upstream
    git remote add origin $url
}

function updatemaster
{
    git fetch upstream
    git checkout master
	if ($lastexitcode -ne 0) {
	"break"
		break
	}
    git merge upstream/master
}

function gb {
	git branch $args
}

function gbd {
echo $args
	git branch -d $args
}

function gitopen
{
    $url = git remote get-url origin
    start $url
}

function go {
	gitopen
}

function gitpushnew
{
    git push --set-upstream origin HEAD
}

function gpn {
	gitpushnew
}

function gpl {
	git pull
}

function gco
{
	git checkout $args
}

function gcob
{
	git checkout -b $args
}

function gd
{
	git diff $args
}

function gds
{
	git diff --staged $args
}

function gs
{
	git status
}

function gap { git add -p $args }

function gcmm([string]$message) {
	if ([string]::IsNullOrEmpty($message)) {
		$message = Read-Host -Prompt "Commit message"
	}

	git commit -m $message
}
 
function gac([string]$message) {
	gau
	gcmm $message
}

function gcp([string]$message) {
	gcmm $message
	gp
}

function gacp([string]$message) {
	gau
	gcmm $message
	gp
}

function pipeline() {
	gau
	gcmm "Updated pipeline"
	gp
}

function tg { TortoiseGitProc.exe /command:$args }

function tgc { tg commit }

function gct { tg commit }

function cdz() {
	z $args
}

function r() {
	z r $args
}

# Chocolatey profile
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }
