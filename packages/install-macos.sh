#!/usr/bin/env bash
# macOS: Xcode CLI tools, Homebrew, Brewfile.
# Safe to re-run.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/lib.sh"

if ! xcode-select -p >/dev/null 2>&1; then
  info "installing Xcode command line tools (finish the GUI prompt, then re-run)"
  xcode-select --install
  exit 0
fi

if ! has brew; then
  info "installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do [[ -x $b ]] && eval "$($b shellenv)" && break; done

info "brew bundle"
brew bundle --file="$DOTFILES/packages/Brewfile"
[[ -f "$DOTFILES/packages/Brewfile.local" ]] && brew bundle --file="$DOTFILES/packages/Brewfile.local"

ok "macOS packages done"
