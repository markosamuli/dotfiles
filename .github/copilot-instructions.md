# Copilot Instructions

## Commands

- Set up development tools and Git hooks: `make setup-dev`. It requires `uv`
  and `shellcheck`, installs a compatible pre-commit 4.x release with
  `uv tool`, and installs `shfmt` with Go when absent.
- Run all configured checks: `make lint` (equivalent to `pre-commit run -a`).
- Run checks for changed files: `pre-commit run --files path/to/file`.
  Run one hook for a file with `pre-commit run <hook-id> --files path/to/file`;
  relevant IDs include `shellcheck`, `shfmt`, and `shell-config`.
- There is no build or automated test suite. The closest targeted validation
  for shell startup changes is syntax checking: `bash -n .bashrc` or
  `zsh -n .zshrc`.
- `make install` runs the machine installer. It creates/backs up home-directory
  symlinks and can install or configure system tools; do not use it as a
  routine validation command.

## Architecture

This is a modular dotfiles repository installed at `~/.dotfiles` and exposed
through symlinks such as `~/.bashrc`, `~/.zshrc`, and `~/.zprofile`.
`install.sh` owns those symlinks and machine setup; it also configures Git and
may install Homebrew, Zsh, Sheldon, GitHub CLI, and Vim.

The shell entry points discover module files from every immediate top-level
module directory:

- `.bashrc` loads `*/path.bash` first, then other `*.bash` files, then
  `*/completion.bash` after Bash completion is initialized.
- `.zshrc` follows the same phase order for `*.zsh`, initializes the selected
  plugin manager between path and general modules, and initializes `compinit`
  before completion modules. It selects Sheldon, Oh My Zsh, or Antibody from
  files already present in `$HOME`.
- `zsh/config.zsh` makes functions in `functions/` available through Zsh
  autoloading. User-specific extensions live in the `user/` modules, while
  `~/.localrc` is sourced last for unversioned local secrets.

Most tool directories therefore contain paired Bash and Zsh modules. Add PATH
changes in `path.bash`/`path.zsh`, completion setup in
`completion.bash`/`completion.zsh`, and all other integration in another
shell-specific module so it executes in the appropriate startup phase.

## Repository Conventions

- Preserve the dynamic module loading model rather than adding tool-specific
  initialization directly to `.bashrc` or `.zshrc`. The `shell-config`
  pre-commit hook rejects several direct PATH and version-manager initialization
  patterns in those two entry points.
- Guard optional tool integrations with availability or directory checks, as
  existing modules do, and use the `platform`, `platform_wsl`, and
  `platform_apple_silicon` variables established by the entry points for
  platform-specific behavior.
- Bash and Zsh are intentionally separate implementations. Do not source a
  Bash module from Zsh or vice versa.
- Use four-space indentation in shell modules. `shellcheck` and `shfmt` run on
  Bash files, while `*.zsh` is intentionally excluded from those hooks.
- Pre-commit also normalizes whitespace and validates JSON/YAML. Markdown
  trailing whitespace is preserved for hard line breaks.
- Changelog commit subjects use `new:`, `chg:`, or `fix:`, optionally followed
  by an audience such as `dev:`, `usr:`, `pkg:`, `test:`, or `doc:`.
