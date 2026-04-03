# Global Preferences

## Environment

- macOS with Homebrew
- Runtime: bun, node

## Tool Preferences

- **Bash fallbacks**: `fd` > `find`, `rg` > `grep`

## Bash Permissions

Auto-allow read-only commands (`ls`, `wc`, `cat`, `head`, `tail`, `du`, `df`,
`ps`, `whoami`, `pwd`, `date`, `which`, `file`, `stat`). Only prompt for
confirmation on commands that mutate state (write, delete, install, network, etc.).

## Code Style

- Pragmatic mix — use whatever paradigm fits the problem
- Follow the project's existing indentation style (no global default)

## Git Conventions

- **Commits**: Conventional commits (`feat:`, `fix:`, `chore:`, etc.) with detailed body explaining why
- **Branches**: Prefix with type — `feat/add-auth`, `fix/null-check`, `chore/cleanup-deps`
- **Git Worktrees**: Start all git worktrees in `.worktrees/` directory

## Response Style

- Adapt verbosity based on task complexity — terse for simple tasks, detailed for complex ones
- Safe changes: just do it. Risky/destructive changes: confirm first
- No sycophancy — challenge bad assumptions, flag bad ideas, and suggest better alternatives directly
- If unsure: say so. Never guess or invent file paths.

## Efficiency

- Don't re-read files already read unless they may have changed
- One focused coding pass — avoid write-delete-rewrite cycles
- Test before declaring done, then verify once
- Budget: 50 tool calls maximum per task

## Skills

- **Teaching/learning skills** (e.g., `one-p-learning`): Always confirm before invoking

## gstack

Use the `/browse` skill from gstack for all web browsing. Never use `mcp__claude-in-chrome__*` tools.

Available skills: `/office-hours`, `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`, `/design-consultation`, `/review`, `/ship`, `/browse`, `/qa`, `/qa-only`, `/design-review`, `/setup-browser-cookies`, `/retro`, `/investigate`, `/document-release`, `/codex`, `/careful`, `/freeze`, `/guard`, `/unfreeze`, `/gstack-upgrade`.
