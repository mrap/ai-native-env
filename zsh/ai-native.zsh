# ai-native-env — base zsh module
# Sourced from a user's ~/.zshrc. Portable across machines and users.
# Personal config belongs in ~/.zshrc, around the source line.

# =====================
# Environment
# =====================
export SHELL=$(command -v zsh)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim
export XDG_CONFIG_HOME=~/.config
export PATH="/usr/local/bin:$PATH"

bindkey -v
# Shorter delay switching between insert/normal mode (default is 0.4s)
export KEYTIMEOUT=1
# Show current mode in prompt (optional)
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[2 q'  # block cursor for normal mode
  else
    echo -ne '\e[6 q'  # beam cursor for insert mode
  fi
}
zle -N zle-keymap-select

# =====================
# History
# =====================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# =====================
# Startup guard (stalled exec path)
# =====================
# Every optional tool init below execs a binary (nvm/npm, starship, brew, fzf,
# zoxide). If the OS exec path is stalled (macOS Gatekeeper assessment backlog,
# dead network mount), each of those execs can block for minutes and the shell
# never reaches a prompt. So: probe the first external tool with a deadline.
# If it does not answer in time, fall back to a plain prompt and skip the tool
# inits. Loud by design: one stderr line says what happened and how to reload
# (`ain-reload`) once the stall clears. Override the deadline with
# AIN_EXEC_DEADLINE (seconds, fractional ok); force with AIN_SAFE_MODE=1.
: "${AIN_EXEC_DEADLINE:=1.5}"
typeset -gi AIN_SAFE_MODE=${AIN_SAFE_MODE:-0}
typeset -g AIN_ZSH_FILE=${(%):-%x}
_ain_exec_answers() {
  # usage: _ain_exec_answers <deadline-seconds> <cmd> [args...]
  # 0 if the command makes progress within the deadline, 1 if it is still
  # wedged. No external `timeout`. The command runs via `exec` inside a coproc,
  # so the coproc pid IS the command: a kill reaches the real process instead
  # of orphaning it behind a shell wrapper (which is exactly the stuck-child
  # pile this guard exists to prevent). First output or clean exit within the
  # deadline = healthy; still alive at the deadline = wedged, so SIGKILL it.
  # The probe runs entirely inside a SUBSHELL, and that is load-bearing, not
  # style. An INTERACTIVE shell reports background jobs from its own job table,
  # so a coproc started in this function made every new shell print noise on
  # its way to the prompt:
  #   [5] 26696
  #   [5]  + done       { exec "$@" 2> /dev/null; } 2> /dev/null
  # Redirecting the command's stderr cannot suppress that (the notice is the
  # shell's, not the command's), and `unsetopt monitor` only hides the start
  # line: the `+ done` report is emitted later, at the next prompt, after any
  # function-local options have already been restored. Owning the job in a
  # subshell that exits immediately is what actually keeps it off the parent's
  # job table. With two call sites (the starship probe below and the
  # hex-completions probe in ~/.zshrc) the old behavior was four junk lines
  # before every prompt.
  # The subshell's exit status is the function's return value. coproc and kill
  # do not need MONITOR, so behavior is otherwise unchanged; killing from
  # inside the subshell still reaches the real process, because `exec` means
  # the coproc pid IS the command rather than a shell wrapper around it.
  (
    emulate -L zsh
    unsetopt monitor
    local deadline=$1; shift
    local line
    coproc { exec "$@" 2>/dev/null } 2>/dev/null
    local pid=$!
    # First output or clean exit within the deadline = healthy.
    read -t "$deadline" -p line 2>/dev/null && exit 0
    # Deadline hit with no output. If the process is still alive it is wedged in
    # the exec/assessment path, so kill it. The pid guard rejects an empty or
    # zero pid, which would otherwise signal our own process group.
    if [[ $pid == <1-> ]] && kill -0 "$pid" 2>/dev/null; then
      kill -KILL "$pid" 2>/dev/null
      exit 1
    fi
    exit 0
  )
}
_ain_startup_probe() {
  (( AIN_SAFE_MODE )) && return          # forced by the caller or environment
  [[ -n ${AIN_SKIP_PROBE:-} ]] && return  # ain-reload: trust the caller
  local tool=""
  for tool in starship zoxide fzf; do
    command -v "$tool" &>/dev/null && break
    tool=""
  done
  [[ -z $tool ]] && return                # nothing heavy to protect
  if ! _ain_exec_answers "$AIN_EXEC_DEADLINE" "$tool" --version; then
    AIN_SAFE_MODE=1
    print -u2 "ai-native: '$tool --version' did not answer within ${AIN_EXEC_DEADLINE}s (stalled exec path, e.g. macOS Gatekeeper backlog). Plain prompt; nvm/starship/fzf/zoxide init skipped. Run 'ain-reload' once it clears."
  fi
}
ain-reload() { AIN_SAFE_MODE=0 AIN_SKIP_PROBE=1 source "$AIN_ZSH_FILE"; }
_ain_startup_probe
if (( AIN_SAFE_MODE )); then
  PROMPT='%F{yellow}[safe]%f %F{cyan}%~%f %# '
fi

# =====================
# nvm
# =====================
export NVM_DIR="$HOME/.nvm"
if (( ! AIN_SAFE_MODE )); then
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi

# =====================
# Starship prompt
# =====================
if (( ! AIN_SAFE_MODE )) && command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# =====================
# fzf keybindings + history search
# =====================
if (( ! AIN_SAFE_MODE )) && command -v fzf &>/dev/null; then
  if [[ "$(uname)" == "Darwin" ]]; then
    _fzf_prefix="$(brew --prefix 2>/dev/null)/opt/fzf/shell"
  else
    _fzf_prefix="/usr/share/doc/fzf/examples"
  fi
  [ -f "$_fzf_prefix/key-bindings.zsh" ] && source "$_fzf_prefix/key-bindings.zsh"
  [ -f "$_fzf_prefix/completion.zsh" ] && source "$_fzf_prefix/completion.zsh"
  unset _fzf_prefix
  # Functional defaults only — no hardcoded palette (inherits your terminal theme).
  # Set a personal --color scheme in your own ~/.zshrc if you want one.
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi

# =====================
# Aliases — Git
# =====================
alias g="git"
alias gs="git status"
alias ga="git add -A"
alias gc="git commit -m"
alias gcm="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gl="git log --graph --decorate --all --max-count=30 --format='%C(auto)%h%d %s %C(dim)(%cr)%C(reset)'"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"

clonerepo() {
  local url="$1"
  if [ -z "$url" ]; then
    echo "Pass a GitHub URL to clone."
    return 0
  fi
  local owner repo dest
  owner=$(echo "$url" | sed -E "s|.*github\.com[:/]([^/]+)/.*|\1|")
  repo=$(echo "$url"  | sed -E "s|.*github\.com[:/][^/]+/([^/.]+).*|\1|")
  dest="$HOME/github.com/$owner/$repo"
  mkdir -p "$(dirname "$dest")"
  git clone "$url" "$dest" && cd "$dest"
}

# =====================
# Aliases — General
# =====================
# Don't alias `ls` itself — shadowing the system `ls` can break scripts on other machines.
alias lst="ls -t"
alias la="ls -A"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias df="df -h"
alias du="du -h"
alias ports="lsof -nP -iTCP -sTCP:LISTEN"  # portable (macOS + Linux); ss is Linux-only
alias vz='vim ~/.zshrc'
alias sz='source ~/.zshrc'

mkcd() { mkdir -p "$1" && cd "$1"; }

# =====================
# PATH
# =====================
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# =====================
# Secrets (API keys, tokens — never commit this file)
# =====================
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

alias vim="nvim"
alias vi="nvim"

alias claude='claude --dangerously-skip-permissions'
stty -ixon -ixoff 2>/dev/null

# =====================
# Homebrew (macOS, Apple Silicon)
# =====================
if [ -x /opt/homebrew/bin/brew ]; then
  if (( AIN_SAFE_MODE )); then
    # brew shellenv execs brew; in safe mode set the essential PATH statically.
    export HOMEBREW_PREFIX=/opt/homebrew
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  else
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# =====================
# zoxide (smart cd)
# =====================
if (( ! AIN_SAFE_MODE )) && command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# =====================
# bun
# =====================
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# =====================
# Completions
# =====================
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
fpath=("$HOME/.zfunc" $fpath)
autoload -U compinit && compinit
