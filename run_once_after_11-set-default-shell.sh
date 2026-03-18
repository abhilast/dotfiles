#!/bin/bash
set -euo pipefail

# Determine the best available zsh
if [[ -x "/opt/homebrew/bin/zsh" ]]; then
  TARGET_SHELL="/opt/homebrew/bin/zsh"
elif [[ -x "/usr/local/bin/zsh" ]]; then
  TARGET_SHELL="/usr/local/bin/zsh"
else
  TARGET_SHELL="/bin/zsh"
fi

# Check if already set
CURRENT_SHELL=$(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')
if [[ "$CURRENT_SHELL" == "$TARGET_SHELL" ]]; then
  echo "Default shell already set to $TARGET_SHELL"
  exit 0
fi

# Ensure target shell is in /etc/shells
if ! grep -qF "$TARGET_SHELL" /etc/shells; then
  echo "Adding $TARGET_SHELL to /etc/shells (requires sudo)..."
  echo "$TARGET_SHELL" | sudo tee -a /etc/shells >/dev/null
fi

echo "Setting default shell to $TARGET_SHELL..."
chsh -s "$TARGET_SHELL"
echo "Default shell set to $TARGET_SHELL"
