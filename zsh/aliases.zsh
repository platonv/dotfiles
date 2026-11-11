# Aliases. Put machine-specific ones in ~/.zshrc.local instead.

# git (on top of the oh-my-zsh git plugin)
alias gco="git checkout"
alias gaa="git add ."
alias gps="git push"
alias gpl="git pull"
alias gs="git status -sb"

# dotfiles
alias dot='cd "$DOTFILES"'
alias dotup='git -C "$DOTFILES" pull --ff-only && "$DOTFILES/scripts/link.sh"'
