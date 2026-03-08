#!/usr/bin/env bash

# Ops layout: 4 panes
# [  top-left  |  top-right  ]  70% height
# [ btm-left | btm-right     ]  30% height
#        38% | 62%  (bottom row)

tmux split-window -v -l 30% -c "#{pane_current_path}"      # split bottom row off (30% height), focus moves to bottom
tmux split-window -h -l 62% -c "#{pane_current_path}"      # split bottom row: left=38%, right=62%, focus on right
tmux select-pane -t 1                                      # back to top pane
tmux split-window -h -l 50% -c "#{pane_current_path}"      # split top row 50/50, focus on right
tmux select-pane -t 1                                      # return focus to top-left
tmux rename-window "OPS"
