#########
# ZINIT #
#########
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

###########
# GENERAL #
###########
# configure zsh histroy
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# set default sudoeditor
export SUDO_EDITOR=/usr/bin/nvim

# set nvim as default
export EDITOR=nvim

# Share history with other terminals
setopt share_history

# Don't show duplicated history
setopt histignorealldups

###########
# PLUGINS #
###########
# fzf-tab
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#4d4d4c,bg:-1,hl:#d7005f
    --color=fg+:#4d4d4c,bg+:-1,hl+:#d7005f
    --color=info:#4271ae,prompt:#8959a8,pointer:#d7005f
    --color=marker:#4271ae,spinner:#4271ae,header:#4271ae'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:(cat|nvim):*' fzf-preview 'cat -b $realpath'
zinit light Aloxaf/fzf-tab

# zsh-completion
zinit light zsh-users/zsh-completions

# zsh-autosuggestions
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# zsh-syntax-highlighting
zinit light zsh-users/zsh-syntax-highlighting

# Speeding up Zsh startup
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k 
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

###########
# ALIASES #
###########
alias n='nnn -e'
alias ud='sudo pacman -Syyu' # UpDate
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias pacman='pacman --color=auto'
alias yay='yay --color=auto'
alias vi='nvim'
alias cl='clear'
alias nf='clear; neofetch'
alias q='python ~/.config/pythons-scripts/daily_quote/daily_quote.py | lolcat -p 1.5 -a -d 3'
alias top='bpytop'
alias xrp='python ~/.config/crypto-script/crypto.py'
