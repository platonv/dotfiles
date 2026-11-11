#!/usr/bin/env bash
# [core] tmux plugins: TPM + everything listed in tmux/tmux.conf. Safe to re-run.
# tmux itself comes from the Brewfile. Config: tmux/tmux.conf -> ~/.tmux.conf (links.conf).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

has tmux || die "tmux not installed. Run ./install.sh packages first"

TPM="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM" ]]; then
  info "installing TPM"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
fi

# The TPM scripts read the plugin list from ~/.tmux.conf, so the config must be linked first.
if [[ ! -e "$HOME/.tmux.conf" ]]; then
  warn "~/.tmux.conf missing. Run scripts/link.sh, then re-run this"
  exit 0
fi

info "installing / updating tmux plugins"
"$TPM/bin/install_plugins" >/dev/null
"$TPM/bin/update_plugins" all >/dev/null
ok "tmux plugins: $(ls "$HOME/.tmux/plugins" | tr '\n' ' ')"
