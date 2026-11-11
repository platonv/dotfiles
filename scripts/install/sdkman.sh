#!/usr/bin/env bash
# [optional] SDKMAN for JVM tooling. Not part of ./install.sh.
#
#   ./install.sh tool sdkman                     SDKMAN only
#   ./install.sh tool sdkman java scala sbt      SDKMAN + those candidates (latest versions)
#
# The SDKMAN installer adds its init line to this machine's own ~/.zshrc,
# so nothing JVM-related lives in the shared zsh base.
set -eo pipefail   # no -u: sdkman-init.sh references unset variables
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

export SDKMAN_DIR="$HOME/.sdkman"
if [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  info "installing SDKMAN"
  curl -fsSL "https://get.sdkman.io" | bash
fi

source "$SDKMAN_DIR/bin/sdkman-init.sh"
for candidate in "$@"; do
  info "sdk install $candidate"
  sdk install "$candidate" </dev/null || warn "sdk install $candidate failed"
done
ok "sdkman $(sdk version 2>/dev/null | tail -1)"
