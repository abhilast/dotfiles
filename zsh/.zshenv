# ===========================
# PERFORMANCE: Environment Variables (.zshenv)
# This file is sourced for ALL zsh invocations (login, non-login, scripts)
# Keep only essential environment variables here for optimal performance
# ===========================

# PERFORMANCE: Workspace configuration
export WORKSPACE="$HOME/Developer/repos"

# PERFORMANCE: Homebrew configuration
export HOMEBREW_AUTO_UPDATE_SECS=86400
# PERFORMANCE: Disable Homebrew analytics for faster operations
export HOMEBREW_NO_ANALYTICS=1
# PERFORMANCE: Use Homebrew's faster installation method
export HOMEBREW_NO_AUTO_UPDATE=1

# PERFORMANCE: Disable Oh My Zsh auto-update prompts for faster startup
export DISABLE_UPDATE_PROMPT=true
export DISABLE_AUTO_UPDATE=true

# PERFORMANCE: Default editors (essential for many tools)
export EDITOR=nvim
export VISUAL=nvim

# PERFORMANCE: Locale settings (required by many tools)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# PERFORMANCE: Essential tool configurations
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"

# PERFORMANCE: Configure pager for better git diff display with delta
export LESS="-R"

# PERFORMANCE: Prevent PATH duplicates (critical for performance)
typeset -U PATH

# ===========================
# PERFORMANCE: Optimized PATH Construction
# Build PATH efficiently with minimal external calls
# ===========================

# PERFORMANCE: Build PATH dynamically with existence checks (macOS only)
# Start from predictable system defaults so exec zsh/exec zsh -l stay consistent
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Prefer Homebrew (Apple Silicon) and keep PATH ordering stable
__ensure_brew_shellenv() {
  local brew_bin="/opt/homebrew/bin/brew"
  if [[ -x "$brew_bin" ]]; then
    eval "$("$brew_bin" shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  fi
}

__ensure_brew_shellenv

[[ -d "/System/Cryptexes/App/usr/bin" ]] && PATH="$PATH:/System/Cryptexes/App/usr/bin"
[[ -d "/Library/Apple/usr/bin" ]] && PATH="$PATH:/Library/Apple/usr/bin"

# Add cryptex paths only if they exist (version-specific)
for cryptex_path in \
  "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin" \
  "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin" \
  "/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"; do
  [[ -d "$cryptex_path" ]] && PATH="$PATH:$cryptex_path"
done

# PERFORMANCE: Add Go PATH with error handling and caching
if command -v go >/dev/null 2>&1; then
  # Cache GOPATH to avoid repeated calls
  export GOPATH="${GOPATH:-$(go env GOPATH 2>/dev/null || echo "$HOME/go")}"
  PATH="$PATH:$GOPATH/bin"
fi

# PERFORMANCE: Source Cargo environment if it exists
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# ===========================
# FZF CONFIGURATION - PERFORMANCE OPTIMIZED
# ===========================
# Theme-aware colors (macOS system appearance)
FZF_COLOR_LIGHT='fg:#1f2937,fg+:#111827,bg:#f8fafc,bg+:#e2e8f0,hl:#1d4ed8,hl+:#1e40af,info:#2563eb,prompt:#0f766e,pointer:#dc2626,marker:#b45309,spinner:#0891b2,header:#334155,border:#cbd5e1'
FZF_COLOR_DARK='fg:#e5e7eb,fg+:#f8fafc,bg:#1f2937,bg+:#334155,hl:#93c5fd,hl+:#bfdbfe,info:#60a5fa,prompt:#34d399,pointer:#f87171,marker:#f59e0b,spinner:#22d3ee,header:#cbd5e1,border:#475569'
FZF_THEME_COLOR="$FZF_COLOR_LIGHT"

if [[ "$OSTYPE" == darwin* ]] && command -v defaults >/dev/null 2>&1; then
  if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
    FZF_THEME_COLOR="$FZF_COLOR_DARK"
  fi
fi

export FZF_THEME_COLOR
export FZF_THEME_OPTS="--color=${FZF_THEME_COLOR}"

# Default command uses fd for better performance and respects .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Default options with optimized preview and keybindings
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview-window=right:60% --bind \"ctrl-/:change-preview-window(down|hidden|)\" --bind ctrl-u:preview-page-up --bind ctrl-d:preview-page-down ${FZF_THEME_OPTS}"

# Ctrl+T command for file selection
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview \"bat --style=numbers --color=always --line-range :500 {}\" ${FZF_THEME_OPTS}"

# Alt+C command for directory selection
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview \"eza --tree --level=2 --color=always {} 2>/dev/null || ls -la {}\" ${FZF_THEME_OPTS}"

# Ctrl+R command for history search
export FZF_CTRL_R_OPTS="--preview \"echo {}\" --preview-window down:3:hidden:wrap --bind \"ctrl-/:toggle-preview\" ${FZF_THEME_OPTS}"

# PERFORMANCE: Export the constructed PATH
export PATH

# Claude Token limit
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000

# 1Password SSH agent
export SSH_AUTH_SOCK=~/.1password/agent.sock

fpath=(/Users/ab/.granted/zsh_autocomplete/assume/ $fpath)

fpath=(/Users/ab/.granted/zsh_autocomplete/granted/ $fpath)

alias assume=". assume"
