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

###########
# GENERAL #
###########
# Aliases
source $HOME/.aliases

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Navigate to beginning or end of line
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

# Enable colors
autoload -Uz colors && colors

# Change prompt
PS1=$'%(4~|%-1~/…/%3~|%~)\n%F{blue}> '

# Completion configuration
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu yes select

# Fuzzy find history forward/backward
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

#################
# ZINIT PLUGINS #
#################
# syntax-highlighting
# zsh-completions
# zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
zinit wait lucid for \
	atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
	zdharma-continuum/fast-syntax-highlighting \
	blockf \
	zsh-users/zsh-completions \
	atload"!_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions

# colored-man-pages
zinit wait"1" lucid for \
	ael-code/zsh-colored-man-pages
