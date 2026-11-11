# dotfiles

Terminal, editor and AI tool configs, plus install scripts, for **Ubuntu** and **macOS**.
Configs are symlinked from here into place, so editing either side edits the same file.
The exception is `~/.zshrc`, which each machine owns and which loads a shared base from here.

## New machine

```sh
# Ubuntu: sudo apt install -y git curl   |   macOS: xcode-select --install
git clone https://github.com/platonv/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Afterwards:
1. Set your name/email in `~/.gitconfig.local` (seeded from `git/gitconfig.local.example`).
2. Add SSH keys, then `gh auth login`.
3. Install what this machine needs on top: `./install.sh tool rust`, `./install.sh tool sdkman java scala`.

## Install steps

| Command | Does |
|---|---|
| `./install.sh` | everything below except `tool` |
| `./install.sh packages` | Homebrew/Linuxbrew + `packages/Brewfile`, apt base on Ubuntu, Ghostty/Zed/font on Ubuntu |
| `./install.sh shell` | creates `~/.zshrc` from the template **only if missing**, installs the core tools, sets zsh as login shell |
| `./install.sh link` | symlinks from `links.conf` |
| `./install.sh desktop` | GNOME settings (monospace font). Linux only |
| `./install.sh tool [name...]` | optional installers. No name lists them |

Every step is safe to re-run. Each tool has its own script in `scripts/install/`:

| Tool | Kind | Notes |
|---|---|---|
| `ohmyzsh` | core | oh-my-zsh + autosuggestions, syntax-highlighting, you-should-use, zsh-bat |
| `starship` | core | prompt. Brew if available, else the official installer to `~/.local/bin` |
| `nvm` | core | nvm + Node LTS |
| `claude-code` | core | Claude Code CLI |
| `rust` | optional | rustup. It adds `~/.cargo/env` to the machine's own shell files |
| `sdkman` | optional | SDKMAN, plus any candidates you pass (`java scala sbt`) |

Adding a tool means adding `scripts/install/<name>.sh`, with a `# [core]` or `# [optional]` description on line 2.
Core tools are listed in `CORE_TOOLS` in `install.sh`.

## zsh: shared base + per-machine zshrc

`~/.zshrc` is **not** a symlink. Each machine keeps its own and loads the shared base at the top:

```zsh
# ZSH_EXTRA_PLUGINS=(docker)        # optional, before the base
[[ -f "$HOME/dotfiles/zsh/base.zsh" ]] && source "$HOME/dotfiles/zsh/base.zsh"

# machine-specific config below: SDKMAN, conda, Android SDK, work stuff...
```

New machines get this from `zsh/zshrc.template`. On an existing machine, `install.sh` never edits
`~/.zshrc`. It only prints the line to add.

| File | Contents |
|---|---|
| `zsh/base.zsh` | entry point: `$EDITOR`, oh-my-zsh + plugins, starship |
| `zsh/path.zsh` | Homebrew/Linuxbrew, `~/.local/bin`, `~/bin`, `~/go/bin` |
| `zsh/tools.zsh` | nvm |
| `zsh/aliases.zsh` | git aliases, `dot` / `dotup` |

Knobs to set before the source line: `ZSH_EXTRA_PLUGINS=(...)`, `DOTFILES_NO_STARSHIP=1`.

## Linked configs

| Repo path | Linked to |
|---|---|
| `git/gitconfig` (no identity; includes `~/.gitconfig.local`) | `~/.gitconfig` |
| `git/ignore` (global gitignore) | `~/.config/git/ignore` |
| `ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `nvim/` (kickstart.nvim fork, `vim.pack`, Neovim ≥ 0.12) | `~/.config/nvim` |
| `zed/settings.json` | `~/.config/zed/settings.json` |
| `ai/claude/CLAUDE.md`, `ai/claude/settings.json` | `~/.claude/` |

`links.conf` is the manifest. To add a config:
1. `mv ~/.config/foo/config ~/dotfiles/foo/config`
2. Add a line to `links.conf`: `foo/config  ~/.config/foo/config` (optional 3rd column: `linux` or `macos`)
3. Run `scripts/link.sh`. Use `scripts/link.sh --dry-run` to preview.

Anything `link.sh` would replace gets moved to `~/.dotfiles-backup/<timestamp>/` first.

## Look

- **Font:** JetBrains Mono (Nerd Font build) in Ghostty, Zed and the GNOME monospace setting.
- **Theme:** Catppuccin Mocha in Ghostty, nvim and starship.
- **Prompt:** starship with directory, git, language versions inside projects, and duration for slow commands.
  Cloud/k8s modules are left out on purpose, so account and cluster names don't end up in screenshots.

### Ghostty keys

| Keys | Action |
|---|---|
| `alt+\` / `alt+-` | split right / down |
| `ctrl+h/j/k/l` | move between splits |
| `alt+shift+h/j/k/l` | resize split |
| `alt+z` / `alt+x` | zoom / close split |
| `alt+t`, `alt+[` / `alt+]` | new tab, prev / next tab |
| `alt+.` | command palette |
| `ctrl+shift+f` | search scrollback |

## Public repo: what stays out

This repo is public. Secrets, personal details, work info, and per-machine setup stay out of it.
They go in local files that git never sees:

| Local file | Purpose |
|---|---|
| `~/.zshrc` | everything machine-specific in the shell |
| `~/.gitconfig.local` | git identity, credential helper, `includeIf` for other identities |
| `~/.claude/CLAUDE.local.md` | private AI instructions (imported by `ai/claude/CLAUDE.md`) |
| `packages/Brewfile.local` | extra packages for one machine (gitignored) |
| `~/.config/dotfiles/blocklist` | words the leak check must reject |

**Leak check:** `.githooks/pre-commit` runs `scripts/check-leaks.sh` before every commit.
It looks for token/key patterns and private IPs, runs [gitleaks](https://github.com/gitleaks/gitleaks)
if installed, and matches against the private blocklist. Scan the whole repo with
`scripts/check-leaks.sh --all`.
