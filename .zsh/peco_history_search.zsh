if which peco >/dev/null 2>&1; then

	peco-select-history() {
		local tac
		if which tac > /dev/null; then
			tac="tac"
		else
			tac="tail -r"
		fi
		BUFFER=$( \history -n 1 | eval $tac | peco --query "$LBUFFER" )
		CURSOR=$#BUFFER
		zle clear-screen
	}

	zle -N peco-select-history
	bindkey "^x^r" peco-select-history
	# bindkey "^r" peco-select-history
	# bindkey "^x^r" history-incremental-search-backward

fi
