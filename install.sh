#!/usr/bin/env bash
# Bootstrap a machine (Ubuntu or macOS).
#
#   git clone https://github.com/platonv/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
#
#   ./install.sh                 packages + shell + link + desktop (core only)
#   ./install.sh packages        OS packages (Brewfile / apt)
#   ./install.sh shell           ~/.zshrc hook + core tools (oh-my-zsh, starship, nvm, claude-code)
#   ./install.sh link            symlinks from links.conf
#   ./install.sh desktop         GNOME settings (Linux only)
#   ./install.sh tool <name>...  optional installers from scripts/install/, e.g. `tool rust sdkman`
#   ./install.sh tool            list available tools
#
# Every step is safe to re-run.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/scripts/lib.sh"

OS="$(detect_os)"
step="${1:-all}"
[[ $# -gt 0 ]] && shift

# Tools every machine gets. Everything else in scripts/install/ is opt-in.
CORE_TOOLS="ohmyzsh starship nvm claude-code"

run_tool() {
  local script="$DOTFILES/scripts/install/$1.sh"
  [[ -f "$script" ]] || die "no installer: scripts/install/$1.sh (see ./install.sh tool)"
  info "tool: $1"
  bash "$script" "${@:2}"
}

list_tools() {
  echo "Installers in scripts/install/ ([core] ones run with ./install.sh shell):"
  for f in "$DOTFILES"/scripts/install/*.sh; do
    printf '  %-12s %s\n' "$(basename "$f" .sh)" "$(sed -n 2p "$f" | sed 's/^# //')"
  done
}

do_packages() { bash "$DOTFILES/packages/install-$OS.sh"; }
do_link()     { bash "$DOTFILES/scripts/link.sh"; post_link; }
do_desktop()  { if [[ "$OS" == linux ]]; then bash "$DOTFILES/scripts/linux-desktop.sh"; fi; }

do_shell() {
  # ~/.zshrc belongs to the machine. Only create it if it doesn't exist yet.
  if [[ ! -e "$HOME/.zshrc" ]]; then
    cp "$DOTFILES/zsh/zshrc.template" "$HOME/.zshrc"
    info "created ~/.zshrc from zsh/zshrc.template"
  elif ! grep -q 'dotfiles/zsh/base.zsh' "$HOME/.zshrc"; then
    warn "~/.zshrc doesn't load the shared base. To use it, add near the top:"
    warn "  [[ -f \"\$HOME/dotfiles/zsh/base.zsh\" ]] && source \"\$HOME/dotfiles/zsh/base.zsh\""
  fi

  for t in $CORE_TOOLS; do run_tool "$t"; done

  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ "${SHELL:-}" != "$zsh_path" && "$(basename "${SHELL:-}")" != zsh ]]; then
    grep -qx "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    info "changing default shell to $zsh_path"
    chsh -s "$zsh_path" || warn "chsh failed. Run it manually: chsh -s $zsh_path"
  fi
}

post_link() {
  # Seed the private files that are never committed
  if [[ ! -f "$HOME/.gitconfig.local" ]]; then
    cp "$DOTFILES/git/gitconfig.local.example" "$HOME/.gitconfig.local"
    warn "created ~/.gitconfig.local from the template. Set your name/email in it."
  fi
  mkdir -p "$HOME/.claude" "$HOME/.config/dotfiles"
  touch "$HOME/.claude/CLAUDE.local.md"
  if [[ ! -f "$HOME/.config/dotfiles/blocklist" ]]; then
    printf '# One case-insensitive regex per line. The leak check rejects commits that match.\n' > "$HOME/.config/dotfiles/blocklist"
    warn "add terms that must never be committed to ~/.config/dotfiles/blocklist"
  fi
}

info "OS: $OS, step: $step"
case "$step" in
  all)      do_packages; do_shell; do_link; do_desktop ;;
  packages) do_packages ;;
  shell)    do_shell ;;
  link)     do_link ;;
  desktop)  do_desktop ;;
  tool)
    if [[ $# -eq 0 ]]; then list_tools; exit 0; fi
    # `tool sdkman java scala`: extra args after sdkman go to the sdkman installer
    if [[ "$1" == sdkman ]]; then run_tool "$@"; else for t in "$@"; do run_tool "$t"; done; fi
    ;;
  *) die "unknown step: $step (use: all | packages | shell | link | desktop | tool)" ;;
esac
ok "done. Open a new terminal."
