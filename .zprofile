#!/bin/zsh

# This file is called when you login.login

# Set environment variables
export LANG=${LANG:=en_US}
export WORDCHARS='*?_-+.[]~=&!#$%^(){}<>'

export EDITOR=vim
export PAGER=less

export GOPATH=$HOME/work
export PATH=$PATH:$GOPATH/bin
export XDG_CONFIG_HOME=$HOME/.config

# Load ~/.zshrc
if [ -f ~/.zshrc ]; then
	. ~/.zshrc
fi

