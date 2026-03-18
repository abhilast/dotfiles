# Coding Conventions

**Analysis Date:** 2026-03-18

## Naming Patterns

**Files:**
- Shell scripts: `lowercase-with-dashes.sh` (e.g., `health-check.sh`, `ghostty-theme-switcher.sh`)
- Lua files: `lowercase-with-dashes.lua` (e.g., `fzf-lua.lua`, `lspconfig.lua`)
- Zsh configuration: descriptive names with leading dot (e.g., `.zshrc`, `.zsh_aliases`, `.zsh_functions`)
- Structured configs: `name.toml` or `name.json` (e.g., `.stylua.toml`, `lazy-lock.json`)

**Functions:**
- Shell: `lowercase_with_underscores` (e.g., `require_repo()`, `worktree_path()`, `get_python_path()`)
- Zsh: `camelCase` or `lowercase_with_underscores` (e.g., `mkcd()`, `cleanmac()`, `pingtest()`)
- Lua: `camelCase` for local functions, `UPPERCASE` for global constants (e.g., `buffer_previewer_maker`, `POWERLEVEL9K_TODO_FOREGROUND`)

**Variables:**
- Shell: `UPPERCASE_WITH_UNDERSCORES` for environment/global vars (e.g., `RIPGREP_CONFIG_PATH`, `WORKSPACE`, `HOMEBREW_NO_ANALYTICS`)
- Shell: `lowercase_with_underscores` for local variables (e.g., `brew_bin`, `conda_setup`, `file`)
- Lua: `camelCase` for local variables, `vim.*` or `require()` results stored in lowercase (e.g., `local status_ok`, `local mason`)

**Types:**
- Comments prefix sections with standardized emoji+text: `# ===========================` with `# [EMOJI] SECTION NAME` (e.g., `# 🚀 GENERAL NAVIGATION`)
- Comments describe performance optimizations: `# PERFORMANCE: [brief description]` throughout shell and Lua code

## Code Style

**Formatting:**

Lua:
- Tool: `stylua` (configured in `nvim/.config/nvim/.stylua.toml`)
- Column width: 120
- Line endings: Unix
- Indentation: 2 spaces
- Quote style: AutoPreferDouble

Shell/Bash:
- Tool: `shfmt` (via conform.nvim)
- Indentation: 2 spaces (in Lua configs)
- No hard tabs

**Linting:**

Lua:
- NvChad built-in linting via LSP (lua_ls)
- Mason handles installation of language servers
- Error handling uses `pcall()` for safe require statements: `local status_ok, module = pcall(require, "module")`

Shell:
- Strict mode in production scripts: `set -euo pipefail` (e.g., in `scripts/wt`)
- Simple bash scripts may use `set -e` (e.g., `install.sh`)

## Import Organization

**Order:**

Lua (standard pattern):
1. Local requires/imports
2. Local helper functions
3. Configuration tables
4. Setup calls
5. Return statement

Example from `lua/configs/lspconfig.lua`:
```lua
require("nvchad.configs.lspconfig").defaults()

local servers = { ... }

for _, lsp in ipairs(servers) do
  pcall(function() vim.lsp.enable(lsp) end)
end

local function get_python_path(workspace) ... end

vim.lsp.config("pyright", { ... })
```

Shell:
1. Shebang and set options
2. Environment variables
3. Helper functions (die, usage, etc.)
4. Main command implementations
5. Argument parsing and dispatch

Example from `scripts/wt`:
```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${WT_ROOT:-$HOME/repos/skates}"

die() { printf 'wt: %s\n' "$*" >&2; exit 1; }
usage() { cat <<USAGE ... }

require_repo() { ... }
new_cmd() { ... }

# Dispatch
main() { case "$cmd" in ... }
```

**Path Aliases:**
- Lua: No explicit path aliases; files organized in `lua/configs/` and `lua/plugins/`
- Shell: Environment variables used as anchors (`$HOME`, `$WORKSPACE`, `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`)
- Zsh: Exported paths in `.zshenv` for portability (e.g., `WORKSPACE="$HOME/Developer/repos"`)

## Error Handling

**Patterns:**

Shell - Early return/exit:
```bash
[[ $# -eq 0 ]] && { echo "Usage: ..."; return 1; }
[[ ! -f "$1" ]] && { echo "Error: File not found"; return 1; }
```

Shell - Conditional execution:
```bash
mkdir -p "$1" && cd "$1" || {
  echo "Error: Failed to create directory"
  return 1
}
```

Shell - Safe command checks:
```bash
if command -v rg >/dev/null 2>&1; then
  # Use ripgrep
else
  # Fallback
fi
```

Shell - Explicit error messages:
```bash
die() {
  printf 'script: %s\n' "$*" >&2
  exit 1
}
```

Lua - Safe require with pcall:
```lua
local status_ok, module = pcall(require, "module")
if not status_ok then
  vim.notify("Failed to load module", vim.log.levels.ERROR)
  return
end
```

Lua - Error checking with callback:
```lua
vim.loop.fs_stat(filepath, function(_, stat)
  if not stat then return end
  if stat.size > 100000 then return end
  -- process file
end)
```

## Logging

**Framework:** `echo` and `printf` in shell; `vim.notify()` in Lua

**Patterns:**

Shell logging with emoji prefixes:
```bash
echo "🚀 Starting operation..."
echo "✅ Success"
echo "❌ Error: description"
echo "⚠️ Warning"
echo "📦 Installing packages..."
echo "🔍 Checking..."
echo "💾 Backing up..."
```

Lua logging:
```lua
vim.notify("Message text", vim.log.levels.INFO)
vim.notify("Error text", vim.log.levels.ERROR)
```

Performance/optimization comments:
```bash
# PERFORMANCE: Description of what's being optimized
```

Structured section headers:
```bash
# ===========================
# 🚀 SECTION NAME
# ===========================
```

## Comments

**When to Comment:**
- Describe *why*, not *what*: "PERFORMANCE: Cache GOPATH to avoid repeated calls" not "get GOPATH"
- Mark non-obvious decisions: `# Fixed: Added quotes to grep pattern` (from `health-check.sh`)
- Explain performance optimizations: "PERFORMANCE: Build PATH efficiently with minimal external calls"
- Clarify workarounds: comments explain MacOS/Darwin specifics or version-specific behavior

**JSDoc/TSDoc:**
- Lua uses inline type annotations with `---@type` comments (e.g., `---@type ChadrcConfig`)
- Vim script docstrings use `"` comments with structured format
- No strict docstring convention; inline comments preferred for clarity

## Function Design

**Size:**
- Shell functions: typically 5-30 lines; larger ones split into helpers
- Lua functions: 10-50 lines; complex logic extracted to modules
- Zsh aliases/functions: short aliases (<5 chars) for common operations; longer named functions for complex behavior

**Parameters:**
- Shell: Required parameters checked with early returns: `[[ -n "$repo" ]] || die "repo required"`
- Shell: Optional parameters with defaults: `local levels=${1:-1}`
- Lua: Tables for configuration (e.g., `opts = { ... }`)
- Lua: Function factories that return configured functions

**Return Values:**
- Shell: `0` for success, `1` for error (implicit or explicit `return 1`)
- Shell: Functions may print to stdout (intended for use in command substitution)
- Lua: Return configuration tables or `nil` on setup functions
- Lua: Safe returns with `pcall()` wrapping: `local status_ok, result = pcall(fn)`

## Module Design

**Exports:**

Lua pattern (consistent across configs):
```lua
local options = {
  setting1 = value1,
  setting2 = value2,
}
return options
```

Shell: Functions are defined at top-level and called by main dispatcher

**Barrel Files:**
- Not used in Lua; each config file is imported explicitly
- Shell: `.zsh_aliases`, `.zsh_functions`, `.zsh_functions_lazy` sourced in `.zshrc`
- Zsh: Aliases/functions organized by category with section headers

## Performance-First Design

Throughout codebase, performance optimizations are explicit:
- Lazy loading for Node/npm (`zsh_functions_lazy`)
- Lazy loading for conda, kubectl, nvm (in `.zshrc`)
- Command availability checks before use: `if command -v tool >/dev/null 2>&1; then`
- Fast-fail patterns: `[[ -o interactive ]] || return` early in `.zshrc`
- Caching and memoization: `zstyle ':zinit:*' use-cache yes`
- Depth limits on filesystem traversal: `find . -maxdepth 3` instead of unbounded

---

*Convention analysis: 2026-03-18*
