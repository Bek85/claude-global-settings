# Claude Global Settings

Portable configuration for Claude Code CLI with ClaudeKit framework.

## Quick Install

### Windows (PowerShell)

```powershell
git clone https://github.com/Bek85/claude-global-settings.git
cd claude-global-settings
.\install.ps1
```

### Linux/macOS

```bash
git clone https://github.com/Bek85/claude-global-settings.git
cd claude-global-settings
chmod +x install.sh && ./install.sh
```

## What's Included

| Component | Count | Description |
|-----------|-------|-------------|
| **Commands** | 71+ | Slash commands like `/plan`, `/cook`, `/fix`, `/test` |
| **Agents** | 17 | Specialized AI agents (planner, reviewer, debugger, etc.) |
| **Skills** | 50+ | Domain knowledge modules with references |
| **Hooks** | 7 | Security, optimization, and notification hooks |
| **Workflows** | 4 | Development guidelines and protocols |

## Available Commands

### Core Development
- `/plan <task>` - Create implementation plans
- `/cook <task>` - Implement with research
- `/code` - Execute implementation
- `/fix <issue>` - Fix bugs and issues
- `/test` - Run tests
- `/debug` - Debug issues

### Git & Project
- `/git/cm` - Commit with conventional message
- `/git/pr` - Create pull request
- `/watzup` - Project status check

### Documentation
- `/docs/init` - Initialize docs
- `/docs/update` - Update documentation

### Other
- `/brainstorm` - Solution ideation
- `/scout` - Codebase exploration
- `/kanban` - Task board

## After Install

1. **Restart Claude Code** (or open new terminal)
2. Navigate to any project: `cd your-project`
3. Start Claude: `claude`
4. Test: type `/plan test feature`

## Updating

To get the latest settings:

```bash
cd claude-global-settings
git pull
./install.sh  # or .\install.ps1 on Windows
```

## Customization

### Add Your Own Instructions

Edit `.claude/CLAUDE.md` to add project-wide instructions:

```markdown
# My Global Instructions

- Use TypeScript for all new files
- Follow our coding standards at [link]
- Always add tests for new features
```

### Modify Commands

Commands are in `.claude/commands/`. Each `.md` file is a slash command.

### Add Skills

Skills are in `.claude/skills/`. Each folder contains:
- `SKILL.md` - Entry point
- `references/` - Domain knowledge
- `scripts/` - Executable tools

## Excluded Files

These are **not synced** (machine-specific):
- `.credentials.json` - API tokens
- `history.jsonl` - Command history
- `projects/` - Workspace state
- `session-env/`, `todos/` - Session state
- `telemetry/`, `debug/` - Analytics

## Requirements

- [Claude Code CLI](https://claude.ai/code) v2.0+
- Git
- Node.js 18+

## License

MIT - Based on [ClaudeKit Engineer](https://github.com/claudekit/claudekit-engineer)
