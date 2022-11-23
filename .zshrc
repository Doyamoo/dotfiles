
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

# node.js
export PATH=$HOME/.nodebrew/current/bin:$PATH



### Plugin ############################################

# シンタックスハイライト
zinit light zdharma/fast-syntax-highlighting

## 履歴補完
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

## コマンド補完
zinit ice wait'0'; zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit
## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1 

# コマンド履歴 ctrl+r
zinit light zdharma/history-search-multi-word



### History ############################################

# history search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks 

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 補完時にヒストリを自動的に展開         
setopt hist_expand

# 履歴をインクリメンタルに追加
setopt inc_append_history

# 同時に起動しているzshの間でhistoryを共有する
setopt share_history




### alias ############################################

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




### sharship #########################################

# https://starship.rs/ja-JP/
# https://starship.rs/ja-JP/presets/plain-text.html
eval "$(starship init zsh)"

autoload -U +X bashcompinit && bashcompinit
# terraform
complete -o nospace -C /opt/homebrew/bin/terraform terraform
