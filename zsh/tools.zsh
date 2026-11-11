# Language / version managers. Each block only runs if the tool is installed.

# nvm (Node)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# SDKMAN (Java / Scala / Gradle)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# conda (miniconda3 or miniforge3). Same as `conda init`, but works for any home dir.
for _conda in "$HOME/miniconda3" "$HOME/miniforge3" /opt/homebrew/Caskroom/miniconda/base; do
  if [[ -x "$_conda/bin/conda" ]]; then
    if _hook="$("$_conda/bin/conda" shell.zsh hook 2>/dev/null)"; then
      eval "$_hook"
    elif [[ -f "$_conda/etc/profile.d/conda.sh" ]]; then
      source "$_conda/etc/profile.d/conda.sh"
    fi
    break
  fi
done
unset _conda _hook

# RVM (Ruby)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
