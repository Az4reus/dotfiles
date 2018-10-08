#!/usr/bin/bash
# Set up standard tmux sessions that I tend to need.

set -e

SESSION_NAME="work"
MAIN_WINDOW_NAME="command-central"

if ! (tmux has-session -t $SESSION_NAME 2>/dev/null); then
  tmux new -d -s $SESSION_NAME -c "$HOME"
  tmux new-window -t $SESSION_NAME:2 -n $MAIN_WINDOW_NAME -c $HOME arrive
  tmux split-window -t $SESSION_NAME:2 -h
  tmux new-window -t $SESSION_NAME:3 -n localdev -c "$HOME/work/docker-localdev"
  tmux kill-window -t $SESSION_NAME:1
  tmux select-window -t $SESSION_NAME:$MAIN_WINDOW_NAME.0

  tmux attach -t $SESSION_NAME
fi
