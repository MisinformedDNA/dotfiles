# Install Boxstarter:
# . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
# $creds = Get-Credential
# Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/MisinformedDNA/dotfiles/boxstarter/boxstarter.ps1 -Credential $creds
# http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/boxstarter/boxstarter.ps1

choco feature enable -n=useRememberedArgumentsForUpgrades
mkdir c:\temp
choco config set cacheLocation c:\temp

Install-WindowsUpdate -acceptEula
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

# Source control
choco upgrade git --params "/NoShellIntegration /NoGitLfs"
choco upgrade tortoisegit

# Editors
choco upgrade visualstudio2019enterprise --params "--add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetCoreTools
--add Microsoft.VisualStudio.Workload.VisualStudioExtension"
choco upgrade notepadplusplus
choco upgrade vscode --params "/NoDesktopIcon /NoQuicklaunchIcon"

# VS Code Extensions
Write-Host "Install VS Code extensions"
code --install-extension ms-dotnettools.csharp
code --install-extension ms-vscode.powershell
code --install-extension eamodio.gitlens
code --install-extension davidanson.vscode-markdownlint

# Terminals
choco upgrade powershell-core
choco upgrade microsoft-windows-terminal

# Switch to PowerShell Core
#refreshenv; pwsh

# Clone dotfiles
Write-Host "Clone dotfiles"
$reposPath = "/repos"
New-Item $reposPath -ItemType Directory
Set-Location $reposPath
git clone https://github.com/MisinformedDNA/dotfiles/

# Copy PowerShell profile files
#$source = Join-Path $PSScriptRoot *
$destDir = Split-Path -Parent $PROFILE
Copy-Item $reposPath/pwsh $destDir -Recurse -ErrorAction SilentlyContinue

Write-Host "Pwsh started"
# Powershell Modules
Install-Module PowerShellGet -Force; Import-Module PowerShellGet
Write-Host "NuGet"
Install-PackageProvider NuGet -Force
Write-Host "AZ"
Install-Module Az -AllowClobber -Scope CurrentUser -Force
Write-Host "ZLocation"
Install-Module ZLocation -Scope CurrentUser -Force; Import-Module ZLocation; Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserAllHosts
Write-Host "posh-git"
Install-Module posh-git -Scope CurrentUser -Force -AllowPrerelease; Add-PoshGitToProfile -AllHosts

# CLIs
choco upgrade azure-cli
choco upgrade nodejs-lts
choco upgrade pulumi

# Tools
choco upgrade azure-cosmosdb-emulator
choco upgrade dotpeek
choco upgrade fiddler
choco upgrade microsoftazurestorageexplorer
choco upgrade postman
choco upgrade sql-server-management-studio
choco upgrade sysinternals
choco upgrade winmerge

# Other
choco upgrade adobereader
choco upgrade microsoft-edge
choco upgrade onenote
choco upgrade powertoys
choco upgrade slack
choco upgrade spotify

# # Remove unwanted apps
# # 3D Builder
# Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage

# # Alarms
# Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage

# # Autodesk
# Get-AppxPackage *Autodesk* | Remove-AppxPackage

# # Bing Weather, News, Sports, and Finance (Money):
# Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage
# Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
# Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage
# Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage

# # BubbleWitch
# Get-AppxPackage *BubbleWitch* | Remove-AppxPackage

# # Candy Crush
# Get-AppxPackage king.com.CandyCrush* | Remove-AppxPackage

# # Comms Phone
# Get-AppxPackage Microsoft.CommsPhone | Remove-AppxPackage

# # Dell
# Get-AppxPackage *Dell* | Remove-AppxPackage

# # Dropbox
# Get-AppxPackage *Dropbox* | Remove-AppxPackage

# # Facebook
# Get-AppxPackage *Facebook* | Remove-AppxPackage

# # Feedback Hub
# Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage

# # Get Started
# Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage

# # Keeper
# Get-AppxPackage *Keeper* | Remove-AppxPackage

# # Mail & Calendar
# Get-AppxPackage microsoft.windowscommunicationsapps | Remove-AppxPackage

# # Maps
# Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage

# # March of Empires
# Get-AppxPackage *MarchofEmpires* | Remove-AppxPackage

# # McAfee Security
# Get-AppxPackage *McAfee* | Remove-AppxPackage

# # Uninstall McAfee Security App
# $mcafee = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "McAfee Security" } | select UninstallString
# if ($mcafee) {
# 	$mcafee = $mcafee.UninstallString -Replace "C:\Program Files\McAfee\MSC\mcuihost.exe",""
# 	Write "Uninstalling McAfee..."
# 	start-process "C:\Program Files\McAfee\MSC\mcuihost.exe" -arg "$mcafee" -Wait
# }

# # Messaging
# Get-AppxPackage Microsoft.Messaging | Remove-AppxPackage

# # Minecraft
# Get-AppxPackage *Minecraft* | Remove-AppxPackage

# # Netflix
# Get-AppxPackage *Netflix* | Remove-AppxPackage

# # Office Hub
# Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage

# # One Connect
# Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage

# # OneNote
# Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage

# # People
# Get-AppxPackage Microsoft.People | Remove-AppxPackage

# # Phone
# Get-AppxPackage Microsoft.WindowsPhone | Remove-AppxPackage

# # Photos
# Get-AppxPackage Microsoft.Windows.Photos | Remove-AppxPackage

# # Plex
# Get-AppxPackage *Plex* | Remove-AppxPackage

# # Skype (Metro version)
# Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage

# # Sound Recorder
# Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage

# # Solitaire
# Get-AppxPackage *Solitaire* | Remove-AppxPackage

# # Sticky Notes
# Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage

# # Sway
# Get-AppxPackage Microsoft.Office.Sway | Remove-AppxPackage

# # Twitter
# Get-AppxPackage *Twitter* | Remove-AppxPackage

# # Xbox
# Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
# Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage

# # Zune Music, Movies & TV
# Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
# Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage

#DISABLE All BLOATWARE EXCEPT STORE
# Get-AppxPackage -AllUsers | where-object {$_.name –notlike "*store*"} | Remove-AppxPackage

#--- List all installed programs --#
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall* | sort -property DisplayName | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |Format-Table -AutoSize

#--- List all store-installed programs --#
Get-AppxPackage | sort -property Name | Select-Object Name, PackageFullName, Version | Format-Table -AutoSize
