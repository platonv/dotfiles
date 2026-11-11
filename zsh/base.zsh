# Shared zsh base. NOT linked as ~/.zshrc: each machine keeps its own ~/.zshrc
# and sources this at the top (see zsh/zshrc.template):
#
#   [[ -f "$HOME/dotfiles/zsh/base.zsh" ]] && source "$HOME/dotfiles/zsh/base.zsh"
#
# Load order: path.zsh → oh-my-zsh → tools.zsh (nvm, zoxide) → aliases.zsh → claude.zsh → starship.
# Anything specific to one machine (SDKMAN, conda, Rust, work stuff) goes in that
# machine's ~/.zshrc, after the source line.
#
# Optional knobs, set before the source line:
#   ZSH_EXTRA_PLUGINS=(docker kubectl)   extra oh-my-zsh plugins
#   DOTFILES_NO_STARSHIP=1               keep the oh-my-zsh theme instead of starship

# Repo root, worked out from this file's location so the clone can live anywhere.
export DOTFILES="${${(%):-%x}:A:h:h}"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"

source "$DOTFILES/zsh/path.zsh"

# ---------- oh-my-zsh ----------
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
_use_starship=0
if [[ -z "${DOTFILES_NO_STARSHIP:-}" ]] && command -v starship >/dev/null 2>&1; then
  _use_starship=1
  ZSH_THEME=""
else
  ZSH_THEME="${ZSH_THEME:-robbyrussell}"
fi

# Custom plugins are cloned by scripts/install/ohmyzsh.sh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use zsh-bat ${ZSH_EXTRA_PLUGINS[@]})

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

source "$DOTFILES/zsh/tools.zsh"
source "$DOTFILES/zsh/aliases.zsh"
source "$DOTFILES/zsh/claude.zsh"

# Config: starship/starship.toml, linked to ~/.config/starship.toml
(( _use_starship )) && eval "$(starship init zsh)"
unset _use_starship
