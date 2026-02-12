# Dotfiles

Personal PowerShell environment configuration for Windows, Linux, and GitHub Codespaces.

## Quick Start

### Windows (Boxstarter)

One-click automated setup via Boxstarter:

```
http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/MisinformedDNA/dotfiles/main/boxstarter.ps1
```

This will:
- Install Git, PowerShell Core, and applications via winget
- Configure Windows settings (dark mode, Explorer settings, taskbar)
- Set up PowerShell profile with Oh My Posh and git aliases
- Configure Windows Terminal

### Manual Setup (Windows/Linux/Codespaces)

```powershell
git clone https://github.com/MisinformedDNA/dotfiles.git
cd dotfiles
pwsh -NoProfile -ExecutionPolicy Bypass -File ./Setup.ps1
```

### GitHub Codespaces

The `.devcontainer` configuration automatically sets up the PowerShell environment when you open this repo in Codespaces.

## Prerequisites

- **PowerShell 7+** (PowerShell Core) - Installed automatically on Windows via Boxstarter
- **Git** - Installed automatically on Windows via Boxstarter
- **Windows 11** (for full Windows-specific features) or Linux/macOS for cross-platform profile

## What Gets Installed/Configured

### PowerShell Modules
- **posh-git** - Git status in prompt and tab completion
- **PSReadLine** - Enhanced command-line editing with predictive IntelliSense
- **ZLocation** - Fast directory navigation based on frequency
- **Oh My Posh** - Beautiful prompt theming (paradox theme)

### Git Configuration
- Default branch: `main`
- Auto setup remote on push
- Common git aliases: `cp` (cherry-pick), `unstage`, `last`, `visual`

### PowerShell Aliases & Functions
Git shortcuts: `ga`, `gac`, `gacp`, `gb`, `gc`, `gcmm`, `gco`, `gcob`, `gd`, `gds`, `gl`, `gp`, `gpl`, `gs`, and more

See [pwsh/Set-GitAliases.ps1](pwsh/Set-GitAliases.ps1) for complete list.

### Windows Applications (via winget)
- PowerShell Core
- Oh My Posh
- Git & TortoiseGit
- VS Code
- WinMerge
- PowerToys
- Spotify

See [winget-packages.json](winget-packages.json) for complete list.

### Windows Settings
- Dark mode for system and apps
- File Explorer: show hidden files, file extensions, protected OS files
- Taskbar: hide Task View, News and Interests, search box
- File Explorer opens to "This PC" instead of Quick Access

See [scripts/Initialize-Windows.ps1](scripts/Initialize-Windows.ps1) for all settings.

## Usage

After installation, restart your PowerShell session or run:

```powershell
. $PROFILE
```

### Quick Navigation
- `repos` or `r` - Navigate to repos directory (C:\Repos on Windows, ~/repos on Linux)

### Git Workflow Examples
```powershell
# Stage all modified files, commit, and push
gacp "commit message"

# Stage all, commit only
gac "commit message"

# Create new branch and check it out
gcob feature-branch

# Open repo in browser
gopen

# Prune merged local branches
gprune
```

## Customization

- **Profile override**: Create `.profile.ps1` in your repo root for local customizations
- **Git credentials**: Edit git config manually for work/personal separation
- **Windows Terminal**: Settings symlinked from [apps/WindowsTerminal/settings.json](apps/WindowsTerminal/settings.json)

## File Structure

```
dotfiles/
├── Setup.ps1                 # Main setup script (cross-platform)
├── boxstarter.ps1            # Windows automated installation via Boxstarter
├── winget-packages.json      # Windows applications to install
├── apps/
│   └── WindowsTerminal/      # Windows Terminal configuration
├── pwsh/
│   ├── profile.ps1           # PowerShell profile (loads for all hosts)
│   └── Set-GitAliases.ps1    # Git function aliases
└── scripts/
    ├── Configure-Git.ps1     # Git global configuration
    ├── Initialize-Windows.ps1 # Windows registry settings
    ├── Install-Apps.ps1      # Application installation
    └── Install-PowerShellModules.ps1 # PowerShell module installation
```

## License

MIT - See [LICENSE](LICENSE)
