#!/usr/bin/env bash
# Claude Code hook: mirror the session's state onto its tmux window, so the status bar
# shows which Claude is working, waiting on you, or done. Wired up in ai/claude/settings.json.
#
#   tmux-status.sh busy     UserPromptSubmit, PostToolUse  (working)
#   tmux-status.sh waiting  Notification                   (needs permission / input)
#   tmux-status.sh done     Stop                           (finished, your turn)
#   tmux-status.sh clear    SessionEnd
#
# Sets the window option @claude_state, plus the global @claude_attention (number of windows
# in any session that are waiting or done, empty when 0) for the status-right badge.
# A no-op outside tmux. Never fails the hook.

[ -n "${TMUX_PANE:-}" ] && command -v tmux >/dev/null 2>&1 || exit 0
cat >/dev/null 2>&1   # drain the hook's JSON input

case "${1:-}" in
  busy|waiting|done) tmux set -w -t "$TMUX_PANE" @claude_state "$1" 2>/dev/null ;;
  clear)             tmux set -wu -t "$TMUX_PANE" @claude_state 2>/dev/null ;;
esac

n=$(tmux list-windows -a -F '#{@claude_state}' 2>/dev/null | grep -cE '^(waiting|done)$')
if [ "${n:-0}" -gt 0 ]; then tmux set -g @claude_attention "$n"; else tmux set -g @claude_attention ""; fi 2>/dev/null
exit 0
