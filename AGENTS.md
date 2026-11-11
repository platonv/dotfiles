# AGENTS.md: guide for AI assistants working in this repo

Personal dotfiles for Ubuntu and macOS. Read `README.md` for the full layout. This file covers the rules.

## Hard rules

1. **This repo is PUBLIC.** Never commit secrets, tokens, keys, private IPs, hostnames,
   home-infra details, or anything work-related (employer, clients, work tools, VPNs).
   Private or work content goes in the `*.local` files listed in the README, which git ignores.
2. Run `scripts/check-leaks.sh --all` before proposing a commit. Never use `--no-verify`
   unless the user approves that specific false positive.
3. Ask before pushing. Ask before running `install.sh` without a step (it installs packages and runs `chsh`).
4. Everything must work on **both** Ubuntu and macOS:
   - scripts run under macOS's bash 3.2: no `declare -A`, `mapfile` (except in `install-linux.sh`), `${var,,}`
   - no GNU-only flags (`sed -i` without a suffix, `readlink -f`, `grep -P`) in shared scripts
   - guard every tool in shell config: `command -v x >/dev/null && ...` or `[[ -d ... ]]`
   - OS-specific logic: `detect_os` from `scripts/lib.sh`, or the 3rd column in `links.conf`

## How things fit together

- `links.conf` is the source of truth for what gets symlinked where. `scripts/link.sh` applies it idempotently.
- Configs are symlinked, so `~/.zshrc` and `zsh/zshrc` are the same file. Edit the repo copy.
- `zsh/zshrc` sources `path.zsh` → oh-my-zsh → `tools.zsh` → `aliases.zsh` → `~/.zshrc.local`.
- Packages: `packages/Brewfile` serves both OSes (casks inside `if OS.mac?`). `apt.txt` is just the Ubuntu base.
  Tools that aren't brew/apt packages (oh-my-zsh, nvm, SDKMAN, rustup, Claude Code) are in `scripts/install-shell.sh`.
- `nvim/` is a kickstart.nvim fork on `vim.pack` (Neovim ≥ 0.12). `nvim-pack-lock.json` pins plugin versions and is tracked.
  Custom plugins go in `nvim/lua/custom/plugins/*.lua`.
- `ai/claude/CLAUDE.md` is the user's global Claude Code instructions. It imports `~/.claude/CLAUDE.local.md` for private context.

## Common tasks

| Task | Do |
|---|---|
| Add a config | move it into the repo, add a line to `links.conf`, run `scripts/link.sh` |
| Add a CLI tool | add `brew "x"` to `packages/Brewfile` |
| Add a mac GUI app | add `cask "x"` inside `if OS.mac?` |
| Add a Linux GUI app | add a guarded install block to `packages/install-linux.sh` |
| Add an alias | `zsh/aliases.zsh` |
| Check a shell change | `zsh -i -c exit` (no errors), then `zsh -n zsh/*.zsh` |
| Check the Ghostty config | `ghostty +validate-config --config-file=ghostty/config.ghostty` |
| Check shell scripts | `bash -n scripts/*.sh packages/*.sh install.sh` (and `shellcheck` if installed) |

## Style

- Short header comment at the top of each file: what it is and where it's linked.
- Comments explain *why*, not what.
- Keep the README tables up to date when adding or moving files.
