#!/usr/bin/env bash
# Shared helpers. Source it, don't run it.

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export DOTFILES

info() { printf '\033[34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[32m ok\033[0m %s\n' "$*"; }
warn() { printf '\033[33m !!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[31mERR\033[0m %s\n' "$*" >&2; exit 1; }

# Prints: linux | macos
detect_os() {
  case "$(uname -s)" in
    Linux)  echo linux ;;
    Darwin) echo macos ;;
    *) die "unsupported OS: $(uname -s)" ;;
  esac
}

has() { command -v "$1" >/dev/null 2>&1; }
