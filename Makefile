.PHONY: all
all: install deploy

.PHONY: environment
environment: .zprofile
	./update .zprofile ${HOME}/.zprofile

.PHONY: install
install: environment
	zsh -c "source ${HOME}/.zprofile && ( \
		go get github.com/motemen/ghq; \
		go get github.com/peco/peco; \
		mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim; \
		git clone https://github.com/Shougo/dein.vim.git ~/.vim/dein/repos/github.com/Shougo/dein.vim || :; \
		mkdir \$${XDG_CONFIG_HOME}/nvim || :; \
		ln -s ~/.vim \$${XDG_CONFIG_HOME}/nvim || :; \
		ln -s ~/.vimrc \$${XDG_CONFIG_HOME}/nvim/init.vim || :; \
		)"

.PHONY: deploy
deploy: .zshrc environment
	zsh -c "source ${HOME}/.zprofile && ( \
		./update .zsh \$${HOME}/.zsh; \
		./update .zshrc \$${HOME}/.zshrc; \
		./update .xinitrc \$${HOME}/.xinitrc; \
		./update .xmobarrc \$${HOME}/.xmobarrc; \
		[ -e \$${HOME}/.xmonad ] || mkdir \$${HOME}/.xmonad; \
		./update xmonad.hs \$${HOME}/.xmonad/; \
		./update .vimrc \$${HOME}/.vimrc; \
		./update .vim \$${HOME}/.vim; \
		)"
