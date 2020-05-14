function Get-GitUser {
    git config user.name
    git config user.email
}
Set-Alias ggu Get-GitUser

function Get-GitStoreUser {
    try {
        $content = Get-Content -Path "$PSScriptRoot\.gitusers" -ErrorAction 'Stop' | ConvertFrom-Json

        return $content
    } catch {
    }
}

function Add-GitStoreUser (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String] $name, 
        
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()] 
    [String] $email,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()] 
    [String] $shortcut
)
{
    try {
        $content = Get-Content -Path "$PSScriptRoot\.gitusers" -ErrorAction 'Stop'
    } catch {
        $content = '[]'
    }

    [PSCustomObject[]]$users = $content | ConvertFrom-Json

    $newUser =@"
    {
        "shortcut": "$shortcut",
        "name": "$name",
        "email": "$email"
    }
"@

    $users += (ConvertFrom-Json $newUser)

    $users |
        ConvertTo-Json |
            Set-Content -Path "$PSScriptRoot\.gitusers"
}

function Set-GitUser ($name) {
    $users = Get-GitStoreUser
    if ($users -eq $null) {
        Write-Host "No git users found. Add a new user with 'Add-GitStoreUser'."
        return
    }

    $options = $users | 
        ForEach-Object { New-Object System.Management.Automation.Host.ChoiceDescription $_.shortcut, "$name ($email)" }

    $title = "Choose credentials for this repo"
    $result = $host.ui.PromptForChoice($title, $null, $options, 0)

    $user = $users[$result]
    git config user.name $user.name
    git config user.email $user.email

    Get-GitUser
}
Set-Alias sgu Set-GitUser
