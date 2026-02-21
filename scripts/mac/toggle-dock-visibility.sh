#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title toggle-dock-visibility
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

set -euo pipefail

DOMAIN="com.apple.dock"
KEY="autohide"

current="$(defaults read "$DOMAIN" "$KEY" 2>/dev/null || echo 0)"

# `defaults` may return 0/1 or true/false depending on how it was written.
case "$current" in
  1|true|TRUE|yes|YES) next=false; label="Dock: always visible" ;;
  0|false|FALSE|no|NO|"") next=true;  label="Dock: auto-hide" ;;
  *) next=true; label="Dock: auto-hide" ;;
esac

defaults write "$DOMAIN" "$KEY" -bool "$next"
killall Dock >/dev/null 2>&1 || true

echo "$label"

