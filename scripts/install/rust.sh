#!/usr/bin/env bash
# [optional] Rust via rustup. Not part of ./install.sh. Run: ./install.sh tool rust
# rustup adds `. "$HOME/.cargo/env"` to this machine's own ~/.zshenv / ~/.profile,
# so nothing Rust-related lives in the shared zsh base.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

if has rustup || [[ -x "$HOME/.cargo/bin/rustup" ]]; then
  ok "rustup already installed, updating"
  "$(command -v rustup || echo "$HOME/.cargo/bin/rustup")" update
else
  info "installing Rust (rustup, stable toolchain)"
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
  ok "open a new shell, or: source ~/.cargo/env"
fi
