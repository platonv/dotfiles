#!/usr/bin/env bash
# Shell and dev tooling that isn't a brew/apt package:
# oh-my-zsh + custom plugins, nvm, SDKMAN, Rust, Claude Code. Default shell -> zsh.
# Safe to re-run.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "installing oh-my-zsh"
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
  info "installing nvm"
  PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh)"
fi

if [[ ! -d "$HOME/.sdkman" ]]; then
  info "installing SDKMAN"
  curl -fsSL "https://get.sdkman.io?rcupdate=false" | bash
fi

if ! has cargo && [[ ! -x "$HOME/.cargo/bin/cargo" ]]; then
  info "installing Rust (rustup)"
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

if ! has claude; then
  info "installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

zsh_path="$(command -v zsh)"
if [[ "${SHELL:-}" != "$zsh_path" ]]; then
  grep -qx "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  info "changing default shell to $zsh_path"
  chsh -s "$zsh_path" || warn "chsh failed. Run it manually: chsh -s $zsh_path"
fi

ok "shell tooling done"
