#!/bin/bash
# Claude Global Settings Installer for Linux/macOS
# Usage: chmod +x install.sh && ./install.sh

set -e

CLAUDE_DIR="$HOME/.claude"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

echo "╭─────────────────────────────────────────╮"
echo "│   Claude Global Settings Installer      │"
echo "╰─────────────────────────────────────────╯"
echo ""

# Check if source .claude exists
if [ ! -d "$REPO_DIR/.claude" ]; then
    echo "❌ Error: .claude folder not found in repo"
    exit 1
fi

# Backup existing .claude if it exists
if [ -d "$CLAUDE_DIR" ]; then
    BACKUP_DIR="$CLAUDE_DIR.backup.$TIMESTAMP"
    echo "📦 Backing up existing $CLAUDE_DIR to $BACKUP_DIR"
    mv "$CLAUDE_DIR" "$BACKUP_DIR"
    echo "✓ Backup created"
fi

# Copy .claude folder
echo "📁 Copying .claude folder..."
cp -r "$REPO_DIR/.claude" "$CLAUDE_DIR"

# Replace {{HOME}} placeholder with actual home directory
echo "🔧 Configuring paths..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS uses different sed syntax
    sed -i '' "s|{{HOME}}|$HOME|g" "$CLAUDE_DIR/settings.json"
else
    # Linux
    sed -i "s|{{HOME}}|$HOME|g" "$CLAUDE_DIR/settings.json"
fi

# Make scripts executable
chmod +x "$CLAUDE_DIR/statusline.sh" 2>/dev/null || true
chmod +x "$CLAUDE_DIR/hooks/"*.cjs 2>/dev/null || true

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
echo "  3. Try: /plan test"
echo ""

# Show what was installed
echo "Installed components:"
echo "  • Commands: $(find "$CLAUDE_DIR/commands" -name "*.md" | wc -l | tr -d ' ') files"
echo "  • Skills:   $(ls -d "$CLAUDE_DIR/skills"/*/ 2>/dev/null | wc -l | tr -d ' ') folders"
echo "  • Agents:   $(ls "$CLAUDE_DIR/agents/"*.md 2>/dev/null | wc -l | tr -d ' ') files"
echo "  • Hooks:    $(ls "$CLAUDE_DIR/hooks/"*.cjs 2>/dev/null | wc -l | tr -d ' ') files"
