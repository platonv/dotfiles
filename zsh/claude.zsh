# Claude Code helpers. Sourced by base.zsh. See README "Claude Code in tmux".

# cw <task> [claude args...]: start Claude on <task> in its own git worktree.
# Inside tmux it opens a new window named "cc:<task>" in the current session, so its status icon
# shows up in the status bar. Outside tmux it runs in the current terminal.
cw() {
  if [[ -z "$1" ]]; then
    echo "usage: cw <task-name> [claude args...]" >&2
    return 1
  fi
  if [[ -n "$TMUX" ]]; then
    tmux new-window -n "cc:$1" -c "$PWD" "$DOTFILES/tmux/claude-task.sh" "$@"
  else
    "$DOTFILES/tmux/claude-task.sh" "$@"
  fi
}
