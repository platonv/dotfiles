# Version managers every machine gets (installed by ./install.sh shell). Sourced by base.zsh.
# Optional ones (SDKMAN, Rust, conda, ...) are set up by their own installer in
# scripts/install/ and live in that machine's ~/.zshrc or ~/.zshenv.

# nvm (Node)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# zoxide: `z foo` jumps to the best match for "foo", `zi` picks interactively with fzf.
# Must run after compinit, which oh-my-zsh does before this file is sourced.
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
