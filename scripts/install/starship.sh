#!/usr/bin/env bash
# [core] starship prompt. Config: starship/starship.toml -> ~/.config/starship.toml (links.conf).
# Uses Homebrew when available (same version as the Brewfile), else the official installer.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

if has starship; then
  ok "starship $(starship --version | head -1 | awk '{print $2}')"
elif has brew; then
  info "installing starship (brew)"
  brew install starship
else
  info "installing starship to ~/.local/bin"
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi
