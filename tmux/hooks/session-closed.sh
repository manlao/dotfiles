#!/usr/bin/env bash

if ! tmux ls -F "#{session_name}" | grep "Apple" 1>/dev/null 2>&1; then
  osascript -e 'tell application "Terminal" to quit'
fi
