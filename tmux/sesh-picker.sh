#!/usr/bin/env bash
# sesh session picker with fzf
# Enter = connect to selected session via sesh
# ctrl-n = create new bare tmux session from typed query
choice=$(sesh list --icons | fzf-tmux -p 55%,60% \
  --no-sort --ansi \
  --border-label ' sesh ' --prompt '⚡  ' \
  --header '  ^a all  ^t tmux  ^g config  ^x zoxide  ^d tmux kill  ^f find  ^n new' \
  --bind 'tab:down,btab:up' \
  --bind "ctrl-n:become(echo NEW:{q})" \
  --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
  --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
  --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
  --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
  --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
  --bind 'ctrl-d:execute(tmux kill-session -t {2..})+reload(sesh list --icons)')

if [[ "$choice" == NEW:* ]]; then
  name="${choice#NEW:}"
  [[ -n "$name" ]] && tmux new-session -d -s "$name" && tmux switch-client -t "$name"
elif [[ -n "$choice" ]]; then
  sesh connect "$choice"
fi
