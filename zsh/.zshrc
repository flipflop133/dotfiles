#########
# ZINIT #
#########
# Installation
__ZINIT="$HOME/.zinit/bin/zinit.zsh"
__ZINIT_BIN=$(echo $__ZINIT |sed 's/zinit\.zsh//')

if [[ ! -f "$__ZINIT" ]]; then
	if (( $+commands[git] )); then
		print -P '%F{blue}Installing zinit...%f'
		git clone https://github.com/zdharma/zinit.git $__ZINIT_BIN
	else
		print -P '%F{red}git not found%f'
		exit 1
	fi
fi

source "$__ZINIT"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

###########
# GENERAL #
###########
# Aliases
source $HOME/aliases

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Enable colors
autoload -Uz colors && colors

# Change prompt
PS1=$'%(4~|%-1~/…/%3~|%~)\n%F{blue}\uf303%f '

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
	zdharma/fast-syntax-highlighting \
	blockf \
	zsh-users/zsh-completions \
	atload"!_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions

# colored-man-pages
zinit wait"1" lucid for \
	ael-code/zsh-colored-man-pages

#######
# NVM #
#######
# Set up Node Version Manager
source /usr/share/nvm/init-nvm.sh
