# Claude Global Settings Installer for Windows
# Usage: .\install.ps1

$ErrorActionPreference = "Stop"

$ClaudeDir = "$env:USERPROFILE\.claude"
$RepoDir = $PSScriptRoot
$Timestamp = Get-Date -Format "yyyyMMddHHmmss"

Write-Host ""
Write-Host "+-----------------------------------------+" -ForegroundColor Cyan
Write-Host "|   Claude Global Settings Installer      |" -ForegroundColor Cyan
Write-Host "+-----------------------------------------+" -ForegroundColor Cyan
Write-Host ""

# Check if source .claude exists
if (-not (Test-Path "$RepoDir\.claude")) {
    Write-Host "X Error: .claude folder not found in repo" -ForegroundColor Red
    exit 1
}

# Backup existing .claude if it exists
if (Test-Path $ClaudeDir) {
    $BackupDir = "$ClaudeDir.backup.$Timestamp"
    Write-Host "[*] Backing up existing $ClaudeDir to $BackupDir" -ForegroundColor Yellow
    Move-Item $ClaudeDir $BackupDir
    Write-Host "[+] Backup created" -ForegroundColor Green
}

# Copy .claude folder
Write-Host "[*] Copying .claude folder..." -ForegroundColor Yellow
Copy-Item -Recurse "$RepoDir\.claude" $ClaudeDir

# Replace {{HOME}} placeholder with actual home directory (using forward slashes)
Write-Host "[*] Configuring paths..." -ForegroundColor Yellow
$SettingsPath = "$ClaudeDir\settings.json"
$Settings = Get-Content $SettingsPath -Raw
$HomePath = $env:USERPROFILE -replace '\\', '/'
$Settings = $Settings -replace '\{\{HOME\}\}', $HomePath
Set-Content $SettingsPath $Settings -NoNewline

Write-Host ""
Write-Host "+-----------------------------------------+" -ForegroundColor Green
Write-Host "|  [+] Installation complete!             |" -ForegroundColor Green
Write-Host "+-----------------------------------------+" -ForegroundColor Green
Write-Host ""
Write-Host "Installed to: $ClaudeDir"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Restart Claude Code"
Write-Host "  2. Test: claude"
Write-Host "  3. Try: /plan test"
Write-Host ""

# Show what was installed
$CommandCount = (Get-ChildItem "$ClaudeDir\commands" -Filter "*.md" -Recurse).Count
$SkillCount = (Get-ChildItem "$ClaudeDir\skills" -Directory).Count
$AgentCount = (Get-ChildItem "$ClaudeDir\agents" -Filter "*.md").Count
$HookCount = (Get-ChildItem "$ClaudeDir\hooks" -Filter "*.cjs").Count

Write-Host "Installed components:"
Write-Host "  - Commands: $CommandCount files"
Write-Host "  - Skills:   $SkillCount folders"
Write-Host "  - Agents:   $AgentCount files"
Write-Host "  - Hooks:    $HookCount files"
Write-Host ""
