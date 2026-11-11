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
| `./install.sh` | packages → link → shell → desktop (not `tool`) |
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
| `tmux` | core | TPM + the plugins in `tmux/tmux.conf`: navigator, which-key, fzf, resurrect, continuum, theme |
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
| `zsh/tools.zsh` | nvm, zoxide (`z foo` to jump, `zi` to pick with fzf) |
| `zsh/aliases.zsh` | git aliases, `dot` / `dotup` |
| `zsh/claude.zsh` | `cw <task>`: Claude in a new git worktree + tmux window |

Knobs to set before the source line: `ZSH_EXTRA_PLUGINS=(...)`, `DOTFILES_NO_STARSHIP=1`.

## Linked configs

| Repo path | Linked to |
|---|---|
| `git/gitconfig` (no identity; includes `~/.gitconfig.local`) | `~/.gitconfig` |
| `git/ignore` (global gitignore) | `~/.config/git/ignore` |
| `ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `tmux/tmux.conf` | `~/.tmux.conf` (machine overrides: `~/.tmux.local.conf`) |
| `nvim/` (kickstart.nvim fork, `vim.pack`, Neovim ≥ 0.12) | `~/.config/nvim` |
| `zed/settings.json` | `~/.config/zed/settings.json` |
| `ai/claude/settings.json` | `~/.claude/settings.json` |

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

### nvim keys

Leader is **Space**. Lost? Press **`<leader>?`** for a searchable list of every keymap, or press
`<leader>` and wait for the which-key popup. Inside the explorer or a Telescope picker, `?` shows its own keys.

| Keys | Action |
|---|---|
| `<leader>p` | find files (includes dotfiles, skips `.git`) |
| `<leader>f` | search text across the project (live grep). In visual mode: search the selection |
| `<leader>o` / `<leader>O` | symbols in file (LSP, falls back to Treesitter) / in workspace |
| `<leader>e` | file explorer (neo-tree), docked on the right, reveals the current file |
| `<leader><leader>` | open buffers |
| `<leader>s…` | more Telescope pickers: help, diagnostics, recent files, resume... |
| `<leader>w` | save |
| `<leader>cf` | format buffer (also runs on save) |
| `<leader>bd` / `<leader>bo` | close buffer / close all other buffers |
| `<leader>\|` or `<leader>\` / `<leader>-` | split right / down (same keys as tmux) |
| `C-h/j/k/l` | move between splits and tmux panes |
| visual `J` / `K`, `<` / `>` | move lines, indent while keeping the selection |

Icons come from mini.icons and need a Nerd Font in the terminal. JetBrainsMono Nerd Font is installed by
`packages/` and set in Ghostty. Custom config lives in `nvim/lua/custom/plugins/` (`keymaps.lua`, `explorer.lua`).

### tmux keys

Prefix is **`C-a`** (press twice to send a literal `C-a`). Tips for finding shortcuts:
- **`prefix ?`** lists every binding with a description. All custom ones have one.
- **`prefix Space`** opens a which-key style menu ([tmux-which-key](https://github.com/alexwforsythe/tmux-which-key)) for everything.
- A red **PREFIX** badge in the status bar shows when the prefix is active.

| Keys | Action |
|---|---|
| `C-h/j/k/l` (no prefix) | move between tmux panes **and** nvim splits ([vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)) |
| `prefix \|` or `prefix \` / `prefix -` | split right / down, in the current directory |
| `prefix h/j/k/l` | move between panes (fallback) |
| `prefix H/J/K/L` | resize, repeatable |
| `prefix z` / `prefix x` | zoom / kill pane |
| `prefix c`, `prefix Tab`, `prefix < / >` | new window, last window, move window |
| `prefix F` | fzf menu: switch/kill/rename sessions, windows, panes; run any tmux command ([tmux-fzf](https://github.com/sainnhe/tmux-fzf)) |
| `prefix s` / `prefix N` | session tree / new session |
| `prefix C-s` / `prefix C-r` | save / restore sessions now (also automatic, see below) |
| `prefix Enter`, then `v` / `C-v` / `y` | copy mode: select / rectangle / copy to the system clipboard (OSC 52, works over SSH) |
| `prefix C-l` | clear screen (plain `C-l` is pane navigation) |
| `prefix r` | reload config |
| `prefix I` / `prefix U` | install / update plugins |

**Sessions survive reboots.** [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) saves every 15 minutes
through [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect). The first `tmux` after a reboot restores
sessions, windows, splits, working dirs, pane contents and programs (nvim, ssh, lazygit, ...).
Saves go to `~/.local/share/tmux/resurrect/`. Autosave pauses while a second tmux server is running, so two
environments can't overwrite each other's saves.

Ghostty's own `ctrl+h/j/k/l` split navigation is `performable:`. Ghostty only takes the key
when it has a split in that direction, so in a single Ghostty pane the keys reach tmux and nvim.

## Claude Code in tmux

| Do | How |
|---|---|
| Claude in the current dir | `prefix a` → `n` |
| Parallel task, isolated | `cw <task>` in a shell, or `prefix a` → `w`. Opens window `cc:<task>` running `claude -w <task>`: its own git worktree in `.claude/worktrees/<task>` on branch `worktree-<task>` |
| Continue / pick an old conversation | `prefix a` → `c` / `r` |
| Find the Claude that needs you | `prefix a` → `j` (tree of windows that are waiting or done) |
| Background agents (`claude --bg`) | `prefix a` → `b` (`claude agents` view) |
| Newline in Claude's input | `Shift+Enter` |

**Status icons:** Claude Code hooks (`ai/claude/hooks/tmux-status.sh`, wired in `ai/claude/settings.json`) mark each window:
󰔟 working, 󰂚 waiting for you (permission or input), ✓ done. The yellow `󰂚 N` badge at the right of the
status bar counts the Claude windows waiting on you across **all** sessions, so nothing gets missed
in a session you're not looking at.

**After a reboot**, resurrect restarts each Claude as `claude --continue` in its pane's directory.
Every project and worktree resumes its own last conversation.

Rules of thumb:
- **Parallel edits:** one worktree per task (`cw`). Never run two Claudes editing the same checkout.
- **Read-only fan-out** (research, review, running tests): subagents inside one session. Cheaper, and their noise stays out of the main session's context.
- **Fire-and-forget:** `claude --bg "..."`, then check on it with `prefix a` → `b`.
- `claude -w` only works in a git repo you've already trusted (run plain `claude` there once). On exit Claude asks whether to keep the worktree.
- In Claude's input, `C-a` (start of line) is the tmux prefix, so press it twice.

## Public repo: what stays out

This repo is public. Secrets, personal details, work info, and per-machine setup stay out of it.
They go in local files that git never sees:

| Local file | Purpose |
|---|---|
| `~/.zshrc` | everything machine-specific in the shell |
| `~/.gitconfig.local` | git identity, credential helper, `includeIf` for other identities |
| `~/.tmux.local.conf` | machine-specific tmux overrides |
| `packages/Brewfile.local` | extra packages for one machine (gitignored) |
| `~/.config/dotfiles/blocklist` | words the leak check must reject |

**Leak check:** `.githooks/pre-commit` runs `scripts/check-leaks.sh` before every commit.
It looks for token/key patterns and private IPs, runs [gitleaks](https://github.com/gitleaks/gitleaks)
if installed, and matches against the private blocklist. Scan the whole repo with
`scripts/check-leaks.sh --all`.
