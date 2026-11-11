#!/usr/bin/env bash
# GNOME desktop preferences (Ubuntu). No-op without gsettings. Safe to re-run.
#   scripts/linux-desktop.sh
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

has gsettings || { warn "gsettings not found, skipping desktop settings"; exit 0; }

# JetBrains Mono as the system monospace font (GTK apps, GNOME Terminal, etc.).
# The UI font stays the Ubuntu default.
if fc-list : family | grep -i "JetBrainsMono Nerd Font" >/dev/null; then
  gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 13'
  ok "monospace font: JetBrainsMono Nerd Font 13"
else
  warn "JetBrainsMono Nerd Font not installed, run packages/install-linux.sh first"
fi
