#!/bin/zsh

# KEY
	bindkey -e
	stty stop undef
	stty start undef
	bindkey '^]' copy-prev-shell-word
	bindkey '^Y' insert-last-word

# COMPLETION
	autoload -U compinit && compinit
	setopt extended_glob
	setopt correct
	setopt list_packed
	setopt auto_cd
	setopt auto_pushd
	zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z} r:|[-_.]=**'
	zstyle ':completion:*:(processes|jobs)' menu yes select=2

# HISTROY
	HISTFILE=~/.zsh_history
	HISTSIZE=65536
	SAVEHIST=65536
	setopt hist_ignore_dups
	setopt share_history
	setopt hist_ignore_space

# PROMPT
	setopt prompt_subst
    local prompt_newline=$'\n'
    local prompt_hbar=$'${(r:$(($COLUMNS-15))::_:)}'
    local prompt_status="%(?.%{%F{green}%}.%{%F{red}%})( %? )$prompt_hbar%f"
    local prompt_date="%{%F{white}%}%D{%H:%M}%{%f%}"
    PROMPT="${prompt_status}${prompt_date}${prompt_newline}%{%F{green}%}%(!.#.$)%{%f%} "
	RPROMPT="%{%F{green}%}%3~%{%f%} [%{%B%F{magenta}%}%n%{%f%b%}@%{%F{magenta}%}%m%{%f%}]"

	if [ -e ~/.dir_colors ]; then
		eval `dircolors ~/.dir_colors`
	fi

# ALIAS
	alias ls='ls --color=auto'
	alias mv='mv -i'
	alias rm='rm -i'

	alias -s txt='less'
	alias -s pdf='evince'
	alias -s py='python'
	alias -s rb='ruby'
	alias -s go='go run'
	alias -s txt='less'
	alias -s {bmp,eps,gif,jpg,jpeg,png,ps}='display'

	alias Glog='git log --graph --decorate --oneline --all --color'

	alias Pcd='target_dir=`pwd`; while [ ! -z $target_dir ]; do cd $target_dir; target_dir=$(echo ".." | cat - =(find -L . -maxdepth 1 -type d -name "[^.]*" -printf "%f\n" | sort) =(find -L . -maxdepth 1 -type d -name ".*" -printf "%f\n" | sort) | peco); done'
    alias Pghq='cd $(ghq root)/$(ghq list | peco)'

	autoload -Uz zmv
	alias Zmv='noglob zmv -W'
	alias Zcp='noglob zmv -W -C'
	alias Zln='noglob zmv -W -L'

# EXTERNAL SCRIPT
    if [ -e $HOME/.zsh ]; then
        for f in $HOME/.zsh/*; do
            source $f
        done
    fi
