# Shared aliases. Machine-specific ones go in that machine's ~/.zshrc.

# git (on top of the oh-my-zsh git plugin)
alias gco="git checkout"
alias gaa="git add ."
alias gps="git push"
alias gpl="git pull"
alias gs="git status -sb"
# Signed commit (GPG/SSH signature). Overrides oh-my-zsh's gcsm, which is --signoff
# (only adds a "Signed-off-by:" line). Needs user.signingkey in ~/.gitconfig.local.
alias gcsm="git commit --gpg-sign -m"

# dotfiles
alias dot='cd "$DOTFILES"'
alias dotup='git -C "$DOTFILES" pull --ff-only && "$DOTFILES/scripts/link.sh"'
