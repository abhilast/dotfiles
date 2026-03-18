#!/bin/bash
set -euo pipefail

# Idempotent: skip if Homebrew already installed
if command -v brew &>/dev/null; then
  echo "Homebrew already installed"
  exit 0
fi

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Bootstrap PATH for this session
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Homebrew installed successfully"
