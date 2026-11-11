#!/usr/bin/env bash
# Run Claude Code on a task in its own git worktree: <repo>/.claude/worktrees/<task>, branch worktree-<task>.
# Used by `cw` (zsh/claude.zsh) and the tmux Claude menu (prefix a). On exit, Claude asks
# whether to keep or remove the worktree.
#
#   claude-task.sh <task-name> [extra claude args...]
#
# If claude fails (not a git repo, folder not trusted yet), the pane stays open so you can read why.

task="${1:-}"
if [[ ! "$task" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "usage: claude-task.sh <task-name> [claude args...]  (name: letters, digits, . _ -)" >&2
  read -r -p "Press Enter to close" _
  exit 1
fi
shift

claude -w "$task" -n "$task" "$@" && exit 0

echo
echo "claude -w failed. Usually: not inside a git repo, or this folder isn't trusted yet"
echo "(run plain 'claude' here once and accept the trust prompt)."
read -r -p "Press Enter to close" _
exit 1
