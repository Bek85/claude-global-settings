# Claude Global Settings Installer for Windows PowerShell
# Usage: .\install.ps1
#
# This script safely installs Claude global settings without destroying
# existing user data (credentials, history, cache, etc.)

$ErrorActionPreference = "Stop"

$ClaudeDir = "$env:USERPROFILE\.claude"
$RepoDir = $PSScriptRoot
$RepoClaude = "$RepoDir\.claude"

Write-Host ""
Write-Host "╭─────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│   Claude Global Settings Installer      │" -ForegroundColor Cyan
Write-Host "╰─────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""

# Check if source .claude exists
if (-not (Test-Path $RepoClaude)) {
    Write-Host "❌ Error: .claude folder not found in repo" -ForegroundColor Red
    exit 1
}

# Create .claude directory if it doesn't exist
if (-not (Test-Path $ClaudeDir)) {
    New-Item -ItemType Directory -Path $ClaudeDir | Out-Null
}

# Copy folders (these are safe to overwrite)
Write-Host "📁 Installing components..." -ForegroundColor Yellow

$Folders = @("agents", "commands", "hooks", "skills", "scripts", "workflows", "output-styles")
foreach ($folder in $Folders) {
    $srcPath = "$RepoClaude\$folder"
    $dstPath = "$ClaudeDir\$folder"
    if (Test-Path $srcPath) {
        Write-Host "  • Copying $folder/" -ForegroundColor Gray
        if (Test-Path $dstPath) {
            Remove-Item $dstPath -Recurse -Force
        }
        Copy-Item -Recurse $srcPath $dstPath
    }
}

# Copy individual files
Write-Host "📄 Copying config files..." -ForegroundColor Yellow
$Files = @("statusline.cjs", "statusline.sh", "statusline.ps1", ".ck.json", ".ckignore", "metadata.json", ".env.example", ".mcp.json.example", ".gitignore")
foreach ($file in $Files) {
    $srcPath = "$RepoClaude\$file"
    if (Test-Path $srcPath) {
        Copy-Item $srcPath "$ClaudeDir\$file"
    }
}

# Merge settings.json (preserve user settings, add new hooks/statusLine)
Write-Host "🔧 Merging settings.json..." -ForegroundColor Yellow

$userSettingsPath = "$ClaudeDir\settings.json"
$repoSettingsPath = "$RepoClaude\settings.json"

$userSettings = @{}
$repoSettings = @{}

# Read existing user settings
if (Test-Path $userSettingsPath) {
    try {
        $userSettings = Get-Content $userSettingsPath -Raw | ConvertFrom-Json -AsHashtable
    } catch {
        Write-Host "  ⚠ Warning: Could not parse existing settings.json, will use defaults" -ForegroundColor Yellow
    }
}

# Read repo settings
if (Test-Path $repoSettingsPath) {
    $repoSettings = Get-Content $repoSettingsPath -Raw | ConvertFrom-Json -AsHashtable
}

# Merge: repo settings as base, preserve user preferences
$merged = $repoSettings.Clone()
foreach ($key in $userSettings.Keys) {
    if ($key -ne "hooks" -and $key -ne "statusLine" -and $key -ne "includeCoAuthoredBy") {
        $merged[$key] = $userSettings[$key]
    }
}

# Always use repo's hooks and statusLine
$merged["hooks"] = $repoSettings["hooks"]
$merged["statusLine"] = $repoSettings["statusLine"]
$merged["includeCoAuthoredBy"] = $repoSettings["includeCoAuthoredBy"]

$merged | ConvertTo-Json -Depth 10 | Set-Content $userSettingsPath -NoNewline
Write-Host "  ✓ Settings merged" -ForegroundColor Green

# Replace {{HOME}} placeholder with actual home directory (using forward slashes for Node.js)
Write-Host "🔧 Configuring paths..." -ForegroundColor Yellow
$Settings = Get-Content $userSettingsPath -Raw
$HomePath = $env:USERPROFILE -replace '\\', '/'
$Settings = $Settings -replace '\{\{HOME\}\}', $HomePath
Set-Content $userSettingsPath $Settings -NoNewline

Write-Host ""
Write-Host "╭─────────────────────────────────────────╮" -ForegroundColor Green
Write-Host "│  ✓ Installation complete!               │" -ForegroundColor Green
Write-Host "╰─────────────────────────────────────────╯" -ForegroundColor Green
Write-Host ""
Write-Host "Installed to: $ClaudeDir"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Restart Claude Code"
Write-Host "  2. Test: claude"
Write-Host "  3. Try: /agents to see available agents"
Write-Host ""

# Show what was installed
try {
    $CommandCount = (Get-ChildItem "$ClaudeDir\commands" -Filter "*.md" -Recurse -ErrorAction SilentlyContinue).Count
    $SkillCount = (Get-ChildItem "$ClaudeDir\skills" -Directory -ErrorAction SilentlyContinue).Count
    $AgentCount = (Get-ChildItem "$ClaudeDir\agents" -Filter "*.md" -ErrorAction SilentlyContinue).Count
    $HookCount = (Get-ChildItem "$ClaudeDir\hooks" -Filter "*.cjs" -ErrorAction SilentlyContinue).Count

    Write-Host "Installed components:"
    Write-Host "  • Commands: $CommandCount files"
    Write-Host "  • Skills:   $SkillCount folders"
    Write-Host "  • Agents:   $AgentCount files"
    Write-Host "  • Hooks:    $HookCount files"
    Write-Host ""
    Write-Host "Note: Your existing credentials, history, and cache were preserved." -ForegroundColor Gray
} catch {
    # Silently continue if counting fails
}
