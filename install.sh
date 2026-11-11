#!/usr/bin/env bash
# Bootstrap a machine (Ubuntu or macOS).
#
#   git clone git@github.com:platonv/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
#
#   ./install.sh            packages + shell tooling + symlinks
#   ./install.sh link       symlinks only (safe, fast)
#   ./install.sh packages   OS packages only
#   ./install.sh shell      oh-my-zsh, nvm, sdkman, rust, claude code only
#   ./install.sh desktop    GNOME settings (monospace font), Linux only
#
# Every step is safe to re-run.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/scripts/lib.sh"

OS="$(detect_os)"
step="${1:-all}"

do_packages() { bash "$DOTFILES/packages/install-$OS.sh"; }
do_shell()    { bash "$DOTFILES/scripts/install-shell.sh"; }
do_link()     { bash "$DOTFILES/scripts/link.sh"; post_link; }
do_desktop()  { [[ "$OS" == linux ]] && bash "$DOTFILES/scripts/linux-desktop.sh" || true; }

post_link() {
  # Seed the private files that are never committed
  if [[ ! -f "$HOME/.gitconfig.local" ]]; then
    cp "$DOTFILES/git/gitconfig.local.example" "$HOME/.gitconfig.local"
    warn "created ~/.gitconfig.local from the template. Set your name/email in it."
  fi
  touch "$HOME/.zshrc.local" "$HOME/.claude/CLAUDE.local.md" 2>/dev/null || true
  mkdir -p "$HOME/.config/dotfiles"
  [[ -f "$HOME/.config/dotfiles/blocklist" ]] || {
    printf '# One case-insensitive regex per line: employer, clients, internal domains.\n' > "$HOME/.config/dotfiles/blocklist"
    warn "add work terms to ~/.config/dotfiles/blocklist so the leak check catches them"
  }
}

info "OS: $OS, step: $step"
case "$step" in
  all)      do_packages; do_shell; do_link; do_desktop ;;
  desktop)  do_desktop ;;
  packages) do_packages ;;
  shell)    do_shell ;;
  link)     do_link ;;
  *) die "unknown step: $step (use: all | packages | shell | link | desktop)" ;;
esac
ok "done. Open a new terminal."
