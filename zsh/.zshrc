#########
# ZINIT #
#########
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

# Default sudoeditor
export SUDO_EDITOR=/usr/bin/nvim

# Default editor
export EDITOR=nvim

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=1200000
SAVEHIST=1000000

# Enable colors and change prompt
autoload -U colors && colors
PS1=$'%(4~|%-1~/…/%3~|%~)\n%F{blue}❯%f '
setopt interactive_comments
setopt noflowcontrol

# Completion configuration
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu yes select

# Fuzzy find history forward/backward
autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# load cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 25

# Go easily to previously visited directories
function fzf-cdr () {
	local dir=$(cdr -l | awk '{print $2}' | fzf -q "${LBUFFER}")
	if [ -n "${dir}" ]; then
		BUFFER="cd ${dir}"
		zle accept-line
	fi
	zle reset-prompt
}
zle -N fzf-cdr
bindkey '^g' fzf-cdr

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
# NNN #
#######
if command -v nnn > /dev/null; then
	source $HOME/.config/nnn/config.nnn
	bindkey -s '^N' 'n\n'
fi

#######
# NVM #
#######
# Set up Node Version Manager
source /usr/share/nvm/init-nvm.sh
