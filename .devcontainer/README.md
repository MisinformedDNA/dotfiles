# Codespaces Setup

This devcontainer configuration sets up a PowerShell development environment in GitHub Codespaces.

## What gets installed

- PowerShell modules:
  - `posh-git` - Git integration for PowerShell
  - `PSReadLine` - Command-line editing
  - `ZLocation` - Directory navigation
- Oh My Posh - Prompt theming
- GitStore module - Custom git user management
- PowerShell profile from `pwsh/profile.ps1`

## Git configuration

- Default branch: `main`
- Auto setup remote on push
- Cherry-pick alias: `git cp`

## Testing locally

You can test the Codespaces setup script without actually using Codespaces:

```bash
# On Linux/macOS/WSL with PowerShell installed
pwsh -NoProfile -ExecutionPolicy Bypass -File ./scripts/Setup-Codespaces.ps1
```

## Opening in Codespaces

1. Push this repo to GitHub
2. Click the green "Code" button
3. Select "Create codespace on main"
4. Wait for setup to complete (runs `post-install.sh` automatically)

The PowerShell environment will be ready to use once the container builds.
