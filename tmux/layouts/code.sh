#!/usr/bin/env bash
# Code layout: 3 panes
# [ top-left        | right ]  70% height
# [ bottom-left     |       ]  30% height
#  70% width        | 30% width

tmux split-window -h -l 30% -c "#{pane_current_path}"      # split right pane off (30% width), focus moves to right
tmux select-pane -t 1                                      # back to left pane
tmux split-window -v -l 30% -c "#{pane_current_path}"      # split bottom-left off (30% height), focus moves to bottom-left
tmux select-pane -t 1                                      # return focus to top-left
tmux rename-window "CODE"
