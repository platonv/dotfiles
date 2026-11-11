#!/usr/bin/env bash
# [core] nvm + the current LTS Node. Safe to re-run.
# zsh/tools.zsh loads nvm, so the installer must not edit any rc file (PROFILE=/dev/null).
set -eo pipefail   # no -u: nvm.sh references unset variables
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  info "installing nvm"
  PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh)"
fi

source "$NVM_DIR/nvm.sh"
if [[ -z "$(nvm ls --no-colors 2>/dev/null | grep -v 'N/A' | grep -E 'v[0-9]')" ]]; then
  info "installing Node LTS"
  nvm install --lts
fi
ok "nvm $(nvm --version)"
