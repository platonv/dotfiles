# Global instructions

These are the shared preferences in my public dotfiles repo (`~/dotfiles/ai/claude/CLAUDE.md`).
Private, machine-specific instructions live in
`~/.claude/CLAUDE.local.md`, imported at the bottom. That file is never committed.

## How I like to work

- Diagnose before fixing: confirm the root cause read-only, give me options, then act on the one I pick. No speculative "try this" fixes on live systems.
- I work across Ubuntu and macOS. Scripts and configs should run on both, or detect the OS explicitly.

## Dotfiles

- My configs live in `~/dotfiles` (public GitHub repo `platonv/dotfiles`), symlinked into place. See its `AGENTS.md` before editing.
- When you change a config that is symlinked from `~/dotfiles`, edit the repo file and offer to commit it.
- That repo is public: never put secrets, hostnames/IPs, or anything work-related in it.

@~/.claude/CLAUDE.local.md
