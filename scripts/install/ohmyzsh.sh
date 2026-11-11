#!/usr/bin/env bash
# [core] oh-my-zsh + the custom plugins zsh/base.zsh enables. Safe to re-run.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "installing oh-my-zsh"
  # KEEP_ZSHRC: never touch the machine's ~/.zshrc
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
# "<name> <url>" pairs. Plain list because macOS ships bash 3.2 (no associative arrays).
while read -r name url; do
  dir="$ZSH_CUSTOM/plugins/$name"
  if [[ -d "$dir" ]]; then ok "omz plugin $name"; else
    info "cloning omz plugin $name"
    git clone --depth 1 "$url" "$dir"
  fi
done <<'EOF'
zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting
you-should-use https://github.com/MichaelAquilina/zsh-you-should-use
zsh-bat https://github.com/fdellwing/zsh-bat
EOF
