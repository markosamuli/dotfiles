# AGENTS.md

Working rules for this repository, for any coding agent. [`README.md`](README.md)
describes what the repository is and how to install it; this file covers how to
change it.

**This repository is public.** Everything committed here is world-readable,
including commit messages. That constrains more than it first appears — see
[Disclosure and commit messages](#disclosure-and-commit-messages).

## Commands

- Set up development tools and Git hooks: `make setup-dev`. It requires `uv`
  and `shellcheck`, installs a compatible pre-commit 4.x release with
  `uv tool`, and installs `shfmt` with Go when absent.
- Run all configured checks: `make lint` (equivalent to `pre-commit run -a`).
- Run checks for changed files: `pre-commit run --files path/to/file`.
  Run one hook for a file with `pre-commit run <hook-id> --files path/to/file`;
  relevant IDs include `shellcheck`, `shfmt`, and `shell-config`.
- There is no build and no automated test suite. The closest targeted
  validation for shell startup changes is a syntax check: `bash -n .bashrc` or
  `zsh -n .zshrc`.
- `make install` runs the machine installer. It creates and backs up
  home-directory symlinks and can install or configure system tools. **Do not
  use it as a routine validation command** — it changes the machine, not just
  the checkout.

## Architecture

A modular dotfiles repository installed at `~/.dotfiles` and exposed through
symlinks such as `~/.bashrc`, `~/.zshrc` and `~/.zprofile`. `install.sh` owns
those symlinks and machine setup; it also configures Git and may install
Homebrew, Zsh, Sheldon, GitHub CLI and Vim.

The shell entry points discover module files from every immediate top-level
module directory:

- `.bashrc` loads `*/path.bash` first, then other `*.bash` files, then
  `*/completion.bash` once Bash completion is initialised.
- `.zshrc` follows the same phase order for `*.zsh`, initialises the selected
  plugin manager between the path and general phases, and runs `compinit`
  before completion modules. It selects Sheldon, Oh My Zsh or Antibody from
  files already present in `$HOME`.
- `zsh/config.zsh` makes functions in `functions/` available through Zsh
  autoloading. User-specific extensions live in the `user/` modules, and
  `~/.localrc` is sourced last for unversioned local secrets.

Most tool directories therefore contain paired Bash and Zsh modules. Put PATH
changes in `path.bash`/`path.zsh`, completion setup in
`completion.bash`/`completion.zsh`, and every other integration in another
shell-specific module, so each runs in the right startup phase.

## Shell conventions

- **Preserve the dynamic module loading model.** Do not add tool-specific
  initialisation directly to `.bashrc` or `.zshrc`. The `shell-config`
  pre-commit hook rejects several direct PATH and version-manager
  initialisation patterns in those two entry points.
- Guard optional tool integrations with availability or directory checks, as
  existing modules do, and use the `platform`, `platform_wsl` and
  `platform_apple_silicon` variables the entry points establish.
- **Bash and Zsh are deliberately separate implementations.** Never source a
  Bash module from Zsh or the reverse.
- Four-space indentation in shell modules. `shellcheck` and `shfmt` run on Bash
  files; `*.zsh` is intentionally excluded from both.
- Pre-commit also normalises whitespace and validates JSON and YAML. Markdown
  trailing whitespace is preserved, because it encodes hard line breaks.

## Two ignore files, and which one a rule belongs in

This repository contains both, and putting a rule in the wrong one is a mistake
that looks like it worked.

- **`.gitignore`** governs *this repository's own checkout*. It travels with
  every clone and fork.
- **`.gitignore_global`** is a dotfile this repository *ships*. `install.sh`
  symlinks it to `~/.gitignore_global`, where it governs every other repository
  on a machine that has run the installer.

**A rule protecting this repository belongs in `.gitignore`, even when the
global file already covers it.** A global ignore protects one machine after
installation; it does nothing for a fresh clone, for the fork, or for a
contributor. PR #13 is the worked example: it added
`**/.claude/settings.local.json` to `.gitignore_global` — correct for the
machine, and no protection at all for this repository, which is why `.gitignore`
had to gain the same rule later.

The reverse also holds: a pattern that should apply to *all* of Marko's
repositories belongs in `.gitignore_global`, not here.

## Commit messages

**Conventional Commits.** `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`,
`style:`, optionally scoped. This reflects existing practice rather than
changing it — the recent history is overwhelmingly Conventional.

Older documentation described `new:`/`chg:`/`fix:` subjects for `gitchangelog`.
That scheme is not in use: no changelog is generated from this repository.
Do not reintroduce it.

Explain *why* in the body, not just what. A commit that moves a rule from one
file to another should say what the old placement failed to cover.

## Disclosure and commit messages

**AI assistance is disclosed, and that is deliberate.** An agent-assisted commit
carries a co-authorship trailer naming the tool:

```text
Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
```

The harness emits the **active model name**, so the exact string varies between
sessions and may carry a context-window suffix such as
`Claude Opus 5 (1M context)`. There is no setting to shorten it. **Do not
hand-edit the trailer to match a canonical form** — the emitted string is the
accurate one, and a rewritten trailer records a session that did not happen.

Naming the tool is what every published disclosure norm asks for. The
`Assisted-by:` trailer that the Linux kernel and LLVM prefer is the
better-argued form, but this harness cannot emit it, and a trailer that depends
on being remembered by hand every time will drift — there is no commit-msg hook
here to catch it.

GitHub sets `Co-authored-by: Copilot <…>` server-side on Copilot-assisted
commits. That is expected and stays. The lower-case spelling is GitHub's; Git
matches trailer names case-insensitively, so it is not worth normalising.

**Do not add session-transcript URLs.** No publication norm asks for one, only
its author can open it, and public git history is effectively permanent while a
provider's access policy is not.

**Do not add a "Generated with" footer.** It appears nowhere in this
repository's history, and where it turns up elsewhere it reads as an unmodified
default rather than a decision.

**Read what a commit message discloses before writing it.** This repository is
public, so absolute machine paths, hostnames, employer or client names, the
names of private repositories, and the contents of `~/.localrc` or any other
unversioned local file do not belong in one. Describe the change instead of
pasting the environment it happened in.

## Landing changes

**Changes land through a pull request**; `master` is the default branch. Open
one with `gh pr create` and let Marko merge it.

Two facts about review state here, because the obvious queries mislead:

- For a pull request authored by the current user, `reviewDecision` is not a
  substitute for inspecting reviews: self-approval is forbidden, but another
  reviewer can still set the decision.
- An approval appears in a **review's state**, not necessarily its body;
  `gh pr view <n> --json comments,reviews` lets you inspect both.

There is no CI in this repository — no `.github/workflows/` — so pre-commit is
the only gate. Run `make lint` before opening a pull request; nothing else will.

**`make lint` currently fails on `master`, and has for some time.** The
`shell-config` hook flags one commented-out line in each entry point:

```text
.bashrc:147:# eval "$(pyenv init -)"
.zshrc:118:# eval "$(pyenv init -)"
```

Both date to `6b7963c` (April 2022). The hook matches the pattern without
noticing that the line is commented out, so nothing is actually initialising
pyenv there. **Do not take this as a failure you introduced**, and do not
"fix" it by deleting the comments without deciding whether the hook or the
comment is wrong. Check that your own files are clean instead:

```sh
pre-commit run --files <the files you changed>
```

## Where work gets tracked

**GitHub issues on this repository.** Filing is Marko's decision, not a side
effect of finishing something: describe what you found and let him choose.
Never open one issue per pull request — the pull request already records what
changed and why.
