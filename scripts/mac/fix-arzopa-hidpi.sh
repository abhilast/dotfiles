#!/usr/bin/env bash
# fix-arzopa-hidpi.sh — Enable HiDPI scaled resolutions for the Arzopa 1080p monitor
#                        using BetterDisplay.
#
# macOS won't offer HiDPI modes for non-Retina panels by default. BetterDisplay
# creates a virtual screen linked to the physical Arzopa, enabling HiDPI scaling.
# This is more reliable than display override plists on modern macOS (Ventura+).
#
# Usage: fix-arzopa-hidpi.sh [install|setup|status|remove]

set -euo pipefail

CASK="betterdisplay"
APP_NAME="BetterDisplay.app"
APP_PATH="/Applications/$APP_NAME"

usage() {
    cat <<EOF
Usage: $(basename "$0") [install|setup|status|remove]

Commands:
  install  (default) Install BetterDisplay via Homebrew if not present
  setup    Open BetterDisplay and print HiDPI configuration steps
  status   Check whether BetterDisplay is installed and running
  remove   Uninstall BetterDisplay via Homebrew
EOF
}

cmd_status() {
    if [[ -d "$APP_PATH" ]]; then
        echo "BetterDisplay is INSTALLED at $APP_PATH"
    else
        echo "BetterDisplay is NOT installed."
        return 0
    fi

    if pgrep -q "BetterDisplay"; then
        echo "BetterDisplay is RUNNING."
    else
        echo "BetterDisplay is NOT running."
    fi
}

cmd_install() {
    if [[ -d "$APP_PATH" ]]; then
        echo "BetterDisplay is already installed."
        cmd_status
        echo ""
        echo "Run '$(basename "$0") setup' for HiDPI configuration steps."
        return 0
    fi

    echo "Installing BetterDisplay via Homebrew..."
    brew install --cask "$CASK"

    echo ""
    echo "BetterDisplay installed."
    echo "Run '$(basename "$0") setup' for HiDPI configuration steps."
}

cmd_setup() {
    if [[ ! -d "$APP_PATH" ]]; then
        echo "BetterDisplay is not installed. Run '$(basename "$0") install' first."
        return 1
    fi

    if ! pgrep -q "BetterDisplay"; then
        echo "Launching BetterDisplay..."
        open -a "$APP_NAME"
        sleep 2
    fi

    cat <<EOF

=== Arzopa HiDPI Setup ===

BetterDisplay is running. To enable HiDPI for the Arzopa:

  1. Click the BetterDisplay menu bar icon
  2. Find the "ARZOPA" display in the list
  3. Click the settings (gear) icon next to it
  4. Enable "Create dummy for this display" (or "Set as HiDPI")
  5. Choose your preferred scaled resolution (e.g. "looks like 1280x720")

The Arzopa should immediately switch to crisp HiDPI rendering.
No restart needed — BetterDisplay handles it live.

Tip: Set BetterDisplay to launch at login (Preferences > General)
     so HiDPI persists across reboots.

EOF
}

cmd_remove() {
    if [[ ! -d "$APP_PATH" ]]; then
        echo "BetterDisplay is not installed. Nothing to remove."
        return 0
    fi

    echo "Uninstalling BetterDisplay..."
    if pgrep -q "BetterDisplay"; then
        killall "BetterDisplay" 2>/dev/null || true
        sleep 1
    fi
    brew uninstall --cask "$CASK"

    echo ""
    echo "BetterDisplay removed. Display will revert to native resolution."
}

case "${1:-install}" in
    install) cmd_install ;;
    setup)   cmd_setup ;;
    status)  cmd_status ;;
    remove)  cmd_remove ;;
    -h|--help) usage ;;
    *)
        echo "Unknown command: $1" >&2
        usage >&2
        exit 1
        ;;
esac
