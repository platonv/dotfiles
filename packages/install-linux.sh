#!/usr/bin/env bash
# Ubuntu: apt base, Linuxbrew + Brewfile, GUI apps, Nerd Font.
# Safe to re-run. Anything already installed is skipped.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/lib.sh"

info "apt base packages"
mapfile -t pkgs < <(grep -vE '^\s*(#|$)' "$DOTFILES/packages/apt.txt")
sudo apt-get update -qq
sudo apt-get install -y "${pkgs[@]}"

if ! has brew && [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  info "installing Linuxbrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

info "brew bundle"
brew bundle --file="$DOTFILES/packages/Brewfile"
[[ -f "$DOTFILES/packages/Brewfile.local" ]] && brew bundle --file="$DOTFILES/packages/Brewfile.local"

# Ghostty: community .deb builds (https://github.com/mkasberg/ghostty-ubuntu)
if ! has ghostty; then
  info "installing Ghostty"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
fi

# Zed
if ! has zed; then
  info "installing Zed"
  curl -fsSL https://zed.dev/install.sh | sh
fi

# JetBrainsMono Nerd Font (used by Ghostty and nvim icons)
if ! fc-list : family | grep -i "JetBrainsMono Nerd Font" >/dev/null; then
  info "installing JetBrainsMono Nerd Font"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/font.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  mkdir -p "$HOME/.local/share/fonts"
  unzip -qo "$tmp/font.zip" -d "$HOME/.local/share/fonts"
  fc-cache -f >/dev/null
  rm -rf "$tmp"
fi

ok "linux packages done"
