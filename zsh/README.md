# ZSH Configuration

## Overview
This repository currently uses a **Zinit-first** ZSH setup.

Primary entrypoints:
- `zsh/.zshenv` for environment and PATH
- `zsh/.zshrc` for interactive shell setup (plugins, completions, aliases/functions)

## Files
- `zsh/.zshenv` - environment variables, PATH, tool env
- `zsh/.zshrc` - active interactive configuration (Zinit-based)
- `zsh/.zshrc.zinit` - alternate Zinit profile kept in repo
- `zsh/.zsh_aliases` - aliases
- `zsh/.zsh_functions` - shell functions
- `zsh/.zsh_functions_lazy` - lazy helpers (kitty/theme, node wrappers)
- `zsh/.zsh_autoload/` - autoloaded helper functions
- `zsh/.p10k.zsh` - Powerlevel10k config

## Key Behaviors
- Atuin integration for history (`Ctrl+R`) when `atuin` is installed
- Zinit plugin loading with staged/deferred loading
- Ripgrep defaults via `RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"`
- FZF defaults and theme-aware colors exported from `.zshenv`

## Install / Apply
```bash
cd ~/dotfiles
stow zsh
zsh -n zsh/.zshenv zsh/.zshrc
source ~/.zshrc
```

## Useful Checks
```bash
./scripts/benchmark.sh
./scripts/profile-zsh-startup.sh
./scripts/zsh-benchmark-advanced.sh
./scripts/test-completion-demo.sh
```

## Notes
- `scripts/migrate-to-zinit.sh` still exists, but the repo's main `.zshrc` is already Zinit-oriented.
- If docs and runtime differ, treat `zsh/.zshenv` and `zsh/.zshrc` as source of truth.
