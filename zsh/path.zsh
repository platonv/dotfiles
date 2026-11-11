# PATH entries every machine shares. Sourced by base.zsh.
# Machine-specific dirs (Android SDK, pinned toolchains, ...) go in that machine's ~/.zshrc.
# `typeset -U` drops duplicates, so the machine's ~/.zshrc can re-add entries safely.
typeset -U path PATH

# Homebrew: macOS (Apple Silicon / Intel) or Linuxbrew
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew "$HOME/.linuxbrew/bin/brew" /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x "$_brew" ]]; then eval "$("$_brew" shellenv)"; break; fi
done
unset _brew

path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/go/bin"
  /usr/local/bin
  $path
)

# Drop entries that don't exist on this machine. `-/` follows symlinks (/bin -> /usr/bin).
path=($^path(N-/))
