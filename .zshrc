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
    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "%F{yellow}C"
    zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}S"
    zstyle ':vcs_info:*' formats "%F{blue}%c%u[%b]%f"
    zstyle ':vcs_info:*' actionformats '[%b|%a]'
    function precmd_ps1() {
        local last_status="($?)"
        local time_str=$(date +%T)
        local padlen=$(( $COLUMNS - ${#last_status} - ${#time_str} ))
        local padding=$(printf "%.1s" "-"{1..$padlen})
        [ $? -eq 0 ] && local color=32 || local color=31
        echo -e "\e[${color}m${last_status}${padding}\e[m${time_str}"
    }
    function precmd_update_vcs_info () {
        vcs_info
    }
    add-zsh-hook precmd precmd_ps1
    add-zsh-hook precmd precmd_update_vcs_info
    local prompt_newline=$'\n'
    local user_info_msg="[%{%B%F{magenta}%}%n%{%f%b%}@%{%F{magenta}%}%m%{%f%}]"
    local dir_info_msg="%{%F{green}%}%3~%{%f%}"
    local prompt_mark="%{%F{white}%}%(!.#.$)%{%f%} "
    PROMPT="$user_info_msg $dir_info_msg \${vcs_info_msg_0_}$prompt_newline$prompt_mark"

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
