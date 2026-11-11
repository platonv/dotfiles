# dotfiles

My terminal, editor and AI tool configs, plus install scripts, for **Ubuntu** and **macOS**.
Configs live here and get symlinked into place, so editing either side edits the same file.

## New machine

```sh
# Ubuntu: sudo apt install -y git curl   |   macOS: xcode-select --install
git clone https://github.com/platonv/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Afterwards:
1. Set your name/email in `~/.gitconfig.local` (seeded from `git/gitconfig.local.example`).
2. Add SSH keys, then `gh auth login`.
3. Optional: put machine-specific shell config in `~/.zshrc.local`.

Run single steps with `./install.sh link | packages | shell | desktop`. Every step is safe to re-run.

## What's in here

| Path | What | Linked to |
|---|---|---|
| `zsh/zshrc` | oh-my-zsh, plugins, starship, loads the modules below | `~/.zshrc` |
| `zsh/path.zsh` | PATH, Homebrew/Linuxbrew, Go, Android SDK | (sourced) |
| `zsh/tools.zsh` | nvm, SDKMAN, conda, RVM, each guarded | (sourced) |
| `zsh/aliases.zsh` | aliases | (sourced) |
| `zsh/zshenv` | cargo env, `$EDITOR` (all shells) | `~/.zshenv` |
| `git/gitconfig` | git settings without identity | `~/.gitconfig` |
| `git/ignore` | global gitignore | `~/.config/git/ignore` |
| `ghostty/config.ghostty` | Ghostty terminal: Catppuccin Mocha, alt+ split keys | `~/.config/ghostty/config.ghostty` |
| `nvim/` | Neovim, based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), uses `vim.pack` (nvim 0.12+) | `~/.config/nvim` |
| `zed/settings.json` | Zed editor | `~/.config/zed/settings.json` |
| `ai/claude/` | Claude Code: global `CLAUDE.md`, `settings.json` | `~/.claude/...` |
| `packages/` | `Brewfile` (mac + Linuxbrew), `apt.txt`, per-OS installers | |
| `scripts/` | `link.sh`, `install-shell.sh`, `linux-desktop.sh` (GNOME monospace font), `check-leaks.sh` | |
| `links.conf` | **the symlink manifest**: what goes where | |

## Font

JetBrains Mono (Nerd Font build) everywhere: Ghostty, Zed, the GNOME monospace font (`scripts/linux-desktop.sh`).
Installed by `packages/install-linux.sh` / the `font-jetbrains-mono-nerd-font` cask.

## Ghostty keys

| Keys | Action |
|---|---|
| `alt+\` / `alt+-` | split right / down |
| `ctrl+h/j/k/l` | move between splits |
| `alt+shift+h/j/k/l` | resize split |
| `alt+z` / `alt+x` | zoom / close split |
| `alt+t`, `alt+[` / `alt+]` | new tab, prev / next tab |
| `alt+.` | command palette |
| `ctrl+shift+f` | search scrollback |

## Adding a config

1. Move the file into the repo: `mv ~/.config/foo/config ~/dotfiles/foo/config`
2. Add a line to `links.conf`: `foo/config  ~/.config/foo/config` (optional 3rd column: `linux` or `macos`)
3. Run `scripts/link.sh`. Use `scripts/link.sh --dry-run` to preview.

Anything `link.sh` would overwrite gets moved to `~/.dotfiles-backup/<timestamp>/` first.

## Public repo: what stays out

This repo is public. These stay out of it:

- **Secrets**: tokens, keys, `.npmrc`, `~/.ssh`, `~/.aws`, `~/.kube`, cloud CLI configs.
- **Work**: employer/client names, work hosts, VPN configs, work-only tools.
- **Private or per-machine**: personal infra, note-taking setup, machine-specific Claude skills.

Where they go instead: local files that git never sees.

| Local file | Purpose |
|---|---|
| `~/.gitconfig.local` | git identity, credential helper, `includeIf` for work dirs |
| `~/.zshrc.local`, `~/.zshenv.local` | machine/work shell config, tokens |
| `~/.claude/CLAUDE.local.md` | private AI instructions (imported by `ai/claude/CLAUDE.md`) |
| `packages/Brewfile.local` | work-only packages (gitignored) |
| `~/.config/dotfiles/blocklist` | words the leak check must reject |

**Leak check:** `.githooks/pre-commit` runs `scripts/check-leaks.sh` before every commit.
It looks for token/key patterns and private IPs, runs [gitleaks](https://github.com/gitleaks/gitleaks)
if installed, and matches against your private blocklist. Scan the whole repo with
`scripts/check-leaks.sh --all`.
