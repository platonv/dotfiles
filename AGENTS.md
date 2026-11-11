# AGENTS.md: guide for AI assistants working in this repo

Personal dotfiles for Ubuntu and macOS. `README.md` has the full layout. This file covers the rules.

## Hard rules

1. **This repo is PUBLIC.** Never commit secrets, tokens, keys, private IPs, hostnames, personal
   details (names, emails, employers, clients), personal infra, note-taking/vault setup, or anything
   work-related. Per-machine or private content goes in the local files listed in the README.
2. Run `scripts/check-leaks.sh --all` before proposing a commit. Never use `--no-verify`
   unless the user approves that specific false positive.
3. Ask before pushing. Ask before running `install.sh` with no step (it installs packages and may run `chsh`).
4. **`~/.zshrc` belongs to the machine.** Never symlink, overwrite or auto-edit it. Shared shell config
   goes in `zsh/*.zsh`, loaded through `zsh/base.zsh`.
5. **Keep the core small.** Language toolchains that not every machine needs (Rust, JVM/SDKMAN, conda, ...)
   get their own `scripts/install/<name>.sh` marked `# [optional]`. They never go in `CORE_TOOLS` or the
   shared zsh base.
6. Everything must work on **both** Ubuntu and macOS:
   - scripts run under macOS's bash 3.2: no `declare -A`, `mapfile` (except in `install-linux.sh`), `${var,,}`
   - no GNU-only flags (`sed -i` without a suffix, `readlink -f`, `grep -P`) in shared scripts
   - with `set -o pipefail`, don't pipe into `grep -q`: it exits early and the pipeline fails. Use `grep ... >/dev/null`
   - guard every tool in shell config: `command -v x >/dev/null && ...` or `[[ -d ... ]]`
   - OS-specific logic: `detect_os` from `scripts/lib.sh`, or the 3rd column in `links.conf`

## How things fit together

- `install.sh` runs the steps `packages | shell | link | desktop | tool <name>`.
- `scripts/install/*.sh` holds one installer per tool. Line 2 is `# [core] ...` or `# [optional] ...`, and `./install.sh tool` lists them.
  `CORE_TOOLS` in `install.sh` lists what `shell` runs.
- `links.conf` is the source of truth for symlinks. `scripts/link.sh` applies it idempotently and backs up what it replaces.
- `zsh/base.zsh` sources `path.zsh` → oh-my-zsh → `tools.zsh` → `aliases.zsh` → starship. The machine's `~/.zshrc`
  sources the base at the top (template: `zsh/zshrc.template`).
- `packages/Brewfile` serves both OSes (casks inside `if OS.mac?`). `apt.txt` is just the Ubuntu base.
- `nvim/` is a kickstart.nvim fork on `vim.pack` (Neovim ≥ 0.12). `nvim-pack-lock.json` pins plugins and is tracked.
  Custom plugins go in `nvim/lua/custom/plugins/*.lua`.
- `starship/starship.toml` uses an explicit `format` allow-list. Don't add cloud/k8s context modules.
  Nerd Font glyphs can get stripped by some editors and tools, so check them with a codepoint dump after editing.
- `ai/claude/CLAUDE.md` is the user's global Claude Code instructions. It imports `~/.claude/CLAUDE.local.md` for private context.

## Common tasks

| Task | Do |
|---|---|
| Add a config | move it into the repo, add a line to `links.conf`, run `scripts/link.sh` |
| Add a CLI tool everyone gets | `brew "x"` in `packages/Brewfile` |
| Add an optional toolchain | new `scripts/install/<name>.sh` with `# [optional]` on line 2 |
| Add a mac GUI app | `cask "x"` inside `if OS.mac?` |
| Add a Linux GUI app | guarded block in `packages/install-linux.sh` |
| Add an alias | `zsh/aliases.zsh` |
| Check zsh | `zsh -n zsh/*.zsh`, then test via a temp `ZDOTDIR` with a `.zshrc` copied from `zsh/zshrc.template` |
| Check Ghostty | `ghostty +validate-config --config-file=ghostty/config.ghostty` |
| Check starship | `STARSHIP_CONFIG=starship/starship.toml starship prompt` (no warnings printed) |
| Check scripts | `bash -n install.sh scripts/*.sh scripts/install/*.sh packages/*.sh` (and `shellcheck` if installed) |

## Style

- Short header comment at the top of each file: what it is and where it's linked.
- Comments explain *why*, not what.
- Keep the README tables up to date when adding or moving files.
