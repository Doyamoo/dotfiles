
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk



### PATH ##############################################

# homebrew
# https://brew.sh/index_ja
export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/sbin:$PATH"

# node.js
export PATH=$HOME/.nodebrew/current/bin:$PATH

# GO
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin



### Plugin ############################################

# Pure プロンプト
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# シンタックスハイライト
zinit ice wait lucid
zinit light zdharma/fast-syntax-highlighting

# 履歴補完
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# コマンド補完
zinit ice wait lucid
zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 小文字でも大文字にマッチさせる
zstyle ':completion:*:default' menu select=1        # TAB・矢印で選択する



### Peco ############################################

# ghqの補完
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="code ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^g^f' peco-src

# historyの補完
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# cdの補完
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^g^d' peco-cdr



### History ############################################

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000        # メモリに保存される履歴の件数
export SAVEHIST=100000      # 履歴ファイルに保存される履歴の件数

# 入力中の内容からhistoryを検索
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

setopt hist_ignore_all_dups # ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_space    # スペースで始まるコマンド行はヒストリリストから削除
setopt hist_verify          # ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_reduce_blanks   # 余分な空白は詰めて記録
setopt hist_no_store        # historyコマンドは履歴に登録しない
setopt hist_expand          # 補完時にヒストリを自動的に展開         
setopt inc_append_history   # 履歴をインクリメンタルに追加
setopt share_history        # 同時に起動しているzshの間でhistoryを共有する



### Alias ############################################

alias ls='ls -G'
alias ll='ls -alF'
alias la='ls -A'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gb='git branch'
alias gc='git checkout'
alias gf='git fetch'
alias gc='git commit'

alias d='cd ~/dev'
alias h='cd ~'

alias m='mkdir'
alias q='exit'
alias v='code'



######################################################

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
