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
# nvm
# =====================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# =====================
# Starship prompt
# =====================
command -v starship &>/dev/null && eval "$(starship init zsh)"

# =====================
# fzf keybindings + history search
# =====================
if command -v fzf &>/dev/null; then
  if [[ "$(uname)" == "Darwin" ]]; then
    _fzf_prefix="$(brew --prefix 2>/dev/null)/opt/fzf/shell"
  else
    _fzf_prefix="/usr/share/doc/fzf/examples"
  fi
  [ -f "$_fzf_prefix/key-bindings.zsh" ] && source "$_fzf_prefix/key-bindings.zsh"
  [ -f "$_fzf_prefix/completion.zsh" ] && source "$_fzf_prefix/completion.zsh"
  unset _fzf_prefix
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border \
    --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
    --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
    --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
    --color=selected-bg:#BCC0CC \
    --color=border:#9CA0B0,label:#4C4F69"
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
alias ports="ss -tulanp"
alias vz='vim ~/.zshrc'
alias sz='source ~/.zshrc'

mkcd() { mkdir -p "$1" && cd "$1"; }

# =====================
# Aliases — Docker
# =====================
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias dcp="docker compose pull"

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
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# =====================
# zoxide (smart cd)
# =====================
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# =====================
# bun
# =====================
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# =====================
# agent-browser (Vercel)
# =====================
export AGENT_BROWSER_DEFAULT_TIMEOUT=30000
# Launch Chrome with CDP for agent-browser auto-connect (macOS only)
[[ "$(uname)" == "Darwin" ]] && \
  alias chrome-debug='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 &'

# =====================
# Completions
# =====================
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
fpath=("$HOME/.zfunc" $fpath)
autoload -U compinit && compinit
