# Makefile for https://github.com/markosamuli/dotfiles
#
# Self-documented help from:
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html


.PHONY: default
default: help

.PHONY: help
help:  ## print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install:  ## install dotfiles
	@./install.sh

PRE_COMMIT_INSTALLED = $(shell pre-commit --version 2>&1 | head -1 | grep -q 'pre-commit 1' && echo true)

.PHONY: setup-pre-commit
setup-pre-commit:
ifneq ($(PRE_COMMIT_INSTALLED),true)
	@pip install "pre-commit>=1.20.0,<2.0"
endif

.PHONY: lint
lint: setup-pre-commit  ## lint dotfiles using pre-commit hooks
	@pre-commit run -a -v

PRE_COMMIT_HOOKS = .git/hooks/pre-commit
PRE_PUSH_HOOKS = .git/hooks/pre-push
COMMIT_MSG_HOOKS = .git/hooks/commit-msg

.PHONY: install-git-hooks
install-git-hooks: $(PRE_COMMIT_HOOKS) $(PRE_PUSH_HOOKS) $(COMMIT_MSG_HOOKS)  ## install Git hooks

$(PRE_COMMIT_HOOKS): setup-pre-commit
	@pre-commit install --install-hooks

$(PRE_PUSH_HOOKS): setup-pre-commit
	@pre-commit install --install-hooks -t pre-push

$(COMMIT_MSG_HOOKS): setup-pre-commit
	@pre-commit install --install-hooks -t commit-msg
