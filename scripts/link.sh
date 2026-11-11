#!/usr/bin/env bash
# Create the symlinks listed in links.conf.
#
#   scripts/link.sh            link everything (safe to re-run)
#   scripts/link.sh --dry-run  show what would change
#
# An existing file or dir at a target is moved to ~/.dotfiles-backup/<timestamp>/
# first, so nothing is lost. Links that already point at the repo are left alone.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

DRY=0
[[ "${1:-}" == "--dry-run" ]] && DRY=1
OS="$(detect_os)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

run() { if (( DRY )); then echo "   would: $*"; else "$@"; fi; }

while read -r src target only_os _; do
  [[ -z "$src" || "$src" == \#* ]] && continue
  [[ -n "${only_os:-}" && "$only_os" != "$OS" ]] && continue

  src_abs="$DOTFILES/$src"
  target="${target/#\~/$HOME}"
  [[ -e "$src_abs" ]] || { warn "missing in repo: $src"; continue; }

  if [[ -L "$target" && "$(readlink "$target")" == "$src_abs" ]]; then
    ok "$target"
    continue
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    rel="${target#$HOME/}"
    info "backing up $target -> $BACKUP/$rel"
    run mkdir -p "$(dirname "$BACKUP/$rel")"
    run mv "$target" "$BACKUP/$rel"
  fi

  run mkdir -p "$(dirname "$target")"
  run ln -s "$src_abs" "$target"
  info "linked $target -> $src"
done < "$DOTFILES/links.conf"

# Point git at the repo's hooks (leak check before every commit).
run git -C "$DOTFILES" config core.hooksPath .githooks
