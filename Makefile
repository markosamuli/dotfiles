# Makefile for https://github.com/markosamuli/dotfiles

###
# Makefile configuration
###

.DEFAULT_GOAL := help

# We want our output silent by default, use VERBOSE=1 make <command> ...
# to get verbose output.
ifndef VERBOSE
.SILENT:
endif

###
# Define environment variables in the beginning of the file
###

CURL_BIN       = $(shell command -v curl 2>/dev/null)
GIT_BIN        = $(shell command -v git 2>/dev/null)
GO_BIN         = $(shell command -v go 2>/dev/null)
LUACHECK_BIN   = $(shell command -v luacheck 2>/dev/null)
PRE_COMMIT_BIN = $(shell pre-commit --version 2>&1 | head -1 | grep -q 'pre-commit [12]\.' && command -v pre-commit)
SHELLCHECK_BIN = $(shell command -v shellcheck 2>/dev/null)
SHFMT_BIN      = $(shell command -v shfmt 2>/dev/null)

###
# Define local variables after environment variables
###

# Paths to supported Git hooks
pre_commit_hooks = .git/hooks/pre-commit
pre_push_hooks 	 = .git/hooks/pre-push
commit_msg_hooks = .git/hooks/commit-msg
git_hooks = $(pre_commit_hooks) $(pre_push_hooks) $(commit_msg_hooks)

###
# Setup
###

.PHONY: setup
setup: setup-curl setup-git ## setup requirements for installing dotfiles

.PHONY: setup-dev
setup-dev: setup-lint setup-git-hooks  ## setup development requirements

###
# Setup: development requirements
###

.PHONY: setup-dev-requirements
setup-dev-requirements:
	pip install -q -r requirements.dev.txt

.PHONY: setup-lint
setup-lint: setup-pre-commit setup-shfmt setup-shellcheck setup-luacheck

.PHONY: setup-curl
setup-curl:
ifeq ($(CURL_BIN),)
	$(error "curl not found")
endif

.PHONY: setup-git
setup-git:
ifeq ($(GIT_BIN),)
	$(error "git not found")
endif

.PHONY: setup-golang
setup-golang:
ifeq ($(GO_BIN),)
	$(error "go not found")
endif

.PHONY: setup-luacheck
setup-luacheck:
ifeq ($(LUACHECK_BIN),)
	$(error "luacheck not found")
endif

.PHONY: setup-shellcheck
setup-shellcheck:
ifeq ($(SHELLCHECK_BIN),)
	$(error "shellcheck not found")
endif

.PHONY: setup-shfmt
setup-shfmt: setup-golang
ifeq ($(SHFMT_BIN),)
	go install mvdan.cc/sh/v3/cmd/shfmt@latest
endif

###
# Setup: pre-commit and Git hooks
###

.PHONY: setup-pre-commit
setup-pre-commit:
ifeq ($(PRE_COMMIT_BIN),)
	$(MAKE) setup-dev-requirements
endif

.PHONY: setup-git-hooks
setup-git-hooks: $(git_hooks)

$(pre_commit_hooks): | setup-pre-commit
	pre-commit install --install-hooks

$(pre_push_hooks): | setup-pre-commit
	pre-commit install --install-hooks -t pre-push

$(commit_msg_hooks): | setup-pre-commit
	pre-commit install --install-hooks -t commit-msg

###
# Linting and formatting
###

.PHONY: lint
lint: setup-lint ## run pre-commit hooks on all files
	pre-commit run -a

###
# Install
###

.PHONY: install
install:  ## install dotfiles
	./install.sh

###
# This Makefile uses self-documenting help commands
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
###

.PHONY: help
help:  ## print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -d | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
