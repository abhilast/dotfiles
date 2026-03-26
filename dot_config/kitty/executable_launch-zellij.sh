#!/bin/sh
# Kitty-specific: launch zellij with catppuccin-latte theme
# (default config.kdl uses gruvbox-dark for ghostty)
CONF="$HOME/.config/zellij/config.kdl"
TMPCONF="/tmp/zellij-themed.kdl"
sed 's/^theme ".*"/theme "catppuccin-latte"/' "$CONF" > "$TMPCONF"
exec zellij -l welcome --config "$TMPCONF"
