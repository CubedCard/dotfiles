# --- history ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# --- completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# --- plugins ---
for f in /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
         "$(command -v brew >/dev/null && brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"; do
  [ -f "$f" ] && source "$f" && break
done
bindkey '^F' autosuggest-accept

# --- prompt ---
eval "$(starship init zsh)"

# --- fuzzy finder ---
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# --- languages ---
if [ -x /usr/libexec/java_home ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
elif [ -d /usr/lib/jvm/default ]; then
  export JAVA_HOME=/usr/lib/jvm/default
fi
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/3.1.0/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
if command -v brew >/dev/null; then
  [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && source "$(brew --prefix)/opt/nvm/nvm.sh"
  [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && source "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
fi

command -v pyenv &>/dev/null && eval "$(pyenv init -)"

export BROWSER=w3m

# --- colors ---
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# --- aliases ---
alias v='nvim'
alias vim='nvim'
alias wd="tmux neww -n 'master'; tmux neww -n 'detail'; tmux neww -n 'server'"
alias ks='tmux kill-server'
alias note="sh $HOME/Documents/coding/overig/notetaker/notetaker"
alias newlc="python3 $HOME/Documents/coding/overig/automations/leetcode/new_leetcode.py"
alias sortlc="python3 $HOME/Documents/coding/overig/automations/leetcode/leetcode_sorter.py"
alias sorter="$HOME/Documents/coding/overig/automations/notes/downloads_sorter.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

clear
fastfetch
