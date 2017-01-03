setopt extended_glob

typeset -A abbreviations

abbreviations=(
	"Il"	"| ${PAGER}"
	"Ip"	"| peco"
	"IP"	"| perl -anle"
	"Ih"	"| head"
	"It"	"| tail"
	"Ig"	"| grep"
	"Ix"	"| xargs"
)

magic-abbrev-expand() {
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
	zle self-insert
}

no-magic-abbrev-expand() {
	LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand
bindkey -M isearch " " self-insert
