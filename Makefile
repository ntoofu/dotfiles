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
		)"

.PHONY: deploy
deploy: .zshrc environment
	zsh -c "source ${HOME}/.zprofile && ( \
		./update .zsh \$${HOME}/.zsh; \
		./update .zshrc \$${HOME}/.zshrc; \
		./update .xinitrc \$${HOME}/.xinitrc; \
		./update .xmobarrc \$${HOME}/.xmobarrc; \
		[ -e \$${HOME}/.xmonad ] || mkdir \$${HOME}/.xmonad; \
		cp -i xmonad.hs \$${HOME}/.xmonad/; \
		)"
