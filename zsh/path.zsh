# PATH setup. Sourced first by zshrc.
# `typeset -U` drops duplicates, so re-adding an entry (e.g. from ~/.profile) is harmless.
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
  "$HOME/.opencode/bin"
  "$HOME/.tfenv/bin"
  /usr/local/bin
  $path
  "$HOME/.local/share/coursier/bin"
  "$HOME/.rvm/bin"
)

# Go: prefer a manually unpacked toolchain (~/go-<version>/go) if present, newest first.
_go_dirs=("$HOME"/go-*/go/bin(N-/On))
(( ${#_go_dirs} )) && path=("${_go_dirs[1]}" $path)
unset _go_dirs

# Android SDK (Linux: ~/Android/Sdk, macOS: ~/Library/Android/sdk)
for _sdk in "$HOME/Android/Sdk" "$HOME/Library/Android/sdk"; do
  if [[ -d "$_sdk" ]]; then
    export ANDROID_HOME="$_sdk"
    path+=("$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools")
    break
  fi
done
unset _sdk

# Drop entries that don't exist on this machine.
path=($^path(N-/))
