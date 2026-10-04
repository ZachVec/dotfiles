#!/bin/sh
# fzf pane picker, run inside the popup that the C-. binding in tmux.conf
# opens.  The binding picks the branch: a window with 2 panes is handled there
# with select-pane, so this script only ever runs for windows with 3+ panes.
#
# The switch happens here rather than in the caller because a popup's command
# stdout never reaches the caller, only its exit status does.
#
# select-pane -Z carries the window's zoom state across the switch, so a zoomed
# window stays zoomed on the pane we land on.

set -u

TAB=$(printf '\t')

# The popup job keeps the pane the binding was pressed in as its target.
win=$(tmux display-message -p '#{window_id}')
cur=$(tmux display-message -p '#{pane_id}')

# The other panes of the window, as "<pane_id><TAB><pane_id> <command>".
pane_list() {
  tmux list-panes -t "$win" \
    -F "#{pane_id}${TAB}#{pane_current_command}" |
    awk -F "$TAB" -v cur="$cur" \
      '$1 != cur { printf "%s\t%s  %s\n", $1, $1, $2 }'
}

# Keep the popup open long enough for the message to be read.
if ! command -v fzf >/dev/null; then
  echo 'fzf not found in PATH'
  sleep 2
  exit 1
fi

pick=$(pane_list |
  fzf --delimiter="$TAB" --with-nth=2 --nth=2 \
    --no-sort --reverse --prompt='pane> ' \
    --preview='tmux capture-pane -ep -t {1}' \
    --preview-window='right:65%:wrap' |
  cut -f1)

[ -n "$pick" ] || exit 0
tmux select-pane -Z -t "$pick"
