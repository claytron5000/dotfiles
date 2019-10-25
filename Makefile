# Thanks https://github.com/jessfraz/dotfiles
.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;
	git update-index --skip-worktree $(CURDIR)/.gitconfig;

.PHONY: test
test: shellcheck

.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh

.PHONY: vscode_editor
vscode_editor: ## We'll have to do something clever for linux/windows environments. 
	# ln -f ./vscode/settings.json $(HOME)/Library/Application\ Support/Code/User/settings.json;
	./vscode/install_extensions.sh ./vscode/extensions.txt

.PHONY: python
python: ## install pyenv and python and pip
	curl https://pyenv.run | bash && \
	exec $(SHELL)
	command -v pyenv

.PHONY: nodejs
nodejs: ## install nvm and confirm
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash
	exec $(SHELL)
	command -v nvm
