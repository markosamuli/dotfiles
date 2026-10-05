# AGENTS.md

Working rules for this repository, for any coding agent. [`README.md`](README.md)
describes what the repository is and how to install it; this file covers how to
change it.

**This repository is public.** Everything committed here is world-readable,
including commit messages. That constrains more than it first appears — see
[What must never land here](#what-must-never-land-here) and
[Disclosure and commit messages](#disclosure-and-commit-messages).

## Commands

- Set up development tools and Git hooks: `make setup-dev`. It requires `uv`
  and `shellcheck`, installs a compatible pre-commit 4.x release with
  `uv tool`, and installs `shfmt` with Go when absent.
- Run all configured checks: `pre-commit run -a`. `make lint` runs the same
  hooks, but first runs `setup-lint`, which may install pre-commit with `uv`
  and `shfmt` with `go` — so it is setup plus check, not a pure check.
- Run checks for changed files: `pre-commit run --files path/to/file`.
  Run one hook for a file with `pre-commit run <hook-id> --files path/to/file`;
  relevant IDs include `shellcheck`, `shfmt`, and `shell-config`.
- Check that every shell still starts cleanly: `make check-startup`. It runs
  `zsh -il`, `bash -i` and `sh .profile` from this checkout against a
  throwaway `HOME` with a cleared environment. It fails if an entry point
  (`.bashrc`, `.zshrc`, `.zshenv`, `.zprofile`, `.profile`) is missing or
  empty, if startup exits non-zero or writes anything to stderr beyond the
  shell's own no-terminal messages, or if bash or zsh finish without the
  `dotfiles` alias that the `dotfiles/` module defines — proof the modules
  were loaded, not just that nothing complained. A missing bash is a hard
  failure; a missing zsh skips the zsh check with a `SKIP` line, so read the
  output rather than trusting the exit status on a machine without zsh. It
  runs once with only the system `PATH` and once with Homebrew's `bin` added.
  **Run it after any change to an entry point or a module.**
- What `check-startup` cannot see: most modules guard on a tool or a file
  under `$HOME`, and stay inert in an empty `HOME`. It proves the entry points
  and every unguarded line run cleanly, not that a given tool integration
  works. For that, open a new shell on a real machine.
- There is no build and no test suite beyond that. A syntax check —
  `bash -n .bashrc` or `zsh -n .zshrc` — is quicker but proves only that the
  files parse.
- `make install` runs the machine installer. It creates and backs up
  home-directory symlinks and can install or configure system tools. **Do not
  use it as a routine validation command** — it changes the machine, not just
  the checkout. When `install.sh` changes what it modifies on a machine, update
  the "What could go wrong" section of `README.md` to match.

## Architecture

A modular dotfiles repository installed at `~/.dotfiles` and exposed through
symlinks such as `~/.bashrc`, `~/.zshrc` and `~/.zprofile`. `install.sh` owns
those symlinks and machine setup; it also configures Git and may install
Homebrew, Zsh, Sheldon, GitHub CLI and Vim.

The shell entry points discover module files from every immediate top-level
module directory:

- `.bashrc` loads `*/path.bash` first, then other `*.bash` files, then
  `*/completion.bash` once Bash completion is initialised.
- `.zshrc` follows the same phase order for `*.zsh`, runs `sheldon source`
  between the path and general phases when a Sheldon `plugins.toml` exists
  in `$HOME`, and runs `compinit` before completion modules. Sheldon is the
  only supported plugin manager; without its config, zsh starts with no
  plugins.
- User-specific extensions live in the `user/` modules, and `~/.localrc` is
  sourced last for unversioned local secrets.

Most tool directories therefore contain paired Bash and Zsh modules. Put PATH
changes in `path.bash`/`path.zsh`, completion setup in
`completion.bash`/`completion.zsh`, and every other integration in another
shell-specific module, so each runs in the right startup phase.

The other entry points run before those and are not covered by the module
model. `.zshenv` runs for every zsh, `.zprofile` for zsh login shells and
`.profile` for POSIX login shells. They hold environment setup that must exist
before `.zshrc` or `.bashrc` runs, such as `PATH` for package managers and
toolchains. Read the files for their current contents rather than relying on
this description; each carries a comment on anything non-obvious.

The `shell-config` hook checks all five entry points (`.bashrc`, `.zshrc`,
`.zshenv`, `.zprofile`, `.profile`). Keep the login files to what must run
before `.zshrc` or `.bashrc`.

Each top-level directory is one tool or concern; `ls -d */` is the inventory.
Some modules are zsh-only, with no Bash pair.

## Shell conventions

- **Preserve the dynamic module loading model.** Do not add tool-specific
  initialisation directly to the entry points. The `shell-config` pre-commit
  hook rejects several direct PATH and version-manager initialisation
  patterns in them, and any absolute home directory path.
- **Tool installers edit the entry points.** Installers such as bun's append
  their own setup to `~/.zshrc` or `~/.bashrc`, which are symlinks into this
  repository, so the edit lands in the checkout. Move what is needed into a
  module and restore the entry point; the `shell-config` hook catches the
  absolute home path these blocks usually contain.
- Guard optional tool integrations with availability or directory checks, as
  existing modules do, and use the `platform` variable (`linux` or `macos`)
  both entry points establish. `platform_apple_silicon` is set by `.zshrc`
  only, so Bash modules cannot rely on it.
- **Bash and Zsh are deliberately separate implementations.** Never source a
  Bash module from Zsh or the reverse.
- Four-space indentation in shell modules. `shellcheck` and `shfmt` run on Bash
  files; `*.zsh` is intentionally excluded from both.
- Pre-commit also normalises whitespace and validates JSON and YAML. Markdown
  trailing whitespace is preserved, because it encodes hard line breaks.

## Platforms

- **macOS on Apple Silicon** is the primary platform, with Homebrew under
  `/opt/homebrew`.
- **macOS on Intel** is a legacy platform that may use MacPorts under
  `/opt/local` instead of Homebrew. Keep it working; do not add Intel-only
  paths such as `/usr/local/opt/...` without a guard.
- **Linux** is supported but not verified on a real machine at present. Keep
  its code paths guarded and working, and don't assume a change to them has
  been tested by anyone.

## What must never land here

Everything in this repository is public, in files as much as in commit
messages. Never commit:

- host, device or network names — machine hostnames, private network or VPN
  names, internal domains, IP addresses;
- employer or client names, including their GitHub organisations;
- the names of private repositories;
- absolute paths under a home directory;
- credentials, tokens, or anything copied from `~/.localrc` or another
  unversioned file.

Configuration that only one machine needs belongs outside the repository:
`~/.localrc` for shell settings and secrets, `~/.gitconfig` (which includes
this repository's `.gitconfig`) for Git, and `~/.ssh/config` for SSH. A
setting that would identify a machine or an employer is, by definition, one
machine's configuration.

## Two ignore files, and which one a rule belongs in

This repository contains both, and putting a rule in the wrong one is a mistake
that looks like it worked.

- **`.gitignore`** governs *this repository's own checkout*. It travels with
  every clone and fork.
- **`.gitignore_global`** is a dotfile this repository *ships*. `install.sh`
  symlinks it to `~/.gitignore_global` and, when no other
  `core.excludesfile` is configured, makes Git use it for repositories on that
  machine.

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
`style:`, optionally scoped. Most of the history follows it. Some recent
commits do not; that is drift, not a second convention, and new commits
should not copy it.

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

CI runs `.github/workflows/check.yml` on every pull request and push to
`master`: all pre-commit hooks, then `make check-startup`, on macOS and Ubuntu.
Run both locally before opening a pull request rather than waiting for CI to
report them. The Ubuntu job is the only place the Linux code paths run at all.

## Where work gets tracked

**GitHub issues on this repository.** Filing is Marko's decision, not a side
effect of finishing something: describe what you found and let him choose.
Never open one issue per pull request — the pull request already records what
changed and why.
