#!/bin/bash
# Claude Global Settings Installer for Linux/macOS
# Usage: chmod +x install.sh && ./install.sh
#
# This script safely installs Claude global settings without destroying
# existing user data (credentials, history, cache, etc.)

set -e

CLAUDE_DIR="$HOME/.claude"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_CLAUDE="$REPO_DIR/.claude"

echo "╭─────────────────────────────────────────╮"
echo "│   Claude Global Settings Installer      │"
echo "╰─────────────────────────────────────────╯"
echo ""

# Check if source .claude exists
if [ ! -d "$REPO_CLAUDE" ]; then
    echo "❌ Error: .claude folder not found in repo"
    exit 1
fi

# Create .claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Copy folders (these are safe to overwrite)
echo "📁 Installing components..."

FOLDERS="agents commands hooks skills scripts workflows output-styles"
for folder in $FOLDERS; do
    if [ -d "$REPO_CLAUDE/$folder" ]; then
        echo "  • Copying $folder/"
        rm -rf "$CLAUDE_DIR/$folder"
        cp -r "$REPO_CLAUDE/$folder" "$CLAUDE_DIR/"
    fi
done

# Copy individual files
echo "📄 Copying config files..."
FILES="statusline.cjs statusline.sh statusline.ps1 .ck.json .ckignore metadata.json .env.example .mcp.json.example .gitignore"
for file in $FILES; do
    if [ -f "$REPO_CLAUDE/$file" ]; then
        cp "$REPO_CLAUDE/$file" "$CLAUDE_DIR/"
    fi
done

# Merge settings.json (preserve user settings, add new hooks/statusLine)
echo "🔧 Merging settings.json..."

if command -v node &> /dev/null; then
    # Convert Git Bash paths to Windows paths for Node.js
    # Git Bash: /c/Users/Alex -> Windows: C:\Users\Alex
    CLAUDE_DIR_WIN="$CLAUDE_DIR"
    REPO_CLAUDE_WIN="$REPO_CLAUDE"

    # Check if we're on Windows (Git Bash/MSYS2)
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        # Convert /c/ style paths to C:/ style for Node.js (forward slashes to avoid escape issues)
        CLAUDE_DIR_WIN=$(cygpath -m "$CLAUDE_DIR" 2>/dev/null || echo "$CLAUDE_DIR" | sed 's|^/\([a-z]\)/|\U\1:/|')
        REPO_CLAUDE_WIN=$(cygpath -m "$REPO_CLAUDE" 2>/dev/null || echo "$REPO_CLAUDE" | sed 's|^/\([a-z]\)/|\U\1:/|')
    fi

    node -e "
const fs = require('fs');
const path = require('path');

const userSettingsPath = '$CLAUDE_DIR_WIN/settings.json';
const repoSettingsPath = '$REPO_CLAUDE_WIN/settings.json';

let userSettings = {};
let repoSettings = {};

// Read existing user settings
if (fs.existsSync(userSettingsPath)) {
    try {
        userSettings = JSON.parse(fs.readFileSync(userSettingsPath, 'utf8'));
    } catch (e) {
        console.log('  Warning: Could not parse existing settings.json, will use defaults');
    }
}

// Read repo settings
if (fs.existsSync(repoSettingsPath)) {
    repoSettings = JSON.parse(fs.readFileSync(repoSettingsPath, 'utf8'));
}

// Merge: repo settings as base, preserve user preferences
const merged = {
    ...repoSettings,
    ...userSettings,
    // Always use repo's hooks and statusLine
    hooks: repoSettings.hooks,
    statusLine: repoSettings.statusLine,
    includeCoAuthoredBy: repoSettings.includeCoAuthoredBy
};

fs.writeFileSync(userSettingsPath, JSON.stringify(merged, null, 2));
console.log('  ✓ Settings merged');
"
else
    echo "  ⚠ Node.js not found, copying settings.json directly"
    cp "$REPO_CLAUDE/settings.json" "$CLAUDE_DIR/settings.json"
fi

# Replace {{HOME}} placeholder with actual home directory
echo "🔧 Configuring paths..."

# On Windows, convert $HOME to Windows format (C:/Users/Alex) for Node.js
HOME_PATH="$HOME"
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    HOME_PATH=$(cygpath -m "$HOME" 2>/dev/null || echo "$HOME" | sed 's|^/\([a-z]\)/|\U\1:/|')
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS uses different sed syntax
    sed -i '' "s|{{HOME}}|$HOME_PATH|g" "$CLAUDE_DIR/settings.json"
else
    # Linux/Windows
    sed -i "s|{{HOME}}|$HOME_PATH|g" "$CLAUDE_DIR/settings.json"
fi

# Make scripts executable
chmod +x "$CLAUDE_DIR/statusline.sh" 2>/dev/null || true
chmod +x "$CLAUDE_DIR/statusline.cjs" 2>/dev/null || true
chmod +x "$CLAUDE_DIR/hooks/"*.cjs 2>/dev/null || true
chmod +x "$CLAUDE_DIR/scripts/"*.sh 2>/dev/null || true

echo ""
echo "╭─────────────────────────────────────────╮"
echo "│  ✓ Installation complete!               │"
echo "╰─────────────────────────────────────────╯"
echo ""
echo "Installed to: $CLAUDE_DIR"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code"
echo "  2. Test: claude"
echo "  3. Try: /agents to see available agents"
echo ""

# Show what was installed
echo "Installed components:"
echo "  • Commands: $(find "$CLAUDE_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "  • Skills:   $(ls -d "$CLAUDE_DIR/skills"/*/ 2>/dev/null | wc -l | tr -d ' ') folders"
echo "  • Agents:   $(ls "$CLAUDE_DIR/agents/"*.md 2>/dev/null | wc -l | tr -d ' ') files"
echo "  • Hooks:    $(ls "$CLAUDE_DIR/hooks/"*.cjs 2>/dev/null | wc -l | tr -d ' ') files"
echo ""
echo "Note: Your existing credentials, history, and cache were preserved."
