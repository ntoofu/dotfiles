.PHONY: all
all: install deploy

.PHONY: environment
environment: .zprofile
	sh ./update .zprofile ${HOME}/.zprofile

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
		sh ./update .zsh \$${HOME}/.zsh; \
		sh ./update .zshrc \$${HOME}/.zshrc; \
		sh ./update .xinitrc \$${HOME}/.xinitrc; \
		sh ./update .xmobarrc \$${HOME}/.xmobarrc; \
		[ -e \$${HOME}/.xmonad ] || mkdir \$${HOME}/.xmonad; \
		sh ./update xmonad.hs \$${HOME}/.xmonad/; \
		sh ./update .vimrc \$${HOME}/.vimrc; \
		sh ./update .vim \$${HOME}/.vim; \
		)"
