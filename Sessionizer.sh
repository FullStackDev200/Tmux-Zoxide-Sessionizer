#!/usr/bin/env bash

has_session() {
  tmux list-sessions | grep -q "^$1:"
}

is_tmux_running() {
  tmux_running=$(pgrep tmux)

  if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    return 1
  fi
  return 0
}

selected_project=$(zoxide query -l | fzf)
selected_name=$(basename "$selected_project" | tr . _)


if ! is_tmux_running; then
  echo "Error: tmux is not running.  Please start tmux first before using session commands."
  exit 1
fi

if ! has_session "$selected_name"; then
  tmux new-session -d -c "$selected_project" -s "$selected_name"
fi

if [[ $selected_project ]]; then
  tmux switch-client -t "$selected_name"
fi
