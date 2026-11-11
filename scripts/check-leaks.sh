#!/usr/bin/env bash
# Scan the repo for secrets and private/work info before it goes public.
#
#   scripts/check-leaks.sh           scan staged changes (used by the pre-commit hook)
#   scripts/check-leaks.sh --all     scan every tracked file
#
# Three layers:
#   1. gitleaks, if installed (best secret detection)
#   2. built-in regexes for common tokens, keys and private IPs
#   3. a private blocklist of words (employer, clients, internal hostnames) at
#      ~/.config/dotfiles/blocklist, one case-insensitive regex per line.
#      That file is never committed, so the blocklist doesn't leak either.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$DOTFILES"

MODE="${1:-staged}"
BLOCKLIST="$HOME/.config/dotfiles/blocklist"
fail=0

if [[ "$MODE" == "--all" ]]; then
  content() { git ls-files -z | xargs -0 grep -nHIE "$@" -- 2>/dev/null; }
else
  # Only added lines of the staged diff
  content() { git diff --cached -U0 --no-color | grep -E '^\+[^+]' | grep -nIE "$@"; }
fi

# 1. gitleaks
if has gitleaks; then
  if [[ "$MODE" == "--all" ]]; then gitleaks detect --no-banner --redact -q || fail=1
  else gitleaks protect --staged --no-banner --redact -q || fail=1; fi
fi

# 2. built-in patterns. Each pattern is split with '' so this file doesn't match itself.
patterns=(
  '-----BEGIN [A-Z ]*PRIV''ATE KEY'
  'gh[pousr]_[A-Za-z0-9]{30,}'
  'github_p''at_[A-Za-z0-9_]{30,}'
  'sk-(ant-|proj-)?[A-Za-z0-9_-]{20,}'
  'AK''IA[0-9A-Z]{16}'
  'xox[abprs]-[A-Za-z0-9-]{10,}'
  '[0-9]{8,10}:AA[A-Za-z0-9_-]{30,}'
  '(pass''word|sec''ret|tok''en|api[_-]?key)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9/+_-]{12,}'
  '\b(192\.168|10\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[01]))\.[0-9]{1,3}\.[0-9]{1,3}\b'
)
for p in "${patterns[@]}"; do
  if hits="$(content -e "$p")" && [[ -n "$hits" ]]; then
    warn "possible secret / private info (pattern: $p):"
    echo "$hits" | sed 's/^/     /' >&2
    fail=1
  fi
done

# 3. private blocklist
if [[ -s "$BLOCKLIST" ]]; then
  while IFS= read -r word; do
    [[ -z "$word" || "$word" == \#* ]] && continue
    if hits="$(content -i -e "$word")" && [[ -n "$hits" ]]; then
      warn "blocklisted term found (from $BLOCKLIST):"
      echo "$hits" | sed 's/^/     /' >&2
      fail=1
    fi
  done < "$BLOCKLIST"
else
  warn "no blocklist at $BLOCKLIST. Add your employer/client names there."
fi

if (( fail )); then
  warn "leak check FAILED. Fix it, or bypass with 'git commit --no-verify' if you're sure it's a false positive."
  exit 1
fi
ok "leak check passed ($MODE)"
