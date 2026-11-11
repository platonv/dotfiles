#!/usr/bin/env bash
# [core] Claude Code CLI (native installer, auto-updates). Config: ai/claude/ (links.conf).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

if has claude; then
  ok "claude $(claude --version 2>/dev/null | head -1)"
else
  info "installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi
