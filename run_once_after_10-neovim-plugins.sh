#!/bin/bash
set -euo pipefail

if ! command -v nvim &>/dev/null; then
  echo "WARNING: Neovim not found, skipping plugin sync"
  echo "Install neovim and run: nvim --headless '+Lazy! sync' +qa"
  exit 0
fi

echo "Syncing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || {
  echo "WARNING: Plugin sync failed or timed out"
  echo "Run manually: nvim --headless '+Lazy! sync' +qa"
  exit 0
}

echo "Neovim plugins synced successfully"
